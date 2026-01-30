CREATE TABLE service_items (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    item_uuid VARCHAR(36) NOT NULL UNIQUE,
    hospital_id BIGINT NOT NULL,
    item_code VARCHAR(50) NOT NULL,
    item_name VARCHAR(255) NOT NULL,
    category ENUM('CONSULTATION', 'PROCEDURE', 'MEDICINE', 'LAB_TEST', 'ROOM_CHARGE', 'OTHER') DEFAULT 'OTHER',
    price DECIMAL(10,2) NOT NULL,
    tax_percentage DECIMAL(5,2) DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (hospital_id) REFERENCES hospitals(id) ON DELETE CASCADE,
    UNIQUE KEY unique_hospital_item_code (hospital_id, item_code)
);

CREATE TABLE invoices (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    invoice_uuid VARCHAR(36) NOT NULL UNIQUE,
    hospital_id BIGINT NOT NULL,
    invoice_number VARCHAR(50) NOT NULL,
    patient_id BIGINT NOT NULL,
    billing_date DATE NOT NULL,
    billing_time TIME NOT NULL,
    total_amount DECIMAL(12,2) NOT NULL,
    discount_amount DECIMAL(12,2) DEFAULT 0,
    tax_amount DECIMAL(12,2) DEFAULT 0,
    net_amount DECIMAL(12,2) NOT NULL,
    paid_amount DECIMAL(12,2) DEFAULT 0,
    due_amount DECIMAL(12,2) DEFAULT 0,
    status ENUM('DRAFT', 'GENERATED', 'PARTIALLY_PAID', 'PAID', 'CANCELLED') DEFAULT 'DRAFT',
    payment_mode ENUM('CASH', 'CARD', 'CHEQUE', 'ONLINE', 'INSURANCE'),
    notes TEXT,
    created_by BIGINT,
    updated_by BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (hospital_id) REFERENCES hospitals(id) ON DELETE CASCADE,
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES hospital_users(id),
    FOREIGN KEY (updated_by) REFERENCES hospital_users(id),
    UNIQUE KEY unique_hospital_invoice (hospital_id, invoice_number)
);

CREATE TABLE invoice_items (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    invoice_id BIGINT NOT NULL,
    service_item_id BIGINT,
    item_description VARCHAR(255) NOT NULL,
    quantity INT DEFAULT 1,
    unit_price DECIMAL(10,2) NOT NULL,
    discount_percentage DECIMAL(5,2) DEFAULT 0,
    tax_percentage DECIMAL(5,2) DEFAULT 0,
    total_amount DECIMAL(12,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (invoice_id) REFERENCES invoices(id) ON DELETE CASCADE,
    FOREIGN KEY (service_item_id) REFERENCES service_items(id)
);

CREATE TABLE payments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    payment_uuid VARCHAR(36) NOT NULL UNIQUE,
    invoice_id BIGINT NOT NULL,
    payment_date DATE NOT NULL,
    payment_time TIME NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    payment_mode ENUM('CASH', 'CARD', 'CHEQUE', 'ONLINE', 'INSURANCE') NOT NULL,
    transaction_id VARCHAR(100),
    reference_number VARCHAR(100),
    status ENUM('PENDING', 'COMPLETED', 'FAILED', 'REFUNDED') DEFAULT 'COMPLETED',
    notes TEXT,
    received_by BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (invoice_id) REFERENCES invoices(id) ON DELETE CASCADE,
    FOREIGN KEY (received_by) REFERENCES hospital_users(id)
);