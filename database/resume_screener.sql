CREATE DATABASE  resume_screener;
USE resume_screener;

CREATE TABLE  Candidates (
    candidate_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    gender VARCHAR(10),
    date_of_birth DATE,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20)
);

CREATE TABLE  Resumes (
    resume_id INT AUTO_INCREMENT PRIMARY KEY,
    candidate_id INT NOT NULL,
    resume_text LONGTEXT,
    experience_years DECIMAL(4,2) DEFAULT 0.0,
    education_level VARCHAR(100),
    FOREIGN KEY (candidate_id) REFERENCES Candidates(candidate_id)
);

CREATE TABLE  Jobs (
    job_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    description TEXT, -- Changed from 'job_description' to match your error log fix
    required_skills TEXT
);

CREATE TABLE Skills (
    skill_id INT AUTO_INCREMENT PRIMARY KEY,
    skill_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Candidate_Skills (
    candidate_id INT NOT NULL,
    skill_id INT NOT NULL,
    PRIMARY KEY (candidate_id, skill_id),
    FOREIGN KEY (candidate_id) REFERENCES Candidates(candidate_id) ON DELETE CASCADE,
    FOREIGN KEY (skill_id) REFERENCES Skills(skill_id) ON DELETE CASCADE
);

CREATE TABLE Screening_Results (
    result_id INT AUTO_INCREMENT PRIMARY KEY,
    job_id INT NOT NULL,
    resume_id INT NOT NULL,
    match_score DECIMAL(5,2) NOT NULL, -- Percentage match (e.g., 85.50)
    matched_skills TEXT,               -- Comma-separated string of overlapping skills
    missing_skills TEXT,               -- Comma-separated string of skills the resume lacked
    status ENUM('Pending', 'Shortlisted', 'Rejected') DEFAULT 'Pending',
    screened_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (job_id) REFERENCES Jobs(job_id) ON DELETE CASCADE,
    FOREIGN KEY (resume_id) REFERENCES Resumes(resume_id) ON DELETE CASCADE
);

-- 3. Insert Data
-- Using 'INSERT IGNORE' prevents Error 1062 (Duplicate entry) 
-- if the data is already there.

INSERT IGNORE INTO Candidates (candidate_id, full_name, gender, date_of_birth, email, phone) VALUES 
('1', 'Fatima Ali', 'Female', '2000-03-25', 'fatima.a@gmail.com', '9458188332'),
('2', 'Sneha Gupta', 'Female', '1996-07-23', 'sneha.g@gmail.com', '9765230498'),
('3', 'Ananya Reddy', 'Female', '2006-07-06', 'ananya.r@gmail.com', '9523015687'),
('4', 'Amit Patel', 'Male', '2004-01-20', 'amit.p@gmail.com', '9986231702'),
('5', 'Rahul Sharma', 'Male', '2000-01-01', 'rahul.2@gmail.com', '9821166620'),
('6', 'Siddhi Jain', 'Female', '2000-12-15', 'siddhi.j@gmail.com', '9665544332'),
('7', 'Priya Desai', 'Female', '1999-02-07', 'priya.d40@gmail.com', '9952308725'),
('8', 'Imran Ahmed', 'Male', '1994-12-04', 'imran.a32@gmail.com', '9432888560'),
('9', 'Vikram Singh', 'Male', '1995-11-22', 'vikram.s22@gmail.com', '9530268752'),
('10', 'Amit Patel', 'Male', '1995-01-20', 'amit.p1@gmail.com', '9759320861'),
('11', 'Rohan Iyer', 'Male', '1996-10-30', 'rohan.i4@gmail.com', '9135200687'),
('12', 'Tariq Khan', 'Male', '1996-09-18', 'tariq.kh@gmail.com', '9423088962'),
('13', 'Aditya Shrivastav', 'Male', '2000-12-11', 'aditya.code@email.com', '9988776655'),
('14', 'Reyansh Singh', 'Male', '1990-09-14', 'rey.singh@gmail.com', '9223344556'),
('15', 'Pari Deshmukh', 'Female', '1994-02-28', 'pari.d@icloud.com', '9881122334'),
('16', 'Aryan Khatri', 'Male', '2003-05-12', 'aryan.khatri@gmail.com', '9876501234'),
('17', 'Sanya Malhotra', 'Female', '2001-08-24', 'sanya.m@outlook.in', '9812345678'),
('18', 'Pranav Rao', 'Male', '2004-05-05', 'pranav.rao@startup.in', '9112233445'),
('19', 'Armaan Malik', 'Male', '2005-06-10', 'armaan.m@rediffmail.com', '9778899001'),
('20', 'Anika Grewal', 'Female', '2004-07-09', 'anika.g@pwc.in', '9334567890'),
('21', 'Vihaan Bansal', 'Male', '2006-01-30', 'vihaan.b@protonmail.com', '9556781234'),
('22', 'Saanvi Gupta', 'Female', '1995-07-09', 'saanvi.g@pwc.in', '9334567800'),
('23', 'Vivaan Kapoor', 'Male', '1992-01-30', 'vivaan.k@protonmail.com', '9556781268'),
('24', 'Meera Pillai', 'Female', '1991-12-15', 'meera.p@gmail.com', '9665544332'),
('25','Riya Sen', 'Female', '2003-04-18', 'riya.sen@hotmail.com', '9667894321'),
('26', 'Devansh Negi', 'Male', '2000-09-14', 'dev.negi@gmail.com', '9223344556'),
('27', 'Aditi Verma', 'Female', '1997-04-18', 'aditi.verma@hotmail.com', '9667894321'),
('28', 'Rishabh Pant', 'Male', '2000-03-15', 'rishabh.p@tech-india.com', '9988776655'),
('29', 'Tanya Singhal', 'Female', '2005-11-02', 'tanya.s@yahoo.co.in', '9123456789'),
('30', 'Kabir Singh', 'Male', '2002-12-20', 'kabir.s02@gmail.com', '9440123456');


INSERT INTO Resumes (resume_id, candidate_id, resume_text, experience_years, education_level) VALUES 
(101, 1, 'Full-stack developer proficient in React and Node.js. Interned at a local startup.', 1, 'B.Tech CSE'),
(102, 2, 'Data Science enthusiast with experience in Python, Pandas, and Scikit-Learn.', 0, 'B.Sc Data Science'),
(103, 3, 'Backend Engineer focusing on Java and Spring Boot. Worked on e-commerce projects.', 2, 'M.Tech'),
(104, 4, 'UI/UX Designer skilled in Figma and Adobe XD. Passionate about accessibility.', 1, 'B.Des'),
(105, 5, 'Python Developer with a focus on automation and web scraping using BeautifulSoup.', 1, 'BCA'),
(106, 6, 'Marketing professional with experience in SEO and digital brand management.', 2, 'MBA'),
(107, 7, 'Entry-level Cloud Engineer with AWS Cloud Practitioner certification.', 0, 'B.Tech IT'),
(108, 8, 'Financial Analyst intern with expertise in Excel and Tableau visualization.', 0, 'B.Com'),
(109, 9, 'Software Engineer specializing in C++ and competitive programming.', 3, 'B.Tech CSE'),
(110, 10, 'Graphic Designer with 2 years of experience in branding and social media assets.', 2, 'BFA'),
(111, 11, 'Human Resources coordinator with experience in talent acquisition and screening.', 1, 'MBA HR'),
(112, 12, 'Cybersecurity student with a focus on penetration testing and network security.', 0, 'B.Tech CSE'),
(113, 13, 'Mobile App Developer experienced in Flutter and Firebase integration.', 1, 'B.Tech'),
(114, 14, 'Project Management intern with proficiency in Agile and Scrum methodologies.', 0, 'BBA'),
(115, 15, 'Quality Assurance engineer with experience in manual and automated testing.', 2, 'B.Tech'),
(116, 16, 'HVAC Technician with certification in mechanical troubleshooting and system installation.', 9, 'Associate Degree in Mechanical Technology'),
(117, 17, 'Experienced Civil Engineer managing large-scale infrastructure projects and structural analysis.', 12, 'Master of Engineering'),
(118, 18, 'Registered nurse with 10 years of experience in emergency room care and patient advocacy.', 10, 'Bachelor of Science in Nursing'),
(119, 19, 'Creative graphic designer specializing in brand identity and user interface design using Adobe Creative Suite.', 3, 'Bachelor of Design'),
(120, 20, 'Content writer with experience in technical documentation and SEO-driven blog posts.', 3, 'Master of Arts in English'),
(121, 21, 'Electrical engineer focused on PLC programming and industrial circuit design.', 5, 'Bachelor of Technology'),
(122, 22, 'HR Generalist with expertise in talent acquisition and employee relations management.', 4, 'MBA in Human Resources'),
(123, 23, 'Customer success lead dedicated to reducing churn and improving client satisfaction through CRM data.', 7, 'Bachelor of Arts'),
(124, 24, 'Strategic Project Manager with a history of leading Agile teams in high-pressure environments.', 6, 'MBA in Operations'),
(125, 25, 'Professional Translator fluent in English, Spanish, and Mandarin for technical documents.', 6, 'Master of Arts in Linguistics'),
(126, 26, 'Personal Trainer and Nutritionist with a focus on hypertrophy and diet planning.', 3, 'Diploma in Sports Science'),
(127, 27, 'Network Engineer with CCNA certification and expertise in Cisco routing and switching.', 4, 'Bachelor of Engineering'),
(128, 28, 'Pharmacist with a background in clinical trials and pharmaceutical sales management.', 4, 'Bachelor of Pharmacy'),
(129, 29, 'Video Editor and Motion Graphics artist with proficiency in After Effects and Premiere Pro.', 3, 'Bachelor of Fine Arts'),
(130, 30, 'Cloud Architect certified in Azure and GCP with a focus on serverless architecture.', 6, 'Master of Technology');


-- Fixing Error 1136: Ensure column names match the number of values
INSERT IGNORE INTO Jobs (title, description, required_skills) VALUES 
('Software Engineer', 'Develop and maintain scalable web applications.', 'Java, Spring Boot, Microservices'),
('Data Scientist', 'Build predictive models and perform deep data analysis.', 'Python, R, Machine Learning, SQL'),
('Full Stack Developer', 'Handle both frontend and backend development tasks.', 'JavaScript, Node.js, React, MongoDB'),
('HR Specialist', 'Manage recruitment, onboarding, and employee relations.', 'Communication, HRIS, Conflict Resolution'),
('AI Engineer', 'Implement neural networks and NLP algorithms.', 'PyTorch, TensorFlow, Deep Learning'),
('Business Analyst', 'Bridge the gap between IT and business stakeholders.', 'Requirements Gathering, Tableau, BPMN'),
('Mobile App Developer', 'Build native applications for iOS and Android.', 'Swift, Kotlin, Flutter'),
('Financial Analyst', 'Analyze financial data and prepare budget reports.', 'Excel, Financial Modeling, Accounting'),
('Cybersecurity Analyst', 'Monitor networks for security breaches and install software.', 'CompTIA Security+, Network Security, Firewalls'),
('Content Marketer', 'Write engaging blog posts, newsletters, and social copy.', 'SEO, Copywriting, Content Strategy'),
('Social Media Manager', 'Build brand presence across social platforms.', 'Analytics, Design, Community Management'),
('System Administrator', 'Maintain server health and internal IT infrastructure.', 'Linux, Windows Server, Networking'),
('Technical Writer', 'Create complex documentation for software products.', 'Markdown, DITA, Explanatory Writing'),   
('Sales Representative', 'Identify leads and close business deals.', 'CRM, Negotiation, Cold Calling'),
('Electrical Engineer', 'Design and test electrical systems for industrial applications.', 'AutoCAD, Circuit Design, Power Systems'),
('Content Strategist', 'Plan and execute digital content across multiple platforms.', 'SEO, Copywriting, Content Management Systems'),
('Sustainability Consultant', 'Advise companies on reducing their environmental footprint.', 'Environmental Science, ESG Reporting, Carbon Accounting'),
('Clinical Psychologist', 'Diagnose and treat mental health disorders through therapy.', 'CBT, Patient Counseling, Psychological Assessment'),
('HVAC Technician', 'Install and repair heating, ventilation, and air conditioning systems.', 'Mechanical Troubleshooting, EPA Certification, Brazing'),
('Civil Engineer', 'Supervise infrastructure projects including roads, bridges, and water systems.', 'Structural Analysis, AutoCAD, Project Planning'),
('Data Entry Specialist', 'Maintain accurate records by inputting data into company databases.', 'Typing Speed, Attention to Detail, Microsoft Office'),
('UX Researcher', 'Conduct user interviews and usability testing to improve product design.', 'User Psychology, Wireframing, Analytical Thinking'),
('Human Resources Generalist', 'Manage recruitment, employee relations, and benefits administration.', 'Employment Law, Payroll, Interviewing'),
('Registered Nurse', 'Provide patient care, administer medications, and coordinate with healthcare teams.', 'Patient Care, BLS, Clinical Assessment'),
('Graphic Designer', 'Create visual concepts for branding, marketing materials, and digital assets.', 'Adobe Creative Suite, Typography, UI/UX'),
('Project Manager', 'Lead cross-functional teams to deliver projects on time and within budget.', 'Agile, Scrum, Risk Management, Jira'),
('Customer Success Lead', 'Build long-term relationships with clients and ensure product adoption.', 'CRM, Communication, Conflict Resolution'),
('Chef de Cuisine', 'Oversee kitchen operations, menu planning, and food safety standards.', 'Culinary Arts, Inventory Management, Leadership'),
('Mental Health Counselor', 'Provide therapeutic support and develop treatment plans for clients.', 'Crisis Intervention, Empathy, HIPAA Compliance'),
('Logistics Coordinator', 'Manage supply chain operations, shipping schedules, and vendor relations.', 'Supply Chain Management, ERP, Negotiation');

INSERT INTO Skills (skill_id, skill_name) VALUES 
(1, 'Java'),
(2, 'Python'),
(3, 'C++'),
(4, 'HTML'),
(5, 'CSS'),
(6, 'JavaScript'),
(7, 'React.js'),
(8, 'Node.js'),
(9, 'MySQL'),
(10, 'MongoDB'),
(11, 'AWS'),
(12, 'Docker'),
(13, 'Kubernetes'),
(14, 'Git'),
(15, 'Machine Learning'),
(16, 'Data Analysis'),
(17, 'Tableau'),
(18, 'Figma'),
(19, 'TypeScript'),
(20, 'Spring Boot'),
(21, 'Django'),
(22, 'Cybersecurity'),
(23, 'Agile Methodology'),
(24, 'Project Management'),
(25, 'Cloud Computing'),
(26, 'REST API'),
(27, 'Firebase'),
(28, 'Data Structures'),
(29, 'UI/UX Design'),
(30, 'Unit Testing');
    
INSERT INTO Candidate_Skills (candidate_id, skill_id) VALUES 
    (1, 1), (1, 3), (1, 5),  -- Candidate 1 has 3 skills
    (2, 2), (2, 4),          -- Candidate 2 has 2 skills
    (3, 1), (3, 6), (3, 10), -- Candidate 3 has 3 skills
    (4, 7), (4, 8),          -- Candidate 4 has 2 skills
    (5, 2), (5, 9),          -- Candidate 5 has 2 skills
    (6, 11), (6, 12),        -- ... and so on
    (7, 4), (7, 13), 
    (8, 3), (8, 14), 
    (9, 1), (9, 15), 
    (10, 7), (10, 8), 
    (11, 12), (11, 16), 
    (12, 13), (12, 17), 
    (13, 18), (13, 2), 
    (14, 11), (14, 19), 
    (15, 20), (15, 3),
    (16, 21), (16, 22), (16, 13),
    (17, 3), (17, 23), (17, 4),   
    (18, 15), (18, 24),           
    (19, 10), (19, 16),           
    (20, 18), (20, 14),           
    (21, 25), (21, 1), (21, 2),   
    (22, 26), (22, 13),           
    (23, 5), (23, 14),            
    (24, 6), (24, 19),            
    (25, 13), (25, 3), (25, 12),  
    (26, 9), (26, 29),            
    (27, 27), (27, 11),           
    (28, 28), (28, 13), (28, 3),  
    (29, 6), (29, 7),             
    (30, 8), (30, 9), (30, 29);   

INSERT INTO Screening_Results (job_id, resume_id, match_score, matched_skills, missing_skills, status) VALUES
(1, 101, 90.50, 'Java, Spring Boot', 'Microservices', 'Shortlisted'),
(2, 102, 88.00, 'Python, Machine Learning, SQL', 'R', 'Shortlisted'),
(3, 101, 85.75, 'JavaScript, React, Node.js', 'MongoDB', 'Shortlisted'),
(4, 111, 92.00, 'Communication, HRIS', 'Conflict Resolution', 'Shortlisted'),
(5, 102, 80.20, 'Python, Deep Learning', 'TensorFlow', 'Pending'),
(6, 106, 78.90, 'Requirements Gathering', 'Tableau, BPMN', 'Pending'),
(7, 113, 83.60, 'Flutter', 'Kotlin, Swift', 'Shortlisted'),
(8, 108, 87.40, 'Excel, Financial Modeling', 'Accounting', 'Shortlisted'),
(9, 112, 84.00, 'Network Security', 'Firewalls, CompTIA Security+', 'Pending'),
(10, 120, 79.30, 'SEO, Copywriting', 'Content Strategy', 'Pending'),
(11, 107, 75.50, 'Linux, Networking', 'Windows Server', 'Pending'),
(12, 120, 91.10, 'Technical Writing', 'DITA', 'Shortlisted'),
(13, 123, 82.00, 'CRM, Communication', 'Negotiation', 'Shortlisted'),
(14, 121, 77.80, 'Circuit Design', 'AutoCAD, Power Systems', 'Pending'),
(15, 119, 86.90, 'SEO, Content Management', 'Copywriting', 'Shortlisted'),
(16, 124, 74.20, 'Environmental Science', 'Carbon Accounting', 'Pending'),
(17, 118, 89.50, 'Patient Counseling', 'CBT', 'Shortlisted'),
(18, 116, 93.00, 'Mechanical Troubleshooting', 'EPA Certification', 'Shortlisted'),
(19, 117, 88.70, 'Structural Analysis, AutoCAD', 'Project Planning', 'Shortlisted'),
(20, 107, 70.40, 'Typing Speed, MS Office', 'Attention to Detail', 'Pending'),
(21, 103, 85.60, 'User Psychology, Wireframing', 'Analytical Thinking', 'Shortlisted'),
(22, 111, 87.20, 'Payroll, Interviewing', 'Employment Law', 'Shortlisted'),
(23, 118, 91.80, 'Patient Care, Clinical Assessment', 'BLS', 'Shortlisted'),
(24, 110, 86.30, 'Adobe Creative Suite, UI/UX', 'Typography', 'Shortlisted'),
(25, 114, 83.40, 'Agile, Scrum', 'Jira, Risk Management', 'Shortlisted'),
(26, 123, 89.00, 'CRM, Communication', 'Conflict Resolution', 'Shortlisted'),
(27, 129, 78.50, 'Culinary Arts', 'Inventory Management', 'Pending'),
(28, 118, 92.60, 'Crisis Intervention, Empathy', 'HIPAA Compliance', 'Shortlisted'),
(29, 123, 84.10, 'Supply Chain Management', 'ERP', 'Shortlisted'),
(30, 130, 90.90, 'Cloud, Azure', 'Serverless Architecture', 'Shortlisted');

-- 4. Verify results
SELECT * FROM Candidates;
SELECT * FROM Jobs;
SELECT * FROM Resumes;
SELECT * FROM Skills;
SELECT * FROM Candidate_Skills;
SELECT * FROM Screening_Results;