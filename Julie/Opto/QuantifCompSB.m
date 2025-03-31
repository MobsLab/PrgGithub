clear all, close all
CSoption = '4firstCS not averaged';
disp ('CSoption = 4firstCS not averaged')


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%  INPUTS  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

experiment= 'Fear-electrophy-opto';
manipname='LaserChR2-fear';


cd /media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/
res=pwd;
Dir=PathForExperimentFEAR('Fear-electrophy-opto');
Dir = RestrictPathForExperiment(Dir,'nMice',[363 367 458 459]);
[nameMice, IXnameMice]=unique(Dir.name);

lim=160; % nb bins
bi=1000; % bin size
smo=1;
plo=1;
sav=1;

FolderPath='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/';

StepName={'EXT-24';'EXT-48';'EXT-72'};
%ColorPSTH={ [0.3 0 0],[1 0 0],[0 0 1]};% [1 0.5 0]
ColorPSTH={ [0.7 0.7 1],[1 0 0],[0 0 1],[1 0.7 0.7]};% [1 0.5 0]

% group CS+=bip
CSplu_bip_GpNb=[];
CSplu_bip_Gp={};
for k=1:length(CSplu_bip_GpNb)
    CSplu_bip_Gp{k}=num2str(CSplu_bip_GpNb(k));
end
CSplu_bip_Gp=CSplu_bip_Gp';

% group CS+=WN
CSplu_WN_GpNb=[363 367 458 459];
CSplu_WN_Gp={};
for k=1:length(CSplu_WN_GpNb)
    CSplu_WN_Gp{k}=num2str(CSplu_WN_GpNb(k));
end
CSplu_WN_Gp=CSplu_WN_Gp';

GoodSession=[1,4,10,16]
FzThresh=0.2*1e8;
MergeLitEp=0.5;
i=1;
Mousename='MXXX';
fig=figure;
for man=1:4
    
    Mousename=['M' Dir.name{GoodSession(man)}(end-2:end)];
    disp(Mousename)
    
    cd ([Dir.path{GoodSession(man)}])
    Dir.path{GoodSession(man)}
    load ('behavResources.mat', 'MovAcctsd','TTL')
    
    for l=33:35
        load(['LFPData/LFP',num2str(l),'.mat']);
        if l==33
            Accttsd=tsd(Range(LFP),Data(LFP).^2);
        else
            Accttsd=tsd(Range(LFP),Data(Accttsd)+Data(LFP).^2);
            
        end
    end
    Rg=Range(Accttsd);
    MovAcctsd=Data(Accttsd);
    Accttsd=tsd(Rg(1:25:end),SmoothDec(double(abs([0;diff(MovAcctsd(1:25:end))])),3));
     DiffTimes=diff(TTL(:,1));
    ind=DiffTimes>2;
    times=TTL(:,1);
    event=TTL(:,2);
    CStimes=times([1; find(ind)+1]);  %temps du premier TTL de chaque s�rie de son
    CSevent=event([1; find(ind)+1]);  %valeur du premier TTL de chaque s�rie de son (CS+ ou CS-)
    
    %d�finir CS+ et CS- selon les groupes
    m=Mousename(2:4);
    if sum(strcmp(num2str(m),CSplu_bip_Gp))==1
        CSpluCode=4; %bip
        CSminCode=3; %White Noise
    elseif sum(strcmp(num2str(m),CSplu_WN_Gp))==1
        CSpluCode=3;
        CSminCode=4;
    end
    
if man==1
    csp=CStimes(CSevent==CSpluCode);
    csm=CStimes(CSevent==CSminCode);
end
    laserstarts=TTL(TTL(:,2)==6,1);
    lasercsp=[2,4,6,8];
    lasercsm=[2,4];
    
    FreezeEpoch=thresholdIntervals(Accttsd,FzThresh,'Direction','Below');
    FreezeEpoch=mergeCloseIntervals(FreezeEpoch,MergeLitEp*1e4);
    FreezeEpoch=dropShortIntervals(FreezeEpoch,2*1e4);
    subplot(4,1,man)
    plot(Range(Accttsd,'s'),Data(Accttsd))
    hold on
    for k=1:length(Start(FreezeEpoch))
        plot(Range(Restrict(Accttsd,subset(FreezeEpoch,k)),'s'),Data(Restrict(Accttsd,subset(FreezeEpoch,k))),'c')
    end
    plot(csp,2*1e8,'*')
    xlim([350 800])
    
    
   
    
    load('ChannelsToAnalyse/PFCx_deep_left.mat')
    load(['SpectrumDataL/Spectrum',num2str(channel),'.mat'])
    SptsdL=tsd(t*1e4,Sp);
    
    load('ChannelsToAnalyse/PFCx_deep_right.mat')
    load(['SpectrumDataL/Spectrum',num2str(channel),'.mat'])
    SptsdR=tsd(t*1e4,Sp);

    
    CSSndEpoch=intervalSet([csm;csp]*1e4,[csm;csp]*1e4+30*1e4);
    for k=1:length([csm;csp])
        FzTimeSnd(k,man)=length(Data(Restrict(LFP,and(subset(CSSndEpoch,k),FreezeEpoch))))./...
            length(Data(Restrict(LFP,subset(CSSndEpoch,k))));
        MeanSpecSnd{k,1}(man,:)=mean(Data(Restrict(SptsdR,subset(CSSndEpoch,k))));
        MeanSpecSnd{k,2}(man,:)=mean(Data(Restrict(SptsdL,subset(CSSndEpoch,k))));
        
    end
    
    CSSilEpoch=intervalSet([csm;csp]*1e4+30*1e4,[csm;csp]*1e4+60*1e4);
    for k=1:length([csm;csp])
        FzTimeSil(k,man)=length(Data(Restrict(LFP,and(subset(CSSilEpoch,k),FreezeEpoch))))./...
            length(Data(Restrict(LFP,subset(CSSilEpoch,k))));
        MeanSpecSil{k,1}(man,:)=mean(Data(Restrict(SptsdR,subset(CSSilEpoch,k))));
        MeanSpecSil{k,2}(man,:)=mean(Data(Restrict(SptsdL,subset(CSSilEpoch,k))));
    end
   

    
end
SaveLoc='/home/vador/Dropbox/Mobs_member/SophiePhD/PresentationSB/Mi-thèse/FreezingOptoBis/'
saveas(fig,[SaveLoc,'DataBrut','merge',num2str(MergeLitEp),'thresh',num2str(FzThresh),'.png'])
saveas(fig,[SaveLoc,'DataBrut','merge',num2str(MergeLitEp),'thresh',num2str(FzThresh),'.fig'])
close all
% Get rid of third mouse, 8th sound
FzTimeSnd(8:end,3)=NaN;
FzTimeSil(8:end,3)=NaN;
for k=1:2
    for i=8:12
        MeanSpecSnd{i,k}(3,:)=NaN(1,261);
    end
end
% Get rid of fourth mouse, all but first six sounds are bad
FzTimeSnd(7:end,4)=NaN;
FzTimeSil(7:end,4)=NaN;
for k=1:2
    for i=7:12
        MeanSpecSnd{i,k}(4,:)=NaN(1,261);
    end
end

fig=figure;
subplot(211)
PlotErrorBarN(FzTimeSnd',0,0)
set(gca,'XTick',[2.5,6.5],'XTickLabel',{'CS-','CS+'})
for k=1:4
line([1.5 2.5]+(k-1)*2,[1 1],'color','c','linewidth',3)
end
title('sound')
ylabel('% fz')
ylim([0 1])
% xlim([0 8.5])
subplot(212)
PlotErrorBarN(FzTimeSil',0,0)
set(gca,'XTick',[2.5,6.5],'XTickLabel',{'CS-','CS+'})
% xlim([0 8.5])
for k=1:8
line([1.5 2.5]+(k-1)*2,[1 1],'color','c','linewidth',3)
end
title('postsound')
ylabel('% fz')
ylim([0 1])
saveas(fig,[SaveLoc,'FreezingLevels','merge',num2str(MergeLitEp),'thresh',num2str(FzThresh),'.png'])
saveas(fig,[SaveLoc,'FreezingLevels','merge',num2str(MergeLitEp),'thresh',num2str(FzThresh),'.fig'])
close all

fig=figure;
subplot(221)
g=shadedErrorBar(f,nanmean(MeanSpecSnd{5,1}),[stdError(MeanSpecSnd{5,1});stdError(MeanSpecSnd{5,1})]),hold on
g=shadedErrorBar(f,nanmean(MeanSpecSnd{6,1}),[stdError(MeanSpecSnd{6,1});stdError(MeanSpecSnd{6,1})],'b')
[val,ind]=max((MeanSpecSnd{5,1}(:,find(f>4,1,'first'):find(f>6,1,'first')))');
plot(f(ind+find(f>4,1,'first')),val,'k*')
QuantifSpec.R(1,:)=val;
[val,ind]=max((MeanSpecSnd{6,1}(:,find(f>4,1,'first'):find(f>6,1,'first')))');
plot(f(ind+find(f>4,1,'first')),val,'b*')
QuantifSpec.R(2,:)=val;
line([4 4],ylim)
line([6 6],ylim)
title('First pair, right')

subplot(222)
g=shadedErrorBar(f,nanmean(MeanSpecSnd{5,2}),[stdError(MeanSpecSnd{5,2});stdError(MeanSpecSnd{5,2})])
hold on
g=shadedErrorBar(f,nanmean(MeanSpecSnd{6,2}),[stdError(MeanSpecSnd{6,2});stdError(MeanSpecSnd{6,2})],'b')
[val,ind]=max((MeanSpecSnd{5,2}(:,find(f>4,1,'first'):find(f>6,1,'first')))');
plot(f(ind+find(f>4,1,'first')),val,'k*')
QuantifSpec.L(1,:)=val;
[val,ind]=max((MeanSpecSnd{6,2}(:,find(f>4,1,'first'):find(f>6,1,'first')))');
plot(f(ind+find(f>4,1,'first')),val,'b*')
QuantifSpec.L(2,:)=val;
line([4 4],ylim)
line([6 6],ylim)
title('First pair, Left')

subplot(223)
g=shadedErrorBar(f,nanmean(MeanSpecSnd{7,1}),[stdError(MeanSpecSnd{7,1});stdError(MeanSpecSnd{7,1})])
hold on
g=shadedErrorBar(f,nanmean(MeanSpecSnd{8,1}),[stdError(MeanSpecSnd{8,1});stdError(MeanSpecSnd{8,1})],'b')
[val,ind]=max((MeanSpecSnd{7,1}(:,find(f>4,1,'first'):find(f>6,1,'first')))');
plot(f(ind+find(f>4,1,'first')),val,'k*')
QuantifSpec.R(3,:)=val;
[val,ind]=max((MeanSpecSnd{8,1}(:,find(f>4,1,'first'):find(f>6,1,'first')))');
plot(f(ind+find(f>4,1,'first')),val,'b*')
QuantifSpec.R(4,:)=val;
line([4 4],ylim)
line([6 6],ylim)
title('Second pair, right')


subplot(224)
g=shadedErrorBar(f,nanmean(MeanSpecSnd{7,2}),[stdError(MeanSpecSnd{7,2});stdError(MeanSpecSnd{7,2})])
hold on
g=shadedErrorBar(f,nanmean(MeanSpecSnd{8,2}),[stdError(MeanSpecSnd{8,2});stdError(MeanSpecSnd{8,2})],'b')
[val,ind]=max((MeanSpecSnd{7,2}(:,find(f>4,1,'first'):find(f>6,1,'first')))');
plot(f(ind+find(f>4,1,'first')),val,'k*')
QuantifSpec.L(3,:)=val;
[val,ind]=max((MeanSpecSnd{8,2}(:,find(f>4,1,'first'):find(f>6,1,'first')))');
plot(f(ind+find(f>4,1,'first')),val,'b*')
QuantifSpec.L(4,:)=val;
line([4 4],ylim)
line([6 6],ylim)
title('Second pair, left')
saveas(fig,[SaveLoc,'Spectra','merge',num2str(MergeLitEp),'thresh',num2str(FzThresh),'.png'])
saveas(fig,[SaveLoc,'Spectra','merge',num2str(MergeLitEp),'thresh',num2str(FzThresh),'.fig'])
close all

fig=figure;
subplot(121)
PlotErrorBarN(QuantifSpec.R',0,0)
set(gca,'XTick',[1:4],'XtickLabel',{'1st - no stim','1st - stim','2nd - no stim','2nd - stim'})
title('right')
subplot(122)
PlotErrorBarN(QuantifSpec.L',0,0)
set(gca,'XTick',[1:4],'XtickLabel',{'1st - no stim','1st - stim','2nd - no stim','2nd - stim'})
title('left')
saveas(fig,[SaveLoc,'SpectraQuantif','merge',num2str(MergeLitEp),'thresh',num2str(FzThresh),'.png'])
saveas(fig,[SaveLoc,'SpectraQuantif','merge',num2str(MergeLitEp),'thresh',num2str(FzThresh),'.fig'])
close all


cd /media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161019-EXT-24h-laser10
load('/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161019-EXT-24h-laser10/LFPData/LFP31.mat')
LFPP=FilterLFP(LFP,[1 100],1024);
load('/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161019-EXT-24h-laser10/LFPData/LFP23.mat')
LFPH=FilterLFP(LFP,[1 100],1024);
load('/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161019-EXT-24h-laser10/LFPData/LFP18.mat')
LFPB=FilterLFP(LFP,[1 100],1024);
LitEp=intervalSet(690*1e4,710*1e4);
figure
plot(Range(Restrict(LFPB,LitEp),'s'),Data(Restrict(LFPB,LitEp))+6000,'b'), hold on
plot(Range(Restrict(LFPP,LitEp),'s'),Data(Restrict(LFPP,LitEp)),'r'), hold on
plot(Range(Restrict(LFPH,LitEp),'s'),Data(Restrict(LFPH,LitEp))-6000,'c'), hold on
line([698.6 698.6],ylim)
box off
clear AllSp
load('/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161019-EXT-24h-laser10/SpectrumDataL/Spectrum18.mat')
AllSp{1}=Sp;
load('/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161019-EXT-24h-laser10/SpectrumDataL/Spectrum31.mat')
AllSp{2}=Sp;
load('/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161019-EXT-24h-laser10/SpectrumDataL/Spectrum23.mat')
AllSp{3}=Sp;

for tt=1:3
    subplot(3,1,tt)
imagesc(t,f,log(AllSp{tt}')), axis xy
xlim([694 704])
line([698.6 698.6],ylim)
end