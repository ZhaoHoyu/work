

R0 = csvread('D:\data\LTPS_Tandem_15d5\sim\R031.csv');
G0 = csvread('D:\data\LTPS_Tandem_15d5\sim\G031.csv');
B0 = csvread('D:\data\LTPS_Tandem_15d5\sim\B031.csv');



lie=1181:1380;
hang=701:900;

R1=R0(:,lie);
R2=R1(hang,:);
G1=G0(:,lie);
G2=G1(hang,:);
B1=B0(:,lie);
B2=B1(hang,:);

R_ave=mean(R2(:));
G_ave=mean(G2(:));
B_ave=mean(B2(:));
% R_ave = (10/255)^2.2*(600*0.23);
% G_ave = (10/255)^2.2*(600*0.68);
% B_ave = (10/255)^2.2*(600*0.09);
% R1111=uint8(round((((R_ave/R0(50,1000)).^(1/2.2)).*10)));

%parfor
Q=zeros(1600,2560);
W=zeros(1600,2560);
E=zeros(1600,2560);
for i=1:1:2560;
    R(:,i)=uint8(round(((R_ave./R0(:,i)).^(1/2.2)).*31));
    G(:,i)=uint8(round(((G_ave./G0(:,i)).^(1/2.2)).*31));
    B(:,i)=uint8(round(((B_ave./B0(:,i)).^(1/2.2)).*31));
    %R(:,i)=uint8(round(((R_ave./R0(:,i)).^(1/2.2)).*63));

%     if R(:,i)>20
%         R(:,i)=20;
%     elseif R(:,i)<3
%         R(:,i)=3;
%     end
%     if G(:,i)>20
%         G(:,i)=20;
%     elseif G(:,i)<3
%         G(:,i)=3;
%     end
%     if B(:,i)>15
%         B(:,i)=15;
%     elseif B(:,i)<5
%         B(:,i)=5;
%     end

%     G(:,i)=uint8(round((((G_ave*2-G0(:,i))./(600*0.68)).^(1/2.2)).*255));
%     B(:,i)=uint8(round((((B_ave*2-B0(:,i))./(600*0.09)).^(1/2.2)).*255));
end

% for i=1:1:2560;
%     for j=1:1:1600
%         if R(j,i)>20
%             R(j,i)=20;
%         elseif R(j,i)<3
%             R(j,i)=3;
%         end
%         if G(j,i)>20
%             G(j,i)=20;
%         elseif G(j,i)<3
%             G(j,i)=3;
%         end
%         if B(j,i)>20
%             B(j,i)=20;
%         elseif B(j,i)<3
%             B(j,i)=3;
%         end
%     end
% end
% csvwrite("C:\Users\JC\Desktop\sim\R10_sim.csv",R);
% csvwrite("C:\Users\JC\Desktop\sim\G10_sim.csv",G);
% csvwrite("C:\Users\JC\Desktop\sim\B10_sim.csv",B);
%     
% R_data = csvread("C:\Users\JC\Desktop\sim\R10_sim.csv");
% G_data = csvread("C:\Users\JC\Desktop\sim\G10_sim.csv");
% B_data = csvread("C:\Users\JC\Desktop\sim\B10_sim.csv");

% Red = uint8(R_data);
% Green = uint8(G_data);
% Blue = uint8(B_data);

I0 = zeros(1600,2560,3);
I0 = uint8(I0);
I0(:,:,1)=uint8(R);
I0(:,:,2)=uint8(G);
I0(:,:,3)=uint8(B);
imwrite(I0,'D:\data\LTPS_Tandem_15d5\sim_result\W31_V1.bmp');

R10=uint8(zeros(1600,2560,3));
G10=uint8(zeros(1600,2560,3));
B10=uint8(zeros(1600,2560,3));
R10(:,:,1) = uint8(R);
G10(:,:,2) = uint8(G);
B10(:,:,3) = uint8(B);
imwrite(R10,'D:\data\LTPS_Tandem_15d5\sim_result\R31_V1.bmp');
imwrite(G10,'D:\data\LTPS_Tandem_15d5\sim_result\G31_V1.bmp');
imwrite(B10,'D:\data\LTPS_Tandem_15d5\sim_result\B31_V1.bmp');
