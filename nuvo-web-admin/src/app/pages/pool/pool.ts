import { Component, OnInit, inject, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { DataService } from '../../services/data';
import { AuthService } from '../../services/auth';
import { Pool } from '../../models/pool.model';

@Component({
  selector: 'app-pool',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './pool.html',
})
export class PoolComponent implements OnInit {
  private dataService = inject(DataService);
  private authService = inject(AuthService);
  private cdr = inject(ChangeDetectorRef);

  pools: Pool[] = [];
  selectedPoolId: number | null = null;
  amount: number = 0;
  isLoading = false;
  isAdmin = false;

  ngOnInit() {
    const role = this.authService.getRole();
    this.isAdmin = this.authService.isAdmin();
    console.log('🔒 [Pool] Role:', role);
    console.log('🔒 [Pool] Is Admin?', this.isAdmin);
    this.loadActivePools();
  }

  loadActivePools() {
    console.log('🏊 [Pool] Iniciando carga de pools activos...');
    this.isLoading = true;
    
    this.dataService.getActivePools().subscribe({
      next: (data: Pool[]) => {
        console.log('✅ [Pool] Pools recibidos:', data);
        console.log('📊 [Pool] Total de pools:', data?.length || 0);
        this.pools = data;
        this.isLoading = false;
        this.cdr.detectChanges();
      },
      error: (err) => {
        console.error('❌ [Pool] Error cargando pools:', err);
        console.error('❌ [Pool] Status:', err.status);
        console.error('❌ [Pool] Message:', err.message);
        alert(`Error al cargar pools: ${err.message || 'Error desconocido'}`);
        this.isLoading = false;
        this.cdr.detectChanges();
      }
    });
  }

  selectPool(poolId: number) {
    if (this.isAdmin) return;
    this.selectedPoolId = poolId;
  }

  invest() {
    if (this.isAdmin) {
      alert('Los administradores no pueden invertir');
      return;
    }

    if (!this.selectedPoolId) {
      alert('Por favor selecciona un pool');
      return;
    }

    if (this.amount <= 0) {
      alert('El monto debe ser mayor a 0');
      return;
    }

    this.isLoading = true;
    const userId = this.authService.getUserId();
    
    this.dataService.investInPool(userId, this.amount, this.selectedPoolId).subscribe({
      next: () => {
        alert('¡Inversión realizada exitosamente!');
        this.amount = 0;
        this.selectedPoolId = null;
        this.isLoading = false;
        this.cdr.detectChanges();
      },
      error: (err: any) => {
        console.error('Error invirtiendo:', err);
        alert(err.error || 'Error al realizar inversión');
        this.isLoading = false;
        this.cdr.detectChanges();
      }
    });
  }

  getPercentageFilled(pool: Pool): number {
    return ((pool.currentParticipantsCount || 0) / pool.maxParticipants) * 100;
  }

  getStatusText(pool: Pool): string {
    const available = pool.maxParticipants - (pool.currentParticipantsCount || 0);
    if (pool.full) return 'LLENO';
    if (available === pool.maxParticipants) return `${pool.maxParticipants} cupos disponibles`;
    return `${available} cupos disponibles`;
  }

  getStatusColor(pool: Pool): string {
    if (pool.full) return 'text-red-600';
    const percentage = this.getPercentageFilled(pool);
    if (percentage >= 80) return 'text-yellow-600';
    return 'text-green-600';
  }

  getProjection(days: number): number {
    if (!this.selectedPoolId || this.amount <= 0) return 0;
    const pool = this.pools.find(p => p.id === this.selectedPoolId);
    if (!pool) return 0;
    return this.amount * Math.pow(1 + pool.interestRatePerDay, days);
  }
}