function [meanVal,lowerBound,upperBound]=getCIforPCA(bootstat,CI)
% CI: confidence interval
% Ex: CI = 95, need the first 2.5% and the last 2.5% of the data. 
CI = 1-CI/100;
for ii = 1:size(bootstat,1)
bootstatrow = bootstat(ii,:);
nPts=length(bootstatrow);
x=sort(bootstatrow);
lbindx=round(nPts*(CI/2));
ubindx=round(nPts*(1-CI/2));
lowerBound(ii)=x(lbindx);
upperBound(ii)=x(ubindx);
meanVal(ii) = mean(bootstatrow);
end
end