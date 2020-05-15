close all; clear all;
I_filter_rgb = imread('flare5.jpg');
% I = imresize(I,[600, 450]);
figure, imshow(I_filter_rgb);

% % I_filter = single(I_filter / 255);
% I_filter_rgb = uint8(zeros(600, 450, 3));
% for i = 1:3
%     I_filter_rgb(:,:,i) = I_filter;
% end


I  = imread('original.jpg');
I = imresize(I,[600, 450]);
figure, imshow(I);

% I_add = max(I,I_filter_rgb);
I_add = I + I_filter_rgb;
figure, imshow(I_add);

I_reference  = imread('added_lens_flare.jpeg');
figure, imshow(I_reference);