import { ChangeDetectorRef, Component, OnInit } from '@angular/core';
import { Main } from '../../services/main';
import { Supabase } from '../../services/supabase';
import { ActivatedRoute, Router } from '@angular/router';
import { COMPANIES, messageAlert, SUBSCRIPTION_PACKAGES, USERS } from '../../constants';
import { firstValueFrom } from 'rxjs';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-register',
  imports: [
    CommonModule,
    FormsModule
  ],
  templateUrl: './register.html',
  styleUrl: './register.css',
})
export class Register implements OnInit {
  constructor(
    private Main: Main,
    private Supabase: Supabase,
    private ActivatedRoute: ActivatedRoute,
    private Router: Router,
    private ChangeDetector: ChangeDetectorRef
  ) {

  }
  
  
  package_selected: any;
  package_subscription_id: string = '';
  package_subscription_selected: any;
  new_company: any = {};
  new_user: any = {};
  show_password: boolean = false;
  registering: boolean = false;
  ngOnInit(): void {
    let data: any = this.ActivatedRoute.snapshot.queryParams;
    this.package_subscription_id = data.type;
    if (!this.package_subscription_id) {
      messageAlert("Validación", "Elige un plan para realizar el registro.", "errror");
      this.Router.navigate(['/autenticacion/iniciar-sesion']);
      return;
    }
    this.getPlanSubscription();
    console.log(data);
  }

  async getPlanSubscription() {
    let result_plan_subscription: any = await firstValueFrom(this.Supabase.select(SUBSCRIPTION_PACKAGES, {filters: {id: this.package_subscription_id}}));
    console.log(result_plan_subscription);
    if (!result_plan_subscription.length) {
      messageAlert("Validación", "Elige un plan para realizar el registro.", "errror");
      this.Router.navigate(['/autenticacion/iniciar-sesion']);
      return;
    }
    this.package_selected = result_plan_subscription[0];
    this.ChangeDetector.detectChanges();
  }

  async register() {
    if (!this.new_company.accept_terms) {
      messageAlert("Validación", "Necesitas aceptar los terminos y condiciones", "warning");
      return;
    }
    if (this.new_user.password_hash !== this.new_user.confirm_password) {
      messageAlert("Validación", "Las contraseñas deben de coincidir. Verifique por favor.", "warning");
      return;
    }
    if (this.registering) return;
    this.registering = true;
    let new_company = structuredClone(this.new_company);
    delete new_company.accept_terms;

    let result_company: any = await firstValueFrom(this.Supabase.insert(COMPANIES, new_company));
    if (!result_company) {
      messageAlert("Error", "Hubo un error al momento de registrar la empresa.", "error");
      return;
    }
    let company_created = result_company[0];
    let new_user = structuredClone(this.new_user);
    new_user.is_active = false;
    new_user.has_2fa = false;
    new_user.company_id = company_created.id;
    delete new_user.confirm_password;
    let result_user: any = await firstValueFrom(this.Supabase.insert(USERS, new_user));
    if (!result_user) {
      messageAlert("Error", "Hubo un error al momento de registrar el usuario de empresa.", "error");
      return;
    }
    messageAlert("Éxito", "Se creó correctamente la Empresa.", "success");
    this.Router.navigate(["/autenticacion/iniciar-sesion"]);
  }

  togglePassword() {
    this.show_password = !this.show_password;
  }

}
