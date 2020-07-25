function plotPCA(data,dim2Reduce)
    N = size(data,2);       %trails num
    Cov = data*data'./(N-1);  %covarience matrix
    [EV,~] = eigs(Cov,dim2Reduce);
    component = EV' * data;
    figure
    if(dim2Reduce==3)
        
    else
        for i = 1:dim2Reduce
            
        end

    
    
    
    
end
