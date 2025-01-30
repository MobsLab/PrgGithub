function [r,p,rc,pc]=PlaceFiledCorrealtionFor2(valX,valY,th)

try
th;
catch
th=4;
end


[r,p]=corrcoef(valX,valY);

levelx=max(valX)/th;
levely=max(valY)/th;

[rc,pc]=corrcoef(valX(find(valX>levelx|valY>levely)),valY(find(valX>levelx|valY>levely)));

r=r(1,2);
p=p(1,2);

rc=rc(1,2);
pc=pc(1,2);

