clear all;
close all;
clc;
%% NSST tool box
addpath(genpath('shearlet'));
%%
A=imread('E:\大三上\论文阅读\DenseNet\论文\Dataset\MRI-Normal\072.png');  %anatomical image
B=imread('E:\大三上\论文阅读\DenseNet\论文\Dataset\PET-RGB256\072.bmp'); %functional image

img1 = double(A)/255;
img2 = double(B)/255;
img2_YUV=ConvertRGBtoYUV(img2);
img2_Y=img2_YUV(:,:,1);
[hei, wid] = size(img1);

% image fusion with NSST-PAPCNN 
imgf_Y=fuse_NSST_PAPCNN(img1,img2_Y); 

imgf_YUV=zeros(hei,wid,3);
imgf_YUV(:,:,1)=imgf_Y;
imgf_YUV(:,:,2)=img2_YUV(:,:,2);
imgf_YUV(:,:,3)=img2_YUV(:,:,3);
imgf=ConvertYUVtoRGB(imgf_YUV);

F=uint8(imgf*255);
subplot(131),imshow(B);title('PET Image')
subplot(132),imshow(A);title('MRI Image')
subplot(133),imshow(F,[]);title('Fused Image')
suptitle('SP-ResNet Fusion')
imwrite(F,'results/fused.tif');

