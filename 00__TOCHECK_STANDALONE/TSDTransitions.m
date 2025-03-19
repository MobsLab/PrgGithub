function [Out]=TSDTransitions(LFP,Epoch,sizedt)
% ouput is matrix of transition data

dat=Data(LFP);
%get times
s1=Start(Epoch);
if length(s1)<2
    Out=[];
else
    
    for k=1:length(s1)-1
        OutSt(k)=find(Range(LFP)>s1(k),1,'first');
    end
    
    % gamma get data
    a=OutSt'*ones(1,sizedt*2);
    b=a+([-sizedt+1:sizedt]'*ones(1,length(OutSt)))';
    [row,col]=find(b<0|b>size(dat,1));
    row=unique(row);
    if length(row)~=0
        for t=1:length(row)
            brows=[1:size(b,1)]; brows=brows(find(brows~=row(t)));
        end
        b=b(brows,:);
    end
    Out=reshape(dat(b),size(b,1),2*sizedt);
    
    
end
end




