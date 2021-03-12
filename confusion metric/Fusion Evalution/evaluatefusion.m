function[std,ent,grad]=evaluatefusion(imf)
%求均值，标准偏差，熵，梯度，相关系数
%输入为融合后的图像，初始的全色图像，多波段图像
%对每个波段进行处理

df=double(imf);
% dmul=double(immul);

std=std2(df(:));%求标准偏差，标准差越大灰度级分布越分散，目视效果越好
ent=entropy(imf(:));
[mf,nf,kf]=size(imf);
q=0;
for i=1:1:mf-1
    for j=1:1:nf-1
        q=q+(sqrt(((df(i,j)-df(i+1,j))^2+(df(i,j)-df(i,j+1))^2)/2));
    end
 end
grad=q/((mf-1)*(nf-1)); %求融合影像的平均梯度



