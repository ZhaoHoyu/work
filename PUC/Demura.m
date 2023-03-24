clear;clc;


%std gamma curve
gray_range=0:1:255;
gray_ideal_coefficient=(gray_range./255).^2.2;  

%load gamma data
Vdata_ini=importdata('Vh.mat'); 
bandlist=1:13;
DBV=[2175,1600,1200,650,300,200,100,90,60,30,15,10,4];
Vdata=zeros(256,4,length(bandlist));
for i=1:length(bandlist)
    Vdata(:,:,i)=Vdata_ini(Vdata_ini(:,1)==bandlist(i),2:5);
end

%load capture luminance data
colorx='RGB';
gray=31;
band=5;
I=csvread([colorx(1),num2str(gray),'.csv']);
I(:,:,2)=csvread([colorx(2),num2str(gray),'.csv']);
I(:,:,3)=csvread([colorx(3),num2str(gray),'.csv']);
Vdata_capture_R = Vdata(:,2,band);
Vdata_capture_G = Vdata(:,2,band);
Vdata_capture_B = Vdata(:,2,band);
Vdata_capture = Vdata_capture_R(gray+1);
Vdata_capture(2) = Vdata_capture_G(gray+1);
Vdata_capture(3) = Vdata_capture_B(gray+1);

%calculate center luminance
[r,c,~]=size(I);
raw=round(r/2);
col=round(c/2);
lum_center=mean2(I(raw-m:raw+m,col-m:col+m,1));
lum_center(2)=mean2(I(raw-m:raw+m,col-m:col+m,2));
lum_center(3)=mean2(I(raw-m:raw+m,col-m:col+m,3));

%calculate offset
V_interplate=interp1(gray_ideal_coefficient,Vdata(:,2,bandx),I(:,:,1));
V_interplate(:,:,2)=interp1(gray_ideal_coefficient,Vdata(:,3,bandx),I(:,:,2));
V_interplate(:,:,3)=interp1(gray_ideal_coefficient,Vdata(:,4,bandx),I(:,:,3));
offset=V_interplate-Vdata_capture*ones(r,c);
save('offset.mat','offset');

%% generate simulated ptn
% gray_range=0:255;
% gray_ideal_coefficient=(gray_range./255).^2.2;%亮度比例系数
% Vdata_ini=importdata('Vh.mat');
% bandlist=1:13;
% DBV=[2175,1600,1200,650,300,200,100,90,60,30,15,10,4];
% Vdata=zeros(256,4,length(bandlist));
% for i=1:length(bandlist)
%     Vdata(:,:,i)=Vdata_ini(Vdata_ini(:,1)==bandlist(i),2:5);
% end
offset=importdata('offset.mat');
%
if ~exist('sim_ptn\')
    mkdir('sim_ptn\');
end 
%
colorx='RGB';      
gray=[ 10, 23, 31, 63, 10, 31,240,128,128,128,31];
band=[  5,  7,  5,  5,  4,  4,  5,  5, 12,  7,12];
for i=1:length(gray)
    grayx=gray(i);
    bandx=find(bandlist==band(i));
    patternW = bmpGenerator(offset,grayx,bandx,Vdata);
    imwrite(patternW,['pattern\',num2str(DBV(bandx)),'nits_W',num2str(grayx),'.bmp']);
end



