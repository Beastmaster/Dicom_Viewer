%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: QIN Shuo
% Organization: RRR
% Date: 2016/7/8


%%%%%%       %%%%%
%  Test Script   %
%%%%%%       %%%%%

dat = load('C:\Users\QIN\Documents\MATLAB\mask.mat');
mask = dat.mask;

dat = load('C:\Users\QIN\Documents\MATLAB\thre.mat');
%mask = dat.thre;

maska = zeros([1,size(mask)]);
maska(1,:,:,:) = mask(:,:,:);
maska = permute(maska,[2,3,1,4]);
montage(maska,[],'Indices',65:75);

return;


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
test_file = 'D:\QIN\image\Breast_Lesion_Evaluation - MR20150907112422\SUB_S8S6_1_101\IM-0008-0043.dcm';

image = dicomread(test_file);


new_img = imadjust(image,[],[]);

new_img(new_img<100)=0;

aa = zeros(100,200);
aa(1:50,1:100) = 1;
imshow(new_img,[]);


return;

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