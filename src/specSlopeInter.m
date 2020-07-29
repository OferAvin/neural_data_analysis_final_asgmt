function [slope,intercept] = specSlopeInter(specPower,freq)
%returning the slope and intercept of the log power.
    N = size(specPower ,2); %sample num
    coeff = zeros(N,2);     
    for i = 1:N
        coeff(i,:) = polyfit(10*log10(freq)',10*log10(specPower(:,i)),1);
    end
    slope = coeff(:,1);
    intercept = coeff(:,2);
end