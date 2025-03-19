clear all,
Files=PathForExperimentsEmbReact('UMazeCond');
MouseToAvoid=[431,117]; % mice with noisy data to exclude
Files=RemoveElementsFromDir(Files,'nmouse',MouseToAvoid);

% Get average spectra
clear SaveSpec
Struc={'B','H','PFCx'};
StrucName={'Bulb','dHPC','PFCx'};
WndwSz=2*1e4; % size of little window to extract frequency data
LimFreq=20;
SaveFigName='/media/DataMOBsRAID/ProjectEmbReact/Figures/Sept2016/20160913/';

for ss=1
    clear SaveSpecNoShck SaveSpecShck SaveSpec
    for mm=1:size(Files.path,2)
        mm
        MouseName{mm}=num2str(Files.ExpeInfo{mm}{1}.nmouse);
        AvailStruc=Files.ExpeInfo{mm}{1}.RecordElecs.structure;AvailStruc=[AvailStruc{:}];
        if  not(isempty(findstr(AvailStruc,StrucName{ss})))
            for c=1:size(Files.path{mm},2)
                count1=1;count2=1;
                % Go to folder and load everything
                cd( Files.path{mm}{c})
                clear StimEpoch SleepyEpoch TotalNoiseEpoch
                load('behavResources_SB.mat')
                load('StateEpochSB.mat','TotalNoiseEpoch','SleepyEpoch')
                RemovEpoch=or(or(TTLInfo.StimEpoch,SleepyEpoch),TotalNoiseEpoch);
                load([Struc{ss},'_Low_Spectrum.mat'])
                Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
                
                % On the safe side
                LitEp=and(Behav.FreezeEpoch,or(Behav.ZoneEpoch{2},Behav.ZoneEpoch{5}))-RemovEpoch;
                % Average Spectra
                if not(isempty(Start(LitEp)))
                    if sum(Stop(LitEp)-Start(LitEp))>2*1e4
                        SaveSpec{mm,1}(c,:)=nanmean((Data(Restrict(Sptsd,LitEp))));
                    else
                        SaveSpec{mm,1}(c,:)=nan(1,length(Spectro{3}));
                    end
                else
                    SaveSpec{mm,1}(c,:)=nan(1,length(Spectro{3}));
                    
                end
                
                %Individual Spectra
                if not(isempty(Start(LitEp)))
                    if sum(Stop(LitEp)-Start(LitEp))>2*1e4
                        for s=1:length(Start(LitEp))
                            dur=(Stop(subset(LitEp,s))-Start(subset(LitEp,s)));
                            Str=Start(subset(LitEp,s));
                            if  dur<3.5*1e4 & dur>1.5*1e4
                                SaveSpecNoShck{mm,c}(count1,:)=nanmean(Data(Restrict(Sptsd,subset(LitEp,s))));
                                count1=count1+1;
                            else
                                numbins=round(dur/WndwSz);
                                epdur=dur/numbins;
                                for nn=1:numbins
                                    SaveSpecNoShck{mm,c}(count1,:)=nanmean(Data(Restrict(Sptsd,intervalSet(Str+epdur*(nn-1),Str+epdur*(nn)))));
                                    count1=count1+1;
                                end
                                
                            end
                        end
                    end
                end
                
                % On the shock side
                LitEp=and(Behav.FreezeEpoch,Behav.ZoneEpoch{1})-RemovEpoch;
                % Average Spectra
                if not(isempty(Start(LitEp)))
                    if sum(Stop(LitEp)-Start(LitEp))>2*1e4
                        SaveSpec{mm,2}(c,:)=nanmean((Data(Restrict(Sptsd,LitEp))));
                    else
                        SaveSpec{mm,2}(c,:)=nan(1,length(Spectro{3}));
                    end
                else
                    SaveSpec{mm,2}(c,:)=nan(1,length(Spectro{3}));
                    
                    
                end
                
                % Individual spectra
                if not(isempty(Start(LitEp)))
                    if sum(Stop(LitEp)-Start(LitEp))>2*1e4
                        for s=1:length(Start(LitEp))
                            dur=(Stop(subset(LitEp,s))-Start(subset(LitEp,s)));
                            Str=Start(subset(LitEp,s));
                            if  dur<3.5*1e4 & dur>1.5*1e4
                                SaveSpecShck{mm,c}(count2,:)=nanmean(Data(Restrict(Sptsd,subset(LitEp,s))));
                                count2=count2+1;
                            else
                                numbins=round(dur/WndwSz);
                                epdur=dur/numbins;
                                for nn=1:numbins
                                    SaveSpecShck{mm,c}(count2,:)=nanmean(Data(Restrict(Sptsd,intervalSet(Str+epdur*(nn-1),Str+epdur*(nn)))));
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
    keyboard
    
    fig=figure;fig.Name=[Struc{ss},' Av spec Sep Animals onf'];
    for mm=1:size(Files.path,2)
        subplot(ceil(size(Files.path,2)/2),2,mm)
        plot(Spectro{3},Spectro{3}.*(nanmean(SaveSpec{mm,1})),'r')
        hold on
        plot(Spectro{3},Spectro{3}.*(nanmean(SaveSpec{mm,2})),'b')
        title(MouseName{mm})
        xlim([1 15]),line([3 3],ylim,'color','k','linewidth',2,'linestyle',':'),line([5 5],ylim,'color','k','linewidth',2,'linestyle',':')
    end
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
    close(fig)
    
    fig=figure;fig.Name=[Struc{ss},'Av spec Sep Animals'];
    for mm=1:size(Files.path,2)
        subplot(ceil(size(Files.path,2)/2),2,mm)
        plot(Spectro{3},(nanmean(SaveSpec{mm,1})),'r')
        hold on
        plot(Spectro{3},(nanmean(SaveSpec{mm,2})),'b')
        title(MouseName{mm})
        xlim([1 15]),line([3 3],ylim,'color','k','linewidth',2,'linestyle',':'),line([5 5],ylim,'color','k','linewidth',2,'linestyle',':')
    end
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
    close(fig)
    
    fig=figure;fig.Name=[Struc{ss},'Av spec onf'];
    MeanSpecShk=[];    MeanSpecNoShk=[];
    for mm=1:size(Files.path,2)
        if not(isempty(SaveSpec{mm,1}))
            % normalize by total power for between mice
            % averaging
            MeanSpecNoShk=[MeanSpecNoShk;Spectro{3}.*(nanmean(SaveSpec{mm,1})./nanmean(nanmean(SaveSpec{mm,1}(:,LimFreq:end))))];
        end
        if not(isempty(SaveSpec{mm,2}))
            MeanSpecShk=[MeanSpecShk;Spectro{3}.*(nanmean(SaveSpec{mm,2})./nanmean(nanmean(SaveSpec{mm,2}(:,LimFreq:end))))];
        end
    end
    hold on
    g=shadedErrorBar(Spectro{3},nanmean(MeanSpecShk),[stdError(MeanSpecShk);stdError(MeanSpecShk)],'b')
    g=shadedErrorBar(Spectro{3},nanmean(MeanSpecNoShk),[stdError(MeanSpecNoShk);stdError(MeanSpecNoShk)],'r')
    xlim([1 15]),line([3 3],ylim,'color','k'),line([5 5],ylim,'color','k')
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
    close(fig)
    
    fig=figure;fig.Name=[Struc{ss},'Av spec'];
    MeanSpecShk=[];    MeanSpecNoShk=[];
    for mm=1:size(Files.path,2)
        if not(isempty(SaveSpec{mm,1}))
            MeanSpecNoShk=[MeanSpecNoShk;nanmean((SaveSpec{mm,1}))];
        end
        if not(isempty(SaveSpec{mm,2}))
            MeanSpecShk=[MeanSpecShk;nanmean((SaveSpec{mm,2}))];
        end
    end
    hold on
    g=shadedErrorBar(Spectro{3},nanmean(log(MeanSpecShk)),[stdError(log(MeanSpecShk));stdError(log(MeanSpecShk))],'b')
    g=shadedErrorBar(Spectro{3},nanmean(log(MeanSpecNoShk)),[stdError(log(MeanSpecNoShk));stdError(log(MeanSpecNoShk))],'r')
    xlim([1 15]),line([3 3],ylim,'color','k'),line([5 5],ylim,'color','k')
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
    close(fig)
    
    % Look at distributions of peak frequencies
    fig=figure;fig.Name=[Struc{ss},'Freq Dist'];
    f=Spectro{3};
    fShck=[];fNoShck=[];
    for mm=1:size(Files.path,2)
        mm
        for c=1:size(Files.path{mm},2)
            if not(isempty(SaveSpecNoShck{mm,c}))
                for k=1:size(SaveSpecNoShck{mm,c},1)
                    [val,ind]=max(SaveSpecNoShck{mm,c}(k,LimFreq:end)); ind=ind+LimFreq;
                    fNoShck=[fNoShck,f(ind)];
                end
            end
        end
        for c=1:size(Files.path{mm},2)
            try
                if not(isempty(SaveSpecShck{mm,c}))
                    for k=1:size(SaveSpecShck{mm,c},1)
                        [val,ind]=max(SaveSpecShck{mm,c}(k,LimFreq:end)); ind=ind+LimFreq;
                        fShck=[fShck,f(ind)];
                    end
                end
            end
        end
        
    end
    nhist({fShck,fNoShck},'samebins')
    xlim([1 15]),line([3 3],ylim,'color','k'),line([5 5],ylim,'color','k')
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
    close(fig)
    
    
    fig=figure;fig.Name=[Struc{ss},'Indiv Freq Distrib'];
    clear fShck fNoShck
    f=Spectro{3};
    for mm=1:size(Files.path,2)
        fShck{mm}=[];fNoShck{mm}=[];
        subplot(ceil(size(Files.path,2)/2),2,mm)
        
        for c=1:size(Files.path{mm},2)
            if not(isempty(SaveSpecNoShck{mm,c}))
                for k=1:size(SaveSpecNoShck{mm,c},1)
                    [val,ind]=max(SaveSpecNoShck{mm,c}(k,LimFreq:end)); ind=ind+LimFreq;
                    fNoShck{mm}=[fNoShck{mm},f(ind)];
                end
            end
        end
        for c=1:size(Files.path{mm},2)
            try
                if not(isempty(SaveSpecShck{mm,c}))
                    for k=1:size(SaveSpecShck{mm,c},1)
                        [val,ind]=max(SaveSpecShck{mm,c}(k,LimFreq:end)); ind=ind+LimFreq;
                        fShck{mm}=[fShck{mm},f(ind)];
                    end
                end
            end
        end
        nhist({fShck{mm},fNoShck{mm}},'samebins')
        title(MouseName{mm})
        xlim([1 15]),line([3 3],ylim,'color','k','linewidth',2,'linestyle',':'),line([5 5],ylim,'color','k','linewidth',2,'linestyle',':')
    end
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
    close(fig)
    
    fig=figure;fig.Name=[Struc{ss},'Freq Dist Av Of Mice '];
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
    stairs(BinLims,smooth(nanmean(YNoSchk),5),'color',UMazeColors('safe'),'linewidth',3);
    hold on
    stairs(BinLims,smooth(nanmean(YSchk),5),'color',UMazeColors('shock'),'linewidth',3);
    xlim([1 15]),line([3 3],ylim,'color','k'),line([5 5],ylim,'color','k')
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
    close(fig)

    % Look at distributions of peak frequencies - after multiplying by f
    fig=figure;fig.Name=[Struc{ss},'Freq Dist onf'];
    f=Spectro{3};
    fShck=[];fNoShck=[];
    for mm=1:size(Files.path,2)
        mm
        for c=1:size(Files.path{mm},2)
            if not(isempty(SaveSpecNoShck{mm,c}))
                for k=1:size(SaveSpecNoShck{mm,c},1)
                    [val,ind]=max(Spectro{3}(LimFreq:end).*SaveSpecNoShck{mm,c}(k,LimFreq:end)); ind=ind+LimFreq;
                    fNoShck=[fNoShck,f(min(ind,length(f)))];
                end
            end
        end
        for c=1:size(Files.path{mm},2)
            try
                if not(isempty(SaveSpecShck{mm,c}))
                    for k=1:size(SaveSpecShck{mm,c},1)
                        [val,ind]=max(Spectro{3}(LimFreq:end).*SaveSpecShck{mm,c}(k,LimFreq:end)); ind=ind+LimFreq;
                        fShck=[fShck,f(min(ind,length(f)))];
                    end
                end
            end
        end
        
    end
    nhist({fShck,fNoShck},'samebins')
    xlim([1 15]),line([3 3],ylim,'color','k'),line([5 5],ylim,'color','k')
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
    close(fig)
    
    
    fig=figure;fig.Name=[Struc{ss},'Indiv Freq Distrib onf'];
    clear fShck fNoShck
    f=Spectro{3};
    for mm=1:size(Files.path,2)
        fShck{mm}=[];fNoShck{mm}=[];
        subplot(ceil(size(Files.path,2)/2),2,mm)
        
        for c=1:size(Files.path{mm},2)
            if not(isempty(SaveSpecNoShck{mm,c}))
                for k=1:size(SaveSpecNoShck{mm,c},1)
                    [val,ind]=max(Spectro{3}(LimFreq:end).*SaveSpecNoShck{mm,c}(k,LimFreq:end)); ind=ind+LimFreq;
                    fNoShck{mm}=[fNoShck{mm},f(min(ind,length(f)))];
                end
            end
        end
        for c=1:size(Files.path{mm},2)
            try
                if not(isempty(SaveSpecShck{mm,c}))
                    for k=1:size(SaveSpecShck{mm,c},1)
                        [val,ind]=max(Spectro{3}(LimFreq:end).*SaveSpecShck{mm,c}(k,LimFreq:end)); ind=ind+LimFreq;
                        fShck{mm}=[fShck{mm},f(min(ind,length(f)))];
                    end
                end
            end
        end
        nhist({fShck{mm},fNoShck{mm}},'samebins')
        title(MouseName{mm})
        xlim([1 15]),line([3 3],ylim,'color','k','linewidth',2,'linestyle',':'),line([5 5],ylim,'color','k','linewidth',2,'linestyle',':')
    end
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
    close(fig)
    
    fig=figure;fig.Name=[Struc{ss},'Freq Dist Av Of Mice onf'];
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
    xlim([1 15]),line([3 3],ylim,'color','k','linewidth',2,'linestyle',':'),line([5 5],ylim,'color','k','linewidth',2,'linestyle',':')
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
    close(fig)
end
