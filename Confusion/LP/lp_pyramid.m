% �����Ǿ���һ�����ӣ������õ�
% m1=imread('C:\Users\15846\Desktop\�����ںϵ��㷨\materials\test\VIS_man.bmp');
% m2=imread('C:\Users\15846\Desktop\�����ںϵ��㷨\materials\test\IR_man.bmp');
% zt=4;ap=[1 1];mp=1;
% y=lp_pyramid(m1,m2,zt,ap,mp);  %��������ݶȽ������ĺ���  ��������ص��������ļ�����Ͳ���������ļ�����Ҫ�ó�ȥ���ò�������ļ��������������function�����fuse_gra
% subplot(131),imshow(m1);title('Visible Image')
% subplot(132),imshow(m2);title('Infrared Image')
% subplot(133),imshow(y);title('Fused Image')
% suptitle('Gradient Pyramid Fusion');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%������˹�������ںϺ���
function y=lp_pyramid(m1,m2,zt,ap,mp)
% m1��m2ΪԴͼ��ztΪ�ںϲ�����mpΪ��Ƶ�Ӵ�ͼ��ѡ��ϵ����ap�Ǹ�Ƶ��Ĭ��ztΪ4��ap��mpΪ1��
[z1, s1]=size(m1);
[z2, s2]=size(m2);
if(z1~=z2)||(s1~=s2)
    error('����ͼ���С��һ��');
end;
w=[1 4 6 4 1]/16;   % ��˹���ں���
e=cell(1,zt);
for i1=1:zt
    [z, s]=size(m1);
    z1(i1)=z;s1(i1)=s;
    % ͼ��ߴ�Ϊ��������ż��
    if(floor(z/2)~=z/2),ew(1)=1;else ew(1)=0;end;
    if(floor(s/2)~=s/2),ew(2)=1;else ew(2)=0;end;
    % ��Ϊ��������չΪż��
    if(any(ew))
        m1=adb(m1,ew);
        m2=adb(m2,ew);
    end;
    % m1��m2��ͨ�˲�
    g1=conv2(conv2(es2(m1,2),w,'valid'),w','valid'); % m1��ͨ�˲�
    g2=conv2(conv2(es2(m2,2),w,'valid'),w','valid'); % m2��ͨ�˲�
    % g1��g2�²������ϲ�����ͨ�˲������������
    m1t=conv2(conv2(es2(undec2(dec2(g1)),2),2*w,'valid'),2*w','valid');
    m2t=conv2(conv2(es2(undec2(dec2(g2)),2),2*w,'valid'),2*w','valid');
    % ��Ƶ�Ӵ�ͼ��ϵ��ѡ��
    e(i1)={selg(double(m1)-m1t,double(m2)-m2t,ap)};
    % g1��g2�²���
    m1=dec2(g1);
    m2=dec2(g2);
end;
% ��Ƶ�Ӵ�ͼ��ϵ��ѡ��
m1=selh(m1,m2,mp);
% ͼ���ع�  
for i1=zt:-1:1
    m1t=conv2(conv2(es2(undec2(m1),2),2*w,'valid'),2*w','valid');  %��������
    %%%%% �Լ���� ��һ���Ǵ�������dec2����֮�����e��i1���ľ����С��m1t�����С��ͬ��ë����
    a=cell2mat(e(i1));
    r1=size(m1t);r2=size(a);
    if r1(1)~=r2(1)||r1(2)~=r2(2)
        [z, s]=size(a);
        yy=zeros(z,s);
        yy=m1t(1:z,1:s);
        m1t=yy;
    end;
    %%%%% �Լ���� ����
    m1=m1t+e{i1};
      % ѡ��ͼ����Ч����
     %%% ȥ�����������������      m1=m1(1:z1(i1),1:s1(i1));
end;
  y=uint8(m1); % ʹ��uint8������ȷ��ͼ�󣬲�Ȼ����һ�ſհ�ͼ
end

% ͼ��2��ȡ����
function y=dec2(x)
[a, b]=size(x);
y=x(1:2:a,1:2:b);
end
% ͼ��2��ֵ����
function y=undec2(x)
[z, s]=size(x);
y=zeros(2*z,2*s);
y(1:2:2*z,1:2:2*s)=x;
end
% ͼ����չ����
function y=adb(x,bd)
[z, s]=size(x);
y=zeros(z+bd(1),s+bd(2));
y(1:z,1:s)=x;
if(bd(1)>0)
    y(z+1:z+bd(1),1:s)=x(z-1:-1:z-bd(1),1:s);
end;
if(bd(2)>0)
    y(1:z,s+1:s+bd(2))=x(1:z,s-1:-1:s-bd(2));
end;
if(bd(1)>0 && bd(2)>0)
    y(z+1:z+bd(1),s+1:s+bd(2))=x(z-1:-1:z-bd(1),s-1:-1:s-bd(2));
end;
end
% ͼ���Ե���ش�����
function y=es2(x,n)
[z, s]=size(x);
y=zeros(z+2*n,s+2*n);
y(n+1:n+z,n:-1:1)=x(:,2:1:n+1);
y(n+1:n+z,n+1:1:n+s)=x;
y(n+1:n+z,n+s+1:1:s+2*n)=x(:,s-1:-1:s-n);
y(n:-1:1,n+1:s+n)=x(2:1:n+1,:);
y(n+z+1:1:z+2*n,n+1:s+n)=x(z-1:-1:z-n,:);
end
%��Ƶ�Ӵ�ͼ��ѡ����
function y=selh(m1,m2,mp)
switch(mp)
    case 1,y=m1; % ѡ��ͼ��m1��Ƶ�Ӵ�ͼ����Ϊ�ںϺ�����Ƶ�ɷ�
    case 2,y=m2; % ѡ��ͼ��m2��Ƶ�Ӵ�ͼ����Ϊ�ںϺ�����Ƶ�ɷ�
    case 3,y=(m1+m2)/2; % ѡ��ͼ��m1��m2��Ȩƽ����Ƶ�Ӵ�ͼ����Ϊ�ںϺ�����Ƶ�ɷ�
    otherwise, error('��Ƶ�ɷ�ѡ�����');
end;
end
% ��Ƶ�Ӵ�ͼ��ѡ����
function y=selg(m1,m2,ap)
% �ж�����ͼ���Ƿ��Сһ��
[z1, s1]=size(m1);
[z2, s2]=size(m2);
if(z1~=z2)||(s1~=s2)
    error('����ͼ���С��һ��');
end;
switch(ap(1))
    case 1,mm=(abs(m1))>(abs(m2)); %����ֵ����ں�׼��
        y=(mm.*m1)+((~mm).*m2); 
    case 2, um=ap(2);th=.75; % �趨��ֵ   %���ڴ���ϵ����Ȩƽ���ں�
        %���������Ȩƽ������
        ss1=conv2(es2(m1.*m1,floor(um/2)),ones(um),'valid');
        ss2=conv2(es2(m2.*m2,floor(um/2)),ones(um),'valid');
        % ��һ����ض�
        ma=conv2(es2(m1.*m2,floor(um/2)),ones(um),'valid');
        ma=2*ma./(ss1+ss2+eps);
        % s�����趨��ֵѡ���ں�ϵ��
        mm1=ma > th;mm2=ss1>ss2;
        w1=(0.5-0.5*(1-ma)/(1-th));
        y=(~mm1).*((mm2.*m1)+((~mm2).*m2));
        y=y+(mm1.*((mm2.*m1.*(1-w1))+((mm2).*m2.*w1)+((~mm2).*m2.*(1-w1))+((~mm2).*m1.*w1)));
    case 3,
        % ����ϵ������ֵѡ���ں�׼��
        um=ap(2);
        a1=ordfilt2(abs(es2(m1,floor(um/2))),um*um,ones(um));
        a2=ordfilt2(abs(es2(m2,floor(um/2))),um*um,ones(um));
        r1=a1>a2;
        mm=(conv2(double(r1),ones(um),'valid'))>floor(um*um/2);
        y=(mm.*m1)+((~mm).*m2);
    case 4,
        % ϵ������ں�׼��
        mm=m1>m2;
        y=(mm.*m1)+((~mm).*m2);
    otherwise,
        error('��Ƶ�ɷ�ѡ�����');
end;
end
%%% �����graf����Դ�����ϵ���Щ��ʽ Ȼ���Լ���д�ģ����� p109
function y=graf(m1,m2)
% �ж�����ͼ���Ƿ��Сһ��
[z1 s1]=size(m1);
[z2 s2]=size(m2);
answ=zeros(size(m1));
if(z1~=z2)||(s1~=s2)
    error('����ͼ���С��һ��');
end;
a=[1 2 1; 2 10 2; 1 2 1]/28;
for m=2:1:z1-1
    for n=2:1:s1-1
        for i=-1:1:1
            for j=-1:1:1
                sa1=a(i+2,j+2)*m1(m+i,n+j)*m1(m+i,n+j);  % �����Բ��
                sa2=a(i+2,j+2)*m2(m+i,n+j)*m2(m+i,n+j);
                m12=2*a(i+2,j+2)*m1(m+i,n+j)*m2(m+i,n+j)/(sa1^2+sa2^2);    % �����Բ��
                th=0.8;  % ������ֵΪ0.8
                if m12>=th
                    w1=0.5-0.5*((1-m12)/(1-th));w2=1-w1;
                elseif sa1>sa2
                    w1=1;w2=0;
                else w1=0;w2=1;
                end;
                answ(m,n)=w1*m1(i+2,j+2)+w2*m2(i+2,j+2);
            end;
        end;
    end;
end;

y=answ;
end
                

    
    
    
    
    
    
    
    
    