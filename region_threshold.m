%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: QIN Shuo
% Organization: RRR
% Date: 2016/7/15
%
% Basic threshold

%% Region growing method in 3d method
% input_img: 3d original data
% seed_pos: [x y z]
% mask: output, a binary image, type: logical
% CC: bwconncomp result
function [mask,CC,thre] = region_threshold(input_img,seed_pos,vargin)
% convert subscript to linear index
index = sub2ind(size(input_img),seed_pos(1),seed_pos(2),seed_pos(3));
% pre-process
processed = seg_preprocess(input_img);
% threshold
if nargin>2
    threshold = vargin(1);
else
    % extract a block and set the max value as threshold
    length = 10;
    xx = seed_pos(1)-length : seed_pos(1) + length;
    yy = seed_pos(2)-length : seed_pos(2) + length;
    zz = seed_pos(3)-length : seed_pos(3) + length;
    sub_block = input_img(xx,yy,zz);
    mm = max(sub_block(:));
    threshold = mm * 0.3;
end
BW = (processed>=threshold);
thre = BW;

% connect area
conn = 26;%18
CC = bwconncomp(BW,conn);

% find
list = CC.PixelIdxList;
[~,len] = size(list);
for i = 1: len
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



