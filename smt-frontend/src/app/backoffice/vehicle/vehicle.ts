import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { BsModalRef, BsModalService } from 'ngx-bootstrap/modal'
import { NewVehicle } from '../modals/new-vehicle/new-vehicle';
import { Supabase } from '../../services/supabase';
import { firstValueFrom } from 'rxjs';
import { VEHICLES } from '../../constants';

@Component({
  selector: 'app-vehicle',
  imports: [
    CommonModule,
    FormsModule,
  ],
  providers: [
    BsModalService
  ],
  templateUrl: './vehicle.html',
  styleUrl: './vehicle.css',
})
export class Vehicle implements OnInit {

  constructor(
    private modalService: BsModalService,
    private Supabase: Supabase
  ) {

  }

  filters: any = {};
  vehicleTypes: any[] = [
    { id: 1, code: "A", name: "Bombona" },
    { id: 2, code: "B", name: "Encapsulado" },
    { id: 3, code: "C", name: "Retro" }
  ];

  vehicleStatus: any[] = [
    { id: 1, code: true, name: "Activo" },
    { id: 2, code: false, name: "Inactivo" },
  ];

  vehicleAvailabilities: any[] = [
    { id: 1, code: "A", name: "Bombona" },
    { id: 2, code: "B", name: "Encapsulado" },
    { id: 3, code: "C", name: "Retro" }
  ];

  vehicles: any[] = [];

  modalRef?: BsModalRef;

  ngOnInit(): void {
    this.getVehicles();
  }

  async getVehicles() {
    let result: any = await firstValueFrom(this.Supabase.select(VEHICLES, {}));
    this.vehicles = result;
  }

  toggleVehicle(item?: any) {
    let config: any = {};
    if (item) {
      config.vehicle = structuredClone(item);
    }
    this.modalRef = this.modalService.show(NewVehicle, { 
      initialState: config,
      class: 'modal-lg'
    });

  }



}
