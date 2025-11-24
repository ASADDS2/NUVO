import { Routes } from '@angular/router';
import { LoginComponent } from './pages/login/login';
import { LayoutComponent } from './components/layout/layout';
import { DashboardComponent } from './pages/dashboard/dashboard';
import { AccountsComponent } from './pages/accounts/accounts';
import { LoansComponent } from './pages/loans/loans';
import { PoolComponent } from './pages/pool/pool';

export const routes: Routes = [
    { path: 'login', component: LoginComponent },
    
    // Rutas protegidas (dentro del Layout)
    { 
        path: '', 
        component: LayoutComponent,
        children: [
            { path: 'dashboard', component: DashboardComponent },
            { path: 'accounts', component: AccountsComponent },
            { path: 'loans', component: LoansComponent },
            { path: 'pool', component: PoolComponent },
            { path: '', redirectTo: 'dashboard', pathMatch: 'full' } // Por defecto ir al dashboard
        ]
    }
];