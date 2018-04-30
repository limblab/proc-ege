function [ReconstructionError LowerBoundError UpperBoundError ErrorBoot] = PCAwithError(spike_data,ConfidenceInterval)

%get binsize
unique_intervals = unique(spike_data(:)); 
binsize = unique_intervals(2);

%convert Poisson to Gaussian
spike_data = sqrt(spike_data/binsize);
num_channel = size(spike_data,2);

% Gaussian filtering
ws = 5;
w = gausswin(2*ws+1)/ws;
for kk = 1:num_channel
    spike_data(:,kk) = filter(w,1,spike_data(:,kk));
    
end

% Do PCA. get eigenvectors and scores.
% [eigenvectors, scores] = pca(spike_data);
% mu = mean(spike_data);
% 
% for ii = 1:length(Dimensions)
%         spike_data_hat_PCA = scores(:,1:Dimensions(ii)) * eigenvectors(:,1:Dimensions(ii))';
%         spike_data_hat_PCA = spike_data_hat_PCA + mu;
%         VAF(1,ii) = (1-sum(sum((spike_data-spike_data_hat_PCA).^2 ))/sum(sum((spike_data-repmat(mean(spike_data),size(spike_data,1),1)).^2)))*100;
% end

% [~,~,~,~,VAF] = pca(spike_data);
% VAF = cumsum(VAF)';
% 
nBoot = 1000;
VAF_Boot = zeros(size(spike_data,2),nBoot);
nBin = size(spike_data,1);
for jj = 1:nBoot
    spike_data_boot = spike_data(randsample(nBin,nBin,1),:);
    [~,~,~,~,VAF_Boot(:,jj)] = pca(spike_data_boot);
    VAF_Boot(:,jj) = cumsum(VAF_Boot(:,jj));
end
[VAF,lowVAF,highVAF] = getCIforPCA(VAF_Boot,ConfidenceInterval);


ReconstructionError = 100 - VAF;
LowerBoundError = 100 - highVAF;
UpperBoundError = 100 - lowVAF;
ErrorBoot = 100 - VAF_Boot;


end