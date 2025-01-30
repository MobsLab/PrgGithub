function M=RemoveNan(A)

a=1;
for i=1:size(A,1)
    
    if length(find(isnan(A(i,:))))>1
   id(a)=i;
   a=a+1;
    end
end

M=A;
try
M(id,:)=[];
end

