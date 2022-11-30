
path = 'D:\data\FPGA_DEMURA\ESWIN\#1\650NITS@120Hz\';
% newpath = 'D:\data\FPGA_DEMURA\ESWIN\#1\650NITS@1Hz\';
files = dir([path '*.csv']);
filenums = size(files, 1);

for i = 1:filenums

imgdata = csvread([path files(i).name]);
sz = size(imgdata);

imgdata(1:85, :) = imgdata(100:184, :);
imgdata(sz(1)-84:sz(1), :) = imgdata(100:184, :);



csvwrite([path files(i).name], imgdata);

end
