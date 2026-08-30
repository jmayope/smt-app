import { Component, OnInit } from '@angular/core';
import { loadingAlert, messageAlert } from '../../constants';
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

  ngOnInit(): void {
      
  }

  async login() {
    this.logging = true;
    loadingAlert("Validando tus datos");
    let resultLogin: any = await firstValueFrom(this.Supabase.select(''));
  }

  selectPlan(type: string) {
    console.log(type);
    this.Router.navigate([`autenticacion/registro`], {queryParams: {type: type}});
  }

}
