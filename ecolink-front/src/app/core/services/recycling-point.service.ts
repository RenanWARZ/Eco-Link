import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { RecyclingPoint } from '../models/index';
import { environment } from '../../../environments/environment';

@Injectable({ providedIn: 'root' })
export class RecyclingPointService {
  private base = `${environment.apiUrl}/recycling-points`;
  constructor(private http: HttpClient) {}

  getAllActive(): Observable<RecyclingPoint[]> {
    return this.http.get<RecyclingPoint[]>(this.base);
  }
  getById(id: number): Observable<RecyclingPoint> {
    return this.http.get<RecyclingPoint>(`${this.base}/${id}`);
  }
  create(point: Partial<RecyclingPoint>): Observable<RecyclingPoint> {
    return this.http.post<RecyclingPoint>(this.base, point);
  }
  update(id: number, point: Partial<RecyclingPoint>): Observable<RecyclingPoint> {
    return this.http.put<RecyclingPoint>(`${this.base}/${id}`, point);
  }
  getNearby(latitude: number, longitude: number, radiusKm: number = 5): Observable<RecyclingPoint[]> {
    const params = new HttpParams()
      .set('latitude', latitude)
      .set('longitude', longitude)
      .set('radiusKm', radiusKm);
    return this.http.get<RecyclingPoint[]>(`${this.base}/nearby`, { params });
  }
}
