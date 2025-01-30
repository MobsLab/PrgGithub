%RipplesPrefrontalDown



%%
res=pwd;
try
    load SleepScoring_OBGamma SWSEpoch
    SWSEpoch;
catch  
    load StateEpochSB SWSEpoch
    SWSEpoch;
end

try
load SleepSubstages Epoch
N1=Epoch{1};
N2=Epoch{2};
N3=Epoch{3};
clear Epoch
end


%Epoch=SWSEpoch;
%Epoch=N2;

%%

load SpikeData S
load Ripples 

try
    Ripples;
    if exist('Epoch')
    rip=ts(Ripples(:,2)*10);
    rip=Restrict(rip,Epoch);
    clear Ripples
    Ripples(:,1)=Range(rip,'ms');
    Ripples(:,2)=Range(rip,'ms');
    end
catch
    if exist('Epoch')
    [test,idx]=Restrict(tRipples,Epoch);
    st=Start(RipplesEpoch,'ms');
    en=End(RipplesEpoch,'ms');
    Ripples(:,1)=st(idx);
    Ripples(:,3)=en(idx);
    Ripples(:,2)=Range(Restrict(tRipples,Epoch),'ms');
    else
    Ripples(:,1)=Start(RipplesEpoch,'ms');
    Ripples(:,3)=End(RipplesEpoch,'ms');
    Ripples(:,2)=Range(tRipples,'ms');
    end
end


try
    load DownState down_PFCx
end
load DeltaWaves deltas_PFCx

events=deltas_PFCx;

if exist('Epoch')
    events=and(events,Epoch);
end
    
list=zeros(size(Ripples,1),1);
lim=1;

for i=1:size(Ripples,1)
    temp1=abs(Ripples(i,2)/1E3-End(events,'s'));
    temp2=abs(Ripples(i,2)/1E3-Start(events,'s'));
    list(i,2)=min(min(temp1),min(temp2));
    if min(temp1)<lim
        list(i,1)=1;
    end
    if min(temp2)<lim
        list(i,1)=1;
    end
end

id=find(list(:,1)==0);

clear LFP
tempchHpc=load([res,'/ChannelsToAnalyse/dHPC_rip.mat'],'channel');
chHpc=tempchHpc.channel;
eval(['load(''',res,'','/LFPData/LFP',num2str(chHpc),'.mat'');'])
LFPh=LFP;
clear LFP

tempchPFCd=load([res,'/ChannelsToAnalyse/PFCx_deep.mat'],'channel');
chPFCxdeep=tempchPFCd.channel;
eval(['load(''',res,'','/LFPData/LFP',num2str(chPFCxdeep),'.mat'');'])
LFPp=LFP;
clear LFP

[Mh,Th]=PlotRipRaw_SB(LFPh,Ripples(:,2)/1E3,1000);close
[Mp,Tp]=PlotRipRaw_SB(LFPp,Ripples(:,2)/1E3,1000);close

for i=1:length(S)
    [c(i,:),b]=CrossCorr(Ripples(:,2)*10,Range(S{i}),10,200);
end


for i=1:length(S)
    [cc(i,:),b]=CrossCorr(Ripples(id,2)*10,Range(S{i}),10,200);
end
[Mhc,Thc]=PlotRipRaw_SB(LFPh,Ripples(id,2)/1E3,1000);close
[Mpc,Tpc]=PlotRipRaw_SB(LFPp,Ripples(id,2)/1E3,1000);close

cz=zscore(c')';
[BE,idx]=sort(mean(cz(:,100:104),2));

figure, 
subplot(3,2,1), hold on, plot(Mh(:,1),Mh(:,2),'b','linewidth',2), line([0 0],ylim,'color','r'), title(res)
subplot(3,2,3), hold on, plot(Mp(:,1),Mp(:,2),'k','linewidth',2), line([0 0],ylim,'color','r')
subplot(3,2,2), hold on, plot(Mpc(:,1),Mpc(:,2),'k','linewidth',2), line([0 0],ylim,'color','r')
subplot(3,2,5), hold on, 
plot(b/1E3,mean(c),'k','linewidth',2), line([0 0],ylim,'color','r')
plot(b/1E3,mean(cc),'r','linewidth',2), line([0 0],ylim,'color','r')

subplot(3,2,4), imagesc(b/1E3,1:length(S),zscore(c(idx,:)')'), axis xy, colorbar
subplot(3,2,6), imagesc(b/1E3,1:length(S),zscore(cc(idx,:)')'), axis xy, colorbar
