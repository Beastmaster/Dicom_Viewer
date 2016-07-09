%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: QIN Shuo
% Organization: RRR
% Date: 2016/7/8


%%%%%%       %%%%%
%  Test Script   %
%%%%%%       %%%%%

clc;
clear all
close all;

Load_Dicom_Series('D:\QIN\image\breast_test','PatientName','SeriesDescription','AcquisitionTime')

dicom_series = load('dicom_series.mat');
dicom_series = dicom_series.dicom_series;

info_struct = load('info_struct.mat');
info_struct = info_struct.info_struct;

aa = sort_tag2(info_struct);

bb = 0;


