sum(diff(Data.allData(:,:,i) >= Features.mVthrshld,[],2),2) %get sum of passed th
maxV = max(Data.allData(:,:,i),[],2)
minV = min(Data.allData(:,:,i),[],2)