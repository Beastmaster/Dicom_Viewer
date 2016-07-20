%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: QIN Shuo
% Organization: RRR
% Date: 2016/7/15



%% Segmentation pre-process
%
%
%
function output = seg_preprocess( input )

% adjust image
ss = size(input);
output = zeros(ss);

sigma = 2;
gaussed = imgaussfilt3(input, sigma);

se = strel('square',4);
for i = 1: ss(3)
    %output(:,:,i) = imdilate(output(:,:,i),se);
    %output(:,:,i) = imadjust(gaussed(:,:,i));
end
output = gaussed;
end