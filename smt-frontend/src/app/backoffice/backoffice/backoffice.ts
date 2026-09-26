import { CommonModule } from '@angular/common';
import { Component, HostListener, OnInit } from '@angular/core';
import { RouterLink, RouterOutlet } from '@angular/router';
import { Main } from '../../services/main';

@Component({
  selector: 'app-backoffice',
  imports: [
    CommonModule,
    RouterLink,
    RouterOutlet
  ],
  templateUrl: './backoffice.html',
  styleUrl: './backoffice.css',
})
export class Backoffice implements OnInit {

  constructor(
    private Main: Main
  ) {}

  sidebarCollapsed = false;
  mobileSidebarOpen = false;
  userDropdownOpen = false;

  modules = [
    {
      name: 'General',
      icon: 'fa fa-cog',
      children: [
        {
          label: 'Dashboard',
          icon: 'fa fa-chart-column',
          route: '/backoffice/tablero'
        },
      ]
    },
    {
      name: 'Operación',
      icon: 'fa fa-route',
      children: [
        {
          label: 'Compañias',
          icon: 'fa fa-building',
          route: '/backoffice/administracion-de-empresa'
        },
        {
          label: 'Usuarios',
          icon: 'fa fa-users',
          route: '/backoffice/administracion-de-usuario'
        },
        {
          label: 'Rutas y Viajes',
          icon: 'fa fa-route',
          route: '/backoffice/administracion-de-ruta'
        },
        {
          label: 'Vehiculos',
          icon: 'fa fa-car-side',
          route: '/backoffice/administracion-de-vehiculo'
        },
        {
          label: 'Conductores',
          icon: 'fa fa-route',
          route: '/backoffice/administracion-de-conductor'
        },
        {
          label: 'Incidentes',
          icon: 'fa fa-road-spikes',
          route: '/backoffice/incidente'
        },
      ]
    },
    {
      name: 'Gestion',
      icon: 'fa fa-sliders',
      children: [
        {
          label: 'Reportes',
          icon: 'fa fa-file-lines',
          route: '/backoffice/reporte'
        },
        {
          label: 'Subscripción',
          icon: 'fa fa-file-lines',
          route: '/backoffice/modelo-de-subscripcion'
        },
      ]
    },
  ];

  activeModule = sessionStorage.getItem('menuSelected') || 'Dashboard';
  userLoged: any;

  ngOnInit(): void {
    this.sidebarCollapsed = sessionStorage.getItem('collapsed') ? sessionStorage.getItem('collapsed') === '1' : false;
    this.userLoged = this.Main.getSession();
    console.log(this.userLoged);
  }

  // =========================================================
  // RESPONSIVE
  // =========================================================

  isMobile(): boolean {
    return window.innerWidth < 992;
  }


  // =========================================================
  // SIDEBAR
  // =========================================================

  toggleSidebar(): void {

    if (this.isMobile()) {

      this.closeMobileSidebar();

    } else {

      this.sidebarCollapsed = !this.sidebarCollapsed;
      sessionStorage.setItem("collapsed", this.sidebarCollapsed ? '1' : '0');
    }
  }


  openMobileSidebar(): void {

    this.mobileSidebarOpen = true;

  }


  closeMobileSidebar(): void {

    this.mobileSidebarOpen = false;

  }


  // =========================================================
  // MENÚ USUARIO
  // =========================================================

  toggleUserMenu(event?: Event): void {

    event?.stopPropagation();

    this.userDropdownOpen =
      !this.userDropdownOpen;

  }


  closeUserMenu(): void {

    this.userDropdownOpen = false;

  }


  // =========================================================
  // MÓDULOS
  // =========================================================

  selectModule(module: string): void {

    this.activeModule = module;
    sessionStorage.setItem("menuSelected", module);

    if (this.isMobile()) {

      this.closeMobileSidebar();

    }

  }


  // =========================================================
  // RESIZE
  // =========================================================

  @HostListener('window:resize')
  onResize(): void {

    if (!this.isMobile()) {

      this.mobileSidebarOpen = false;

    }

  }


  // =========================================================
  // CLICK FUERA DEL MENÚ DE USUARIO
  // =========================================================

  @HostListener('document:click')
  onDocumentClick(): void {

    this.userDropdownOpen = false;

  }
}
