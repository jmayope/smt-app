import { ChangeDetectorRef, Component } from '@angular/core';
import { Main } from '../../services/main';
import { Supabase } from '../../services/supabase';
import { BsModalRef, BsModalService } from 'ngx-bootstrap/modal';
import { firstValueFrom } from 'rxjs';
import { messageAlert, ROUTES, TRANSPORT_ASSIGNMENTS, USERS, VEHICLES } from '../../constants';
import Swal from 'sweetalert2';
import { NewDriver } from '../../modals/new-driver/new-driver';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-driver',
  imports: [
    CommonModule,
    FormsModule
  ],
  templateUrl: './driver.html',
  styleUrl: './driver.css',
})
export class Driver {

  constructor(
    private Main: Main,
    private Supabase: Supabase,
    private ChangeDetector: ChangeDetectorRef,
    private ModalService: BsModalService
  ) { }

  modalRef?: BsModalRef;

  drivers: any[] = [];
  assignments: any[] = [];
  routes: any[] = [];
  vehicles: any[] = [];

  filters: any = {};
  totals: any = {};
  user_loged: any;

  ngOnInit(): void {
    this.user_loged = this.Main.getSession();
    this.getDrivers();
  }

  async getDrivers() {
    this.drivers = [];
    let result_drivers: any = await firstValueFrom(
      this.Supabase.select(USERS, { filters: { company_id: this.user_loged.company_id, role: 'conductor' } })
    );
    this.drivers = result_drivers;
    this.totals.total = this.drivers.length;
    this.totals.active = this.drivers.filter((d: any) => d.is_active).length;
    this.totals.with_2fa = this.drivers.filter((d: any) => d.has_2fa).length;
    this.totals.inactive = this.drivers.filter((d: any) => !d.is_active).length;
    this.getActiveAssignments();
  }

  async getActiveAssignments() {
    let today = new Date().toISOString().slice(0, 10);

    let result_assignments: any = await firstValueFrom(
      this.Supabase.select(TRANSPORT_ASSIGNMENTS, {
        filters: {
          driver_id: this.drivers.map((d: any) => d.id),
          assignment_date: today
        }
      })
    );
    this.assignments = result_assignments;

    let result_routes: any = await firstValueFrom(
      this.Supabase.select(ROUTES, { filters: { id: this.assignments.map((a: any) => a.route_id) } })
    );
    this.routes = result_routes;

    let result_vehicles: any = await firstValueFrom(
      this.Supabase.select(VEHICLES, { filters: { id: this.assignments.map((a: any) => a.vehicle_id) } })
    );
    this.vehicles = result_vehicles;

    this.drivers.map((d: any) => {
      d.current_assignment = this.assignments.find((a: any) =>
        a.driver_id === d.id && (a.status === 'in_progress' || a.status === 'pending')
      );
      if (d.current_assignment) {
        d.current_assignment.route = this.routes.find((r: any) => r.id === d.current_assignment.route_id);
        d.current_assignment.vehicle = this.vehicles.find((v: any) => v.id === d.current_assignment.vehicle_id);
      }
    });

    this.ChangeDetector.detectChanges();
  }

  toggleDriver(driver?: any) {
    this.modalRef = this.ModalService.show(NewDriver, { class: 'modal-nm' });

    if (this.modalRef && this.modalRef.content) {
      this.modalRef.content.driver = structuredClone(driver);
    }

    this.modalRef.content?.onClose.subscribe((data: any) => {
      if (data.registered) {
        this.getDrivers();
      }
    });
  }

  deleteItem(driver: any) {
    Swal.fire({
      icon: 'question',
      text: `¿Estás seguro de eliminar al conductor: "${driver.first_name} ${driver.last_name}"?`,
      allowOutsideClick: false,
      allowEscapeKey: false,
      showConfirmButton: true,
      showCancelButton: true
    }).then(async (choice) => {
      if (choice.isConfirmed) {
        let result_delete: any = await firstValueFrom(this.Supabase.delete(USERS, driver.id));
        if (!result_delete) {
          messageAlert("Error", "Hubo un error al eliminar el conductor", "error");
          return;
        }
        messageAlert("Éxito", "Se eliminó el conductor", "success");
        this.getDrivers();
      }
    });
  }

}
