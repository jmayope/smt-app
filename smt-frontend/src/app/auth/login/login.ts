import { Component, OnInit } from '@angular/core';
import { loadingAlert, messageAlert, USERS } from '../../constants';
import { firstValueFrom } from 'rxjs';
import { Supabase } from '../../services/supabase';
import { Router } from '@angular/router';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

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
    private Router: Router
  ) {

  }

  credentials: any = {};
  logging: boolean = false;
  showPassword: boolean = false;

  ngOnInit(): void {
      
  }

  async login() {
    this.logging = true;
    loadingAlert("Validando tus datos");
    let authentication = structuredClone(this.credentials);
    authentication.password_hash = authentication.password;
    delete authentication.password;
    let resultLogin: any = await firstValueFrom(this.Supabase.select(USERS, authentication));
    console.log(resultLogin);
    if (!resultLogin) {
      messageAlert("Error", "Credenciales invalidas", "error");
      return;
    }
    console.log("Verificación de Perfil");
  }

  selectPlan(type: string) {
    console.log(type);
    this.Router.navigate([`autenticacion/registro`], {queryParams: {type: type}});
  }

  togglePassword() {
    this.showPassword = !this.showPassword;
  }

}
