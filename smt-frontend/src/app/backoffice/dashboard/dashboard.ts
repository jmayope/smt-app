import { ChangeDetectorRef, Component, OnInit } from '@angular/core';
import { Main } from '../../services/main';
import { Supabase } from '../../services/supabase';
import { COMPANY_SUBSCRIPTIONS, DAILY_REPORTS, INCIDENTS, messageAlert, ROUTES, SUBSCRIPTION_PACKAGES, TRANSPORT_ASSIGNMENTS, USERS, VEHICLE_DOCUMENTS, VEHICLES } from '../../constants';
import { firstValueFrom } from 'rxjs';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-dashboard',
  imports: [
    CommonModule,
    FormsModule
  ],
  templateUrl: './dashboard.html',
  styleUrl: './dashboard.css',
})
export class Dashboard implements OnInit {

  constructor(
    private Main: Main,
    private Supabase: Supabase,
    private ChangeDetector: ChangeDetectorRef
  ) { }

  loading: boolean = false;
  loaded: boolean = false;
  refresh_interval: any;
  today: string = '';

  // ---- Datos crudos ----
  users: any[] = [];
  vehicles: any[] = [];
  routes: any[] = [];
  trips_today: any[] = [];
  unresolved_incidents: any[] = [];
  recent_incidents: any[] = [];
  recent_assignments: any[] = [];
  daily_reports: any[] = [];
  documents: any[] = [];
  subscription: any = null;
  subscription_package: any = null;

  // ---- Datos calculados para el template ----
  totals: any = {};
  trip_status: any = {};
  chart_days: any[] = [];
  documents_alert: any[] = [];
  plan_usage: any = {};

  day_labels: string[] = ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'];

  status_labels: any = {
    pending: 'Pendiente',
    in_progress: 'En progreso',
    completed: 'Completado',
    cancelled: 'Cancelado',
    delayed: 'Retrasado'
  };

  incident_type_labels: any = {
    accident: 'Accidente',
    mechanical_failure: 'Falla mecánica',
    theft: 'Robo',
    delay: 'Retraso',
    weather: 'Clima',
    other: 'Otro'
  };

  severity_labels: any = {
    low: 'Baja',
    medium: 'Media',
    high: 'Alta',
    critical: 'Crítica'
  };
  user_loged: any;

  ngOnInit(): void {
    this.user_loged = this.Main.getSession();
    this.loadDashboard();
    // Refresco automático cada 60 segundos (sin alertas si falla)
    this.refresh_interval = setInterval(() => this.loadDashboard(true), 60000);
  }

  ngOnDestroy(): void {
    if (this.refresh_interval) {
      clearInterval(this.refresh_interval);
    }
  }

  // ==================================================================
  // CARGA GENERAL
  // ==================================================================
  async loadDashboard(silent: boolean = false) {
    if (this.loading) {
      return;
    }
    this.loading = true;
    this.today = this.getLocalDate();

    try {
      await Promise.all([
        this.getUsers(),
        this.getVehicles(),
        this.getRoutes(),
        this.getTripsToday(),
        this.getIncidents(),
        this.getDailyReports(),
        this.getSubscription()
      ]);
      await this.getVehicleDocuments(); // depende de this.vehicles
      this.buildSummary();
    } catch (error) {
      console.error('Error cargando dashboard:', error);
      if (!silent) {
        messageAlert("Error", "Hubo un problema al cargar el dashboard", "error");
      }
    } finally {
      this.loading = false;
      this.loaded = true;
      this.ChangeDetector.detectChanges();
    }
  }

  refresh() {
    this.loadDashboard();
  }

  // ==================================================================
  // CONSULTAS
  // ==================================================================
  async getUsers() {
    let result: any = await firstValueFrom(
      this.Supabase.select(USERS, { filters: { company_id: this.user_loged.company_id } })
    );
    this.users = result || [];
  }

  async getVehicles() {
    let result: any = await firstValueFrom(
      this.Supabase.select(VEHICLES, { filters: { company_id: this.user_loged.company_id } })
    );
    this.vehicles = result || [];
  }

  async getRoutes() {
    let result: any = await firstValueFrom(
      this.Supabase.select(ROUTES, { filters: { company_id: this.user_loged.company_id } })
    );
    this.routes = result || [];
  }

  async getTripsToday() {
    let result: any = await firstValueFrom(
      this.Supabase.select(TRANSPORT_ASSIGNMENTS, {
        filters: {
          company_id: this.user_loged.company_id,
          assignment_date: this.today
        }
      })
    );
    this.trips_today = result || [];
  }

  async getIncidents() {
    let [result_unresolved, result_recent]: any = await Promise.all([
      firstValueFrom(
        this.Supabase.select(INCIDENTS, {
          filters: { company_id: this.user_loged.company_id, is_resolved: false }
        })
      ),
      firstValueFrom(
        this.Supabase.select(INCIDENTS, {
          filters: { company_id: this.user_loged.company_id },
          order: { column: 'reported_at', direction: 'desc' },
          limit: 5
        })
      )
    ]);

    this.unresolved_incidents = result_unresolved || [];
    this.recent_incidents = result_recent || [];

    // Asignaciones de los incidentes recientes (para mostrar ruta y vehículo)
    let assignment_ids = this.recent_incidents
      .map((i: any) => i.assignment_id)
      .filter((id: any) => !!id);

    if (assignment_ids.length) {
      let result_assignments: any = await firstValueFrom(
        this.Supabase.select(TRANSPORT_ASSIGNMENTS, { filters: { id: assignment_ids } })
      );
      this.recent_assignments = result_assignments || [];
    } else {
      this.recent_assignments = [];
    }
  }

  async getDailyReports() {
    let result: any = await firstValueFrom(
      this.Supabase.select(DAILY_REPORTS, {
        filters: { company_id: this.user_loged.company_id },
        order: { column: 'report_date', direction: 'desc' },
        limit: 7
      })
    );
    this.daily_reports = result || [];
  }

  async getVehicleDocuments() {
    let vehicle_ids = this.vehicles.map((v: any) => v.id);
    if (!vehicle_ids.length) {
      this.documents = [];
      return;
    }
    let result: any = await firstValueFrom(
      this.Supabase.select(VEHICLE_DOCUMENTS, { filters: { vehicle_id: vehicle_ids } })
    );
    this.documents = result || [];
  }

  async getSubscription() {
    let result_subscription: any = await firstValueFrom(
      this.Supabase.select(COMPANY_SUBSCRIPTIONS, {
        filters: { company_id: this.user_loged.company_id, is_active: true },
        order: { column: 'start_date', direction: 'desc' },
        limit: 1
      })
    );
    this.subscription = (result_subscription && result_subscription.length) ? result_subscription[0] : null;
    this.subscription_package = null;

    if (this.subscription) {
      let result_package: any = await firstValueFrom(
        this.Supabase.select(SUBSCRIPTION_PACKAGES, { filters: { id: this.subscription.package_id } })
      );
      this.subscription_package = (result_package && result_package.length) ? result_package[0] : null;
    }
  }

  // ==================================================================
  // CÁLCULOS PARA EL TEMPLATE
  // ==================================================================
  buildSummary() {
    this.buildFleetAndDrivers();
    this.buildTripsSummary();
    this.buildIncidentsSummary();
    this.buildDocumentsAlert();
    this.buildChart();
    this.buildPlanUsage();
  }

  buildFleetAndDrivers() {
    let in_route_vehicle_ids = new Set(
      this.trips_today.filter((t: any) => t.status === 'in_progress').map((t: any) => t.vehicle_id)
    );
    let in_route_driver_ids = new Set(
      this.trips_today.filter((t: any) => t.status === 'in_progress').map((t: any) => t.driver_id)
    );

    // Vehículos
    this.totals.vehicles_total = this.vehicles.length;
    this.totals.vehicles_in_route = this.vehicles.filter((v: any) => in_route_vehicle_ids.has(v.id)).length;
    this.totals.vehicles_maintenance = this.vehicles.filter((v: any) => v.has_maintenance_scheduled).length;
    this.totals.vehicles_available = this.vehicles.filter((v: any) =>
      v.is_active && v.is_available && !v.has_maintenance_scheduled && !in_route_vehicle_ids.has(v.id)
    ).length;

    // Conductores
    let active_drivers = this.users.filter((u: any) => u.role === 'conductor' && u.is_active);
    this.totals.drivers_active = active_drivers.length;
    this.totals.drivers_in_route = active_drivers.filter((d: any) => in_route_driver_ids.has(d.id)).length;
    this.totals.drivers_available = this.totals.drivers_active - this.totals.drivers_in_route;

    // Rutas
    this.totals.routes_total = this.routes.length;
    this.totals.routes_priority = this.routes.filter((r: any) => r.is_priority && r.is_active).length;
  }

  buildTripsSummary() {
    let total = this.trips_today.length;
    let count = (status: string) => this.trips_today.filter((t: any) => t.status === status).length;
    let pct = (n: number) => total ? Math.round((n / total) * 100) : 0;

    this.totals.trips_today = total;
    this.totals.trips_in_progress = count('in_progress');
    this.totals.trips_completed = count('completed');
    this.totals.trips_pending = count('pending');
    this.totals.trips_cancelled = count('cancelled');
    this.totals.trips_delayed = this.trips_today.filter((t: any) => t.has_delayed || t.status === 'delayed').length;
    this.totals.load_today = this.trips_today.reduce((acc: number, t: any) => acc + (Number(t.load_weight_tons) || 0), 0);

    this.trip_status = {
      completed_pct: pct(this.totals.trips_completed),
      in_progress_pct: pct(this.totals.trips_in_progress),
      pending_pct: pct(this.totals.trips_pending),
      delayed_pct: pct(this.totals.trips_delayed),
      cancelled_pct: pct(this.totals.trips_cancelled)
    };

    // Tabla de "Viajes de hoy": en progreso y retrasados primero
    let order: any = { in_progress: 0, delayed: 1, pending: 2, completed: 3, cancelled: 4 };

    this.trips_today.map((t: any) => {
      t.route = this.routes.find((r: any) => r.id === t.route_id);
      t.vehicle = this.vehicles.find((v: any) => v.id === t.vehicle_id);
      t.driver = this.users.find((u: any) => u.id === t.driver_id);
      t.status_label = this.status_labels[t.status] || t.status;
      t.badge_class = this.statusBadge(t.status);
    });

    this.trips_today.sort((a: any, b: any) => (order[a.status] ?? 9) - (order[b.status] ?? 9));
  }

  buildIncidentsSummary() {
    this.totals.incidents_unresolved = this.unresolved_incidents.length;
    this.totals.incidents_critical = this.unresolved_incidents.filter((i: any) =>
      i.severity === 'critical' || i.severity === 'high'
    ).length;

    this.recent_incidents.map((i: any) => {
      i.assignment = this.recent_assignments.find((a: any) => a.id === i.assignment_id);
      i.route = this.routes.find((r: any) => r.id === i.assignment?.route_id);
      i.vehicle = this.vehicles.find((v: any) => v.id === i.assignment?.vehicle_id);
      i.incident_type_label = this.incident_type_labels[i.incident_type] || i.incident_type;
      i.severity_label = this.severity_labels[i.severity] || i.severity;
      i.badge_class = this.severityBadge(i.severity);
    });
  }

  buildDocumentsAlert() {
    let today_date = this.parseLocalDate(this.today);

    this.documents.map((d: any) => {
      d.days_left = d.expiry_date
        ? Math.ceil((this.parseLocalDate(d.expiry_date).getTime() - today_date.getTime()) / 86400000)
        : null;
      d.vehicle = this.vehicles.find((v: any) => v.id === d.vehicle_id);
    });

    let with_expiry = this.documents.filter((d: any) => d.days_left !== null);

    this.totals.documents_expired = with_expiry.filter((d: any) => d.days_left < 0).length;
    this.totals.documents_expiring = with_expiry.filter((d: any) => d.days_left >= 0 && d.days_left <= 30).length;

    // Los 5 más urgentes (vencidos o por vencer en 30 días)
    this.documents_alert = with_expiry
      .filter((d: any) => d.days_left <= 30)
      .sort((a: any, b: any) => a.days_left - b.days_left)
      .slice(0, 5);
  }

  buildChart() {
    // daily_reports viene desc; lo invertimos para mostrarlo cronológicamente
    let last_7 = [...this.daily_reports].reverse();
    let max_value = Math.max(...last_7.map((r: any) => r.completed_assignments || 0), 1);

    this.chart_days = last_7.map((r: any) => ({
      date: r.report_date,
      label: this.day_labels[this.parseLocalDate(r.report_date).getDay()],
      completed: r.completed_assignments || 0,
      delayed: r.delayed_assignments || 0,
      height_pct: Math.round(((r.completed_assignments || 0) / max_value) * 100)
    }));

    this.totals.week_completed = last_7.reduce((acc: number, r: any) => acc + (r.completed_assignments || 0), 0);
    this.totals.week_distance = last_7.reduce((acc: number, r: any) => acc + (Number(r.total_distance_km) || 0), 0);
    this.totals.week_load = last_7.reduce((acc: number, r: any) => acc + (Number(r.total_load_tons) || 0), 0);
  }

  buildPlanUsage() {
    if (!this.subscription || !this.subscription_package) {
      this.plan_usage = null;
      return;
    }

    let users_used = this.users.filter((u: any) => u.is_active).length;
    let vehicles_used = this.vehicles.length;
    let max_users = this.subscription_package.max_users;
    let max_vehicles = this.subscription_package.max_vehicles;

    let pct = (used: number, max: number) => max ? Math.min(100, Math.round((used / max) * 100)) : 0;
    let bar = (value: number) => value >= 90 ? 'bg-danger' : (value >= 70 ? 'bg-warning' : 'bg-primary');

    let days_left = this.subscription.end_date
      ? Math.ceil((this.parseLocalDate(this.subscription.end_date).getTime() - this.parseLocalDate(this.today).getTime()) / 86400000)
      : null;

    this.plan_usage = {
      name: this.subscription_package.name,
      is_trial: this.subscription.is_trial,
      end_date: this.subscription.end_date,
      days_left,
      users_used,
      max_users,
      users_pct: pct(users_used, max_users),
      users_bar: bar(pct(users_used, max_users)),
      vehicles_used,
      max_vehicles,
      vehicles_pct: pct(vehicles_used, max_vehicles),
      vehicles_bar: bar(pct(vehicles_used, max_vehicles))
    };
  }

  // ==================================================================
  // HELPERS (clases Bootstrap para los badges, sin CSS propio)
  // ==================================================================
  statusBadge(status: string): string {
    switch (status) {
      case 'in_progress': return 'text-bg-success';
      case 'completed': return 'text-bg-primary';
      case 'delayed': return 'text-bg-warning';
      case 'cancelled': return 'text-bg-danger';
      default: return 'text-bg-secondary';
    }
  }

  severityBadge(severity: string): string {
    switch (severity) {
      case 'critical': return 'text-bg-danger';
      case 'high': return 'text-bg-danger';
      case 'medium': return 'text-bg-warning';
      default: return 'text-bg-light border';
    }
  }

  // Fecha local en formato YYYY-MM-DD (toISOString usaría UTC y en Perú
  // devolvería "mañana" a partir de las 19:00)
  private getLocalDate(): string {
    let d = new Date();
    return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
  }

  // Parsea 'YYYY-MM-DD' (o timestamp ISO) como fecha local a medianoche
  private parseLocalDate(value: string): Date {
    return new Date(value.slice(0, 10) + 'T00:00:00');
  }
}
