function MD = calculateMaxDrawdowns(prices)
    % Input:
    % prices: Matrix of prices for multiple assets (each column is a different asset)

    n = length(prices);


    drawdowns = zeros(n, 1);

    for x = 1:n
        for y = x+1:n
            drawdowns(x) = max(drawdowns(x), (prices(x) - prices(y)) / prices(x));
        end
    end

    % Calculate Maximum Drawdown for the current asset
    MD = max(drawdowns);

end

