import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Pool, PoolStats, CreatePoolRequest, UpdatePoolRequest } from '../models/pool.model';

@Injectable({
  providedIn: 'root'
})
export class DataService {
  private http = inject(HttpClient);

  // URLs de los microservicios
  private accountUrl = 'http://localhost:8082/api/v1/accounts';
  private loanUrl = 'http://localhost:8084/api/v1/loans';
  private poolUrl = 'http://localhost:8085/api/v1/pool';
  private poolManagementUrl = 'http://localhost:8085/api/v1/pools';

  // --- CUENTAS ---
  getAllAccounts(): Observable<any[]> {
    return this.http.get<any[]>(this.accountUrl);
  }

  // --- PRÉSTAMOS ---
  getAllLoans(): Observable<any[]> {
    return this.http.get<any[]>(this.loanUrl);
  }

  getLoansByUserId(userId: number): Observable<any[]> {
    return this.http.get<any[]>(`${this.loanUrl}/my-loans/${userId}`);
  }

  approveLoan(loanId: number): Observable<any> {
    return this.http.put(`${this.loanUrl}/${loanId}/approve`, {});
  }

  // --- POOL INVESTMENTS ---
  getAllInvestments(): Observable<any[]> {
    return this.http.get<any[]>(this.poolUrl);
  }

  investInPool(userId: number, amount: number, poolId: number): Observable<any> {
    return this.http.post(`${this.poolUrl}/invest`, {
      userId,
      amount,
      poolId
    });
  }

  getMyInvestments(userId: number): Observable<any[]> {
    return this.http.get<any[]>(`${this.poolUrl}/my-investments/${userId}`);
  }

  // --- POOL MANAGEMENT (CRUD) ---
  getAllPools(): Observable<PoolStats[]> {
    return this.http.get<PoolStats[]>(this.poolManagementUrl);
  }

  getActivePools(): Observable<Pool[]> {
    return this.http.get<Pool[]>(`${this.poolManagementUrl}/active`);
  }

  getPoolById(id: number): Observable<Pool> {
    return this.http.get<Pool>(`${this.poolManagementUrl}/${id}`);
  }

  getPoolStats(id: number): Observable<PoolStats> {
    return this.http.get<PoolStats>(`${this.poolManagementUrl}/${id}/stats`);
  }

  createPool(request: CreatePoolRequest): Observable<Pool> {
    return this.http.post<Pool>(this.poolManagementUrl, request);
  }

  updatePool(id: number, request: UpdatePoolRequest): Observable<Pool> {
    return this.http.put<Pool>(`${this.poolManagementUrl}/${id}`, request);
  }

  deletePool(id: number): Observable<void> {
    return this.http.delete<void>(`${this.poolManagementUrl}/${id}`);
  }

  // --- AUTH ---
  getUserById(userId: number): Observable<any> {
    return this.http.get<any>(`http://localhost:8081/api/v1/auth/${userId}`);
  }
}