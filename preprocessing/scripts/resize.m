I = imread('preprocessing/x_data/original.JPG');

I = imresize(I, [256, 256]);
imwrite(I, 'preprocessing/x_data/image9.jpg');