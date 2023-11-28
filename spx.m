fn = 'spx.xlsx';

opt=detectImportOptions(fn);
spx_prices = readtimetable(fn,opt);
prices = spx_prices{:,:};

returns = diff(prices(:,:)) ./ prices(1:end-1, :);
returns = [0 ; returns];

window_all = [10, 25, 50, 100];
threshold_all = [0.05, 0.1];

AllPerformanceMetrics = [];



for k = 1:length(threshold_all)

    threshold = threshold_all(k);

    for j = 1:length(window_all)
    
        % Parametry
        window = window_all(j);  % Długość okna dla średniej kroczącej
           % Buy/Sell when price is above/below SMA * threshold
        transaction_cost_rate = 0.005; % Transaction cost rate per position

        buyNhold = prices(window:end,:)./prices(window);
        
        % Inicjalizacja zmiennych
        signals = zeros(size(prices, 1), 1);
        position = 0;  % 0 - neutral, 1 - długa, -1 - krótka
        capital(1) = 1;
        
        % Oblicz średnie kroczące
        sma = movmean(prices(:,:), window, 'Endpoints', 'discard');
        
        % Trading strategy with transaction costs
        for i = window+1:length(prices)
            if prices(i) > sma(i-window) * (1+threshold)
                if position == -1
                    % Buy signal
                    signals(i) = 1;
                    position = 1;
                    capital(i-window+1) = capital(i-window)*(1+returns(i-1) - 2*transaction_cost_rate);
                elseif position == 0
                    signals(i) = 1;
                    position = 1;
                    capital(i-window+1) = capital(i-window)*(1+returns(i-1) - 2*transaction_cost_rate);
                else
                    signals(i) = 1;
                    capital(i-window+1) = capital(i-window)*(1+returns(i-1));    
                end
            elseif prices(i) < sma(i-window) * (1-threshold)
                if position == 1
                    % Short signal
                    signals(i) = -1;
                    position = -1;
                    capital(i-window+1) = capital(i-window)*(1-returns(i-1) - 2*transaction_cost_rate);
                elseif position == 0
                    signals(i) = -1;
                    position = -1;
                    capital(i-window+1) = capital(i-window)*(1-returns(i-1) - transaction_cost_rate);
                else
                    signals(i) = -1;
                    capital(i-window+1) = capital(i-window)*(1-returns(i-1));  
                end
            else
                % Neutral signal
                signals(i) = 0;
                position = 0;
                capital(i-window+1) = capital(i-window);
            end
        end
       
                
        % Plotting
        figure;
        subplot(2,1,1);
        plot(prices, 'k');
        hold on;
        plot(sma, 'r', 'LineWidth', 2);
        title('Price and SMA');
        legend('Price', 'SMA');
        ylabel('Price');
        
        subplot(2,1,2);
        stairs(signals, 'b', 'LineWidth', 2);
        title('Trading Signals');
        xlabel('Time');
        ylabel('Signal');
        ylim([-1.5 1.5]);
        
        % Save plot as a PNG image with a unique name
        fileName = ['Trading Signals_window_', num2str(window), 'threshold_', num2str(threshold), '.png'];  % Generate a unique file name
        saveas(gcf, fileName);
        
        
        % Plotting
        figure;
        plot(buyNhold, 'k');
        hold on;
        plot(capital, 'r', 'LineWidth', 2);
        title('strategy and BnH');
        legend('buyNhold', 'strategy');
        ylabel('Price');
        
        % Save plot as a PNG image with a unique name
        fileName = ['strategy and BnH_window_', num2str(window), 'threshold_', num2str(threshold), '.png'];  % Generate a unique file name
        saveas(gcf, fileName);



        %calculation of performance metrics
        
        %ARC Annualized Return Compounded 
        ARC = calculateARC(capital);
        
        % Calculate annualized standard deviation
        aSD = calculateAnnualizedSD(capital);
        
        % Calculate Maximum Drawdown
        MD = calculateMaxDrawdowns(capital);
        
        
        % Calculate Information Ratio
        IR = calculateInformationRatio(ARC, aSD);
        
        
        % Calculate Modified Information Ratio
        IR2 = calculateModifiedInformationRatio(ARC, aSD, MD);
        
        
        % Calculate Maximum Loss Durations for each asset
        MLD = calculateMaxLossDuration(capital, 252);


        PerformanceMetrics = table(ARC, aSD, MD, IR, IR2, MLD,'VariableNames',{'ARC','aSD','MD','IR','IRst','MLD'});
        % Concatenate the new data to the existing table
        AllPerformanceMetrics = [AllPerformanceMetrics; PerformanceMetrics];
    
        capital = [];
    end
end


%calculation of performance metrics for buyNhold

%ARC Annualized Return Compounded 
ARC = calculateARC(buyNhold);

% Calculate annualized standard deviation
aSD = calculateAnnualizedSD(buyNhold);

% Calculate Maximum Drawdown
MD = calculateMaxDrawdowns(buyNhold);


% Calculate Information Ratio
IR_star = calculateInformationRatio(ARC, aSD);


% Calculate Modified Information Ratio
IR_star_star = calculateModifiedInformationRatio(ARC, aSD, MD);


% Calculate Maximum Loss Durations for each asset
MLD = calculateMaxLossDuration(buyNhold, 252);

PerformanceMetrics = table(ARC, aSD, MD, IR, IR2, MLD,'VariableNames',{'ARC','aSD','MD','IR','IRst','MLD'});
% Concatenate the new data to the existing table
AllPerformanceMetrics = [AllPerformanceMetrics; PerformanceMetrics];

% Save the complete table to a CSV file
writetable(AllPerformanceMetrics, 'all_performance_metrics.csv', 'WriteRowNames', true);


