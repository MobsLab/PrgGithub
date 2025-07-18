%NbNeuronsDownStatesIdentifiation

try
    ch;
catch
    ch=1;
end

LoadNeuronPFCx

idMUA=[];a=1;
for i=NumNeurons
    if cellnames{i}(end)=='1'&cellnames{i}(end-1)=='c';
        idMUA=[idMUA i];
        a=a+1;
    end
end
NumNeurons(idMUA)=[];

clear dd
a=1;
for i=NumNeurons
dd(a)=length(Range(Restrict(S{i},SWSEpoch)));
a=a+1;
end

[BE,idd]=sort(dd);
idd=idd(end:-1:1);

clear D

for i=1:length(NumNeurons)   
    %[Down,Qt,B,h1,b1,h2,b2,h3,b3,h4,b4]=FindDown(S,NumNeurons(idd(1:i)),SWSEpoch,10,0.01,1,0,[0 70],1);close
    if ch
        [Down,Qt,B,h1,b1,h2,b2,h3,b3,h4,b4]=FindDown(S,NumNeurons(idd(1:i)),SWSEpoch,10,0.01,1,0,[0 70],1);
    else
        [Down,Qt,B,h1,b1,h2,b2,h3,b3,h4,b4]=FindDown(S,NumNeurons(idd(1:i)),SWSEpoch,10,0.02,1,5,[20 70],1);
    end
    D(i,1)=length(Start(and(Down,SWSEpoch)));
    D(i,2)=length(Range(Restrict(PoolNeurons(S,NumNeurons(idd(1:i))),SWSEpoch)));
end



figure('color',[1 1 1]), plotyy(1:length(D),D(:,1),1:length(D),D(:,2))




