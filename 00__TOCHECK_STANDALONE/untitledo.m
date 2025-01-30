
load behavResources

clu=load('ICSS-Mouse-26-18012012.clu.1');
spk=GetSpikes([1 -1]);
clu(1)=[];

Epoch=intervalSet(tpsdeb{1}*1E4,tpsfin{2}*1E4);
stim1=Restrict(stim,Epoch);
st=Range(stim1,'s');



 ID=[];
clear id
 for i=1:length(st)
    clear id
    id=find(abs(st(i)-spk)<0.002);
    ID=[ID;[id spk(id) i*ones(length(id),1) length(id)*ones(length(id),1)]];
 end
 figure, hist(clu(ID(:,1)),100)
 
 

w1 = GetSpikeWaveforms([1 0],'intervals',[Start(Epoch,'s') End(Epoch,'s')]);

w4 = GetSpikeWaveforms([1 4],'intervals',[Start(Epoch,'s') End(Epoch,'s')]);

