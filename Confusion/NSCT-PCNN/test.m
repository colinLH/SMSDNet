clc;
close all;
clear all;


path(path,'E:\大三上\论文阅读\DenseNet\论文\source code\confusion\NSCT-PCNN\NSCT-PCNN--CODE\PCNN_toolbox\')
path(path,'E:\大三上\论文阅读\DenseNet\论文\source code\confusion\NSCT-PCNN\NSCT-PCNN--CODE\nsct_toolbox')
path(path,'E:\大三上\论文阅读\DenseNet\论文\source code\confusion\NSCT-PCNN\NSCT-PCNN--CODE\FusionEvaluation\')

Low_Coeffs_Rule='ML-PCNN'; %'PCNN','ML-PCNN'
High_Coeffs_Rule='PCNN';   %'PCNN'

str = 'E:\大三上\论文阅读\DenseNet\论文\Dataset\'; %根据原图像所在的位置进行更改
ori_A=imread([str 'PET-Normal\070.png']);
ori_B=imread([str 'MRI-Normal\070.png']);
A=double(ori_A)/255;
B=double(ori_B)/255;
%% Parameters for NSCT
pfilt = '9-7';
dfilt = 'pkva';
nlevs = [0,1,3,4,4];
%% Parameters for PCNN
Para.iterTimes=200;
Para.link_arrange=3;
Para.alpha_L=1;
Para.alpha_Theta=0.2;
Para.beta=3;
Para.vL=1.0;
Para.vTheta=20;
%% NSCT分解 
disp('Decompose the image via nsct ...')
yA=nsctdec(A,nlevs,dfilt,pfilt);
yB=nsctdec(B,nlevs,dfilt,pfilt);

n = length(yA);
%% 低频融合 
Fused=yA;
disp('Process in Lowpass subband...')
ALow1= yA{1};
BLow1 =yB{1};
ALow2= yA{2};
BLow2 =yB{2};
switch Low_Coeffs_Rule
    case 'PCNN'       
        Fused{1}=fusion_NSCT_PCNN(ALow1,BLow1,Para);
        Fused{2}=fusion_NSCT_PCNN(ALow2,BLow2,Para);
   case 'ML-PCNN'
       Fused{1}=fusion_NSCT_ML_PCNN(ALow1,BLow1,Para);
       Fused{2}=fusion_NSCT_ML_PCNN(ALow2,BLow2,Para);
end
%% 高频融合
disp('Process in  Bandpass subbands...')
for l = 3:n
    for d = 1:length(yA{l})
        Ahigh = yA{l}{d};
        Bhigh = yB{l}{d};
        switch High_Coeffs_Rule
            case 'PCNN'
                Fused{l}{d}=fusion_NSCT_PCNN(Ahigh,Bhigh,Para);
            case 'ML-PCNN'
                Fused{l}{d}=fusion_NSCT_SF_PCNN(Ahigh,Bhigh,Para);
        end
    end
end
disp('High frequecy field process is ended')
disp('Reconstruct the image via nsct ...')
F=nsctrec(Fused, dfilt, pfilt);
disp('Reconstruct is ended...')
%%
F=F*255;
F(F<0)=0;
disp('F>255')
F(F>255)=255;
F=round(F);
subplot(131),imshow(ori_A);title('PET Image')
subplot(132),imshow(ori_B);title('MRI Image')
subplot(133),imshow(F,[]);title('Fused Image')
suptitle('NSCT-PCNN Fusion')
%figure,imshow(F,[])
imwrite(uint8(F),[str 'NSCT-ML-PCNNres.bmp'])


