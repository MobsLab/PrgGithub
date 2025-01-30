clear all,% close all
%% INITIATION
%% DATA LOCALISATION
[Dir,KeepFirstSessionOnly]=GetRightSessionsFor4HzPaper('CtrlAllData_Beeps');
SaveFolder='/media/DataMOBsRAIDN/ProjetAversion/AnalysisStartStopFreezing_LinkWith4Hz/';
NumBins=30;
Smax=log(NumBins);
LFP_types = {'OB','PFCx','HPCRip','HPCDeep'}
for m=1:length(KeepFirstSessionOnly)
    %% Go to file location
    mm=KeepFirstSessionOnly(m);
    disp(Dir.path{mm})
    cd(Dir.path{mm})
    
    load('behavResources.mat')
    
    tps.CSP = BeepTimes.CSP(:);
    tps.CSM = BeepTimes.CSM(:);
    tps.CSP = tps.CSP(1:length(tps.CSM(:)));
    
    clear AllLFP
    load('ChannelsToAnalyse/Bulb_deep.mat')
    load(['LFPData/LFP',num2str(channel),'.mat'])
    AllLFP.(LFP_types{1}) = LFP;
    
    load('ChannelsToAnalyse/PFCx_deep.mat')
    load(['LFPData/LFP',num2str(channel),'.mat'])
    AllLFP.(LFP_types{2}) = LFP;
    
    if exist('ChannelsToAnalyse/dHPC_rip.mat')>0
        load('ChannelsToAnalyse/dHPC_rip.mat')
        if not(isempty(channel))
            load(['LFPData/LFP',num2str(channel),'.mat'])
            AllLFP.(LFP_types{3}) = LFP;
        else
            AllLFP.(LFP_types{3}) = [];
        end
    else
        AllLFP.(LFP_types{3}) = [];
    end
    
    if exist('ChannelsToAnalyse/dHPC_deep.mat')>0
        load('ChannelsToAnalyse/dHPC_deep.mat')
        if not(isempty(channel))
            load(['LFPData/LFP',num2str(channel),'.mat'])
            AllLFP.(LFP_types{4}) = LFP;
        else
            AllLFP.(LFP_types{4}) = [];
        end
    else
        AllLFP.(LFP_types{4}) = [];
    end
    
    for k = 1:4
        
        if not(isempty(AllLFP.(LFP_types{k})))
            
            [M,T] = PlotRipRaw(AllLFP.(LFP_types{k}),tps.CSP,500,0,0);
            LFPResp.(LFP_types{k}).CSP(m,:) = M(:,2);
            [M,T] = PlotRipRaw(AllLFP.(LFP_types{k}),tps.CSM,500,0,0);
            LFPResp.(LFP_types{k}).CSM(m,:) = M(:,2);
            
        else
            LFPResp.(LFP_types{k}).CSP(m,:) = nan(1251,1)
            LFPResp.(LFP_types{k}).CSM(m,:) = nan(1251,1)
            
        end
    end
    
    if exist('SpikeData.mat')>0
        load('SpikeData.mat')
        clear ResResp
        for sp = 1:length(S)
            Y = hist(Range(S{sp}),[0:0.01:1432]*1e4);
            SpikeData = tsd([0:0.01:1432]*1e4,Y') ;
            [M,T] = PlotRipRaw(SpikeData,tps.CSP,500,0,0);
            ResResp.CSP{m}(sp,:) = M(:,2);
            [M,T] = PlotRipRaw(SpikeData,tps.CSM,500,0,0);
            ResResp.CSM{m}(sp,:) = M(:,2);
        end
        
        
    end
end


figure
for k = 1:4
    subplot(1,4,k)
    imagesc(nanzscore(LFPResp.(LFP_types{k}).CSP')')
    clim([-2.5 2.5])
end

for k = 1:4
    subplot(1,4,k)
    plot(M(:,1),runmean(nanmean(nanzscore(LFPResp.(LFP_types{k}).CSP')'),3),'r')
    hold on
    plot(M(:,1),runmean(nanmean(nanzscore(LFPResp.(LFP_types{k}).CSM')'),3),'g')
    line([0 0],ylim,'color','k')
    title(LFP_types{k})
    clim([-2.5 2.5])
    if k==1
       legend({'CSPlus','CSMoins'}) 
    end
end





%%%%
figure
clear all,% close all
%% INITIATION
%% DATA LOCALISATION
Dir=PathForExperimentFEAR('Fear-electrophy-opto');
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
Dir=RestrictPathForExperiment(Dir,'Group','GADgfp');

SaveFolder='/media/DataMOBsRAIDN/ProjetAversion/AnalysisStartStopFreezing_LinkWith4Hz/';
LFP_types = {'OB','PFCx','HPCRip','HPCDeep'}
for m=1:length(Dir.path)
    %% Go to file location
    mm=(m);
    disp(Dir.path{mm})
    cd(Dir.path{mm})
    
    load('behavResources.mat')
    
    
    tps.CSP = TTL((find(TTL(:,2)==3)),1);
    
    clear AllLFP
    load('ChannelsToAnalyse/Bulb_deep.mat')
    load(['LFPData/LFP',num2str(channel),'.mat'])
    AllLFP.(LFP_types{1}) = LFP;
    
    load('ChannelsToAnalyse/PFCx_deep.mat','channel')
    load(['LFPData/LFP',num2str(channel),'.mat'])
    AllLFP.(LFP_types{2}) = LFP;
    
    if exist('ChannelsToAnalyse/dHPC_rip.mat')>0
        load('ChannelsToAnalyse/dHPC_rip.mat')
        if not(isempty(channel))
            load(['LFPData/LFP',num2str(channel),'.mat'])
            AllLFP.(LFP_types{3}) = LFP;
        else
            AllLFP.(LFP_types{3}) = [];
        end
    else
        AllLFP.(LFP_types{3}) = [];
    end
    
    if exist('ChannelsToAnalyse/dHPC_deep.mat')>0
        load('ChannelsToAnalyse/dHPC_deep.mat')
        if not(isempty(channel))
            load(['LFPData/LFP',num2str(channel),'.mat'])
            AllLFP.(LFP_types{4}) = LFP;
        else
            AllLFP.(LFP_types{4}) = [];
        end
    else
        AllLFP.(LFP_types{4}) = [];
    end
    
    for k = 1:4
        
        if not(isempty(AllLFP.(LFP_types{k})))
            
            [M,T] = PlotRipRaw(AllLFP.(LFP_types{k}),tps.CSP,1000,0,0);
            LFPResp.(LFP_types{k}).CSP(m,:) = M(:,2);
            
        else
            LFPResp.(LFP_types{k}).CSP(m,:) = nan(2501,1);
            
        end
    end
    
end


for k = 1:4
    subplot(1,4,k)
    dat = nanzscore(LFPResp.(LFP_types{k}).CSP')';
    [hl,hp]=boundedline(M(:,1),nanmean((dat)),[stdError((dat));stdError((dat))]','g','alpha');
    hold on
%     plot(M(:,1),runmean(nanmean(nanzscore(LFPResp.(LFP_types{k}).CSM')'),3),'g')
    line([0 0],ylim,'color','k')
    title(LFP_types{k})
    clim([-2.5 2.5])
end


clear all,% close all
%% INITIATION
%% DATA LOCALISATION
Dir=PathForExperimentFEAR('Fear-electrophy-opto');
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
Dir=RestrictPathForExperiment(Dir,'Group','GADchr2');

SaveFolder='/media/DataMOBsRAIDN/ProjetAversion/AnalysisStartStopFreezing_LinkWith4Hz/';
LFP_types = {'OB','PFCx','HPCRip','HPCDeep'}
for m=1:length(Dir.path)
    %% Go to file location
    mm=(m);
    disp(Dir.path{mm})
    cd(Dir.path{mm})
    
    load('behavResources.mat')

    
    tps.CSP = TTL((find(TTL(:,2)==3)),1);
    
    clear AllLFP
    load('ChannelsToAnalyse/Bulb_deep.mat')
    load(['LFPData/LFP',num2str(channel),'.mat'])
    AllLFP.(LFP_types{1}) = LFP;
    
    load('ChannelsToAnalyse/PFCx_deep.mat','channel')
    load(['LFPData/LFP',num2str(channel),'.mat'])
    AllLFP.(LFP_types{2}) = LFP;
    
    if exist('ChannelsToAnalyse/dHPC_rip.mat')>0
        load('ChannelsToAnalyse/dHPC_rip.mat')
        if not(isempty(channel))
            load(['LFPData/LFP',num2str(channel),'.mat'])
            AllLFP.(LFP_types{3}) = LFP;
        else
            AllLFP.(LFP_types{3}) = [];
        end
    else
        AllLFP.(LFP_types{3}) = [];
    end
    
    if exist('ChannelsToAnalyse/dHPC_deep.mat')>0
        load('ChannelsToAnalyse/dHPC_deep.mat')
        if not(isempty(channel))
            load(['LFPData/LFP',num2str(channel),'.mat'])
            AllLFP.(LFP_types{4}) = LFP;
        else
            AllLFP.(LFP_types{4}) = [];
        end
    else
        AllLFP.(LFP_types{4}) = [];
    end
    
    for k = 1:4
        
        if not(isempty(AllLFP.(LFP_types{k})))
            
            [M,T] = PlotRipRaw(AllLFP.(LFP_types{k}),tps.CSP,1000,0,0);
            LFPResp.(LFP_types{k}).CSP(m,:) = M(:,2);
%             [M,T] = PlotRipRaw(AllLFP.(LFP_types{k}),tps.CSM,1000,0,0);
%             LFPResp.(LFP_types{k}).CSM(m,:) = M(:,2);
            
        else
            LFPResp.(LFP_types{k}).CSP(m,:) = nan(2501,1);
%             LFPResp.(LFP_types{k}).CSM(m,:) = nan(2501,1)
            
        end
    end
    
end

for k = 1:4
    subplot(1,4,k)
    dat = nanzscore(LFPResp.(LFP_types{k}).CSP')';
    [hl,hp]=boundedline(M(:,1),nanmean((dat)),[stdError((dat));stdError((dat))]','b','alpha');
    hold on
%     plot(M(:,1),runmean(nanmean(nanzscore(LFPResp.(LFP_types{k}).CSM')'),3),'g')
    line([0 0],ylim,'color','k')
    title(LFP_types{k})
    clim([-2.5 2.5])
end

