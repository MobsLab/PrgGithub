function [r,p,rc,pc]=PlaceFiledCorrealtion(Mat,th)

try
th;
catch
th=4;
end

[r,p]=corrcoef(Mat);
p=p-diag(diag(p));

r=r-diag(diag(r));
for i=1:length(r)
    r(i,i)=max(max(r));
end


rc=zeros(size(Mat,2),size(Mat,2));
pc=zeros(size(Mat,2),size(Mat,2));

for i=1:size(Mat,2)
    for j=i+1:size(Mat,2)
        valX=Mat(:,i);
        valY=Mat(:,j);
        levelx=max(valX)/th;
        levely=max(valY)/th;
        [rtemp,ptemp]=corrcoef(valX(find(valX>levelx|valY>levely)),valY(find(valX>levelx|valY>levely)));
        rc(i,j)=rtemp(2,1);
        pc(i,j)=ptemp(2,1);
    end

end

rc=rc+rc';
for i=1:length(rc)
    rc(i,i)=max(max(rc));
end
pc=pc+pc';
