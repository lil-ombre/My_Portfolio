/*
PPC Campaign Performance: Queries and Insights
by Adrian Luis-Martinez
*/
SELECT *
FROM ppc_campaign_cleaned
LIMIT 20;
### 1. Which platforms have the highest average ROAS(Return on Ad Spend)?
## Insights: Facebook has the highest average ROAS at 13.04, followed closely by LinkedIn and Google.
-- All platforms are significantly above the standard ROAS benchmark of 4.0, indicating strong returns across all platforms. 
## Recommendations: Prioritze Facebook for scaling campaigns. 
-- All platforms performed exceedingly well - no major changes are required but prioritizing top three platforms could improve returns.
SELECT platform, ROUND(AVG(roas),3) AS average_return_on_ad_spend
FROM ppc_campaign_cleaned
GROUP BY platform
ORDER BY average_return_on_ad_spend DESC;

### 2. Which content types generate the highest average conversion rate?
## Insights:Video content has the highest average conversion rate at 0.527, followed closley carousel (0.524) and image (0.500)
-- Text-based ads perform the lowest at 0.481
-- All formats perform exceedingly well (over 48%), but video still leads
## Recommendations: Prioritize video content for future campaigns if aiming for higher conversions
-- Carousel and image content can be used to diversify strategy
-- Consider limiting use of text contnent or testing improvements to boost performance
SELECT content_type, ROUND(AVG(conversion_rate),3) AS average_conversion_rate
FROM ppc_campaign_cleaned
GROUP BY content_type
ORDER BY average_conversion_rate DESC;

### 3. Which age groups generate the strongest performance and cost-efficiency?
## Insights: The 25–34 age group delivers the highest average ROAS at 12.39, closely followed by the 55+ and 45–54 segments
-- The 55+ group has the lowest average CPA at 39.07 and second highest average ROAS, results suggest strong cost efficiency
-- The 18–24 group shows the lowest ROAS at 10.96 and a relatively high CPA, making it the least efficient segment in this dataset.
## Recommendations: Prioritize the 25–34 and 55+ age groups, both balance strong returns with efficient costs
-- Consider scaling back spend on the 18–24 segment, suggest running tests to improve efficiency
SELECT target_age, ROUND(AVG(roas),3) AS average_return_on_ad_spend, ROUND(AVG(cpa),3) AS average_cost_per_acquisition
FROM ppc_campaign_cleaned
GROUP BY target_age
ORDER BY average_return_on_ad_spend DESC, average_cost_per_acquisition ASC;

### 4. Which regions generate the highest ROAS and revenue?
## Insights: North America delivers the highest ROAS at 12.47 and the highest total revenue at $12.6M
-- Europe and South America follow closely, both generating ROAS above 12.3 and revenue over $12.4M
-- Africa lags behind with a significantly lower ROAS of 9.11 and the lowest revenue at $9.7M
## Recommendations: North America, Europe, South America, and Asia are nearly identical in both revenue and ROAS, making them strong candidates for scaling
-- Africa performed well but may benefit from creative testing or targeting refinement
SELECT region, ROUND(AVG(roas),3) AS average_return_on_ad_spend, SUM(revenue) AS total_revenue
FROM ppc_campaign_cleaned
GROUP BY region
ORDER BY average_return_on_ad_spend DESC, total_revenue DESC;

### 5. Which campaigns had high spend but delivered low return on ad spend (ROAS)?
-- Step 1: Find ROAS and Spend distribution to define thresholds needed
-- important thresholds found: Average Spend = 5956.17, High Spend => 7500, Average ROAS = 11.69, Low ROAS =< 4.0
SELECT 
  MIN(spend) AS min_spend,
  MAX(spend) AS max_spend,
  ROUND(AVG(spend), 2) AS avg_spend,
  MIN(roas),
  MAX(roas),
  AVG(roas)
FROM ppc_campaign_cleaned;
-- Step 2: Identify Campaigns with High Spend but Low ROAS
## Insights: A total of 139 campaigns spent over $7,500 but returned a ROAS below 4.0, far below the average (ROAS = 11.69)
-- Some campaigns spent nearly $10K but returned less than $3K, indicating major inefficiencies
## Recommendations: Suggest pausing or reallocating budgets while testing for improvements
SELECT campaign_id, spend, revenue, roas
FROM ppc_campaign_cleaned
WHERE spend > 7500 AND roas < 4
ORDER BY spend DESC;

### 6. Which gender segment delivers the highest ROAS and lowest CPA?
## Insights: The "Other" gender segment has the highest average ROAS at 12.82, but a mid-range CPA of 40.75
-- The Male segment has the lowest CPA at 37.40 and a strong ROAS of 11.53, making it the most cost-efficient overall
-- The Female segment has the lowest ROAS at 10.61 and the highest CPA at 44.98, indicating lower efficiency
## Recommendations: Prioritize campaigns targeting Male and "Other" gender segments based on strong performance
-- Suggest testing new strategies or messaging to improve cost-efficiency for Female segment
SELECT target_gender, 
	ROUND(AVG(roas),3) AS average_return_on_ad_spend, 
    ROUND(AVG(cpa),3) AS average_cost_per_acquisition,
    COUNT(*) AS total_campaigns
FROM ppc_campaign_cleaned
GROUP BY target_gender
ORDER BY average_return_on_ad_spend DESC, average_cost_per_acquisition ASC;

### 7. Which combinations of platform and content type generate the highest average return on ad spend (ROAS)?
## Insights: Facebook + Video content has the highest ROAS at 15.94, making it the top-performing combination overall
-- YouTube + Carousel (13.64) and LinkedIn + Video (13.29) also perform well above average
-- Google + Text has one of the lowest ROAS scores at 9.48, and YouTube + Text is the lowest overall at 9.12
## Recommendations: Prioritize Video content on Facebook, LinkedIn, and Instagram for maximum return
-- Consider reducing or redesigning Text-based campaigns, especially on YouTube and Google where they underperform
-- Explore scaling Carousel formats on high-performing platforms like YouTube, Google, and Facebook
SELECT platform,
	content_type,
    ROUND(AVG(roas),3) AS average_return_on_ad_spend,
    COUNT(*) AS total_campaigns
FROM ppc_campaign_cleaned
GROUP BY platform, content_type
ORDER BY average_return_on_ad_spend DESC;
