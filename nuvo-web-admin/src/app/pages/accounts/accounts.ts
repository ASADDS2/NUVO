import { Component, OnInit, inject, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { DataService } from '../../services/data';

@Component({
  selector: 'app-accounts',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './accounts.html',
})
export class AccountsComponent implements OnInit {
  private dataService = inject(DataService);
  private cdr = inject(ChangeDetectorRef); // ⚡

  accounts: any[] = [];
  isLoading = true;

  ngOnInit() {
    this.loadAccounts();
  }

  loadAccounts() {
    console.log('👥 Cargando Cuentas...');
    this.isLoading = true;

    this.dataService.getAllAccounts().subscribe({
      next: (data: any) => {
        console.log('✅ Cuentas recibidas:', data);
        
        if (Array.isArray(data)) {
          this.accounts = data;
        } else {
          // Fallback por si viene envuelto en un objeto
          this.accounts = data.content || [];
        }

        this.isLoading = false;
        this.cdr.detectChanges(); // ⚡ Fuerza la actualización
      },
      error: (err: any) => {
        console.error('❌ Error cargando cuentas:', err);
        this.isLoading = false;
        this.cdr.detectChanges();
      }
    });
  }
}