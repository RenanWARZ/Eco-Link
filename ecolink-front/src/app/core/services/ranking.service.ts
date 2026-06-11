import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Ranking } from '../models/index';
import { environment } from '../../../environments/environment';

@Injectable({ providedIn: 'root' })
export class RankingService {
  private base = `${environment.apiUrl}/rankings`;
  constructor(private http: HttpClient) {}

  create(ranking: Partial<Ranking>): Observable<Ranking> {
    return this.http.post<Ranking>(this.base, ranking);
  }
  getById(id: number): Observable<Ranking> {
    return this.http.get<Ranking>(`${this.base}/${id}`);
  }
  getByUserId(userId: number): Observable<Ranking> {
    return this.http.get<Ranking>(`${this.base}/user/${userId}`);
  }
  getTopRankings(): Observable<Ranking[]> {
    return this.http.get<Ranking[]>(this.base);
  }
  updatePoints(userId: number, points: number): Observable<Ranking> {
    const params = new HttpParams().set('points', points);
    return this.http.put<Ranking>(`${this.base}/user/${userId}/points`, null, { params });
  }
}
