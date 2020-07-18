% this function gets each bend boundaries as an input and returns the bend
%indices in the range - f as an output.
function waveCell = extractWavesIdx(delta, theta, lowAlpha, highAlpha, beta, gamma, range)
    
    delta_rng = find(range >= delta(1) & range <= delta(end));
    theta_rng = find(range > theta(1) & range <= theta(end));
    alphaLow_rng = find(range > lowAlpha(1) & range <= lowAlpha(end));
    alphaHigh_rng = find(range > highAlpha(1) & range <= highAlpha(end));
    beta_rng = find(range > beta(1) & range <= beta(end));
    gamma_rng = find(range > gamma(1) & range <= gamma(end));

    waveCell = {delta_rng theta_rng alphaLow_rng alphaHigh_rng beta_rng gamma_rng};
end