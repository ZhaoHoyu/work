% clear;clc;
% offsetV=importdata('offset.mat');
% grayx=10;
% bandx=5;
% Vdata=importdata('Vh.mat');
% band0=1:25;
% V=zeros(256,4,length(band0));
% for i=1:length(band0)
%     V(:,:,i)=Vdata(Vdata(:,1)==band0(i),2:5);
% end
% h=2796;
% w=1290;
%
function pattern = makepattern2(offsetV,grayx,bandx,V)

    gray0=0:255;
    Lv0=(gray0./255).^2.2;%亮度比例系数
    V0=V(:,2:4,bandx);
    Lv_x=(grayx./255).^2.2;%理论亮度比例系数
    V_xR=interp1(Lv0,V0(:,1),Lv_x);%理论亮度对应理论电压
    V_xG=interp1(Lv0,V0(:,2),Lv_x);%理论亮度对应理论电压
    V_xB=interp1(Lv0,V0(:,3),Lv_x);%理论亮度对应理论电压
    V_xRo=V_xR-offsetV(:,:,1);%达到此亮度实际的每个像素电压
    V_xGo=V_xG-offsetV(:,:,2);%达到此亮度实际的每个像素电压
    V_xBo=V_xB-offsetV(:,:,3);%达到此亮度实际的每个像素电压
    %
    V_xRo(V_xRo>max(V0(:,1)))=max(V0(:,1));%防插值出现nan
    V_xRo(V_xRo<min(V0(:,1)))=min(V0(:,1));
    V_xGo(V_xGo>max(V0(:,2)))=max(V0(:,2));%防插值出现nan
    V_xGo(V_xGo<min(V0(:,2)))=min(V0(:,2));
    V_xBo(V_xBo>max(V0(:,3)))=max(V0(:,3));%防插值出现nan
    V_xBo(V_xBo<min(V0(:,3)))=min(V0(:,3));
    %
    Lv_xRo=interp1(V0(:,1),Lv0,V_xRo);%达到实际亮度的输入亮度比例系数
    Lv_xGo=interp1(V0(:,2),Lv0,V_xGo);%达到实际亮度的输入亮度比例系数
    Lv_xBo=interp1(V0(:,3),Lv0,V_xBo);%达到实际亮度的输入亮度比例系数
    pattern_cal=Lv_xRo.^(1/2.2)*255;%达到实际亮度的灰阶
    pattern_cal(:,:,2)=Lv_xGo.^(1/2.2)*255;%达到实际亮度的灰阶
    pattern_cal(:,:,3)=Lv_xBo.^(1/2.2)*255;%达到实际亮度的灰阶
    pattern=uint8(pattern_cal);
end
% imshow(pattern*10);