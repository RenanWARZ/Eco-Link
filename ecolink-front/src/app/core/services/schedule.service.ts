import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Schedule, ScheduleStatus } from '../models/index';
import { environment } from '../../../environments/environment';

@Injectable({ providedIn: 'root' })
export class ScheduleService {
  private base = `${environment.apiUrl}/schedules`;
  constructor(private http: HttpClient) {}

  create(schedule: Partial<Schedule>): Observable<Schedule> {
    return this.http.post<Schedule>(this.base, schedule);
  }
  getById(id: number): Observable<Schedule> {
    return this.http.get<Schedule>(`${this.base}/${id}`);
  }
  getByUserId(userId: number): Observable<Schedule[]> {
    return this.http.get<Schedule[]>(`${this.base}/user/${userId}`);
  }
  getByStatus(status: ScheduleStatus): Observable<Schedule[]> {
    return this.http.get<Schedule[]>(`${this.base}/status/${status}`);
  }
  update(id: number, schedule: Partial<Schedule>): Observable<Schedule> {
    return this.http.put<Schedule>(`${this.base}/${id}`, schedule);
  }
  cancel(id: number): Observable<Schedule> {
    return this.http.put<Schedule>(`${this.base}/${id}/cancel`, null);
  }
}
