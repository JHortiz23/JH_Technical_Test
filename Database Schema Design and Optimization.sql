
/*******Script to create netforemost surveys database.*******/
create database netforemost_surveys;

-- Switch to netforemost surveys database.
use netforemost_surveys;

/*******Script to create tables in netforemost surveys database*******/
-- Create users table
create table users (
user_id varchar(12) primary key not null,
user_name varchar(50) not null,
user_email varchar(100) unique not null,
registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP

)

-- Create surveys table
Create table surveys(
survey_id int auto_increment primary key,
survey_name varchar(100) not null,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP

)

-- Create questions table.
Create table questions(
question_id int auto_increment primary key,
survey_quest_id int not null,
question_text text not null,
foreign key(survey_quest_id) references surveys(survey_id)
)

-- Create responses table.
Create table responses(
response_id int auto_increment primary key,
user_resp_id varchar(12) not null,
question_resp_id int not null,
response_text text not null,
foreign key(user_resp_id) references users(user_id),
foreign key(question_resp_id) references questions(question_id)
)

/*******SQL Script to create table indexes for optimizing queries.*******/
Create index idx_survey_quest_id on questions (survey_quest_id);
Create index idx_user_resp_id on responses (user_resp_id);
Create index idx_question_resp_id on responses (question_resp_id);

/*SHOW CREATED TABLES*/
show tables;

/*
 * Script to show table constraints .
 * SHOW CREATE TABLE "table_name"
 * 
 * OR
 * 
 * Table structure
 * DESCRIBE "Table_Name"
 * 
 * OR 
 * 
 * Show table indexes
 * SHOW INDEX FROM "Table_Name"
 */
show create table users;
describe users;
SHOW INDEX FROM responses;


/*******SQL Scripts for inserting data into the tablets*******/

-- Script to insert sample data into users table
Insert into users (user_id, user_name, user_email) Values
('207740561', 'Julio', 'juhuortiz13@gmail.com'),
('207740562', 'Iraida', 'Ira@example.com'),
('207740563', 'Luis', 'Luis@example.com'),
('207740564', 'Andrés', 'Andres@example.com'),
('207740565', 'Jafet', 'Jafet@example.com');


-- Script to insert sample data into surveys table
Insert into surveys (survey_name) values
('Costa Rica Tourism Satisfaction Survey'),
('Costa Rica Travel Experience Survey'),
('Costa Rica Adventure Activities Feedback Survey');

-- Script for inserting sample data into questions table
Insert questions (survey_quest_id, question_text) values
(1, 'How satisfied are you with your overall travel experience in Costa Rica?'),
(1, 'Would you recommend Costa Rica as a travel destination to others?'),
(2, 'How would you rate the quality of accommodations in Costa Rica?'),
(2, 'How would you rate the local cuisine in Costa Rica?'),
(3, 'How satisfied are you with the adventure activities offered in Costa Rica?');

-- Script to insert sample data into responses table
-- Insert sample data into responses table
INSERT INTO responses (user_resp_id, question_resp_id, response_text) VALUES
(207740561, 1, 'Very Satisfied'),
(207740562, 1, 'Satisfied'),
(207740563, 1, 'Neutral'),
(207740564, 1, 'Dissatisfied'),
(207740565, 1, 'Very Dissatisfied'),
(207740561, 2, 'Yes'),
(207740562, 2, 'Yes'),
(207740563, 2, 'Maybe'),
(207740564, 2, 'No'),
(207740565, 2, 'No'),
(207740561, 3, 'Excellent'),
(207740562, 3, 'Good'),
(207740563, 3, 'Average'),
(207740564, 3, 'Below Average'),
(207740565, 3, 'Poor'),
(207740561, 4, 'Delicious'),
(207740562, 4, 'Very Good'),
(207740563, 4, 'Good'),
(207740564, 4, 'Average'),
(207740565, 4, 'Not Good'),
(207740561, 5, 'Extremely Satisfied'),
(207740562, 5, 'Very Satisfied'),
(207740563, 5, 'Satisfied'),
(207740564, 5, 'Unsatisfied'),
(207740565, 5, 'Very Unsatisfied'),
(207740561, 1, 'Satisfied'),
(207740562, 2, 'No'),
(207740563, 3, 'Neutral'),
(207740564, 4, 'Yes'),
(207740565, 5, 'Good');

-- SHOW RESPONSES
select *from responses r  ;
