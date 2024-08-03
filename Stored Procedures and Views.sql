-- ********** STORED PROCEDURE **************
/*
 * Stored procedure that calculates the score for a survey base on responses.
 * the procedure takes one parameter "survey_id" wich specifies the survey for wich webwant to calculate the score.
 * A variable "average_score" is declared to hold the calculated average score.
 * "AVG - INTO" Calculates de avg score using "case" statement to map text response to numerical values and store them into "average_score".
 * "JOIN" each result obtained is linked via a JOIN to the respective survey to which the questions and responses belong.
 * "WHERE" Filter to include only responses for the specific survey_id.
 * "SELECT" Returns the result.
 * 
 * */

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

/*
 * Stored procedure that calculate the sum of all the responses weight (people´s satisfaction for this example).
 * For this example, every responses has a weight, wich could be assigned in different ways.
 * the procedure takes one parameter "survey_id" wich specifies the survey for wich web want to calculate the score.
 * A variable "average_score" is declared to hold the calculated score.
 * "SUM" Sums the weights for responses in the survey using "case" statement to map text response to numerical values and store them into "total_score".
 * "JOIN" each result obtained is linked via a JOIN to the respective question to which the response belongs.
 * "WHERE" Filter to include only responses for the specific survey_id.
 * "SELECT" Returns the result.
 * 
 * */

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


-- ********** CREATE VIEW **************
/*
 * View that displays that displays the survey name, question text, response text, and calculated score for each response (people´s satisfaction for this example).
 * For this example, every responses has a weight, wich could be assigned in different ways to calculate the average score.
 * A variable "score" is declared to hold the calculated score.
 * "JOIN" each result obtained is linked via a JOIN to the respective question to which the response belongs.
 * 
 * */

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
   
  
  /* "AVG" EXPLANATION ***
   * Each text response is mapped to a numerical value using a CASE statement.This mapping assigns a score to each possible response.
   * For this example i used people´s satisfaction from the surveys.
   * 
   * 'Very Satisfied': Assigned a score of 5.
   * 'Satisfied': Assigned a score of 4.
   * 'Neutral': Assigned a score of 3.
   * 'Dissatisfied': Assigned a score of 2.
   * 'Very Dissatisfied': Assigned a score of 1
   * other 0.
   * */