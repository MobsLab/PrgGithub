clear all,
MouseToAvoid=[431]; % mice with noisy data to exclude
FilesCond=PathForExperimentsEmbReact('SoundCond');
FilesCond=RemoveElementsFromDir(FilesCond,'nmouse',MouseToAvoid);
FilesTest=PathForExperimentsEmbReact('SoundTest');
FilesTest=RemoveElementsFromDir(FilesTest,'nmouse',MouseToAvoid);

clear SaveSpec
Struc={'OBHPC','OBPFCx','PFCHPC'};
StrucName{1}={'Bulb','Bulb','dHPC'};
StrucName{2}={'dHPC','PFCx','PFCx'};
WndwSz=2*1e4; % size of little window to extract frequency data
LimFreq=17;
SaveFigName='/media/DataMOBsRAID/ProjectEmbReact/Figures/Oct2016/20161006/';


for ss=1:length(Struc)
    clear SaveSpecCond SaveSpecTest SaveSpec
    % Cond
    for mm=1:size(FilesCond.path,2)
        mm
        MouseName{mm}=num2str(FilesCond.ExpeInfo{mm}.nmouse);
        AvailStruc=FilesCond.ExpeInfo{mm}.RecordElecs.structure;AvailStruc=[AvailStruc{:}];
        if  not(isempty(findstr(AvailStruc,StrucName{1}{ss}))) & not(isempty(findstr(AvailStruc,StrucName{2}{ss})))
            for c=1
                count1=1;
                % Go to folder and load everything
                cd( FilesCond.path{mm}{c})
                clear StimEpoch SleepyEpoch TotalNoiseEpoch
                load('behavResources.mat')
                load('StateEpochSB.mat','TotalNoiseEpoch')
                RemovEpoch=or(or(StimEpoch,SleepyEpoch),TotalNoiseEpoch);
                load(['CoherenceLow' Struc{ss},'.mat'])
                Cohtsd=tsd(t*1e4,C);
                
                % On the safe side
            LitEp=FreezeEpoch-RemovEpoch;
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
                                SaveSpecCond{mm,c}(count1,:)=nanmean(Data(Restrict(Cohtsd,subset(LitEp,s))));
                                count1=count1+1;
                            else
                                numbins=round(dur/WndwSz);
                                epdur=dur/numbins;
                                for nn=1:numbins
                                    SaveSpecCond{mm,c}(count1,:)=nanmean(Data(Restrict(Cohtsd,intervalSet(Str+epdur*(nn-1),Str+epdur*(nn)))));
                                    count1=count1+1;
                                end
                                
                            end
                        end
                    end
                end
 
            end
        else
            SaveSpec{mm,1}=[];
            for c=1:size(FilesCond.path{mm},2)
                SaveSpecCond{mm,c}=[];
            end
        end
    end
    
    % Test
    for mm=1:size(FilesTest.path,2)
        mm
        MouseName{mm}=num2str(FilesTest.ExpeInfo{mm}.nmouse);
        AvailStruc=FilesTest.ExpeInfo{mm}.RecordElecs.structure;AvailStruc=[AvailStruc{:}];
        if  not(isempty(findstr(AvailStruc,StrucName{1}{ss}))) & not(isempty(findstr(AvailStruc,StrucName{2}{ss})))
            for c=1
                count1=1;
                % Go to folder and load everything
                cd( FilesTest.path{mm}{c})
                clear StimEpoch SleepyEpoch TotalNoiseEpoch
                load('behavResources.mat')
                load('StateEpochSB.mat','TotalNoiseEpoch')
                RemovEpoch=or(or(StimEpoch,SleepyEpoch),TotalNoiseEpoch);
                load(['CoherenceLow' Struc{ss},'.mat'])
                Cohtsd=tsd(t*1e4,C);
                
                % On the safe side
            LitEp=FreezeEpoch-RemovEpoch;
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
                
                %Individual Spectra
                if not(isempty(Start(LitEp)))
                    if sum(Stop(LitEp)-Start(LitEp))>2*1e4
                        for s=1:length(Start(LitEp))
                            dur=(Stop(subset(LitEp,s))-Start(subset(LitEp,s)));
                            Str=Start(subset(LitEp,s));
                            if  dur<3.5*1e4 & dur>1.5*1e4
                                SaveSpecTest{mm,c}(count1,:)=nanmean(Data(Restrict(Cohtsd,subset(LitEp,s))));
                                count1=count1+1;
                            else
                                numbins=round(dur/WndwSz);
                                epdur=dur/numbins;
                                for nn=1:numbins
                                    SaveSpecTest{mm,c}(count1,:)=nanmean(Data(Restrict(Cohtsd,intervalSet(Str+epdur*(nn-1),Str+epdur*(nn)))));
                                    count1=count1+1;
                                end
                                
                            end
                        end
                    end
                end
 
            end
        else
            SaveSpec{mm,2}=[];
            for c=1:size(FilesTest.path{mm},2)
                SaveSpecTest{mm,c}=[];
            end
        end
    end
    
    fig=figure;fig.Name=[Struc{ss},' Av coh Sep Animals SoundCond'];
    for mm=1:size(FilesTest.path,2)
        subplot(ceil(size(FilesTest.path,2)/2),2,mm)
        plot(f,(nanmean(SaveSpec{mm,1},1)),'r')
        hold on
        plot(f,(nanmean(SaveSpec{mm,2},1)),'b')
        title(MouseName{mm})
        line([3 3],ylim,'color','k','linewidth',2,'linestyle',':'),line([5 5],ylim,'color','k','linewidth',2,'linestyle',':')
    end
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
    close(fig)
    
    fig=figure;fig.Name=[Struc{ss},'Av coh SoundCond'];
    MeanSpecTest=[];    MeanSpecCond=[];
    for mm=1:size(FilesTest.path,2)
        if not(isempty(SaveSpec{mm,1}))
            MeanSpecCond=[MeanSpecCond;(nanmean(SaveSpec{mm,1},1))];
        end
        if not(isempty(SaveSpec{mm,2}))
            MeanSpecTest=[MeanSpecTest;(nanmean(SaveSpec{mm,2},1))];
        end
    end
    g=shadedErrorBar(f,nanmean(MeanSpecCond),[stdError(MeanSpecCond);stdError(MeanSpecCond)],'r')
    hold on
    g=shadedErrorBar(f,nanmean(MeanSpecTest),[stdError(MeanSpecTest);stdError(MeanSpecTest)],'b')
    line([3 3],ylim,'color','k','linewidth',2,'linestyle',':'),line([5 5],ylim,'color','k','linewidth',2,'linestyle',':')
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
    close(fig)
    
    fig=figure;fig.Name=[Struc{ss},'Av coh z-score SoundCond'];
    g=shadedErrorBar(f,nanmean(zscore(MeanSpecCond')'),[stdError(zscore(MeanSpecCond')');stdError(zscore(MeanSpecCond')')],'r')
    hold on
    g=shadedErrorBar(f,nanmean(zscore(MeanSpecTest')'),[stdError(zscore(MeanSpecTest')');stdError(zscore(MeanSpecTest')')],'b')
    line([3 3],ylim,'color','k','linewidth',2,'linestyle',':'),line([5 5],ylim,'color','k','linewidth',2,'linestyle',':')
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
    close(fig)
    
    
    % Look at distributions of peak frequencies
    fig=figure;fig.Name=[Struc{ss},'Freq Coh Dist SoundCond'];
    f=f;
    fTest=[];fCond=[];
    for mm=1:size(FilesTest.path,2)
        mm
        for c=1
            if not(isempty(SaveSpecCond{mm,c}))
                for k=1:size(SaveSpecCond{mm,c},1)
                    [val,ind]=max(SaveSpecCond{mm,c}(k,LimFreq:end)); ind=ind+LimFreq;
                    fCond=[fCond,f(min(ind,length(f)))];
                end
            end
        end
        for c=1
            try
                if not(isempty(SaveSpecTest{mm,c}))
                    for k=1:size(SaveSpecTest{mm,c},1)
                        [val,ind]=max(SaveSpecTest{mm,c}(k,LimFreq:end)); ind=ind+LimFreq;
                        fTest=[fTest,f(min(ind,length(f)))];
                    end
                end
            end
        end
        
    end
    nhist({fTest,fCond},'samebins')
    xlim([1 15]),line([3 3],ylim,'color','k','linewidth',2,'linestyle',':'),line([5 5],ylim,'color','k','linewidth',2,'linestyle',':')
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
    close(fig)
    
    
    fig=figure;fig.Name=[Struc{ss},'Indiv Freq Coh Distrib SoundCond'];
    clear fTest fCond
    
    for mm=1:size(FilesTest.path,2)
        fTest{mm}=[];fCond{mm}=[];
        subplot(ceil(size(FilesTest.path,2)/2),2,mm)
        
        for c=1
            if not(isempty(SaveSpecCond{mm,c}))
                for k=1:size(SaveSpecCond{mm,c},1)
                    [val,ind]=max(SaveSpecCond{mm,c}(k,LimFreq:end)); ind=ind+LimFreq;
                    fCond{mm}=[fCond{mm},f(min(ind,length(f)))];
                end
            end
        end
        for c=1
            try
                if not(isempty(SaveSpecTest{mm,c}))
                    for k=1:size(SaveSpecTest{mm,c},1)
                        [val,ind]=max(SaveSpecTest{mm,c}(k,LimFreq:end)); ind=ind+LimFreq;
                        fTest{mm}=[fTest{mm},f(min(ind,length(f)))];
                    end
                end
            end
        end
        nhist({fTest{mm},fCond{mm}},'samebins')
        title(MouseName{mm})
        line([3 3],ylim,'color','k','linewidth',2,'linestyle',':'),line([5 5],ylim,'color','k','linewidth',2,'linestyle',':')
    end
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
    close(fig)
    
    fig=figure;fig.Name=[Struc{ss},'Freq Coh Dist Av Of Mice SoundCond'];
    clear YNoSchk YSchk
    BinLims=[0.25:0.25:20]
    % exclude ouse with v little freezign and lots of baseline noise
    for mm=1:size(FilesTest.path,2)
        if not(isempty(fTest{mm}))
            [YSchk(mm,:),X]=hist(fTest{mm},BinLims);YSchk(mm,:)=YSchk(mm,:)./sum(YSchk(mm,:));
        else
            YSchk(mm,:)=nan(1,length(BinLims));
        end
        if not(isempty(fCond{mm}))
            [YNoSchk(mm,:),X]=hist(fCond{mm},BinLims);YNoSchk(mm,:)=YNoSchk(mm,:)./sum(YNoSchk(mm,:));
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
