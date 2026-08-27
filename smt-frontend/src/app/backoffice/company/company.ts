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

  ngOnInit(): void {
    this.getCompanies();    
  }

  async getCompanies() {
    
  }



}
