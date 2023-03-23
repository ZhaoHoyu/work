clear;clc;
%ѡ����ɫ
color='B';
colorx='RGB';
%����31�ҽ�ͼƬ
pic=csvread([color,'31.csv']);
%����gamma�������ҽ����ѹ��ϵ
gray=0:255;
% V=5:-(5-2.5)/255:2.5;%��ѹֵ���˴�Ϊģ��
V=importdata('V.mat');
V=V(:,colorx==color)';
Lvx=(gray./255).^2.2;%���ȱ���ϵ��
Lv_31=(31./255).^2.2;
%����OFFSET
[h,w]=size(pic);
picmean=mean2(pic(round(h/2)-199:round(h/2)+200,round(w/2)-199:round(w/2)+200));%����ƽ������
%
pic=pic./picmean*Lv_31;%ת��Ϊ���ȱ���ϵ��
%
pic(pic>1)=1;%��Ϊ�ǲ�ֵ�����ܸ������ֵ������������ϻ�������ʽʹ��ɸ������ֵ
%
Vx=interp1(Lvx,V,pic);%��ֵ�����ȶ�Ӧ�ĵ�ѹ
Vx0=interp1(Lvx,V,Lv_31);%��ֵ�����ȶ�Ӧ�ĵ�ѹ(����)
offsetV=Vx-Vx0;
csvwrite(['offset',color,'.csv'],offsetV);

%���������ҽ�ģ������
gray0=[10,63];
for i=1:length(gray0)
    Lvx_0=(gray0(i)./255).^2.2;%�������ȱ���ϵ��
    %
    Lvx_0(Lvx_0>1)=1;
    %
    Vx_0=interp1(Lvx,V,Lvx_0);%���۵�ѹ
    Vx_cal=Vx_0+offsetV;%����ʵ�ʵ�ѹ
    %
    Vx_cal(Vx_cal>max(V))=max(V);%����ֵ����nan
    Vx_cal(Vx_cal>max(V))=max(V);
    %
    Lvx_cal0=interp1(V,Lvx,Vx_cal);%��������ȱ���ϵ��
    Lvx_cal=Lvx_cal0*picmean/Lv_31;%ת��Ϊʵ������
    csvwrite([color,num2str(gray0(i)),'_ģ��.csv'],Lvx_cal);
end

%% ����ģ��ͼ_ģ������
%�ҽ����ѹ��ϵ
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
%         pic0=csvread([color0(j),num2str(gray0(i)),'_ģ��.csv']);
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

