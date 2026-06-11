import { Component, signal, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { AuthService } from '../../core/services/auth.service';
import { User } from '../../core/models/index';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule, FormsModule],
  template: `
    <div class="login-shell">
      <!-- Left panel — visible tablet+ -->
      <div class="login-panel">
        <div class="brand-block">
          <div class="brand-icon">☘</div>
          <h1 class="brand-name">EcoLink</h1>
          <p class="brand-tagline">Recicle. Denuncie.<br>Transforme sua cidade.</p>
        </div>
        <div class="stats-row">
          <div class="stat"><span class="stat-n">44</span><span class="stat-l">Ecopontos</span></div>
          <div class="stat"><span class="stat-n">4</span><span class="stat-l">Cooperativas</span></div>
          <div class="stat"><span class="stat-n">300t</span><span class="stat-l">Lixo/dia</span></div>
        </div>
        <p class="panel-footer">Plataforma de gestão urbana sustentável · Maringá PR</p>
      </div>

      <!-- Right panel — form -->
      <div class="login-form-wrap">
        <div class="login-form">
          <p class="form-eyebrow">Acesso à plataforma</p>
          <h2 class="form-heading">Entrar</h2>

          <div class="form-group">
            <label class="form-label">Nome</label>
            <input class="form-control" type="text" [(ngModel)]="name" placeholder="Seu nome completo" />
          </div>
          <div class="form-group">
            <label class="form-label">E-mail</label>
            <input class="form-control" type="email" [(ngModel)]="email" placeholder="seu@email.com" />
          </div>
          <div class="form-group">
            <label class="form-label">Perfil</label>
            <select class="form-control" [(ngModel)]="role">
              <option value="CITIZEN">Cidadão</option>
              <option value="ADMIN">Prefeitura / Admin</option>
            </select>
          </div>

          <button class="btn btn-primary" (click)="entrar()" [disabled]="loading()">
            <span *ngIf="loading()" class="spinner"></span>
            {{ loading() ? 'Entrando…' : 'Entrar' }}
          </button>

          <p *ngIf="erro()" class="form-error">{{ erro() }}</p>
          <p class="form-note">Sem conta? Seu primeiro acesso cria o perfil automaticamente.</p>
        </div>
      </div>
    </div>
  `,
  styles: [`
    /* Mobile: stacked, panel on top as hero */
    .login-shell {
      min-height: 100vh;
      display: flex;
      flex-direction: column;
    }

    .login-panel {
      background: linear-gradient(150deg, #1a4d24 0%, var(--green) 100%);
      padding: 52px 24px 36px;
      color: #fff;
      display: flex;
      flex-direction: column;
      gap: 0;
    }

    .brand-block { margin-bottom: 28px; }
    .brand-icon {
      font-size: 28px; width: 48px; height: 48px;
      background: rgba(255,255,255,.15); border-radius: var(--r);
      display: flex; align-items: center; justify-content: center;
      margin-bottom: 14px;
    }
    .brand-name {
      font-family: var(--font-head); font-size: 30px; font-weight: 700;
      letter-spacing: -.02em; margin-bottom: 6px;
    }
    .brand-tagline { font-size: 15px; opacity: .75; line-height: 1.5; }

    .stats-row { display: flex; gap: 28px; }
    .stat { display: flex; flex-direction: column; gap: 2px; }
    .stat-n { font-family: var(--font-head); font-size: 22px; font-weight: 700; }
    .stat-l { font-size: 11px; opacity: .6; text-transform: uppercase; letter-spacing: .05em; }

    .panel-footer { display: none; }

    .login-form-wrap {
      flex: 1;
      background: var(--surface);
      padding: 28px 18px 40px;
      display: flex;
      align-items: flex-start;
      justify-content: center;
    }
    .login-form { width: 100%; max-width: 400px; }

    .form-eyebrow {
      font-size: 11px; font-weight: 600; color: var(--ink-muted);
      text-transform: uppercase; letter-spacing: .07em; margin-bottom: 4px;
    }
    .form-heading {
      font-family: var(--font-head); font-size: 24px; font-weight: 700;
      color: var(--ink); margin-bottom: 24px;
    }
    .form-error { margin-top: 10px; font-size: 13px; color: var(--red); text-align: center; }
    .form-note  { margin-top: 16px; font-size: 12px; color: var(--ink-muted); text-align: center; }

    /* Tablet: side by side */
    @media (min-width: 768px) {
      .login-shell { flex-direction: row; }
      .login-panel {
        flex: 0 0 340px;
        padding: 64px 36px;
        justify-content: center;
        min-height: 100vh;
      }
      .brand-name { font-size: 36px; }
      .panel-footer {
        display: block;
        margin-top: auto;
        padding-top: 32px;
        font-size: 11px;
        opacity: .45;
        line-height: 1.5;
      }
      .login-form-wrap {
        flex: 1;
        align-items: center;
        padding: 48px 40px;
      }
    }

    /* Desktop: wider left panel */
    @media (min-width: 1024px) {
      .login-panel { flex: 0 0 420px; padding: 72px 48px; }
      .brand-name { font-size: 42px; }
      .brand-tagline { font-size: 17px; }
      .login-form-wrap { padding: 64px 60px; }
      .form-heading { font-size: 28px; margin-bottom: 28px; }
    }
  `]
})
export class LoginComponent {
  private auth = inject(AuthService);
  private router = inject(Router);

  name = '';
  email = '';
  role: 'CITIZEN' | 'ADMIN' = 'CITIZEN';
  loading = signal(false);
  erro = signal('');

  entrar(): void {
    if (!this.name.trim() || !this.email.trim()) { this.erro.set('Preencha nome e e-mail.'); return; }
    this.loading.set(true); this.erro.set('');
    const payload: Partial<User> = {
      openId: this.email.trim().toLowerCase(), name: this.name.trim(),
      email: this.email.trim(), role: this.role, loginMethod: 'local'
    };
    this.auth.login(payload).subscribe({
      next: () => this.router.navigate(['/home']),
      error: () => { this.erro.set('Erro ao conectar com o servidor.'); this.loading.set(false); }
    });
  }
}
