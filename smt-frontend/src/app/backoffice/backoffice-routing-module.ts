import { RouterModule, Routes } from '@angular/router';
import { Backoffice } from './backoffice/backoffice';
import { NgModule } from '@angular/core';
import { Dashboard } from './dashboard/dashboard';
import { Company } from './company/company';
import { User } from './user/user';
import { Vehicle } from './vehicle/vehicle';
import { Driver } from './driver/driver';
import { Route } from './route/route';
import { Operation } from './operation/operation';
import { Incident } from './incident/incident';
import { Report } from './report/report';
import { SubscriptionModel } from './subscription-model/subscription-model';
import { Profile } from './profile/profile';

export const routes: Routes = [
  {
    path: '',
    component: Backoffice,
    children: [
      {
          path: 'tablero',
          component: Dashboard,
          data: { title: 'Tablero' }
      },
      {
          path: 'administracion-de-empresa',
          component: Company,
          data: { title: 'Administración de Empresa' }
      },
      {
          path: 'administracion-de-usuario',
          component: User,
          data: { title: 'Administración de Usuario' }
      },
      {
          path: 'administracion-de-vehiculo',
          component: Vehicle,
          data: { title: 'Administración de Vehiculo' }
      },
      {
          path: 'administracion-de-conductor',
          component: Driver,
          data: { title: 'Administración de Conductor' }
      },
      {
          path: 'administracion-de-ruta',
          component: Route,
          data: { title: 'Administración de Rutas' }
      },
      {
          path: 'administracion-de-operacion',
          component: Operation,
          data: { title: 'Administracipon de Operación' }
      },
      {
          path: 'incidente',
          component: Incident,
          data: { title: 'Incidentes' }
      },
      {
          path: 'reporte',
          component: Report,
          data: { title: 'Reportes' }
      },
      {
          path: 'modelo-de-subscripcion',
          component: SubscriptionModel,
          data: { title: 'Módelos de Subscripción' }
      },
      {
          path: 'perfil',
          component: Profile,
          data: { title: 'Perfil de Usuario' }
      },
    ]
  }
];

@NgModule({
    imports: [RouterModule.forChild(routes)],
    exports: [RouterModule]
})
export class BackofficeRoutingModule {}