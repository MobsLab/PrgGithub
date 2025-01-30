function Mat=RemoveLignsMatrix(Mat,th)

id=[];
for i=1:size(Mat,1)
    
if length(find(abs(Mat(i,:))>th))==0    
    id=[id,i];
    
end
end


Mat=Mat(id,:);

