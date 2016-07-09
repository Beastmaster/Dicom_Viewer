%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: QIN Shuo
% Organization: RRR
% Date: 2016/7/8


%%%%%%       %%%%%
%  Test Script   %
%%%%%%       %%%%%

clc;
clear all;
close all;

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