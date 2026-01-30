CREATE TABLE lab_test_types (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    test_type_uuid VARCHAR(36) NOT NULL UNIQUE,
    hospital_id BIGINT NOT NULL,
    test_code VARCHAR(50) NOT NULL,
    test_name VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    specimen_type VARCHAR(100),
    price DECIMAL(10,2),
    turnaround_hours INT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (hospital_id) REFERENCES hospitals(id) ON DELETE CASCADE,
    UNIQUE KEY unique_hospital_test_code (hospital_id, test_code)
);

CREATE TABLE lab_tests (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    test_uuid VARCHAR(36) NOT NULL UNIQUE,
    hospital_id BIGINT NOT NULL,
    patient_id BIGINT NOT NULL,
    test_type_id BIGINT NOT NULL,
    doctor_id BIGINT,
    requested_date DATE NOT NULL,
    requested_time TIME NOT NULL,
    specimen_collected_date DATE,
    specimen_collected_time TIME,
    priority ENUM('ROUTINE', 'URGENT', 'STAT') DEFAULT 'ROUTINE',
    status ENUM('REQUESTED', 'SAMPLE_COLLECTED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED') DEFAULT 'REQUESTED',
    notes TEXT,
    created_by BIGINT,
    updated_by BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (hospital_id) REFERENCES hospitals(id) ON DELETE CASCADE,
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE,
    FOREIGN KEY (test_type_id) REFERENCES lab_test_types(id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(id),
    FOREIGN KEY (created_by) REFERENCES hospital_users(id),
    FOREIGN KEY (updated_by) REFERENCES hospital_users(id)
);

CREATE TABLE lab_results (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    test_id BIGINT NOT NULL,
    parameter_name VARCHAR(255) NOT NULL,
    result_value VARCHAR(255),
    unit VARCHAR(50),
    normal_range VARCHAR(100),
    is_abnormal BOOLEAN DEFAULT FALSE,
    technician_notes TEXT,
    verified_by BIGINT,
    verified_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (test_id) REFERENCES lab_tests(id) ON DELETE CASCADE,
    FOREIGN KEY (verified_by) REFERENCES hospital_users(id)
);