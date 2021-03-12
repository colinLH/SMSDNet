%Contourlet图像融合 低取大，高取局部能量最大
tic
clear all
clc
im1=imread('D:\master  materials\仿真\2图像融合\img\img1\source20_1.tif');
im2=imread('D:\master  materials\仿真\2图像融合\img\img1\source20_2.tif');
% im1=rgb2gray(im11);
% im2=rgb2gray(im22);
nlevels = [3,3,3] ;        % Decomposition level
pfilter = 'maxflat' ;              % Pyramidal filter
dfilter = 'dmaxflat7' ;              % Directional filter
C1=nsctdec(double(im1),nlevels,dfilter,pfilter);
C2=nsctdec(double(im2),nlevels,dfilter,pfilter);
C=C1;

I=C1{1}.*(C1{1}<=C2{1})+C2{1}.*(C1{1}>C2{1});
C{1}=C1{1}+C2{1}-I;

block=2;
for i=2:length(C1)
    for j=1:length(C1{i})
        b_im1=C1{i}{j};
        b_im2=C2{i}{j};
        rr=ceil(size(b_im1,1)/block)*block-size(b_im1,1);
        b_im1=wextend('ar','zpd',b_im1,ceil(size(b_im1,1)/block)*block-size(b_im1,1),'l');
        ll=ceil(size(b_im1,2)/block)*block-size(b_im1,2);
        b_im1=wextend('ac','zpd',b_im1,ceil(size(b_im1,2)/block)*block-size(b_im1,2),'l');
        b_im2=wextend('ar','zpd',b_im2,ceil(size(b_im2,1)/block)*block-size(b_im2,1),'l');
        b_im2=wextend('ac','zpd',b_im2,ceil(size(b_im2,2)/block)*block-size(b_im2,2),'l');
        b_f_im=b_im1;
        for m=1:size(b_im1,1)/block
            for n=1:size(b_im1,2)/block
                a_b=b_im1(((m-1)*block+1):m*block ,((n-1)*block+1):n*block);
                b_b=b_im2(((m-1)*block+1):m*block ,((n-1)*block+1):n*block);
                if mean2(a_b.^2)>mean2(b_b.^2)
                    b_f_im(((m-1)*block+1):m*block,((n-1)*block+1):n*block)=a_b;
                else
                    b_f_im(((m-1)*block+1):m*block,((n-1)*block+1):n*block)=b_b;
                end
            end
        end
        C{i}{j}=b_f_im(rr+1:end,ll+1:end);
    end
end
f_im=nsctrec(C);
figure,imshow(im1);
figure,imshow(im2);
figure,imshow(f_im,[]);
f_im = uint8(f_im);
imwrite(f_im,'2contourletRes.bmp')
toc
t=toc



