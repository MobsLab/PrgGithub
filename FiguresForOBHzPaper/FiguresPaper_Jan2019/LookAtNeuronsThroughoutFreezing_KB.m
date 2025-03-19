

Dir=PathForExperimentFEAR('Fear-electrophy','fear');

for i=1:length(Dir.path)
cd([Dir.path{i}])
clear FreezeEpoch
load behavResources FreezeEpoch 
 Nb(i,1)=i;
 Nb(i,3)=sum(End(FreezeEpoch,'s')-Start(FreezeEpoch,'s'));
Nb(i,4)=mean(End(FreezeEpoch,'s')-Start(FreezeEpoch,'s'));
Nb(i,5)=length(Start(FreezeEpoch,'s'));
clear S
try
load SpikeData S
Nb(i,2)=length(S);
catch
 Nb(i,2)=0;   
end
end


cd([Dir.path{38}])
load behavResources FreezeEpoch Movtsd
load SpikeData S


st=Start(FreezeEpoch);
to=End(FreezeEpoch);

dur=End(FreezeEpoch,'s')-Start(FreezeEpoch,'s');

clear Q
clear Qt1
clear Qt2
clear Qz
clear Qs
clear qz
clear ti
clear tit
clear til
clear tis


listshort=find(dur<10);
listlong=find(dur>10);

listshort=find(dur<15&dur>4);
listlong=find(dur>15);



bi=4000;binsize=30;

for i=1:length(st)
tit(i,:)=[st(i):(to(i)-st(i))/binsize:to(i)];
end

for k=1:length(listshort)
    i=listshort(k);
tis(k,:)=[st(i):(to(i)-st(i))/binsize:to(i)];
end

for k=1:length(listlong)
    i=listlong(k);
til(k,:)=[st(i):(to(i)-st(i))/binsize:to(i)];
end


ti=tis; 


Qs = MakeQfromS(S,bi);
qz=zscore(Data(Qs));
Qz=tsd(Range(Qs),qz);



Q=full(Data(Restrict(Qz,til(1,:)))');
Qt1=full(Data(Restrict(Qz,til(1,:)))');
Qt2=full(Data(Restrict(Qz,til(1,:))));
for i=2:size(til,1)   
Q=Q+full(Data(Restrict(Qz,til(i,:)))');       
Qt1=[Qt1;full(Data(Restrict(Qz,til(i,:))))'];
Qt2=[Qt2;full(Data(Restrict(Qz,til(i,:))))];
end


[r1,p1]=corrcoef(Qt1);
[r2,p2]=corrcoef(Qt2);
figure, 
subplot(1,2,1), imagesc(r1), caxis([-0.2 0.2])
subplot(1,2,2), imagesc(r2), caxis([-0.2 0.2])

