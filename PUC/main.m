clear;clc;
%选择颜色
color='B';
colorx='RGB';
%加载31灰阶图片
pic=csvread([color,'31.csv']);
%输入gamma参数，灰阶与电压关系
gray=0:255;
% V=5:-(5-2.5)/255:2.5;%电压值，此处为模拟
V=importdata('V.mat');
V=V(:,colorx==color)';
Lvx=(gray./255).^2.2;%亮度比例系数
Lv_31=(31./255).^2.2;
%计算OFFSET
[h,w]=size(pic);
picmean=mean2(pic(round(h/2)-199:round(h/2)+200,round(w/2)-199:round(w/2)+200));%中心平均亮度
%
pic=pic./picmean*Lv_31;%转化为亮度比例系数
%
pic(pic>1)=1;%因为是插值，不能高于最高值，后续考虑拟合或其他方式使其可高于最高值
%
Vx=interp1(Lvx,V,pic);%插值出亮度对应的电压
Vx0=interp1(Lvx,V,Lv_31);%插值出亮度对应的电压(中心)
offsetV=Vx-Vx0;
csvwrite(['offset',color,'.csv'],offsetV);

%计算其他灰阶模拟亮度
gray0=[10,63];
for i=1:length(gray0)
    Lvx_0=(gray0(i)./255).^2.2;%理论亮度比例系数
    %
    Lvx_0(Lvx_0>1)=1;
    %
    Vx_0=interp1(Lvx,V,Lvx_0);%理论电压
    Vx_cal=Vx_0+offsetV;%估算实际电压
    %
    Vx_cal(Vx_cal>max(V))=max(V);%防插值出现nan
    Vx_cal(Vx_cal>max(V))=max(V);
    %
    Lvx_cal0=interp1(V,Lvx,Vx_cal);%估测的亮度比例系数
    Lvx_cal=Lvx_cal0*picmean/Lv_31;%转化为实际亮度
    csvwrite([color,num2str(gray0(i)),'_模拟.csv'],Lvx_cal);
end

%% 生成模拟图_模拟数据
%灰阶与电压关系
Lv_V=((0:255)/255).^2.2;
V=importdata('V.mat');
Lv_V(2,:)=V(:,colorx==color)';
%
if ~exist('pattern\')
    mkdir('pattern\');
end 
color0='RGB';      
gray0=[10,31,63];
for i=1:length(gray0)
    patternw=[];
    for j=1:length(color0)
    Lv_V(2,:)=V(:,colorx==color)';
%         pic0=csvread([color0(j),num2str(gray0(i)),'_模拟.csv']);
        pic0=csvread([color0(j),'31.csv']);
        gray=gray0(i);
        color=color0(j);
        offsetx=csvread(['offset',color,'.csv']);
        pattern = makepattern(pic0,gray,color,offsetx,Lv_V);
        imwrite(pattern,['pattern\',color,num2str(gray),'_cal.bmp']);
        patternw(:,:,j)=pattern(:,:,j);
    end
    imwrite(uint8(patternw),['pattern\W',num2str(gray),'_cal.bmp']);
end

