function C=GravityCenter(M)

[rc,cc]=ndgrid(1:size(M,1),1:size(M,2));
Mt=sum(M(:));
c1=sum(M(:).*rc(:))/Mt;
c2=sum(M(:).*cc(:))/Mt;

C=[c2,c1];
