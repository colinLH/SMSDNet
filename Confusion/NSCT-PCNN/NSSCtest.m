close all
clear all
clc

path(path,'PCNN_toolbox/')
path(path,'nsct_toolbox')
path(path,'FusionEvaluation/')

str = 'D:\master  materials\����\2ͼ���ں�\img\zoneplate\';
im1=imread([str 'zoneplate.png']);
nlevels = [1,2,3,4] ;  % Decomposition level
pfilter = 'maxflat' ;              % Pyramidal filter
dfilter = 'dmaxflat7' ;
C1=nsctdec(double(im1),nlevels,dfilter,pfilter);
C1{1,1} = uint8(C1{1,1});
imwrite(C1{1,1},[str '��ͨͼ��.bmp']);
for i = 2:5
    n = 2^(i-1);
    a = i-1;
    for j = 1:n
        C1{1,i}{1,j} = uint8(C1{1,i}{1,j});
        str1 = [str  num2str(a) '����-' num2str(j) '.bmp'];
        imwrite(C1{1,i}{1,j},str1);
        
    end
end