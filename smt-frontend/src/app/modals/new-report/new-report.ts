import { ChangeDetectorRef, Component, OnInit } from '@angular/core';
import { BsModalRef } from 'ngx-bootstrap/modal';
import { Supabase } from '../../services/supabase';
import { Main } from '../../services/main';
import { firstValueFrom, Subject } from 'rxjs';
import { messageAlert } from '../../constants';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-new-report',
  imports: [CommonModule, FormsModule],
  templateUrl: './new-report.html',
  styleUrl: './new-report.css',
})
export class NewReport implements OnInit {
  constructor(
    public modalRef: BsModalRef,
    private Supabase: Supabase,
    private Main: Main,
    private ChangeDetector: ChangeDetectorRef
  ) { }

  new_report: any = {
    type: 'trips',
    format: 'pdf'
  };
  generating: boolean = false;
  public onClose: Subject<any> = new Subject<any>();

  report_types: any[] = [
    { id: 'trips', name: 'Viajes y asignaciones' },
    { id: 'vehicles', name: 'Uso de vehículos' },
    { id: 'incidents', name: 'Incidentes' },
    { id: 'drivers', name: 'Conductores' }
  ];

  formats: any[] = [
    { id: 'pdf', name: 'PDF' },
    { id: 'xlsx', name: 'Excel (.xlsx)' },
    { id: 'csv', name: 'CSV' }
  ];

  user_loged: any;
  ngOnInit(): void {
    this.user_loged = this.Main.getSession();
  }

  async generate() {
    if (this.generating) {
      return;
    }
    if (!this.new_report.from_date || !this.new_report.to_date) {
      messageAlert("Error", "Selecciona el rango de fechas del reporte", "error");
      return;
    }

    this.generating = true;

    let result_report: any = await firstValueFrom(
      this.Supabase.rpc('generate_report', {
        company_id: this.user_loged.company_id,
        report_type: this.new_report.type,
        from_date: this.new_report.from_date,
        to_date: this.new_report.to_date,
        format: this.new_report.format
      })
    );

    this.generating = false;

    if (!result_report) {
      messageAlert("Error", "Hubo un problema al generar el reporte", "error");
      return;
    }

    if (result_report.file_url) {
      window.open(result_report.file_url, '_blank');
    }

    this.onClose.next({
      generated: true
    });
    this.modalRef.hide();
  }
}
