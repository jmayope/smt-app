import { CommonModule } from '@angular/common';
import { ChangeDetectorRef, Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { BsModalRef, BsModalService } from 'ngx-bootstrap/modal'
import { Supabase } from '../../services/supabase';
import { firstValueFrom } from 'rxjs';
import { loadingAlert, VEHICLE_DOCUMENTS, VEHICLE_TYPES, VEHICLES } from '../../constants';
import { Main } from '../../services/main';
import { BsDropdownModule } from 'ngx-bootstrap/dropdown';
import { NewVehicle } from '../../modals/new-vehicle/new-vehicle';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-vehicle',
  imports: [
    CommonModule,
    FormsModule,
    BsDropdownModule
  ],
  providers: [
    BsModalService
  ],
  templateUrl: './vehicle.html',
  styleUrl: './vehicle.css',
})
export class Vehicle implements OnInit {

  constructor(
    private Main: Main,
    private modalService: BsModalService,
    private Supabase: Supabase,
    private ChangeDetector: ChangeDetectorRef
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

  vehicleAvailabilities: any[] = VEHICLE_TYPES;

  vehicles: any[] = [];
  vehicle_totals: any = {};
  modalRef?: BsModalRef;
  user_loged: any;

  ngOnInit(): void {
    this.user_loged = this.Main.getSession();
    loadingAlert("Cargando información de Vehiculos");
    this.getVehicles();
  }

  async getVehicles() {
    let filters: any = {};
    if (this.user_loged.currentCompany) {
      filters.company_id = this.user_loged.currentCompany.id;
    }
    let result: any = await firstValueFrom(this.Supabase.select(VEHICLES, {filters: filters}));
    this.vehicles = result;
    this.vehicle_totals.total = this.vehicles.length;
    this.vehicle_totals.availables = this.vehicles.filter((v: any) => v.is_available).length;
    this.vehicle_totals.actives = this.vehicles.filter((v: any) => v.is_active).length;
    this.getVehicleDocuments();
  }
  
  async getVehicleDocuments() {
    let result_vehicle_documents: any = await firstValueFrom(this.Supabase.select(VEHICLE_DOCUMENTS, {filters: {vehicle_id: this.vehicles.map((v: any) => v.id)}}));
    this.vehicles.map((v: any) => {
      v.documents = result_vehicle_documents.filter((vd: any) => vd.vehicle_id === v.id);
    });
    console.log(this.vehicles);
    Swal.close();
    this.ChangeDetector.detectChanges();
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

    this.modalRef.onHidden?.subscribe(() => {
      console.log('El modal se cerró correctamente');

      // Ejecuta aquí lo que necesites
      this.getVehicles();
    });

  }



}
