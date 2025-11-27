import { Component, OnInit, inject, ChangeDetectorRef, importProvidersFrom } from '@angular/core';
import { CommonModule } from '@angular/common';
import { DataService } from '../../services/data';
import { LucideAngularModule, Users, DollarSign, CreditCard, Layers, TrendingUp, Activity, PieChart, Download, Plus } from 'lucide-angular';
import { BaseChartDirective } from 'ng2-charts';
import { ChartConfiguration, ChartData, ChartType } from 'chart.js';

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [
    CommonModule,
    LucideAngularModule,
    BaseChartDirective
  ],
  providers: [
    importProvidersFrom(LucideAngularModule.pick({
      Users, DollarSign, CreditCard, Layers, TrendingUp, Activity, PieChart, Download, Plus
    }))
  ],
  templateUrl: './dashboard.html',
  styleUrls: ['./dashboard.css']
})
export class DashboardComponent implements OnInit {
  private dataService = inject(DataService);
  private cdr = inject(ChangeDetectorRef);

  totalUsers = 0;
  totalMoney = 0;
  isLoading = true;

  // Line Chart Configuration
  public lineChartData: ChartConfiguration<'line'>['data'] = {
    labels: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul'],
    datasets: [
      {
        data: [65, 59, 80, 81, 56, 55, 40],
        label: 'Usuarios Activos',
        fill: true,
        tension: 0.4,
        borderColor: '#00E676',
        backgroundColor: 'rgba(0, 230, 118, 0.1)',
        pointBackgroundColor: '#00E676',
        pointBorderColor: '#fff',
        pointHoverBackgroundColor: '#fff',
        pointHoverBorderColor: 'rgba(148,159,177,0.8)'
      }
    ]
  };

  public lineChartOptions: ChartConfiguration<'line'>['options'] = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: { display: false },
      tooltip: {
        backgroundColor: 'rgba(0,0,0,0.8)',
        titleColor: '#fff',
        bodyColor: '#fff',
        padding: 10,
        cornerRadius: 8,
        displayColors: false
      }
    },
    scales: {
      x: {
        grid: { color: 'rgba(255,255,255,0.05)' },
        ticks: { color: '#888' }
      },
      y: {
        grid: { color: 'rgba(255,255,255,0.05)' },
        ticks: { color: '#888' },
        beginAtZero: true
      }
    }
  };

  // Doughnut Chart Configuration
  public doughnutChartData: ChartData<'doughnut'> = {
    labels: ['Aprobados', 'Pendientes', 'Rechazados'],
    datasets: [
      {
        data: [350, 45, 20],
        backgroundColor: ['#00E676', '#EAB308', '#EF4444'],
        hoverBackgroundColor: ['#00c865', '#CA8A04', '#DC2626'],
        borderWidth: 0,
        hoverOffset: 4
      }
    ]
  };

  public doughnutChartOptions: ChartConfiguration<'doughnut'>['options'] = {
    responsive: true,
    maintainAspectRatio: false,
    cutout: '75%',
    plugins: {
      legend: { display: false }
    }
  };

  constructor() {
    // Register icons
    // Note: In standalone components with LucideAngularModule, icons are usually imported in the imports array
    // or registered in a provider if using a global registry. 
    // Here we import the module which should handle it if configured correctly, 
    // but for specific icons we might need to import them.
    // However, LucideAngularModule usually works with icons as components or via name if configured.
    // Let's assume standard usage for now.
  }

  ngOnInit() {
    console.log('📊 Cargando Dashboard...');

    this.dataService.getAllAccounts().subscribe({
      next: (data: any) => {
        console.log('✅ Dashboard recibió datos:', data);

        if (Array.isArray(data)) {
          this.totalUsers = data.length;
          this.totalMoney = data.reduce((acc: number, curr: any) => acc + (curr.balance || 0), 0);
        }

        this.isLoading = false;
        this.cdr.detectChanges();
      },
      error: (err: any) => {
        console.error('❌ Error en Dashboard:', err);
        this.isLoading = false;
        this.cdr.detectChanges();
      }
    });
  }
}