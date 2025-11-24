import { Component, OnInit, inject, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { DataService } from '../../services/data';

@Component({
  selector: 'app-pool',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './pool.html',
})
export class PoolComponent implements OnInit {
  private dataService = inject(DataService);
  private cdr = inject(ChangeDetectorRef); // ⚡

  investments: any[] = [];
  isLoading = true;

  ngOnInit() {
    this.loadInvestments();
  }

  loadInvestments() {
    console.log('🏊 Cargando Inversiones...');
    this.isLoading = true;

    this.dataService.getAllInvestments().subscribe({
      next: (data: any) => {
        console.log('✅ Inversiones recibidas:', data);

        if (Array.isArray(data)) {
          this.investments = data;
        } else {
          this.investments = data.content || [];
        }

        this.isLoading = false;
        this.cdr.detectChanges(); // ⚡
      },
      error: (err: any) => {
        console.error('❌ Error cargando inversiones:', err);
        this.isLoading = false;
        this.cdr.detectChanges();
      }
    });
  }
}