import { Component } from '@angular/core';
import { RouterLink, RouterLinkActive } from '@angular/router';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-navbar',
  standalone: true,
  imports: [RouterLink, RouterLinkActive, CommonModule],
  template: `
    <nav class="bottom-nav">
      <a routerLink="/home" routerLinkActive="active" class="nav-item">
        <span class="nav-icon">🏠</span>
        <span class="nav-label">Home</span>
      </a>
      <a routerLink="/mapa" routerLinkActive="active" class="nav-item">
        <span class="nav-icon">📍</span>
        <span class="nav-label">Mapa</span>
      </a>
      <a routerLink="/agendamento" routerLinkActive="active" class="nav-item">
        <span class="nav-icon">📅</span>
        <span class="nav-label">Agendar</span>
      </a>
      <a routerLink="/denuncia" routerLinkActive="active" class="nav-item">
        <span class="nav-icon">🚨</span>
        <span class="nav-label">Denúncia</span>
      </a>
      <a routerLink="/pontuacao" routerLinkActive="active" class="nav-item">
        <span class="nav-icon">⭐</span>
        <span class="nav-label">Pontos</span>
      </a>
    </nav>
  `,
  styles: [`
    .bottom-nav {
      position: fixed; bottom: 0; left: 0; right: 0;
      height: var(--nav-h); background: #fff;
      border-top: 1px solid var(--gray-100);
      display: flex; align-items: center; justify-content: space-around;
      z-index: 1000; padding: 0 8px;
      box-shadow: 0 -4px 20px rgba(0,0,0,.06);
    }
    .nav-item {
      display: flex; flex-direction: column; align-items: center; gap: 2px;
      text-decoration: none; padding: 8px 12px; border-radius: var(--radius-sm);
      transition: all .15s; min-width: 56px;
    }
    .nav-icon { font-size: 20px; line-height: 1; transition: transform .15s; }
    .nav-label { font-size: 10px; font-weight: 600; color: var(--gray-500); text-transform: uppercase; letter-spacing: .04em; }
    .nav-item.active .nav-icon { transform: scale(1.15); }
    .nav-item.active .nav-label { color: var(--green-500); }
    .nav-item:hover { background: var(--green-50); }
  `]
})
export class NavbarComponent {}
