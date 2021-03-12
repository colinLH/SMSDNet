function cp=ModifyLow(matrix)

disp('Modified low frequency is computing...')
filter1 = [-1 -1 -1
           -1 -9 -1
           -1 -1 -1];
filter2 = [0.11 0.11 0.11
           0.11 0.12 0.11
           0.11 0.11 0.11];
ML1 = imfilter(matrix,filter1);
ML2 = imfilter(matrix,filter2);

[h,w] = size(matrix);
max1 = max(ML1);
min1 = min(ML1);

max2 = max(ML2);
min2 = min(ML2);
for i = 1:h
    for j = 1:w
        ML1(i,j) = (ML1(i,j)-min1)/(max1 - min1);
    end
end

for i = 1:h
    for j = 1:w
        ML2(i,j) = (ML2(i,j)-min2)/(max2 - min2);
    end
end

for i = 1:h
    for j = 1:w
        cp(i,j) = max(ML1(i,j),ML2(i,j));
    end
end

