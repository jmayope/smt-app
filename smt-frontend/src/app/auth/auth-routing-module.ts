import { RouterModule, Routes } from "@angular/router";
import { Login } from "./login/login";
import { ForgotPassword } from "./forgot-password/forgot-password";
import { Register } from "./register/register";
import { NgModule } from "@angular/core";

const routes: Routes = [
  {
    path: 'iniciar-sesion',
    component: Login
  },
  {
    path: 'olvido-clave',
    component: ForgotPassword
  },
  {
    path: 'registro',
    component: Register
  },
  {
    path: '**',
    redirectTo: 'iniciar-sesion'
  }
];

@NgModule({
    imports: [RouterModule.forChild(routes)],
    exports: [RouterModule]
})
export class AuthRoutingModule {}