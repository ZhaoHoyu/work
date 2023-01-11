clear;
clc;
F = imread('C:\Users\asus1\Desktop\IMG_20170708_090611.jpg');
F1 = rgb2gray(F);
% F1 = imnoise(F1,'gaussian',0.1);   %添加噪声
subplot(2,2,1),imshow(F1);
title('噪声图像');

FFT = fft2(F1);
myangle = angle(FFT);             %相位谱(没有进行移位的)
FS = abs(fftshift(FFT));          % 移位，使低频成分集中到图像中心，并得到幅度谱

S = log(1+abs(FS));
subplot(2,2,2),imshow(S,[]);     % 带噪声的幅度图，亮度代表着能量
title('傅里叶变换后幅度图');

% 对幅度图进行操作，去除外围的高频成分的幅度值，也就是将高频成分能量去除了
%（此处只是简单地保留了图像中心 200 X 200 的图像块）
[m,n] = size(FS);
FS(1:m/2-100,:) = 0;
FS(m/2+100:m,:) = 0;
FS(m/2-100:m/2+100,1:n/2-100) = 0;
FS(m/2-100:m/2+100,n/2+100:n) = 0;

SS = log(1+abs(FS));
subplot(2,2,3),imshow(SS,[]);     % 去除外围幅度值后的幅度图，亮度代表着能量
title('去除外围幅值后幅度图');


aaa = ifftshift(FS);          % 将处理后的幅度图反移位，恢复到正常状态
bbb = aaa.*cos(myangle) + aaa.*sin(myangle).*1i;      % 幅度值和相位值重新进行结合，得到复数
fr = abs(ifft2(bbb));               % 进行傅里叶反变换，得到处理后的时域图像
ret = im2uint8(mat2gray(fr));       
subplot(2,2,4),imshow(ret);       %去除高频成分后的图像

