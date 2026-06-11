import { Component } from '@angular/core';
import { RouterLink, RouterLinkActive, RouterOutlet } from '@angular/router';

@Component({
  selector: 'app-layout',
  standalone: true,
  imports: [RouterOutlet, RouterLink, RouterLinkActive],
  template: `
    <div class="app-layout">
      <!-- Sidebar — only visible on desktop via CSS -->
      <aside class="sidebar">
        <div class="sidebar-brand">
          <span class="sidebar-brand-icon">☘</span>
          <span class="sidebar-brand-name">EcoLink</span>
        </div>
        <nav class="sidebar-nav">
          <a routerLink="/home"        routerLinkActive="active" class="sidebar-item">
            <span class="s-icon">⌂</span><span class="s-label">Início</span>
          </a>
          <a routerLink="/mapa"        routerLinkActive="active" class="sidebar-item">
            <span class="s-icon">◎</span><span class="s-label">Mapa</span>
          </a>
          <a routerLink="/agendamento" routerLinkActive="active" class="sidebar-item sidebar-fab">
            <span class="s-fab-dot">+</span><span class="s-label">Agendar Coleta</span>
          </a>
          <a routerLink="/denuncia"    routerLinkActive="active" class="sidebar-item">
            <span class="s-icon">⚑</span><span class="s-label">Denúncia</span>
          </a>
          <a routerLink="/pontuacao"   routerLinkActive="active" class="sidebar-item">
            <span class="s-icon">◈</span><span class="s-label">Pontuação</span>
          </a>
          <a routerLink="/ranking"     routerLinkActive="active" class="sidebar-item">
            <span class="s-icon">🏆</span><span class="s-label">Ranking</span>
          </a>
        </nav>
        <p class="sidebar-footer">Maringá · PR</p>
      </aside>

      <!-- Main content area -->
      <main class="main-content">
        <router-outlet />
      </main>

      <!-- Bottom nav — only visible on mobile/tablet via CSS -->
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
    </div>
  `,
  styles: [`
    /* ── Shell ─────────────────────────────── */
    .app-layout {
      min-height: 100vh;
      position: relative;
    }

    /* ── Sidebar (hidden on mobile/tablet) ── */
    .sidebar {
      display: none;
    }

    /* ── Main content ───────────────────────── */
    .main-content {
      min-height: 100vh;
      padding-bottom: calc(var(--nav-h) + 24px);
    }

    /* ── Bottom Nav (mobile/tablet) ─────────── */
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
      transition: background .12s; flex: 1;
    }
    .nav-item:hover { background: var(--green-bg); }
    .nav-icon { font-size: 17px; color: var(--ink-muted); line-height: 1; transition: color .12s, transform .15s; }
    .nav-label { font-size: 10px; font-weight: 500; color: var(--ink-muted); letter-spacing: .02em; }
    .nav-item.active .nav-icon { color: var(--green); transform: scale(1.1); }
    .nav-item.active .nav-label { color: var(--green); font-weight: 600; }
    .nav-center { flex: 0 0 52px; }
    .nav-fab {
      width: 44px; height: 44px;
      background: var(--green); color: #fff; border-radius: 50%;
      display: flex; align-items: center; justify-content: center;
      font-size: 22px; font-weight: 300; line-height: 1;
      box-shadow: 0 2px 10px rgba(45,122,58,.35);
      transition: transform .15s, box-shadow .15s;
      margin-top: -18px;
    }
    .nav-center:hover .nav-fab { transform: scale(1.08); }
    .nav-center.active .nav-fab { background: var(--green-mid); }

    /* ── Desktop ≥ 1024px ─────────────────── */
    @media (min-width: 1024px) {
      .app-layout {
        display: flex;
        flex-direction: row;
      }

      /* Show sidebar */
      .sidebar {
        display: flex;
        flex-direction: column;
        width: 240px;
        min-width: 240px;
        background: var(--white);
        border-right: 1px solid var(--line);
        position: fixed;
        top: 0; left: 0; bottom: 0;
        height: 100vh;
        padding: 24px 12px;
        box-shadow: 1px 0 12px rgba(15,23,17,.05);
        z-index: 100;
        overflow-y: auto;
      }

      .sidebar-brand {
        display: flex; align-items: center; gap: 10px;
        padding: 8px 12px 20px;
        border-bottom: 1px solid var(--line);
        margin-bottom: 8px;
      }
      .sidebar-brand-icon { font-size: 20px; }
      .sidebar-brand-name {
        font-family: var(--font-head); font-size: 18px; font-weight: 700; color: var(--green);
      }

      .sidebar-nav { display: flex; flex-direction: column; gap: 2px; flex: 1; }
      .sidebar-item {
        display: flex; align-items: center; gap: 12px;
        padding: 11px 14px; border-radius: var(--r);
        text-decoration: none; transition: background .12s;
      }
      .sidebar-item:hover { background: var(--green-bg); }
      .sidebar-item.active { background: var(--green-bg); }
      .sidebar-item.active .s-icon { color: var(--green); }
      .sidebar-item.active .s-label { color: var(--green); font-weight: 600; }
      .s-icon { font-size: 16px; color: var(--ink-muted); width: 20px; text-align: center; flex-shrink: 0; }
      .s-label { font-size: 14px; font-weight: 500; color: var(--ink-soft); }

      /* Agendar item with green dot */
      .sidebar-fab .s-fab-dot {
        width: 28px; height: 28px;
        background: var(--green); color: #fff;
        border-radius: var(--r-sm);
        display: flex; align-items: center; justify-content: center;
        font-size: 18px; flex-shrink: 0;
      }
      .sidebar-fab.active .s-label,
      .sidebar-fab:hover .s-label { color: var(--green); }

      .sidebar-footer {
        font-size: 11px; color: var(--ink-muted);
        padding: 16px 14px 0;
        border-top: 1px solid var(--line);
        margin-top: 8px;
      }

      /* Hide bottom nav */
      .bottom-nav { display: none !important; }

      /* Main content shifts right */
      .main-content {
        margin-left: 240px;
        width: calc(100% - 240px);
        padding-bottom: 40px;
      }
    }

    /* ── Tablet 768–1023px ───────────────── */
    @media (min-width: 768px) and (max-width: 1023px) {
      .main-content {
        padding-bottom: calc(var(--nav-h) + 32px);
      }
    }
  `]
})
export class LayoutComponent {}
