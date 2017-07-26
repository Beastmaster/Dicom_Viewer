%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: QIN Shuo
% Organization: RRR
% Date: 2016/7/8


%%%%%%       %%%%%
%  Test Script   %
%%%%%%       %%%%%

img = imread('\\192.168.1.139\homes\WorkPlace\eos_keras\unet\tmp\res\12-14-15_14h55m31_Y7427156_face.png');

se = strel('rectangle',[10,20]);
im = imopen(img,se);
im = imopen(im,se);

imshow(im,[]);

return;

%% test median filter
clear;
close all;

img = load_nii('03.nii');
img3 = img.img;

imgh = load_nii('06.nii');
img6 = imgh.img;

sub = img6-img3;

imgh.img = sub;
save_nii(imgh,'sub.nii');



return ;

img = dicomread('E:\BaiduNetdiskDownload\breast\content\Zhang_Yan\Breast_Lesion_Evaluation - MR20150907112422\SUB_S8S6_1_101\IM-0008-0038.dcm');

% shift left
img_left = uint16(zeros(size(img)));
l_shift = 2;
img_left(1:size(img,1)-l_shift,:) = img(l_shift+1:size(img,1),:);
img = abs(img-img_left);

%img = img>80;

imshow(img,[]);
return



%% test mask function
dat = load('C:\Users\QIN\Documents\MATLAB\mask.mat');
mask = dat.mask;

dat = load('C:\Users\QIN\Documents\MATLAB\thre.mat');
%mask = dat.thre;

maska = zeros([1,size(mask)]);
maska(1,:,:,:) = mask(:,:,:);
maska = permute(maska,[2,3,1,4]);
montage(maska,[],'Indices',65:75);

return;


%% test mask function
dicom_series = load('dicom_series.mat');
dicom_series = dicom_series.dicom_series;
data = dicom_series(1).data;
[mask,CC] = region_growing3d(data,[161 294 40]);

map = colormap(jet(256));
maska = zeros([1,size(mask)]);
maska(1,:,:,:) = mask(:,:,:);
maska = permute(maska,[2,3,1,4]);
montage(maska,[],'Indices',35:50);

save('mask.mat','mask');
return


%% test imadjust preprocess
test_file = 'D:\QIN\image\Breast_Lesion_Evaluation - MR20150907112422\SUB_S8S6_1_101\IM-0008-0043.dcm';

image = dicomread(test_file);


new_img = imadjust(image,[],[]);

new_img(new_img<100)=0;

aa = zeros(100,200);
aa(1:50,1:100) = 1;
imshow(new_img,[]);

return;

%% test alpha opacity
aa = (data>300);
save('aa.mat','aa');
slice = data(:,:,43);

figure
imshow(data(:,:,43),[]);
hold on;
aa = aa(:,:,43);
    aa = ind2rgb(aa,[0 0 0;1 0 1]);
    himage = imshow(aa);
    himage.AlphaData = 0.5;
return





%% test load dicom series function
%Load_Dicom_Series('D:\QIN\image\breast_test','PatientName','SeriesDescription','AcquisitionTime')
dicom_series = load('dicom_series.mat');
dicom_series = dicom_series.dicom_series;
data = dicom_series(1).data;
ddObj = reslice_data(data);
a = '';
i = 1;
while(~strcmp(a,'q'))
    prompt = 'input: ';
    a = input(prompt,'s');
    
    oo = ddObj.reslice('x',i);
    imshow(oo,[])
    
    i = i+1;
    if i>380
        break;
    end
    disp(strcat('i is : ',num2str(i)));
end