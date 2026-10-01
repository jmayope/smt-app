import { CommonModule } from '@angular/common';
import { ChangeDetectorRef, Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { firstValueFrom } from 'rxjs';
import { Main } from '../../services/main';
import { Supabase } from '../../services/supabase';
import { COMPANIES } from '../../constants';

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

  constructor(
    private Main: Main,
    private Supabase: Supabase,
    private ChangeDetector: ChangeDetectorRef
  ) {

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
    let result_companies: any = await firstValueFrom(this.Supabase.select(COMPANIES, {filters: {}}));
    this.companies = result_companies;
    this.ChangeDetector.detectChanges();
  }

  // async getCompanySubscriptionInfo() {
  //   let result_subscription_infos: any = await 
  // }



}
