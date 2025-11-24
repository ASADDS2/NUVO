import { Component, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterOutlet, RouterLink, RouterLinkActive, Router } from '@angular/router';
// CORRECCIÓN 1: El archivo se llama 'auth', no 'auth.service'
import { AuthService } from '../../services/auth'; 

@Component({
  selector: 'app-layout',
  standalone: true,
  imports: [CommonModule, RouterOutlet, RouterLink, RouterLinkActive],
  // CORRECCIÓN 2: El archivo se llama 'layout.html', no 'layout.component.html'
  templateUrl: './layout.html', 
})
export class LayoutComponent {
  private authService = inject(AuthService);
  private router = inject(Router);

  onLogout() {
    this.authService.logout();
    this.router.navigate(['/login']);
  }
}