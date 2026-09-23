import Swal from "sweetalert2";

export const SUPABASE_URL_C = "https://lfixohlfrqyzxilpdazs.supabase.co/rest/v1/";
export const SUPABASE_API_KEY_C = "sb_publishable_VwtDyc_4HoaLKyCLSr_ZKw_g_3xIvkN";

export const VEHICLES = 'vehicles';
export const USERS = 'users';
export const COMPANIES = 'companies';
export const USER_COMPANY_ROLES = 'user_company_roles';

export const TOKEN_NAME = "smt-token";



export function generateRandomString(length: number) {
  const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()';
  let result = '';
  for (let i = 0; i < length; i++) {
    result += characters.charAt(Math.floor(Math.random() * characters.length));
  }
  return result;
}

export function loadingAlert(message: string, timerInSeconds?: number) {
  if (timerInSeconds) {
    Swal.fire({
      html: `
        <div class="spinner-grow text-primary" role="status">
          <span class="visually-hidden">Loading...</span>
        </div>
        <div class="spinner-grow text-secondary" role="status">
          <span class="visually-hidden">Loading...</span>
        </div>
        <div class="spinner-grow text-success" role="status">
          <span class="visually-hidden">Loading...</span>
        </div><br>${message}
      `,
      timer: timerInSeconds * 1000,
      allowEscapeKey: false,
      allowOutsideClick: false,
      showConfirmButton: false,
      showCancelButton: false
    });
  } else {
    Swal.fire({
      html: `
        <div class="spinner-grow text-primary" role="status">
          <span class="visually-hidden">Loading...</span>
        </div>
        <div class="spinner-grow text-secondary" role="status">
          <span class="visually-hidden">Loading...</span>
        </div>
        <div class="spinner-grow text-success" role="status">
          <span class="visually-hidden">Loading...</span>
        </div><br>${message}
      `,
      allowEscapeKey: false,
      allowOutsideClick: false,
      showConfirmButton: false,
      showCancelButton: false
    });
  }
}

export function messageAlert(title: any, message: string, icon: string) {
  let icons: any = {
    'success': 'success',
    'error': 'error',
    'warning': 'warning',
    'info': 'info',
  }
  Swal.fire({
    text: message,
    icon: icons[icon]
  });
}