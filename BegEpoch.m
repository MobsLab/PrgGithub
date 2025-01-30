function EpCell=BegEpoch(Epoch,dur)
 str=start(Epoch);
 stp=Stop(Epoch);
newstr=[];
newstp=[];
 
 for i=1:length(str)
newstr(i)=str(i);
newstp(i)=str(i)+dur;
  end
   
 EpCell=cell(1,3);
    EpCell=intervalSet(newstr,newstp);
 
end
