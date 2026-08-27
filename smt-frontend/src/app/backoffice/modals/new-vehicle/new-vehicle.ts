import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { BsModalRef } from 'ngx-bootstrap/modal';
import { Supabase } from '../../../services/supabase';
import { firstValueFrom } from 'rxjs';
import { VEHICLES } from '../../../constants';

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
    public bsModalRef: BsModalRef,
    private Supabase: Supabase
  ) {

  }

  vehicle_types: any[] = [
    { id: 1, code: "A", name: "Bombona" },
    { id: 2, code: "B", name: "Encapsulado" },
    { id: 3, code: "C", name: "Retro" }
  ];

  vehicle: any = {};

  ngOnInit(): void {
    if (this.vehicle.id) {
      this.vehicle.editing = true;
    }
  }

  close() {
    this.bsModalRef.hide();
  }

  async save() {
    console.log(this.vehicle);
    let newVehicle = structuredClone(this.vehicle);
    delete newVehicle.editing;
    let resultVehicleCreate = await firstValueFrom(this.Supabase.insert(VEHICLES, this.vehicle));
    console.log(resultVehicleCreate);
    this.bsModalRef.hide();
  }
}
