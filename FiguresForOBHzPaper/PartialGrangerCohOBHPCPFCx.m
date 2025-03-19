clear all,close all

CtrlEphys=[242,248,244,243,253,254,258,259,299,394,395,402,403,450,451];
Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
KeepFirstSessionOnly=[1,3,4,6,8:length(Dir.path)];
n=1;
StrucNames={'HPC','OB','PFCx'};
order=10;
FilterFreq=[0.1 100];
FilterFreq2=[0.1 100];

for mm=KeepFirstSessionOnly
    cd(Dir.path{mm})
    if exist('PartGrangerOBHPCPFC.mat')>0
       movefile('PartGrangerOBHPCPFC.mat','PartGrangerOBHPCPFC36Hz.mat') 
    end
    Abort=0;
    clear FreezeEpoch NoFreezeEpoch  TotalNoiseEpoch Movtsd
    load('behavResources.mat')
    load('StateEpochSB.mat','TotalNoiseEpoch')
    FreezeEpoch=FreezeEpoch-TotalNoiseEpoch;FreezeEpoch=dropShortIntervals(FreezeEpoch,5*1e4);
    TotEpoch=intervalSet(0,max(Range(Movtsd))); NoFreezeEpoch=TotEpoch-FreezeEpoch;NoFreezeEpoch=dropShortIntervals(NoFreezeEpoch,5*1e4);
    
    Ep{1}=FreezeEpoch;Ep{2}=NoFreezeEpoch;
    if exist('ChannelsToAnalyse/Bulb_deep.mat')>0
        clear channel
        load('ChannelsToAnalyse/Bulb_deep.mat')
        if not(isempty(channel))
            load(['LFPData/LFP',num2str(channel),'.mat'])
            FilLFP=FilterLFP((LFP),FilterFreq,1024);
            DataLFP.OB=FilLFP;
            FilLFP=FilterLFP((LFP),FilterFreq2,1024);
            DataLFP2.OB=FilLFP;
            
        else
            Abort=1;
        end
    else
        Abort=1;
    end
    
    if exist('ChannelsToAnalyse/PFCx_deep.mat')>0
        clear channel
        load('ChannelsToAnalyse/PFCx_deep.mat')
        if not(isempty(channel))
            load(['LFPData/LFP',num2str(channel),'.mat'])
            FilLFP=FilterLFP((LFP),FilterFreq,1024);
            DataLFP.P=FilLFP;
            FilLFP=FilterLFP((LFP),FilterFreq2,1024);
            DataLFP2.P=FilLFP;
            
        else
            Abort=1;
        end
    else
        Abort=1;
    end
    
    if exist('ChannelsToAnalyse/dHPC_rip.mat')>0
        clear channel
        load('ChannelsToAnalyse/dHPC_rip.mat')
        if not(isempty(channel))
            load(['LFPData/LFP',num2str(channel),'.mat'])
            FilLFP=FilterLFP((LFP),FilterFreq,1024);
            DataLFP.HPC=FilLFP;
            FilLFP=FilterLFP((LFP),FilterFreq2,1024);
            DataLFP2.HPC=FilLFP;
        elseif  exist('ChannelsToAnalyse/dHPC_deep.mat')>0
            clear channel
            load('ChannelsToAnalyse/dHPC_deep.mat')
            if not(isempty(channel))
                load(['LFPData/LFP',num2str(channel),'.mat'])
                FilLFP=FilterLFP((LFP),FilterFreq,1024);
                DataLFP.HPC=FilLFP;
                FilLFP=FilterLFP((LFP),FilterFreq2,1024);
                DataLFP2.HPC=FilLFP;
                
            else
                Abort=1;
            end
            
        else
            Abort=1;
        end
    elseif exist('ChannelsToAnalyse/dHPC_deep.mat')>0
        clear channel
        load('ChannelsToAnalyse/dHPC_deep.mat')
        if not(isempty(channel))
            load(['LFPData/LFP',num2str(channel),'.mat'])
            FilLFP=FilterLFP((LFP),FilterFreq,1024);
            DataLFP.HPC=FilLFP;
            FilLFP=FilterLFP((LFP),FilterFreq2,1024);
            DataLFP2.HPC=FilLFP;
            
        else
            Abort=1;
        end
    else
        Abort=1;
    end
    
    if Abort==0
        
        Dir.path{mm}
        for ep=1:2
            for st=1:length(Start(Ep{ep}))
                LitEpToUse=subset(Ep{ep},st);
                EpDur{ep,st}=Stop(LitEpToUse,'s')-Start(LitEpToUse,'s');
                X=[Data(Restrict(DataLFP.HPC,LitEpToUse)),Data(Restrict(DataLFP.OB,LitEpToUse)),Data(Restrict(DataLFP.P,LitEpToUse))]';
                X=X(:,1:10:end);%X=X(:,1:floor(length(X)/winsize)*winsize);
                [ret{ep,st}.GW,ret{ep,st}.COH,ret{ep,st}.pp,waut,cons]=cca_pwcausal(X,1,length(X),order,125,[0:0.5:20], 0);
                X=[Data(Restrict(DataLFP2.HPC,LitEpToUse)),Data(Restrict(DataLFP2.OB,LitEpToUse)),Data(Restrict(DataLFP2.P,LitEpToUse))]';
                X=X(:,1:10:end);%X=X(:,1:floor(length(X)/winsize)*winsize);
                ret2{ep,st} = cca_partialgc(X,order,0);
            end
        end
        save(['PartGrangerOBHPCPFC',num2str(FilterFreq2(1)),num2str(FilterFreq2(2)),'Hz.mat'],'ret','EpDur','ret2')
        clear ret EpDur ret2
    end
end
    
    clear all,
    CtrlEphys=[242,248,244,243,253,254,258,259,299,394,395,402,403,450,451];
    Dir=PathForExperimentFEAR('Fear-electrophy');
    Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);
    Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
    KeepFirstSessionOnly=[1,3,4,6,8:length(Dir.path)];
    n=1;
    StrucNames={'HPC','OB','PFCx'};
    num=1;
    fig1=figure;
    for k=1:3
        for kk=1:3
            Remember{k,kk}=[];
        end
    end
    for mm=KeepFirstSessionOnly
        %     Dir.path{mm}
        cd(Dir.path{mm})
        clear ret EpDur
        try load('PartGrangerOBHPCPFC.mat')
            if size([ret{1,:}],2)>0
                for k=1:3
                    for kk=1:3
                        AllDat{k,kk}=zeros(41,1);
                        AllDat2=zeros(3,3);
                    end
                end
                
                for st=1:size([ret{1,:}],2)
                    for k=1:3
                        for kk=1:3
                            AllDat{k,kk}=AllDat{k,kk}+squeeze(ret{1,st}.GW(k,kk,:)).*EpDur{1,st};
                            AllDat2(k,kk)=AllDat2(k,kk)+ret2{1,st}.fg(k,kk).*EpDur{1,st};
                        end
                    end
                    
                end
                AllDat2=AllDat2./sum([EpDur{1,:}]);
                Mouse{num}=Dir.path{mm};
                num=num+1;
                
                for k=1:3
                    for kk=1:3
                        figure(fig1)
                        subplot(3,3,(kk-1)*3+k)
                        AllDat{k,kk}=AllDat{k,kk}./sum([EpDur{1,:}]);
                        plot([0:0.5:20],AllDat{k,kk}),ylim([0 1]),
                        hold on
                        if kk==3
                            xlabel(StrucNames{k})
                        end
                        if k==1
                            ylabel(StrucNames{kk})
                        end
                        Remember{k,kk}=[Remember{k,kk},AllDat2(k,kk)];
                    end
                end
                mm
                clear AllDat AllDat2
            end
        catch
            
        end
    end
    
    
    fig3=figure;
    for k=1:3
        for kk=1:3
            figure(fig3)
            subplot(3,3,(kk-1)*3+k)
            
            PlotErrorBarN(Remember{k,kk}',0),xlim([0 2])
            if kk==3
                xlabel(StrucNames{k})
            end
            if k==1
                ylabel(StrucNames{kk})
            end
        end
    end
    
    % end
    %
    % figure
    % for mm=2:6%:length(Dir.path) % mouse 1 has no reliable PFCx
    %     subplot(2,3,mm)
    %     imagesc(ret{mm,1}.gc)
    % end