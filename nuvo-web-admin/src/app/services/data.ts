import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class DataService {
  private http = inject(HttpClient);

  // URLs de los microservicios
  private accountUrl = 'http://localhost:8082/api/v1/accounts';
  private loanUrl = 'http://localhost:8084/api/v1/loans';
  private poolUrl = 'http://localhost:8085/api/v1/pool';

  // --- CUENTAS ---
  getAllAccounts(): Observable<any[]> {
    return this.http.get<any[]>(this.accountUrl);
  }

  // --- PRÉSTAMOS (Estos son los que te faltaban) ---
  getAllLoans(): Observable<any[]> {
    return this.http.get<any[]>(this.loanUrl);
  }

  getLoansByUserId(userId: number): Observable<any[]> {
    return this.http.get<any[]>(`${this.loanUrl}/user/${userId}`);
  }

  approveLoan(loanId: number): Observable<any> {
    return this.http.put(`${this.loanUrl}/${loanId}/approve`, {});
  }

  // --- POOL ---
  getAllInvestments(): Observable<any[]> {
    return this.http.get<any[]>(this.poolUrl);
  }

  // --- AUTH ---
  getUserById(userId: number): Observable<any> {
    return this.http.get<any>(`http://localhost:8081/api/v1/auth/${userId}`);
  }
}