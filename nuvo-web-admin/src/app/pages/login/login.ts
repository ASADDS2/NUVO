import { Component, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { AuthService } from '../../services/auth';
import { Router } from '@angular/router';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './login.html',
})
export class LoginComponent {
  private authService = inject(AuthService);
  private router = inject(Router);

  email = 'bruno@nuvo.com'; // Pre-llenado para probar
  password = 'password123';
  isLoading = false;
  errorMessage = '';

  onLogin() {
    this.isLoading = true;
    this.errorMessage = '';

    this.authService.login(this.email, this.password).subscribe({
      next: () => {
        this.isLoading = false;
        alert('¡LOGIN EXITOSO! Token guardado.');
        this.router.navigate(['/dashboard']);
        // this.router.navigate(['/dashboard']); // Descomentar luego
      },
      error: (err) => {
        this.isLoading = false;
        console.error(err);
        this.errorMessage = 'Credenciales incorrectas o error de conexión.';
      }
    });
  }
}