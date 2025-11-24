# 🏦 NUVO - Sistema Bancario de Microservicios

[![Java](https://img.shields.io/badge/Java-17-orange.svg)](https://www.oracle.com/java/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.2.3-green.svg)](https://spring.io/projects/spring-boot)
[![Angular](https://img.shields.io/badge/Angular-20.3.6-red.svg)](https://angular.io/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

Sistema bancario moderno construido con arquitectura de microservicios, diseñado para proporcionar servicios financieros completos incluyendo gestión de cuentas, transacciones, préstamos e inversiones.

## 📋 Tabla de Contenidos

- [Características](#-características)
- [Arquitectura](#-arquitectura)
- [Tecnologías](#-tecnologías)
- [Requisitos Previos](#-requisitos-previos)
- [Instalación](#-instalación)
- [Configuración](#-configuración)
- [Uso](#-uso)
- [API Endpoints](#-api-endpoints)
- [Base de Datos](#-base-de-datos)
- [Contribuir](#-contribuir)
- [Licencia](#-licencia)

## ✨ Características

### 🔐 Autenticación y Seguridad
- Autenticación basada en JWT
- Roles de usuario (ADMIN, USER)
- Seguridad end-to-end con Spring Security

### 💰 Gestión de Cuentas
- Creación y administración de cuentas bancarias
- Consulta de saldos en tiempo real
- Historia de movimientos

### 💸 Transacciones
- Transferencias entre usuarios
- Depósitos
- Historial completo de transacciones
- Validaciones de saldo

### 🏦 Préstamos
- Solicitud de préstamos
- Aprobación/rechazo de préstamos
- Seguimiento de pagos
- Cálculo automático de intereses
- Estados: PENDING, APPROVED, REJECTED, PAID

### 📈 Pool de Inversiones
- Sistema de inversiones con rentabilidad
- Interés compuesto calculado por minuto
- Retiro de inversiones con ganancias
- Seguimiento de inversiones activas

## 🏗️ Arquitectura

El sistema está compuesto por 5 microservicios independientes y un frontend Angular:

```
┌─────────────────────────────────────────────────────────────┐
│                     Frontend Angular                         │
│                   (Puerto 4200)                              │
└────────────┬────────────────────────────────────────────────┘
             │
             ├──────────────────────────────────────┐
             │                                      │
   ┌─────────▼──────────┐              ┌──────────▼─────────┐
   │  Auth Service      │              │  Account Service   │
   │   (Puerto 8081)    │              │   (Puerto 8082)    │
   └─────────┬──────────┘              └──────────┬─────────┘
             │                                    │
   ┌─────────▼──────────┐              ┌─────────▼──────────┐
   │Transaction Service │              │   Loan Service     │
   │   (Puerto 8083)    │              │   (Puerto 8084)    │
   └────────────────────┘              └────────────────────┘
                         ┌──────────────────┐
                         │  Pool Service    │
                         │  (Puerto 8085)   │
                         └──────────────────┘
```

### Microservicios

| Servicio | Puerto | Base de Datos | Descripción |
|----------|--------|---------------|-------------|
| **auth-service** | 8081 | nuvo_auth_db | Autenticación y gestión de usuarios |
| **account-service** | 8082 | nuvo_account_db | Gestión de cuentas bancarias |
| **transaction-service** | 8083 | nuvo_transaction_db | Procesamiento de transacciones |
| **loan-service** | 8084 | nuvo_loan_db | Gestión de préstamos |
| **pool-service** | 8085 | nuvo_pool_db | Sistema de inversiones |
| **nuvo-web-admin** | 4200 | - | Interfaz de usuario Angular |

## 🛠️ Tecnologías

### Backend
- **Java 17**
- **Spring Boot 3.2.3**
- **Spring Security** - Seguridad y autenticación
- **Spring Data JPA** - Persistencia
- **Hibernate** - ORM
- **JWT** - JSON Web Tokens
- **OpenFeign** - Cliente HTTP declarativo
- **Lombok** - Reducción de código boilerplate
- **Maven** - Gestión de dependencias

### Frontend
- **Angular 20.3.6**
- **TypeScript**
- **RxJS**
- **Angular Material** (opcional)

### Base de Datos
- **MySQL/MariaDB 10.6+**
- Arquitectura multi-database (una base de datos por microservicio)

## 📦 Requisitos Previos

Antes de comenzar, asegúrate de tener instalado:

- ☕ **Java JDK 17** o superior
- 📦 **Maven 3.6+**
- 🗄️ **MySQL/MariaDB 10.6+**
- 🟢 **Node.js 18+** y **npm**
- 📱 **Angular CLI** (`npm install -g @angular/cli`)

## 🚀 Instalación

### 1. Clonar el Repositorio

```bash
git clone https://github.com/ASADDS2/NUVO.git
cd NUVO
```

### 2. Configurar la Base de Datos

#### Opción A: Ejecutar Script SQL

```bash
# Iniciar sesión en MySQL/MariaDB
mysql -u root -p

# Dentro de MySQL, ejecutar:
source docs/insert_data.sql
```

#### Opción B: Crear Bases de Datos Manualmente

```sql
CREATE DATABASE nuvo_auth_db;
CREATE DATABASE nuvo_account_db;
CREATE DATABASE nuvo_transaction_db;
CREATE DATABASE nuvo_loan_db;
CREATE DATABASE nuvo_pool_db;

GRANT ALL PRIVILEGES ON nuvo_auth_db.* TO 'root'@'localhost';
GRANT ALL PRIVILEGES ON nuvo_account_db.* TO 'root'@'localhost';
GRANT ALL PRIVILEGES ON nuvo_transaction_db.* TO 'root'@'localhost';
GRANT ALL PRIVILEGES ON nuvo_loan_db.* TO 'root'@'localhost';
GRANT ALL PRIVILEGES ON nuvo_pool_db.* TO 'root'@'localhost';
FLUSH PRIVILEGES;
```

### 3. Configurar Credenciales de Base de Datos

Actualiza los archivos `application.yml` en cada microservicio con tus credenciales:

```yaml
spring:
  datasource:
    username: root
    password: TU_CONTRASEÑA
```

**Archivos a actualizar:**
- `nuvo-auth-service/src/main/resources/application.yml`
- `nuvo-account-service/src/main/resources/application.yml`
- `nuvo-transaction-service/src/main/resources/application.yml`
- `nuvo-loan-service/src/main/resources/application.yml`
- `nuvo-pool-service/src/main/resources/application.yml`

### 4. Compilar los Microservicios

```bash
# Compilar todos los microservicios
cd nuvo-auth-service && ./mvnw clean install -DskipTests && cd ..
cd nuvo-account-service && ./mvnw clean install -DskipTests && cd ..
cd nuvo-transaction-service && ./mvnw clean install -DskipTests && cd ..
cd nuvo-loan-service && ./mvnw clean install -DskipTests && cd ..
cd nuvo-pool-service && ./mvnw clean install -DskipTests && cd ..
```

### 5. Instalar Dependencias del Frontend

```bash
cd nuvo-web-admin
npm install
cd ..
```

## ⚙️ Configuración

### Variables de Entorno (Opcional)

Puedes configurar variables de entorno para personalizar la configuración:

```bash
export DB_USERNAME=root
export DB_PASSWORD=tu_contraseña
export JWT_SECRET=tu_clave_secreta_jwt
```

## 🎯 Uso

### Iniciar los Microservicios

Abre **5 terminales diferentes** y ejecuta cada servicio:

```bash
# Terminal 1 - Auth Service
cd nuvo-auth-service
./mvnw spring-boot:run

# Terminal 2 - Account Service
cd nuvo-account-service
./mvnw spring-boot:run

# Terminal 3 - Transaction Service
cd nuvo-transaction-service
./mvnw spring-boot:run

# Terminal 4 - Loan Service  
cd nuvo-loan-service
./mvnw spring-boot:run

# Terminal 5 - Pool Service
cd nuvo-pool-service
./mvnw spring-boot:run
```

### Iniciar el Frontend

```bash
# Terminal 6 - Frontend
cd nuvo-web-admin
ng serve
```

### Acceder a la Aplicación

Una vez que todos los servicios estén corriendo:

🌐 **Frontend**: http://localhost:4200

## 🔑 Usuarios de Prueba

| Email | Contraseña | Rol |
|-------|------------|-----|
| bruno@nuvo.com | password | ADMIN |
| elena@nuvo.com | password | USER |
| juan@nuvo.com | password | USER |
| sofia@nuvo.com | password | USER |

## 📡 API Endpoints

### Auth Service (8081)

```
POST   /api/v1/auth/register  - Registrar nuevo usuario
POST   /api/v1/auth/login     - Iniciar sesión
POST   /api/v1/auth/refresh   - Refrescar token
```

### Account Service (8082)

```
GET    /api/v1/accounts                 - Listar todas las cuentas
GET    /api/v1/accounts/{id}            - Obtener cuenta por ID
GET    /api/v1/accounts/user/{userId}   - Obtener cuenta por usuario
POST   /api/v1/accounts                 - Crear nueva cuenta
PUT    /api/v1/accounts/{id}            - Actualizar cuenta
DELETE /api/v1/accounts/{id}            - Eliminar cuenta
POST   /api/v1/accounts/{userId}/deposit - Depositar/retirar
```

### Transaction Service (8083)

```
GET    /api/v1/transactions              - Listar todas las transacciones
GET    /api/v1/transactions/{id}         - Obtener transacción por ID
GET    /api/v1/transactions/user/{userId} - Transacciones de usuario
POST   /api/v1/transactions/transfer     - Realizar transferencia
POST   /api/v1/transactions/deposit      - Realizar depósito
```

### Loan Service (8084)

```
GET    /api/v1/loans                 - Listar todos los préstamos
GET    /api/v1/loans/{id}            - Obtener préstamo por ID
GET    /api/v1/loans/user/{userId}   - Préstamos de usuario
POST   /api/v1/loans                 - Solicitar préstamo
PUT    /api/v1/loans/{id}/approve    - Aprobar préstamo
PUT    /api/v1/loans/{id}/reject     - Rechazar préstamo
PUT    /api/v1/loans/{id}/pay        - Realizar pago
```

### Pool Service (8085)

```
GET    /api/v1/pool                      - Listar todas las inversiones
GET    /api/v1/pool/my-investments/{userId} - Inversiones del usuario
GET    /api/v1/pool/stats/{userId}       - Estadísticas de inversión
POST   /api/v1/pool/invest               - Realizar inversión
POST   /api/v1/pool/withdraw/{id}        - Retirar inversión
```

## 🗄️ Base de Datos

### Esquema de Datos

#### nuvo_auth_db
```sql
_user (id, firstname, lastname, email, password, role)
```

#### nuvo_account_db
```sql
accounts (id, user_id, account_number, balance, created_at)
```

#### nuvo_transaction_db
```sql
transactions (id, source_user_id, target_user_id, amount, type, timestamp)
```

#### nuvo_loan_db
```sql
loans (id, user_id, amount, term_months, interest_rate, status, paid_amount, created_at, approved_at)
```

#### nuvo_pool_db
```sql
investments (id, user_id, invested_amount, status, invested_at)
```

### Poblar con Datos de Prueba

```bash
mysql -u root -p < docs/insert_data.sql
```

Esto creará:
- 10 usuarios
- 10 cuentas con balances variados
- 20 transacciones de ejemplo
- 10 préstamos en diferentes estados
- 4 inversiones activas

## 🧪 Testing

```bash
# Ejecutar tests de un microservicio
cd nuvo-auth-service
./mvnw test

# Ejecutar tests del frontend
cd nuvo-web-admin
npm test
```

## 🐛 Troubleshooting

### Error de Conexión a Base de Datos

Si obtienes `Access denied for user 'root'@'localhost'`:

1. Verifica tus credenciales en `application.yml`
2. Asegúrate de que MySQL/MariaDB esté corriendo
3. Otorga permisos al usuario:

```sql
ALTER USER 'root'@'localhost' IDENTIFIED BY 'tu_contraseña';
FLUSH PRIVILEGES;
```

### Puerto Ya en Uso

Si un puerto está ocupado:

```bash
# Linux/Mac
lsof -i :8081  # Reemplaza 8081 con el puerto
kill -9 <PID>

# Windows
netstat -ano | findstr :8081
taskkill /PID <PID> /F
```

### Problemas con Angular

```bash
cd nuvo-web-admin
rm -rf node_modules package-lock.json
npm install
ng serve
```

## 🤝 Contribuir

¡Las contribuciones son bienvenidas! Por favor:

1. Fork el proyecto
2. Crea una rama para tu característica (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📝 Roadmap

- [ ] Implementar notificaciones en tiempo real
- [ ] Agregar tests unitarios y de integración
- [ ] Implementar Circuit Breaker con Resilience4j
- [ ] Agregar API Gateway (Spring Cloud Gateway)
- [ ] Implementar Service Discovery (Eureka)
- [ ] Containerización con Docker
- [ ] Orquestación con Kubernetes
- [ ] CI/CD con GitHub Actions

## 👥 Autores

- **Tu Nombre** - *Desarrollo Inicial* - [ASADDS2](https://github.com/ASADDS2)

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.

## 🙏 Agradecimientos

- Spring Boot por el excelente framework
- Angular por la poderosa plataforma frontend
- La comunidad de código abierto

---

⭐ **Si este proyecto te fue útil, considera darle una estrella!** ⭐

Para preguntas o soporte, abre un [issue](https://github.com/ASADDS2/NUVO/issues).
