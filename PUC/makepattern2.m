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
    Lv0=(gray0./255).^2.2;%���ȱ���ϵ��
    V0=V(:,2:4,bandx);
    Lv_x=(grayx./255).^2.2;%�������ȱ���ϵ��
    V_xR=interp1(Lv0,V0(:,1),Lv_x);%�������ȶ�Ӧ���۵�ѹ
    V_xG=interp1(Lv0,V0(:,2),Lv_x);%�������ȶ�Ӧ���۵�ѹ
    V_xB=interp1(Lv0,V0(:,3),Lv_x);%�������ȶ�Ӧ���۵�ѹ
    V_xRo=V_xR-offsetV(:,:,1);%�ﵽ������ʵ�ʵ�ÿ�����ص�ѹ
    V_xGo=V_xG-offsetV(:,:,2);%�ﵽ������ʵ�ʵ�ÿ�����ص�ѹ
    V_xBo=V_xB-offsetV(:,:,3);%�ﵽ������ʵ�ʵ�ÿ�����ص�ѹ
    %
    V_xRo(V_xRo>max(V0(:,1)))=max(V0(:,1));%����ֵ����nan
    V_xRo(V_xRo<min(V0(:,1)))=min(V0(:,1));
    V_xGo(V_xGo>max(V0(:,2)))=max(V0(:,2));%����ֵ����nan
    V_xGo(V_xGo<min(V0(:,2)))=min(V0(:,2));
    V_xBo(V_xBo>max(V0(:,3)))=max(V0(:,3));%����ֵ����nan
    V_xBo(V_xBo<min(V0(:,3)))=min(V0(:,3));
    %
    Lv_xRo=interp1(V0(:,1),Lv0,V_xRo);%�ﵽʵ�����ȵ��������ȱ���ϵ��
    Lv_xGo=interp1(V0(:,2),Lv0,V_xGo);%�ﵽʵ�����ȵ��������ȱ���ϵ��
    Lv_xBo=interp1(V0(:,3),Lv0,V_xBo);%�ﵽʵ�����ȵ��������ȱ���ϵ��
    pattern_cal=Lv_xRo.^(1/2.2)*255;%�ﵽʵ�����ȵĻҽ�
    pattern_cal(:,:,2)=Lv_xGo.^(1/2.2)*255;%�ﵽʵ�����ȵĻҽ�
    pattern_cal(:,:,3)=Lv_xBo.^(1/2.2)*255;%�ﵽʵ�����ȵĻҽ�
    pattern=uint8(pattern_cal);
end
% imshow(pattern*10);