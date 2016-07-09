%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: QIN Shuo
% Organization: RRR
% Date: 2016/7/9


%% Alternative version of sort tag function
%Input and output are same as sort_tag()
%Use buffer file
%Use containers.Map structure
function out = sort_tag2( infos )
    
    % find all field and integrate all tag except filename
    fields = fieldnames(infos);
    fields_len = length(fields);
    if fields_len<2
        disp('No enough tag.. \nExiting');
        return
    end
    
    % create a map, key is 
    mapObj = containers.Map();
    
    % loop begin to fullfill the map
    for i = 1: length(infos)
        info_temp = infos(i);
        key = '';
        for j = 2:fields_len
            key = strcat(key,info_temp.(char(fields(j))));
        end
        
        % if key is not exist, then add
        if ~isKey(mapObj,key)
            mapObj(key) = cellstr(info_temp.Filename);
        % else, append the filename to that key
        else
            temp = mapObj(key);
            temp = [temp;cellstr(info_temp.Filename)];
            mapObj(key) = temp;
        end
    end
    
    % Read data
    out = [];
    kk = keys(mapObj);
    for i = 1: length(kk)
        vv = mapObj(char(kk(i)));
        % read data set
        [data,info ]= read_series(vv);
        ss = struct('tag',info,'data',data);
        out = [out;ss];
    end
end


%% Read series
%Input:
%   file_list: file name list (cell component)
%Output:
%   X: dicom data (3d)
%   
function [X,varargout]= read_series(file_list)
    % Read dicom
    info = dicominfo(char(file_list(1)));
    nRows = info.Rows;
    nCols = info.Columns;
    nPlanes = length(file_list);
    X = repmat(int16(0), [nRows, nCols, nPlanes]);
    for j  = 1:nPlanes
        fname = char(file_list(j));
        X(:,:,j) = dicomread(fname);
    end
    
    if nargout>1
        varargout{1} = info;
    end
end





