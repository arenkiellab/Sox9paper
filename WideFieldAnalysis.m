%% Load and Selects Files
foldername='filepath'; %User Input of the file directory
date = 150605;                      %Date/Animal ID (User input)    
AnimalIndex = 5;                    %Index for the array for all data (User Input - Change for each sample)
Group = 1;                           %User defined, 1=Dlx5/6, 2=CRHR, 3=Dlx6weeks


IAA = [foldername,'Average_IAA.tif'];           %Grabs IAA 
ANI = [foldername,'Average_Anisole.tif'];   %Grabs Anisole
MSC = [foldername,'Average_MSC.tif']; %Grabs MSC
load('outline.mat')                             %Make sure the outline is loaded

%% Register OB Mask
Register = double(imread(IAA, 1));              %Loads the first frame of IAA movie         
figure, imshow(Register, []);                   %Show the first frame
OutlineRegister = impoly(gca, outline);         %Apply Outline to register
Accepted_pos = wait(OutlineRegister);           %Pauses code until double click on ROI
FinalROI = impoly(gca, Accepted_pos);           %Sets the ROI as final position
Mask = createMask(FinalROI);                    %Creates Mask of OB
ROIarea = bwarea(Mask);                         %Calculates area of ROI

%% Create Filter
GaussianFilter = fspecial('average');       %Creates filter (3 x 3)

%% IAA Create df_f & df Section
    IAA_Baseline = double(imread(IAA, 20)); 
    for i = 21:30                                                    % Set up for loop for averaging baseline
        IAA_Baseline = IAA_Baseline + double(imread(IAA ,i));
    end
     IAA_Baseline = IAA_Baseline/11;                                    % Makeing Average
     IAA_BaselineF = imfilter(IAA_Baseline, GaussianFilter);            % Filters BaselineIAA


    IAA_Response = double(imread(IAA, 35));
    for i = 36:65                                                      % Set up for loop for averaging response
        IAA_Response = IAA_Response + double(imread(IAA ,i));
    end
     IAA_Response = IAA_Response/31;                                    % Making Average
     IAA_ResponseF = imfilter(IAA_Response, GaussianFilter);            % Filters ResponseIAA   


    IAA_df_f = (IAA_ResponseF-IAA_BaselineF)./IAA_BaselineF;                %Calculates df/f map
    IAA_df = (IAA_ResponseF-IAA_BaselineF);                                 %Calculates df map
    %%IAA_df_f = IAA_df_f.* Mask;
    IAA_df = IAA_df.* Mask;
    IAA_df_f = IAA_df_f(any(IAA_df_f,2),:);                             %Removes any ALL Zero Rows
    IAA_df_f = IAA_df_f(:,any(IAA_df_f,1));                             %Removes any ALL Zero Columns
    IAA_df = IAA_df(any(IAA_df,2),:);                             %Removes any ALL Zero Rows
    IAA_df = IAA_df(:,any(IAA_df,1));                             %Removes any ALL Zero Columns
    
    
   %%figure, imshow(IAA_df_f, []);
   %%figure, imshow(IAA_df, []);

 %% IAA Analyze df_f   
 IAA_df_f_Max = max(IAA_df_f(:));                     %Calculates max df/f
 IAA_normdf_f = IAA_df_f/IAA_df_f_Max;                %nomalizes map to maxf
 IAA_df_fthresh70 = im2bw(IAA_normdf_f, 0.70);         %Thresholds normal map at 70%
 figure, imshow(IAA_df_fthresh70);                    %Displays binary 50% threshold image
 title('IAA')
 IAA_df_f_Area = bwarea(IAA_df_fthresh70);            %Caculate Area of image valued over 50% max (all pixels)
 
 IAA_df_ffinal = bwareaopen(IAA_df_fthresh70,5);                %Fills holes of binary image    
 [IAA_index_df_f, fN] = bwlabel(IAA_df_ffinal);                 %Indexes segmented 
 fD = regionprops(IAA_index_df_f, 'area', 'centroid');          %Makes an array of all the segments indexes
 fA = [fD.Area];                                                %Creates array of
 IAA_df_f_maxSegment = max(fA);                                 %Finds the value of the max area
 fAmaxI = find(fA==IAA_df_f_maxSegment);                        %Finds the index of the max area
 IAA_df_f_Centroid = [fD(fAmaxI,1).Centroid];                   %Reports the centroid of the largest Array

 
%%  IAA Analyze df   
 IAA_df_Max = max(IAA_df(:));                     %Calculates max df/f
 IAA_normdf = IAA_df/IAA_df_Max;                %nomalizes map to maxf
 IAA_df_thresh70 = im2bw(IAA_normdf, 0.70);         %Thresholds normal map at 50%
 %figure, imshow(IAA_df_thresh50);                    %Displays binary 50% threshold image
 IAA_df_Area = bwarea(IAA_df_thresh70);            %Caculate Area of image valued over 50% max (all pixels)
 
 IAA_df_final = bwareaopen(IAA_df_thresh70,5);                %Fills holes of binary image    
 [IAA_index_df, fN] = bwlabel(IAA_df_final);                 %Indexes segmented 
 fD = regionprops(IAA_index_df, 'area', 'centroid');          %Makes an array of all the segments indexes
 fA = [fD.Area];                                                %Creates array of
 IAA_df_maxSegment = max(fA);                                 %Finds the value of the max area
 fAmaxI = find(fA==IAA_df_maxSegment);                        %Finds the index of the max area
 IAA_df_Centroid = [fD(fAmaxI,1).Centroid];                   %Reports the centroid of the largest Array

 
%% MSC Create df_f & df Section
    MSC_Baseline = double(imread(MSC, 20)); 
    for i = 21:30                                                    % Set up for loop for averaging baseline
        MSC_Baseline = MSC_Baseline + double(imread(MSC ,i));
    end
     MSC_Baseline = MSC_Baseline/11;                                    % Makeing Average
     MSC_BaselineF = imfilter(MSC_Baseline, GaussianFilter);            % Filters BaselineMSC
 
 
    MSC_Response = double(imread(MSC, 35));
    for i = 36:65                                                      % Set up for loop for averaging response
        MSC_Response = MSC_Response + double(imread(MSC ,i));
    end
     MSC_Response = MSC_Response/31;                                    % Making Average
     MSC_ResponseF = imfilter(MSC_Response, GaussianFilter);            % Filters ResponseMSC   
 
 
    MSC_df_f = (MSC_ResponseF-MSC_BaselineF)./MSC_BaselineF;                %Calculates df/f map
    MSC_df = (MSC_ResponseF-MSC_BaselineF);                                 %Calcultes df map
    MSC_df_f = MSC_df_f.* Mask;
    MSC_df = MSC_df.* Mask;
    MSC_df_f = MSC_df_f(any(MSC_df_f,2),:);                             %Removes any ALL Zero Rows
    MSC_df_f = MSC_df_f(:,any(MSC_df_f,1));                             %Removes any ALL Zero Columns
    MSC_df = MSC_df(any(MSC_df,2),:);                             %Removes any ALL Zero Rows
    MSC_df = MSC_df(:,any(MSC_df,1));                             %Removes any ALL Zero Columns
    
    
    
  %  figure, imshow(MSC_df_f, []);
  %  figure, imshow(MSC_df, []);
 
 %% MSC Analyze df_f   
 MSC_df_f_Max = max(MSC_df_f(:));                     %Calculates max df/f
 MSC_normdf_f = MSC_df_f/MSC_df_f_Max;                %nomalizes map to maxf
 MSC_df_fthresh70 = im2bw(MSC_normdf_f, 0.70);         %Thresholds normal map at 50%
 figure, imshow(MSC_df_fthresh70);                    %Displays binary 50% threshold image
 title('MSC')
 MSC_df_f_Area = bwarea(MSC_df_fthresh70);            %Caculate Area of image valued over 50% max (all pixels)
 
 MSC_df_ffinal = bwareaopen(MSC_df_fthresh70,5);                %Fills holes of binary image    
 [MSC_index_df_f, fN] = bwlabel(MSC_df_ffinal);                 %Indexes segmented 
 fD = regionprops(MSC_index_df_f, 'area', 'centroid');          %Makes an array of all the segments indexes
 fA = [fD.Area];                                                %Creates array of
 MSC_df_f_maxSegment = max(fA);                                 %Finds the value of the max area
 fAmaxI = find(fA==MSC_df_f_maxSegment);                        %Finds the index of the max area
 MSC_df_f_Centroid = [fD(fAmaxI,1).Centroid];                   %Reports the centroid of the largest Array
 
 
%%  MSC Analyze df   
 MSC_df_Max = max(MSC_df(:));                     %Calculates max df/f
 MSC_normdf = MSC_df/MSC_df_Max;                %nomalizes map to maxf
 MSC_df_thresh70 = im2bw(MSC_normdf, 0.70);         %Thresholds normal map at 50%
 %figure, imshow(MSC_df_thresh50);                    %Displays binary 50% threshold image
 MSC_df_Area = bwarea(MSC_df_thresh70);            %Caculate Area of image valued over 50% max (all pixels)
 
 MSC_df_final = bwareaopen(MSC_df_thresh70,5);                %Fills holes of binary image    
 [MSC_index_df, fN] = bwlabel(MSC_df_final);                 %Indexes segmented 
 fD = regionprops(MSC_index_df, 'area', 'centroid');          %Makes an array of all the segments indexes
 fA = [fD.Area];                                                %Creates array of
 MSC_df_maxSegment = max(fA);                                 %Finds the value of the max area
 fAmaxI = find(fA==MSC_df_maxSegment);                        %Finds the index of the max area
 MSC_df_Centroid = [fD(fAmaxI,1).Centroid];                   %Reports the centroid of the largest Array

%% ANI Create df_f & df Section
    ANI_Baseline = double(imread(ANI, 20)); 
    for i = 21:30                                                    % Set up for loop for averaging baseline
        ANI_Baseline = ANI_Baseline + double(imread(ANI ,i));
    end
     ANI_Baseline = ANI_Baseline/11;                                    % Makeing Average
     ANI_BaselineF = imfilter(ANI_Baseline, GaussianFilter);            % Filters BaselineANI
 
 
    ANI_Response = double(imread(ANI, 35));
    for i = 36:65                                                      % Set up for loop for averaging response
        ANI_Response = ANI_Response + double(imread(ANI ,i));
    end
     ANI_Response = ANI_Response/31;                                    % Making Average
     ANI_ResponseF = imfilter(ANI_Response, GaussianFilter);            % Filters ResponseANI   
 
 
    ANI_df_f = (ANI_ResponseF-ANI_BaselineF)./ANI_BaselineF;                %Calculates df/f map
    ANI_df = (ANI_ResponseF-ANI_BaselineF);                                 %Calcultes df map
    ANI_df_f = ANI_df_f.* Mask;
    ANI_df = ANI_df.* Mask;
    ANI_df_f = ANI_df_f(any(ANI_df_f,2),:);                             %Removes any ALL Zero Rows
    ANI_df_f = ANI_df_f(:,any(ANI_df_f,1));                             %Removes any ALL Zero Columns
    ANI_df = ANI_df(any(ANI_df,2),:);                             %Removes any ALL Zero Rows
    ANI_df = ANI_df(:,any(ANI_df,1));                             %Removes any ALL Zero Columns
    
    
    
 %   figure, imshow(ANI_df_f, []);
 %   figure, imshow(ANI_df, []);
 
 %% ANI Analyze df_f   
 ANI_df_f_Max = max(ANI_df_f(:));                     %Calculates max df/f
 ANI_normdf_f = ANI_df_f/ANI_df_f_Max;                %nomalizes map to maxf
 ANI_df_fthresh70 = im2bw(ANI_normdf_f, 0.70);         %Thresholds normal map at 50%
 figure, imshow(ANI_df_fthresh70);                    %Displays binary 50% threshold image
 title('Anisole')
 ANI_df_f_Area = bwarea(ANI_df_fthresh70);            %Caculate Area of image valued over 50% max (all pixels)
 
 ANI_df_ffinal = bwareaopen(ANI_df_fthresh70,5);                %Fills holes of binary image    
 [ANI_index_df_f, fN] = bwlabel(ANI_df_ffinal);                 %Indexes segmented 
 fD = regionprops(ANI_index_df_f, 'area', 'centroid');          %Makes an array of all the segments indexes
 fA = [fD.Area];                                                %Creates array of
 ANI_df_f_maxSegment = max(fA);                                 %Finds the value of the max area
 fAmaxI = find(fA==ANI_df_f_maxSegment);                        %Finds the index of the max area
 ANI_df_f_Centroid = [fD(fAmaxI,1).Centroid];                   %Reports the centroid of the largest Array
 
 
%%  ANI Analyze df   
 ANI_df_Max = max(ANI_df(:));                     %Calculates max df/f
 ANI_normdf = ANI_df/ANI_df_Max;                %nomalizes map to maxf
 ANI_df_thresh70 = im2bw(ANI_normdf, 0.70);         %Thresholds normal map at 50%
 %figure, imshow(ANI_dfthresh50);                    %Displays binary 50% threshold image
 ANI_df_Area = bwarea(ANI_df_thresh70);            %Caculate Area of image valued over 50% max (all pixels)
 
 ANI_df_final = bwareaopen(ANI_df_thresh70,5);                %Fills holes of binary image    
 [ANI_index_df, fN] = bwlabel(ANI_df_final);                 %Indexes segmented 
 fD = regionprops(ANI_index_df, 'area', 'centroid');          %Makes an array of all the segments indexes
 fA = [fD.Area];                                                %Creates array of
 ANI_df_maxSegment = max(fA);                                 %Finds the value of the max area
 fAmaxI = find(fA==ANI_df_maxSegment);                        %Finds the index of the max area
 ANI_df_Centroid = [fD(fAmaxI,1).Centroid];                   %Reports the centroid of the largest Array


 %% Places all data in array or matrices
DataArray (AnimalIndex,:) = [date, AnimalIndex, Group, ROIarea, ... 
    IAA_df_f_Max, IAA_df_f_Area, IAA_df_f_maxSegment, IAA_df_f_Centroid(1), IAA_df_f_Centroid(2), ...
    IAA_df_Max, IAA_df_Area, IAA_df_maxSegment, IAA_df_Centroid(1), IAA_df_Centroid(2), ...
    MSC_df_f_Max, MSC_df_f_Area, MSC_df_f_maxSegment, MSC_df_f_Centroid(1), MSC_df_f_Centroid(2), ...
    MSC_df_Max, MSC_df_Area, MSC_df_maxSegment, MSC_df_Centroid(1), MSC_df_Centroid(2), ...
    ANI_df_f_Max, ANI_df_f_Area, ANI_df_f_maxSegment, ANI_df_f_Centroid(1), ANI_df_f_Centroid(2), ...
    ANI_df_Max, ANI_df_Area, ANI_df_maxSegment, ANI_df_Centroid(1), ANI_df_Centroid(2)]; 

ALL_df_f_IAA(:,:,AnimalIndex) = IAA_df_f;                   % Arrays of all images df_f     
ALL_df_f_MSC(:,:,AnimalIndex) = IAA_df_f;
ALL_df_f_ANI(:,:,AnimalIndex) = IAA_df_f;               

ALLnormdf_f_IAA(:,:,AnimalIndex) = IAA_normdf_f;            % Arrays of all images normalized df_f
ALLnormdf_f_MSC(:,:,AnimalIndex) = MSC_normdf_f;
ALLnormdf_f_ANI(:,:,AnimalIndex) = ANI_normdf_f;

ALL_df_IAA(:,:,AnimalIndex) = IAA_df;                   % Arrays of all images df_f     
ALL_df_MSC(:,:,AnimalIndex) = IAA_df;
ALL_df_ANI(:,:,AnimalIndex) = IAA_df;               

ALLnormdf_IAA(:,:,AnimalIndex) = IAA_normdf;            % Arrays of all images normalized df_f
ALLnormdf_MSC(:,:,AnimalIndex) = MSC_normdf;
ALLnormdf_ANI(:,:,AnimalIndex) = ANI_normdf;

close;


    %%  Create Histograms 
%Dlx_Anisole = df_Anisole(:,:,1-3 5-7);      %Creates Matrix of just Dlx
%CRHR_Anisole = df_MSC(:,:,8:13);        %Creates Matirx of just CRHR
%x = -0.1:0.001:0.6;                 %Creates array for histogram bin
%lDlx_IAA = reshape(Dlx_IAA,1,[]);   %Linearizes Matrices
%lCRHR_IAA = reshape(CRHR_IAA,1,[]);
%figure, hist (lDlx_IAA,x);
%hold on;
%hist(lCRHR_IAA,x);