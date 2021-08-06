%% Load and Selects Files
foldername='filepath'; %User Input of the file directory
%date = 150605;                      %Date/Animal ID (User input)    
%AnimalIndex = 5;                    %Index for the array for all data (User Input - Change for each sample)
%Group = 1;                           %User defined, 1=Dlx5/6, 2=CRHR, 3=Dlx6weeks

ContIAA = [foldername, 'FS_IAA Ctrl.tif'];
% Sox9IAA = [foldername, 'FS_IAA Sox9.tif'];
ContMSC = [foldername, 'FS_MSC Ctrl.tif'];
% Sox9MSC = [foldername, 'FS_MSC Sox9.tif'];
ContAnisole = [foldername,'FS_Anisole Ctrl.tif'];           %Grabs Anisole
% Sox9Anisole = [foldername,'FS_Anisole Sox9.tif'];   %Grabs Anisole dnSNARE
ContAcetophenone = [foldername,'FS_Acetophenone Ctrl.tif']; %Grabs Acetophenone
% Sox9Acetophenone = [foldername, 'FS_Acetophenone Sox9.tif']; %Grabs Acetophenone dnSNARE
ContPentanol = [foldername, 'FS_Pentanol Ctrl.tif'];
% Sox9Pentanol = [foldername, 'FS_Pentanol Sox9.tif'];
ContHeptanol = [foldername, 'FS_Heptanol Ctrl.tif'];
% Sox9Heptanol = [foldername, 'FS_Heptanol Sox9.tif'];
ContCarvone = [foldername, 'FS_Carvone Ctrl.tif'];
% Sox9Carvone = [foldername, 'FS_Carvone Sox9.tif'];

%% Converts files to matrices (0 to 255)

ContIAA_im = im2double(imcomplement(imread(ContIAA)));
% Sox9IAA_im = im2double(imcomplement(imread(Sox9IAA)));
ContMSC_im = im2double(imcomplement(imread(ContMSC)));
% Sox9MSC_im = im2double(imcomplement(imread(Sox9MSC)));
ContAnisole_im = im2double(imcomplement(imread(ContAnisole)));
% Sox9Anisole_im = im2double(imcomplement(imread(Sox9Anisole)));
ContAcetophenone_im = im2double(imcomplement(imread(ContAcetophenone)));
% Sox9Acetophenone_im = im2double(imcomplement(imread(Sox9Acetophenone)));
ContPentanol_im = im2double(imcomplement(imread(ContPentanol)));
% Sox9Pentanol_im = im2double(imcomplement(imread(Sox9Pentanol)));
ContHeptanol_im = im2double(imcomplement(imread(ContHeptanol)));
% Sox9Heptanol_im = im2double(imcomplement(imread(Sox9Heptanol)));
ContCarvone_im = im2double(imcomplement(imread(ContCarvone)));
% Sox9Carvone_im = im2double(imcomplement(imread(Sox9Carvone)));

%% Convert thresholded images to logical (0 and 1)

ContIAA_bw = im2bw(ContIAA_im);
% Sox9IAA_bw = im2bw(Sox9IAA_im);
ContMSC_bw = im2bw(ContMSC_im);
% Sox9MSC_bw = im2bw(Sox9MSC_im);
ContAnisole_bw = im2bw(ContAnisole_im);
% Sox9Anisole_bw = im2bw(Sox9Anisole_im);
ContAcetophenone_bw = im2bw(ContAcetophenone_im);
% Sox9Acetophenone_bw = im2bw(Sox9Acetophenone_im);
ContPentanol_bw = im2bw(ContPentanol_im);
% Sox9Pentanol_bw = im2bw(Sox9Pentanol_im);
ContHeptanol_bw = im2bw(ContHeptanol_im);
% Sox9Heptanol_bw = im2bw(Sox9Heptanol_im);
ContCarvone_bw = im2bw(ContCarvone_im);
% Sox9Carvone_bw = im2bw(Sox9Carvone_im);

%% Sums the pixels activated of each image (in pixels)

ContIAA_pixels = sum(sum(ContIAA_bw));
% Sox9IAA_pixels = sum(sum(Sox9IAA_bw));
ContMSC_pixels = sum(sum(ContMSC_bw));
% Sox9MSC_pixels = sum(sum(Sox9MSC_bw));
ContAnisole_pixels = sum(sum(ContAnisole_bw));
% Sox9Anisole_pixels = sum(sum(Sox9Anisole_bw));
ContAcetophenone_pixels = sum(sum(ContAcetophenone_bw));
% Sox9Acetophenone_pixels = sum(sum(Sox9Acetophenone_bw));
ContPentanol_pixels = sum(sum(ContPentanol_bw));
% Sox9Pentanol_pixels = sum(sum(Sox9Pentanol_bw));
ContHeptanol_pixels = sum(sum(ContHeptanol_bw));
% Sox9Heptanol_pixels = sum(sum(Sox9Heptanol_bw));
ContCarvone_pixels = sum(sum(ContCarvone_bw));
% Sox9Carvone_pixels = sum(sum(Sox9Carvone_bw));

% Converts number of activated pixels to area (mm2)

ContIAA_area = (ContIAA_pixels/160544)*4.19280536;
% Sox9IAA_area = (Sox9IAA_pixels/160544)*4.19280536;
ContMSC_area = (ContMSC_pixels/160544)*4.19280536;
% Sox9MSC_area = (Sox9MSC_pixels/160544)*4.19280536;
ContAnisole_area = (ContAnisole_pixels/160544)*4.19280536;
% Sox9Anisole_area = (Sox9Anisole_pixels/160544)*4.19280536;
ContAcetophenone_area = (ContAcetophenone_pixels/160544)*4.19280536;
% Sox9Acetophenone_area = (Sox9Acetophenone_pixels/160544)*4.19280536;
ContPentanol_area = (ContPentanol_pixels/160544)*4.19280536;
% Sox9Pentanol_area = (Sox9Pentanol_pixels/160544)*4.19280536;
ContHeptanol_area = (ContHeptanol_pixels/160544)*4.19280536;
% Sox9Heptanol_area = (Sox9Heptanol_pixels/160544)*4.19280536;
ContCarvone_area = (ContCarvone_pixels/160544)*4.19280536;
% Sox9Carvone_area = (Sox9Carvone_pixels/160544)*4.19280536;

Areas = [ContIAA_area; ContMSC_area; ContAnisole_area; ContAcetophenone_area; ContPentanol_area; ContHeptanol_area; ContCarvone_area]
% Areas = [Sox9IAA_area; Sox9MSC_area; Sox9Anisole_area; Sox9Acetophenone_area; Sox9Pentanol_area; Sox9Heptanol_area; Sox9Carvone_area]