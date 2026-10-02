import { ChangeDetectorRef, Component, OnInit } from '@angular/core';
import { Main } from '../../services/main';
import { Supabase } from '../../services/supabase';
import { BsModalRef, BsModalService } from 'ngx-bootstrap/modal';
import { firstValueFrom } from 'rxjs';
import { messageAlert, ROUTES, TRANSPORT_ASSIGNMENTS, USERS, VEHICLES } from '../../constants';
import { NewRoute } from '../../modals/new-route/new-route';
import Swal from 'sweetalert2';
import { NewTrip } from '../../modals/new-trip/new-trip';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-route',
  imports: [
    CommonModule,
    FormsModule
  ],
  templateUrl: './route.html',
  styleUrl: './route.css',
})
export class Route implements OnInit {
  constructor(
    private Main: Main,
    private Supabase: Supabase,
    private ChangeDetector: ChangeDetectorRef,
    private ModalService: BsModalService
  ) { }

  modalRef?: BsModalRef;

  routes: any[] = [];
  routes_filters: any = {};
  routes_totals: any = {};

  trips: any[] = [];
  vehicles: any[] = [];
  drivers: any[] = [];
  supervisors: any[] = [];
  trips_filters: any = {};
  trips_totals: any = {};

  status_labels: any = {
    pending: 'Pendiente',
    in_progress: 'En progreso',
    completed: 'Completado',
    cancelled: 'Cancelado',
    delayed: 'Retrasado'
  };

  user_loged: any;
  tabs: any[] = [
    {id: 'route', name: 'Rutas', icon: 'fa-route'},
    {id: 'trip', name: 'Viajes', icon: 'fa-truck-fast'},
  ];
  
  tabSelected: any;

  ngOnInit(): void {
    this.user_loged = this.Main.getSession();
    this.selectTab(this.tabs[0]);
    this.getRoutes();
    this.getTrips();
  }

  selectTab(tab: any) {
    this.tabSelected = tab;
    this.ChangeDetector.detectChanges();
  }

  async getRoutes() {
    this.routes = [];
    let result_routes: any = await firstValueFrom(
      this.Supabase.select(ROUTES, { filters: { company_id: this.user_loged.company_id } })
    );
    this.routes = result_routes;
    this.routes_totals.total = this.routes.length;
    this.routes_totals.priority = this.routes.filter((r: any) => r.is_priority).length;
    this.routes_totals.active = this.routes.filter((r: any) => r.is_active).length;
    this.ChangeDetector.detectChanges();
  }

  toggleRoute(route?: any) {
    this.modalRef = this.ModalService.show(NewRoute, { class: 'modal-nm' });

    if (this.modalRef && this.modalRef.content) {
      this.modalRef.content.route = structuredClone(route);
    }

    this.modalRef.content?.onClose.subscribe((data: any) => {
      if (data.registered) {
        this.getRoutes();
      }
    });
  }

  deleteRoute(route: any) {
    Swal.fire({
      icon: 'question',
      text: `¿Estás seguro de eliminar la ruta: "${route.name}"?`,
      allowOutsideClick: false,
      allowEscapeKey: false,
      showConfirmButton: true,
      showCancelButton: true
    }).then(async (choice) => {
      if (choice.isConfirmed) {
        let result_delete: any = await firstValueFrom(this.Supabase.delete(ROUTES, route.id));
        if (!result_delete) {
          messageAlert("Error", "Hubo un error al eliminar la ruta", "error");
          return;
        }
        messageAlert("Éxito", "Se eliminó la ruta", "success");
        this.getRoutes();
      }
    });
  }

  async getTrips() {
    this.trips = [];
    let result_trips: any = await firstValueFrom(
      this.Supabase.select(TRANSPORT_ASSIGNMENTS, { filters: { company_id: this.user_loged.company_id } })
    );
    this.trips = result_trips;
    this.trips_totals.total = this.trips.length;
    this.trips_totals.in_progress = this.trips.filter((t: any) => t.status === 'in_progress').length;
    this.trips_totals.delayed = this.trips.filter((t: any) => t.has_delayed).length;
    this.trips_totals.with_incident = this.trips.filter((t: any) => t.has_incident).length;
    this.getTripsRelations();
  }

  async getTripsRelations() {
    let result_vehicles: any = await firstValueFrom(
      this.Supabase.select(VEHICLES, { filters: { company_id: this.user_loged.company_id } })
    );
    this.vehicles = result_vehicles;

    let result_drivers: any = await firstValueFrom(
      this.Supabase.select(USERS, { filters: { company_id: this.user_loged.company_id, role: 'conductor' } })
    );
    this.drivers = result_drivers;

    let result_supervisors: any = await firstValueFrom(
      this.Supabase.select(USERS, { filters: { company_id: this.user_loged.company_id, role: 'supervisor' } })
    );
    this.supervisors = result_supervisors;

    this.trips.map((t: any) => {
      t.route = this.routes.find((r: any) => r.id === t.route_id);
      t.vehicle = this.vehicles.find((v: any) => v.id === t.vehicle_id);
      t.driver = this.drivers.find((d: any) => d.id === t.driver_id);
      t.supervisor = this.supervisors.find((s: any) => s.id === t.supervisor_id);
      t.status_label = this.status_labels[t.status] || t.status;
    });

    this.ChangeDetector.detectChanges();
  }

  toggleTrip(trip?: any) {
    this.modalRef = this.ModalService.show(NewTrip, { class: 'modal-nm' });

    if (this.modalRef && this.modalRef.content) {
      this.modalRef.content.trip = structuredClone(trip);
    }

    this.modalRef.content?.onClose.subscribe((data: any) => {
      if (data.registered) {
        this.getTrips();
      }
    });
  }

  deleteTrip(trip: any) {
    Swal.fire({
      icon: 'question',
      text: `¿Estás seguro de cancelar este viaje?`,
      allowOutsideClick: false,
      allowEscapeKey: false,
      showConfirmButton: true,
      showCancelButton: true
    }).then(async (choice) => {
      if (choice.isConfirmed) {
        let result_delete: any = await firstValueFrom(this.Supabase.delete(TRANSPORT_ASSIGNMENTS, trip.id));
        if (!result_delete) {
          messageAlert("Error", "Hubo un error al eliminar el viaje", "error");
          return;
        }
        messageAlert("Éxito", "Se eliminó el viaje", "success");
        this.getTrips();
      }
    });
  }
}
