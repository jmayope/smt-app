import { ChangeDetectorRef, Component, OnInit } from '@angular/core';
import { BsModalRef } from 'ngx-bootstrap/modal';
import { Supabase } from '../../services/supabase';
import { Main } from '../../services/main';
import { firstValueFrom, Subject } from 'rxjs';
import { INCIDENTS, messageAlert } from '../../constants';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-new-incident',
  imports: [
    CommonModule,
    FormsModule
  ],
  templateUrl: './new-incident.html',
  styleUrl: './new-incident.css',
})
export class NewIncident implements OnInit {
  constructor(
    public modalRef: BsModalRef,
    private Supabase: Supabase,
    private Main: Main,
    private ChangeDetector: ChangeDetectorRef
  ) { }

  incident!: any;
  assignments: any[] = [];
  new_incident: any = {};
  inserting: boolean = false;
  public onClose: Subject<any> = new Subject<any>();

  incident_types: any[] = [
    { id: 'accident', name: 'Accidente' },
    { id: 'mechanical_failure', name: 'Falla mecánica' },
    { id: 'theft', name: 'Robo' },
    { id: 'delay', name: 'Retraso' },
    { id: 'weather', name: 'Clima' },
    { id: 'other', name: 'Otro' }
  ];

  severities: any[] = [
    { id: 'low', name: 'Baja' },
    { id: 'medium', name: 'Media' },
    { id: 'high', name: 'Alta' },
    { id: 'critical', name: 'Crítica' }
  ];

  user_loged: any;

  ngOnInit(): void {
    this.user_loged = this.Main.getSession();
    if (this.incident) {
      this.new_incident = structuredClone(this.incident);
      this.new_incident.editing = true;
      this.ChangeDetector.detectChanges();
    } else {
      this.new_incident = {
        severity: 'low',
        is_resolved: false,
        has_insurance_claim: false
      };
      this.ChangeDetector.detectChanges();
    }
  }

  async save() {
    if (this.inserting) {
      return;
    }
    this.inserting = true;

    if (this.new_incident.editing) {
      let result_update: any = await firstValueFrom(
        this.Supabase.update(INCIDENTS, this.new_incident.id, this.new_incident)
      );
      if (!result_update) {
        messageAlert("Error", "Hubo un problema al actualizar el incidente", "error");
        this.inserting = false;
        return;
      }
      messageAlert("Éxito", "Se actualizó correctamente el incidente", "success");
    } else {
      this.new_incident.company_id = this.user_loged.company_id;
      this.new_incident.reported_at = new Date().toISOString();
      let result_incident: any = await firstValueFrom(
        this.Supabase.insert(INCIDENTS, this.new_incident)
      );
      if (!result_incident) {
        messageAlert("Error", "Hubo un problema al insertar el incidente", "error");
        this.inserting = false;
        return;
      }
      messageAlert("Éxito", "Se guardó correctamente el incidente", "success");
    }

    this.onClose.next({
      registered: true
    });
    this.modalRef.hide();
  }
}
