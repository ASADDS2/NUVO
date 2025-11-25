#!/bin/bash

# NUVO PostgreSQL Setup Script
# This script creates all necessary databases for the NUVO application

echo "Creating PostgreSQL databases..."

# Create databases using createdb command
sudo -u postgres createdb nuvo_auth_db 2>/dev/null || echo "nuvo_auth_db already exists"
sudo -u postgres createdb nuvo_account_db 2>/dev/null || echo "nuvo_account_db already exists"
sudo -u postgres createdb nuvo_transaction_db 2>/dev/null || echo "nuvo_transaction_db already exists"
sudo -u postgres createdb nuvo_loan_db 2>/dev/null || echo "nuvo_loan_db already exists"
sudo -u postgres createdb nuvo_pool_db 2>/dev/null || echo "nuvo_pool_db already exists"

# Set password for postgres user
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD '1234';" 2>/dev/null || echo "Password already set"

echo "✅ PostgreSQL databases created successfully!"
echo ""
echo "To insert test data, run:"
echo "sudo -u postgres psql -f /home/Coder/Descargas/NUVO-main/NUVO/docs/insert_data.sql"
