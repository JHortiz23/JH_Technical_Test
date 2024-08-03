
# SQL Developer Technical Test

This repository contains the solution for the SQL Developer Technical Test.

## Repository Structure

- `schema/`: Contains SQL scripts for table creation, data insertion, and index creation.
- `queries/`: Contains SQL scripts for basic and advanced queries.
- `procedures_views/`: Contains SQL scripts for stored procedures and views.
- `README.md`: This file, with instructions and necessary details to run the code.

## Requirements

- PostgreSQL or MySQL (any version compatible with the provided scripts).

## Instructions to Run the Code

### 1. Database Schema Setup

1. Clone this repository to your local machine:
    ```sh
    git clone https://github.com/JHortiz23/JH_Technical_Test.git
    cd JH_Technical_Test
    ```

2. Create a new database in your SQL environment (PostgreSQL or MySQL).
    ```sql
    create database netforemost_surveys;
    
    ```

4. Run the table creation scripts in the database:
    ```sql
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
    ```

5. Insert sample data into the tables:
    ```sql
       Insert into users (user_id, user_name, user_email) Values
      ('207740561', 'Julio', 'juhuortiz13@gmail.com'),
      ('207740562', 'Iraida', 'Ira@example.com'),
      ('207740563', 'Luis', 'Luis@example.com'),
      ('207740564', 'Andrés', 'Andres@example.com'),
      ('207740565', 'Jafet', 'Jafet@example.com');

     Insert into surveys (survey_name) values
    ('Costa Rica Tourism Satisfaction Survey'),
    ('Costa Rica Travel Experience Survey'),
    ('Costa Rica Adventure Activities Feedback Survey');

    Insert questions (survey_quest_id, question_text) values
    (1, 'How satisfied are you with your overall travel experience in Costa Rica?'),
    (1, 'Would you recommend Costa Rica as a travel destination to others?'),
    (2, 'How would you rate the quality of accommodations in Costa Rica?'),
    (2, 'How would you rate the local cuisine in Costa Rica?'),
    (3, 'How satisfied are you with the adventure activities offered in Costa Rica?');

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
    ```

6. Create indexes to optimize queries:
    ```sql
    Create index idx_survey_quest_id on questions (survey_quest_id);
    Create index idx_user_resp_id on responses (user_resp_id);
    Create index idx_question_resp_id on responses (question_resp_id);
    ```

### 2. Running Queries


1. Run the basic queries:
    ```sql
      (Document: Query Writing, Optimization, and Advanced Analysis)
    
    SELECT 
    s.survey_name,
    q.question_text,
    r.response_text
    FROM 
        surveys s
    JOIN 
        questions q ON s.survey_id = q.survey_quest_id
    JOIN 
        responses r ON q.question_id = r.question_resp_id
    WHERE 
        s.survey_id = 1; -- Replace with the desired survey_id
    ```

2. Run the advanced queries:
    ```sql
      (Document: Query Writing, Optimization, and Advanced Analysis)

    select
    s.survey_name,
    AVG(
        case r.response_text
            when 'Very Satisfied' then 5
            when 'Satisfied' then 4
            when 'Neutral' then 3
            when 'Dissatisfied' then 2
            when 'Very Dissatisfied' then 1
            else null
        end
    ) as average_score
    from
        surveys s
    join
        questions q on s.survey_id = q.survey_quest_id
    join
        responses r ON q.question_id = r.question_resp_id
    group by
        s.survey_name;


     select
    TO_BASE64(u.user_id) as user_,
    u.user_name,
    u.user_email,
    AVG(
        case r.response_text
            when 'Very Satisfied' then 5
            when 'Satisfied' then 4
            when 'Neutral' then 3
            when 'Dissatisfied' then 2
            when 'Very Dissatisfied' then 1
            else null
        end
    ) as average_score_user
    from
        users u
    join
        responses r on u.user_id = r.user_resp_id 
        
    group by
        u.user_id, u.user_name, u.user_email
     
    order by 
    average_score_user DESC 
    limit 3;



    select
	s.survey_name,
    q.question_text,
    r.response_text,
    COUNT(r.response_text) as response_count
    from
        surveys s
    join
        questions q on s.survey_id = q.survey_quest_id
    join
        responses r on q.question_id = r.question_resp_id
    where
        s.survey_id = 1 -- survey_id
    group by
        q.question_text,
        r.response_text
    order by
        response_count DESC;


    SELECT 
        AVG(
            CASE r.response_text
                WHEN 'Very Satisfied' THEN 5
                WHEN 'Satisfied' THEN 4
                WHEN 'Neutral' THEN 3
                WHEN 'Dissatisfied' THEN 2
                WHEN 'Very Dissatisfied' THEN 1
                ELSE NULL
            END
        ) INTO avg_score
    FROM 
        questions q
    JOIN 
        responses r ON q.question_id = r.question_id
    WHERE 
        q.survey_id = surveyID;

    SELECT avg_score AS survey_score;
    ```

### 3. Stored Procedures and Views


1. Create the stored procedure:
    ```sql
      Script on document Task 3: Stored Procedures and Views.

        create procedure sp_CalculaSurveyScore(IN surveyID int)
        begin 
        	-- variables
        	declare average_score decimal(10,2); -- Variable to store calculated average score.
        	--    
        select 
                COALESCE(
                    AVG(
                        CASE r.response_text
                            WHEN 'Very Satisfied' THEN 5
                            WHEN 'Satisfied' THEN 4
                            WHEN 'Neutral' THEN 3
                            WHEN 'Dissatisfied' THEN 2
                            WHEN 'Very Dissatisfied' THEN 1
                            ELSE NULL
                        END
                    ), 0
                ) INTO average_score
            from
                questions q 
                
            join
                responses r on q.question_id = r.question_resp_id
            where
                q.survey_quest_id = surveyID;
        
            select average_score as survey_score;
        
        end
        
        -- EXECUTE THE STORED PROCEDURE.
        call sp_CalculaSurveyScore(1);


        create procedure sp_CalculateWeights(in surveyID int)
        begin
            declare total_score int; -- declare a variable to stored the score.
            select
                coalesce(
                    sum(
                        case r.response_text -- set the weights
                            when 'Very Satisfied' then 5
                            when 'Satisfied' then 4
                            when 'Neutral' then 3
                            when 'Dissatisfied' then 2
                            when 'Very Dissatisfied' then 1
                            else 0 -- 0 or add more weights.
                        end
                    ), 0
                ) into total_score
            from
                questions q
            left join
                responses r on q.question_id = r.question_resp_id
            where
                q.survey_quest_id = surveyID; -- parameter survey_id
        
            select total_score as responses_weight; -- shows the result
        end
        
        -- EXECUTE THE STORED PROCEDURE
        call sp_CalculateWeights(2); -- 0 is the survey_id parameter.

        
        
    ```

2. Create the view:
    ```sql
     Script on document Task 3: Stored Procedures and Views.
        CREATE VIEW v_survey_responses AS
        SELECT 
            s.survey_name AS Survey,
            q.question_text AS Question,
            r.response_text,
            AVG(
                CASE r.response_text
                    WHEN 'Very Satisfied' THEN 5
                    WHEN 'Satisfied' THEN 4
                    WHEN 'Neutral' THEN 3
                    WHEN 'Dissatisfied' THEN 2
                    WHEN 'Very Dissatisfied' THEN 1
                    ELSE 0
                END
            ) AS average_score
        FROM
            surveys s
        JOIN
            questions q ON s.survey_id = q.survey_quest_id
        JOIN
            responses r ON q.question_id = r.question_resp_id
        GROUP BY
            s.survey_name,
            q.question_text;
        
        
        
           -- QUERY TO EXECUTE THE VIEW
           select *from v_survey_responses;
    ```

## Solution Description

### Database Schema

- **Table `surveys`:** Stores information about the surveys.
- **Table `questions`:** Stores the questions associated with the surveys.
- **Table `responses`:** Stores users' responses to the questions.
- **Table `users`:** Stores user information.

### Queries

- **Basic Queries:** Retrieve all responses for a given survey, including survey name, question text, and response text.
- **Advanced Queries:** Calculate the average score for each survey, find the top 3 users with the highest average response score, and determine the distribution of responses for each question in a specific survey.

### Stored Procedures and Views

- **Stored Procedure:** Calculates the score for a survey based on responses.
- **View:** Displays survey name, question text, response text, and calculated score for each response.

## Contact

If you have any questions or need further information, feel free to contact me.

Thank you for reviewing my solution!

