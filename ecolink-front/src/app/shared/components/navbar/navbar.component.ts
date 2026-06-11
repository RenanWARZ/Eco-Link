import { Component } from '@angular/core';
import { RouterLink, RouterLinkActive } from '@angular/router';

@Component({
  selector: 'app-navbar',
  standalone: true,
  imports: [RouterLink, RouterLinkActive],
  template: `
    <nav class="bottom-nav">
      <a routerLink="/home"        routerLinkActive="active" class="nav-item">
        <span class="nav-icon">⌂</span><span class="nav-label">Início</span>
      </a>
      <a routerLink="/mapa"        routerLinkActive="active" class="nav-item">
        <span class="nav-icon">◎</span><span class="nav-label">Mapa</span>
      </a>
      <a routerLink="/agendamento" routerLinkActive="active" class="nav-item nav-center">
        <span class="nav-fab">+</span>
      </a>
      <a routerLink="/denuncia"    routerLinkActive="active" class="nav-item">
        <span class="nav-icon">⚑</span><span class="nav-label">Denúncia</span>
      </a>
      <a routerLink="/pontuacao"   routerLinkActive="active" class="nav-item">
        <span class="nav-icon">◈</span><span class="nav-label">Pontos</span>
      </a>
    </nav>
  `,
  styles: [`
    .bottom-nav {
      position: fixed; bottom: 0; left: 0; right: 0;
      height: var(--nav-h);
      background: var(--white);
      border-top: 1px solid var(--line);
      display: flex; align-items: center; justify-content: space-around;
      z-index: 1000; padding: 0 4px;
      box-shadow: 0 -1px 12px rgba(15,23,17,.06);
    }
    .nav-item {
      display: flex; flex-direction: column; align-items: center; gap: 2px;
      text-decoration: none; padding: 6px 10px; border-radius: var(--r);
      transition: background .12s, color .12s; flex: 1;
    }
    .nav-item:hover { background: var(--green-bg); }
    .nav-icon { font-size: 17px; color: var(--ink-muted); line-height: 1; transition: color .12s, transform .15s; }
    .nav-label { font-size: 10px; font-weight: 500; color: var(--ink-muted); letter-spacing: .02em; }
    .nav-item.active .nav-icon { color: var(--green); transform: scale(1.1); }
    .nav-item.active .nav-label { color: var(--green); font-weight: 600; }

    /* FAB */
    .nav-center { flex: 0 0 52px; }
    .nav-fab {
      width: 44px; height: 44px;
      background: var(--green); color: #fff;
      border-radius: 50%;
      display: flex; align-items: center; justify-content: center;
      font-size: 22px; font-weight: 300; line-height: 1;
      box-shadow: 0 2px 10px rgba(45,122,58,.35);
      transition: transform .15s, box-shadow .15s;
      margin-top: -18px;
    }
    .nav-center:hover .nav-fab { transform: scale(1.08); box-shadow: 0 4px 14px rgba(45,122,58,.4); }
    .nav-center.active .nav-fab { background: var(--green-mid); }
  `]
})
export class NavbarComponent {}
