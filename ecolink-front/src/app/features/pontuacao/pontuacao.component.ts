import { Component, OnInit, signal, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivityService } from '../../core/services/activity.service';
import { AuthService } from '../../core/services/auth.service';
import { Activity } from '../../core/models/index';
import { NavbarComponent } from '../../shared/components/navbar/navbar.component';

@Component({
  selector: 'app-pontuacao',
  standalone: true,
  imports: [CommonModule, NavbarComponent],
  template: `
    <div class="page-shell">
      <header class="pts-header">
        <div class="pts-hero">
          <div>
            <span class="pts-eyebrow">Gamificação</span>
            <div class="pts-display">
              <span class="pts-big">{{ user()?.points ?? 0 }}</span>
              <span class="pts-unit">pts</span>
            </div>
            <span class="level-tag">{{ currentLevel() }}</span>
          </div>
          <div class="prog-block">
            <div class="prog-bar"><div class="prog-fill" [style.width.%]="progressPct()"></div></div>
            <p class="prog-label">{{ nextLevelMsg() }}</p>
          </div>
        </div>
      </header>

      <div class="container">
        <div class="pts-layout">
          <!-- Achievements -->
          <div class="ach-col">
            <p class="section-title">Conquistas</p>
            <div class="ach-grid">
              <div class="ach-item" *ngFor="let a of achievements" [class.unlocked]="isUnlocked(a.pts)">
                <span class="ach-icon">{{ a.icon }}</span>
                <span class="ach-name">{{ a.name }}</span>
                <span class="ach-pts">{{ a.pts }} pts</span>
              </div>
            </div>
          </div>

          <!-- History -->
          <div class="hist-col">
            <p class="section-title">Histórico</p>
            <div *ngIf="loading()" class="empty-state"><p>Carregando…</p></div>
            <div *ngIf="!loading() && activities().length === 0" class="empty-state">
              <div class="empty-icon">🌱</div><p>Nenhuma atividade ainda.</p>
            </div>
            <div *ngIf="!loading() && activities().length > 0" class="hist-list">
              <div class="hist-item card" *ngFor="let a of activities()">
                <div class="hist-dot" [style.background]="typeColor(a.type)"></div>
                <div class="hist-info">
                  <p class="hist-desc">{{ a.description }}</p>
                  <p class="hist-date">{{ a.createdAt | date:'dd/MM/yyyy' }}</p>
                </div>
                <span *ngIf="a.pointsEarned" class="hist-pts badge badge-green">+{{ a.pointsEarned }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
      <app-navbar></app-navbar>
    </div>
  `,
  styles: [`
    .pts-header {
      background: linear-gradient(135deg, #1a4d24, var(--green));
      padding: 52px 18px 28px; color: #fff;
    }
    .pts-hero { }
    .pts-eyebrow { font-size: 11px; opacity: .6; text-transform: uppercase; letter-spacing: .07em; }
    .pts-display { display: flex; align-items: baseline; gap: 6px; margin: 6px 0 8px; }
    .pts-big { font-family: var(--font-head); font-size: 52px; font-weight: 700; line-height: 1; }
    .pts-unit { font-size: 18px; opacity: .7; }
    .level-tag { display: inline-block; background: rgba(255,255,255,.2); border-radius: 99px; padding: 3px 12px; font-size: 12px; font-weight: 600; margin-bottom: 16px; }
    .prog-bar { height: 4px; background: rgba(255,255,255,.25); border-radius: 99px; overflow: hidden; margin-bottom: 6px; }
    .prog-fill { height: 100%; background: #fff; border-radius: 99px; transition: width .4s ease; }
    .prog-label { font-size: 12px; opacity: .65; }

    /* Layout */
    .pts-layout { display: flex; flex-direction: column; }

    .ach-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px; margin-bottom: 24px; }
    .ach-item {
      display: flex; flex-direction: column; align-items: center; gap: 4px;
      background: var(--white); border: 1px solid var(--line); border-radius: var(--r);
      padding: 14px 8px; opacity: .35; transition: opacity .2s;
    }
    .ach-item.unlocked { opacity: 1; border-color: var(--green-line); }
    .ach-icon { font-size: 24px; }
    .ach-name { font-size: 11px; font-weight: 600; color: var(--ink); text-align: center; }
    .ach-pts { font-size: 10px; color: var(--ink-muted); }

    .hist-list { display: flex; flex-direction: column; gap: 8px; margin-bottom: 16px; }
    .hist-item { display: flex; align-items: center; gap: 12px; padding: 12px 14px; }
    .hist-dot { width: 6px; height: 6px; border-radius: 50%; flex-shrink: 0; }
    .hist-info { flex: 1; min-width: 0; }
    .hist-desc { font-size: 13px; font-weight: 500; color: var(--ink); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
    .hist-date { font-size: 11px; color: var(--ink-muted); margin-top: 1px; }
    .hist-pts { font-size: 11px; white-space: nowrap; }

    /* Tablet */
    @media (min-width: 768px) {
      .pts-header { padding: 48px 28px 32px; }
      .pts-big { font-size: 64px; }
      .ach-grid { grid-template-columns: repeat(6, 1fr); }
    }

    /* Desktop */
    @media (min-width: 1024px) {
      .pts-header { padding: 48px 40px 36px; }
      .pts-layout { flex-direction: row; gap: 32px; align-items: flex-start; margin-top: 20px; }
      .ach-col { flex: 0 0 340px; }
      .ach-grid { grid-template-columns: repeat(3, 1fr); }
      .hist-col { flex: 1; min-width: 0; }
    }
  `]
})
export class PontuacaoComponent implements OnInit {
  private auth = inject(AuthService);
  private actSvc = inject(ActivityService);
  user = this.auth.currentUser;
  activities = signal<Activity[]>([]);
  loading = signal(true);

  achievements = [
    { icon: '🌱', name: 'Iniciante',    pts: 50   },
    { icon: '♻️', name: 'Reciclador',   pts: 200  },
    { icon: '🚲', name: 'Eco Rider',    pts: 500  },
    { icon: '🌍', name: 'Guardião',     pts: 1000 },
    { icon: '⭐', name: 'Estrela Verde', pts: 2000 },
    { icon: '🏆', name: 'Campeão',      pts: 5000 },
  ];

  ngOnInit(): void {
    const uid = this.auth.getCurrentUserId();
    if (!uid) return;
    this.actSvc.getUserHistory(uid).subscribe({ next: (a: Activity[]) => { this.activities.set(a); this.loading.set(false); }, error: () => this.loading.set(false) });
  }

  currentLevel(): string {
    const p = this.user()?.points ?? 0;
    if (p < 50)   return '🌱 Iniciante';
    if (p < 200)  return '♻️ Reciclador';
    if (p < 500)  return '🚲 Eco Rider';
    if (p < 1000) return '🌍 Guardião';
    if (p < 2000) return '⭐ Estrela Verde';
    return '🏆 Campeão Eco';
  }

  nextLevelMsg(): string {
    const p = this.user()?.points ?? 0;
    const t = [50, 200, 500, 1000, 2000].find(n => p < n);
    return t ? `Faltam ${t - p} pts para o próximo nível` : 'Nível máximo atingido!';
  }

  progressPct(): number {
    const p = this.user()?.points ?? 0;
    const lvs = [0, 50, 200, 500, 1000, 2000];
    for (let i = 0; i < lvs.length - 1; i++) {
      if (p >= lvs[i] && p < lvs[i+1]) return Math.round(((p - lvs[i]) / (lvs[i+1] - lvs[i])) * 100);
    }
    return 100;
  }

  isUnlocked(pts: number): boolean { return (this.user()?.points ?? 0) >= pts; }
  typeColor(type: string): string { return ({ SCHEDULE: '#2563eb', COMPLAINT: '#c0392b', RECYCLING: '#2d7a3a', ACHIEVEMENT: '#d97706' } as Record<string,string>)[type] ?? '#8fa593'; }
}
