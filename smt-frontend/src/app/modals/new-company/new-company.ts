import { CommonModule } from '@angular/common';
import { ChangeDetectorRef, Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { BsModalRef } from 'ngx-bootstrap/modal';
import { BUSINESS_TYPES, COMPANIES, messageAlert } from '../../constants';
import { firstValueFrom, Subject } from 'rxjs';
import { Supabase } from '../../services/supabase';

@Component({
  selector: 'app-new-company',
  imports: [
    CommonModule,
    FormsModule
  ],
  templateUrl: './new-company.html',
  styleUrl: './new-company.css',
})
export class NewCompany implements OnInit { 
  constructor(
    public modalRef: BsModalRef,
    private Supabase: Supabase,
    private ChangeDetector: ChangeDetectorRef
  ) {

  }

  company!: any;
  new_company: any = {};
  business_types: any[] = BUSINESS_TYPES;
  inserting: boolean = false;
  public onClose: Subject<any> = new Subject<any>();

  ngOnInit(): void {
    console.log(this.company);
    if (this.company) {
      this.new_company.editing = true;
      this.ChangeDetector.detectChanges();
    } {
      this.new_company = {};
      this.ChangeDetector.detectChanges();
    }
  }

  async save() {
    if (this.inserting) {
      return;
    }
    this.inserting = true;
    let result_company: any = await firstValueFrom(this.Supabase.insert(COMPANIES,this.new_company));
    if (!result_company) {
      messageAlert("Error", "Hubo un problema al insertar la campaña", "error");
      return;
    }
    messageAlert("Éxito", "Se guardo correctamente la compañia", "success");
    this.onClose.next({
      registered: true
    });
    this.modalRef.hide();
  }
}
