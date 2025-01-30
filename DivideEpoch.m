function EpCell=DivideEpoch(Epoch,num)
 str=start(Epoch);
 stp=Stop(Epoch);
 dur=stp-str;
newstr=[];
newstp=[];
 
 for i=1:length(str)
 delt=dur(i)/num;
 for k=1:num
newstr(k,i)=str(i)+(k-1)*delt;
newstp(k,i)=str(i)+k*delt;
 end
 end
   
 EpCell=cell(1,num);
 for k=1:num
    EpCell{1,k}=intervalSet(newstr(k,:),newstp(k,:));
 end
 
end
