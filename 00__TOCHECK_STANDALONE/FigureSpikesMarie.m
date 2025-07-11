% 
% try
% cd /media/DISK_1/Data1/ICSS-Sleep/Mouse017/20110622/ICSS-Mouse-17-22062011
% catch
% cd /media/Drobo2/DataD2/ICSS-Sleep/Mouse017/20110622/ICSS-Mouse-17-24062011
% end

k=6; %12 %... place cell used as a trigger defaul k=3;


load behavResources
load LFPData
load SpikeData



% Epoch1=intervalSet(0,1966*1E4); % Explo (spike detection)
% Epoch2=intervalSet(3374*1E4,4200*1E4); % sleep (spike detection)
% Epoch3=intervalSet(4200*1E4,5700*1E4); % ICSS sleep
% 



Epoch1=intersect(ExploEpoch,TrackingEpoch);
Epoch2=SleepEpoch;
% Epoch3=intervalSet(tpsdeb{8}*1E4,tpsfin{13}*1E4);
Epoch3=intervalSet(tpsdeb{4}*1E4,tpsfin{5}*1E4);


stim1=Restrict(stim,Epoch1); 
stim2=Restrict(stim,Epoch2);
stim3=Restrict(stim,Epoch3);

s2=Range(stim2);
s2b = burstinfo(s2/1E4,0.8);
stim2=ts(s2b.t_start*1E4);

s3=Range(stim3);
s3b = burstinfo(s3/1E4,0.8);
stim3=ts(s3b.t_start*1E4);

Epoch2good=Epoch2;
% Epoch2good=intervalSet(4120*1E4,4200*1E4); % sleep (spike detection)
%stim2=Restrict(stim,Epoch2good);

titl{1}='Explo (spike detection)';
titl{2}='sleep (spike detection)';
titl{3}='ICSS sleep';

binS=20; %default 30
len=100;

[C1,B1] = CrossCorr(Range(stim1), Range(stim1), 1,800); C1(B1==0)=0;
figure('color',[1 1 1]), [fh,sq,sweeps, rasterAx, histAx,dArea1] = RasterPETH(S{k}, stim1, -len*10, +len*10,'BinSize',binS);
%close

[C2,B2] = CrossCorr(Range(stim2), Range(stim2), 1,800); C2(B2==0)=0;
figure('color',[1 1 1]), [fh,sq,sweeps, rasterAx, histAx,dArea2] = RasterPETH(S{k}, stim2, -len*10, +len*10,'BinSize',binS);
%close

[C3,B3] = CrossCorr(Range(stim3), Range(stim3), 1,800); C3(B3==0)=0;
figure('color',[1 1 1]), [fh,sq,sweeps, rasterAx, histAx,dArea3] = RasterPETH(S{k}, stim3, -len*10, +len*10,'BinSize',binS);
%close


%tbin=3;
%nbbins=60;

tbin=8;
nbbins=80;

[Cstim,Bstim] = CrossCorr(Range(stim3), Range(stim3), tbin,nbbins); Cstim(Bstim==0)=0;
[Cspike1,Bspike1] = CrossCorr(Range(Restrict(S{k},Epoch1)), Range(Restrict(S{k},Epoch1)), tbin,nbbins); Cspike1(Bspike1==0)=0;
[Cspike2,Bspike2] = CrossCorr(Range(Restrict(S{k},Epoch2good)), Range(Restrict(S{k},Epoch2good)), tbin,nbbins); Cspike2(Bspike2==0)=0;
[Cspike3,Bspike3] = CrossCorr(Range(Restrict(S{k},Epoch3)), Range(Restrict(S{k},Epoch3)), tbin,nbbins); Cspike3(Bspike3==0)=0;

deb=Start(Epoch3,'s');
fin=End(Epoch3,'s');
deb2=Start(Epoch2,'s');
fin2=End(Epoch2,'s');

FRspike=length(Range(Restrict(S{k},Epoch3)))/(fin-deb)
FRspike2=length(Range(Restrict(S{k},Epoch2)))/(fin2-deb2)
FRstim=length(stim3)/(fin-deb)

figure('color',[1 1 1]), hold on, 
bar(Bspike3,Cspike3,1,'k'),title(['Autocorrelogramm stim vs ',cellnames{k},' ',titl{3}])
plot(Bstim,Cstim,'r','linewidth',2)
xlim([-tbin*nbbins/2 tbin*nbbins/2])

%------------------------------------------------------------------------------------------------------------------

figure('color',[1 1 1]), hold on, 
bar(Bspike3,Cspike3,1,'k'),title(['Autocorrelogramm  ',cellnames{k},' ',titl{2},' vs ',titl{3}])
plot(Bspike2,Cspike2,'r','linewidth',2)
xlim([-tbin*nbbins/2 tbin*nbbins/2])

Cspike3s=SmoothDec(Cspike3,0.8);
Cspike2s=SmoothDec(Cspike2,0.8);
Cspike3s(Bspike3==0)=0;
Cspike2s(Bspike2==0)=0;
figure('color',[1 1 1]), hold on, 
bar(Bspike3,Cspike3s,1,'k'),title(['Autocorrelogramm  ',cellnames{k},' ',titl{2},' vs ',titl{3}])
plot(Bspike2,Cspike2s,'r','linewidth',2)
xlim([-tbin*nbbins/2 tbin*nbbins/2])

%------------------------------------------------------------------------------------------------------------------


[Ccross,Bcross] = CrossCorr(Range(stim3), Range(Restrict(S{k},Epoch3)), tbin,nbbins); %Ccross(Bcross==0)=0;
figure('color',[1 1 1]), hold on, 
bar(Bcross,Ccross,1,'k'),title(['Crosscorrelogramm  ',cellnames{k},' vs stimulation'])
xlim([-tbin*nbbins/2+20 tbin*nbbins/2-20])
yl=ylim;
hold on, line([0 0],[0 yl(2)],'color','r')


% 
% tbinf=1;
% nbbinsf=40;
% % tbinf=8;
% % nbbinsf=80;
% 
% [Ccross,Bcross] = CrossCorr(Range(stim3), Range(Restrict(S{k},Epoch3)), tbinf,nbbinsf); %Ccross(Bcross==0)=0;
% figure('color',[1 1 1]), hold on, 
% bar(Bcross,Ccross,1,'k'),title(['Crosscorrelogramm  ',cellnames{k},' vs stimulation'])
% xlim([-tbinf*nbbinsf/2 tbinf*nbbinsf/2])
% yl=ylim;
% hold on, line([0 0],[0 yl(2)],'color','r')
% 


% figure('color',[1 1 1]), hold on
% plot(Bstim,Cstim,'k','linewidth',2)
% plot(Bspike1,Cspike1,'g','linewidth',1)
% plot(Bspike2,Cspike2,'r','linewidth',2)
% plot(Bspike3,Cspike3,'b','linewidth',2)
% 
% 
% figure('color',[1 1 1]), hold on, 
% bar(Bstim,Cstim,1,'k'),title(['stimulation'])
% figure('color',[1 1 1]), hold on, 
% bar(Bspike1,Cspike1,1,'k'),title([cellnames{k},' ',titl{1}])
% plot(Bstim,Cstim,'r','linewidth',2)
% xlim([-tbin*nbbins/2 tbin*nbbins/2])
% 
% figure('color',[1 1 1]), hold on, 
% bar(Bspike2,Cspike2,1,'k'),title([cellnames{k},' ',titl{2}])
% plot(Bstim,Cstim,'r','linewidth',2)
% xlim([-tbin*nbbins/2 tbin*nbbins/2])




tps=[-400:3:400];
tps=[-len:(2*len-1)/(length(dArea3)):len];
%tps=[-len:(length(dArea3)/(len-1)):len];
%tps=[-len:len];

id=(find(tps<0));
id=id(end-2:end);
id=id(end);%

dArea1b=dArea1;
dArea1b(id)=0;
dArea2b=dArea2;
dArea2b(id)=0;
dArea3b=dArea3;
dArea3b(id)=0;

% figure('color',[1 1 1]), hold on
% plot([-400:3:400],dArea1)
% plot([-400:3:400],dArea1b,'r')
% title([cellnames{k},' ',titl{1}])
% 
% figure('color',[1 1 1]), hold on
% plot([-400:3:400],dArea2)
% plot([-400:3:400],dArea2b,'r')
% title([cellnames{k},' ',titl{2}])
% 
% figure('color',[1 1 1]), hold on
% plot([-400:3:400],dArea3)
% plot([-400:3:400],dArea3b,'r')
% title([cellnames{k},' ',titl{3}])



figure('color',[1 1 1]), hold on
%plot([-400:3:400],dArea1b,'b')
bar([-len:binS/10:len],dArea2b,1,'k')
plot([-len:binS/10:len],dArea3b,'r','linewidth',2)
title(['PETH ',cellnames{k},' ',titl{2},' vs ',titl{3},' (ref=stimulation)'])
xlim([-len len])


