function [Prop,vX]=CompPropEpoch(Ep,plo,Epnames)


try 
    plo;
catch
    plo=0;
end

Prop=zeros(length(Ep),length(Ep));

for i=1:length(Ep)
    for j=1:length(Ep)
    if i==j
        Prop(i,j)=sum(End(Ep{i},'s')-Start(Ep{i},'s'));
        
    else
        Prop(i,j)=sum(End(and(Ep{i},Ep{j}),'s')-Start(and(Ep{i},Ep{j}),'s'));
    end
     
    end

end

if plo
 
figure('color',[1 1 1]),
subplot(2,1,1), imagesc(log(Prop)), colorbar
subplot(2,1,2), imagesc(Prop/sum(diag(Prop))*100), colorbar
end



vX(1)=sum(End(Ep{1},'s')-Start(Ep{1},'s'));
vX(2)=sum(End(and(Ep{1},Ep{2}),'s')-Start(and(Ep{1},Ep{2}),'s'));
vX(3)=sum(End(Ep{2},'s')-Start(Ep{2},'s'));
try
vX(4)=sum(End(and(Ep{2},Ep{3}),'s')-Start(and(Ep{2},Ep{3}),'s'));
vX(5)=sum(End(Ep{3},'s')-Start(Ep{3},'s'));
vX(6)=sum(End(and(Ep{1},Ep{3}),'s')-Start(and(Ep{1},Ep{3}),'s'));
vX(7)=sum(End(and(Ep{1},and(Ep{2},Ep{3})),'s')-Start(and(Ep{1},and(Ep{2},Ep{3})),'s'));
end
if length(Ep)<4
vennX(vX/sum(diag(Prop))*100,0.1)
end
