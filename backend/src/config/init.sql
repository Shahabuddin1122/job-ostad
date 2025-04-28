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

-- Create the books table
CREATE TABLE IF NOT EXISTS books (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    writer VARCHAR(255),
    visibility BOOLEAN DEFAULT true,   -- assuming visibility means whether the book is visible or not
    book_image VARCHAR(255),
    book_pdf VARCHAR(255),            -- store the path or URL to the PDF
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
