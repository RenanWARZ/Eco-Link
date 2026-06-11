import { Component, OnInit, AfterViewInit, OnDestroy, signal, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RecyclingPointService } from '../../core/services/recycling-point.service';
import { RecyclingPoint } from '../../core/models/index';
import { NavbarComponent } from '../../shared/components/navbar/navbar.component';

declare const L: any;

@Component({
  selector: 'app-mapa',
  standalone: true,
  imports: [CommonModule, NavbarComponent],
  template: `
    <div class="page-shell">
      <header class="page-header" style="background:linear-gradient(135deg,#1a4d24,var(--green))">
        <h1 class="page-title">Mapa de Reciclagem</h1>
        <p class="page-sub">{{ points().length }} pontos ativos em Maringá</p>
      </header>

      <div class="container">
        <div class="mapa-layout">
          <!-- Map -->
          <div class="map-col">
            <div id="map-el" class="map-box"></div>
          </div>

          <!-- List -->
          <div class="list-col">
            <p class="section-title" style="margin-top:16px">Pontos de coleta</p>
            <div *ngIf="loading()" class="empty-state"><p>Carregando pontos…</p></div>
            <div *ngIf="!loading() && points().length === 0" class="empty-state">
              <div class="empty-icon">🗺</div><p>Nenhum ponto cadastrado.</p>
            </div>
            <div *ngIf="!loading() && points().length > 0" class="pts-list">
              <div class="pt-card card card-accent" *ngFor="let p of points()" (click)="focus(p)">
                <div class="pt-top">
                  <div class="pt-info">
                    <p class="pt-name">{{ p.name }}</p>
                    <p class="pt-addr">{{ p.address }}</p>
                  </div>
                  <span [class]="'badge ' + (p.isActive ? 'badge-green' : 'badge-gray')">
                    {{ p.isActive ? 'Ativo' : 'Inativo' }}
                  </span>
                </div>
                <div class="pt-types">
                  <span class="type-pill" *ngFor="let t of parseTypes(p.types)">{{ t }}</span>
                </div>
                <div *ngIf="p.capacity" class="pt-load">
                  <div class="load-track"><div class="load-bar" [style.width.%]="occ(p)"></div></div>
                  <span class="load-pct">{{ occ(p).toFixed(0) }}% ocupado</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <app-navbar></app-navbar>
    </div>
  `,
  styles: [`
    /* Mobile: map on top, list below */
    .mapa-layout { display: flex; flex-direction: column; }
    .map-col { }
    .map-box {
      height: 240px;
      border-radius: var(--r);
      margin: 16px 0 0;
      overflow: hidden;
      box-shadow: var(--sh-sm);
    }
    .list-col { }

    .pts-list { display: flex; flex-direction: column; gap: 10px; margin-bottom: 16px; }
    .pt-card { padding: 14px 16px; cursor: pointer; transition: transform .14s; }
    .pt-card:hover { transform: translateY(-1px); box-shadow: var(--sh-sm); }
    .pt-top { display: flex; justify-content: space-between; align-items: flex-start; gap: 10px; margin-bottom: 8px; }
    .pt-name { font-weight: 600; font-size: 14px; color: var(--ink); }
    .pt-addr { font-size: 12px; color: var(--ink-muted); margin-top: 2px; }
    .pt-types { display: flex; flex-wrap: wrap; gap: 5px; margin-bottom: 8px; }
    .type-pill { background: var(--green-bg); color: var(--green); border-radius: 99px; padding: 2px 9px; font-size: 11px; font-weight: 500; }
    .pt-load { display: flex; align-items: center; gap: 8px; }
    .load-track { flex: 1; height: 4px; background: var(--line); border-radius: 99px; overflow: hidden; }
    .load-bar { height: 100%; background: var(--green); border-radius: 99px; transition: width .3s; }
    .load-pct { font-size: 11px; color: var(--ink-muted); white-space: nowrap; }

    /* Tablet: taller map */
    @media (min-width: 768px) {
      .map-box { height: 320px; }
      .pts-list { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
    }

    /* Desktop: map and list side by side */
    @media (min-width: 1024px) {
      .mapa-layout { flex-direction: row; gap: 28px; align-items: flex-start; margin-top: 16px; }
      .map-col { flex: 0 0 420px; position: sticky; top: 20px; }
      .map-box { height: 520px; margin: 0; }
      .list-col { flex: 1; min-width: 0; }
      .pts-list { grid-template-columns: 1fr; }
    }
  `]
})
export class MapaComponent implements OnInit, AfterViewInit, OnDestroy {
  private svc = inject(RecyclingPointService);
  points = signal<RecyclingPoint[]>([]);
  loading = signal(true);
  private map: any = null;
  private ready = false;

  ngOnInit(): void {
    this.svc.getAllActive().subscribe({
      next: (p: RecyclingPoint[]) => { this.points.set(p); this.loading.set(false); this.addMarkers(); },
      error: () => this.loading.set(false)
    });
  }

  ngAfterViewInit(): void { this.loadLeaflet(); }
  ngOnDestroy(): void { if (this.map) this.map.remove(); }

  private loadLeaflet(): void {
    if (typeof L !== 'undefined') { this.ready = true; this.createMap(); return; }
    const link = document.createElement('link');
    link.rel = 'stylesheet'; link.href = 'https://unpkg.com/leaflet@1.9.4/dist/leaflet.css';
    document.head.appendChild(link);
    const script = document.createElement('script');
    script.src = 'https://unpkg.com/leaflet@1.9.4/dist/leaflet.js';
    script.onload = () => { this.ready = true; this.createMap(); };
    document.head.appendChild(script);
  }

  private createMap(): void {
    const el = document.getElementById('map-el');
    if (!el) return;
    this.map = L.map('map-el').setView([-23.4253, -51.9386], 12);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', { attribution: '© OpenStreetMap' }).addTo(this.map);
    this.addMarkers();
  }

  private addMarkers(): void {
    if (!this.map || !this.ready) return;
    this.points().forEach((p: RecyclingPoint) => {
      L.marker([p.latitude, p.longitude]).addTo(this.map).bindPopup(`<b>${p.name}</b><br>${p.address}`);
    });
    if (this.points().length) this.map.setView([this.points()[0].latitude, this.points()[0].longitude], 13);
  }

  focus(p: RecyclingPoint): void { if (this.map) this.map.setView([p.latitude, p.longitude], 16); }
  parseTypes(t: string): string[] { try { return JSON.parse(t); } catch { return [t]; } }
  occ(p: RecyclingPoint): number { if (!p.capacity) return 0; return ((p.currentLoad ?? 0) / p.capacity) * 100; }
}
