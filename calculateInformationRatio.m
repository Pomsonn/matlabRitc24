function IR_star = calculateInformationRatio(ARC, aSD)
    % Input:
    % ARC: Annualized Return Compounded
    % aSD: Annualized Standard Deviation

    % Calculate Information Ratio
    IR_star = ARC ./ aSD;
end
