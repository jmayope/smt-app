import { Routes } from '@angular/router';

export const routes: Routes = [
  {
    path: '',
    redirectTo: 'autenticacion/iniciar-sesion',
    pathMatch: 'full'
  },
  {
    path: 'autenticacion',
    loadChildren: () => import('./auth/auth-module').then(m => m.AuthModule)
  },
  {
    path: 'backoffice',
    loadChildren: () => import('./backoffice/backoffice-module').then(m => m.BackofficeModule)
  },
  {
    path: '**',
    redirectTo: 'autenticacion/iniciar-sesion'
  }
];
