SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

CREATE DATABASE IF NOT EXISTS quaquy_project_cms CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE quaquy_project_cms;

CREATE TABLE users (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  role VARCHAR(50) NOT NULL DEFAULT 'staff',
  department VARCHAR(100) DEFAULT NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE customers (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  customer_name VARCHAR(150) NOT NULL,
  contact_name VARCHAR(100) DEFAULT NULL,
  customer_type VARCHAR(50) NOT NULL DEFAULT _utf8mb4'KH thường',
  note TEXT,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_customer_type (customer_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE projects (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  project_code VARCHAR(30) NOT NULL UNIQUE,
  project_name VARCHAR(255) NOT NULL,
  customer_id INT UNSIGNED NOT NULL,
  owner_user_id INT UNSIGNED NOT NULL,
  priority_level VARCHAR(30) NOT NULL DEFAULT _utf8mb4'Cấp 4 - Low',
  priority_score INT NOT NULL DEFAULT 0,
  customer_level VARCHAR(50) NOT NULL DEFAULT _utf8mb4'KH thường',
  received_date DATE DEFAULT NULL,
  project_deadline DATE DEFAULT NULL,
  request_description TEXT,
  project_status VARCHAR(100) NOT NULL DEFAULT _utf8mb4'Đang tiếp cận, tư vấn',
  risk_note TEXT,
  evaluation_note TEXT,
  total_order_value DECIMAL(18,2) NOT NULL DEFAULT 0,
  is_archived TINYINT(1) NOT NULL DEFAULT 0,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_projects_customer FOREIGN KEY (customer_id) REFERENCES customers(id),
  CONSTRAINT fk_projects_owner FOREIGN KEY (owner_user_id) REFERENCES users(id),
  INDEX idx_project_status (project_status),
  INDEX idx_priority_level (priority_level),
  INDEX idx_project_deadline (project_deadline),
  INDEX idx_owner_user_id (owner_user_id),
  INDEX idx_customer_level (customer_level),
  INDEX idx_projects_customer_id (customer_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE project_items (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  project_id INT UNSIGNED NOT NULL,
  product_name VARCHAR(255) NOT NULL,
  product_category VARCHAR(100) DEFAULT NULL,
  material VARCHAR(100) DEFAULT NULL,
  quantity INT NOT NULL DEFAULT 0,
  unit_price DECIMAL(18,2) NOT NULL DEFAULT 0,
  total_value DECIMAL(18,2) NOT NULL DEFAULT 0,
  unit VARCHAR(30) NOT NULL DEFAULT _utf8mb4'cái',
  item_status VARCHAR(50) NOT NULL DEFAULT _utf8mb4'Đang xử lý',
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_project_items_project FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
  INDEX idx_project_items_project_id (project_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE tasks (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  project_id INT UNSIGNED NOT NULL,
  task_name VARCHAR(255) NOT NULL,
  assigned_to_user_id INT UNSIGNED NOT NULL,
  task_deadline DATE DEFAULT NULL,
  task_progress_note TEXT,
  task_status VARCHAR(50) NOT NULL DEFAULT _utf8mb4'Chưa làm',
  task_priority VARCHAR(30) NOT NULL DEFAULT 'Medium',
  risk_level VARCHAR(20) NOT NULL DEFAULT 'Low',
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_tasks_project FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
  CONSTRAINT fk_tasks_user FOREIGN KEY (assigned_to_user_id) REFERENCES users(id),
  INDEX idx_tasks_project_id (project_id),
  INDEX idx_assigned_to_user_id (assigned_to_user_id),
  INDEX idx_task_status (task_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE sales_targets (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  year SMALLINT UNSIGNED NOT NULL,
  target_revenue DECIMAL(18,2) NOT NULL DEFAULT 0,
  actual_revenue DECIMAL(18,2) NOT NULL DEFAULT 0,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uq_sale_year (user_id, year),
  CONSTRAINT fk_sales_targets_user FOREIGN KEY (user_id) REFERENCES users(id),
  INDEX idx_sales_targets_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE priority_rules (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  rule_name VARCHAR(120) NOT NULL,
  rule_type VARCHAR(50) NOT NULL,
  condition_value VARCHAR(120) NOT NULL,
  score INT NOT NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE risk_logs (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  project_id INT UNSIGNED NOT NULL,
  task_id INT UNSIGNED DEFAULT NULL,
  risk_type VARCHAR(100) NOT NULL,
  risk_level VARCHAR(20) NOT NULL DEFAULT 'Medium',
  risk_message TEXT NOT NULL,
  is_resolved TINYINT(1) NOT NULL DEFAULT 0,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_risk_project FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
  CONSTRAINT fk_risk_task FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE SET NULL,
  INDEX idx_risk_project_id (project_id),
  INDEX idx_risk_task_id (task_id),
  INDEX idx_risk_resolved (is_resolved)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE activity_logs (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED DEFAULT NULL,
  action VARCHAR(100) NOT NULL,
  table_name VARCHAR(100) NOT NULL,
  record_id INT UNSIGNED NOT NULL,
  old_value TEXT,
  new_value TEXT,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_activity_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_activity_user_id (user_id),
  INDEX idx_activity_table_record (table_name, record_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO users (full_name, role, department) VALUES
('Việt', 'admin', 'Kinh doanh'), ('Yến', 'sale', 'Kinh doanh'), ('Phương', 'sale', 'Kinh doanh'),
('Dương', 'pm', 'Vận hành'), ('Trang', 'staff', 'Thiết kế'), ('Hoàn', 'staff', 'Sản xuất'),
('Hải', 'staff', 'Kho vận'), ('Kim Anh', 'staff', 'CSKH'), ('Huệ', 'staff', 'Kế toán');

INSERT INTO customers (customer_name, contact_name, customer_type, note) VALUES
('Quốc Hội Việt Nam', 'Ông Nam', 'KH VIP', 'Khách hàng chiến lược'),
('Bệnh viện Bạch Mai', 'Bà Hà', 'Lấy thường xuyên', NULL),
('Viettel Warehousing', 'Anh Dũng', 'KH VIP', NULL),
('VCX Group', 'Chị Ngân', 'KH thường', NULL),
('SeABank', 'Anh Toàn', 'KH VIP', NULL),
('Petrovietnam PVEP', 'Anh Hưng', 'KH VIP', NULL),
('Tân Cảng Sài Gòn', 'Chị Vi', 'Lấy thường xuyên', NULL),
('Showroom tầng 1', 'Nội bộ', 'KH thường', 'Dự án nội bộ'),
('Viettel Solutions', 'Anh Bình', 'Lấy thường xuyên', NULL);

INSERT INTO projects (project_code, project_name, customer_id, owner_user_id, priority_level, priority_score, customer_level, received_date, project_deadline, request_description, project_status, risk_note, evaluation_note, total_order_value) VALUES
('DA-001','Dự án Quốc Hội Việt Nam',1,1,'Cấp 1 - Critical',95,'KH VIP','2026-04-01','2026-05-20','Quà tặng đại biểu cao cấp','Đang triển khai Đơn hàng','Nguy cơ chậm vật liệu','Theo dõi sát',2300000000),
('DA-002','Dự án Bạch Mai',2,2,'Cấp 2 - High',78,'Lấy thường xuyên','2026-04-08','2026-05-25','Giftset y tế','Triển khai mẫu',NULL,NULL,650000000),
('DA-003','Dự án Viettel Warehousing',3,1,'Cấp 2 - High',82,'KH VIP','2026-03-25','2026-05-30','Quà tri ân khách hàng logistics','Đang triển khai Đơn hàng',NULL,NULL,1850000000),
('DA-004','Dự án VCX',4,3,'Cấp 3 - Medium',60,'KH thường','2026-04-15','2026-06-10','Combo onboarding','Đang tiếp cận, tư vấn',NULL,NULL,180000000),
('DA-005','Dự án SeABank',5,2,'Cấp 1 - Critical',90,'KH VIP','2026-04-05','2026-05-18','Quà event ngân hàng','Đang triển khai Đơn hàng','Áp lực deadline',NULL,1250000000),
('DA-006','Dự án Petrovietnam PVEP',6,1,'Cấp 2 - High',75,'KH VIP','2026-04-11','2026-06-01','Giftset cao cấp','Triển khai mẫu',NULL,NULL,920000000),
('DA-007','Dự án Tân Cảng Sài Gòn',7,3,'Cấp 3 - Medium',55,'Lấy thường xuyên','2026-04-12','2026-06-05','Lịch + sổ tay doanh nghiệp','Đang tiếp cận, tư vấn',NULL,NULL,260000000),
('DA-008','Dự án Setup showroom tầng 1',8,4,'Cấp 4 - Low',35,'KH thường','2026-04-18','2026-06-20','Setup trưng bày sản phẩm','D/A hoàn thành',NULL,'Đã hoàn tất',90000000),
('DA-009','Dự án Viettel Solutions',9,2,'Cấp 2 - High',72,'Lấy thường xuyên','2026-04-02','2026-05-28','Quà tặng công nghệ','Đang triển khai Đơn hàng',NULL,NULL,780000000);

INSERT INTO project_items (project_id, product_name, product_category, material, quantity, unit_price, total_value, unit, item_status) VALUES
(1,'Bút ký cao cấp','Bút','Kim loại',3000,350000,1050000000,'cây','Đang sản xuất'),
(1,'Sổ da logo','Sổ','Da PU',3000,180000,540000000,'quyển','Đang sản xuất'),
(3,'Bình giữ nhiệt','Bình','Inox 304',5000,220000,1100000000,'cái','Đang xử lý'),
(5,'Giftset ngân hàng','Giftset','Da + kim loại',2500,420000,1050000000,'set','Đang sản xuất'),
(9,'Sạc dự phòng','Điện tử','ABS',2000,240000,480000000,'cái','Đang xử lý');

INSERT INTO tasks (project_id, task_name, assigned_to_user_id, task_deadline, task_progress_note, task_status, task_priority, risk_level) VALUES
(1,'Chốt thiết kế hộp quà',5,'2026-05-17','Đang chờ duyệt mẫu cuối','Đang làm','High','High'),
(1,'Đặt vật liệu bút ký',6,'2026-05-16','Đã gửi PO','Đang làm','High','Medium'),
(2,'Làm mẫu giftset bệnh viện',5,'2026-05-19','Hoàn thành 70%','Đang làm','Medium','Low'),
(3,'Kiểm tra tiến độ in logo',7,'2026-05-21','Cần bổ sung file AI','Chờ phản hồi','Medium','Medium'),
(5,'Xác nhận kế hoạch giao hàng',8,'2026-05-15','Quá hạn xác nhận','Chưa làm','High','High'),
(9,'Kiểm thử sản phẩm demo',4,'2026-05-23','Đã lên checklist','Chưa làm','Medium','Low');

INSERT INTO sales_targets (user_id, year, target_revenue, actual_revenue) VALUES
(1,2026,20000000000,12300000000),
(2,2026,15000000000,8800000000),
(3,2026,15000000000,7600000000);
