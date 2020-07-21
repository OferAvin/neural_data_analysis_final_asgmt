function infoFreqBand = findInfoFreqBand(signal1,signal2,diff,freq)
    diffVec = signal1-signal2;
    infoIndex = find(diffVec >= diff);
    
end