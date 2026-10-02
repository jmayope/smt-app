import { ChangeDetectorRef, Component, OnInit } from '@angular/core';
import { BsModalRef } from 'ngx-bootstrap/modal';
import { Supabase } from '../../services/supabase';
import { Main } from '../../services/main';
import { firstValueFrom, Subject } from 'rxjs';
import { messageAlert, ROUTES } from '../../constants';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-new-route',
  imports: [
    CommonModule,
    FormsModule
  ],
  templateUrl: './new-route.html',
  styleUrl: './new-route.css',
})
export class NewRoute implements OnInit{
  constructor(
    public modalRef: BsModalRef,
    private Supabase: Supabase,
    private Main: Main,
    private ChangeDetector: ChangeDetectorRef
  ) { }

  route!: any;
  new_route: any = {};
  inserting: boolean = false;
  public onClose: Subject<any> = new Subject<any>();
  user_loged: any;

  ngOnInit(): void {
    this.user_loged = this.Main.getSession();
    if (this.route) {
      this.new_route = structuredClone(this.route);
      this.new_route.editing = true;
      this.ChangeDetector.detectChanges();
    } else {
      this.new_route = {
        is_active: true,
        is_priority: false
      };
      this.ChangeDetector.detectChanges();
    }
  }

  async save() {
    if (this.inserting) {
      return;
    }
    this.inserting = true;

    if (this.new_route.editing) {
      let result_update: any = await firstValueFrom(
        this.Supabase.update(ROUTES, this.new_route.id, this.new_route)
      );
      if (!result_update) {
        messageAlert("Error", "Hubo un problema al actualizar la ruta", "error");
        this.inserting = false;
        return;
      }
      messageAlert("Éxito", "Se actualizó correctamente la ruta", "success");
    } else {
      this.new_route.company_id = this.user_loged.company_id;
      let result_route: any = await firstValueFrom(
        this.Supabase.insert(ROUTES, this.new_route)
      );
      if (!result_route) {
        messageAlert("Error", "Hubo un problema al insertar la ruta", "error");
        this.inserting = false;
        return;
      }
      messageAlert("Éxito", "Se guardó correctamente la ruta", "success");
    }

    this.onClose.next({
      registered: true
    });
    this.modalRef.hide();
  }
}
