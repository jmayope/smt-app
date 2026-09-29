import { ChangeDetectorRef, Component, OnInit } from '@angular/core';
import { COMPANIES, loadingAlert, messageAlert, SUBSCRIPTION_PACKAGES, USER_COMPANY_ROLES, USERS } from '../../constants';
import { firstValueFrom } from 'rxjs';
import { Supabase } from '../../services/supabase';
import { Router } from '@angular/router';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Main } from '../../services/main';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-login',
  imports: [
    CommonModule,
    FormsModule
  ],
  templateUrl: './login.html',
  styleUrl: './login.css',
})
export class Login implements OnInit {

  constructor(
    private Supabase: Supabase,
    private Main: Main,
    private Router: Router,
    private ChangeDetector: ChangeDetectorRef
  ) {

  }

  credentials: any = {};
  logging: boolean = false;
  showPassword: boolean = false;
  subscription_packages: any[] = [];



  ngOnInit(): void {
    this.getSusbscriptionPackages();
  }

  async getSusbscriptionPackages() {
    let result_subscription_packages: any = await firstValueFrom(this.Supabase.select(SUBSCRIPTION_PACKAGES, {filters: {}}));
    console.log(result_subscription_packages);
    this.subscription_packages = result_subscription_packages;
    this.ChangeDetector.detectChanges();
  }

  async login() {
    this.logging = true;
    if (!this.credentials.email || !this.credentials.password) {
      messageAlert("Validación", "Tienes que completar el formulario", "warning");
      return;
    }
    loadingAlert("Validando tus datos");
    let authentication = structuredClone(this.credentials);
    authentication.password_hash = authentication.password;
    delete authentication.password;
    
    let resultLogin: any = await firstValueFrom(this.Supabase.select(USERS, {filters: authentication}));
    console.log(resultLogin);
    if (!resultLogin) {
      messageAlert("Error", "Credenciales invalidas", "error");
      return;
    }
    let userLoged = resultLogin[0];
    let resultUserCompanyRoles: any = await firstValueFrom(this.Supabase.select(USER_COMPANY_ROLES, {filters: {user_id: userLoged.id}}));
    if (!resultUserCompanyRoles.length) {
      messageAlert("Validación", "No se tiene asignado ningun rol para este usuari", "warning")
      return;
    }
    let resultCompaniesOfUser: any = await firstValueFrom(this.Supabase.select(COMPANIES, {filters: {id: resultUserCompanyRoles.map((r: any) => r.company_id)}}));
    console.log(resultCompaniesOfUser);
    if (!resultCompaniesOfUser.length) {
      messageAlert("Validacion", "No tienes asignado a ninguna compañia", "warning");
      return;
    }
    userLoged.companies = resultCompaniesOfUser;
    userLoged.companies.map((c: any) => {
      c.roles = resultUserCompanyRoles.filter((ru: any) => ru.company_id === c.id);
    });
    if (userLoged.companies.length === 1) {
      userLoged.currentCompany = userLoged.companies[0];
      this.Main.setSession(userLoged);
      this.logging = false;
      Swal.close();
      if (userLoged.currentCompany.roles.length === 1) {
        userLoged.currentRole = userLoged.currentCompany.roles[0];
        this.Router.navigate(["autenticacion/tablero"]);
      } else {
        this.Router.navigate(["autenticacion/seleccionar-perfil"]);
      }
      return;
    }
    this.Main.setSession(userLoged);
    this.logging = false;
    Swal.close();
    this.Router.navigate(["autenticacion/seleccionar-empresa"]);
    return;
  }

  selectPlan(type: string) {
    console.log(type);
    this.Router.navigate([`autenticacion/registro`], {queryParams: {type: type}});
  }

  togglePassword() {
    this.showPassword = !this.showPassword;
  }

}
