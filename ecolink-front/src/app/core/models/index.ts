// ---- User ----
export type UserRole = 'CITIZEN' | 'ADMIN';

export interface User {
  id?: number;
  openId: string;
  name: string;
  email: string;
  loginMethod?: string;
  role?: UserRole;
  points?: number;
  address?: string;
  latitude?: number;
  longitude?: number;
  createdAt?: string;
  updatedAt?: string;
  lastSignedIn?: string;
}

// ---- Activity ----
export type ActivityType = 'SCHEDULE' | 'COMPLAINT' | 'RECYCLING' | 'ACHIEVEMENT';

export interface Activity {
  id?: number;
  user?: User;
  type: ActivityType;
  description: string;
  pointsEarned?: number;
  createdAt?: string;
}

// ---- Complaint ----
export type ComplaintPriority = 'LOW' | 'MEDIUM' | 'HIGH' | 'CRITICAL';
export type ComplaintStatus = 'OPEN' | 'IN_PROGRESS' | 'RESOLVED' | 'CLOSED';

export interface Complaint {
  id?: number;
  user?: User;
  title: string;
  description: string;
  latitude: number;
  longitude: number;
  priority?: ComplaintPriority;
  status?: ComplaintStatus;
  imageUrl?: string;
  createdAt?: string;
  updatedAt?: string;
}

// ---- RecyclingPoint ----
export interface RecyclingPoint {
  id?: number;
  name: string;
  address: string;
  latitude: number;
  longitude: number;
  types: string; // JSON array string e.g. '["plástico","papel"]'
  capacity?: number;
  currentLoad?: number;
  isActive?: boolean;
  createdAt?: string;
  updatedAt?: string;
}

// ---- Schedule ----
export type ScheduleStatus = 'PENDING' | 'CONFIRMED' | 'COMPLETED' | 'CANCELLED';

export interface Schedule {
  id?: number;
  user?: User;
  wasteType: string;
  address: string;
  latitude: number;
  longitude: number;
  scheduledDate: string;
  description?: string;
  status?: ScheduleStatus;
  createdAt?: string;
  updatedAt?: string;
}

// ---- Ranking ----
export interface Ranking {
  id?: number;
  user?: User;
  totalPoints: number;
  rank?: number;
  updatedAt?: string;
}
