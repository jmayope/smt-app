import { ChangeDetectorRef, Component, OnInit } from '@angular/core';
import { BsModalRef } from 'ngx-bootstrap/modal';
import { Main } from '../../services/main';
import { Supabase } from '../../services/supabase';
import { firstValueFrom, Subject } from 'rxjs';
import { loadingAlert, messageAlert, USER_COMPANY_ROLES, USERS } from '../../constants';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-new-driver',
  imports: [
    CommonModule,
    FormsModule
  ],
  templateUrl: './new-driver.html',
  styleUrl: './new-driver.css',
})
export class NewDriver implements OnInit {
   constructor(
    public modalRef: BsModalRef,
    private Supabase: Supabase,
    private Main: Main,
    private ChangeDetector: ChangeDetectorRef
  ) { }

  driver!: any;
  new_driver: any = {};
  inserting: boolean = false;
  public onClose: Subject<any> = new Subject<any>();
  user_loged: any;

  person_exists: boolean = false;
  document_validated: boolean = false;

  ngOnInit(): void {
    this.user_loged = this.Main.getSession();
    if (this.driver) {
      this.new_driver = structuredClone(this.driver);
      this.new_driver.editing = true;
      this.ChangeDetector.detectChanges();
    } else {
      this.new_driver = {
        role: 'conductor',
        is_active: true,
        has_2fa: false
      };
      this.ChangeDetector.detectChanges();
    }
  }

  async validateDocument() {
    if (this.document_validated) {
      this.document_validated = false;
      this.new_driver.document_id = undefined;
      this.person_exists = false;
    } else {
      console.log(this.new_driver.document_id);
      if (!this.new_driver.document_id || this.new_driver.document_id.length < 8) {
        messageAlert("Validación", "El número de documento debe tener 8 dígitos", "warning");
        return;
      }    
      loadingAlert("Validando número de documento");
  
      let result_persons: any = await firstValueFrom(this.Supabase.select(USERS, {filters: {company_id: this.user_loged.currentCompany.id, document_id: this.new_driver.document_id}}));
      console.log(result_persons);
      if (result_persons.length) {
        this.person_exists = true;
        let personFound = result_persons[0];
        this.new_driver.first_name = personFound.first_name;
        this.new_driver.last_name = personFound.last_name;
        this.new_driver.email = personFound.email;
        this.new_driver.phone = personFound.phone;
        this.new_driver.is_active = personFound.is_active;
        this.new_driver.has_2fa = personFound.has_2fa;
      } else {
        this.person_exists = false;
      }
      Swal.close();
      this.document_validated = true;
    }
    this.ChangeDetector.detectChanges();
  }

  async save() {
    if (this.inserting) {
      return;
    }
    this.inserting = true;

    if (this.new_driver.editing || this.person_exists) {
      let result_update: any = await firstValueFrom(
        this.Supabase.update(USERS, this.new_driver.id, this.new_driver)
      );
      if (!result_update) {
        messageAlert("Error", "Hubo un problema al actualizar el conductor", "error");
        this.inserting = false;
        return;
      }
      messageAlert("Éxito", "Se actualizó correctamente el conductor", "success");
    } else {
      this.new_driver.company_id = this.user_loged.company_id;
      this.new_driver.role = 'conductor';
      let result_driver: any = await firstValueFrom(
        this.Supabase.insert(USERS, this.new_driver)
      );
      if (!result_driver) {
        messageAlert("Error", "Hubo un problema al insertar el conductor", "error");
        this.inserting = false;
        return;
      }

      let user_created: any = result_driver[0];
      // creamos la relacion entre compañia y rol

      let new_user_company_role: any = {
        user_id: user_created.id,
        company_id: this.user_loged.currentCompany.id,
        role: 'driver',
        is_active: true,
      };

      let result_user_company_role: any = await firstValueFrom(this.Supabase.insert(USER_COMPANY_ROLES, new_user_company_role));
      if (!result_user_company_role.length) {
        messageAlert("Error", "Hubo un error al insertar el rol del conductor", "error");
        this.inserting = false;
        return;
      }

      messageAlert("Éxito", "Se guardó correctamente el conductor", "success");
    }

    this.onClose.next({
      registered: true
    });
    this.modalRef.hide();
  }
}
