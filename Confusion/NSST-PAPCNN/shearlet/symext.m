function yT=symext(x,h,shift)

% FUNCTION Y = SYMEXT
% INPUT:  x, mxn image
%         h, 2-D filter coefficients
%         shift, optional shift
% OUTPUT: yT image symetrically extended (H/V symmetry)
%
% Performs symmetric extension for image x, filter h. 
% The filter h is assumed have odd dimensions.
% If the filter has horizontal and vertical symmetry, then 
% the nonsymmetric part of conv2(h,x) has the same size of x.
%
% Created by A. Cunha, Fall 2003;
% Modified 12/2005 by A. Cunha. Fixed a bug on wrongly 
% swapped indices (m and n). 

[m,n] = size(x);% [256,256]
[p,q] = size(h);% [13,13]
parp  = 1-mod(p,2) ;% 0
parq  = 1-mod(q,2);% 0

p2=floor(p/2);q2=floor(q/2); % 6 6
s1=shift(1);s2=shift(2);% 1 1

ss = p2 - s1 + 1; % 6
rr = q2 - s2 + 1; % 6
a1 = fliplr(x(: , 1:ss));
a2 = x(: , n:-1:n-p-s1+1);

yT = [a1,x,a2];
b1 = flipud(yT(1:rr, :));
b2 = yT(m :-1:m-q-s2+1 , :);
yT = [b1; yT ; b2];
x_range = m+p-1;
y_range = n+q-1;
yT = yT(1:x_range ,1:y_range);
 
