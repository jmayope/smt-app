import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { firstValueFrom } from 'rxjs';

@Component({
  selector: 'app-company',
  imports: [
    CommonModule,
    FormsModule
  ],
  templateUrl: './company.html',
  styleUrl: './company.css',
})
export class Company implements OnInit{

  constructor() {

  }

  companies: any[] = [];
  business_types: any[] = [
    { id: "PRI", name: "PRIVADA", },
    { id: "PUB", name: "PÚBLICA", }
  ];

  subscription_packages: any[] = [
    { id: "B", name: "BÁSICO" },
    { id: "R", name: "REGULAR" },
    { id: "P", name: "PREMIUM" },
  ];

  filters: any = {};

  ngOnInit(): void {
    this.getCompanies();    
  }

  async getCompanies() {
    
  }



}
