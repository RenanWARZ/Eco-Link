import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Activity } from '../models/index';
import { environment } from '../../../environments/environment';

@Injectable({ providedIn: 'root' })
export class ActivityService {
  private base = `${environment.apiUrl}/activities`;
  constructor(private http: HttpClient) {}

  create(activity: Partial<Activity>): Observable<Activity> {
    return this.http.post<Activity>(this.base, activity);
  }
  getById(id: number): Observable<Activity> {
    return this.http.get<Activity>(`${this.base}/${id}`);
  }
  getByUserId(userId: number): Observable<Activity[]> {
    return this.http.get<Activity[]>(`${this.base}/user/${userId}`);
  }
  getUserHistory(userId: number): Observable<Activity[]> {
    return this.http.get<Activity[]>(`${this.base}/user/${userId}/history`);
  }
}
