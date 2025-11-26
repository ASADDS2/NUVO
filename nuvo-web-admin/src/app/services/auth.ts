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
    // Limpiar cualquier sesión anterior antes de iniciar una nueva
    this.logout();

    return this.http.post(`${this.apiUrl}/authenticate`, { email, password }).pipe(
      tap((response: any) => {
        if (response.token) {
          // Guardar token y datos completos del usuario
          localStorage.setItem('token', response.token);
          localStorage.setItem('userId', response.id);
          localStorage.setItem('role', response.role);

          // Guardar información completa del usuario para uso en la UI
          const currentUser = {
            id: response.id,
            firstname: response.firstname || 'Usuario',
            lastname: response.lastname || 'NUVO',
            email: response.email || email,
            role: response.role || 'USER'
          };
          localStorage.setItem('currentUser', JSON.stringify(currentUser));

          // Marcar timestamp de login para control de sesión
          localStorage.setItem('loginTime', new Date().toISOString());
        }
      })
    );
  }

  getToken() {
    return localStorage.getItem('token');
  }

  getUserId(): number {
    return Number(localStorage.getItem('userId'));
  }

  getRole(): string {
    return localStorage.getItem('role') || '';
  }

  getCurrentUser(): any {
    const userStr = localStorage.getItem('currentUser');
    return userStr ? JSON.parse(userStr) : null;
  }

  isLoggedIn(): boolean {
    return !!this.getToken();
  }

  isAdmin(): boolean {
    return this.getRole() === 'ADMIN';
  }

  logout() {
    // Limpiar toda la información de sesión
    localStorage.removeItem('token');
    localStorage.removeItem('userId');
    localStorage.removeItem('role');
    localStorage.removeItem('currentUser');
    localStorage.removeItem('loginTime');
  }
}