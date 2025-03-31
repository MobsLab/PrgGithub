clear all
MiceNumber=[490,507,508,509,510,512,514];
SessNames={'UMazeCond','SleepPreUMaze','SleepPostUMaze'};
Binsize=0.01; %s
WindowSize=2; %s
for rr=1:3
    for ss=1:length(SessNames)
        Dir = PathForExperimentsEmbReact(SessNames{ss});
        
        for dd=1:length(Dir.path)
            MaxTime=0;
            clear AllS
            for mm=1:length(MiceNumber)
                
                if Dir.ExpeInfo{dd}{1}.nmouse==MiceNumber(mm)
                    if not(isnan(Dir.ExpeInfo{dd}{1}.Ripples))
                        
                        % Get data from all sessions
                        for ddd=1:length(Dir.path{dd})
                            
                            % Go to location and load data
                            cd(Dir.path{dd}{ddd})
                            disp(Dir.path{dd}{ddd})
                            load('SpikeData.mat')
                            load('LFPData/LFP0.mat')
                            clear RipplesR;load('Ripples.mat')
                            for sp=1:length(S)
                                Spiketsd = tsd([0:Binsize*1e4:max(Range(LFP))],hist(Range(S{sp}),[0:Binsize*1e4:max(Range(LFP))])');
                                [M,T] = PlotRipRaw(Spiketsd,RipplesR(:,rr)/1e3,WindowSize*1e3,0,0);
                                RippleResponse_Units_temp{ddd}(sp,:) = M(:,2);
                                NeurChan.(SessNames{ss}){mm}(sp)=tetrodeChannels{TT{sp}(1)}(1);
                                tpsUnitRipResp=M(:,1);
                            end
                            NumberOfRipples(ddd)=size(RipplesR,1);
                            
                            % Trigger LFPs
                            load('ChannelsToAnalyse/dHPC_rip.mat')
                            load(['LFPData/LFP',num2str(channel),'.mat'])
                            [M,T] = PlotRipRaw(LFP,RipplesR(:,rr)/1e3,50,0,0);
                            RippleResponse_HPCLFP_temp{ddd}=M(:,2);
                            
                            % PFC channels
                            AllChans = unique(NeurChan.(SessNames{ss}){mm});
                            for ch=1:length(AllChans)
                                load(['LFPData/LFP',num2str(AllChans(ch)),'.mat'])
                                [M,T] = PlotRipRaw(LFP,RipplesR(:,rr)/1e3,500,0,0);
                                RippleResponse_PFCLFP_temp.(['chan',num2str(AllChans(ch))]){ddd}=M(:,2);
                                tpsRipResp=M(:,1);
                            end
                            
                            if Dir.ExpeInfo{dd}{1}.SleepSession
                                load('DownState.mat')
                                for ch=1:length(AllChans)
                                    load(['LFPData/LFP',num2str(AllChans(ch)),'.mat'])
                                    [M,T] = PlotRipRaw(LFP,Start(down_PFCx,'s'),500,0,0);
                                    DownResponse.(SessNames{ss}){mm}.(['chan',num2str(AllChans(ch))])=M(:,2);
                                    tpsDownResp=M(:,1);
                                    
                                end
                            end
                        end
                        
                        % Average over the sessions
                        % Average unit responses
                        for sp=1:length(S)
                            RippleResponse_Units.(SessNames{ss}){mm}(sp,:)=zeros(size(RippleResponse_Units_temp{ddd},2),1);
                            for ddd=1:length(Dir.path{dd})
                                RippleResponse_Units.(SessNames{ss}){mm}(sp,:)=RippleResponse_Units.(SessNames{ss}){mm}(sp,:)+NumberOfRipples(ddd).*RippleResponse_Units_temp{ddd}(sp,:);
                            end
                            RippleResponse_Units.(SessNames{ss}){mm}(sp,:)=RippleResponse_Units.(SessNames{ss}){mm}(sp,:)./nansum(NumberOfRipples);
                        end
                        clear RippleResponse_Units_temp
                        
                        % Average LFPs
                        RippleResponse_HPCLFP.(SessNames{ss}){mm}=zeros(125,1);
                        for ddd=1:length(Dir.path{dd})
                            RippleResponse_HPCLFP.(SessNames{ss}){mm}=RippleResponse_HPCLFP.(SessNames{ss}){mm}+NumberOfRipples(ddd).*RippleResponse_HPCLFP_temp{ddd};
                        end
                        RippleResponse_HPCLFP.(SessNames{ss}){mm}= RippleResponse_HPCLFP.(SessNames{ss}){mm}./nansum(NumberOfRipples);
                        clear RippleResponse_HPCLFP_temp
                        
                        
                        for ch=1:length(AllChans)
                            RippleResponse_PFCLFP.(SessNames{ss}){mm}.(['chan',num2str(AllChans(ch))])=zeros(1251,1);
                            for ddd=1:length(Dir.path{dd})
                                RippleResponse_PFCLFP.(SessNames{ss}){mm}.(['chan',num2str(AllChans(ch))])= RippleResponse_PFCLFP.(SessNames{ss}){mm}.(['chan',num2str(AllChans(ch))])+NumberOfRipples(ddd).* RippleResponse_PFCLFP_temp.(['chan',num2str(AllChans(ch))]){ddd};
                            end
                            RippleResponse_PFCLFP.(SessNames{ss}){mm}.(['chan',num2str(AllChans(ch))])=RippleResponse_PFCLFP.(SessNames{ss}){mm}.(['chan',num2str(AllChans(ch))])./nansum(NumberOfRipples);
                        end
                        clear RippleResponse_PFCLFP_temp
                        
                        
                    else
                        RippleResponse_Units.(SessNames{ss}){mm}(1,:)=nan(1,801);
                        RippleResponse_HPCLFP.(SessNames{ss}){mm}=zeros(125,1);
                        RippleResponse_PFCLFP.(SessNames{ss}){mm}=zeros(1251,1);
                        DownResponse.(SessNames{ss}){mm}.(['chan',num2str(AllChans(ch))])=zeros(1251,1);
                    end
                    clear AllResp
                end
            end
        end
    end
    keyboard
    cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_UMazeSpatialFiring
    save(['RippleTriggeredFiring',num2str(rr),'.mat'],'DownResponse','RippleResponse_Units','RippleResponse_HPCLFP','RippleResponse_PFCLFP','-v7.3')
    clear DownResponse RippleResponse_Units RippleResponse_HPCLFP RippleResponse_PFCLFP
end


clear all
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/RippleTriggeredActivity
load('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_UMazeSpatialFiring/Firing_Hab_NewRandomisation.mat','IsPFCNeuron')
SessNames={'UMazeCond','SleepPreUMaze','SleepPostUMaze'};
MiceNumber=[490,507,508,509,510,512,514];
for rr=1:3
    load(['RippleTriggeredFiring',num2str(rr),'.mat'])
    
    %% unit responses
    fig=figure;
    clear AllResp
    for ss=1:length(SessNames)
        AllResp.(SessNames{ss})=[];
        for mm=1:length(MiceNumber)
            if not(sum(isnan(RippleResponse_Units.(SessNames{ss}){mm}(:)))==length(RippleResponse_Units.(SessNames{ss}){mm}(:)))
                AllResp.(SessNames{ss})=[AllResp.(SessNames{ss});zscore(RippleResponse_Units.(SessNames{ss}){mm}(find(IsPFCNeuron{mm}),:)')'];
            end
        end
    end
    
    for ss=1:length(SessNames)
        if ss==1
            ord=mean(AllResp.(SessNames{ss})(:,195:205)');
        end
        subplot(4,1,ss)
        imagesc(tpsUnitRipResp,1:length(ord),sortrows([ord',AllResp.(SessNames{ss})])),hold on
        line([0 0],ylim,'color','w','linewidth',2)
        title(SessNames{ss})
        clim([-3 3]);
    end
    
    subplot(4,1,4)
    for ss=1:length(SessNames)
        plot(tpsUnitRipResp,nanmean(zscore(AllResp.(SessNames{ss})')'),'linewidth',2)
        hold on
    end
    line([0 0],ylim,'color','k','linewidth',1)
    box off
    fig.Position=[690 554 700 900];
    saveas(fig.Number,['NeuronResponseToRipples',num2str(rr),'.fig'])
    saveas(fig.Number,['NeuronResponseToRipples',num2str(rr),'.png'])
    
    for ss=1:3
        fig=figure;
        fig.Name=SessNames{ss};
        Ytemp=AllResp.(SessNames{ss});
        X=tpsUnitRipResp(:,1);
        Dat=zscore(Ytemp')';
        [EigVect,EigVals]=PerformPCA(Dat);
        Dat=zscore(Ytemp')';
        for k=1:5
            subplot(5,3,1+(k-1)*3)
            ToPlot=EigVect(:,k)'*Dat;
            EigVect(:,k)=EigVect(:,k)*sign(mean(ToPlot(200:220)));
            ToPlot=EigVect(:,k)'*Dat;
            plot(X,ToPlot), hold on
            line([0;0],[0*0+min(ylim);0*0+max(ylim)],'color','k')
            ylabel(['Comp' num2str(k)])
            xlim([-1 1])
            title(num2str(round(100*EigVals(k)/sum(EigVals))))
            subplot(5,3,2+(k-1)*3)
            imagesc(X,1:length(EigVect),sortrows([EigVect(:,k),Dat]))
            line([0;0],[0*0+min(ylim);0*0+max(ylim)],'color','k')
            clim([-2 2]);
            xlim([-1 1])
            set(gca,'YTick',[],'XTick',[])
            subplot(5,3,3+(k-1)*3)
            hist([EigVect(:,k)],50),line([0 0],ylim)
            xlim([-0.4 0.4])
        end
        fig.Position=[690 554 700 900];
        saveas(fig.Number,['PCAonNeuronResponseToRipples',SessNames{ss},num2str(rr),'.fig'])
        saveas(fig.Number,['PCAonNeuronResponseToRipples',SessNames{ss},num2str(rr),'.png'])
    end
    
    
    
    % responses in HPC
    fig=figure;
    clear AllResp
    for ss=1:length(SessNames)
        AllResp.(SessNames{ss})=[];
        for mm=1:length(MiceNumber)
            if not(sum(isnan(RippleResponse_Units.(SessNames{ss}){mm}(:)))==length(RippleResponse_Units.(SessNames{ss}){mm}(:)))
                AllResp.(SessNames{ss})=[AllResp.(SessNames{ss});zscore(RippleResponse_Units.(SessNames{ss}){mm}(find(IsPFCNeuron{mm}==0),:)')'];
            end
        end
    end
    
    for ss=1:length(SessNames)
        ord=mean(AllResp.(SessNames{ss})(:,95:105)');
        subplot(4,1,ss)
        imagesc(tpsUnitRipResp,1:length(ord),sortrows([ord',AllResp.(SessNames{ss})])),hold on
        line([0 0],ylim,'color','w','linewidth',2)
        title(SessNames{ss})
        clim([-3 3])
    end
    
    subplot(4,1,4)
    for ss=1:length(SessNames)
        plot(tpsUnitRipResp,nanmean(zscore(AllResp.(SessNames{ss})')'),'linewidth',2)
        hold on
    end
    line([0 0],ylim,'color','k','linewidth',1)
    box off
    fig.Position=[690 554 700 900];
    saveas(fig.Number,['HPCNeuronResponseToRipples',SessNames{ss},num2str(rr),'.fig'])
    saveas(fig.Number,['HPCNeuronResponseToRipples',SessNames{ss},num2str(rr),'.png'])
    
    %% Average ripple response of units by electrode
    %% unit responses
    fig=figure;
    clear AllResp
    for ss=1:length(SessNames)
        AllResp=[];NumNeur=[];MouseNum=[];
        nn=0;
        for mm=1:length(MiceNumber)
            if not(sum(isnan(RippleResponse_Units.(SessNames{ss}){mm}(:)))==length(RippleResponse_Units.(SessNames{ss}){mm}(:)))
                AllResp_temp=((RippleResponse_Units.(SessNames{ss}){mm}(find(IsPFCNeuron{mm}),:)'))';
                NeurId_temp=NeurChan.(SessNames{ss}){mm}(find(IsPFCNeuron{mm}));
                
                
                ListChans=unique(NeurId_temp);
                for u=1:length(ListChans)
                    AllResp=[AllResp;nanmean(AllResp_temp(find(NeurId_temp==ListChans(u)),:))];
                    NumNeur=[NumNeur,length(find(NeurId_temp==ListChans(u)))];
                    MouseNum=[MouseNum,nn];
                    
                end
                nn=nn+1;
            end
        end
        subplot(3,5,(ss-1)*5+[1:4])
        imagesc(tpsUnitRipResp,1:size(AllResp,1),zscore(AllResp')'), hold on
        title(SessNames{ss})
        line([0 0],ylim,'color','k')
        clim([-3 3])
        axis xy
        plot(MouseNum/5+1,1:length(MouseNum),'k','linewidth',3)
        subplot(3,5,(ss-1)*5+5)
        stairs(NumNeur,1:size(AllResp,1))
        ylim([1 size(AllResp,1)])
        
    end
    fig.Position=[690 554 700 900];
    saveas(fig.Number,['AverageNeuronResponseElectrodeByElectrode',SessNames{ss},num2str(rr),'.fig'])
    saveas(fig.Number,['AverageNeuronResponseElectrodeByElectrode',SessNames{ss},num2str(rr),'.png'])
    
    responses=zscore(AllResp');
    order=nanmean(responses(190:210,:));
    subplot(131)
    imagesc(sortrows([order;responses]')), clim([-3 3])
    subplot(132),imagesc(sortrows([order;zscore(AllRipLFP)]'))
    
    subplot(133),imagesc(sortrows([order;zscore(AllDowns)]'))
OrdDown=sortrows([order;(AllDowns)]');
    OrdDown=sortrows([order;zscore(AllRipLFP)]');

    %%
    fig=figure;
    cols=lines(7);
    for ss=2:length(SessNames)
        subplot(2,2,1+(ss-2)*2)
        AllDowns=[];MouseNum=[];
        nn=1;
        for mm=1:length(MiceNumber)
            all= fieldnames(DownResponse.(SessNames{ss}){mm});
            if mm==1
                all=all(4:end);
            end
            if length(all)>1
                for a=1:length(all)
                    plot(tpsDownResp,DownResponse.(SessNames{ss}){mm}.(all{a}),'color',cols(mm,:)), hold on
                    AllDowns=[AllDowns,DownResponse.(SessNames{ss}){mm}.(all{a})];
                    MouseNum=[MouseNum,nn];
                    
                end
                nn=nn+1;
            end
        end
        subplot(2,2,2+(ss-2)*2)
        imagesc(tpsDownResp,1:size(AllDowns,2),zscore(AllDowns)'), hold on
        axis xy
        plot(MouseNum/20+0.2,1:length(MouseNum),'k','linewidth',3)
        
    end
    fig.Position=[690 554 700 600];
    saveas(fig.Number,['DownResponse.fig'])
    saveas(fig.Number,['DownResponse.png'])
    
    %%
    fig=figure;
    for ss=1:length(SessNames)
        subplot(3,2,1+(ss-1)*2)
        AllRipLFP=[];MouseNum=[];
        nn=1;
        for mm=1:length(MiceNumber)
            try
                all= fieldnames(RippleResponse_PFCLFP.(SessNames{ss}){mm});
            catch
                all=[];
            end
            if mm==1
                all=all(4:end);
            end
            if length(all)>1
                for a=1:length(all)
                    plot(tpsRipResp,RippleResponse_PFCLFP.(SessNames{ss}){mm}.(all{a}),'color',cols(mm,:)), hold on
                    AllRipLFP=[AllRipLFP,RippleResponse_PFCLFP.(SessNames{ss}){mm}.(all{a})];
                    MouseNum=[MouseNum,nn];
                    
                end
                nn=nn+1;
            end
        end
        title(SessNames{ss})
        line([0 0],ylim,'color','k')
        subplot(3,2,2+(ss-1)*2)
        imagesc(tpsRipResp,1:size(AllRipLFP,2),zscore(AllRipLFP)'),hold on
        clim([-5 3])
        axis xy
        plot(MouseNum/20+0.2,1:length(MouseNum),'k','linewidth',3)
        title(SessNames{ss})
        line([0 0],ylim,'color','k')
    end
    fig.Position=[690 554 700 600];
    saveas(fig.Number,['RippleResponse.fig'])
    saveas(fig.Number,['RippleResponse.png'])
    
    
    fig=figure;
    Dat=zscore(AllDowns)';
    [EigVect,EigVals]=PerformPCA(Dat);
    for k=1:5
        subplot(5,5,1+(k-1)*5)
        ToPlot=EigVect(:,k)'*Dat;
        EigVect(:,k)=EigVect(:,k)*(sign(mean(ToPlot(630:650))));
        ToPlot=EigVect(:,k)'*Dat;
        plot(tpsDownResp,ToPlot), hold on
        line([0;0],[0*0+min(ylim);0*0+max(ylim)],'color','k')
        ylabel(['Comp' num2str(k)])
        clim([-0.5 0.5]);
        title(num2str(round(100*EigVals(k)/sum(EigVals))))
        
        subplot(5,5,2+(k-1)*5)
        ToPlot=sortrows([EigVect(:,k),Dat]);
        imagesc(tpsDownResp,1:length(EigVect),ToPlot(:,2:end))
        line([0;0],[0*0+min(ylim);0*0+max(ylim)],'color','k')
        clim([-3 3]);
        xlim([-0.5 0.5])
        if k==1
            title('Down')
        end
        
        subplot(5,5,3+(k-1)*5)
        hist([EigVect(:,k)],50),line([0 0],ylim)
        xlim([-0.4 0.4])
        clim([-3 3]);
        if k==1
            title('hist weights')
        end
        
        subplot(5,5,4+(k-1)*5)
        ToPlot=sortrows([EigVect(:,k),zscore(AllRipLFP)']);
        imagesc(tpsDownResp,1:length(EigVect),ToPlot(:,2:end))
        line([0;0],[0*0+min(ylim);0*0+max(ylim)],'color','k')
        xlim([-0.5 0.5])
        if k==1
            title('LFP response - ripples')
        end
        subplot(5,5,5+(k-1)*5)
        ToPlot=sortrows([EigVect(:,k),zscore(AllResp')']);
        imagesc(tpsDownResp,1:length(EigVect),ToPlot(:,2:end))
        line([0;0],[0*0+min(ylim);0*0+max(ylim)],'color','k')
        clim([-3 3]);
        xlim([-0.5 0.5])
        if k==1
            title('unit response - ripples')
        end
        
    end
    fig.Position=[690 554 1900 900];
    saveas(fig.Number,['LinkBetweenLFPAndNeuronResponse',SessNames{ss},num2str(rr),'.fig'])
    saveas(fig.Number,['LinkBetweenLFPAndNeuronResponse',SessNames{ss},num2str(rr),'.png'])
end