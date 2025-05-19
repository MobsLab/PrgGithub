function [Mo,Mf,Ms,id]=ReordPCA(M,idx,idd)

C=corrcoef(M(:,idx)');
C(isnan(C))=0;
[V,L]=pcacov(C);
pc1=V(:,1);
[BE,id]=sort(pc1);

try
    idd;
    Mf=M(id(idd,:),:);
catch
    
    if median(pc1)>0
        Mf=M(id(floor(length(id)/3):end),:);  
        Ms=M;
        Ms(id(1:floor(length(id)/3)),:)=[];
    else
        Mf=M(id(1:floor(2*length(id)/3)),:);   
        Ms=M;
        Ms(id(floor(2*length(id)/3):end),:)=[];   
    end
end

Mo=M(id,:);


