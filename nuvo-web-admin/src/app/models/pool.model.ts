export interface Pool {
  id: number;
  name: string;
  description: string;
  interestRatePerDay: number;
  maxParticipants: number;
  active: boolean;
  createdAt: string;
  currentParticipantsCount?: number;
  full?: boolean;
}

export interface PoolStats {
  pool: Pool;
  currentInvestors: number;
  availableSlots: number;
  totalInvested: number;
  totalCurrentValue: number;
}

export interface CreatePoolRequest {
  name: string;
  description: string;
  interestRatePerDay: number;
  maxParticipants: number;
}

export interface UpdatePoolRequest {
  name?: string;
  description?: string;
  maxParticipants?: number;
  active?: boolean;
}

export interface Investment {
  id: number;
  userId: number;
  investedAmount: number;
  investedAt: string;
  status: 'ACTIVE' | 'WITHDRAWN';
  pool?: Pool;
}
