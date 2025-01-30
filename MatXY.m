function k=MatXY(i,j,n)

% i index 1
% j index 2
% n number of column/raw

nb=1;
for xi=1:n
    for xj=1:n
Mat(xi,xj)=nb;
nb=nb+1;
    end
end

k=Mat(i,j);



