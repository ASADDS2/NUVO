import { Component, importProvidersFrom } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { LucideAngularModule, BarChart2, Users, Wallet, TrendingUp, PieChart, Shield, Mail, Phone, MapPin, CheckCircle, ArrowRight } from 'lucide-angular';

@Component({
    selector: 'app-landing',
    standalone: true,
    imports: [CommonModule, RouterLink, LucideAngularModule],
    providers: [
        importProvidersFrom(LucideAngularModule.pick({
            BarChart2, Users, Wallet, TrendingUp, PieChart, Shield, Mail, Phone, MapPin, CheckCircle, ArrowRight
        }))
    ],
    templateUrl: './landing.html',
    styleUrls: ['./landing.css']
})
export class LandingComponent {

    isDarkMode = true;

    toggleTheme() {
        this.isDarkMode = !this.isDarkMode;
    }

    features = [
        {
            icon: 'bar-chart-2',
            title: 'Dashboard Inteligente',
            desc: 'Visualiza métricas en tiempo real con gráficos interactivos y estadísticas detalladas.'
        },
        {
            icon: 'users',
            title: 'Gestión de Cuentas',
            desc: 'Administra cuentas bancarias con historial completo de transacciones y estados.'
        },
        {
            icon: 'wallet',
            title: 'Control de Préstamos',
            desc: 'Gestiona solicitudes de préstamos con seguimiento de estados y tasas de interés.'
        },
        {
            icon: 'trending-up',
            title: 'Inversión en Pools',
            desc: 'Permite a usuarios invertir en pools con tasas de retorno competitivas.'
        },
        {
            icon: 'pie-chart',
            title: 'Gestión de Pools',
            desc: 'Crea y administra piscinas de inversión con control total de parámetros.'
        },
        {
            icon: 'shield',
            title: 'Seguridad Avanzada',
            desc: 'Autenticación segura y protección de datos con las mejores prácticas.'
        }
    ];

    missionPoints = [
        'Acceso financiero para todos',
        'Tasas competitivas y justas',
        'Tecnología de vanguardia'
    ];

    visionPoints = [
        'Liderazgo regional',
        'Innovación continua',
        'Impacto social positivo'
    ];

    contactInfo = [
        {
            icon: 'mail',
            title: 'Email',
            value: 'contacto@nuvo.com'
        },
        {
            icon: 'phone',
            title: 'Teléfono',
            value: '+1 (555) 123-4567'
        },
        {
            icon: 'map-pin',
            title: 'Dirección',
            value: 'Av. Principal 123, Ciudad'
        }
    ];
}
