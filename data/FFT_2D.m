clear, close all
%% 读取图像
% x1 = imread('D:\data\LTPS_Tandem_15d5\sim\W10_sim.bmp');
x1 = imread('C:\Users\F1_001\Desktop\0.jpg');
x2 = rgb2gray(x1);
% x2 = x2 * exp(3);% 进行傅里叶变换
x = double(x2);
subplot(2,2,1), imshow(x1), title('原图')
%% 傅里叶变换
y = fft2(x);       % 二维傅里叶变换
y = fftshift(y);   % 将零频分量移到频谱中心
y_abs = abs(y);    % 对复数进行模运算 
z = log(y_abs+1);  % 映射到小范围区间
% 根据z中的像素值范围对显示进行转换，将z中的最小值显示为黑色，最大值显示为白色。
subplot(2,2,2), imshow(z, []), title('频域');
%% 低通滤波器
LPF = ones(size(y));        % 初始化低通滤波器
threshold_low = 100;         % 设置截至频率
[row, col] = size(y);       % 得到图像y的高度和宽度
for i = 1: row
    for j = 1: col
        % 计算频率
        if sqrt((i-row/2)^2+(j-col/2)^2) > threshold_low
            % 将低通滤波器中高于截止频率的频率变为0
            LPF(i,j) = 0;
        end
    end
end
y_LPF = y.*LPF;             % 低通滤波
y_LPF = ifftshift(y_LPF);   % 逆零频平移
x_LPF = ifft2(y_LPF);       % 傅里叶逆变换
x_LPF = uint8(real(x_LPF)); % 转换成实数，并将double转成uint8
% subplot(2,2,3), imshow(x_LPF), title('低通滤波')
y_L = fftshift(y_LPF);   % 将零频分量移到频谱中心
y_L_abs = abs(y_L);    % 对复数进行模运算 
y_LPF_L = log(y_L_abs+1);  % 映射到小范围区间
subplot(2,2,3), imshow(y_LPF_L, []), title('频域');
%% 高通滤波器
HPF = ones(size(y));        % 初始化低通滤波器
threshold_high = 100;         % 设置截至频率
[row, col] = size(y);       % 得到图像y的高度和宽度
for i = 1: row
    for j = 1: col
        % 计算频率
        if sqrt((i-row/2)^2+(j-col/2)^2) < threshold_high
            % 将低通滤波器中高于截止频率的频率变为0
            HPF(i,j) = 0;
        end
    end
end
y_HPF = y.*HPF;
y_HPF = ifftshift(y_HPF);
x_HPF = ifft2(y_HPF);
x_HPF = uint8(real(x_HPF));
% subplot(2,2,4), imshow(x_HPF), title('高通滤波')
y_H = fftshift(y_HPF);   % 将零频分量移到频谱中心
y_H_abs = abs(y_H);    % 对复数进行模运算 
y_HPF_H = log(y_H_abs+1);  % 映射到小范围区间
subplot(2,2,4), imshow(y_HPF_H, []), title('频域');


%% 区间FFT滤波器
IPF = ones(size(y));        % 初始化低通滤波器
threshold_h = 60;         % 设置截至频率
threshold_l = 120; 
[row, col] = size(y);       % 得到图像y的高度和宽度
for i = 1: row
    for j = 1: col
        % 计算频率
        if sqrt((i-row/2)^2+(j-col/2)^2) < threshold_h
            % 将低通滤波器中高于截止频率的频率变为0
            IPF(i,j) = 0;
        elseif sqrt((i-row/2)^2+(j-col/2)^2) > threshold_l
            IPF(i,j) = 0;
        end
    end
end
y_IPF = y.*IPF;
y_IPF = ifftshift(y_IPF);
x_IPF = ifft2(y_IPF);
x_IPF = uint8(real(x_IPF));
% subplot(2,2,4), imshow(x_IPF), title('区间滤波')
y_I = fftshift(y_IPF);   % 将零频分量移到频谱中心
y_I_abs = abs(y_I);    % 对复数进行模运算 
y_IPF_I = log(y_I_abs+1);  % 映射到小范围区间
subplot(2,2,4), imshow(y_IPF_I, []), title('频域');

%% 理想FFT
% s=fftshift(fft2(I));%傅里叶变换，直流分量搬移到频谱中心
% q=uint8(log(abs(s)+1));
% subplot(222), imshow(log(abs(s)+1),[]); 
% title('图像傅里叶变换取对数所得频谱');
% [a,b]=size(y);
% h=zeros(a,b);%滤波器函数
% res=zeros(a,b);%保存结果
% a0=round(a/2);
% b0=round(b/2);
% d=300;
% for i=1:a 
%     for j=1:b 
%         distance=sqrt((i-a0)^2+(j-b0)^2);
%         if distance<d
%             h(i,j)=1;
%         else
%             h(i,j)=0;
%         end
%     end
% end
% res=y.*h;
% res=real(ifft2(ifftshift(res)));
% subplot(223),imshow(res);
% title('理想高通滤波所得图像'); 
% subplot(224),imshow(h);
% title('理想高通滤波器图像'); 
