clear all
close all
%29.11.2017

cd  /media/DataMOBsRAIDN/ProjetAversion/OptoFear/Fear_Mar2-July-Oct2017
res=pwd;

load(['EXT-24_fullperiod_close2sound_acc2'], 'bilan','gfpmice','chr2mice','StepName', 'Dir','period','bilanMovAccSmotsd','optionfullper','bilanMovAccSmotsd','bilanFreezeAccEpoch',...
    'csm','csp','CSplInt','CSmiInt')
load('EXT-24_fullperiod_close2sound_acc_epochs','CsminPer','CspluPer0','CspluPer1','CspluPer2','CspluPer3','NosoundNoLaserPer','NosoundWithLaserPer','csm','csp','CSplInt','CSmiInt')
sav=0;
colori={[0 0 0]; [0 0.7 1]};
%% distribution
% if 1
maxlength=100;
pas=2;
EpisodeDurAllmice_gfp=[];
n=4;
h_cumsum=figure('Position',[ 88         537        1618         400]);
Xlabels={'2 CS- no laser';'2 CS+ no laser'; 'CS+ +laser';};
NbEp_gfp=nan(length(gfpmice),4);
NbEp_ch=nan(length(chr2mice),4);
MeanDurEp_gfp=nan(length(gfpmice),4);
MeanDurEp_ch=nan(length(chr2mice),4);
EpAboveTh_gfp=nan(length(gfpmice),4);
EpAboveTh_ch=nan(length(chr2mice),4);
PropEpAboveTh_gfp=nan(length(gfpmice),4);
PropEpAboveTh_ch=nan(length(chr2mice),4);

EndSessionTime = 1400;

DurTh=20;
EPOI_All = {CsminPer,CspluPer0,CspluPer1,CspluPer2,CspluPer3};

for stepsize = [0.5,1,1.5,2,3,4]
    for k=1:3
        if k==1
            EPOI = CsminPer;
        elseif k==2
            EPOI = CspluPer0;
        elseif k==3
            EPOI = CspluPer1;
        end
        
        a=1;
        for man=gfpmice
            tps = [0:stepsize:EndSessionTime]*1e4;
            FakeData = tsd((tps),[1:length(tps)]');
            
            BinData_FZ_ind = Data(Restrict(FakeData,bilanFreezeAccEpoch{man}));
            BinData_FZ_val = zeros(1,length(tps));
            BinData_FZ_val(BinData_FZ_ind)=1;
            BinData_FZ_val_Change=diff(BinData_FZ_val);
            BinData_FZ_val(end)=[];
            
            BinData_FZ_val_Change = Data(Restrict(tsd(tps(1:end-1),BinData_FZ_val_Change'),EPOI));
            BinData_FZ_val = Data(Restrict(tsd(tps(1:end-1),BinData_FZ_val'),EPOI));
            
            StayAct_GFP(a,k) = sum(BinData_FZ_val==0 & BinData_FZ_val_Change==0)/sum(BinData_FZ_val==0);
            ChangeAct_GFP(a,k) = sum(BinData_FZ_val==0 & BinData_FZ_val_Change==1)/sum(BinData_FZ_val==0);
            StayFz_GFP(a,k)= sum(BinData_FZ_val==1 & BinData_FZ_val_Change==0)/sum(BinData_FZ_val==1);
            ChangeFz_GFP(a,k) = sum(BinData_FZ_val==1 & BinData_FZ_val_Change==-1)/sum(BinData_FZ_val==1);
            
            %             FreqInit_GFP(a,k)=sum(BinData_FZ_val==0 & BinData_FZ_val_Change==1)./(length(BinData_FZ_val)*stepsize);
            %             PercFz_GFP(a,k)=sum(BinData_FZ_val==1)./length(BinData_FZ_val);
            TotEpDur = nansum(Stop(EPOI,'s')-Start(EPOI,'s'));
            TotFzDur = nansum(Stop(and(EPOI,bilanFreezeAccEpoch{man}),'s')-Start(and(EPOI,bilanFreezeAccEpoch{man}),'s'));
            FreqInit_GFP(a,k)=length(Stop(and(EPOI,bilanFreezeAccEpoch{man}),'s'))/TotEpDur;
            PercFz_GFP(a,k)=TotFzDur/TotEpDur;
            
            LittleFreezeEpoch = and(EPOI,bilanFreezeAccEpoch{man});
            LittleFreezeEpoch = dropShortIntervals(LittleFreezeEpoch,2*1e4); % some episodes are truncated by the restriction drop them
            DurFzEp_GFP(a,k)=nanmean(Stop(LittleFreezeEpoch,'s')-Start(LittleFreezeEpoch,'s'));
            DistribFzEpisodes_GFP{a,k} = (Stop(LittleFreezeEpoch,'s')-Start(LittleFreezeEpoch,'s'));

            ActEpoch = and(EPOI,intervalSet(0,EndSessionTime*1e4)-bilanFreezeAccEpoch{man});
            DurActEp_GFP(a,k)=nanmean(Stop(ActEpoch,'s')-Start(ActEpoch,'s'));
            
            DistribActEpisodes_GFP{a,k} = Stop(ActEpoch,'s')-Start(ActEpoch,'s');

       

            
            a=a+1;
        end
        
        
        a=1;
        for man=chr2mice
            
            tps = [0:stepsize:EndSessionTime]*1e4;
            FakeData = tsd((tps),[1:length(tps)]');
            
            BinData_FZ_ind = Data(Restrict(FakeData,bilanFreezeAccEpoch{man}));
            BinData_FZ_val = zeros(1,length(tps));
            BinData_FZ_val(BinData_FZ_ind)=1;
            BinData_FZ_val_Change=diff(BinData_FZ_val);
            BinData_FZ_val(end)=[];
            
            BinData_FZ_val_Change = Data(Restrict(tsd(tps(1:end-1),BinData_FZ_val_Change'),EPOI));
            BinData_FZ_val = Data(Restrict(tsd(tps(1:end-1),BinData_FZ_val'),EPOI));
            
            StayAct_CHR2(a,k) = sum(BinData_FZ_val==0 & BinData_FZ_val_Change==0)/sum(BinData_FZ_val==0);
            ChangeAct_CHR2(a,k) = sum(BinData_FZ_val==0 & BinData_FZ_val_Change==1)/sum(BinData_FZ_val==0);
            StayFz_CHR2(a,k)= sum(BinData_FZ_val==1 & BinData_FZ_val_Change==0)/sum(BinData_FZ_val==1);
            ChangeFz_CHR2(a,k) = sum(BinData_FZ_val==1 & BinData_FZ_val_Change==-1)/sum(BinData_FZ_val==1);
            
            %FreqInit_CHR2(a,k)=sum(BinData_FZ_val==0 & BinData_FZ_val_Change==1)./(length(BinData_FZ_val)*stepsize);
            %PercFz_CHR2(a,k)=sum(BinData_FZ_val==1)./length(BinData_FZ_val);
            TotEpDur = nansum(Stop(EPOI,'s')-Start(EPOI,'s'));
            TotFzDur = nansum(Stop(and(EPOI,bilanFreezeAccEpoch{man}),'s')-Start(and(EPOI,bilanFreezeAccEpoch{man}),'s'));
            
            FreqInit_CHR2(a,k)=length(Stop(and(EPOI,bilanFreezeAccEpoch{man}),'s'))/TotEpDur;
            PercFz_CHR2(a,k)=TotFzDur/TotEpDur;

            LittleFreezeEpoch = and(EPOI,bilanFreezeAccEpoch{man});
            LittleFreezeEpoch = dropShortIntervals(LittleFreezeEpoch,2*1e4); % some episodes are truncated by the restriction drop them
            DurFzEp_CHR2(a,k)=nanmean(Stop(LittleFreezeEpoch,'s')-Start(LittleFreezeEpoch,'s'));
            DistribFzEpisodes_CHR2{a,k} = (Stop(LittleFreezeEpoch,'s')-Start(LittleFreezeEpoch,'s'));
            
            ActEpoch = and(EPOI,intervalSet(0,EndSessionTime*1e4)-bilanFreezeAccEpoch{man});
            DurActEp_CHR2(a,k)=nanmean(Stop(ActEpoch,'s')-Start(ActEpoch,'s'));
            DistribActEpisodes_CHR2{a,k} = Stop(ActEpoch,'s')-Start(ActEpoch,'s');

            
            a=a+1;
        end
        
        
    end
    
    save(['/home/vador/Dropbox/Mobs_member/SophieBagur/BehaviourOptoDurationEvents/DataFzingStatesopto_' num2str(stepsize),'.mat'],...
        'DurActEp_CHR2','DurFzEp_CHR2','PercFz_CHR2','FreqInit_CHR2','StayAct_CHR2','ChangeAct_CHR2','StayFz_CHR2','ChangeFz_CHR2','DistribFzEpisodes_CHR2','DistribActEpisodes_CHR2',...
        'DurActEp_GFP','DurFzEp_GFP','PercFz_GFP','FreqInit_GFP','StayAct_GFP','ChangeAct_GFP','StayFz_GFP','ChangeFz_GFP','DistribFzEpisodes_GFP','DistribActEpisodes_GFP')
end