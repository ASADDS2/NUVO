import { Component, OnInit, OnDestroy, inject, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { DataService } from '../../services/data';
import { Pool, PoolStats, CreatePoolRequest } from '../../models/pool.model';

@Component({
  selector: 'app-pool-management',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './pool-management.html',
  styleUrl: './pool-management.css'
})
export class PoolManagementComponent implements OnInit, OnDestroy {
  private dataService = inject(DataService);
  private cdr = inject(ChangeDetectorRef);

  pools: PoolStats[] = [];
  isLoading = true;
  showForm = false;
  selectedPool: Pool | null = null;
  lastUpdate: Date = new Date();
  autoRefreshInterval: any;
  uiUpdateInterval: any;

  newPool: CreatePoolRequest = {
    name: '',
    description: '',
    interestRatePerDay: 0.01,
    maxParticipants: 50
  };

  ngOnInit() {
    this.loadPools();
    
    // Auto-refresh de datos cada 10 segundos
    this.autoRefreshInterval = setInterval(() => {
      this.loadPools(true);
    }, 10000);
    
    // Actualizar UI cada segundo para mostrar timestamp actualizado
    this.uiUpdateInterval = setInterval(() => {
      this.cdr.detectChanges();
    }, 1000);
  }

  ngOnDestroy() {
    if (this.autoRefreshInterval) {
      clearInterval(this.autoRefreshInterval);
    }
    if (this.uiUpdateInterval) {
      clearInterval(this.uiUpdateInterval);
    }
  }

  loadPools(silent: boolean = false) {
    console.log('⚙️ [PoolManagement] Iniciando carga de pools...');
    if (!silent) {
      this.isLoading = true;
    }
    
    this.dataService.getAllPools().subscribe({
      next: (data) => {
        console.log('✅ [PoolManagement] Pools recibidos:', data);
        console.log('📊 [PoolManagement] Total de pools:', data?.length || 0);
        this.pools = data;
        this.lastUpdate = new Date();
        if (!silent) {
          this.isLoading = false;
        }
        this.cdr.detectChanges();
      },
      error: (err) => {
        console.error('❌ [PoolManagement] Error cargando pools:', err);
        console.error('❌ [PoolManagement] Status:', err.status);
        console.error('❌ [PoolManagement] Message:', err.message);
        if (!silent) {
          alert(`Error al cargar pools: ${err.message || 'Error desconocido'}`);
          this.isLoading = false;
        }
        this.cdr.detectChanges();
      }
    });
  }

  openCreateForm() {
    this.showForm = true;
    this.selectedPool = null;
    this.newPool = {
      name: '',
      description: '',
      interestRatePerDay: 0.01,
      maxParticipants: 50
    };
  }

  openEditForm(pool: Pool) {
    this.showForm = true;
    this.selectedPool = pool;
    this.newPool = {
      name: pool.name,
      description: pool.description,
      interestRatePerDay: pool.interestRatePerDay,
      maxParticipants: pool.maxParticipants
    };
  }

  closeForm() {
    this.showForm = false;
    this.selectedPool = null;
  }

  createPool() {
    if (!this.newPool.name) {
      alert('El nombre es requerido');
      return;
    }

    this.dataService.createPool(this.newPool).subscribe({
      next: () => {
        alert('Pool creado exitosamente');
        this.closeForm();
        this.loadPools();
      },
      error: (err) => {
        console.error('Error creando pool:', err);
        alert(err.error || 'Error al crear pool');
      }
    });
  }

  updatePool() {
    if (!this.selectedPool) return;

    this.dataService.updatePool(this.selectedPool.id, {
      name: this.newPool.name,
      description: this.newPool.description,
      maxParticipants: this.newPool.maxParticipants
    }).subscribe({
      next: () => {
        alert('Pool actualizado exitosamente');
        this.closeForm();
        this.loadPools();
      },
      error: (err) => {
        console.error('Error actualizando pool:', err);
        alert(err.error || 'Error al actualizar pool');
      }
    });
  }

  deletePool(pool: Pool) {
    if (!confirm(`¿Estás seguro de eliminar "${pool.name}"?\n\nATENCIÓN: Todas las inversiones activas serán retiradas automáticamente.`)) {
      return;
    }

    this.dataService.deletePool(pool.id).subscribe({
      next: () => {
        alert('Pool eliminado exitosamente');
        this.loadPools();
      },
      error: (err) => {
        console.error('Error eliminando pool:', err);
        alert(err.error || 'Error al eliminar pool');
      }
    });
  }

  toggleStatus(pool: Pool) {
    this.dataService.updatePool(pool.id, {
      active: !pool.active
    }).subscribe({
      next: () => {
        pool.active = !pool.active;
        alert(`Pool ${pool.active ? 'activado' : 'desactivado'}`);
      },
      error: (err) => {
        console.error('Error actualizando estado:', err);
        alert('Error al cambiar estado');
      }
    });
  }

  getPercentageFilled(stats: PoolStats): number {
    return (stats.currentInvestors / stats.pool.maxParticipants) * 100;
  }

  getStatusColor(pool: Pool, percentage: number): string {
    if (!pool.active) return 'bg-gray-100 text-gray-600';
    if (percentage >= 100) return 'bg-red-100 text-red-700';
    if (percentage >= 80) return 'bg-yellow-100 text-yellow-700';
    return 'bg-green-100 text-green-700';
  }

  getInterestGain(stats: PoolStats): number {
    if (stats.totalInvested === 0) return 0;
    return ((stats.totalCurrentValue - stats.totalInvested) / stats.totalInvested) * 100;
  }

  getTimeSinceUpdate(): string {
    const seconds = Math.floor((new Date().getTime() - this.lastUpdate.getTime()) / 1000);
    if (seconds < 5) return 'ahora';
    return `hace ${seconds}s`;
  }
}
