clear all
close all
clc

load C1.mat
iter = 1;
for i = 2:4
    for j = 1:8
        
        subplot(3,8,iter),imshow(C1{1,i}{1,j},[]);
        iter = iter + 1;
    end
end
figure,imshow(C1{1,1},[])