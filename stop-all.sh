#!/bin/bash

# Script para detener todos los servicios de NUVO
# Autor: ASADDS2

echo "🛑 Deteniendo todos los servicios de NUVO..."
echo ""

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Función para detener un servicio
stop_service() {
    local service_name=$1
    local pid_file="/tmp/nuvo-$service_name.pid"
    
    if [ -f "$pid_file" ]; then
        local pid=$(cat "$pid_file")
        if ps -p $pid > /dev/null 2>&1; then
            echo -e "${YELLOW}⏹  Deteniendo $service_name (PID: $pid)...${NC}"
            kill $pid
            rm -f "$pid_file"
            echo -e "${GREEN}✓ $service_name detenido${NC}"
        else
            echo -e "${RED}✗ $service_name no está corriendo${NC}"
            rm -f "$pid_file"
        fi
    else
        echo -e "${YELLOW}⚠ No se encontró PID file para $service_name${NC}"
    fi
}

# Detener todos los servicios
stop_service "nuvo-auth-service"
stop_service "nuvo-account-service"
stop_service "nuvo-transaction-service"
stop_service "nuvo-loan-service"
stop_service "nuvo-pool-service"
stop_service "frontend"

echo ""
echo -e "${GREEN}✅ Todos los servicios han sido detenidos${NC}"
echo ""
