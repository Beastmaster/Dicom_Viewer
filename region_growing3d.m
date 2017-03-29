%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: QIN Shuo
% Organization: RRR
% Date: 2017/3/29
% 
% Note: All images are in 3D

%% Region growing method in 3d method
% input_img: 3d original data
% seed_pos: [x y z]
% mask: output, a binary image, type: logical
% CC: bwconncomp result
function mask = region_growing3d(input_img,seed_pos,vargin)
% convert subscript to linear index
index = sub2ind(size(input_img),seed_pos(1),seed_pos(2),seed_pos(3));
% pre-process
processed = seg_preprocess(input_img);
% threshold
if nargin>2
    threshold = vargin(1);
else
    % extract a block and set the max value as threshold
    len = 10;
    xx = seed_pos(1)-len : seed_pos(1) + len;
    yy = seed_pos(2)-len : seed_pos(2) + len;
    zz = seed_pos(3)-len : seed_pos(3) + len;
    sub_block = input_img(xx,yy,zz);
    mm = max(sub_block(:));
    threshold = mm * 0.3;  % Similarity threshold value
end

mask = zeros(size(input_img));
pos_2b_test = [];
pos_mask = [];

pos_2b_test = [seed_pos;find_adjacent(seed_pos,input_img)];
%pos_tested = [pos_tested ;seed_pos];
last_intensity = input_img(seed_pos(1),seed_pos(2),seed_pos(3));

while ~isempty(pos_2b_test)
    update_pos_2b_test = [];
    for ii=1:length(pos_2b_test)
        temp_pos = pos_2b_test(ii,:);
        temp_itensity = input_img(temp_pos(1),temp_pos(2),temp_pos(3));
        % check point in pos_tested set
        if mask(temp_pos(1),temp_pos(2),temp_pos(3)) > 0
            continue
        end
        % add point to tested set
        mask(temp_pos(1),temp_pos(2),temp_pos(3))=1;
        % test point (in threshold)
        if (0.7*last_intensity < temp_itensity) && (1.3*last_intensity > temp_itensity)
            mask(temp_pos(1),temp_pos(2),temp_pos(3)) = 2;
            nn = find_adjacent(temp_pos,input_img);
            update_pos_2b_test = [update_pos_2b_test;nn];
        end
    end
    pos_2b_test = update_pos_2b_test;
    masked_ids = find(mask>1);
    last_intensity = mean(input_img(masked_ids));
end  % end while


mask(pos_mask) = 1;
mask = logical(mask);

end


%% Find adjacent
% xyz coordinate in row
% input px: [x,y,z]
function result = find_adjacent(px,img)
    adjacent = [
    [-1,0,0];    
    [0,0,0];    
    [1,0,0];    
    [-1,1,0];    
    [0,1,0];    
    [1,1,0];        
    [-1,-1,0];    
    [0,-1,0];    
    [1,-1,0];    
    
    [-1,0,1];    
    [0,0,1];    
    [1,0,1];    
    [-1,1,1];    
    [0,1,1];    
    [1,1,1];        
    [-1,-1,1];    
    [0,-1,1];    
    [1,-1,1]; 
    
    [-1,0,-1];    
    [0,0,-1];    
    [1,0,-1];    
    [-1,1,-1];    
    [0,1,-1];    
    [1,1,-1];        
    [-1,-1,-1];    
    [0,-1,-1];    
    [1,-1,-1]; 
    ];
    
    result_raw = bsxfun(@plus,int16(adjacent),px);
    result = [];
    for i=1:size(result_raw,2)
       xx=result_raw(1,i);
       yy=result_raw(2,i);
       zz=result_raw(3,i);
        if (xx>0)&&(xx<=size(img,1))&&(yy>0)&&(yy<=size(img,2))&&(zz>0)&&(zz<=size(img,3))
           result = [result;result_raw];
       end
    end
end


%% Find the whether the index is in the cell
% index: form of linear index
%
function result = find_index_in(array,index)
    if isempty(array)
        result = 0;
        return;
    end
    nn = sum(abs(bsxfun(@minus,int16(array),index)));
    if find(~nn)>0
        result = 1;
    else
        result = 0;
    end % end if
end % end function



