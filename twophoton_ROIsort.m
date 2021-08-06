[datapoints,n] = size(x);

totalROIs = datapoints/300; %%300 is the number of frames per video

for i = 1:totalROIs
    sorted_ROI_data(i,:) = x((300*i)-299:300*i,4); %%takes the 300 data points per ROI and puts them into a new matrix with each row as an ROI
    ROImean(i) = mean(sorted_ROI_data(i,:)); %% calculates mean of each ROI trace (for baseline)
    ROIstd(i) = std(sorted_ROI_data(i,:)); %%calculates standard deviation of each ROI trace
    ROIpeak(i) = max(sorted_ROI_data(i,:)); %% calculates the highest peak of each ROI trace
    ROIthres(i) = ROImean(i) + ROIstd(i); %% sets threshold for 1 std above mean
    
    sorted_ROI_dff(i,:) = ((sorted_ROI_data(i,:) - ROImean(i))/ ROImean(i));
    ROImean_dff(i) = mean(sorted_ROI_dff(i,:));
    ROIstd_dff(i) = std(sorted_ROI_dff(i,:));
    ROIpeak_dff(i) = max(sorted_ROI_dff(i,:));
    ROIthres_dff(i) = ROImean_dff(i) + ROIstd_dff(i);
end


%%for finding the amplitude of peaks and locations of each peak
for j = 1:totalROIs
    [PKS{j},LOCS{j}] = findpeaks(sorted_ROI_data(j,:),'MinPeakProminence', 2*ROIstd(j)); %% finds the peaks and location of peaks from the data based on threshold
    [dffPKS{j},LOCS{j}] = findpeaks(sorted_ROI_dff(j,:),'MinPeakProminence', 2*ROIstd_dff(j)); %% finds the normalized peaks and location of peaks from the data based on threshold
    Amp(j) = mean(PKS{j});
    dffAmp(j) = mean(dffPKS{j});
    Freq(j) = length(LOCS{j})/5;
end


%%finding the dff amplitude of each peak using peak location data
% for m = 1:length(LOCS)
%     LOCSmatrix(m,:) = LOCS{m}
% end




