/* ==================================================
   INSERTAR DATOS DE PRUEBA EN LAS BASES DE DATOS
   PostgreSQL Version
   ================================================== */

-- ========== 1. USUARIOS (AUTH) ==========
\c nuvo_auth_db;

INSERT INTO _user (id, firstname, lastname, email, password, role) VALUES
(1, 'Bruno', 'Diaz', 'bruno@nuvo.com', '$2a$10$slYQmyNdGzTn7ZLBXBChFOC9f6kFjAqPhccnP6DxlZ/r2sZ8NCNRa', 'ADMIN'),
(2, 'Elena', 'Gomez', 'elena@nuvo.com', '$2a$10$slYQmyNdGzTn7ZLBXBChFOC9f6kFjAqPhccnP6DxlZ/r2sZ8NCNRa', 'USER'),
(3, 'Juan', 'Perez', 'juan@nuvo.com', '$2a$10$slYQmyNdGzTn7ZLBXBChFOC9f6kFjAqPhccnP6DxlZ/r2sZ8NCNRa', 'USER'),
(4, 'Sofia', 'Vergara', 'sofia@nuvo.com', '$2a$10$slYQmyNdGzTn7ZLBXBChFOC9f6kFjAqPhccnP6DxlZ/r2sZ8NCNRa', 'USER'),
(5, 'Carlos', 'Vives', 'carlos@nuvo.com', '$2a$10$slYQmyNdGzTn7ZLBXBChFOC9f6kFjAqPhccnP6DxlZ/r2sZ8NCNRa', 'USER'),
(6, 'Shakira', 'Mebarak', 'shakira@nuvo.com', '$2a$10$slYQmyNdGzTn7ZLBXBChFOC9f6kFjAqPhccnP6DxlZ/r2sZ8NCNRa', 'USER'),
(7, 'James', 'Rodriguez', 'james@nuvo.com', '$2a$10$slYQmyNdGzTn7ZLBXBChFOC9f6kFjAqPhccnP6DxlZ/r2sZ8NCNRa', 'USER'),
(8, 'Karol', 'G', 'karol@nuvo.com', '$2a$10$slYQmyNdGzTn7ZLBXBChFOC9f6kFjAqPhccnP6DxlZ/r2sZ8NCNRa', 'USER'),
(9, 'Radamel', 'Falcao', 'falcao@nuvo.com', '$2a$10$slYQmyNdGzTn7ZLBXBChFOC9f6kFjAqPhccnP6DxlZ/r2sZ8NCNRa', 'USER'),
(10, 'Egan', 'Bernal', 'egan@nuvo.com', '$2a$10$slYQmyNdGzTn7ZLBXBChFOC9f6kFjAqPhccnP6DxlZ/r2sZ8NCNRa', 'USER')
ON CONFLICT (id) DO UPDATE SET firstname = EXCLUDED.firstname;

-- ========== 2. CUENTAS (ACCOUNTS) ==========
\c nuvo_account_db;

INSERT INTO accounts (user_id, account_number, balance, created_at) VALUES
(1, '1000000001', 500000.00, NOW()),
(2, '2000000002', 35000.00, NOW()),
(3, '3000000003', 800.00, NOW()),
(4, '4000000004', 150000.00, NOW()),
(5, '5000000005', 2000.00, NOW()),
(6, '6000000006', 2500000.00, NOW()),
(7, '7000000007', 80000.00, NOW()),
(8, '8000000008', 300000.00, NOW()),
(9, '9000000009', 120000.00, NOW()),
(10, '1000000010', 5500.00, NOW())
ON CONFLICT (user_id) DO UPDATE SET balance = EXCLUDED.balance;

-- ========== 3. TRANSACCIONES ==========
\c nuvo_transaction_db;

INSERT INTO transactions (source_user_id, target_user_id, amount, type, timestamp) VALUES
(NULL, 1, 500000.00, 'DEPOSIT', NOW() - INTERVAL '30 days'),
(NULL, 6, 2500000.00, 'DEPOSIT', NOW() - INTERVAL '29 days'),
(6, 8, 5000.00, 'TRANSFER', NOW() - INTERVAL '10 days'),
(1, 3, 200.00, 'TRANSFER', NOW() - INTERVAL '5 days'),
(7, 5, 100.00, 'TRANSFER', NOW() - INTERVAL '2 days'),
(2, 3, 50.00, 'TRANSFER', NOW() - INTERVAL '1 day'),
(NULL, 4, 150000.00, 'DEPOSIT', NOW() - INTERVAL '60 days'),
(NULL, 7, 80000.00, 'DEPOSIT', NOW() - INTERVAL '45 days'),
(4, 2, 1000.00, 'TRANSFER', NOW() - INTERVAL '3 days'),
(8, 9, 2500.00, 'TRANSFER', NOW() - INTERVAL '1 day');

-- ========== 4. PRÉSTAMOS ==========
\c nuvo_loan_db;

INSERT INTO loans (user_id, amount, term_months, interest_rate, status, paid_amount, created_at, approved_at) VALUES
(5, 10000.00, 12, 5.00, 'APPROVED', 0.00, NOW() - INTERVAL '10 days', NOW() - INTERVAL '10 days'),
(10, 20000.00, 24, 5.00, 'APPROVED', 10000.00, NOW() - INTERVAL '60 days', NOW() - INTERVAL '60 days'),
(9, 50000.00, 12, 5.00, 'PAID', 53000.00, NOW() - INTERVAL '365 days', NOW() - INTERVAL '365 days'),
(2, 5000.00, 6, 5.00, 'PENDING', 0.00, NOW() - INTERVAL '2 days', NULL),
(7, 30000.00, 18, 5.00, 'APPROVED', 5000.00, NOW() - INTERVAL '90 days', NOW() - INTERVAL '88 days');

-- ========== 5. INVERSIONES (POOL) ==========
\c nuvo_pool_db;

INSERT INTO investments (user_id, invested_amount, status, invested_at) VALUES
(4, 50000.00, 'ACTIVE', NOW() - INTERVAL '5 days'),
(6, 1000000.00, 'ACTIVE', NOW() - INTERVAL '20 days'),
(1, 100000.00, 'ACTIVE', NOW() - INTERVAL '15 days'),
(8, 75000.00, 'WITHDRAWN', NOW() - INTERVAL '30 days');

SELECT '✅ Datos insertados correctamente en todas las bases de datos' AS Status;
