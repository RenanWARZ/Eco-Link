import { Routes } from '@angular/router';

export const routes: Routes = [
  {
    path: '',
    redirectTo: 'login',
    pathMatch: 'full'
  },
  {
    path: 'login',
    loadComponent: () => import('./features/auth/login.component').then(m => m.LoginComponent)
  },
  {
    path: 'home',
    loadComponent: () => import('./features/home/home.component').then(m => m.HomeComponent)
  },
  {
    path: 'mapa',
    loadComponent: () => import('./features/mapa/mapa.component').then(m => m.MapaComponent)
  },
  {
    path: 'pontuacao',
    loadComponent: () => import('./features/pontuacao/pontuacao.component').then(m => m.PontuacaoComponent)
  },
  {
    path: 'denuncia',
    loadComponent: () => import('./features/denuncia/denuncia.component').then(m => m.DenunciaComponent)
  },
  {
    path: 'agendamento',
    loadComponent: () => import('./features/agendamento/agendamento.component').then(m => m.AgendamentoComponent)
  },
  {
    path: 'ranking',
    loadComponent: () => import('./features/ranking/ranking.component').then(m => m.RankingComponent)
  },
  {
    path: '**',
    redirectTo: 'home'
  }
];
