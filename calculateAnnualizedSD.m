function aSD = calculateAnnualizedSD(returns)
    % Input:
    % returns: A vector of returns for each period

    % Calculate mean return
    r = mean(returns);

    % Calculate the annualized standard deviation
    n = length(returns);
    aSD = sqrt(252)*sqrt(sum((returns - r).^2)/(n - 1));
end
