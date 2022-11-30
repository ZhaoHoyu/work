function out = sim_block(input_dir, Gray, block_size, output_dir)


% path = 'C:\Users\F1_001\Desktop\SIM\';
path = output_dir;
% Gray = 10;

block_size_w = block_size(1);
block_size_h = block_size(2);

R0 = csvread([input_dir 'R' num2str(Gray) '.csv']);
G0 = csvread([input_dir 'G' num2str(Gray) '.csv']);
B0 = csvread([input_dir 'B' num2str(Gray) '.csv']);

% R0 = csvread('D:\data\LEMON\1st\R10.csv');
% G0 = csvread('D:\data\LEMON\1st\G10.csv');
% B0 = csvread('D:\data\LEMON\1st\B10.csv');

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

R_AF=uint8(zeros(1600,2560,3));
G_AF=uint8(zeros(1600,2560,3));
B_AF=uint8(zeros(1600,2560,3));
for i=1:block_size_w:2560
    for j=1:block_size_h:1600
        R_temp = R0(j:(j+block_size_h-1),i:(i+block_size_w-1));
        R_temp = uint8(round(((R_ave/mean(mean(R_temp)))^(1/2.2))*Gray));
        G_temp = G0(j:(j+block_size_h-1),i:(i+block_size_w-1));
        G_temp = uint8(round(((G_ave/mean(mean(G_temp)))^(1/2.2))*Gray));
        B_temp = B0(j:(j+block_size_h-1),i:(i+block_size_w-1));
        B_temp = uint8(round(((B_ave/mean(mean(B_temp)))^(1/2.2))*Gray));

        if Gray - 10 == 0
            R_temp(:,:) = max(min(R_temp(1, 1), 13), 3);
            G_temp(:,:) = max(min(G_temp(1, 1), 13), 3);
            B_temp(:,:) = max(min(B_temp(1, 1), 13), 3);
        end

        R_AF(j:(j+block_size_h-1),i:(i+block_size_w-1), 1) = R_temp;
        G_AF(j:(j+block_size_h-1),i:(i+block_size_w-1), 2) = G_temp;
        B_AF(j:(j+block_size_h-1),i:(i+block_size_w-1), 3) = B_temp;
    end
end


filename_R = ['R', num2str(Gray), '_block_',  num2str(block_size_w), '_', num2str(block_size_h), '.csv'];
filename_G = ['G', num2str(Gray), '_block_',  num2str(block_size_w), '_', num2str(block_size_h), '.csv'];
filename_B = ['B', num2str(Gray), '_block_',  num2str(block_size_w), '_', num2str(block_size_h), '.csv'];

imgname_R = ['R', num2str(Gray), '_block_',  num2str(block_size_w), '_', num2str(block_size_h), '.bmp'];
imgname_G = ['G', num2str(Gray), '_block_',  num2str(block_size_w), '_', num2str(block_size_h), '.bmp'];
imgname_B = ['B', num2str(Gray), '_block_',  num2str(block_size_w), '_', num2str(block_size_h), '.bmp'];

csvwrite([path filename_R], R_AF(:,:,1));
csvwrite([path filename_G], G_AF(:,:,2));
csvwrite([path filename_B], B_AF(:,:,3));

imwrite(R_AF, [path imgname_R]);
imwrite(G_AF, [path imgname_G]);
imwrite(B_AF, [path imgname_B]);

W_AF = uint8(zeros(1600,2560,3));
W_AF(:,:,1) = R_AF(:,:,1);
W_AF(:,:,2) = G_AF(:,:,2);
W_AF(:,:,3) = B_AF(:,:,3);

imgname_W = ['W', num2str(Gray), '_block_',  num2str(block_size_w), '_', num2str(block_size_h), '.bmp'];
imwrite(W_AF, [path imgname_W]);

out = true;

end

