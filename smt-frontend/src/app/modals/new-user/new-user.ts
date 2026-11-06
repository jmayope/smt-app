import { ChangeDetectorRef, Component, OnInit } from '@angular/core';
import { Main } from '../../services/main';
import { Supabase } from '../../services/supabase';
import { firstValueFrom, Subject } from 'rxjs';
import { messageAlert, ROLES, USERS } from '../../constants';
import { BsModalRef } from 'ngx-bootstrap/modal';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-new-user',
  imports: [
    CommonModule,
    FormsModule
  ],
  templateUrl: './new-user.html',
  styleUrl: './new-user.css',
})
export class NewUser implements OnInit {
  constructor(
    public modalRef: BsModalRef,
    private Main: Main,
    private Supabase: Supabase,
    private ChangeDetector: ChangeDetectorRef
  ) {

  }
  roles: any[] = ROLES;
  user!: any;
  new_user: any = {};
  inserting: boolean = false;
  public onClose: Subject<any> = new Subject<any>();
  user_loged: any;
  showPassword: boolean = false;
  ngOnInit(): void {
    this.user_loged = this.Main.getSession();
    if (this.user) {
      this.new_user = structuredClone(this.user);
      this.new_user.editing = true;
      this.ChangeDetector.detectChanges();
    } else {
      this.new_user = {
        company_id: this.user_loged.currentCompany.id,
        is_active: true,
        has_2fa: false
      };
      this.ChangeDetector.detectChanges();
    }
  }

  async save() {
    if (this.inserting) {
      return;
    }
    this.inserting = true;

    if (this.new_user.editing) {
      let new_user = structuredClone(this.new_user);
      delete new_user.editing;
      let result_update: any = await firstValueFrom(
        this.Supabase.update(USERS, this.new_user.id, new_user)
      );
      if (!result_update) {
        messageAlert("Error", "Hubo un problema al actualizar el conductor", "error");
        this.inserting = false;
        return;
      }
      messageAlert("Éxito", "Se actualizó correctamente el conductor", "success");
    } else {
      this.new_user.company_id = this.user_loged.company_id;
      // this.new_user.role = 'conductor';
      let result_driver: any = await firstValueFrom(
        this.Supabase.insert(USERS, this.new_user)
      );
      if (!result_driver) {
        messageAlert("Error", "Hubo un problema al insertar el conductor", "error");
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

  togglePassword() {
    this.showPassword = !this.showPassword;
  }
}
