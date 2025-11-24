import { Component, OnInit, inject, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { DataService } from '../../services/data';

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './dashboard.html',
})
export class DashboardComponent implements OnInit {
  private dataService = inject(DataService);
  private cdr = inject(ChangeDetectorRef); // ⚡ Inyección para forzar UI

  totalUsers = 0;
  totalMoney = 0;
  isLoading = true; // Variable para controlar spinner si lo usas

  ngOnInit() {
    console.log('📊 Cargando Dashboard...');
    
    this.dataService.getAllAccounts().subscribe({
      next: (data: any) => {
        console.log('✅ Dashboard recibió datos:', data);

        if (Array.isArray(data)) {
          this.totalUsers = data.length;
          // Sumar saldos: Se asume que el campo se llama 'balance'
          this.totalMoney = data.reduce((acc: number, curr: any) => acc + (curr.balance || 0), 0);
        }

        this.isLoading = false;
        this.cdr.detectChanges(); // ⚡ Actualizar vista
      },
      error: (err: any) => {
        console.error('❌ Error en Dashboard:', err);
        this.isLoading = false;
        this.cdr.detectChanges();
      }
    });
  }
}