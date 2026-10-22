import { CommonModule } from '@angular/common';
import { ChangeDetectorRef, Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Main } from '../../services/main';
import { Supabase } from '../../services/supabase';
import { firstValueFrom } from 'rxjs';
import { generateRandomString, messageAlert, USERS } from '../../constants';
import { BsDropdownModule } from 'ngx-bootstrap/dropdown';
import Swal from 'sweetalert2';
import { BsModalRef, BsModalService } from 'ngx-bootstrap/modal';
import { NewUser } from '../../modals/new-user/new-user';

@Component({
  selector: 'app-user',
  imports: [
    CommonModule,
    FormsModule,
    BsDropdownModule
  ],
  templateUrl: './user.html',
  styleUrl: './user.css',
})
export class User implements OnInit {

  constructor(
    private Main: Main,
    private Supabase: Supabase,
    private ChangeDetector: ChangeDetectorRef,
    private modalService: BsModalService,
  ) {}
  userLoged: any;
  users: any[] = [];
  totals: any = {};
  modalRef?: BsModalRef;

  ngOnInit(): void {
    this.userLoged = this.Main.getSession();
    this.getUsers();
  }

  async getUsers() {
    // let result_users: any = await firstValueFrom(this.Supabase.select(USERS, {filters: {}}));
    let filters: any = {};
    if (this.userLoged.currentCompany) {
      filters.company_id = this.userLoged.currentCompany.id;
    }
    let result_users: any = await firstValueFrom(this.Supabase.select(USERS, {filters: filters}));
    this.users = result_users;
    console.log(this.users);
    this.totals.admin = this.users.filter((u: any) => u.role.includes('administrador')).length;
    this.totals.supervisor = this.users.filter((u: any) => u.role.includes('supervisor')).length;
    this.totals.driver = this.users.filter((u: any) => u.role.includes('conductor')).length;
    this.ChangeDetector.detectChanges();
  }

  async toggleActivate(user: any) {
    Swal.fire({
      icon: 'question',
      text: `¿Estás seguro de ${user.is_active ? 'Desactivar' : 'Activar'} el Usuario?`,
      showCancelButton: true,
      showConfirmButton: true,
      allowEscapeKey: false,
      allowOutsideClick: false
    }).then(async (choice) => {
      if (choice.isConfirmed) {
        let resultUser: any = await firstValueFrom(this.Supabase.update(USERS, user.id, {is_active: !user.is_active}));
        if (!resultUser) {
          messageAlert("Error", "Hubo un error al momento de actualizar estado", 'error');
          return;
        }
        messageAlert("Éxito", "Se modificó al usuario", "success");
        this.getUsers();
      }
    })
  }

  changePassword(user: any) {
    Swal.fire({
      icon: 'question',
      text: `¿Estás seguro de Restablecer la Contraseña del Usuario?`,
      showCancelButton: true,
      showConfirmButton: true,
      allowEscapeKey: false,
      allowOutsideClick: false
    }).then(async (choice) => {
      if (choice.isConfirmed) {
        let resultUser: any = await firstValueFrom(this.Supabase.update(USERS, user.id, {password_hash: generateRandomString(8)}));
        if (!resultUser) {
          messageAlert("Error", "Hubo un error al momento de restablecer la contraseña", 'error');
          return;
        }
        messageAlert("Éxito", "Se modificó al usuario", "success");
        this.getUsers();
      }
    })
  }

  toggleUser(user?: any) {
    let config: any = {};
    if (user) {
      config.user = structuredClone(user);
    }
    this.modalRef = this.modalService.show(NewUser, { 
      initialState: config,
      class: 'modal-lg'
    });
    
    this.modalRef.onHidden?.subscribe(() => {
      console.log('El modal se cerró correctamente');

      // Ejecuta aquí lo que necesites
      this.getUsers();
    });

  }

}
