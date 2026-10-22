import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { catchError, Observable, throwError } from 'rxjs';
import { SUPABASE_API_KEY_C, SUPABASE_URL_C } from '../constants';

@Injectable({
  providedIn: 'root',
})
export class Supabase {
  
  // Configuración de Supabase
  private readonly SUPABASE_URL = SUPABASE_URL_C;
  private readonly SUPABASE_API_KEY = SUPABASE_API_KEY_C;
  
  // Headers comunes para todas las peticiones
  private readonly headers = new HttpHeaders({
    'apikey': this.SUPABASE_API_KEY,
    'Authorization': `Bearer ${this.SUPABASE_API_KEY}`,
    'Content-Type': 'application/json',
    'Prefer': 'return=representation'
  });

  constructor(private http: HttpClient) {}

  /**
   * Método genérico para SELECT
   */
  select<T = any>(table: string, queryParams: any = {}): Observable<T> {
    let url = `${this.SUPABASE_URL}${table}`;
    let params = new HttpParams();
    
    // Filtrar por columnas específicas
    if (queryParams.select) {
      params = params.set('select', queryParams.select);
    }
    
    // Filtros WHERE
    if (queryParams.filters) {
      Object.keys(queryParams.filters).forEach(key => {
        const filter = queryParams.filters![key];
        
        // Filtro IN
        if (Array.isArray(filter)) {
          params = params.set(key, `in.(${filter.join(',')})`);
        } 
        // Filtro normal EQ
        else {
          params = params.set(key, `eq.${filter}`);
        }
      });
    }
    
    // Ordenamiento
    if (queryParams.order) {
      const direction = queryParams.order.direction || 'desc';
      params = params.set('order', `${queryParams.order.column}.${direction}`);
    }
    
    // Límite
    if (queryParams.limit) {
      params = params.set('limit', queryParams.limit.toString());
    }
    
    // Rango
    if (queryParams.range) {
      params = params.set('offset', queryParams.range.offset.toString());
      params = params.set('limit', queryParams.range.limit.toString());
    }
    
    return this.http.get<T>(url, { 
      headers: this.headers, 
      params: params 
    }).pipe(
      catchError(error => {
        console.error('Error en SELECT:', error);
        return throwError(() => error);
      })
    );
  }

  /**
   * Método genérico para INSERT
   */
  insert<T = any>(table: string, data: any): Observable<T> {
    const headers = this.headers.set('Prefer', 'return=representation');
    
    return this.http.post<T>(`${this.SUPABASE_URL}${table}`, data, { headers }).pipe(
      catchError(error => {
        console.error('Error en INSERT:', error);
        return throwError(() => error);
      })
    );
  }

  /**
   * Método genérico para UPDATE
   */
  update<T = any>(table: string, id: any, data: any, idColumn: string = 'id'): Observable<T> {
    const headers = this.headers.set('Prefer', 'return=representation');
    const params = new HttpParams().set(idColumn, `eq.${id}`);
    
    return this.http.patch<T>(`${this.SUPABASE_URL}${table}`, data, { 
      headers, 
      params 
    }).pipe(
      catchError(error => {
        console.error('Error en UPDATE:', error);
        return throwError(() => error);
      })
    );
  }

  /**
   * Método genérico para DELETE
   */
  delete<T = any>(table: string, id: any, idColumn: string = 'id'): Observable<T> {
    const params = new HttpParams().set(idColumn, `eq.${id}`);
    
    return this.http.delete<T>(`${this.SUPABASE_URL}${table}`, { 
      headers: this.headers, 
      params 
    }).pipe(
      catchError(error => {
        console.error('Error en DELETE:', error);
        return throwError(() => error);
      })
    );
  }

    /**
   * Método genérico para ejecutar funciones (RPC / stored procedures)
   * POST {SUPABASE_URL}rpc/{functionName}
   *
   * @param functionName Nombre de la función en Postgres (ej: 'generate_report')
   * @param params       Parámetros de la función como objeto { nombre_param: valor }
   * @param options      Opciones extra (ej: get para funciones STABLE/IMMUTABLE)
   */
  rpc<T = any>(
    functionName: string,
    params: Record<string, any> = {},
    options: { get?: boolean } = {}
  ): Observable<T> {
    const url = `${this.SUPABASE_URL}rpc/${functionName}`;

    // Opción GET: solo para funciones STABLE / IMMUTABLE (sin efectos secundarios)
    if (options.get) {
      let httpParams = new HttpParams();
      Object.keys(params).forEach(key => {
        const value = params[key];
        if (value !== undefined && value !== null) {
          httpParams = httpParams.set(
            key,
            typeof value === 'object' ? JSON.stringify(value) : String(value)
          );
        }
      });

      return this.http.get<T>(url, { headers: this.headers, params: httpParams }).pipe(
        catchError(error => {
          console.error(`Error en RPC (${functionName}):`, error);
          return throwError(() => error);
        })
      );
    }

    // Por defecto: POST (funciona con cualquier función)
    return this.http.post<T>(url, params, { headers: this.headers }).pipe(
      catchError(error => {
        console.error(`Error en RPC (${functionName}):`, error);
        return throwError(() => error);
      })
    );
  }


}
