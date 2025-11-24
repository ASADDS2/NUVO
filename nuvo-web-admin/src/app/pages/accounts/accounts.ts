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

  // --- MODAL LOGIC ---
  showModal = false;
  selectedAccount: any = null;
  selectedUser: any = null; // 👤 Nuevo
  userLoans: any[] = [];
  isLoadingLoans = false;

  openModal(account: any) {
    this.selectedAccount = account;
    this.showModal = true;
    this.isLoadingLoans = true;
    this.userLoans = [];
    this.selectedUser = null; // Reset

    // 1. Cargar Préstamos
    this.dataService.getLoansByUserId(account.userId).subscribe({
      next: (loans: any[]) => {
        this.userLoans = loans;
        this.isLoadingLoans = false;
        this.cdr.detectChanges();
      },
      error: (err) => {
        console.error('Error fetching loans', err);
        this.isLoadingLoans = false;
        this.cdr.detectChanges();
      }
    });

    // 2. Cargar Datos del Usuario
    this.dataService.getUserById(account.userId).subscribe({
      next: (user: any) => {
        console.log('👤 Usuario cargado:', user);
        this.selectedUser = user;
        this.cdr.detectChanges();
      },
      error: (err) => {
        console.error('Error fetching user', err);
      }
    });
  }

  closeModal() {
    this.showModal = false;
    this.selectedAccount = null;
    this.selectedUser = null;
    this.userLoans = [];
  }
}