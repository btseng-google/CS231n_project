close all; clear all;

%% Input Parameters
filename = 'flare5.jpg';
black_level = 0;


%%
I = imread(filename);
I = I - black_level;
I(I < 0) = 0;


I_gray = rgb2gray(I);
[m, n] = size(I_gray);

figure, imshow(I);
center = round(ginput(1));

col_pad = round((n/2) - center(1));
row_pad = round((m/2) - center(2));

if col_pad > 0
    I = padarray(I, [0 abs(col_pad)*2], 'pre');
elseif col_pad < 0
    I = padarray(I, [0 abs(col_pad)*2], 'post');
end

if row_pad > 0
    I = padarray(I, [abs(row_pad)*2  0], 'pre');
elseif row_pad < 0
    top_pad = 0;
    I = padarray(I, [abs(row_pad)*2 0], 'post');
end
figure, imshow(I);

prompt = 'Do you want to save this image (Y/N)? ';
response = input(prompt, 's');
if response == 'Y'
    [pathstr,name,ext] = fileparts(filename);
    imwrite(I, sprintf('%s_centered.jpg',name));
end



