import { Component, OnInit } from '@angular/core';
import { Main } from '../../services/main';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';

@Component({
  selector: 'app-select-company',
  imports: [
    CommonModule,
    FormsModule
  ],
  templateUrl: './select-company.html',
  styleUrl: './select-company.css',
})
export class SelectCompany implements OnInit {
  constructor(
    private Main: Main,
    private Router: Router
  ) {

  }

  userLoged: any = {};

  ngOnInit(): void { 
    this.userLoged = this.Main.getSession();
    console.log(this.userLoged);
  }

  selectCompany(company: any) {
    this.userLoged.currentCompany = company;
    if (this.userLoged.currentCompany.roles.length === 1) {
      this.userLoged.currentRole = this.userLoged.currentCompany.roles[0];
      let sessionSaved = this.Main.setSession(this.userLoged);
      this.Router.navigate(["backoffice/tablero"]);
      return;
    }
    this.Router.navigate(["autenticacion/seleccionar-perfil"]);
  }
}
