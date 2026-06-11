import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { User } from '../models/index';
import { environment } from '../../../environments/environment';

@Injectable({ providedIn: 'root' })
export class UserService {
  private base = `${environment.apiUrl}/users`;
  constructor(private http: HttpClient) {}

  getById(id: number): Observable<User> {
    return this.http.get<User>(`${this.base}/${id}`);
  }
  getByOpenId(openId: string): Observable<User> {
    return this.http.get<User>(`${this.base}/openid/${openId}`);
  }
  createOrUpdate(user: Partial<User>): Observable<User> {
    return this.http.post<User>(this.base, user);
  }
  updatePoints(id: number, points: number): Observable<User> {
    const params = new HttpParams().set('points', points);
    return this.http.put<User>(`${this.base}/${id}/points`, null, { params });
  }
}
