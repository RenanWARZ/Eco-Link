import { Component, OnInit, signal, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ComplaintService } from '../../core/services/complaint.service';
import { AuthService } from '../../core/services/auth.service';
import { Complaint, ComplaintPriority, ComplaintStatus } from '../../core/models/index';
import { NavbarComponent } from '../../shared/components/navbar/navbar.component';

@Component({
  selector: 'app-denuncia',
  standalone: true,
  imports: [CommonModule, FormsModule, NavbarComponent],
  template: `
    <div class="page-shell">
      <header class="page-header" style="background:linear-gradient(135deg,#7f1d1d,#c0392b)">
        <h1 class="page-title">Denúncia</h1>
        <p class="page-sub">Registre descartes irregulares</p>
      </header>

      <div class="container">
        <div class="two-col">
          <!-- Form -->
          <div class="two-col-form">
            <div class="card-lg" style="margin:16px 0">
              <p class="form-section-title">Nova ocorrência</p>
              <div class="form-group">
                <label class="form-label">Título</label>
                <input class="form-control" type="text" [(ngModel)]="form.title" placeholder="Ex: Lixo acumulado na calçada" />
              </div>
              <div class="form-group">
                <label class="form-label">Descrição</label>
                <textarea class="form-control" [(ngModel)]="form.description" placeholder="Descreva o problema…"></textarea>
              </div>
              <div class="form-group">
                <label class="form-label">Endereço</label>
                <input class="form-control" type="text" [(ngModel)]="form.address" placeholder="Rua, número, bairro" />
              </div>
              <div class="coords-row">
                <div class="form-group" style="flex:1"><label class="form-label">Latitude</label><input class="form-control" type="number" step="any" [(ngModel)]="form.latitude" /></div>
                <div class="form-group" style="flex:1"><label class="form-label">Longitude</label><input class="form-control" type="number" step="any" [(ngModel)]="form.longitude" /></div>
              </div>
              <div class="form-group">
                <label class="form-label">Prioridade</label>
                <select class="form-control" [(ngModel)]="form.priority">
                  <option value="LOW">Baixa</option>
                  <option value="MEDIUM">Média</option>
                  <option value="HIGH">Alta</option>
                  <option value="CRITICAL">Crítica</option>
                </select>
              </div>
              <button class="btn btn-secondary" style="margin-bottom:10px;width:100%" (click)="useMyLocation()">◎ Usar minha localização</button>
              <button class="btn btn-primary" (click)="submit()" [disabled]="saving()">
                <span *ngIf="saving()" class="spinner"></span>
                {{ saving() ? 'Enviando…' : 'Registrar Denúncia' }}
              </button>
              <div *ngIf="toast()" [class]="'toast ' + toastType()">{{ toast() }}</div>
            </div>
          </div>

          <!-- List -->
          <div class="two-col-list">
            <p class="section-title" style="margin-top:16px">Minhas denúncias</p>
            <div *ngIf="loading()" class="empty-state"><p>Carregando…</p></div>
            <div *ngIf="!loading() && complaints().length === 0" class="empty-state">
              <div class="empty-icon">✓</div><p>Nenhuma denúncia registrada.</p>
            </div>
            <div *ngIf="!loading() && complaints().length > 0" class="comp-list">
              <div class="comp-card card card-accent" *ngFor="let c of complaints()">
                <div class="comp-top">
                  <p class="comp-title">{{ c.title }}</p>
                  <div class="comp-badges">
                    <span [class]="'badge ' + priorityBadge(c.priority!)">{{ priorityLabel(c.priority!) }}</span>
                    <span [class]="'badge ' + statusBadge(c.status!)">{{ statusLabel(c.status!) }}</span>
                  </div>
                </div>
                <p class="comp-desc">{{ c.description }}</p>
                <p class="comp-date">{{ c.createdAt | date:'dd/MM/yyyy HH:mm' }}</p>
              </div>
            </div>
          </div>
        </div>
      </div>
      <app-navbar></app-navbar>
    </div>
  `,
  styles: [`
    .form-section-title { font-family: var(--font-head); font-size: 16px; font-weight: 700; margin-bottom: 18px; color: var(--ink); }
    .coords-row { display: flex; gap: 10px; }
    .comp-list { display: flex; flex-direction: column; gap: 10px; margin-bottom: 16px; }
    .comp-card { padding: 14px 16px; }
    .comp-top { display: flex; justify-content: space-between; align-items: flex-start; gap: 10px; margin-bottom: 6px; }
    .comp-title { font-weight: 600; font-size: 14px; color: var(--ink); }
    .comp-badges { display: flex; flex-direction: column; gap: 4px; align-items: flex-end; flex-shrink: 0; }
    .comp-desc { font-size: 13px; color: var(--ink-soft); margin-bottom: 6px; }
    .comp-date { font-size: 11px; color: var(--ink-muted); }

    @media (min-width: 768px) {
      .comp-badges { flex-direction: row; }
    }
  `]
})
export class DenunciaComponent implements OnInit {
  private svc = inject(ComplaintService);
  private auth = inject(AuthService);
  complaints = signal<Complaint[]>([]);
  loading = signal(true); saving = signal(false);
  toast = signal(''); toastType = signal('success');
  form = { title: '', description: '', address: '', latitude: 0, longitude: 0, priority: 'MEDIUM' as ComplaintPriority };

  ngOnInit(): void {
    const uid = this.auth.getCurrentUserId();
    if (!uid) return;
    this.svc.getByUserId(uid).subscribe({ next: (l: Complaint[]) => { this.complaints.set(l); this.loading.set(false); }, error: () => this.loading.set(false) });
  }

  useMyLocation(): void { navigator.geolocation?.getCurrentPosition(p => { this.form.latitude = p.coords.latitude; this.form.longitude = p.coords.longitude; }); }

  submit(): void {
    const uid = this.auth.getCurrentUserId();
    if (!uid || !this.form.title || !this.form.description) { this.showToast('Preencha título e descrição.', 'error'); return; }
    this.saving.set(true);
    this.svc.create({ ...this.form, user: { id: uid, openId: '', name: '', email: '' } }).subscribe({
      next: (c: Complaint) => { this.complaints.update(l => [c, ...l]); this.form = { title: '', description: '', address: '', latitude: 0, longitude: 0, priority: 'MEDIUM' }; this.saving.set(false); this.showToast('Denúncia registrada!', 'success'); },
      error: () => { this.saving.set(false); this.showToast('Erro ao registrar.', 'error'); }
    });
  }

  private showToast(msg: string, type: string): void { this.toast.set(msg); this.toastType.set(type); setTimeout(() => this.toast.set(''), 3000); }
  priorityBadge(p: ComplaintPriority): string { return ({ LOW: 'badge-green', MEDIUM: 'badge-warning', HIGH: 'badge-warning', CRITICAL: 'badge-danger' } as Record<string,string>)[p] ?? 'badge-gray'; }
  priorityLabel(p: ComplaintPriority): string { return ({ LOW: 'Baixa', MEDIUM: 'Média', HIGH: 'Alta', CRITICAL: 'Crítica' } as Record<string,string>)[p] ?? p; }
  statusBadge(s: ComplaintStatus): string { return ({ OPEN: 'badge-info', IN_PROGRESS: 'badge-warning', RESOLVED: 'badge-green', CLOSED: 'badge-gray' } as Record<string,string>)[s] ?? 'badge-gray'; }
  statusLabel(s: ComplaintStatus): string { return ({ OPEN: 'Aberta', IN_PROGRESS: 'Em Andamento', RESOLVED: 'Resolvida', CLOSED: 'Fechada' } as Record<string,string>)[s] ?? s; }
}
