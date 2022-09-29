W0 = uint8(zeros(1600,2560,3));
R0 = uint8(zeros(1600,2560,3));
G0 = uint8(zeros(1600,2560,3));
B0 = uint8(zeros(1600,2560,3));

f='C:\Users\F1_001\Desktop\ZJ\';
col = 690:1800; %起始行:结束行
raw = 440:1160; %起始列:结束列
for g=250:255
    W0(raw,col,1) = uint8(g);
    W0(raw,col,2) = uint8(g);
    W0(raw,col,3) = uint8(g);
    R0(raw,col,1) = uint8(g);
    G0(raw,col,2) = uint8(g);
    B0(raw,col,3) = uint8(g);
    pathW=f+"20%APL W"+string(g)+'.bmp';
    pathR=f+"20%APL R"+string(g)+'.bmp';
    pathG=f+"20%APL G"+string(g)+'.bmp';
    pathB=f+"20%APL B"+string(g)+'.bmp';
    imwrite(W0,pathW)
    imwrite(R0,pathR)
    imwrite(G0,pathG)
    imwrite(B0,pathB)
end
