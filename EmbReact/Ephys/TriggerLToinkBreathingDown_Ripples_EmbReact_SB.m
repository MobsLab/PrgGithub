%%
clear all
SessNames={'SleepPreUMaze','SleepPostUMaze','SleepPreSound','SleepPostSound'};

MiceNumber=[490,507,508,509,510,512,514];
StructOfInterest = {'Bulb','EKG','Accelero'};

for ss=2:length(SessNames)
    Dir = PathForExperimentsEmbReact(SessNames{ss});
    
    for dd=13:length(Dir.path)
        if ismember(Dir.ExpeInfo{dd}{1}.nmouse,MiceNumber)
            for ddd=1:length(Dir.path{dd})
                cd(Dir.path{dd}{ddd})
                disp(Dir.path{dd}{ddd})
                delete('OBTriggeredOnDown.mat')
                
                load('DownState.mat')
                if exist('Ripples.mat')>0
                load('Ripples.mat')
                Ripples_ts = ts(Ripples(:,2)*10);
                end
                
                load('StateEpochSB.mat','TotalNoiseEpoch')
                
                DownStart_ts = ts(Start(down_PFCx));
                DownStop_ts = ts(Stop(down_PFCx));
                
                if exist('Ripples.mat')>0
                    EpochAroundRipples = intervalSet(Ripples(:,1)*10-0.5*1e4,Ripples(:,1)*10+0.5*1e4);
                    EpochAroundRipples = mergeCloseIntervals(EpochAroundRipples,0.1*1e4);
                    EpochAroundDown = intervalSet(Start(down_PFCx)-0.5*1e4,Stop(down_PFCx)+0.5*1e4);
                    EpochAroundDown = mergeCloseIntervals(EpochAroundDown,0.1*1e4);
                end
                                
                for st = 1:length(StructOfInterest)
                    try
                    channels = GetDifferentLocationStructure(StructOfInterest{st});
                    for ch = 1:length(channels)
                        
                        load(['LFPData/LFP' num2str(channels(ch))], 'LFP')
                        TotEpoch = intervalSet(0,max(Range(LFP)))-TotalNoiseEpoch;
                        
                        % All Down
                        [M,T] = PlotRipRaw(LFP,Range(Restrict(DownStart_ts,TotEpoch),'s'),2000,0,0);
                        TriggeredOnDownStart{ch} = T;
                        
                        [M,T] = PlotRipRaw(LFP,Range(Restrict(DownStop_ts,TotEpoch),'s'),2000,0,0);
                        TriggeredOnDownStop{ch} = T;
                        
                        % All Ripples
                        if exist('Ripples.mat')>0
                            [M,T] = PlotRipRaw(LFP,Range(Restrict(Ripples_ts,TotEpoch),'s'),2000,0,0);
                            TriggeredOnRipples{ch} = T;
                            
                            % Down no ripples
                            [M,T] = PlotRipRaw(LFP,Range(Restrict(DownStart_ts,TotEpoch-EpochAroundRipples),'s'),2000,0,0);
                            TriggeredOnDownStart_NoRip{ch} = T;
                            
                            [M,T] = PlotRipRaw(LFP,Range(Restrict(DownStop_ts,TotEpoch-EpochAroundRipples),'s'),2000,0,0);
                            TriggeredOnDownStop_NoRip{ch} = T;
                            
                            % Ripples no down
                            [M,T] = PlotRipRaw(LFP,Range(Restrict(Ripples_ts,TotEpoch-EpochAroundDown),'s'),2000,0,0);
                            TriggeredOnRipples_NoDown{ch} = T;
                            
                        else
                            TriggeredOnRipples{ch} = [];
                            TriggeredOnDownStart_NoRip{ch} = [];
                            TriggeredOnDownStop_NoRip{ch} = [];
                            TriggeredOnRipples_NoDown{ch} = [];
                            
                        end
                    end
                    
                    tps = M(:,1);
                    save([StructOfInterest{st} 'TriggeredOnDownandRipples.mat'],'channels','TriggeredOnRipples_NoDown','TriggeredOnDownStop_NoRip',...
                        'TriggeredOnDownStart_NoRip','TriggeredOnDownStop','TriggeredOnDownStart','TriggeredOnRipples','tps','-v7.3')
                    
                    clear channels TriggeredOnRipples_NoDown TriggeredOnDownStop_NoRip TriggeredOnDownStart_NoRip TriggeredOnDownStop TriggeredOnDownStart TriggeredOnRipples
                    end
                end
                clear DownStart_ts DownStop_ts Ripples_ts EpochAroundDown EpochAroundRipples Ripples down_PFCx

            end
        end
    end
end



%% Same with jitter
clear all
SessNames={'SleepPreUMaze','SleepPostUMaze','SleepPreSound','SleepPostSound'};

MiceNumber=[490,507,508,509,510,512,514];
StructOfInterest = {'Bulb','EKG','Accelero'};

for ss=1%length(SessNames)
    Dir = PathForExperimentsEmbReact(SessNames{ss});
    
    for dd=1:length(Dir.path)
        if ismember(Dir.ExpeInfo{dd}{1}.nmouse,MiceNumber)
            for ddd=1:length(Dir.path{dd})
                cd(Dir.path{dd}{ddd})
                disp(Dir.path{dd}{ddd})
                delete('OBTriggeredOnDown.mat')
                
                load('DownState.mat')
                if exist('Ripples.mat')>0
                load('Ripples.mat')
                Ripples_ts = ts(Ripples(:,2)*10);
                end
                
                load('StateEpochSB.mat','TotalNoiseEpoch')
                
                DownStart_ts = ts(Start(down_PFCx));
                DownStop_ts = ts(Stop(down_PFCx));
                
                if exist('Ripples.mat')>0
                    EpochAroundRipples = intervalSet(Ripples(:,1)*10-0.5*1e4,Ripples(:,1)*10+0.5*1e4);
                    EpochAroundRipples = mergeCloseIntervals(EpochAroundRipples,0.1*1e4);
                    EpochAroundDown = intervalSet(Start(down_PFCx)-0.5*1e4,Stop(down_PFCx)+0.5*1e4);
                    EpochAroundDown = mergeCloseIntervals(EpochAroundDown,0.1*1e4);
                end
                                
                for st = 1:length(StructOfInterest)
                    channels = GetDifferentLocationStructure(StructOfInterest{st});
                    for ch = 1:length(channels)
                        
                        load(['LFPData/LFP' num2str(channels(ch))], 'LFP')
                        TotEpoch = intervalSet(0,max(Range(LFP)))-TotalNoiseEpoch;
                        
                        % get the jittered times
                        if ch ==1
                            JitteredDeltaStart = Range(Restrict(DownStart_ts,TotEpoch));
                            JitteredDeltaStart = ts(sort(JitteredDeltaStart+rand(length(JitteredDeltaStart),1)*0.5*1e4));
                            
                            JitteredDeltaStop = Range(Restrict(DownStop_ts,TotEpoch));
                            JitteredDeltaStop = ts(sort(JitteredDeltaStop+rand(length(JitteredDeltaStop),1)*0.5*1e4));
                            
                            if exist('Ripples.mat')>0
                                JitteredRipples = Range(Restrict(Ripples_ts,TotEpoch));
                                JitteredRipples = ts(sort(JitteredRipples+rand(length(JitteredRipples),1)*0.5*1e4));
                            end
                        end
                            
                        % All Down
                        [M,T] = PlotRipRaw(LFP,Range(Restrict(JitteredDeltaStart,TotEpoch),'s'),2000,0,0);
                        TriggeredOnDownStart{ch} = T;
                        
                        [M,T] = PlotRipRaw(LFP,Range(Restrict(JitteredDeltaStop,TotEpoch),'s'),2000,0,0);
                        TriggeredOnDownStop{ch} = T;
                        
                        % All Ripples
                        if exist('Ripples.mat')>0
                            [M,T] = PlotRipRaw(LFP,Range(Restrict(JitteredRipples,TotEpoch),'s'),2000,0,0);
                            TriggeredOnRipples{ch} = T;
                            
                            % Down no ripples
                            [M,T] = PlotRipRaw(LFP,Range(Restrict(JitteredDeltaStart,TotEpoch-EpochAroundRipples),'s'),2000,0,0);
                            TriggeredOnDownStart_NoRip{ch} = T;
                            
                            [M,T] = PlotRipRaw(LFP,Range(Restrict(JitteredDeltaStop,TotEpoch-EpochAroundRipples),'s'),2000,0,0);
                            TriggeredOnDownStop_NoRip{ch} = T;
                            
                            % Ripples no down
                            [M,T] = PlotRipRaw(LFP,Range(Restrict(JitteredRipples,TotEpoch-EpochAroundDown),'s'),2000,0,0);
                            TriggeredOnRipples_NoDown{ch} = T;
                            
                        else
                            TriggeredOnRipples{ch} = [];
                            TriggeredOnDownStart_NoRip{ch} = [];
                            TriggeredOnDownStop_NoRip{ch} = [];
                            TriggeredOnRipples_NoDown{ch} = [];
                            
                        end
                    end
                    
                    tps = M(:,1);
                    save([StructOfInterest{st} 'TriggeredOnDownandRipplesJitter.mat'],'channels','TriggeredOnRipples_NoDown','TriggeredOnDownStop_NoRip',...
                        'TriggeredOnDownStart_NoRip','TriggeredOnDownStop','TriggeredOnDownStart','TriggeredOnRipples','tps','-v7.3')
                    
                    clear channels TriggeredOnRipples_NoDown TriggeredOnDownStop_NoRip TriggeredOnDownStart_NoRip TriggeredOnDownStop TriggeredOnDownStart TriggeredOnRipples
                    clear JitteredDeltaStop JitteredRipples JitteredDeltaStart
                     
                end
                clear DownStart_ts DownStop_ts Ripples_ts EpochAroundDown EpochAroundRipples Ripples down_PFCx

            end
        end
    end
end

%%%
clear all
SessNames={'SleepPreUMaze','SleepPostUMaze','SleepPreSound','SleepPostSound'};

MiceNumber=[490,507,508,509,510,512];
OBTriggeredOnDown_AllStart = [];
MouseAll = [];MouseAll_Ripples=[];
Chan_All_Ripples = []; Chan_All=[];
OBTriggeredOnDown_AllStop = [];
% OBHi_AllSlWk = [];
% OBLow_Sl = [];
% OBLow_Wk = [];
StructOfInterest = {'Bulb','EKG'};

for st = 1:length(StructOfInterest)
    
    TriggeredOnDownStart_All.(StructOfInterest{st}) = [];
    TriggeredOnDownStop_All.(StructOfInterest{st}) = [];
    TriggeredOnRipples_All.(StructOfInterest{st}) = [];
end

for ss=1%:length(SessNames)
    Dir = PathForExperimentsEmbReact(SessNames{ss});
    
    for dd=1:length(Dir.path)
        if ismember(Dir.ExpeInfo{dd}{1}.nmouse,MiceNumber)
            for ddd=1:length(Dir.path{dd})
                cd(Dir.path{dd}{ddd})
                disp(Dir.path{dd}{ddd})
                
                load('StateEpochSB.mat','Sleep','Wake','TotalNoiseEpoch')
                Wake = Wake -TotalNoiseEpoch;
                
                for st = 1:length(StructOfInterest)
                    
                    load([StructOfInterest{st} 'TriggeredOnDownandRipples.mat'])
                    
                    for chan = 1:length(channels)
                        TriggeredOnDownStart_All.(StructOfInterest{st}) = [TriggeredOnDownStart_All.(StructOfInterest{st});nanmean(TriggeredOnDownStart{chan})];
                        TriggeredOnDownStop_All.(StructOfInterest{st}) = [TriggeredOnDownStop_All.(StructOfInterest{st});nanmean(TriggeredOnDownStop{chan})];
                        try,
                            TriggeredOnRipples_All.(StructOfInterest{st}) = [TriggeredOnRipples_All.(StructOfInterest{st});nanmean(TriggeredOnRipples{chan})];
                        catch
                            TriggeredOnRipples_All.(StructOfInterest{st}) = [TriggeredOnRipples_All.(StructOfInterest{st});nan(1,5001)];

                        end
                    end
                    if st ==1
                        MouseAll = [MouseAll;channels*0+find(Dir.ExpeInfo{dd}{1}.nmouse==MiceNumber)];
                        Chan_All = [Chan_All;channels];
                        
                    end
                    
                end
                
                %
                %                 for chan = 1 :length(channels)
                %                    load(['AllOBSpectra/B',num2str(channels(chan)),'_High_Spectrum.mat'])
                %                     Sptsd_B = tsd(Spectro{2}*1e4,Spectro{1});
                %                     WakeSleep = nanmean(Data(Restrict(Sptsd_B,Wake)))-nanmean(Data(Restrict(Sptsd_B,Sleep)));
                %
                %                     load(['AllOBSpectra/B',num2str(channels(chan)),'_Low_Spectrum.mat'])
                %                     Sptsd_B = tsd(Spectro{2}*1e4,Spectro{1});
                %                     SleepLow = nanmean(Data(Restrict(Sptsd_B,Sleep)));
                %                     WakeLow = nanmean(Data(Restrict(Sptsd_B,Wake)));
                %
                %                     OBHi_AllSlWk = [OBHi_AllSlWk;WakeSleep];
                %                     OBLow_Sl = [OBLow_Sl;SleepLow];
                %                     OBLow_Wk = [OBLow_Wk;WakeLow];
                %                 end
                %
            end
        end
    end
end


[EigVect,EigVals]=PerformPCA(zscore(TriggeredOnDownStart_All.Bulb')');
[sorted,ind] = sortrows([EigVect(:,1),MouseAll,Chan_All])

subplot(321)
imagesc(tps,1:38,sortrows([EigVect(:,1),zscore(TriggeredOnDownStart_All.Bulb')']))
line([0 0],ylim,'color','k')
subplot(322)
plot(tps,(TriggeredOnDownStart_All.EKG))

subplot(323)
imagesc(tps,1:38,sortrows([EigVect(:,1),zscore(TriggeredOnDownStop_All.Bulb')']))
line([0 0],ylim,'color','k')
subplot(324)
plot(tps,(TriggeredOnDownStop_All.EKG))

subplot(325)
mat = sortrows([EigVect(:,1),zscore(TriggeredOnRipples_All.Bulb')']);
mat(find(sum(isnan(mat)')),:) = [];
imagesc(tps,1:38,mat)
subplot(326)
plot(tps,(TriggeredOnRipples_All.EKG))

%% example mouse
cd /media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170203/ProjectEmbReact_M508_20170203_SleepPre
load('BulbTriggeredOnDownandRipples.mat')
% load('BulbTriggeredOnDownandRipplesJitter.mat')

figure
subplot(131)
for ch = 1:8
plot(tps,runmean(nanmean(TriggeredOnDownStart{ch}),10),'linewidth',1.5), hold on
xlim([-1 1]), ylim([-1500 1000])
end

subplot(132)
for ch = 1:8
plot(tps,runmean(nanmean(TriggeredOnDownStop{ch}),10),'linewidth',1.5), hold on
xlim([-1 1]), ylim([-1500 1000])
end

subplot(133)
for ch = 1:8
plot(tps,runmean(nanmean(TriggeredOnRipples{ch}),10),'linewidth',1.5), hold on
xlim([-1 1]), ylim([-1500 1000])
end

load('EKGTriggeredOnDownandRipples.mat')
% load('EKGTriggeredOnDownandRipplesJitter.mat')

subplot(131)
plot(tps,runmean(nanmean(TriggeredOnDownStart{1}),10),'linewidth',3,'color','k','linestyle',':'), hold on
title('Down start')
xlabel('time to evt (s)')
box off
line([0 0],ylim,'color','k')
subplot(132)
plot(tps,runmean(nanmean(TriggeredOnDownStop{1}),10),'linewidth',3,'color','k','linestyle',':'), hold on
title('Down stop')
xlabel('time to evt (s)')
box off
line([0 0],ylim,'color','k')
subplot(133)
plot(tps,runmean(nanmean(TriggeredOnRipples{1}),10),'linewidth',3,'color','k','linestyle',':'), hold on
title('Ripple')
xlabel('time to evt (s)')
box off
line([0 0],ylim,'color','k')
legend({'OB','OB','OB','OB','OB','OB','OB','OB','EKG'})



FileName{1} = ('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170203/ProjectEmbReact_M508_20170203_SleepPre/RayleighFreqAnalysis/Rayleigh_BandWidth_REM_LFP51Spike.mat');
FileName{2} = ('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170203/ProjectEmbReact_M508_20170203_SleepPre/RayleighFreqAnalysis/Rayleigh_BandWidth_N3_LFP51Spike.mat');
FileName{3} = ('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170203/ProjectEmbReact_M508_20170203_SleepPre/RayleighFreqAnalysis/Rayleigh_BandWidth_N2_LFP51Spike.mat');
FileName{4} = ('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170203/ProjectEmbReact_M508_20170203_SleepPre/RayleighFreqAnalysis/Rayleigh_BandWidth_N1_LFP51Spike.mat');
FileName{5} = ('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170203/ProjectEmbReact_M508_20170203_SleepPre/RayleighFreqAnalysis/Rayleigh_BandWidth_Sleep_NoDown_LFP51Spike.mat');
FileName{6} = ('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170203/ProjectEmbReact_M508_20170203_UMazeCond/RayleighFreqAnalysis/Rayleigh_BandWidth_FreezingOnlyLocalBulb_left_ActivitySpike.mat')

FileName{1} = ('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170203/ProjectEmbReact_M508_20170203_SleepPre/RayleighFreqAnalysis/Rayleigh_BandWidth_REM_LocalBulb_left_ActivitySpike.mat');
FileName{2} = ('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170203/ProjectEmbReact_M508_20170203_SleepPre/RayleighFreqAnalysis/Rayleigh_BandWidth_N3_LocalBulb_left_ActivitySpike.mat');
FileName{3} = ('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170203/ProjectEmbReact_M508_20170203_SleepPre/RayleighFreqAnalysis/Rayleigh_BandWidth_N2_LocalBulb_left_ActivitySpike.mat');
FileName{4} = ('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170203/ProjectEmbReact_M508_20170203_SleepPre/RayleighFreqAnalysis/Rayleigh_BandWidth_N1_LocalBulb_left_ActivitySpike.mat');
FileName{5} = ('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170203/ProjectEmbReact_M508_20170203_SleepPre/RayleighFreqAnalysis/Rayleigh_BandWidth_Sleep_NoDown_LocalBulb_left_ActivitySpike.mat');
FileName{6} = ('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170203/ProjectEmbReact_M508_20170203_SleepPre/RayleighFreqAnalysis/Rayleigh_BandWidth_FreezingOnlyLocalBulb_left_ActivitySpike.mat');


figure
for ii = 1:6
    subplot(1,6,ii)
    load(FileName{ii})
    AllHs = zeros(18,40);
    
    [A,B] = strtok(FileName{ii},'_');
    for p =1:5
    [A,B] = strtok(B,'_');
    end
    
    for k = 1:99
        if sum(isnan(HS{k}))==0 & size((PhaseSpikes.Transf{k}),1)>100
            %     HS{k} = HS{k}./repmat(sum(HS{k}')',1,40);
            AllHs = AllHs + HS{k};
        end
    end
    AllHs = AllHs./sum(AllHs(:));
    imagesc([0:4*pi],mean(FilterBands),AllHs), axis xy
    xlabel('phase')
    clim([0.0012 0.0015])
    title(A)
end
subplot(1,6,1)
ylabel('FilterFrequency')

clf
for ii = 1:5
    load(FileName{ii})
    AllHs = zeros(18,40);
%     
    subplot(122)
    plot(mean(FilterBands),nanmean(ModInfo.pval.Transf'<0.05),'linewidth',2), hold on
    
%     subplot(122)
%     [row,col]= find(ModInfo.pval.Transf>0.05);
%     for g= 1:length(row)
%         ModInfo.Kappa.Transf(row(g),col(g)) = NaN;
%     end
%     plot(mean(FilterBands),nanmean(ModInfo.Kappa.Transf'),'linewidth',2), hold on
end
legend({'REM','N3','N2','N1','NoDown'})
