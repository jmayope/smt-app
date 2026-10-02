import { ChangeDetectorRef, Component, OnInit } from '@angular/core';
import { Main } from '../../services/main';
import { Supabase } from '../../services/supabase';
import { BsModalRef, BsModalService } from 'ngx-bootstrap/modal';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { firstValueFrom } from 'rxjs';
import { INCIDENTS, messageAlert, ROUTES, TRANSPORT_ASSIGNMENTS, USERS, VEHICLES } from '../../constants';
import { NewIncident } from '../../modals/new-incident/new-incident';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-incident',
  imports: [
    CommonModule,
    FormsModule
  ],
  templateUrl: './incident.html',
  styleUrl: './incident.css',
})
export class Incident implements OnInit {
  constructor(
    private Main: Main,
    private Supabase: Supabase,
    private ChangeDetector: ChangeDetectorRef,
    private ModalService: BsModalService
  ) { }

  modalRef?: BsModalRef;

  incidents: any[] = [];
  assignments: any[] = [];
  routes: any[] = [];
  vehicles: any[] = [];
  drivers: any[] = [];

  filters: any = {};
  totals: any = {};

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
    this.getIncidents();
  }

  async getIncidents() {
    this.incidents = [];
    let result_incidents: any = await firstValueFrom(
      this.Supabase.select(INCIDENTS, { filters: { company_id: this.user_loged.company_id } })
    );
    this.incidents = result_incidents;

    this.totals.total = this.incidents.length;
    this.totals.unresolved = this.incidents.filter((i: any) => !i.is_resolved).length;
    this.totals.resolved = this.incidents.filter((i: any) => i.is_resolved).length;
    this.totals.with_claim = this.incidents.filter((i: any) => i.has_insurance_claim).length;

    this.getRelations();
  }

  async getRelations() {
    let result_assignments: any = await firstValueFrom(
      this.Supabase.select(TRANSPORT_ASSIGNMENTS, {
        filters: { id: this.incidents.map((i: any) => i.assignment_id) }
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

    let result_drivers: any = await firstValueFrom(
      this.Supabase.select(USERS, { filters: { id: this.assignments.map((a: any) => a.driver_id) } })
    );
    this.drivers = result_drivers;

    this.incidents.map((i: any) => {
      i.assignment = this.assignments.find((a: any) => a.id === i.assignment_id);
      if (i.assignment) {
        i.assignment.route = this.routes.find((r: any) => r.id === i.assignment.route_id);
        i.assignment.vehicle = this.vehicles.find((v: any) => v.id === i.assignment.vehicle_id);
        i.assignment.driver = this.drivers.find((d: any) => d.id === i.assignment.driver_id);
      }
      i.incident_type_label = this.incident_type_labels[i.incident_type] || i.incident_type;
      i.severity_label = this.severity_labels[i.severity] || i.severity;
    });

    this.ChangeDetector.detectChanges();
  }

  toggleIncident(incident?: any) {
    this.modalRef = this.ModalService.show(NewIncident, { class: 'modal-nm' });

    if (this.modalRef && this.modalRef.content) {
      this.modalRef.content.incident = structuredClone(incident);
      this.modalRef.content.assignments = this.assignments;
    }

    this.modalRef.content?.onClose.subscribe((data: any) => {
      if (data.registered) {
        this.getIncidents();
      }
    });
  }

  resolveIncident(incident: any) {
    Swal.fire({
      icon: 'question',
      text: `¿Marcar este incidente como resuelto?`,
      allowOutsideClick: false,
      allowEscapeKey: false,
      showConfirmButton: true,
      showCancelButton: true
    }).then(async (choice) => {
      if (choice.isConfirmed) {
        let result_update: any = await firstValueFrom(
          this.Supabase.update(INCIDENTS, incident.id, {
            is_resolved: true,
            resolved_at: new Date().toISOString()
          })
        );
        if (!result_update) {
          messageAlert("Error", "Hubo un error al resolver el incidente", "error");
          return;
        }
        messageAlert("Éxito", "Se marcó el incidente como resuelto", "success");
        this.getIncidents();
      }
    });
  }

  deleteItem(incident: any) {
    Swal.fire({
      icon: 'question',
      text: `¿Estás seguro de eliminar este incidente?`,
      allowOutsideClick: false,
      allowEscapeKey: false,
      showConfirmButton: true,
      showCancelButton: true
    }).then(async (choice) => {
      if (choice.isConfirmed) {
        let result_delete: any = await firstValueFrom(this.Supabase.delete(INCIDENTS, incident.id));
        if (!result_delete) {
          messageAlert("Error", "Hubo un error al eliminar el incidente", "error");
          return;
        }
        messageAlert("Éxito", "Se eliminó el incidente", "success");
        this.getIncidents();
      }
    });
  }
}
