import { Component, OnInit, signal, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { AuthService } from '../../core/services/auth.service';
import { ActivityService } from '../../core/services/activity.service';
import { RankingService } from '../../core/services/ranking.service';
import { Activity, Ranking } from '../../core/models/index';
import { NavbarComponent } from '../../shared/components/navbar/navbar.component';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [CommonModule, RouterLink, NavbarComponent],
  template: `
    <div class="page-shell">
      <header class="home-header">
        <div class="header-inner">
          <div>
            <span class="greeting-hi">Olá, {{ firstName() }}</span>
            <h1 class="greeting-title">Bem-vindo ao EcoLink</h1>
          </div>
          <div class="pts-chip">
            <span class="pts-num">{{ user()?.points ?? 0 }}</span>
            <span class="pts-lbl">pts</span>
          </div>
        </div>
      </header>

      <div class="container">
        <div *ngIf="myRanking()" class="rank-strip card card-accent">
          <div class="rank-left">
            <span class="rank-medal">{{ medal(myRanking()?.rank ?? 99) || '#' + myRanking()?.rank }}</span>
            <div>
              <p class="rank-label">Sua posição</p>
              <p class="rank-pts">{{ myRanking()?.totalPoints }} pontos acumulados</p>
            </div>
          </div>
          <a routerLink="/ranking" class="rank-link">Ver ranking →</a>
        </div>

        <section class="actions-section">
          <p class="section-title">Ações</p>
          <div class="actions-grid">
            <a routerLink="/mapa"        class="action-card">
              <span class="action-icon" style="background:#eef6ef;color:#2d7a3a">◎</span>
              <span class="action-name">Pontos de Reciclagem</span>
            </a>
            <a routerLink="/agendamento" class="action-card">
              <span class="action-icon" style="background:#eff6ff;color:#2563eb">▦</span>
              <span class="action-name">Agendar Coleta</span>
            </a>
            <a routerLink="/denuncia"    class="action-card">
              <span class="action-icon" style="background:#fdecea;color:#c0392b">⚑</span>
              <span class="action-name">Registrar Denúncia</span>
            </a>
            <a routerLink="/ranking"     class="action-card">
              <span class="action-icon" style="background:#fef3c7;color:#d97706">◈</span>
              <span class="action-name">Ver Ranking</span>
            </a>
          </div>
        </section>

        <section>
          <p class="section-title">Atividades recentes</p>
          <div *ngIf="loadingActs()" class="empty-state"><p>Carregando…</p></div>
          <div *ngIf="!loadingActs() && activities().length === 0" class="empty-state">
            <div class="empty-icon">🌱</div>
            <p>Nenhuma atividade ainda.<br>Comece reciclando!</p>
          </div>
          <div *ngIf="!loadingActs() && activities().length > 0" class="act-list">
            <div class="act-item card" *ngFor="let a of activities().slice(0,5)">
              <span class="act-dot" [style.background]="typeColor(a.type)"></span>
              <div class="act-info">
                <p class="act-desc">{{ a.description }}</p>
                <p class="act-date">{{ a.createdAt | date:'dd MMM, HH:mm' }}</p>
              </div>
              <span *ngIf="a.pointsEarned" class="act-pts">+{{ a.pointsEarned }}</span>
            </div>
          </div>
        </section>
      </div>
      <app-navbar></app-navbar>
    </div>
  `,
  styles: [`
    .home-header {
      background: linear-gradient(135deg, #1a4d24, var(--green));
      padding: 52px 18px 24px;
    }
    .header-inner { display: flex; justify-content: space-between; align-items: flex-start; }
    .greeting-hi { display: block; font-size: 13px; color: rgba(255,255,255,.65); margin-bottom: 4px; }
    .greeting-title { font-family: var(--font-head); font-size: 20px; color: #fff; font-weight: 700; }
    .pts-chip {
      background: rgba(255,255,255,.15); border: 1px solid rgba(255,255,255,.2);
      border-radius: var(--r-lg); padding: 8px 14px; text-align: center;
      backdrop-filter: blur(4px);
    }
    .pts-num { display: block; font-family: var(--font-head); font-size: 20px; font-weight: 700; color: #fff; line-height: 1; }
    .pts-lbl { font-size: 10px; color: rgba(255,255,255,.6); text-transform: uppercase; letter-spacing: .05em; }

    .rank-strip { display: flex; align-items: center; justify-content: space-between; margin: 16px 0; padding: 14px 16px; }
    .rank-left { display: flex; align-items: center; gap: 12px; }
    .rank-medal { font-family: var(--font-head); font-size: 20px; font-weight: 700; color: var(--green); }
    .rank-label { font-size: 11px; color: var(--ink-muted); text-transform: uppercase; letter-spacing: .05em; }
    .rank-pts { font-size: 13px; font-weight: 600; color: var(--ink); margin-top: 1px; }
    .rank-link { font-size: 12px; font-weight: 600; color: var(--green); text-decoration: none; white-space: nowrap; }

    .actions-section { margin-top: 20px; }
    .actions-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
    .action-card {
      display: flex; align-items: center; gap: 12px;
      background: var(--white); border: 1px solid var(--line);
      border-radius: var(--r); padding: 14px; text-decoration: none;
      transition: transform .15s, box-shadow .15s; box-shadow: var(--sh-xs);
    }
    .action-card:hover { transform: translateY(-1px); box-shadow: var(--sh-sm); }
    .action-icon {
      width: 38px; height: 38px; border-radius: var(--r-sm);
      display: flex; align-items: center; justify-content: center;
      font-size: 16px; flex-shrink: 0;
    }
    .action-name { font-size: 13px; font-weight: 600; color: var(--ink); line-height: 1.35; }

    .act-list { display: flex; flex-direction: column; gap: 8px; margin-bottom: 16px; }
    .act-item { display: flex; align-items: center; gap: 12px; padding: 12px 14px; }
    .act-dot { width: 6px; height: 6px; border-radius: 50%; flex-shrink: 0; }
    .act-info { flex: 1; min-width: 0; }
    .act-desc { font-size: 13px; font-weight: 500; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; color: var(--ink); }
    .act-date { font-size: 11px; color: var(--ink-muted); margin-top: 1px; }
    .act-pts { font-size: 12px; font-weight: 700; color: var(--green); white-space: nowrap; }

    /* Tablet */
    @media (min-width: 768px) {
      .home-header { padding: 48px 28px 32px; }
      .greeting-title { font-size: 26px; }
      .pts-num { font-size: 24px; }
      .actions-grid { grid-template-columns: repeat(4, 1fr); gap: 14px; }
      .action-card { flex-direction: column; align-items: flex-start; gap: 10px; padding: 18px 16px; }
      .action-icon { width: 44px; height: 44px; font-size: 20px; }
      .action-name { font-size: 14px; }
      .rank-strip { padding: 18px 20px; }
    }

    /* Desktop */
    @media (min-width: 1024px) {
      .home-header { padding: 48px 40px 36px; }
      .greeting-title { font-size: 30px; }
      .act-list { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
    }
  `]
})
export class HomeComponent implements OnInit {
  private auth = inject(AuthService);
  private actSvc = inject(ActivityService);
  private rankSvc = inject(RankingService);
  user = this.auth.currentUser;
  activities = signal<Activity[]>([]);
  myRanking = signal<Ranking | null>(null);
  loadingActs = signal(true);

  firstName(): string { return this.user()?.name?.split(' ')[0] ?? 'Olá'; }

  ngOnInit(): void {
    const uid = this.auth.getCurrentUserId();
    if (!uid) return;
    this.actSvc.getByUserId(uid).subscribe({ next: (a: Activity[]) => { this.activities.set(a); this.loadingActs.set(false); }, error: () => this.loadingActs.set(false) });
    this.rankSvc.getByUserId(uid).subscribe({ next: (r: Ranking) => this.myRanking.set(r), error: () => {} });
  }

  medal(pos: number): string { return ({ 1: '🥇', 2: '🥈', 3: '🥉' } as Record<number, string>)[pos] ?? ''; }
  typeColor(type: string): string { return ({ SCHEDULE: '#2563eb', COMPLAINT: '#c0392b', RECYCLING: '#2d7a3a', ACHIEVEMENT: '#d97706' } as Record<string, string>)[type] ?? '#8fa593'; }
}
