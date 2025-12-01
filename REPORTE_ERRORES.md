# REPORTE DE ERRORES Y RIESGOS – NUVO

Fecha: 2025-12-01

## Resumen ejecutivo
- Se detectaron fallas críticas de seguridad (backdoor de login, secretos y credenciales en texto plano, CORS permisivo, endpoints abiertos).
- Inconsistencias entre documentación y código (README indica MySQL; el código usa PostgreSQL).
- Problemas de robustez en scripts (arranque/paro, readiness de DB, portabilidad).
- Configuración de Maven inconsistente (falta `lombok.version` en un microservicio).
- Higiene del repositorio mejorable (archivos .log y binarios grandes versionados, rutas absolutas en scripts de docs).

---

## Hallazgos por carpeta/archivo

### Raíz del repositorio
- **/README.md**
  - Inconsistencia: documenta "MySQL/MariaDB" mientras todos los `application.yml` usan **PostgreSQL**.
  - Requisitos de Node: se indica "Node 18+". Angular 20 requiere Node 18.19.1+ o 20.10+ (revisar versión exacta instalada).
- **/*.log (auth.log, auth_new.log, loan.log, pool.log, transaction.log)**
  - Archivos de log versionados. Deben ignorarse con `.gitignore`.
- **/docker-compose.yml**
  - Usa `network_mode: host` (solo Linux, poco portable).
  - Sin `healthcheck`, `restart: unless-stopped` ni variables parametrizables.
  - `command: -p 5444` cambia el puerto del servidor Postgres interno a 5444. Funciona, pero no es común; suele mapearse `5432`→`5444` con `ports:`.
- **/start-all.sh**
  - Mezcla Docker "a mano" con Compose (posible duplicidad/confusión).
  - Arranca Postgres con `--network host` (no portable) y no valida readiness (solo `sleep 10`).
  - Usa `lsof` para revisar puertos (no siempre instalado).
  - No instala dependencias del frontend ni verifica `mvnw` ejecutable.
  - No maneja caída/errores del `mvnw spring-boot:run` (solo redirige logs a /tmp).
- **/stop-all.sh**
  - No espera a la terminación (`wait`) ni aplica SIGKILL si no termina.
  - No detiene/remueve el contenedor Postgres (`nuvo_postgres`).

### /docker
- **/docker/init-scripts/01-create-dbs.sql**
  - Crea las 5 bases. Correcto para inicialización.

### /docs
- **setup_postgres.sh**
  - Usa `sudo -u postgres` (depende de usuario del SO; no funciona en contenedor).
  - Imprime una ruta absoluta fija: `/home/Coder/Descargas/NUVO-main/NUVO/docs/insert_data.sql` (incorrecta para otras máquinas). Debe ser relativa.
- **setup_postgres.sql**
  - `GRANT ALL ... TO postgres;` redundante; `postgres` ya tiene privilegios.
- **insert_data.sql**
  - Orientado a PostgreSQL. OK.
- **pool_migration.sql**
  - Tipos correctos para Postgres; usar `double precision` en lugar de `float(53)` por claridad.
- **screen-capture.webm**
  - Binario grande versionado. Considerar Git LFS o excluir.

### Microservicios Backend
- Común en `application.yml` (auth, account, transaction, loan, pool)
  - **Credenciales en texto plano** (`username: postgres`, `password: 1234`). Riesgo alto. Externalizar a variables de entorno.
  - `spring.jpa.hibernate.ddl-auto: update` apropiado para dev, no para prod.

- **nuvo-auth-service**
  - Archivo: `src/main/resources/application.yml`
    - **Secreto JWT hardcodeado** (`application.security.jwt.secret-key`). Riesgo crítico. Debe provenir de secreto/entorno.
  - Archivo: `infrastructure/config/SecurityConfig.java`
    - `anyRequest().permitAll()` deja todo el API abierto. Riesgo alto.
    - Se imprime el hash de la contraseña del usuario en logs (`System.out.println("DEBUG - Password en BD: ...")`). Evitar loggear hashes.
  - Archivo: `infrastructure/adapters/AuthenticationAdapter.java`
    - **Backdoor**: acceso especial para `bruno@nuvo.com` con `password123`. Riesgo crítico; eliminar inmediatamente.
  - Logs (`auth.log`, `auth_new.log`)
    - Errores "Bad credentials" en pruebas y terminación con exit 137 (esperable si se mata el proceso desde `stop-all.sh`).

- **nuvo-account-service**
  - Archivo: `pom.xml`
    - Falta la propiedad `lombok.version`, pero el `maven-compiler-plugin` la usa en `annotationProcessorPaths`:
      - Consecuencia: build puede fallar por propiedad no definida.
      - Solución: añadir `<lombok.version>1.18.30</lombok.version>` en `<properties>` (o unificar versión con el resto de servicios).

- **nuvo-transaction-service / nuvo-loan-service / nuvo-pool-service**
  - POMs y `application.yml` consistentes con PostgreSQL.
  - `nuvo-pool-service`: código principal `com.nuvo.pool.PoolApplication` OK. Los logs antiguos muestran `com.nuvo.loan.PoolApplication` (probable nombre de paquete incorrecto en una versión previa ya corregida).

### Frontend – /nuvo-web-admin (Angular)
- `package.json`: Angular 20.3.x.
- Requisitos de Node: asegurar Node 18.19.1+ o 20.10+.
- Sin `.nvmrc`/`.node-version` para fijar versión. Recomendable añadir.

### Mobile – /flutter_nuvo_app (Flutter)
- Proyecto base; no integrado al arranque. Sin errores críticos visibles en `pubspec.yaml`.

---

## Seguridad – resumen de riesgos críticos
- **Backdoor de autenticación** en `AuthenticationAdapter.java`. CRÍTICO.
- **JWT secret** hardcodeado en `nuvo-auth-service/application.yml`. CRÍTICO.
- **Credenciales de DB** hardcodeadas y débiles (`postgres/1234`). ALTO.
- **CORS permisivo con credenciales** (permite `*` + `allowCredentials(true)`). ALTO.
- **API expuesta** (`anyRequest().permitAll()`). ALTO.
- **Divulgación de información sensible** (hashes de contraseña en logs). MEDIO.

---

## Recomendaciones concretas
- **Eliminar backdoor** y agregar pruebas de autenticación.
- **Externalizar secretos**: mover JWT secret y credenciales a variables de entorno o gestor de secretos.
- **Restringir CORS**: dominios específicos y revisar `allowCredentials`.
- **Asegurar rutas**: reemplazar `anyRequest().permitAll()` por reglas de autorización adecuadas.
- **Higiene de logs**: no imprimir hashes ni datos sensibles; usar niveles y mascarado.
- **Unificar base de datos**: corregir README para PostgreSQL (o parametrizar ambos motores si procede).
- **Maven**: agregar `lombok.version` en `nuvo-account-service/pom.xml` (y homogeneizar versión en todos los servicios).
- **Scripts**:
  - `start-all.sh`: chequear `pg_isready`, fallback a `ss`/`netstat` si no hay `lsof`, manejar errores de arranque, instalar deps del frontend si faltan.
  - `stop-all.sh`: `kill -TERM` + `wait` + `kill -9` si es necesario; detener contenedor `nuvo_postgres`.
- **Docker/Compose**:
  - Evitar `network_mode: host`; usar `ports: ["5444:5432"]` y `healthcheck`.
  - Añadir `restart: unless-stopped` y variables por entorno (`POSTGRES_PASSWORD`, etc.).
- **Repo**:
  - Añadir `.gitignore` en raíz: ignorar `*.log`, `node_modules/`, `target/`, binarios grandes, `.vscode/` (opcional).
  - Mover binarios grandes a Git LFS o a releases.
- **Docs**:
  - Quitar rutas absolutas en `docs/setup_postgres.sh`; usar rutas relativas.
  - Alinear instrucciones de instalación con PostgreSQL.

---

## Anexo – Ubicaciones exactas clave
- Backdoor: `nuvo-auth-service/src/main/java/com/nuvo/auth/infrastructure/adapters/AuthenticationAdapter.java` (líneas ~22–26).
- JWT secret: `nuvo-auth-service/src/main/resources/application.yml` (`application.security.jwt.secret-key`).
- CORS permisivo: `nuvo-auth-service/.../config/CorsConfig.java` (`allowedOriginPatterns=["*"]`, `allowCredentials(true)`).
- Endpoints abiertos: `nuvo-auth-service/.../config/SecurityConfig.java` (`anyRequest().permitAll()`).
- Hash en logs: `nuvo-auth-service/.../config/SecurityConfig.java` (`System.out.println("DEBUG - Password en BD: ...")`).
- Credenciales DB en texto plano: `*/src/main/resources/application.yml` en todos los microservicios.
- POM sin `lombok.version`: `nuvo-account-service/pom.xml`.
- Ruta absoluta incorrecta: `docs/setup_postgres.sh`.
