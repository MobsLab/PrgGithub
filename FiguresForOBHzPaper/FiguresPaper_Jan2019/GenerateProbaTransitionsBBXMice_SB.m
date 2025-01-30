% Thsi code imitates GenerateProbaTransitionsOptoMice_SB
clear all
close all

% Get the data location
Dir_All.All{1} = PathForExperimentFEAR('ManipFeb15Bulbectomie','fear');
Dir_All.Ext{1} = RestrictPathForExperiment(Dir_All.All{1},'Session','EXT-24h-envC');
Dir_All.Hab{1} = RestrictPathForExperiment(Dir_All.All{1},'Session','HAB-envC');

% these mice extinguished in the plethysmograph so we're using 48hrs
Dir_All.All{2} = PathForExperimentFEAR('ManipDec14Bulbectomie','fear');
Dir_All.Ext{2} = RestrictPathForExperiment(Dir_All.All{2},'Session','EXT-48h-envB')
Dir_All.Hab{2} = RestrictPathForExperiment(Dir_All.All{2},'Session','HAB-envA')

Dir = MergePathForExperiment(Dir_All.Ext{1},Dir_All.Ext{2});

obxmice = find(~cellfun(@isempty,strfind(Dir.group,'OBX')));
shammice= find(~cellfun(@isempty,strfind(Dir.group,'CTRL')));

EndSessionTime = 2000;

%% distribution
% if 1
load('/media/DataMOBsRAIDN/ProjetAversion/OptoFear/Fear_Mar2-July-Oct2017/EXT-24_fullperiod_close2sound_acc_epochs','CsminPer','CspluPer0','CspluPer1','CspluPer2','CspluPer3','NosoundNoLaserPer','NosoundWithLaserPer','csm','csp','CSplInt','CSmiInt')

EPOI_All = {CsminPer,CspluPer0,CspluPer1,CspluPer2,CspluPer3};

for stepsize = 2% [0.5,1,1.5,2,3,4]
    for k=1:3
        if k==1
            EPOI = CsminPer;
        elseif k==2
            EPOI = CspluPer0;
        elseif k==3
            EPOI = intervalSet(0*1e4,EndSessionTime*1e4);
        end
        
        a=1;
        for man=shammice
            
            cd(Dir.path{(man)})
            clear Movtsd FreezeEpoch
            try, load('behavResources.mat');catch,load('Behavior.mat'); end
            TotEpoch = intervalSet(0,max(Range(Movtsd)));
            FreezeEpoch = mergeCloseIntervals(FreezeEpoch,2*1e4);
            FreezeEpoch = dropShortIntervals(FreezeEpoch,2*1e4);

            tps = [0:stepsize:EndSessionTime]*1e4;
            FakeData = tsd((tps),[1:length(tps)]');
            
            BinData_FZ_ind = Data(Restrict(FakeData,FreezeEpoch));
            BinData_FZ_val = zeros(1,length(tps));
            BinData_FZ_val(BinData_FZ_ind)=1;
            BinData_FZ_val_Change=diff(BinData_FZ_val);
            BinData_FZ_val(end)=[];
            
            BinData_FZ_val_Change = Data(Restrict(tsd(tps(1:end-1),BinData_FZ_val_Change'),EPOI));
            BinData_FZ_val = Data(Restrict(tsd(tps(1:end-1),BinData_FZ_val'),EPOI));
            
            StayAct_SHAM(a,k) = sum(BinData_FZ_val==0 & BinData_FZ_val_Change==0)/sum(BinData_FZ_val==0);
            ChangeAct_SHAM(a,k) = sum(BinData_FZ_val==0 & BinData_FZ_val_Change==1)/sum(BinData_FZ_val==0);
            StayFz_SHAM(a,k)= sum(BinData_FZ_val==1 & BinData_FZ_val_Change==0)/sum(BinData_FZ_val==1);
            ChangeFz_SHAM(a,k) = sum(BinData_FZ_val==1 & BinData_FZ_val_Change==-1)/sum(BinData_FZ_val==1);
            
            %             FreqInit_SHAM(a,k)=sum(BinData_FZ_val==0 & BinData_FZ_val_Change==1)./(length(BinData_FZ_val)*stepsize);
            %             PercFz_SHAM(a,k)=sum(BinData_FZ_val==1)./length(BinData_FZ_val);
            TotEpDur = nansum(Stop(EPOI,'s')-Start(EPOI,'s'));
            TotFzDur = nansum(Stop(and(EPOI,FreezeEpoch),'s')-Start(and(EPOI,FreezeEpoch),'s'));
            FreqInit_SHAM(a,k)=length(Stop(and(EPOI,FreezeEpoch),'s'))/TotEpDur;
            PercFz_SHAM(a,k)=TotFzDur/TotEpDur;
            
            LittleFreezeEpoch = and(EPOI,FreezeEpoch);
            LittleFreezeEpoch = dropShortIntervals(LittleFreezeEpoch,2*1e4); % some episodes are truncated by the restriction drop them
            DurFzEp_SHAM(a,k)=nanmean(Stop(LittleFreezeEpoch,'s')-Start(LittleFreezeEpoch,'s'));
            DistribFzEpisodes_SHAM{a,k} = (Stop(LittleFreezeEpoch,'s')-Start(LittleFreezeEpoch,'s'));

            ActEpoch = and(EPOI,intervalSet(0,EndSessionTime*1e4)-FreezeEpoch);
            DurActEp_SHAM(a,k)=nanmean(Stop(ActEpoch,'s')-Start(ActEpoch,'s'));
            
            DistribActEpisodes_SHAM{a,k} = Stop(ActEpoch,'s')-Start(ActEpoch,'s');

       

            
            a=a+1;
        end
        
        
        a=1;
        for man=obxmice
            
            cd(Dir.path{(man)})
            clear Movtsd FreezeEpoch
            try, load('behavResources.mat');catch,load('Behavior.mat'); end
            TotEpoch = intervalSet(0,max(Range(Movtsd)));
            FreezeEpoch = mergeCloseIntervals(FreezeEpoch,2*1e4);
            FreezeEpoch = dropShortIntervals(FreezeEpoch,2*1e4);

            tps = [0:stepsize:EndSessionTime]*1e4;
            FakeData = tsd((tps),[1:length(tps)]');
            
            BinData_FZ_ind = Data(Restrict(FakeData,FreezeEpoch));
            BinData_FZ_val = zeros(1,length(tps));
            BinData_FZ_val(BinData_FZ_ind)=1;
            BinData_FZ_val_Change=diff(BinData_FZ_val);
            BinData_FZ_val(end)=[];
            
            BinData_FZ_val_Change = Data(Restrict(tsd(tps(1:end-1),BinData_FZ_val_Change'),EPOI));
            BinData_FZ_val = Data(Restrict(tsd(tps(1:end-1),BinData_FZ_val'),EPOI));
            
            StayAct_BBX(a,k) = sum(BinData_FZ_val==0 & BinData_FZ_val_Change==0)/sum(BinData_FZ_val==0);
            ChangeAct_BBX(a,k) = sum(BinData_FZ_val==0 & BinData_FZ_val_Change==1)/sum(BinData_FZ_val==0);
            StayFz_BBX(a,k)= sum(BinData_FZ_val==1 & BinData_FZ_val_Change==0)/sum(BinData_FZ_val==1);
            ChangeFz_BBX(a,k) = sum(BinData_FZ_val==1 & BinData_FZ_val_Change==-1)/sum(BinData_FZ_val==1);
            
            %FreqInit_BBX(a,k)=sum(BinData_FZ_val==0 & BinData_FZ_val_Change==1)./(length(BinData_FZ_val)*stepsize);
            %PercFz_BBX(a,k)=sum(BinData_FZ_val==1)./length(BinData_FZ_val);
            TotEpDur = nansum(Stop(EPOI,'s')-Start(EPOI,'s'));
            TotFzDur = nansum(Stop(and(EPOI,FreezeEpoch),'s')-Start(and(EPOI,FreezeEpoch),'s'));
            
            FreqInit_BBX(a,k)=length(Stop(and(EPOI,FreezeEpoch),'s'))/TotEpDur;
            PercFz_BBX(a,k)=TotFzDur/TotEpDur;

            LittleFreezeEpoch = and(EPOI,FreezeEpoch);
            LittleFreezeEpoch = dropShortIntervals(LittleFreezeEpoch,2*1e4); % some episodes are truncated by the restriction drop them
            DurFzEp_BBX(a,k)=nanmean(Stop(LittleFreezeEpoch,'s')-Start(LittleFreezeEpoch,'s'));
            DistribFzEpisodes_BBX{a,k} = (Stop(LittleFreezeEpoch,'s')-Start(LittleFreezeEpoch,'s'));
            
            ActEpoch = and(EPOI,intervalSet(0,EndSessionTime*1e4)-FreezeEpoch);
            DurActEp_BBX(a,k)=nanmean(Stop(ActEpoch,'s')-Start(ActEpoch,'s'));
            DistribActEpisodes_BBX{a,k} = Stop(ActEpoch,'s')-Start(ActEpoch,'s');

            
            a=a+1;
        end
        
        
    end
    
    save(['/home/vador/Dropbox/Mobs_member/SophieBagur/Figures/BilnJan2019_OB4HzPaper/DataFzingStatesBBX_' num2str(stepsize),'.mat'],...
        'DurActEp_BBX','DurFzEp_BBX','PercFz_BBX','FreqInit_BBX','StayAct_BBX','ChangeAct_BBX','StayFz_BBX','ChangeFz_BBX','DistribFzEpisodes_BBX','DistribActEpisodes_BBX',...
        'DurActEp_SHAM','DurFzEp_SHAM','PercFz_SHAM','FreqInit_SHAM','StayAct_SHAM','ChangeAct_SHAM','StayFz_SHAM','ChangeFz_SHAM','DistribFzEpisodes_SHAM','DistribActEpisodes_SHAM')
end