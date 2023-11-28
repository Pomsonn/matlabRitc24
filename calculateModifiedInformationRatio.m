function IR_star_star = calculateModifiedInformationRatio(ARC, aSD, MD)
    % Input:
    % ARC: Annualized Return Compounded
    % aSD: Annualized Standard Deviation
    % MD: Mean Deviation

    % Calculate Modified Information Ratio
    IR_star_star = (ARC .* ARC .* sign(ARC)) ./ (aSD .* MD);
end
