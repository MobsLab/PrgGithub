

load SpikeData
load behavResources

Epoch1=intervalSet(tpsdeb{1}*1E4,tpsfin{1}*1E4);

X1=Restrict(X,Epoch1);
Y1=Restrict(Y,Epoch1);
S1=Restrict(S,Epoch1);

stim1=Restrict(stim,Epoch1);

[data,indices] = GetWidebandData(1);
Wide1=tsd(data(:,1)*1E4,data(:,2));
Wide1=Restrict(Wide1,Epoch1);
figure, [fh, rasterAx, histAx, matVal] = ImagePETH(Wide1, stim1, -20, +20,'BinSize',1);

M=Data(matVal)';

le=size(M,1);
si=size(M,2);

M2=[zeros(le,32)];

for i=1:le
  try   
[ME,id]=min(M(i,:));    
M2(i,1:32)=M(i,id-13:id+18);
  end
end

[ME,id2]=sort(M2(:,15));
M3=M2(id2(1:2000),:)/2;

figure('color',[1 1 1]), imagesc(M3), caxis([-1E4 1E4])

n=5;
figure('color',[1 1 1]), hold on
plot(mean(M3),'r','linewidth',2)
plot(std(M3)+mean(M3),'r')
plot(-std(M3)+mean(M3),'r')
plot(mean(squeeze(W{n}(:,1,:))),'k','linewidth',2)
plot(mean(squeeze(W{n}(:,1,:)))+std(squeeze(W{n}(:,1,:))),'k')
plot(mean(squeeze(W{n}(:,1,:)))-std(squeeze(W{n}(:,1,:))),'k')


