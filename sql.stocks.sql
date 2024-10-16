USE stocks;

CREATE TABLE historical_prices (
    id INT AUTO_INCREMENT PRIMARY KEY,
    stock_symbol VARCHAR(10) NOT NULL,
    date DATE NOT NULL,
    open_price DECIMAL(10, 2) NOT NULL,
    close_price DECIMAL(10, 2) NOT NULL,
    high_price DECIMAL(10, 2) NOT NULL,
    low_price DECIMAL(10, 2) NOT NULL,
    volume BIGINT NOT NULL,
    UNIQUE KEY (stock_symbol, date)  -- Ensures no duplicate entries for the same stock on the same date
);

INSERT INTO stocks.historical_prices (stock_symbol, date, open_price, close_price, high_price, low_price, volume) VALUES
('AAPL', '2023-10-01', 175.00, 176.50, 177.00, 174.50, 10000000),
('AAPL', '2023-10-02', 176.60, 178.00, 179.00, 175.50, 12000000),
('MSFT', '2023-10-01', 330.00, 332.50, 335.00, 329.00, 8000000),
('MSFT', '2023-10-02', 332.60, 334.00, 335.50, 330.50, 9000000),
('GOOGL', '2023-10-01', 1400.00, 1420.50, 1430.00, 1390.00, 7000000),
('GOOGL', '2023-10-02', 1421.00, 1430.00, 1440.00, 1410.00, 6500000),
('AMZN', '2023-10-01', 3200.00, 3225.00, 3230.00, 3190.00, 6000000),
('AMZN', '2023-10-02', 3226.00, 3240.00, 3250.00, 3210.00, 5800000),
('TSLA', '2023-10-01', 850.00, 855.00, 860.00, 840.00, 11000000),
('TSLA', '2023-10-02', 856.00, 860.00, 865.00, 850.00, 11500000),
('FB', '2023-10-01', 330.00, 335.00, 336.00, 328.00, 5000000),
('FB', '2023-10-02', 335.50, 340.00, 342.00, 334.00, 5500000),
('BRK.A', '2023-10-01', 450000.00, 455000.00, 460000.00, 448000.00, 2000),
('BRK.A', '2023-10-02', 455500.00, 457500.00, 458000.00, 453000.00, 1800),
('JPM', '2023-10-01', 160.00, 162.50, 163.00, 159.00, 4000000),
('JPM', '2023-10-02', 162.80, 163.00, 164.00, 161.00, 4200000),
('NVDA', '2023-10-01', 220.00, 225.00, 226.00, 219.00, 3000000),
('NVDA', '2023-10-02', 225.50, 228.00, 229.00, 224.00, 3100000),
('NFLX', '2023-10-01', 500.00, 510.00, 512.00, 495.00, 2500000),
('NFLX', '2023-10-02', 511.00, 515.00, 520.00, 508.00, 2600000);

SELECT * FROM stocks.historical_prices;

-- Calculate the 5-day simple moving average (SMA) for AAPL

SELECT AVG(close_price) AS sma_5
FROM stocks.historical_prices
WHERE stock_symbol = 'AAPL';
 
-- Calculate a 30-day moving average and compare with the current close price

WITH moving_avg AS (
    SELECT date, close_price, AVG(close_price) OVER (ORDER BY date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW) AS ma_30
    FROM historical_prices
    WHERE stock_symbol = 'AAPL'
)
SELECT date, close_price, ma_30, CASE 
        WHEN close_price > ma_30 THEN 'Upward Trend'
        WHEN close_price < ma_30 THEN 'Downward Trend'
        ELSE 'No Trend'
    END AS trend
FROM moving_avg
ORDER BY date;

-- Find the Highest and Lowest closing prices for each stock

SELECT stock_symbol, MAX(close_price) AS highest_price, MIN(close_price) AS lowest_price
FROM historical_prices
GROUP BY stock_symbol;

-- Calculate the average volume traded per day for each stock

SELECT stock_symbol, AVG(volume) AS average_volume
FROM historical_prices
GROUP BY stock_symbol;

 -- Calculate the percentage change in the closing price from the beginning to the end of each year for each stock
 
SELECT stock_symbol, YEAR(date) AS year, MIN(close_price) AS start_price, MAX(close_price) AS end_price, ((MAX(close_price) - MIN(close_price)) / MIN(close_price)) * 100 AS percentage_change
FROM historical_prices
GROUP BY stock_symbol, year
ORDER BY year, stock_symbol;


-- Calculate the daily price change for a specific stock

WITH daily_changes AS (
    SELECT date, close_price, LAG(close_price) OVER (ORDER BY date) AS previous_close, ABS(close_price - LAG(close_price) OVER (ORDER BY date)) AS price_change
    FROM historical_prices
    WHERE stock_symbol = 'AAPL'
)
SELECT date, price_change
FROM daily_changes
WHERE previous_close IS NOT NULL
ORDER BY date;

-- Compare the Average closing price of two stocks over a specific time period

SELECT date, AVG(CASE WHEN stock_symbol = 'AAPL' THEN close_price END) AS AAPL_avg, AVG(CASE WHEN stock_symbol = 'MSFT' THEN close_price END) AS MSFT_avg
FROM historical_prices
WHERE date BETWEEN '2023-10-01' AND '2023-10-02'
GROUP BY date;

-- Calculate the price range (high-low) for each stock over a specified period

SELECT stock_symbol, MIN(low_price) AS min_price, MAX(high_price) AS max_price, MAX(high_price) - MIN(low_price) AS price_range
FROM historical_prices
WHERE date BETWEEN '2023-10-01' AND '2023-10-02'
GROUP BY stock_symbol;








