import { HttpInterceptorFn } from '@angular/common/http';
import { inject } from '@angular/core';
import { AuthService } from '../services/auth.service';

export const authInterceptor: HttpInterceptorFn = (req, next) => {
  const auth = inject(AuthService);
  const userId = auth.getCurrentUserId();
  if (userId) {
    const cloned = req.clone({ setHeaders: { 'X-User-Id': String(userId) } });
    return next(cloned);
  }
  return next(req);
};
