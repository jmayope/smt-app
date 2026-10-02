import { CommonModule } from '@angular/common';
import { ChangeDetectorRef, Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { firstValueFrom } from 'rxjs';
import { Main } from '../../services/main';
import { Supabase } from '../../services/supabase';
import { COMPANIES, COMPANY_SUBSCRIPTIONS, messageAlert, SUBSCRIPTION_PACKAGES, USERS } from '../../constants';
import Swal from 'sweetalert2';
import { BsModalRef, BsModalService } from 'ngx-bootstrap/modal';
import { NewCompany } from '../../modals/new-company/new-company';


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
    private ChangeDetector: ChangeDetectorRef,
    private ModalService: BsModalService
  ) {

  }

  modalRef?: BsModalRef;

  companies: any[] = [];
  business_types: any[] = [
    { id: "PRI", name: "PRIVADA", },
    { id: "PUB", name: "PÚBLICA", }
  ];

  company_subscriptions: any[] = [];
  subscription_packages: any[] = [];
  users_by_company: any[] = [];

  filters: any = {};
  totals: any = {};

  ngOnInit(): void {
    this.getCompanies();    
  }

  async getCompanies() {
    this.companies = [];
    let result_companies: any = await firstValueFrom(this.Supabase.select(COMPANIES, {filters: {}}));
    this.companies = result_companies;
    this.totals.total = this.companies.length;
    this.getUsersOfCompany();
  }
  
  async getUsersOfCompany() {
    let result_users_by_company: any = await firstValueFrom(this.Supabase.select(USERS, {filters: {company_id: this.companies.map((c: any) => c.id)}}));
    this.users_by_company = result_users_by_company;
    this.companies.map((c: any) => {
      c.users = this.users_by_company.filter((u: any) => u.company_id === c.id);
    });
    this.getCompanySubscriptionInfo();
  }
  async getCompanySubscriptionInfo() {
    let result_company_subscription: any = await firstValueFrom(this.Supabase.select(COMPANY_SUBSCRIPTIONS, { filters: { company_id: this.companies.map((c: any) => c.id)}}));
    this.company_subscriptions = result_company_subscription;
    this.companies.map((c: any) => {
      c.subscription = this.company_subscriptions.find((cs: any) => cs.company_id === c.id);
    });
    this.totals.subscripteds = this.companies.filter((c: any) => c.subscription).length;
    this.totals.testing = this.companies.filter((c: any) => c.subscription).length;
    this.getPackagesSubscriptions();
  }

  async getPackagesSubscriptions() {
    let result_subscriptions_package: any = await firstValueFrom(this.Supabase.select(SUBSCRIPTION_PACKAGES, {filters: {id: this.company_subscriptions.map((x: any) => x.package_id) }}));
    this.subscription_packages = result_subscriptions_package;
    this.companies.map((c: any) => {
      if (c.subscription) {
        c.subscription_package = this.subscription_packages.find((sp: any) => sp.id === c.subscription.package_id);
      }
    });
    this.ChangeDetector.detectChanges();
  }

  toggleCompany(company?: any) {
    this.modalRef = this.ModalService.show(NewCompany, {class: 'modal-nm'});
    
    if (this.modalRef && this.modalRef.content) {
      this.modalRef.content.company = structuredClone(company);
    }

    this.modalRef.content?.onClose.subscribe((data: any) => {
      if (data.registered) {
        this.getCompanies();
      }
    })
  }

  deleteItem(company: any) {
    Swal.fire({
      icon: 'question',
      text: `¿Estás seguro de eliminar la compañia: "${company.name}"?`,
      allowOutsideClick: false,
      allowEscapeKey: false,
      showConfirmButton: true,
      showCancelButton: true
    }).then(async (choice) => {
      if (choice.isConfirmed) {
        let result_delete: any = await firstValueFrom(this.Supabase.delete(COMPANIES, company.id));
        if (!result_delete) {
          messageAlert("Error", "Hubo un error al eliminar el usuario", "error");
          return;  
        }
        messageAlert("Éxito", "Se elimino la compañia", "success");
        this.getCompanies();
      }
    })
  }

}
