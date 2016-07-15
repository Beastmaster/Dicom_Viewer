%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: QIN Shuo
% Organization: RRR
% Date: 2016/7/8


%%%%%%       %%%%%
%  Test Script   %
%%%%%%       %%%%%

clc;
clear;
close all;



dicom_series = load('dicom_series.mat');
dicom_series = dicom_series.dicom_series;
data = dicom_series(1).data;


test_file = 'D:\QIN\image\Breast_Lesion_Evaluation - MR20150907112422\SUB_S8S6_1_101\IM-0008-0043.dcm';

image = dicomread(test_file);


new_img = imadjust(image);

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