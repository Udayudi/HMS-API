CREATE TABLE staff (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    staff_uuid VARCHAR(36) NOT NULL UNIQUE,
    hospital_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    employee_id VARCHAR(50) NOT NULL,
    designation VARCHAR(100),
    department VARCHAR(100),
    date_of_joining DATE,
    qualification TEXT,
    specialization VARCHAR(255),
    experience_years INT,
    shift_timing VARCHAR(100),
    salary DECIMAL(12,2),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (hospital_id) REFERENCES hospitals(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES hospital_users(id) ON DELETE CASCADE,
    UNIQUE KEY unique_hospital_employee (hospital_id, employee_id)
);

CREATE TABLE staff_attendance (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    staff_id BIGINT NOT NULL,
    attendance_date DATE NOT NULL,
    check_in_time TIME,
    check_out_time TIME,
    status ENUM('PRESENT', 'ABSENT', 'HALF_DAY', 'LEAVE') DEFAULT 'PRESENT',
    leave_type VARCHAR(50),
    notes TEXT,
    recorded_by BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (staff_id) REFERENCES staff(id) ON DELETE CASCADE,
    FOREIGN KEY (recorded_by) REFERENCES hospital_users(id),
    UNIQUE KEY unique_staff_attendance (staff_id, attendance_date)
);