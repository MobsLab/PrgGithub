

function DigOUT=ConvertToTTL(DigIN)

for k=0:15
    a(k+1)=2^k;
end
for dd=1:length(DigIN)
    
    temp=DigIN(dd);
    binres=zeros(1,16);
    while temp>0
        binres(1,find(a<=temp,1,'last'))=1;
        temp=temp-a(find(a<=temp,1,'last'));
    end
    
    DigOUT(dd,:)=binres;
end
end


