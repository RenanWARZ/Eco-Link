import { Injectable, signal } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, tap } from 'rxjs';
import { User } from '../models/index';
import { environment } from '../../../environments/environment';

@Injectable({ providedIn: 'root' })
export class AuthService {
  private readonly STORAGE_KEY = 'ecolink_user';
  currentUser = signal<User | null>(this.loadFromStorage());

  constructor(private http: HttpClient) {}

  private loadFromStorage(): User | null {
    try {
      const raw = localStorage.getItem(this.STORAGE_KEY);
      return raw ? JSON.parse(raw) : null;
    } catch { return null; }
  }

  private saveToStorage(user: User): void {
    localStorage.setItem(this.STORAGE_KEY, JSON.stringify(user));
  }

  login(userData: Partial<User>): Observable<User> {
    return this.http.post<User>(`${environment.apiUrl}/users`, userData).pipe(
      tap((user: User) => {
        this.currentUser.set(user);
        this.saveToStorage(user);
      })
    );
  }

  logout(): void {
    this.currentUser.set(null);
    localStorage.removeItem(this.STORAGE_KEY);
  }

  getCurrentUserId(): number | null {
    return this.currentUser()?.id ?? null;
  }

  isLoggedIn(): boolean {
    return this.currentUser() !== null;
  }

  isAdmin(): boolean {
    return this.currentUser()?.role === 'ADMIN';
  }
}
