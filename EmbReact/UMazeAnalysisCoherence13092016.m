clear all,
Files=PathForExperimentsEmbReact('UMazeCond');
MouseToAvoid=[431]; % mice with noisy data to exclude
Files=RemoveElementsFromDir(Files,'nmouse',431);

clear SaveSpec
Struc={'OBHPC','OBPFCx','PFCHPC'};
StrucName{1}={'Bulb','Bulb','dHPC'};
StrucName{2}={'dHPC','PFCx','PFCx'};
WndwSz=2*1e4; % size of little window to extract frequency data
LimFreq=17;
SaveFigName='/media/DataMOBsRAID/ProjectEmbReact/Figures/Sept2016/20160913/';
for ss=1:length(Struc)
    clear SaveSpecNoShck SaveSpecShck SaveSpec
    for mm=1:size(Files.path,2)
        mm
        MouseName{mm}=num2str(Files.ExpeInfo{mm}{1}.nmouse);
        AvailStruc=Files.ExpeInfo{mm}{1}.RecordElecs.structure;AvailStruc=[AvailStruc{:}];
        if  not(isempty(findstr(AvailStruc,StrucName{1}{ss}))) & not(isempty(findstr(AvailStruc,StrucName{2}{ss})))
            for c=1:size(Files.path{mm},2)
                count1=1;count2=1;
                % Go to folder and load everything
                cd( Files.path{mm}{c})
                clear StimEpoch SleepyEpoch TotalNoiseEpoch
                load('behavResources.mat')
                load('StateEpochSB.mat','TotalNoiseEpoch')
                RemovEpoch=or(or(StimEpoch,SleepyEpoch),TotalNoiseEpoch);
                load(['CoherenceLow' Struc{ss},'.mat'])
                Cohtsd=tsd(t*1e4,C);
                
                % On the safe side
                LitEp=and(FreezeEpoch,or(ZoneEpoch{2},ZoneEpoch{5}))-RemovEpoch;
                % Average Spectra
                if not(isempty(Start(LitEp)))
                    if sum(Stop(LitEp)-Start(LitEp))>2*1e4
                        SaveSpec{mm,1}(c,:)=nanmean((Data(Restrict(Cohtsd,LitEp))));
                    else
                        SaveSpec{mm,1}(c,:)=nan(1,length(f));
                    end
                else
                    SaveSpec{mm,1}(c,:)=nan(1,length(f));
                end
                
                %Individual Spectra
                if not(isempty(Start(LitEp)))
                    if sum(Stop(LitEp)-Start(LitEp))>2*1e4
                        for s=1:length(Start(LitEp))
                            dur=(Stop(subset(LitEp,s))-Start(subset(LitEp,s)));
                            Str=Start(subset(LitEp,s));
                            if  dur<3.5*1e4 & dur>1.5*1e4
                                SaveSpecNoShck{mm,c}(count1,:)=nanmean(Data(Restrict(Cohtsd,subset(LitEp,s))));
                                count1=count1+1;
                            else
                                numbins=round(dur/WndwSz);
                                epdur=dur/numbins;
                                for nn=1:numbins
                                    SaveSpecNoShck{mm,c}(count1,:)=nanmean(Data(Restrict(Cohtsd,intervalSet(Str+epdur*(nn-1),Str+epdur*(nn)))));
                                    count1=count1+1;
                                end
                                
                            end
                        end
                    end
                end
                
                % On the shock side
                LitEp=and(FreezeEpoch,ZoneEpoch{1})-RemovEpoch;
                % Average Spectra
                if not(isempty(Start(LitEp)))
                    if sum(Stop(LitEp)-Start(LitEp))>2*1e4
                        SaveSpec{mm,2}(c,:)=nanmean((Data(Restrict(Cohtsd,LitEp))));
                    else
                        SaveSpec{mm,2}(c,:)=nan(1,length(f));
                    end
                else
                    SaveSpec{mm,2}(c,:)=nan(1,length(f));
                    
                end
                
                % Individual spectra
                if not(isempty(Start(LitEp)))
                    if sum(Stop(LitEp)-Start(LitEp))>2*1e4
                        for s=1:length(Start(LitEp))
                            dur=(Stop(subset(LitEp,s))-Start(subset(LitEp,s)));
                            Str=Start(subset(LitEp,s));
                            if  dur<3.5*1e4 & dur>1.5*1e4
                                SaveSpecShck{mm,c}(count2,:)=nanmean(Data(Restrict(Cohtsd,subset(LitEp,s))));
                                count2=count2+1;
                            else
                                numbins=round(dur/WndwSz);
                                epdur=dur/numbins;
                                for nn=1:numbins
                                    SaveSpecShck{mm,c}(count2,:)=nanmean(Data(Restrict(Cohtsd,intervalSet(Str+epdur*(nn-1),Str+epdur*(nn)))));
                                    count2=count2+1;
                                end
                                
                            end
                        end
                    end
                end
                
                
            end
        else
            SaveSpec{mm,1}=[];
            SaveSpec{mm,2}=[];
            for c=1:size(Files.path{mm},2)
                SaveSpecShck{mm,c}=[];
                SaveSpecNoShck{mm,c}=[];
            end
        end
    end
    
    
    
    fig=figure;fig.Name=[Struc{ss},' Av coh Sep Animals'];
    for mm=1:size(Files.path,2)
        subplot(ceil(size(Files.path,2)/2),2,mm)
        plot(f,(nanmean(SaveSpec{mm,1})),'r')
        hold on
        plot(f,(nanmean(SaveSpec{mm,2})),'b')
        title(MouseName{mm})
        line([3 3],ylim,'color','k','linewidth',2,'linestyle',':'),line([5 5],ylim,'color','k','linewidth',2,'linestyle',':')
    end
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
    close(fig)
    
    fig=figure;fig.Name=[Struc{ss},'Av coh'];
    MeanSpecShk=[];    MeanSpecNoShk=[];
    for mm=1:size(Files.path,2)
        if not(isempty(SaveSpec{mm,1}))
            MeanSpecNoShk=[MeanSpecNoShk;(nanmean(SaveSpec{mm,1}))];
        end
        if not(isempty(SaveSpec{mm,2}))
            MeanSpecShk=[MeanSpecShk;(nanmean(SaveSpec{mm,2}))];
        end
    end
    g=shadedErrorBar(f,nanmean(MeanSpecNoShk),[stdError(MeanSpecNoShk);stdError(MeanSpecNoShk)],'r')
    hold on
    g=shadedErrorBar(f,nanmean(MeanSpecShk),[stdError(MeanSpecShk);stdError(MeanSpecShk)],'b')
    line([3 3],ylim,'color','k','linewidth',2,'linestyle',':'),line([5 5],ylim,'color','k','linewidth',2,'linestyle',':')
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
    close(fig)
    
    fig=figure;fig.Name=[Struc{ss},'Av coh z-score'];
    g=shadedErrorBar(f,nanmean(zscore(MeanSpecNoShk')'),[stdError(zscore(MeanSpecNoShk')');stdError(zscore(MeanSpecNoShk')')],'r')
    hold on
    g=shadedErrorBar(f,nanmean(zscore(MeanSpecShk')'),[stdError(zscore(MeanSpecShk')');stdError(zscore(MeanSpecShk')')],'b')
    line([3 3],ylim,'color','k','linewidth',2,'linestyle',':'),line([5 5],ylim,'color','k','linewidth',2,'linestyle',':')
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
    close(fig)
    
    
    % Look at distributions of peak frequencies
    fig=figure;fig.Name=[Struc{ss},'Freq Coh Dist'];
    f=f;
    fShck=[];fNoShck=[];
    for mm=1:size(Files.path,2)
        mm
        for c=1:size(Files.path{mm},2)
            if not(isempty(SaveSpecNoShck{mm,c}))
                for k=1:size(SaveSpecNoShck{mm,c},1)
                    [val,ind]=max(SaveSpecNoShck{mm,c}(k,LimFreq:end)); ind=ind+LimFreq;
                    fNoShck=[fNoShck,f(min(ind,length(f)))];
                end
            end
        end
        for c=1:size(Files.path{mm},2)
            try
                if not(isempty(SaveSpecShck{mm,c}))
                    for k=1:size(SaveSpecShck{mm,c},1)
                        [val,ind]=max(SaveSpecShck{mm,c}(k,LimFreq:end)); ind=ind+LimFreq;
                        fShck=[fShck,f(min(ind,length(f)))];
                    end
                end
            end
        end
        
    end
    nhist({fShck,fNoShck},'samebins')
    xlim([1 15]),line([3 3],ylim,'color','k','linewidth',2,'linestyle',':'),line([5 5],ylim,'color','k','linewidth',2,'linestyle',':')
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
    close(fig)
    
    
    fig=figure;fig.Name=[Struc{ss},'Indiv Freq Coh Distrib'];
    clear fShck fNoShck
    
    for mm=1:size(Files.path,2)
        fShck{mm}=[];fNoShck{mm}=[];
        subplot(ceil(size(Files.path,2)/2),2,mm)
        
        for c=1:size(Files.path{mm},2)
            if not(isempty(SaveSpecNoShck{mm,c}))
                for k=1:size(SaveSpecNoShck{mm,c},1)
                    [val,ind]=max(SaveSpecNoShck{mm,c}(k,LimFreq:end)); ind=ind+LimFreq;
                    fNoShck{mm}=[fNoShck{mm},f(min(ind,length(f)))];
                end
            end
        end
        for c=1:size(Files.path{mm},2)
            try
                if not(isempty(SaveSpecShck{mm,c}))
                    for k=1:size(SaveSpecShck{mm,c},1)
                        [val,ind]=max(SaveSpecShck{mm,c}(k,LimFreq:end)); ind=ind+LimFreq;
                        fShck{mm}=[fShck{mm},f(min(ind,length(f)))];
                    end
                end
            end
        end
        nhist({fShck{mm},fNoShck{mm}},'samebins')
        title(MouseName{mm})
        line([3 3],ylim,'color','k','linewidth',2,'linestyle',':'),line([5 5],ylim,'color','k','linewidth',2,'linestyle',':')
    end
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
    close(fig)
    
    fig=figure;fig.Name=[Struc{ss},'Freq Coh Dist Av Of Mice '];
    clear YNoSchk YSchk
    BinLims=[0.25:0.25:20]
    % exclude ouse with v little freezign and lots of baseline noise
    for mm=1:size(Files.path,2)
        if not(isempty(fShck{mm}))
            [YSchk(mm,:),X]=hist(fShck{mm},BinLims);YSchk(mm,:)=YSchk(mm,:)./sum(YSchk(mm,:));
        else
            YSchk(mm,:)=nan(1,length(BinLims));
        end
        if not(isempty(fNoShck{mm}))
            [YNoSchk(mm,:),X]=hist(fNoShck{mm},BinLims);YNoSchk(mm,:)=YNoSchk(mm,:)./sum(YNoSchk(mm,:));
        else
            YNoSchk(mm,:)=nan(1,length(BinLims));
        end
    end
    stairs(BinLims,smooth(nanmean(YNoSchk),3),'r','linewidth',3);
    hold on
    stairs(BinLims,smooth(nanmean(YSchk),3),'b','linewidth',3);
    line([3 3],ylim,'color','k','linewidth',2,'linestyle',':'),line([5 5],ylim,'color','k','linewidth',2,'linestyle',':')
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
    close(fig)
    
end
