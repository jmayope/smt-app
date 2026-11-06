import { ChangeDetectorRef, Component, OnInit } from '@angular/core';
import { BsModalRef } from 'ngx-bootstrap/modal';
import { Supabase } from '../../services/supabase';
import { Main } from '../../services/main';
import { firstValueFrom, Subject } from 'rxjs';
import { loadingAlert, messageAlert, ROUTE_POINTS, ROUTES, timeToDatetime, TRANSPORT_ASSIGNMENTS, USERS, VEHICLES } from '../../constants';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import moment from 'moment';

@Component({
  selector: 'app-new-trip',
  imports: [
    CommonModule,
    FormsModule
  ],
  templateUrl: './new-trip.html',
  styleUrl: './new-trip.css',
})
export class NewTrip implements OnInit {

  constructor(
    public modalRef: BsModalRef,
    private Supabase: Supabase,
    private Main: Main,
    private ChangeDetector: ChangeDetectorRef
  ) { }

  trip!: any;
  new_trip: any = {};
  inserting: boolean = false;
  public onClose: Subject<any> = new Subject<any>();

  routes: any[] = [];
  vehicles: any[] = [];
  drivers: any[] = [];
  supervisors: any[] = [];

  status_options: any[] = [
    { id: 'pending', name: 'Pendiente' },
    { id: 'in_progress', name: 'En progreso' },
    { id: 'completed', name: 'Completado' },
    { id: 'cancelled', name: 'Cancelado' },
    { id: 'delayed', name: 'Retrasado' }
  ];

  user_loged: any;
  current_date: any;

  ngOnInit(): void {
    this.user_loged = this.Main.getSession();
    if (this.trip) {
      this.new_trip = structuredClone(this.trip);
      this.new_trip.editing = true;
      this.ChangeDetector.detectChanges();
    } else {
      this.new_trip = {
        company_id: this.user_loged.currentCompany.id,
        status: 'pending',
        material_type: 'oro'
      };
      this.ChangeDetector.detectChanges();
    }
    this.current_date = moment().format('YYYY-MM-DD');
    console.log(this.current_date);
    this.getRelations();
  }

  async getRelations() {
    let result_routes: any = await firstValueFrom(
      this.Supabase.select(ROUTES, { filters: { company_id: this.user_loged.company_id, is_active: true } })
    );
    this.routes = result_routes;
    let result_route_points: any = await firstValueFrom(
      this.Supabase.select(ROUTE_POINTS, { filters: {route_id: [...new Set(this.routes.map((r: any) => r.id))]}})
    );
    this.routes.map((r: any) => {
      r.points = result_route_points.filter((rp: any) => rp.route_id === r.id);
    });
    
    let result_vehicles: any = await firstValueFrom(
      this.Supabase.select(VEHICLES, { filters: { company_id: this.user_loged.company_id, is_active: true, is_available: true } })
    );
    this.vehicles = result_vehicles;
    let result_drivers: any = await firstValueFrom(
      this.Supabase.select(USERS, { filters: { company_id: this.user_loged.company_id, role: 'conductor', is_active: true } })
    );
    this.drivers = result_drivers;

    let result_supervisors: any = await firstValueFrom(
      this.Supabase.select(USERS, { filters: { company_id: this.user_loged.company_id, role: 'supervisor', is_active: true } })
    );
    this.supervisors = result_supervisors;

    this.ChangeDetector.detectChanges();
  }

  async save() {
    if (this.inserting) {
      return;
    }
    this.inserting = true;

    if (this.new_trip.editing) {
      let result_update: any = await firstValueFrom(
        this.Supabase.update(TRANSPORT_ASSIGNMENTS, this.new_trip.id, this.new_trip)
      );
      if (!result_update) {
        messageAlert("Error", "Hubo un problema al actualizar el viaje", "error");
        this.inserting = false;
        return;
      }
      messageAlert("Éxito", "Se actualizó correctamente el viaje", "success");
    } else {
      this.new_trip.company_id = this.user_loged.currentCompany.id;
      let new_trip: any = structuredClone(this.new_trip);
      new_trip.estimated_start_time = timeToDatetime(new_trip.estimated_start_time);
      new_trip.estimated_end_time = timeToDatetime(new_trip.estimated_end_time);
      let result_trip: any = await firstValueFrom(
        this.Supabase.insert(TRANSPORT_ASSIGNMENTS, new_trip)
      );
      if (!result_trip) {
        messageAlert("Error", "Hubo un problema al insertar el viaje", "error");
        this.inserting = false;
        return;
      }
      // Actualizar estado de vehiculo de disponible a falso.

      let result_update_vehicle: any = await firstValueFrom(this.Supabase.update(VEHICLES, this.new_trip.vehicle_id, {is_available: false}));
      if (!result_update_vehicle.length) {
        messageAlert("Error", "Hubo un error al actualizar el estado del vehiculo", "error");
        this.inserting = false;
        return;
      }

      messageAlert("Éxito", "Se guardó correctamente el viaje", "success");
    }

    this.onClose.next({
      registered: true
    });
    this.modalRef.hide();
  }
}
