% this function returns the frequency which a prct(number between 0 to 100) percent
%of the power resides below it for each window
function spectralEdge = spectralEdge(Data,f,prct)
    indices = diff(cumsum(Data)>prct/100);
    [~,indices] = max(indices);
    spectralEdge = f(indices);
end