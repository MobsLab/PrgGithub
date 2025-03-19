
function B = interp2_BM(A , n1 , n2)

if ~exist('n1','var')
    n1=size(A,1)*10;
    n2=size(A,2)*10;
end

% INPUT:
% A: matrix to interp
% n1: 1st wanted dimension
% n2: 2nd wanted dimension

% OUTPUT:
% B: interpolated matrix

for line=1:size(A,1)
    B_pre(line,:) = interp1(linspace(0,1,size(A,2)) ,  A(line,:) , linspace(0,1,n2));
end
for column=1:n2
    B(:,column) = interp1(linspace(0,1,size(A,1)) ,  B_pre(:,column) , linspace(0,1,n1));
end








