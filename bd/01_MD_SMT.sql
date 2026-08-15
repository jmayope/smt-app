CREATE TABLE companies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    business_type VARCHAR(100),
    ruc VARCHAR(20),
    phone VARCHAR(50),
    address TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID REFERENCES companies(id) ON DELETE CASCADE,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    document_id VARCHAR(50),
    phone VARCHAR(50),
    role VARCHAR(50) CHECK (role IN ('administrador', 'administrador_empresa', 'supervisor', 'conductor')),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    last_login TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    has_2fa BOOLEAN DEFAULT FALSE
);

CREATE TABLE subscription_packages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(50) NOT NULL, -- 'BASICO', 'REGULAR', 'VIP'
    description TEXT,
    max_users INTEGER NOT NULL,
    max_supervisors INTEGER NOT NULL,
    max_drivers INTEGER NOT NULL,
    max_vehicles INTEGER NOT NULL,
    price DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT NOW(),
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE company_subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID REFERENCES companies(id) ON DELETE CASCADE,
    package_id UUID REFERENCES subscription_packages(id),
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    is_active BOOLEAN DEFAULT TRUE,
    is_trial BOOLEAN DEFAULT FALSE
);

CREATE TABLE vehicles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID REFERENCES companies(id) ON DELETE CASCADE,
    license_plate VARCHAR(20) UNIQUE NOT NULL,
    brand VARCHAR(100),
    model VARCHAR(100),
    year INTEGER,
    vehicle_type VARCHAR(50) CHECK (vehicle_type IN ('camion_encapsulado', 'camion_bombona', 'camion_retro')),
    capacity_tons INTEGER, -- 25, 30, 35
    material_type VARCHAR(50) DEFAULT 'oro',
    color VARCHAR(50),
    vin VARCHAR(50),
    insurance_number VARCHAR(100),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    is_active BOOLEAN DEFAULT TRUE,
    has_maintenance_scheduled BOOLEAN DEFAULT FALSE,
    is_available BOOLEAN DEFAULT TRUE
);

CREATE TABLE vehicle_documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    vehicle_id UUID REFERENCES vehicles(id) ON DELETE CASCADE,
    document_type VARCHAR(50),
    document_number VARCHAR(100),
    expiry_date DATE,
    file_url TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    is_valid BOOLEAN DEFAULT TRUE,
    has_notification_sent BOOLEAN DEFAULT FALSE
);

CREATE TABLE routes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID REFERENCES companies(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    start_location VARCHAR(255),
    end_location VARCHAR(255),
    distance_km DECIMAL(10, 2),
    estimated_duration_hours DECIMAL(5, 2),
    description TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    is_active BOOLEAN DEFAULT TRUE,
    is_priority BOOLEAN DEFAULT FALSE
);

CREATE TABLE route_points (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    route_id UUID REFERENCES routes(id) ON DELETE CASCADE,
    point_code VARCHAR(10) NOT NULL, -- I1, I2, I3, P1, P2
    point_type VARCHAR(20) CHECK (point_type IN ('I', 'P')), -- I = Input, P = Processing
    name VARCHAR(100),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    address TEXT,
    sequence_order INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    estimated_arrival_minutes INTEGER
);

CREATE TABLE route_segments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    route_id UUID REFERENCES routes(id) ON DELETE CASCADE,
    from_point_id UUID REFERENCES route_points(id),
    to_point_id UUID REFERENCES route_points(id),
    segment_order INTEGER,
    distance_km DECIMAL(10, 2),
    estimated_time_minutes INTEGER,
    created_at TIMESTAMP DEFAULT NOW(),
    has_restriction BOOLEAN DEFAULT FALSE
);

CREATE TABLE transport_assignments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID REFERENCES companies(id) ON DELETE CASCADE,
    route_id UUID REFERENCES routes(id),
    vehicle_id UUID REFERENCES vehicles(id),
    driver_id UUID REFERENCES users(id),
    supervisor_id UUID REFERENCES users(id),
    assignment_date DATE NOT NULL,
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    estimated_start_time TIMESTAMP,
    estimated_end_time TIMESTAMP,
    status VARCHAR(50) CHECK (status IN ('pending', 'in_progress', 'completed', 'cancelled', 'delayed')),
    load_weight_tons DECIMAL(8, 2),
    material_type VARCHAR(50) DEFAULT 'oro',
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    has_delayed BOOLEAN DEFAULT FALSE,
    is_completed BOOLEAN DEFAULT FALSE,
    has_incident BOOLEAN DEFAULT FALSE
);

CREATE TABLE transport_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    assignment_id UUID REFERENCES transport_assignments(id) ON DELETE CASCADE,
    route_point_id UUID REFERENCES route_points(id),
    timestamp TIMESTAMP DEFAULT NOW(),
    location VARCHAR(255),
    event_type VARCHAR(50) CHECK (event_type IN ('departure', 'arrival', 'checkpoint', 'incident', 'delivery', 'fuel_stop', 'rest_stop')),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    has_issue BOOLEAN DEFAULT FALSE,
    is_verified BOOLEAN DEFAULT FALSE
);

CREATE TABLE transport_deliveries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    assignment_id UUID REFERENCES transport_assignments(id) ON DELETE CASCADE,
    delivery_point_id UUID REFERENCES route_points(id),
    delivered_at TIMESTAMP,
    received_by VARCHAR(100),
    received_signature_url TEXT,
    quantity_tons DECIMAL(8, 2),
    observations TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    is_delivered BOOLEAN DEFAULT FALSE,
    has_quality_check BOOLEAN DEFAULT FALSE
);

CREATE TABLE maintenance_records (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    vehicle_id UUID REFERENCES vehicles(id) ON DELETE CASCADE,
    maintenance_date TIMESTAMP NOT NULL,
    maintenance_type VARCHAR(100),
    cost DECIMAL(10, 2),
    description TEXT,
    performed_by VARCHAR(100),
    next_maintenance_date DATE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    is_completed BOOLEAN DEFAULT FALSE,
    has_warranty BOOLEAN DEFAULT FALSE,
    is_urgent BOOLEAN DEFAULT FALSE
);

CREATE TABLE user_company_roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    company_id UUID REFERENCES companies(id) ON DELETE CASCADE,
    role VARCHAR(50) CHECK (role IN ('admin', 'supervisor', 'driver', 'viewer')),
    assigned_at TIMESTAMP DEFAULT NOW(),
    is_active BOOLEAN DEFAULT TRUE,
    has_access_all BOOLEAN DEFAULT FALSE,
    UNIQUE(user_id, company_id, role)
);

CREATE TABLE company_settings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID REFERENCES companies(id) ON DELETE CASCADE UNIQUE,
    timezone VARCHAR(50) DEFAULT 'America/Lima',
    currency VARCHAR(10) DEFAULT 'PEN',
    language VARCHAR(10) DEFAULT 'es',
    notification_preferences JSONB,
    theme VARCHAR(50),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    has_multi_tenant BOOLEAN DEFAULT TRUE,
    has_gps_tracking BOOLEAN DEFAULT FALSE,
    has_real_time_alerts BOOLEAN DEFAULT FALSE
);

CREATE TABLE company_modules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID REFERENCES companies(id) ON DELETE CASCADE,
    module_name VARCHAR(100),
    is_enabled BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    has_config BOOLEAN DEFAULT FALSE,
    UNIQUE(company_id, module_name)
);

CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID REFERENCES companies(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id),
    action VARCHAR(100) NOT NULL,
    table_name VARCHAR(100),
    record_id UUID,
    old_data JSONB,
    new_data JSONB,
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE session_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    token VARCHAR(255),
    ip_address INET,
    user_agent TEXT,
    login_time TIMESTAMP DEFAULT NOW(),
    logout_time TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    has_expired BOOLEAN DEFAULT FALSE
);

CREATE TABLE incidents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID REFERENCES companies(id) ON DELETE CASCADE,
    assignment_id UUID REFERENCES transport_assignments(id),
    incident_type VARCHAR(50) CHECK (incident_type IN ('accident', 'mechanical_failure', 'theft', 'delay', 'weather', 'other')),
    severity VARCHAR(20) CHECK (severity IN ('low', 'medium', 'high', 'critical')),
    description TEXT,
    reported_at TIMESTAMP DEFAULT NOW(),
    resolved_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    is_resolved BOOLEAN DEFAULT FALSE,
    has_insurance_claim BOOLEAN DEFAULT FALSE
);

CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID REFERENCES companies(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id),
    title VARCHAR(255),
    message TEXT,
    notification_type VARCHAR(50),
    read_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW(),
    is_read BOOLEAN DEFAULT FALSE,
    is_sent BOOLEAN DEFAULT FALSE,
    has_attachment BOOLEAN DEFAULT FALSE
);

CREATE TABLE daily_reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID REFERENCES companies(id) ON DELETE CASCADE,
    report_date DATE NOT NULL,
    total_assignments INTEGER DEFAULT 0,
    completed_assignments INTEGER DEFAULT 0,
    delayed_assignments INTEGER DEFAULT 0,
    cancelled_assignments INTEGER DEFAULT 0,
    total_distance_km DECIMAL(10, 2),
    total_load_tons DECIMAL(10, 2),
    incidents_count INTEGER DEFAULT 0,
    generated_at TIMESTAMP DEFAULT NOW(),
    has_anomalies BOOLEAN DEFAULT FALSE
);

CREATE TABLE vehicle_usage_stats (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    vehicle_id UUID REFERENCES vehicles(id) ON DELETE CASCADE,
    period_start DATE,
    period_end DATE,
    total_trips INTEGER DEFAULT 0,
    total_distance_km DECIMAL(10, 2),
    total_load_tons DECIMAL(10, 2),
    maintenance_count INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    is_optimized BOOLEAN DEFAULT FALSE
);

