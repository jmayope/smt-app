import { ChangeDetectorRef, Component, OnInit } from '@angular/core';
import { BsModalRef } from 'ngx-bootstrap/modal';
import { Main } from '../../services/main';
import { Supabase } from '../../services/supabase';
import { firstValueFrom, Subject } from 'rxjs';
import { messageAlert, USERS } from '../../constants';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

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

  async save() {
    if (this.inserting) {
      return;
    }
    this.inserting = true;

    if (this.new_driver.editing) {
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
      messageAlert("Éxito", "Se guardó correctamente el conductor", "success");
    }

    this.onClose.next({
      registered: true
    });
    this.modalRef.hide();
  }
}
