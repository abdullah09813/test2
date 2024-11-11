WITH UserActivity AS (
    SELECT 
        user_id,
        COUNT(*) AS activity_count
    FROM 
        user_actions
    WHERE 
        action_date >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month')
        AND action_date < DATE_TRUNC('month', CURRENT_DATE)
    GROUP BY 
        user_id
),
RankedUsers AS (
    SELECT 
        user_id,
        activity_count,
        ROW_NUMBER() OVER (ORDER BY activity_count DESC) AS rank
    FROM 
        UserActivity
)
SELECT 
    user_id,
    activity_count
FROM 
    RankedUsers
WHERE 
    rank <= 5;