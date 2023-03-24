clear;clc;
%����gray��V֮���ϵ
Vdata=importdata('Vh.mat');
band0=1:25;
Lvmax=[2175,1600,1200,650,300,200,100,90,60,30,15,10,4,200,100,60,30,15,10,4,2,650,410,170,100];
V=zeros(256,4,length(band0));
% V2=[];
for i=1:length(band0)
    V(:,:,i)=Vdata(Vdata(:,1)==band0(i),2:5);
%     V2(:,(i-1)*4+1:i*4)=Vdata(Vdata(:,1)==band(i),2:5);
end
%����31�ҽ�ͼƬ
colorx='RGB';
gray=31;
band=5;
pic=csvread([colorx(1),num2str(gray),'.csv']);
pic(:,:,2)=csvread([colorx(2),num2str(gray),'.csv']);
pic(:,:,3)=csvread([colorx(3),num2str(gray),'.csv']);
[h,w,~]=size(pic);
hh=round(h/2);
wh=round(w/2);
bandx=find(band0==band);
%RGB���ȱ���
dR=0.2442;
dG=0.685;
dB=0.071;
%����B�ҽ����ѹ��Ӧ׼ȷ������R��G�����ȱ�������Ķ�Ӧ��ѹ�Ļҽ�
picmean=mean2(pic(hh-199:hh+200,wh-199:wh+200,1));
picmean(2)=mean2(pic(hh-199:hh+200,wh-199:wh+200,2));
picmean(3)=mean2(pic(hh-199:hh+200,wh-199:wh+200,3));
grayRGB=[gray,gray,gray];
grayRGB(1)=(picmean(3)/dB*dR/picmean(1))^(1/2.2)*gray;
grayRGB(2)=(picmean(3)/dB*dG/picmean(2))^(1/2.2)*gray;
%
gray0=0:255;
Lv0=(gray0./255).^2.2;%���ȱ���ϵ��
Lv_a=(grayRGB./255).^2.2;
%����OFFSET
Lvpic=pic(:,:,1)./picmean(1)*Lv_a(1);%ת��Ϊ���ȱ���ϵ��
Lvpic(:,:,2)=pic(:,:,2)./picmean(2)*Lv_a(2);%ת��Ϊ���ȱ���ϵ��
Lvpic(:,:,3)=pic(:,:,3)./picmean(3)*Lv_a(3);%ת��Ϊ���ȱ���ϵ��
Lvpic(Lvpic>1)=1;%��Ϊ�ǲ�ֵ�����ܸ������ֵ������������ϻ�������ʽʹ��ɸ������ֵ
Vx=interp1(Lv0,V(:,2,bandx),Lvpic(:,:,1));%��ֵ�����ȶ�Ӧ�ĵ�ѹ
Vx(:,:,2)=interp1(Lv0,V(:,3,bandx),Lvpic(:,:,2));%��ֵ�����ȶ�Ӧ�ĵ�ѹ
Vx(:,:,3)=interp1(Lv0,V(:,4,bandx),Lvpic(:,:,3));%��ֵ�����ȶ�Ӧ�ĵ�ѹ
Vx0=interp1(Lv0,V(:,2,bandx),Lv_a(1))*ones(h,w);%��ֵ�����ȶ�Ӧ�ĵ�ѹ(����)
Vx0(:,:,2)=interp1(Lv0,V(:,3,bandx),Lv_a(2))*ones(h,w);%��ֵ�����ȶ�Ӧ�ĵ�ѹ(����)
Vx0(:,:,3)=interp1(Lv0,V(:,4,bandx),Lv_a(3))*ones(h,w);%��ֵ�����ȶ�Ӧ�ĵ�ѹ(����)
offsetV=Vx-Vx0;
save('offset.mat','offsetV');

%% ����ģ��ͼ_ģ������
%�ҽ����ѹ��ϵ
gray0=0:255;
Lv0=(gray0./255).^2.2;%���ȱ���ϵ��
Vdata=importdata('Vh.mat');
band0=1:25;
Lvmax=[2175,1600,1200,650,300,200,100,90,60,30,15,10,4,200,100,60,30,15,10,4,2,650,410,170,100];
V=zeros(256,4,length(band0));
for i=1:length(band0)
    V(:,:,i)=Vdata(Vdata(:,1)==band0(i),2:5);
end
offsetV=importdata('offset.mat');
%
if ~exist('pattern\')
    mkdir('pattern\');
end 
%
colorx='RGB';      
gray=[ 10, 23, 31, 63, 10, 31,240,128,128,128,31];
band=[  5,  7,  5,  5,  4,  4,  5,  5, 12,  7,12];
for i=1:length(gray)
    grayx=gray(i);
    bandx=find(band0==band(i));
    patternW = makepattern2(offsetV,grayx,bandx,V);
    imwrite(patternW,['pattern\',num2str(Lvmax(bandx)),'nits_W',num2str(grayx),'.bmp']);
end


