-- ================================================
-- NUVO PostgreSQL Database Setup Script
-- ================================================

-- Create databases
CREATE DATABASE nuvo_auth_db;
CREATE DATABASE nuvo_account_db;
CREATE DATABASE nuvo_transaction_db;
CREATE DATABASE nuvo_loan_db;
CREATE DATABASE nuvo_pool_db;

-- Set password for postgres user (if needed)
-- ALTER USER postgres WITH PASSWORD '1234';

-- Grant all privileges (already done by default for postgres user)
GRANT ALL PRIVILEGES ON DATABASE nuvo_auth_db TO postgres;
GRANT ALL PRIVILEGES ON DATABASE nuvo_account_db TO postgres;
GRANT ALL PRIVILEGES ON DATABASE nuvo_transaction_db TO postgres;
GRANT ALL PRIVILEGES ON DATABASE nuvo_loan_db TO postgres;
GRANT ALL PRIVILEGES ON DATABASE nuvo_pool_db TO postgres;

SELECT 'PostgreSQL databases created successfully!' AS status;
