% [filename, path] = uigetfile('*')
% image = string(filename);

% [Data] = lsmread(uigetfile('*'));
% image = LSMtovar(Data);


pixxy = size(image,1);

first10framesavg = nanmean(image(:,:,1),3);   %%some points are 0
firstframeavg = nanmean(nanmean(image(:,:,1)));

%%changes all 0 in first10framesavg to 0.00001
first10framesavg(first10framesavg == 0) = 0.00001;


% for j = 1:size(first10framesavg,1)
%     for k = 1:size(first10framesavg,2)
%         if first10framesavg(j,k) == 0
%             first10framesavg(j,k) = 0.00001;
%         end
%     end
% end


%%generates df_f
tic
for j = 1:size(image,1)
    for k = 1:size(image,2)
        for l = 1:size(image,3)
        df_f(j,k,l) = image(j,k,l)/first10framesavg(j,k); 
        end
    end
end
toc

clear j k l 



m = nanmean(nanmean(nanmean(df_f)));
s = nanstd(reshape(df_f,1,(pixxy*pixxy*size(df_f,3))));

%%% Binning 10x10

for x = 1:floor(size(df_f,1)/10)
    for y = 1:floor(size(df_f,2)/10)
        for z = 1:size(df_f,3)
binned(x,y,z) = nanmean(nanmean(df_f(x*10-9:x*10,y*10-9:y*10,z))); 
        end 
    end
end
clear x y z

%%% For analysis of all bins
for i = 1:floor(pixxy/10)
    for j = 1:floor(pixxy/10)
        pixeltime((j+(i-1)*pixxy),:) = squeeze(binned(i,j,:));
    end
end
clear i j 

m = nanmean(nanmean(nanmean(binned)));
s = nanstd(reshape(binned,1,(floor(pixxy/10)*floor(pixxy/10)*size(binned,3))));



pixelbi = pixeltime;
pixelbi(pixeltime < m+3*s)= 0;
pixelbi(pixelbi > 0) = 1;


a=1;
new=[];
for i = 1:size(pixelbi,1)
    if nanmean(pixelbi(i,:)) > 0
        if nanmean(pixelbi(i,:)) < 1
        new(a,:) = pixelbi(i,:);
        %newcentroids(a) = COG(new(a,:));
        a = a+1;
        else
        end
    else
        a=a;
    end
end

%newcentroids = newcentroids';

%newsort = cat(2,newcentroids,new);
%newsort = sortrows(newsort,1);
%newsort(:,1) = [];

figure(1)
imagesc(new)

% figure(8)
% plot(nanmean(new))

%%%%%%%%%%%%%%%%%%

% figure(2)
% imagesc(binned(:,:,:))

%%%% make mask for ROI

%maxframe = max(binned,[],3);
maxframe = nanmean(binned,3);

meanmax = nanmean(nanmean(maxframe));
stdmax = nanstd(nanstd(maxframe));

thresh = meanmax+3*stdmax; %%%%% 2*SD

mask = maxframe;
mask(mask < thresh) = 0;
mask(mask > 0) = 1;

%%%%% For NMDA Puff analysis comment out for kevin

% f2 = figure(3)
% imagesc(mask)
% 
% maskidx = find(mask == 1);
% 
% for i = 1:size(A,2)
%     framemask = binned(:,:,i).*mask;
%     for j = 1:length(maskidx)
%         pixeltimeplot(i,j) = framemask(maskidx(j));
%     end
%     
% end
% 
% avgdf_ftrace = nanmean(pixeltimeplot');
% 
% f1 = figure(1)
% plot(avgdf_ftrace);
% 
% [y,I] = max(avgdf_ftrace);
% decay = avgdf_ftrace(I+30:end);
% 
% [fitresult] = createFit1(decay);
% 
% decaytime = -1/fitresult.b;
% NMDAamp = max(avgdf_ftrace) - nanmean(avgdf_ftrace(1:150));

%%%%%%


%%% FOR MAKING ROIs (comment if/end bookend statements to run)
    %if 1 < 0

    cc = bwconncomp(mask);
    stats = regionprops(cc,'Area','Centroid','BoundingBox','Eccentricity','PixelIdxList');

    for i = 1:length(stats)
    Area(i) = stats(i).Area;
    end
clear i



stats(Area < 2) = [];
%stats(Area > 10000) = [];

ROIarea = nanmean(Area);

filteredblobs = zeros(floor(pixxy/10),floor(pixxy/10));

for i = 1:length(stats);
    filteredblobs(stats(i).PixelIdxList) = 1;
end
clear i

for i = 1:size(stats,1)
    for t = 1:size(binned,3)
    reg = stats(i).PixelIdxList;
    binnedframe = binned(:,:,t);
    trace(i,t) = nanmean(binnedframe(reg));
    end
end
clear i t


ss=nanstd(trace');
mm=nanmean(trace');

rowthresh = mm+ss;
rowthresh = rowthresh';

peak = max(trace');
peak = peak';



a=1;
b=1;
IDXdelete = [];
for i = 1:size(rowthresh);
    if peak(i) > rowthresh(i)
        traceclean(a,:) = (trace(i,:)/mm(i));
        traceraw(a,:) = trace(i,:);
        offsettraces(a,:) = (trace(i,:))+(i/2);
        a=a+1;
        
    else
        IDXdelete(b) = i;
        b=b+1;
        a=a;
    end
end
clear a i b

%%%% Uncomment to generate example ROI images

stats2=stats;
stats2(IDXdelete) = [];

filteredblobs2 = zeros(floor(pixxy/10),floor(pixxy/10));

for i = 1:length(stats2);
    filteredblobs2(stats2(i).PixelIdxList) = 1;
end
clear i

IM2 = imresize(filteredblobs2,10);
IM2 = imgaussfilt(IM2);
IM3 = IM2;
IM3(IM3>.1) = 1;
IM3(IM3<1) = 0;
SE = strel('disk',4,8);
IM4 = imerode(IM3,SE);
IM5 = IM3-IM4;
IM6 = imresize(maxframe,10);
IM7 = IM6+max(max(IM6))*0.5.*IM5;
figure(7)
imagesc(IM7)
% 
% 
% 

figure(4)
imagesc(traceclean)

figure(5)
plot(offsettraces')

figure(6)
plot(traceclean')
meantrace = mean(traceclean);
hold on
plot(meantrace,'k','LineWidth',2)
hold off

%%% detect events in traces

for i = 1:size(traceraw,1)
[pksB{i},locsB{i},wB{i},pB{i}] = findpeaks(traceraw(i,1:(0.5*size(traceraw,2))),'MinPeakProminence',ss(i));
[pksP{i},locsP{i},wP{i},pP{i}] = findpeaks(traceraw(i,(0.5*size(traceraw,2):end)),'MinPeakProminence',ss(i));
end
clear i

%%% amplitude
pB = [pB'];
pP = [pP'];
BAmps = [];
PAmps = [];

for i = 1:size(pB,1)
BAmps = cat(2,BAmps,[pB{i}]);
PAmps = cat(2,PAmps,[pP{i}]);
end

avgAmpB = nanmean(BAmps);
avgAmpP = nanmean(PAmps);
Bstd = nanstd(BAmps);
Pstd = nanstd(PAmps);
seB = Bstd/sqrt(length(BAmps));
seP = Pstd/sqrt(length(PAmps));
%%% frequency
tic
for i = 1:size(pksB,2)
    countB(i) = size(pksB{i},2);
    countP(i) = size(pksP{i},2);
end
clear i
toc
freqB = sum(countB)/((size(traceraw,2)/4));
freqP = sum(countP)/((size(traceraw,2)/4));
% 
% stdFreqB = nanstd(countB);
% stdFreqP = nanstd(countP);
% seFreqB = (stdFreqB)/sqrt(size(traceraw,1));
% seFreqP = (stdFreqP)/sqrt(size(traceraw,1));
%else
%end

fn = sprintf('%0.5e',image(1:end-4));

output = {fn,avgAmpB,seB,avgAmpP,seP,freqB,freqP,size(traceraw,1),ROIarea};
%output = {fn,size(maskidx,1),avgdf_ftrace,NMDAamp,decaytime};