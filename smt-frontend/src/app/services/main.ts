import { Injectable } from '@angular/core';
import { TOKEN_NAME } from '../constants';

@Injectable({
  providedIn: 'root',
})
export class Main {
  constructor() {}

  getSession() {
    return JSON.parse(sessionStorage.getItem(TOKEN_NAME) || '');
  }

  setSession(data: any) {
    sessionStorage.setItem(TOKEN_NAME, JSON.stringify(data));
    return true;
  }
}
