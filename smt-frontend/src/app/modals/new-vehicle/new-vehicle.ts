import { CommonModule } from '@angular/common';
import { ChangeDetectorRef, Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { BsModalRef } from 'ngx-bootstrap/modal';
import { Supabase } from '../../services/supabase';
import { firstValueFrom, Subject } from 'rxjs';
import { messageAlert, VEHICLES } from '../../constants';
import { Main } from '../../services/main';

@Component({
  selector: 'app-new-vehicle',
  imports: [
    CommonModule,
    FormsModule,
  ],
  templateUrl: './new-vehicle.html',
  styleUrl: './new-vehicle.css',
})
export class NewVehicle implements OnInit {
  
  constructor(
    public modalRef: BsModalRef,
    private Supabase: Supabase,
    private Main: Main,
    private ChangeDetector: ChangeDetectorRef
  ) { }

  vehicle!: any;
  new_vehicle: any = {};
  inserting: boolean = false;
  public onClose: Subject<any> = new Subject<any>();

  vehicle_types: any[] = [
    { id: 'camion_encapsulado', name: 'Camión encapsulado' },
    { id: 'camion_bombona', name: 'Camión bombona' },
    { id: 'camion_retro', name: 'Camión retro' }
  ];

  capacities: any[] = [25, 30, 35];
  user_loged: any;

  ngOnInit(): void {
    this.user_loged = this.Main.getSession();
    if (this.vehicle) {
      this.new_vehicle = structuredClone(this.vehicle);
      this.new_vehicle.editing = true;
      this.ChangeDetector.detectChanges();
    } else {
      this.new_vehicle = {
        material_type: 'oro',
        is_active: true,
        is_available: true,
        has_maintenance_scheduled: false
      };
      this.ChangeDetector.detectChanges();
    }
  }

  async save() {
    if (this.inserting) {
      return;
    }
    this.inserting = true;

    if (this.new_vehicle.editing) {
      let result_update: any = await firstValueFrom(
        this.Supabase.update(VEHICLES, this.new_vehicle.id, this.new_vehicle)
      );
      if (!result_update) {
        messageAlert("Error", "Hubo un problema al actualizar el vehículo", "error");
        this.inserting = false;
        return;
      }
      messageAlert("Éxito", "Se actualizó correctamente el vehículo", "success");
    } else {
      this.new_vehicle.company_id = this.user_loged.company_id;
      let result_vehicle: any = await firstValueFrom(
        this.Supabase.insert(VEHICLES, this.new_vehicle)
      );
      if (!result_vehicle) {
        messageAlert("Error", "Hubo un problema al insertar el vehículo", "error");
        this.inserting = false;
        return;
      }
      messageAlert("Éxito", "Se guardó correctamente el vehículo", "success");
    }

    this.onClose.next({
      registered: true
    });
    this.modalRef.hide();
  }
}
