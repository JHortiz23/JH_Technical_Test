-- ********** BASIC QUERIES **************
/*
 * Query to retrieve all responses for a given survey
 * 
 * FOR OPTIMIZING THE QUERY
 * 1: Only select the columns you need. This minimizes the amount of data retrieved and processed.
 * 2: The indexes created during database design help speed up the JOIN operations and the WHERE clause filter.
 * 
 * */
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

    
    
-- ********** ADVANCED QUERIES **************
/* 
 * For this example, AVG is used to calculate the average score of people's satisfaction.
 * the CASE expression within the AVG function assigns numerical scores to every option to select by the user in the survey.
 * Finally, each result obtained is linked via a JOIN to the respective survey to which the questions and their responses belong.
 * 
 * Column and numerical score (any value or validation) depend on the function or result we want to obtain.
 * */
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
   

/* 
 * For this example result, AVG is used to calculate the top 3 users with the highest average score of people's satisfaction across all surveys.
 * the CASE expression within the AVG function assigns numerical scores to every option to select by the user in the survey.
 * Finally, each result obtained is linked via a JOIN to the respective user information to which the questions and responses belong.
 * 
 * "Group by" To group rows that have the same value.
 * "Limit" to controll the number of rows returned by the query.
 * "Order by (DESC)" To order the results in decending order, from the highest to the lowest value.
 * 
 * "TO_BASE64" An example to hide user id as a sensitive data.
 * */
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

/***/
/* 
 * this example result is to get the total of responses for each question in a specific survey.
 * Select of the columns to show (output).
 * Finally, each result obtained is linked via a JOIN to the respective survey which the questions, responses and reponses count belong.
 * 
 * "Count" Count of responses of a certain question. 
 * "Group by" To group rows that have the same value.
 * "WHERE" clause to get the results of a specific survey (survey_id).
 * "Order by (DESC)" To order the results in decending order, from the highest to the lowest count value.
 * 
 * */
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
