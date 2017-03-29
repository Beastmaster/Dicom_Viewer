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
output = gaussed;
se = strel('square',4);
for i = 1: ss(3)
    %output(:,:,i) = imdilate(output(:,:,i),se);
    %output(:,:,i) = de_noise(output(:,:,i));
end

end


%% Denoising
% Main method: median filter
%
function img_out = de_noise(img_in)
%img_out = medfilt2(img_in);
[img_out,~] = wiener2(img_in,[10,10]);
end
