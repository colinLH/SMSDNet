% 以下是举了一个例子，可以用的
% m1=imread('C:\Users\15846\Desktop\各类融合的算法\materials\test\VIS_man.bmp');
% m2=imread('C:\Users\15846\Desktop\各类融合的算法\materials\test\IR_man.bmp');
% zt=4;ap=[1 1];mp=1;
% y=lp_pyramid(m1,m2,zt,ap,mp);  %调用这个梯度金字塔的函数  这里如果回到本函数文件这里，就不是用这个文件名，要拿出去调用采用这个文件名，在里面就用function那里的fuse_gra
% subplot(131),imshow(m1);title('Visible Image')
% subplot(132),imshow(m2);title('Infrared Image')
% subplot(133),imshow(y);title('Fused Image')
% suptitle('Gradient Pyramid Fusion');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%拉普拉斯金字塔融合函数
function y=lp_pyramid(m1,m2,zt,ap,mp)
% m1、m2为源图像，zt为融合层数，mp为低频子带图像选择系数，ap是高频，默认zt为4，ap和mp为1吧
[z1, s1]=size(m1);
[z2, s2]=size(m2);
if(z1~=z2)||(s1~=s2)
    error('输入图像大小不一致');
end;
w=[1 4 6 4 1]/16;   % 高斯窗口函数
e=cell(1,zt);
for i1=1:zt
    [z, s]=size(m1);
    z1(i1)=z;s1(i1)=s;
    % 图像尺寸为奇数还是偶数
    if(floor(z/2)~=z/2),ew(1)=1;else ew(1)=0;end;
    if(floor(s/2)~=s/2),ew(2)=1;else ew(2)=0;end;
    % 若为奇数，扩展为偶数
    if(any(ew))
        m1=adb(m1,ew);
        m2=adb(m2,ew);
    end;
    % m1和m2低通滤波
    g1=conv2(conv2(es2(m1,2),w,'valid'),w','valid'); % m1低通滤波
    g2=conv2(conv2(es2(m2,2),w,'valid'),w','valid'); % m2低通滤波
    % g1和g2下采样、上采样低通滤波后的膨胀序列
    m1t=conv2(conv2(es2(undec2(dec2(g1)),2),2*w,'valid'),2*w','valid');
    m2t=conv2(conv2(es2(undec2(dec2(g2)),2),2*w,'valid'),2*w','valid');
    % 高频子带图像系数选择
    e(i1)={selg(double(m1)-m1t,double(m2)-m2t,ap)};
    % g1和g2下采样
    m1=dec2(g1);
    m2=dec2(g2);
end;
% 低频子带图像系数选择
m1=selh(m1,m2,mp);
% 图像重构  
for i1=zt:-1:1
    m1t=conv2(conv2(es2(undec2(m1),2),2*w,'valid'),2*w','valid');  %膨胀序列
    %%%%% 自己添加 这一段是处理由于dec2函数之后造成e（i1）的矩阵大小和m1t矩阵大小不同的毛病。
    a=cell2mat(e(i1));
    r1=size(m1t);r2=size(a);
    if r1(1)~=r2(1)||r1(2)~=r2(2)
        [z, s]=size(a);
        yy=zeros(z,s);
        yy=m1t(1:z,1:s);
        m1t=yy;
    end;
    %%%%% 自己添加 以上
    m1=m1t+e{i1};
      % 选择图像有效区域
     %%% 去掉这里才能正常工作      m1=m1(1:z1(i1),1:s1(i1));
end;
  y=uint8(m1); % 使用uint8才能正确出图象，不然就是一张空白图
end

% 图像2抽取函数
function y=dec2(x)
[a, b]=size(x);
y=x(1:2:a,1:2:b);
end
% 图像2插值函数
function y=undec2(x)
[z, s]=size(x);
y=zeros(2*z,2*s);
y(1:2:2*z,1:2:2*s)=x;
end
% 图像扩展函数
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
% 图像边缘像素处理函数
function y=es2(x,n)
[z, s]=size(x);
y=zeros(z+2*n,s+2*n);
y(n+1:n+z,n:-1:1)=x(:,2:1:n+1);
y(n+1:n+z,n+1:1:n+s)=x;
y(n+1:n+z,n+s+1:1:s+2*n)=x(:,s-1:-1:s-n);
y(n:-1:1,n+1:s+n)=x(2:1:n+1,:);
y(n+z+1:1:z+2*n,n+1:s+n)=x(z-1:-1:z-n,:);
end
%低频子带图像选择函数
function y=selh(m1,m2,mp)
switch(mp)
    case 1,y=m1; % 选择图像m1低频子带图像作为融合函数低频成分
    case 2,y=m2; % 选择图像m2低频子带图像作为融合函数低频成分
    case 3,y=(m1+m2)/2; % 选择图像m1和m2加权平均低频子带图像作为融合函数低频成分
    otherwise, error('低频成分选择错误');
end;
end
% 高频子带图像选择函数
function y=selg(m1,m2,ap)
% 判断输入图像是否大小一致
[z1, s1]=size(m1);
[z2, s2]=size(m2);
if(z1~=z2)||(s1~=s2)
    error('输入图像大小不一致');
end;
switch(ap(1))
    case 1,mm=(abs(m1))>(abs(m2)); %绝对值最大融合准则
        y=(mm.*m1)+((~mm).*m2); 
    case 2, um=ap(2);th=.75; % 设定阈值   %基于窗口系数加权平均融合
        %窗口区域加权平均能量
        ss1=conv2(es2(m1.*m1,floor(um/2)),ones(um),'valid');
        ss2=conv2(es2(m2.*m2,floor(um/2)),ones(um),'valid');
        % 归一化相关度
        ma=conv2(es2(m1.*m2,floor(um/2)),ones(um),'valid');
        ma=2*ma./(ss1+ss2+eps);
        % s根据设定阈值选择融合系数
        mm1=ma > th;mm2=ss1>ss2;
        w1=(0.5-0.5*(1-ma)/(1-th));
        y=(~mm1).*((mm2.*m1)+((~mm2).*m2));
        y=y+(mm1.*((mm2.*m1.*(1-w1))+((mm2).*m2.*w1)+((~mm2).*m2.*(1-w1))+((~mm2).*m1.*w1)));
    case 3,
        % 窗口系数绝对值选大融合准则
        um=ap(2);
        a1=ordfilt2(abs(es2(m1,floor(um/2))),um*um,ones(um));
        a2=ordfilt2(abs(es2(m2,floor(um/2))),um*um,ones(um));
        r1=a1>a2;
        mm=(conv2(double(r1),ones(um),'valid'))>floor(um*um/2);
        y=(mm.*m1)+((~mm).*m2);
    case 4,
        % 系数最大融合准则
        mm=m1>m2;
        y=(mm.*m1)+((~mm).*m2);
    otherwise,
        error('高频成分选择错误');
end;
end
%%% 这个是graf，来源于书上的那些公式 然后自己编写的，书上 p109
function y=graf(m1,m2)
% 判断输入图像是否大小一致
[z1 s1]=size(m1);
[z2 s2]=size(m2);
answ=zeros(size(m1));
if(z1~=z2)||(s1~=s2)
    error('输入图像大小不一致');
end;
a=[1 2 1; 2 10 2; 1 2 1]/28;
for m=2:1:z1-1
    for n=2:1:s1-1
        for i=-1:1:1
            for j=-1:1:1
                sa1=a(i+2,j+2)*m1(m+i,n+j)*m1(m+i,n+j);  % 显著性测度
                sa2=a(i+2,j+2)*m2(m+i,n+j)*m2(m+i,n+j);
                m12=2*a(i+2,j+2)*m1(m+i,n+j)*m2(m+i,n+j)/(sa1^2+sa2^2);    % 相似性测度
                th=0.8;  % 设置阈值为0.8
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
                

    
    
    
    
    
    
    
    
    