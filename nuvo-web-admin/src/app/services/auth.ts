import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, tap } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  private http = inject(HttpClient);
  
  // OJO: Apuntamos directo al Auth Service porque no tenemos Gateway activo
  private apiUrl = 'http://localhost:8081/api/v1/auth';

  login(email: string, password: string): Observable<any> {
    return this.http.post(`${this.apiUrl}/authenticate`, { email, password }).pipe(
      tap((response: any) => {
        if (response.token) {
          // Guardar token en el navegador
          localStorage.setItem('token', response.token);
        }
      })
    );
  }

  getToken() {
    return localStorage.getItem('token');
  }

  logout() {
    localStorage.removeItem('token');
  }
}