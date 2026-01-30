CREATE TABLE wards (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    ward_uuid VARCHAR(36) NOT NULL UNIQUE,
    hospital_id BIGINT NOT NULL,
    ward_name VARCHAR(100) NOT NULL,
    ward_type ENUM('GENERAL', 'ICU', 'CCU', 'NICU', 'PICU', 'PRIVATE', 'SEMI_PRIVATE') DEFAULT 'GENERAL',
    floor_number INT,
    total_beds INT DEFAULT 0,
    available_beds INT DEFAULT 0,
    charge_per_day DECIMAL(10,2),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (hospital_id) REFERENCES hospitals(id) ON DELETE CASCADE
);

CREATE TABLE beds (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    bed_uuid VARCHAR(36) NOT NULL UNIQUE,
    ward_id BIGINT NOT NULL,
    bed_number VARCHAR(50) NOT NULL,
    bed_type ENUM('NORMAL', 'ICU', 'VENTILATOR', 'OXYGEN') DEFAULT 'NORMAL',
    status ENUM('AVAILABLE', 'OCCUPIED', 'MAINTENANCE', 'RESERVED') DEFAULT 'AVAILABLE',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (ward_id) REFERENCES wards(id) ON DELETE CASCADE,
    UNIQUE KEY unique_ward_bed (ward_id, bed_number)
);

CREATE TABLE ipd_admissions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    admission_uuid VARCHAR(36) NOT NULL UNIQUE,
    hospital_id BIGINT NOT NULL,
    patient_id BIGINT NOT NULL,
    admission_date DATE NOT NULL,
    admission_time TIME NOT NULL,
    admission_type ENUM('EMERGENCY', 'ROUTINE', 'TRANSFER') DEFAULT 'ROUTINE',
    admission_reason TEXT,
    diagnosis TEXT,
    doctor_id BIGINT,
    ward_id BIGINT NOT NULL,
    bed_id BIGINT NOT NULL,
    expected_stay_days INT,
    discharge_date DATE,
    discharge_time TIME,
    discharge_status ENUM('RECOVERED', 'REFERRED', 'LAMA', 'EXPIRED', 'DISCHARGED') DEFAULT 'DISCHARGED',
    discharge_summary TEXT,
    status ENUM('ADMITTED', 'DISCHARGED', 'TRANSFERRED') DEFAULT 'ADMITTED',
    created_by BIGINT,
    updated_by BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (hospital_id) REFERENCES hospitals(id) ON DELETE CASCADE,
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(id),
    FOREIGN KEY (ward_id) REFERENCES wards(id),
    FOREIGN KEY (bed_id) REFERENCES beds(id),
    FOREIGN KEY (created_by) REFERENCES hospital_users(id),
    FOREIGN KEY (updated_by) REFERENCES hospital_users(id)
);

CREATE TABLE ipd_daily_progress (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    admission_id BIGINT NOT NULL,
    progress_date DATE NOT NULL,
    progress_notes TEXT,
    vital_signs JSON,
    treatment_given TEXT,
    doctor_notes TEXT,
    nurse_notes TEXT,
    recorded_by BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (admission_id) REFERENCES ipd_admissions(id) ON DELETE CASCADE,
    FOREIGN KEY (recorded_by) REFERENCES hospital_users(id)
);