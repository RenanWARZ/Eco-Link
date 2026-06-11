import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Complaint, ComplaintPriority, ComplaintStatus } from '../models/index';
import { environment } from '../../../environments/environment';

@Injectable({ providedIn: 'root' })
export class ComplaintService {
  private base = `${environment.apiUrl}/complaints`;
  constructor(private http: HttpClient) {}

  create(complaint: Partial<Complaint>): Observable<Complaint> {
    return this.http.post<Complaint>(this.base, complaint);
  }
  getById(id: number): Observable<Complaint> {
    return this.http.get<Complaint>(`${this.base}/${id}`);
  }
  getByUserId(userId: number): Observable<Complaint[]> {
    return this.http.get<Complaint[]>(`${this.base}/user/${userId}`);
  }
  getByStatus(status: ComplaintStatus): Observable<Complaint[]> {
    return this.http.get<Complaint[]>(`${this.base}/status/${status}`);
  }
  getByPriority(priority: ComplaintPriority): Observable<Complaint[]> {
    return this.http.get<Complaint[]>(`${this.base}/priority/${priority}`);
  }
  update(id: number, complaint: Partial<Complaint>): Observable<Complaint> {
    return this.http.put<Complaint>(`${this.base}/${id}`, complaint);
  }
  updateStatus(id: number, status: ComplaintStatus): Observable<Complaint> {
    const params = new HttpParams().set('status', status);
    return this.http.put<Complaint>(`${this.base}/${id}/status`, null, { params });
  }
}
