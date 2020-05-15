% Synopsis:
%
%   Apply a randomly selected flare pattern to a randomly selected image
%
% Limitations:
%   1. Flare pattern is only applied once to the image.
%   2. Flare pattern is applied on the largest over-exposed area.
%   3. Image must have a least one over-exposed area.
%   4. Only a translational shift is applied to the flare pattern to adjust
%   position on image, no rotation.


%% Initialize
close all; clear all; imtool close all;

%% Get input images

inputDirName = 'x_data';
flareDirName = 'flares';
outputDir = 'y_data';

inputDir = dir(sprintf('%s/*.jpg',inputDirName));
flareDir = dir(sprintf('%s/*6*.jpg',flareDirName));

for i = 1:length(inputDir)
    I = imread(fullfile(inputDirName,inputDir(i).name));
    I_flare = imread(fullfile(flareDirName, flareDir(randi(length(flareDir))).name));
    
    [m,n,~] = size(I);
    [m_flare,n_flare, ~] = size(I_flare);
   
    %% Use gray scale image to find over-exposed regions
%     figure, imshow(I);
    I_gray = rgb2gray(I);
    I_mask = false(size(I_gray));
    I_mask(I_gray > 245) = true;
    % figure, imshow(uint8(I_mask * 255));

    %% Find largest over-exposed region and its centroid and area
    I_blob = bwareafilt(I_mask, 1);
%     figure, imshow(I_blob);
    stats = regionprops(I_blob, 'Centroid', 'Area');

    %%  Scale flare according to area of over-exposed region
    % All flare patterns are preprocessed so brightest region has area of 100px2.
    % This appears to make the flare pattern to large.
    flareArea = 500; %100;
    flare_scale = sqrt(stats.Area / flareArea);
    % flare_scale = 1;

    m_flare = 2 * floor(m_flare * flare_scale/2); % round to multiple of 2
    n_flare = 2 * floor(n_flare * flare_scale/2); % round to multiple of 2
    I_flare_resize = imresize(I_flare, [m_flare, n_flare]);
    % figure, imshow(I_flare);
    % figure, imshow(I_flare_resize);

    %% Align flare pattern to input image

    centroid = round(stats.Centroid);
    include_left = min(n_flare/2 - 1, centroid(1) - 1);
    include_right = min(n_flare/2 - 1, n - centroid(1));

    include_top = min(m_flare/2 - 1, centroid(2) - 1);
    include_bottom = min(m_flare/2 - 1, m - centroid(2));

    r1 = centroid(2) - include_top;
    r2 = min(centroid(2) + include_bottom, m);
    c1 = centroid(1) - include_left;
    c2 = min(centroid(1) + include_right, n);

    r1_f = m_flare/2 - include_top;
    r2_f = m_flare/2 + include_bottom;
    c1_f = n_flare/2 - include_left;
    c2_f = n_flare/2 + include_right;

    % diff_rf = r2_f - r1_f;
    % diff_cf = c2_f - c1_f;
    % diff_r = r2 - r1;
    % diff_c = c2 - c1;

    I_flare_aligned = uint8(zeros(size(I)));
    I_flare_aligned(r1:r2 , c1: c2,:) = I_flare_resize(r1_f: r2_f, c1_f: c2_f,:);

    % figure, imshow(I_flare_aligned);

    I_merged = I + I_flare_aligned;
%     figure, imshow(I_merged);

	%% save image
    imwrite(I_merged, fullfile(outputDir, inputDir(i).name));
end



