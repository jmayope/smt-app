import Swal from "sweetalert2";

export const SUPABASE_URL_C = "https://lfixohlfrqyzxilpdazs.supabase.co/rest/v1/";
export const SUPABASE_API_KEY_C = "sb_publishable_VwtDyc_4HoaLKyCLSr_ZKw_g_3xIvkN";

export const VEHICLES = 'vehicles';
export const VEHICLE_DOCUMENTS = 'vehicle_documents';
export const USERS = 'users';
export const COMPANIES = 'companies';
export const USER_COMPANY_ROLES = 'user_company_roles';
export const SUBSCRIPTION_PACKAGES = 'subscription_packages';
export const COMPANY_SUBSCRIPTIONS = 'company_subscriptions';
export const ROUTES = 'routes';
export const ROUTE_POINTS = 'route_points';
export const ROUTE_SEGMENTS = 'route_segments';
export const TRANSPORT_ASSIGNMENTS = 'transport_assignments';
export const INCIDENTS = 'incidents';
export const DAILY_REPORTS = 'daily_reports';
export const TOKEN_NAME = "smt-token";

export const STATUS_PENDING = 'pending';
export const STATUS_IN_PROGRESS = 'in_progress';
export const STATUS_COMPLETED = 'completed';
export const STATUS_CANCELLED = 'cancelled';
export const STATUS_DELAYED = 'delayed';

export const VEHICLE_TYPES = [
  { id: 'camion_encapsulado', name: 'Camión encapsulado' },
  { id: 'camion_bombona', name: 'Camión bombona' },
  { id: 'camion_retro', name: 'Camión retro' }
];

export function getStatusName(status_id: string) {
  switch (status_id) {
    case STATUS_PENDING:
      return 'Pendiente';
    case STATUS_IN_PROGRESS:
      return 'En Progreso';
    case STATUS_COMPLETED:
      return 'Completado';
    case STATUS_CANCELLED:
      return 'Cancelado';
    case STATUS_DELAYED:
      return 'Retrasado';
    default:
      return 'Sin estado'
  }
}

export const BUSINESS_TYPES = [
  { id: "Minería"},
  { id: "Transporte minero"},
  { id: "Transporte de carga"},
  { id: "Logística"},
  { id: "Operaciones mineras"},
  { id: "Servicios mineros"}
];

export const ROLES = [
  {id: 'administrador', name: 'Administrador'}, 
  {id: 'administrador_empresa', name: 'Administrador de Empresa'}, 
  {id: 'supervisor', name: 'Supervisor'}, 
  {id: 'conductor', name: 'Conductor'}
];


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

export function formatDuration(seconds: number): string {
  const mins = Math.round(seconds / 60);
  if (mins < 60) return `${mins} min`;
  const hours = Math.floor(mins / 60);
  const remainingMins = mins % 60;
  return `${hours} h ${remainingMins} min`;
}

export function timeToDatetime(time: string): string {
  const [hours, minutes] = time.split(':').map(Number);

  const now = new Date();
  now.setHours(hours, minutes, 0, 0); // segundos y ms en 0

  // Formato local sin zona horaria
  return `${now.getFullYear()}-${pad(now.getMonth() + 1)}-${pad(now.getDate())}` +
         `T${pad(hours)}:${pad(minutes)}:00`;
}

export function pad(n: number): string {
  return n.toString().padStart(2, '0');
}