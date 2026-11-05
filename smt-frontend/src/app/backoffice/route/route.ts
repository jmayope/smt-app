import { ChangeDetectorRef, Component, OnInit } from '@angular/core';
import { Main } from '../../services/main';
import { Supabase } from '../../services/supabase';
import { BsModalRef, BsModalService } from 'ngx-bootstrap/modal';
import { firstValueFrom } from 'rxjs';
import { messageAlert, ROUTE_POINTS, ROUTE_SEGMENTS, ROUTES, TRANSPORT_ASSIGNMENTS, USERS, VEHICLES } from '../../constants';
import { NewRoute } from '../../modals/new-route/new-route';
import Swal from 'sweetalert2';
import { NewTrip } from '../../modals/new-trip/new-trip';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { BsDropdownModule } from 'ngx-bootstrap/dropdown';
import { Router } from '@angular/router';

@Component({
  selector: 'app-route',
  imports: [
    CommonModule,
    FormsModule,
    BsDropdownModule
  ],
  templateUrl: './route.html',
  styleUrl: './route.css',
})
export class Route implements OnInit {
  constructor(
    private Main: Main,
    private Supabase: Supabase,
    private ChangeDetector: ChangeDetectorRef,
    private ModalService: BsModalService,
    private Router: Router
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
    let filters: any = {};
    if (this.user_loged.currentCompany) {
      filters.company_id = this.user_loged.currentCompany.id;
    }
    let result_routes: any = await firstValueFrom(
      this.Supabase.select(ROUTES, { filters: filters })
    );
    this.routes = result_routes;
    this.routes_totals.total = this.routes.length;
    this.routes_totals.priority = this.routes.filter((r: any) => r.is_priority).length;
    this.routes_totals.active = this.routes.filter((r: any) => r.is_active).length;
    this.routes_totals.avg = this.routes.length == 0 ? 0 : parseFloat((this.routes.reduce((m: number, i: any) => { return m + i.distance_km}, 0) / this.routes.length).toFixed(2));
    this.getRoutePoints();
  }
  
  async getRoutePoints() {
    let resultRoutePoints: any = await firstValueFrom(this.Supabase.select(ROUTE_POINTS, {filters: {route_id: this.routes.map((r: any) => r.id)}}));
    let resultRouteSegments: any = await firstValueFrom(this.Supabase.select(ROUTE_SEGMENTS, {filters: {route_id: this.routes.map((r: any) => r.id)}}));
    console.log(resultRoutePoints);
    this.routes.map((r: any) => {
      r.points = resultRoutePoints.filter((p: any) => p.route_id === r.id);
      r.segments = resultRouteSegments.filter((p: any) => p.route_id === r.id);
    });
    this.routes_totals.totals_points = resultRoutePoints.length;
    console.log(this.routes);
    this.ChangeDetector.detectChanges();
  }

  toggleRoute(route?: any) {
    let route_id = '0';
    if (route) {
      route_id = route.id;
    }
    this.Router.navigate(['backoffice/ruta', route_id]);
    // this.modalRef = this.ModalService.show(NewRoute, { class: 'modal-nm' });

    // if (this.modalRef && this.modalRef.content) {
    //   this.modalRef.content.route = structuredClone(route);
    // }

    // this.modalRef.content?.onClose.subscribe((data: any) => {
    //   if (data.registered) {
    //     this.getRoutes();
    //   }
    // });
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
    let filters: any = {status: 'completed'};
    if (this.user_loged.currentCompany) {
      filters.company_id = this.user_loged.currentCompany.id;
    }
    let result_trips: any = await firstValueFrom(
      this.Supabase.select(TRANSPORT_ASSIGNMENTS, { filters: filters })
    );
    this.trips = result_trips;
    console.log(this.trips);
    this.trips_totals.total = this.trips.length;
    this.trips_totals.in_progress = this.trips.filter((t: any) => t.status === 'in_progress').length;
    this.trips_totals.delayed = this.trips.filter((t: any) => t.has_delayed).length;
    this.trips_totals.with_incident = this.trips.filter((t: any) => t.has_incident).length;
    this.getTripsRelations();
  }

  async getTripsRelations() {
    let filters: any = {};
    if (this.user_loged.currentCompany) {
      filters.company_id = this.user_loged.currentCompany.id;
    }
    let result_vehicles: any = await firstValueFrom(
      this.Supabase.select(VEHICLES, { filters: {} })
    );
    this.vehicles = result_vehicles;

    let result_drivers: any = await firstValueFrom(
      this.Supabase.select(USERS, { filters: { role: 'conductor' } })
    );
    this.drivers = result_drivers;

    let result_supervisors: any = await firstValueFrom(
      this.Supabase.select(USERS, { filters: { company_id: this.user_loged.currentCompany.id, role: 'supervisor' } })
    );
    this.supervisors = result_supervisors;

    let result_routes: any = await firstValueFrom(this.Supabase.select(ROUTES, {filters: {id: this.trips.map((t: any) => t.route_id)}}));
    console.log(result_routes);

    this.trips.map((t: any) => {
      t.route = result_routes.find((r: any) => r.id === t.route_id);
      t.vehicle = this.vehicles.find((v: any) => v.id === t.vehicle_id);
      t.driver = this.drivers.find((d: any) => d.id === t.driver_id);
      t.supervisor = this.supervisors.find((s: any) => s.id === t.supervisor_id);
      t.status_label = this.status_labels[t.status] || t.status;
    });
    console.log(this.trips);

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
