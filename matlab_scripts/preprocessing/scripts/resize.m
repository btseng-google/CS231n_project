I = imread('flare6_centered.jpg');

I = imresize(I, [103, 135]);
imwrite(I, 'flare6_centered_2.jpg');