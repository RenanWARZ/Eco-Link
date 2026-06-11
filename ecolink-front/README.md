# EcoLink — Frontend Angular

Projeto frontend Angular 17 conectado ao backend Spring Boot (`ecolink-back`).

---

## Pré-requisitos

- Node.js 18+
- Angular CLI 17: `npm install -g @angular/cli`
- Backend `ecolink-back` rodando na porta **8080**

---

## Como rodar

### 1. Instalar dependências
```bash
npm install
```

### 2. Subir o backend primeiro
No projeto `ecolink-back`:
```bash
./mvnw spring-boot:run
```
O backend sobe em `http://localhost:8080` com context-path `/api`.

### 3. Rodar o frontend
```bash
npm start
```
O Angular sobe em `http://localhost:4200` e faz proxy das chamadas `/api` para `http://localhost:8080`.

---

## Estrutura do projeto

```
src/app/
├── core/
│   ├── models/          # Interfaces TypeScript (User, Complaint, Schedule, etc.)
│   ├── services/        # Services HTTP conectados ao backend
│   │   ├── auth.service.ts
│   │   ├── user.service.ts
│   │   ├── activity.service.ts
│   │   ├── complaint.service.ts
│   │   ├── recycling-point.service.ts
│   │   ├── schedule.service.ts
│   │   └── ranking.service.ts
│   └── interceptors/    # HTTP interceptors
├── features/
│   ├── auth/            # Tela de Login  (POST /api/users)
│   ├── home/            # Home + atividades recentes
│   ├── mapa/            # Mapa Leaflet + pontos de reciclagem
│   ├── pontuacao/       # Gamificação + histórico
│   ├── denuncia/        # Registrar e listar denúncias
│   ├── agendamento/     # Agendar e cancelar coletas
│   └── ranking/         # Top rankings
└── shared/
    └── components/
        └── navbar/      # Bottom navigation bar
```

---

## Endpoints utilizados

| Tela          | Endpoint backend                             |
|---------------|----------------------------------------------|
| Login         | `POST /api/users`                            |
| Home          | `GET /api/activities/user/{id}`, `GET /api/rankings/user/{id}` |
| Mapa          | `GET /api/recycling-points`                  |
| Pontuação     | `GET /api/activities/user/{id}/history`      |
| Denúncia      | `POST /api/complaints`, `GET /api/complaints/user/{id}` |
| Agendamento   | `POST /api/schedules`, `GET /api/schedules/user/{id}`, `PUT /api/schedules/{id}/cancel` |
| Ranking       | `GET /api/rankings`, `GET /api/rankings/user/{id}` |

---

## Observações

- O login usa `POST /api/users` com `openId = email` (cria ou atualiza o usuário).
- O usuário logado é salvo no `localStorage` via `AuthService`.
- O mapa usa [Leaflet](https://leafletjs.com/) carregado via CDN.
- Para CORS funcionar em produção, certifique-se que o backend tem `cors.allowed-origins` com a URL do frontend.
