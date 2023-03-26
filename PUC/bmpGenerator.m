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
function pattern = bmpGenerator(offset,grayx,bandx,Vdata)

    gray_range=0:255;
    gray_ideal_coefficient=(gray_range./255).^2.2;
    Vdata_out=Vdata(:,2:4,bandx);
    grayx_ideal_coefficient=(grayx./255).^2.2;
    V_xR=interp1(gray_ideal_coefficient,Vdata_out(:,1),grayx_ideal_coefficient);
    V_xG=interp1(gray_ideal_coefficient,Vdata_out(:,2),grayx_ideal_coefficient);
    V_xB=interp1(gray_ideal_coefficient,Vdata_out(:,3),grayx_ideal_coefficient);
    V_xRo=V_xR-offset(:,:,1);
    V_xGo=V_xG-offset(:,:,2);
    V_xBo=V_xB-offset(:,:,3);
    %
    V_xRo(V_xRo>max(Vdata_out(:,1)))=max(Vdata_out(:,1));
    V_xRo(V_xRo<min(Vdata_out(:,1)))=min(Vdata_out(:,1));
    V_xGo(V_xGo>max(Vdata_out(:,2)))=max(Vdata_out(:,2));
    V_xGo(V_xGo<min(Vdata_out(:,2)))=min(Vdata_out(:,2));
    V_xBo(V_xBo>max(Vdata_out(:,3)))=max(Vdata_out(:,3));
    V_xBo(V_xBo<min(Vdata_out(:,3)))=min(Vdata_out(:,3));
    %
    Lv_xRo=interp1(Vdata_out(:,1),gray_ideal_coefficient,V_xRo);%达到实际亮度的输入亮度比例系数
    Lv_xGo=interp1(Vdata_out(:,2),gray_ideal_coefficient,V_xGo);%达到实际亮度的输入亮度比例系数
    Lv_xBo=interp1(Vdata_out(:,3),gray_ideal_coefficient,V_xBo);%达到实际亮度的输入亮度比例系数
    pattern_cal=Lv_xRo.^(1/2.2)*255;%达到实际亮度的灰阶
    pattern_cal(:,:,2)=Lv_xGo.^(1/2.2)*255;%达到实际亮度的灰阶
    pattern_cal(:,:,3)=Lv_xBo.^(1/2.2)*255;%达到实际亮度的灰阶
    pattern=uint8(pattern_cal);
end
% imshow(pattern*10);