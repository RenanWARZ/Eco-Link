import { Component, OnInit, signal, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RankingService } from '../../core/services/ranking.service';
import { AuthService } from '../../core/services/auth.service';
import { Ranking } from '../../core/models/index';
import { NavbarComponent } from '../../shared/components/navbar/navbar.component';

@Component({
  selector: 'app-ranking',
  standalone: true,
  imports: [CommonModule, NavbarComponent],
  template: `
    <div class="page-shell">
      <header class="page-header" style="background:linear-gradient(135deg,#1e1b4b,#4338ca)">
        <h1 class="page-title">Ranking</h1>
        <p class="page-sub">Os cidadãos mais sustentáveis de Maringá</p>
      </header>

      <div class="container">
        <div *ngIf="myRanking()" class="my-rank card card-accent" style="margin:16px 0">
          <div class="my-rank-row">
            <span class="my-pos">{{ medal(myRanking()?.rank ?? 99) || '#' + myRanking()?.rank }}</span>
            <div>
              <p class="my-name">{{ currentUser()?.name }}</p>
              <p class="my-pts-lbl">{{ myRanking()?.totalPoints }} pontos</p>
            </div>
          </div>
        </div>

        <p class="section-title">Top Recicladores</p>
        <div *ngIf="loading()" class="empty-state"><p>Carregando…</p></div>
        <div *ngIf="!loading() && rankings().length === 0" class="empty-state">
          <div class="empty-icon">🏆</div><p>Nenhum dado ainda.</p>
        </div>
        <div *ngIf="!loading() && rankings().length > 0" class="rank-list">
          <div class="rank-row card" *ngFor="let r of rankings(); let i = index"
               [class.is-me]="r.user?.id === currentUser()?.id">
            <span class="pos">{{ medal(i+1) || (i+1) }}</span>
            <div class="rank-user">
              <p class="rank-name">{{ r.user?.name ?? 'Usuário' }}</p>
              <p class="rank-email">{{ r.user?.email }}</p>
            </div>
            <div class="rank-score">
              <span class="score-val">{{ r.totalPoints }}</span>
              <span class="score-lbl">pts</span>
            </div>
          </div>
        </div>
      </div>
      <app-navbar></app-navbar>
    </div>
  `,
  styles: [`
    .my-rank { padding: 14px 16px; }
    .my-rank-row { display: flex; align-items: center; gap: 14px; }
    .my-pos { font-family: var(--font-head); font-size: 36px; font-weight: 700; color: var(--green); line-height: 1; }
    .my-name { font-weight: 700; font-size: 15px; color: var(--ink); }
    .my-pts-lbl { font-size: 12px; color: var(--ink-muted); margin-top: 1px; }

    .rank-list { display: flex; flex-direction: column; gap: 8px; margin-bottom: 16px; }
    .rank-row { display: flex; align-items: center; gap: 12px; padding: 12px 14px; }
    .rank-row.is-me { border-color: var(--green-line); background: var(--green-bg); }
    .pos { font-family: var(--font-head); font-size: 16px; font-weight: 700; width: 32px; text-align: center; color: var(--ink-muted); flex-shrink: 0; }
    .rank-user { flex: 1; min-width: 0; }
    .rank-name { font-size: 14px; font-weight: 600; color: var(--ink); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
    .rank-email { font-size: 11px; color: var(--ink-muted); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
    .rank-score { text-align: right; flex-shrink: 0; }
    .score-val { display: block; font-family: var(--font-head); font-size: 18px; font-weight: 700; color: var(--green); }
    .score-lbl { font-size: 10px; color: var(--ink-muted); text-transform: uppercase; }

    /* Tablet: 2-col grid */
    @media (min-width: 768px) {
      .rank-list { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
      .my-pos { font-size: 42px; }
    }

    /* Desktop: single wider column */
    @media (min-width: 1024px) {
      .rank-list { grid-template-columns: 1fr; max-width: 640px; }
      .rank-name { font-size: 15px; }
      .score-val { font-size: 22px; }
    }
  `]
})
export class RankingComponent implements OnInit {
  private svc = inject(RankingService);
  private auth = inject(AuthService);
  rankings = signal<Ranking[]>([]);
  myRanking = signal<Ranking | null>(null);
  loading = signal(true);
  currentUser = this.auth.currentUser;

  ngOnInit(): void {
    this.svc.getTopRankings().subscribe({ next: (l: Ranking[]) => { this.rankings.set(l); this.loading.set(false); }, error: () => this.loading.set(false) });
    const uid = this.auth.getCurrentUserId();
    if (uid) this.svc.getByUserId(uid).subscribe({ next: (r: Ranking) => this.myRanking.set(r), error: () => {} });
  }

  medal(pos: number): string { return ({ 1: '🥇', 2: '🥈', 3: '🥉' } as Record<number,string>)[pos] ?? ''; }
}
