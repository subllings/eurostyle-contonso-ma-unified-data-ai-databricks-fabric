-- Quick QA SQL snippets for Fabric Lakehouse after ingestion
-- Replace <lakehouse> with your Lakehouse name/context where needed

-- 1) Row counts check
SELECT COUNT(*) AS row_count FROM customer_scores_gold;

-- 2) Key uniqueness (adjust as needed)
SELECT customer_id, COUNT(*) AS c
FROM customer_scores_gold
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- 3) Value bounds
SELECT
  SUM(CASE WHEN churn_score < 0 OR churn_score > 1 THEN 1 ELSE 0 END) AS churn_out_of_bounds,
  SUM(CASE WHEN clv_pred < 0 THEN 1 ELSE 0 END) AS clv_negative
FROM customer_scores_gold;

-- 4) Null rates by column (example for a few columns)
SELECT
  SUM(CASE WHEN churn_score IS NULL THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS null_rate_churn,
  SUM(CASE WHEN clv_pred IS NULL THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS null_rate_clv
FROM customer_scores_gold;

-- 5) Latest as_of_date
SELECT MAX(as_of_date) AS latest_as_of_date FROM customer_scores_gold;

-- 6) Distribution by churn bucket (if bucket column exists)
SELECT churn_bucket, COUNT(*) AS n
FROM customer_scores_gold
GROUP BY churn_bucket
ORDER BY churn_bucket;
