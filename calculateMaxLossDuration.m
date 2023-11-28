function MLD = calculateMaxLossDuration(prices, S)
    % Input:
    % prices: Matrix of prices for multiple assets (each column is a different asset)
    % S: Number of trading periods per year for a given frequency

    n = size(prices);

    maxDrawdownStart = 1;
    maxDrawdownEnd = 1;
    currentDrawdownStart = 1;

    for t = 2:n
        if prices(t) > prices(t - 1)
            currentDrawdownStart = t;
        else
            currentDrawdownEnd = t;

            if prices(currentDrawdownEnd) < prices(maxDrawdownEnd)
                maxDrawdownStart = currentDrawdownStart;
                maxDrawdownEnd = currentDrawdownEnd;
            end
        end
    end

    % Calculate Maximum Loss Duration for the current asset
    MLD = (maxDrawdownEnd - maxDrawdownStart) / S;

end
