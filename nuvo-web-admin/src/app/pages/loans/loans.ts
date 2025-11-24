import { Component, OnInit, inject, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { DataService } from '../../services/data';

@Component({
  selector: 'app-loans',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './loans.html',
})
export class LoansComponent implements OnInit {
  private dataService = inject(DataService);
  private cdr = inject(ChangeDetectorRef); // ⚡

  loans: any[] = [];
  isLoading = true;

  ngOnInit() {
    this.loadLoans();
  }

  loadLoans() {
    console.log('💸 Cargando Préstamos...');
    this.isLoading = true;

    this.dataService.getAllLoans().subscribe({
      next: (data: any) => {
        console.log('✅ Préstamos recibidos:', data);
        
        if (Array.isArray(data)) {
          this.loans = data;
        } else {
          this.loans = data.content || [];
        }

        this.isLoading = false;
        this.cdr.detectChanges(); // ⚡
      },
      error: (err: any) => {
        console.error('❌ Error cargando préstamos:', err);
        this.isLoading = false;
        this.cdr.detectChanges();
      }
    });
  }

  onApprove(id: number) {
    if(!confirm('¿Aprobar préstamo?')) return;

    this.dataService.approveLoan(id).subscribe({
      next: (res: any) => {
        alert('¡Aprobado!');
        this.loadLoans();
      },
      error: (err: any) => alert('Error al aprobar')
    });
  }
}