clc
clear all
close all

% fdct_wrapping_demo_recon.m -- Partial curvelet reconstruction.
X=imread('E:\大三上\论文阅读\DenseNet\论文\Dataset\PET-RGB256\070.bmp');
X2=imread('E:\大三上\论文阅读\DenseNet\论文\Dataset\MRI-RGB256\070.bmp');
X1=rgb2gray(X);
X2=rgb2gray(X2);

% Forward curvelet transform
disp('Take curvelet transform: fdct_wrapping');
tic; C1 = fdct_wrapping(double(X1),0,2); toc;
tic; C2 = fdct_wrapping(double(X2),0,2); toc;
C=C1;
%tic; C = fdct_wrapping(double(X),0,2,5,16); toc;
for s=1:2
  for w=1:length(C{s})
    C{s}{w} = 0.5*C1{s}{w} + 0.5*C2{s}{w};
  end
end

for s=3:length(C)
  for w=1:length(C{s})
    C{s}{w} = max(C1{s}{w}, C2{s}{w});
  end
end
disp('Take inverse curvelet transform: ifdct_wrapping');
tic; Y = ifdct_wrapping(C,0,256,256); toc;

Y = uint8(Y);
subplot(1,3,1); colormap gray; imagesc(real(X1)); axis('image'); title('PET Image');
subplot(1,3,2); colormap gray; imagesc(real(X2)); axis('image'); title('MRI Image');
subplot(1,3,3); colormap gray; imagesc(real(Y)); axis('image'); title('Fused Image');
suptitle('CurveLet Transform Fusion');

% figure
% imshow(X1);
% figure
% imshow(X2);
% figure
% imshow(Y);

imwrite(Y,'xiaobo1.bmp');
