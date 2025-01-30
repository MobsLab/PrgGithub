function M=ReAlignMatrixMax(mHpc1a,idx,val)

[BE,id]=max(mHpc1a(:,idx)');
id=id+800;
for i=1:size(mHpc1a,1)
    test(i,:)=mHpc1a(i,id(i)-val:id(i)+val);
end
M=test;
