function [wmarked_attack] = attack(wmarked)

% % JPEG QF 20-100
imwrite(uint8(wmarked), 'jpegImageAttacked.jpg','quality',10);
wmarked_attack = imread('jpegImageAttacked.jpg');

% %% AWGN 10-40 (0.005/0.01/0.1)
% wmarked_attack = imnoise(uint8(wmarked), 'gaussian', 0,0.027); 
% 
% %% Gaussian Filter (gf) 3x3 5x5 7x7
% h = fspecial('gaussian',[7 7],1.1); %sigma=1.1
% wmarked_attack = imfilter(uint8(wmarked),h,'replicate');
% 
% %% Median Filter
% wmarked_attack = medfilt2(uint8(wmarked),[7 7]); % 3x3 5x5 7x7
% 
% %% Wiener Filter
% wmarked_attack = wiener2(uint8(wmarked),[k k]); % 33 5x5 7x7
% 
% %% Average Filter
% h = fspecial('average',[7 7]);
% wmarked_attack = imfilter(uint8(wmarked),h,'replicate');
% 
% %% Salt and pepper noise (0.005/0.05/0.1)
% wmarked_attack = imnoise(uint8(wmarked),'salt & pepper',0.027); 
% 
% %% Speckle noise (0.005/0.05/0.1)
% wmarked_attack = imnoise(uint8(wmarked),'speckle',var); 
% 
% %% Histogram Equalization
% wmarked_attack = histeq(uint8(wmarked));
end

