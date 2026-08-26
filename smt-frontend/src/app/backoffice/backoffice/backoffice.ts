import { CommonModule } from '@angular/common';
import { Component, HostListener } from '@angular/core';
import { RouterLink, RouterOutlet } from '@angular/router';

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
export class Backoffice {

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
          route: '/backoffice/usuarios'
        },
        {
          label: 'Rutas y Viajes',
          icon: 'fa fa-route',
          route: '/backoffice/rutas'
        },
        {
          label: 'Vehiculos',
          icon: 'fa fa-car-side',
          route: '/backoffice/vehiculos'
        },
        {
          label: 'Conductores',
          icon: 'fa fa-route',
          route: '/backoffice/rutas'
        },
        {
          label: 'Transporte',
          icon: 'fa fa-road-spikes',
          route: '/backoffice/rutas'
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
          route: '/backoffice/reportes'
        },
      ]
    },
  ];

  activeModule = 'Dashboard';


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
