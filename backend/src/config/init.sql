-- Create the books table
CREATE TABLE IF NOT EXISTS books (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    writer VARCHAR(255),
    visibility VARCHAR(255) DEFAULT 'FREE_USER',
    book_image VARCHAR(255),
    book_pdf VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

-- Create the courses table
CREATE TABLE IF NOT EXISTS courses (
   id SERIAL PRIMARY KEY,
   title VARCHAR(255) NOT NULL,
   description TEXT,
   category VARCHAR(100),
   keywords TEXT,
   course_image VARCHAR(255),
   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Quiz table
CREATE TABLE IF NOT EXISTS quiz (
    id SERIAL PRIMARY KEY,
    course_id INTEGER NOT NULL ,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    date DATE,
    visibility VARCHAR(255) DEFAULT 'FREE_USER',
    number_of_questions INTEGER,
    total_time INTEGER,
    keywords TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);

-- Create Exam Script table (One per Quiz)
CREATE TABLE IF NOT EXISTS exam_script (
   id SERIAL PRIMARY KEY,
   quiz_id INTEGER NOT NULL,
   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   FOREIGN KEY (quiz_id) REFERENCES quiz(id) ON DELETE CASCADE
);

-- Create Question table (Multiple per Exam Script)
CREATE TABLE IF NOT EXISTS question (
    id SERIAL PRIMARY KEY,
    exam_script_id INTEGER NOT NULL,
    question TEXT NOT NULL,
    answer TEXT NOT NULL,
    options TEXT[],
    image VARCHAR(255),
    subject VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (exam_script_id) REFERENCES exam_script(id) ON DELETE CASCADE
);

-- Create User table
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    phone_number BIGINT NOT NULL UNIQUE,
    education VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL
    );


-- Create manager table
CREATE TABLE IF NOT EXISTS managers (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255),
    phone_number INTEGER UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL
);