function arc = calculateARC(prices)
    % Input:
    % returns: A vector of returns for each period

    % Calculate the ARC
    n = length(prices);
    arc = (prices(end)/prices(1))^(252/n) - 1;
end
