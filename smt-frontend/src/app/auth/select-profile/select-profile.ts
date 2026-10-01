import { Component, OnInit } from '@angular/core';
import { Main } from '../../services/main';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';

@Component({
  selector: 'app-select-profile',
  imports: [
    CommonModule,
    FormsModule,
    RouterLink
  ],
  templateUrl: './select-profile.html',
  styleUrl: './select-profile.css',
})
export class SelectProfile implements OnInit {

  constructor(
    private Main: Main,
    private Router: Router
  ) {}

  userLoged: any = {};

  ngOnInit(): void {
    this.userLoged = this.Main.getSession();
    console.log(this.userLoged);
  }

  selectProfile(role: any) {
    this.userLoged.currentRole = role;
    let sessionSaved = this.Main.setSession(this.userLoged);
    this.Router.navigate(["backoffice/tablero"])
  }

}
