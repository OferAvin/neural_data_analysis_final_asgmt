function infoFreqBand = findInfoFreqBand(signal1,signal2,threshold,freq)
    diffVec = signal1-signal2;
    infoIndex = find(diffVec >= threshold);
    infoFreqBand = freq(infoIndex);
    
end