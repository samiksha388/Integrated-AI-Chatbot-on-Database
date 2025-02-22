-- Create Database
CREATE DATABASE Integrated_AI_updated;
USE Integrated_AI_updated;

-- Users Table
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- AI Models Table
CREATE TABLE AI_Models (
    model_id INT AUTO_INCREMENT PRIMARY KEY,
    model_name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    version VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- FAQs Table (Predefined questions and answers)
CREATE TABLE FAQs (
    faq_id INT AUTO_INCREMENT PRIMARY KEY,
    question varchar(500) NOT NULL UNIQUE,
    answer varchar(7000) NOT NULL,
    model_id INT,  -- AI model that generated the answer
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (model_id) REFERENCES AI_Models(model_id) ON DELETE SET NULL
);

-- User Queries Table (For tracking searches)
CREATE TABLE User_Queries (
    query_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    query_text TEXT NOT NULL,
    faq_id INT NULL, -- Links to FAQ if matched
    model_id INT, -- AI model used if no exact FAQ match
    query_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (faq_id) REFERENCES FAQs(faq_id) ON DELETE SET NULL,
    FOREIGN KEY (model_id) REFERENCES AI_Models(model_id) ON DELETE SET NULL
);

-- Responses Table (AI-generated responses)
CREATE TABLE Responses (
    response_id INT AUTO_INCREMENT PRIMARY KEY,
    query_id INT,
    response_text TEXT NOT NULL,
    response_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (query_id) REFERENCES User_Queries(query_id) ON DELETE CASCADE
);

-- Feedback Table (for switching models)
CREATE TABLE Feedback (
    feedback_id INT AUTO_INCREMENT PRIMARY KEY,
    query_id INT,
    user_id INT,
    satisfaction ENUM('Satisfied', 'Not Satisfied') NOT NULL,
    new_model_id INT NULL, -- If user switches AI models
    feedback_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (query_id) REFERENCES User_Queries(query_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (new_model_id) REFERENCES AI_Models(model_id) ON DELETE SET NULL
);

-- Insert Users with Real Names
INSERT INTO Users (username, email) VALUES
('Alice Johnson', 'alice.johnson@example.com'),
('Bob Smith', 'bob.smith@example.com'),
('Charlie Brown', 'charlie.brown@example.com'),
('David Lee', 'david.lee@example.com'),
('Emma Watson', 'emma.watson@example.com'),
('Franklin Harris', 'franklin.harris@example.com'),
('Grace Miller', 'grace.miller@example.com'),
('Henry Wilson', 'henry.wilson@example.com'),
('Isabella Clark', 'isabella.clark@example.com'),
('Jack Turner', 'jack.turner@example.com');

-- Insert AI Models
INSERT INTO AI_Models (model_name, description, version) VALUES
('GPT-4', 'Advanced NLP model for text generation.', '4.0'),
('BERT', 'Context-aware NLP model optimized for understanding language.', '1.1'),
('DALL-E', 'AI model designed for image generation from text descriptions.', '2.0'),
('T5', 'Text-to-text transformer model for various NLP tasks.', '3.1');



-- Insert FAQs
INSERT INTO FAQs (question, answer, model_id) VALUES
('What is AI?', 'AI stands for Artificial Intelligence and is used in various domains.', 1),
('How does BERT work?', 'BERT uses transformers to understand language in context.', 2),
('What is GPT-4 used for?', 'GPT-4 is used for generating human-like text.', 1),
('How does DALL-E generate images?', 'DALL-E creates images based on text descriptions.', 3),
('What makes T5 different?', 'T5 reframes NLP problems as text-to-text tasks.', 4),
('How does AI impact healthcare?', 'AI helps in diagnostics, drug discovery, and patient monitoring.', 1),
('What are the applications of AI in finance?', 'AI is used in fraud detection, algorithmic trading, and risk analysis.', 2),
('Is AI capable of creativity?', 'AI can generate music, art, and poetry using models like DALL-E and GPT-4.', 3),
('What is transfer learning?', 'Transfer learning allows AI models to apply knowledge from one task to another.', 4),
('Can AI understand emotions?', 'AI can analyze sentiment but does not have true emotions.', 2);

-- Insert User Queries

-- Insert User Queries with Repeated Questions
INSERT INTO User_Queries (user_id, query_text, faq_id, model_id) VALUES
-- "Explain AI basics" asked multiple times
(1, 'Explain AI basics', 1, 1),
(2, 'Explain AI basics', 1, 1),
(3, 'Explain AI basics', 1, 1),
(4, 'Explain AI basics', 1, 1),

-- "What can GPT-4 do?" asked twice
(5, 'What can GPT-4 do?', 3, 1),
(6, 'What can GPT-4 do?', 3, 1),

-- "How does BERT process text?" asked once
(7, 'How does BERT process text?', 2, 2),

-- "How does DALL-E create images?" asked once
(8, 'How does DALL-E create images?', 4, 3),

-- "What is special about T5?" asked once
(9, 'What is special about T5?', 5, 4),

-- "How is AI used in medicine?" asked once
(10, 'How is AI used in medicine?', 6, 1),

-- Additional Repetitions to Increase FAQ Count
(1, 'Explain AI basics', 1, 1),
(3, 'Explain AI basics', 1, 1),
(5, 'What can GPT-4 do?', 3, 1);

-- Insert Responses
INSERT INTO Responses (query_id, response_text) VALUES
(1, 'AI is a branch of computer science that focuses on creating intelligent systems.'),
(2, 'BERT processes text bidirectionally for better language understanding.'),
(3, 'GPT-4 can generate text, answer questions, and assist with writing.'),
(4, 'DALL-E generates images from text inputs using deep learning.'),
(5, 'T5 is unique because it treats every NLP task as a text-to-text problem.'),
(6, 'AI assists in disease diagnosis, medical imaging, and personalized treatment.'),
(7, 'In finance, AI is used for detecting fraud, predicting market trends, and automating transactions.'),
(8, 'Yes, AI models like DALL-E and GPT-4 can create artistic content.'),
(9, 'Transfer learning enables AI to use knowledge from one domain to solve new problems.'),
(10, 'AI can analyze text and speech for sentiment but does not truly feel emotions.');

-- Insert Feedback
INSERT INTO Feedback (query_id, user_id, satisfaction, new_model_id) VALUES
(1, 1, 'Satisfied', NULL),
(2, 2, 'Not Satisfied', 1),
(3, 3, 'Satisfied', NULL),
(4, 4, 'Satisfied', NULL),
(5, 5, 'Not Satisfied', 1),
(6, 6, 'Satisfied', NULL),
(7, 7, 'Not Satisfied', 2),
(8, 8, 'Satisfied', NULL),
(9, 9, 'Satisfied', NULL),
(10, 10, 'Not Satisfied', 3);


-- Get Conversations and Their Users
SELECT 
    U.user_id,
    U.username,
    U.email,
    Q.query_id,
    Q.query_text,
    Q.query_timestamp,
    R.response_id,
    R.response_text,
    R.response_timestamp
FROM Users U
JOIN User_Queries Q ON U.user_id = Q.user_id
LEFT JOIN Responses R ON Q.query_id = R.query_id
ORDER BY Q.query_timestamp;

-- Get All Messages for a Specific Conversation

SELECT 
    Q.query_id,
    U.username,
    Q.query_text AS message,
    Q.query_timestamp AS timestamp,
    'User' AS sender
FROM User_Queries Q
JOIN Users U ON Q.user_id = U.user_id
WHERE Q.query_id = query_id

UNION ALL

SELECT 
    R.query_id,
    'AI Model' AS username,
    R.response_text AS message,
    R.response_timestamp AS timestamp,
    'AI' AS sender
FROM Responses R
WHERE R.query_id = query_id

ORDER BY timestamp;



-- Get top 10 most frequently asked queries
SELECT 
    Q.query_text, 
    COUNT(Q.query_id) AS total_times_asked
FROM User_Queries Q
GROUP BY Q.query_text
ORDER BY total_times_asked DESC
LIMIT 10;

-- Get top 3 most referenced FAQs
SELECT 
    F.question, 
    COUNT(UQ.faq_id) AS times_referenced
FROM User_Queries UQ
JOIN FAQs F ON UQ.faq_id = F.faq_id
WHERE UQ.faq_id IS NOT NULL
GROUP BY F.question
ORDER BY times_referenced DESC

SELECT 
    F.question, 
    COUNT(UQ.faq_id) AS times_referenced
FROM User_Queries UQ
JOIN FAQs F ON UQ.faq_id = F.faq_id
WHERE UQ.faq_id IS NOT NULL
GROUP BY F.question
ORDER BY times_referenced DESC

SELECT 
    F.question, 
    COUNT(UQ.faq_id) AS times_referenced
FROM User_Queries UQ
JOIN FAQs F ON UQ.faq_id = F.faq_id
WHERE UQ.faq_id IS NOT NULL
GROUP BY F.question
ORDER BY times_referenced DESC

SELECT 
    F.question, 
    COUNT(UQ.faq_id) AS times_referenced
FROM User_Queries UQ
JOIN FAQs F ON UQ.faq_id = F.faq_id
WHERE UQ.faq_id IS NOT NULL
GROUP BY F.question
ORDER BY times_referenced DESC
LIMIT 3;