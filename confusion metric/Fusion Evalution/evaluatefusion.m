function[std,ent,grad]=evaluatefusion(imf)
%���ֵ����׼ƫ��أ��ݶȣ����ϵ��
%����Ϊ�ںϺ��ͼ�񣬳�ʼ��ȫɫͼ�񣬶ನ��ͼ��
%��ÿ�����ν��д���

df=double(imf);
% dmul=double(immul);

std=std2(df(:));%���׼ƫ���׼��Խ��Ҷȼ��ֲ�Խ��ɢ��Ŀ��Ч��Խ��
ent=entropy(imf(:));
[mf,nf,kf]=size(imf);
q=0;
for i=1:1:mf-1
    for j=1:1:nf-1
        q=q+(sqrt(((df(i,j)-df(i+1,j))^2+(df(i,j)-df(i,j+1))^2)/2));
    end
 end
grad=q/((mf-1)*(nf-1)); %���ں�Ӱ���ƽ���ݶ�



