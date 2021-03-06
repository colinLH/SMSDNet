%亮度-对比度彩色传递融合算法的实现

clc
clear all
close all


Im1 = imread('D:\MATLAB7\work\LCT\img_fusion.bmp');
VI = imread('D:\MATLAB7\work\LCT\img12cut.bmp');

Iref = imread('D:\MATLAB7\work\LCT\VI1021_4111.bmp');

Igray = rgb2gray(Iref);
%Igray = Iref;

%Fuimage = imread('D:\MATLAB7\work\LCT\img_fusion.bmp');
[n1,n2] = size(Im1);

RGBC = double(VI);

Im2 = 0.229*VI(:,:,1) + 0.587*VI(:,:,2) + 0.114*VI(:,:,3);

Im2re = reshape(Igray,n1*n2,1)
udef = mean(Im2re,1);
odef = var(Im2re);
% udef = 129.62;
% odef = 128.93;

% Forward curvelet transform
disp('Take curvelet transform: fdct_wrapping');
tic; C1 = fdct_wrapping(double(Im1),0); toc;
tic; C2 = fdct_wrapping(double(Im2),0); toc;
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
tic; Y = ifdct_wrapping(C,0); toc;

%Y = uint8(Y);



% Fuimage = zeros(n1,n2);
% 
% if size(Im1)~=size(Im2)
%     error('Two images with the same size are needed!!')
% end
% 
% xcount = 0;
% for r = 1:n1
%     xcount = xcount + 1;
%     ycount = 0;
%     for c = 1:n2
%         ycount = ycount + 1;
%         Fuimage(xcount, ycount) = 0.5*Im1(r, c) + 0.5*Im2(r, c);
%         %Fuimage(xcount, ycount) = max(Im1(r, c),Im2(r, c));
%     end
% end


Fuimage = Y;

Fuimage = uint8(Fuimage);

Fuimage2re = reshape(Fuimage,n1*n2,1)
uf = mean(Fuimage2re,1);
of = var(Fuimage2re);

Fuimage = double(Fuimage);

% udef = uf;
% odef = of;
% a = odef/of;

%fff = Fuimage - uf;

Fc = (odef/of)*(Fuimage - uf) + udef;

%Fc = Fuimage;

%Fc = (odef/of)*(fff) + udef;

%Fc = uint8(Fc);



VI = double(VI);
Im2 = double(Im2);
RGBC = double(RGBC);

RGBC(:,:,1) = VI(:,:,1) + Fc - Im2;
RGBC(:,:,2) = VI(:,:,2) + Fc - Im2;
RGBC(:,:,3) = VI(:,:,3) + Fc - Im2;

VI = uint8(VI);
Im2 = uint8(Im2);
Fc = uint8(Fc);
RGBC = uint8(RGBC);

subplot(231), imshow(Im1), title('IR1');
subplot(232), imshow(Im2), title('VI1');
subplot(233), imshow(Fc), title('Fuimage');

figure
imshow(VI);
figure 
imshow(RGBC);