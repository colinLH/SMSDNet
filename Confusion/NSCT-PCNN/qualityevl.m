clear all
close all
clc

str = 'D:\master  materials\仿真\2图像融合\NSCT-PCNN--CODE\res3\';
wstr = [str 'eval.txt'];
fid = fopen(wstr,'w+');
for i = 1:4
    if i == 1
        str1 = [str 'Wavelet-Fusion-Res.bmp'];
        fprintf(fid,'Wavelet融合结果\r\n');
    elseif i == 2
        str1 = [str 'Contourlet-Fusion-Res.bmp'];
        fprintf(fid,'Contourlet融合结果\r\n');
    elseif i == 3
        str1 = [str 'NSCT-PCNN-Fusion-Res.bmp'];
        fprintf(fid,'NSCT-PCNN融合结果\r\n');
    else
        str1 = [str 'NSCT-ML-PCNNres.bmp'];
        fprintf(fid,'创新算法结果\r\n');
    end
    img = imread(str1);
    
    val = AverageGradent(img);
    fprintf(fid,'%7.4f',val);
    fprintf(fid,'    AverageGradent\r\n');

    img1 = imread([str '1.bmp']);
    img2 = imread([str '2.bmp']);    
    val1 = Corralation(img,img1);
    val2 = Corralation(img,img2);
    val = (val1+val2)/2;
    fprintf(fid,'%7.4f',val);
    fprintf(fid,'    Corralation\r\n');
    
    val = myentropy(img);
    fprintf(fid,'%7.4f',val);
    fprintf(fid,'    entropy\r\n');
    
    val = StandardDeviation(img);
    fprintf(fid,'%7.4f',val);
    fprintf(fid,'    StandardDeviation\r\n');
    fprintf(fid,'\r\n');
    
end



