import { Component, OnInit, signal, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ScheduleService } from '../../core/services/schedule.service';
import { AuthService } from '../../core/services/auth.service';
import { Schedule, ScheduleStatus } from '../../core/models/index';
import {  } from '../../shared/components/navbar/navbar.component';

@Component({
  selector: 'app-agendamento',
  standalone: true,
  imports: [CommonModule, FormsModule],
  template: `
    <div class="page-shell">
      <header class="page-header" style="background:linear-gradient(135deg,#064e3b,#059669)">
        <h1 class="page-title">Agendar Coleta</h1>
        <p class="page-sub">Solicite coleta de resíduos em casa</p>
      </header>

      <div class="container">
        <div class="two-col">
          <div class="two-col-form">
            <div class="card-lg" style="margin:16px 0">
              <p class="form-section-title">Novo agendamento</p>
              <div class="form-group">
                <label class="form-label">Tipo de resíduo</label>
                <select class="form-control" [(ngModel)]="form.wasteType">
                  <option value="">Selecione…</option>
                  <option value="plástico">Plástico</option>
                  <option value="papel">Papel / Papelão</option>
                  <option value="vidro">Vidro</option>
                  <option value="metal">Metal</option>
                  <option value="eletrônico">Eletrônico</option>
                  <option value="orgânico">Orgânico</option>
                  <option value="misto">Misto</option>
                </select>
              </div>
              <div class="form-group">
                <label class="form-label">Endereço de coleta</label>
                <input class="form-control" type="text" [(ngModel)]="form.address" placeholder="Rua, número, bairro" />
              </div>
              <div class="coords-row">
                <div class="form-group" style="flex:1"><label class="form-label">Latitude</label><input class="form-control" type="number" step="any" [(ngModel)]="form.latitude" /></div>
                <div class="form-group" style="flex:1"><label class="form-label">Longitude</label><input class="form-control" type="number" step="any" [(ngModel)]="form.longitude" /></div>
              </div>
              <div class="form-group">
                <label class="form-label">Data e hora</label>
                <input class="form-control" type="datetime-local" [(ngModel)]="form.scheduledDate" [min]="minDate" />
              </div>
              <div class="form-group">
                <label class="form-label">Observações</label>
                <textarea class="form-control" [(ngModel)]="form.description" placeholder="Opcional…"></textarea>
              </div>
              <button class="btn btn-secondary" style="margin-bottom:10px;width:100%" (click)="useMyLocation()">◎ Usar minha localização</button>
              <button class="btn btn-primary" (click)="submit()" [disabled]="saving()">
                <span *ngIf="saving()" class="spinner"></span>
                {{ saving() ? 'Agendando…' : 'Confirmar Agendamento' }}
              </button>
              <div *ngIf="toast()" [class]="'toast ' + toastType()">{{ toast() }}</div>
            </div>
          </div>

          <div class="two-col-list">
            <p class="section-title" style="margin-top:16px">Meus agendamentos</p>
            <div *ngIf="loading()" class="empty-state"><p>Carregando…</p></div>
            <div *ngIf="!loading() && schedules().length === 0" class="empty-state">
              <div class="empty-icon">📅</div><p>Nenhum agendamento ainda.</p>
            </div>
            <div *ngIf="!loading() && schedules().length > 0" class="sched-list">
              <div class="sched-card card card-accent" *ngFor="let s of schedules()">
                <div class="sched-top">
                  <div class="sched-info">
                    <p class="sched-type">♻ {{ s.wasteType }}</p>
                    <p class="sched-addr">{{ s.address }}</p>
                    <p class="sched-date">{{ s.scheduledDate | date:'dd/MM/yyyy HH:mm' }}</p>
                  </div>
                  <span [class]="'badge ' + statusBadge(s.status!)">{{ statusLabel(s.status!) }}</span>
                </div>
                <button *ngIf="s.status === 'PENDING' || s.status === 'CONFIRMED'"
                  class="btn btn-danger" style="margin-top:10px;width:auto;padding:7px 14px;font-size:13px"
                  (click)="cancel(s.id!)">Cancelar</button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .form-section-title { font-family: var(--font-head); font-size: 16px; font-weight: 700; margin-bottom: 18px; color: var(--ink); }
    .coords-row { display: flex; gap: 10px; }
    .sched-list { display: flex; flex-direction: column; gap: 10px; margin-bottom: 16px; }
    .sched-card { padding: 14px 16px; }
    .sched-top { display: flex; justify-content: space-between; align-items: flex-start; gap: 10px; }
    .sched-type { font-weight: 600; font-size: 14px; color: var(--ink); }
    .sched-addr, .sched-date { font-size: 12px; color: var(--ink-muted); margin-top: 3px; }
  `]
})
export class AgendamentoComponent implements OnInit {
  private svc = inject(ScheduleService);
  private auth = inject(AuthService);
  schedules = signal<Schedule[]>([]);
  loading = signal(true); saving = signal(false);
  toast = signal(''); toastType = signal('success');
  minDate = new Date().toISOString().slice(0, 16);
  form = { wasteType: '', address: '', latitude: 0, longitude: 0, scheduledDate: '', description: '' };

  ngOnInit(): void {
    const uid = this.auth.getCurrentUserId();
    if (!uid) return;
    this.svc.getByUserId(uid).subscribe({ next: (l: Schedule[]) => { this.schedules.set(l); this.loading.set(false); }, error: () => this.loading.set(false) });
  }

  useMyLocation(): void { navigator.geolocation?.getCurrentPosition(p => { this.form.latitude = p.coords.latitude; this.form.longitude = p.coords.longitude; }); }

  submit(): void {
    const uid = this.auth.getCurrentUserId();
    if (!uid || !this.form.wasteType || !this.form.address || !this.form.scheduledDate) { this.showToast('Preencha tipo, endereço e data.', 'error'); return; }
    this.saving.set(true);
    this.svc.create({ ...this.form, user: { id: uid, openId: '', name: '', email: '' } }).subscribe({
      next: (s: Schedule) => { this.schedules.update(l => [s, ...l]); this.form = { wasteType: '', address: '', latitude: 0, longitude: 0, scheduledDate: '', description: '' }; this.saving.set(false); this.showToast('Agendado!', 'success'); },
      error: () => { this.saving.set(false); this.showToast('Erro ao agendar.', 'error'); }
    });
  }

  cancel(id: number): void { this.svc.cancel(id).subscribe({ next: (s: Schedule) => this.schedules.update(l => l.map(x => x.id === id ? s : x)) }); }

  private showToast(msg: string, type: string): void { this.toast.set(msg); this.toastType.set(type); setTimeout(() => this.toast.set(''), 3000); }
  statusBadge(s: ScheduleStatus): string { return ({ PENDING: 'badge-warning', CONFIRMED: 'badge-green', COMPLETED: 'badge-info', CANCELLED: 'badge-gray' } as Record<string,string>)[s] ?? 'badge-gray'; }
  statusLabel(s: ScheduleStatus): string { return ({ PENDING: 'Pendente', CONFIRMED: 'Confirmado', COMPLETED: 'Concluído', CANCELLED: 'Cancelado' } as Record<string,string>)[s] ?? s; }
}
