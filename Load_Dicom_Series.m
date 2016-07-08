%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: QIN Shuo
% Organization: RRR
% Date: 2016/7/8


%% Load Dicom Series
% Description:
%   Load Dicom series
% Input: 
%       dicom_path: a path conatining dicom data
%       sort_option: data construction restriction method, default by
%           specified dicom tag description. Level by their order
%               'PatientName','SeriesDescription','AcquisitionTime'
% Output: 
%       dicom_series: a series of dicom data
%       status:       0 if no data or fail; 1 read data successfully
% Call: Search_Dicom_Path.m
% Example: Load_Dicom_Series('D:\QIN\image\','PatientName','SeriesDescription','AcquisitionTime')
function dicom_series = Load_Dicom_Series( dicom_path , varargin)
clc;
warning('off','all');

    if length(varargin)<1
       disp('Error: Lack restriction condition..');
       disp('Exiting ... ');
       return;
    end

    %%%% Search the folder to get all dicom file name
    dicom_list = Search_Dicom_Path(dicom_path);
    disp('All dicom files are found...');
    
    %%%% Extract specified dicom tags
    info_struct = [];% new a empty structure
    for i = 1:length(dicom_list)
        info = dicominfo(char(dicom_list(i)));
        temp_struct = [];
        temp_struct = setfield(temp_struct,'Filename',info.Filename);
        for j=1:length(varargin)
            % struct field
            field = char(varargin(j));
            % struct field value
            if strcmp(varargin(j),'PatientName')
               value = strcat(info.PatientName.FamilyName,info.PatientName.GivenName);
            else
               value = info.(char(varargin(j)));
            end
            temp_struct = setfield(temp_struct,field,value);
        end
        info_struct = [info_struct temp_struct];
    end
    disp('All dicom tag informations are extracted....');
    
    %%%% Sort tag
    xxx = sort_tag(info_struct);
    
end


%% Sort single dicom file by a specified tag
%
%Input
%   infos: An array of dicom infos (dicominfo)
%   tag: Dicom tag(dicominfo), example:'PatientName','SeriesDescription','AcquisitionTime'
%Ouput:
%   Cell of cells with different length cell
%
%
%   Output:   {'tag_value'; info_array}
%
function out = sort_tag( infos )
    out = [];
    % Search the info struct to find 
    field_s = fieldnames(infos);
    
    struct_s = [];
    for i=1:length(infos)
        nn='';
        for j=2:length(field_s)
            nn = strcat(nn,infos(i).(char(field_s(j))));
        end
        ss = struct(char(field_s(1)),infos(i).Filename,'Coo',nn);
        struct_s = [struct_s;ss];
    end
    
    % sort struct array
    xx = char(extractfield(struct_s,'Coo'));
    [~, order] = sortrows(xx);
    % Save the sorted output
    struct_s = struct_s(order);
    
    % read
    init = struct_s(1).Coo;
    init_idx = 1;
    for i = 1:length(struct_s)
        temp = struct_s(i).Coo;
        if ~strcmp(temp,init)
            temp_idx = i-1;
            % Read dicom
            info = dicominfo(struct_s(init_idx).Filename);
            nRows = info.Rows;
            nCols = info.Columns;
            nPlanes = temp_idx-init_idx+1;
            X = repmat(int16(0), [nRows, nCols, nPlanes]);
            for j = init_idx:temp_idx
                fname = struct_s(init_idx).Filename;
                X(:,:,j) = dicomread(fname);
            end
            frame_name = init;
            ss = struct('Name',frame_name,'TimeStamp','To be Continued','Image',X);
            out = [out;ss];
            % Change init index
            init = temp;
            init_idx = i ;
        end
    end
    % Read last block
    temp_idx = i;
    % Read dicom
    info = dicominfo(struct_s(init_idx).Filename);
    nRows = info.Rows;
    nCols = info.Columns;
    nPlanes = temp_idx-init_idx+1;
    X = repmat(int16(0), [nRows, nCols, nPlanes]);
    for j = init_idx:temp_idx 
        fname = struct_s(init_idx).Filename;
        X(:,:,j) = dicomread(fname);
    end
    frame_name = init;
    ss = struct('Name',frame_name,'TimeStamp','To be Continued','Image',X);
    out = [out;ss];
    
end



