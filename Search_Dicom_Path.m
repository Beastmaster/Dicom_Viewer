%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: QIN Shuo
% Organization: RRR
% Date: 2016/7/7
% Description:
%   Load Dicom series


%% Search Dicom Path
% Search a secified path to find all dicom files
% Recursively
function dicom_list = Search_Dicom_Path(path)
if ~isdir(path)
    disp('Error: input path is not valid');
    return
end
disp(strcat('Parsing path:  ',path));

lst = dir(path);
dicom_list = {};
for i=1:length(lst)
    cur_name = lst(i);
    if ~cur_name.isdir
        nn = fullfile(path,cur_name.name);
        [~,~,ext] = fileparts(nn);
        if (strcmp(ext,'.dcm')|| strcmp(ext,'.DCM'));
            dicom_list = [dicom_list;nn];
        end
    else
        if ~strcmp(cur_name.name,'.') && ~strcmp(cur_name.name,'..')
            dicom_list = [dicom_list;Search_Dicom_Path(fullfile(path,cur_name.name))];
        end
    end
end
% remove empty cells
dicom_list(~cellfun('isempty',dicom_list)) ;
end



