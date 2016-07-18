%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: QIN Shuo
% Organization: RRR
% Date: 2016/7/15


%% Region growing method in 3d method
%input_img: 3d original data
%seed_pos: [x y z]
%mask: output, a binary image
function [mask,CC] = region_growing3d(input_img,seed_pos,vargin)
% convert subscript to linear index
index = sub2ind(size(input_img),seed_pos(1),seed_pos(2),seed_pos(3));
% pre-process
processed = seg_preprocess(input_img);
% threshold
if nargin>2
    threshold = vargin(1);
else
    threshold = input_img(index)/5;
end
BW = (processed>=threshold);

% connect area
conn = 26;
CC = bwconncomp(BW,conn);

% find
list = CC.PixelIdxList;
for i = 1: length(list)
    arr = cell2mat(list(i));
    if( find_index_in(index,arr))
        break;
    end
end

mask = zeros(size(input_img));
mask(arr) = 1;
mask = logical(mask);

end


%% Find the whether the index is in the cell
% index: form of linear index
%
function result = find_index_in(index,array)
    if find(array == index)
        result = 1;
    else
        result = 0;
    end
end



