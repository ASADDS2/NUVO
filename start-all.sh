#!/bin/bash

# Script para levantar todos los servicios de NUVO
# Autor: ASADDS2
# Descripción: Inicia todos los microservicios y el frontend

echo "🏦 NUVO - Sistema Bancario"
echo "=========================="
echo ""

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Directorio base
BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Función para verificar si un puerto está en uso
check_port() {
    local port=$1
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

# Función para iniciar un servicio Spring Boot
start_service() {
    local service_name=$1
    local service_port=$2
    local service_dir="$BASE_DIR/$service_name"
    
    echo -e "${YELLOW}📦 Iniciando $service_name en puerto $service_port...${NC}"
    
    if check_port $service_port; then
        echo -e "${GREEN}✓ $service_name ya está corriendo en puerto $service_port${NC}"
    else
        cd "$service_dir"
        ./mvnw spring-boot:run > /tmp/nuvo-$service_name.log 2>&1 &
        echo $! > /tmp/nuvo-$service_name.pid
        echo -e "${GREEN}✓ $service_name iniciado (PID: $(cat /tmp/nuvo-$service_name.pid))${NC}"
        echo "  Log: /tmp/nuvo-$service_name.log"
    fi
    echo ""
}

# Verificar PostgreSQL
echo -e "${YELLOW}🔍 Verificando PostgreSQL...${NC}"
if systemctl is-active --quiet postgresql; then
    echo -e "${GREEN}✓ PostgreSQL está corriendo${NC}"
else
    echo -e "${RED}✗ PostgreSQL no está corriendo. Iniciando...${NC}"
    sudo systemctl start postgresql
fi
echo ""

# Iniciar microservicios en orden
echo -e "${YELLOW}🚀 Iniciando Microservicios Backend...${NC}"
echo ""

start_service "nuvo-auth-service" 8081
sleep 3

start_service "nuvo-account-service" 8082
sleep 2

start_service "nuvo-transaction-service" 8083
sleep 2

start_service "nuvo-loan-service" 8084
sleep 2

start_service "nuvo-pool-service" 8085
sleep 2

# Iniciar frontend
echo -e "${YELLOW}🌐 Iniciando Frontend Angular...${NC}"

if check_port 4200; then
    echo -e "${GREEN}✓ Frontend ya está corriendo en puerto 4200${NC}"
else
    cd "$BASE_DIR/nuvo-web-admin"
    npm start > /tmp/nuvo-frontend.log 2>&1 &
    echo $! > /tmp/nuvo-frontend.pid
    echo -e "${GREEN}✓ Frontend iniciado (PID: $(cat /tmp/nuvo-frontend.pid))${NC}"
    echo "  Log: /tmp/nuvo-frontend.log"
fi
echo ""

# Resumen
echo ""
echo -e "${GREEN}✅ ¡Todos los servicios están iniciados!${NC}"
echo ""
echo "📊 Estado de Servicios:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  🔐 Auth Service:        http://localhost:8081"
echo "  💰 Account Service:     http://localhost:8082"
echo "  💸 Transaction Service: http://localhost:8083"
echo "  🏦 Loan Service:        http://localhost:8084"
echo "  📈 Pool Service:        http://localhost:8085"
echo "  🌐 Frontend:            http://localhost:4200"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📝 Logs disponibles en:"
echo "  /tmp/nuvo-*.log"
echo ""
echo "🛑 Para detener todos los servicios, ejecuta:"
echo "  ./stop-all.sh"
echo ""
