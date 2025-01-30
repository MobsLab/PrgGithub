clear all,
Files1=PathForExperimentsEmbReactMontreal('UMazeCond');
Files2=PathForExperimentsEmbReactMontreal('UMazeCondNight');
Files.path=[Files1.path,Files2.path];
Files.ExpeInfo=[Files1.ExpeInfo,Files2.ExpeInfo];
MouseToAvoid=[117,431]; % mice with noisy data to exclude
Files=RemoveElementsFromDir(Files,'nmouse',MouseToAvoid);

% Get average spectra
clear SaveSpec
Struc={'B','H','PFCx'};
StrucName={'Bulb','dHPC','PFCx'};
WndwSz=2*1e4; % size of little window to extract frequency data
LimFreq=20;

% for ss=1:length(Struc)
ss=1;
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
            clear StimEpoch TotalNoiseEpoch
            load('behavResources.mat')
            load('StateEpochSB.mat','TotalNoiseEpoch')
            RemovEpoch=or(TTLInfo.StimEpoch,TotalNoiseEpoch);
            load([Struc{ss},'_Low_Spectrum.mat'])
            Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
            
            
            if exist('HeartBeatInfo.mat')>0
                load('HeartBeatInfo.mat')
                AllHB=diff(Range(EKG.HBTimes,'s'));AllHB(AllHB>0.2)=NaN;
                tps=Range(EKG.HBTimes);
                EKG.AllHB=tsd(tps(1:end-1),AllHB);
            end
            
            
            
            %% On the safe side
            LitEp=and(Behav.FreezeEpoch,or(Behav.ZoneEpoch{2},Behav.ZoneEpoch{5}))-RemovEpoch;
            [AvSpectra,SpectraBySlice,SliceDur]=CharacterizeSpectraEpoch(Sptsd,Spectro{3},Behav.FreezeEpoch,2)
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
            
            if exist('HeartBeatInfo.mat')>0 & sum(Stop(LitEp)-Start(LitEp))>2*1e4
                SaveHR{1,1}(mm,c)=nanmean(Data(Restrict(EKG.HBRate,LitEp)));
                SaveHR{1,2}(mm,c)=nanstd(Data(Restrict(EKG.HBRate,LitEp)));
                AllHB=diff(Range(Restrict(EKG.HBTimes,LitEp),'s'));AllHB(AllHB>0.2)=[];
                SaveHR{1,3}(mm,c)=nanstd(Data(Restrict(EKG.AllHB,LitEp)));
            else
                SaveHR{1}(mm,c)=NaN;
            end
            
            
            %Individual Spectra
            if not(isempty(Start(LitEp)))
                if sum(Stop(LitEp)-Start(LitEp))>2*1e4
                    for s=1:length(Start(LitEp))
                        dur=(Stop(subset(LitEp,s))-Start(subset(LitEp,s)));
                        Str=Start(subset(LitEp,s));
                        if  dur<3.5*1e4 & dur>1.5*1e4
                            SaveSpecNoShck{mm,c}(count1,:)=nanmean(Data(Restrict(Sptsd,subset(LitEp,s))));
                            if exist('HeartBeatInfo.mat')>0
                                SaveHRDistNoShock{mm,c}(count1)=nanmean(Data(Restrict(EKG.HBRate,subset(LitEp,s))));
                                SaveHRDistNoShockSTD{mm,c}(count1)=nanstd(Data(Restrict(EKG.AllHB,subset(LitEp,s))));
                            end
                            count1=count1+1;
                        else
                            numbins=round(dur/WndwSz);
                            epdur=dur/numbins;
                            for nn=1:numbins
                                EpochInUse=intervalSet(Str+epdur*(nn-1),Str+epdur*(nn));
                                SaveSpecNoShck{mm,c}(count1,:)=nanmean(Data(Restrict(Sptsd,EpochInUse)));
                                if exist('HeartBeatInfo.mat')>0
                                    SaveHRDistNoShock{mm,c}(count1)=nanmean(Data(Restrict(EKG.HBRate,EpochInUse)));
                                    SaveHRDistNoShockSTD{mm,c}(count1)=nanstd(Data(Restrict(EKG.AllHB,EpochInUse)));
                                end
                                count1=count1+1;
                            end
                            
                        end
                    end
                end
            end
            
            %% On the shock side 
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
            
            if exist('HeartBeatInfo.mat')>0  & sum(Stop(LitEp)-Start(LitEp))>2*1e4
                SaveHR{2,1}(mm,c)=nanmean(Data(Restrict(EKG.HBRate,LitEp)));
                SaveHR{2,2}(mm,c)=nanstd(Data(Restrict(EKG.HBRate,LitEp)));
                AllHB=diff(Range(Restrict(EKG.HBTimes,LitEp),'s'));AllHB(AllHB>0.2)=[];
                SaveHR{2,3}(mm,c)=nanstd(Data(Restrict(EKG.AllHB,LitEp)));

            else
                SaveHR{2}(mm,c)=NaN;
            end
            
            % Individual spectra
            if not(isempty(Start(LitEp)))
                if sum(Stop(LitEp)-Start(LitEp))>2*1e4
                    for s=1:length(Start(LitEp))
                        dur=(Stop(subset(LitEp,s))-Start(subset(LitEp,s)));
                        Str=Start(subset(LitEp,s));
                        if  dur<3.5*1e4 & dur>1.5*1e4
                            SaveSpecShck{mm,c}(count2,:)=nanmean(Data(Restrict(Sptsd,subset(LitEp,s))));
                            if exist('HeartBeatInfo.mat')>0
                                SaveHRDistShock{mm,c}(count2)=nanmean(Data(Restrict(EKG.HBRate,subset(LitEp,s))));
                                SaveHRDistShockSTD{mm,c}(count2)=nanstd(Data(Restrict(EKG.AllHB,subset(LitEp,s))));
                            end
                            count2=count2+1;
                        else
                            numbins=round(dur/WndwSz);
                            epdur=dur/numbins;
                            for nn=1:numbins
                                EpochInUse=intervalSet(Str+epdur*(nn-1),Str+epdur*(nn));
                                SaveSpecShck{mm,c}(count2,:)=nanmean(Data(Restrict(Sptsd,EpochInUse)));
                                if exist('HeartBeatInfo.mat')>0
                                    SaveHRDistShock{mm,c}(count2)=nanmean(Data(Restrict(EKG.HBRate,EpochInUse)));
                                    SaveHRDistShockSTD{mm,c}(count2)=nanstd(Data(Restrict(EKG.AllHB,EpochInUse)));
                                end
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



fig=figure;fig.Name=[Struc{ss},' Av spec Sep Animals onf'];
for mm=1:size(Files.path,2)
    subplot(ceil(size(Files.path,2)/4),4,mm)
    plot(Spectro{3},Spectro{3}.*(nanmean(SaveSpec{mm,1})),'r','linewidth',3)
    hold on
    plot(Spectro{3},Spectro{3}.*(nanmean(SaveSpec{mm,2})),'b','linewidth',3)
    title(MouseName{mm})
    xlim([1 15]),line([3 3],ylim,'color','k','linewidth',2,'linestyle',':'),line([5 5],ylim,'color','k','linewidth',2,'linestyle',':')
end
%saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
%saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
close(fig)

fig=figure;fig.Name=[Struc{ss},'Av spec Sep Animals'];
for mm=1:size(Files.path,2)
    subplot(ceil(size(Files.path,2)/4),4,mm)
    plot(Spectro{3},(nanmean(SaveSpec{mm,1})),'r','linewidth',3)
    hold on
    plot(Spectro{3},(nanmean(SaveSpec{mm,2})),'b','linewidth',3)
    title(MouseName{mm})
    xlim([1 15]),line([3 3],ylim,'color','k','linewidth',2,'linestyle',':'),line([5 5],ylim,'color','k','linewidth',2,'linestyle',':')
end
%saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
%saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
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
%saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
%saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
close(fig)

fig=figure;fig.Name=[Struc{ss},'Av spec'];
MeanSpecShk=[];    MeanSpecNoShk=[];
for mm=1:size(Files.path,2)
    if not(isempty(SaveSpec{mm,1}))
        MeanSpecNoShk=[MeanSpecNoShk;nanmean(SaveSpec{mm,1})./nanmean(nanmean(SaveSpec{mm,1}(:,LimFreq:end)))];
    end
    if not(isempty(SaveSpec{mm,2}))
        MeanSpecShk=[MeanSpecShk;nanmean(SaveSpec{mm,2})./nanmean(nanmean(SaveSpec{mm,2}(:,LimFreq:end)))];
    end
end
hold on
g=shadedErrorBar(Spectro{3},nanmean(MeanSpecShk),[stdError(MeanSpecShk);stdError(MeanSpecShk)],'b')
g=shadedErrorBar(Spectro{3},nanmean(MeanSpecNoShk),[stdError(MeanSpecNoShk);stdError(MeanSpecNoShk)],'r')
xlim([1 15]),line([3 3],ylim,'color','k'),line([5 5],ylim,'color','k')
%saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
%saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
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
%saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
%saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
close(fig)


fig=figure;fig.Name=[Struc{ss},'Indiv Freq Distrib'];
clear fShck fNoShck
f=Spectro{3};
for mm=1:size(Files.path,2)
    fShck{mm}=[];fNoShck{mm}=[];
    subplot(ceil(size(Files.path,2)/4),4,mm)
    
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
%saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
%saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
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
stairs(BinLims,smooth(nanmean(YNoSchk),5),'r','linewidth',3);
hold on
stairs(BinLims,smooth(nanmean(YSchk),5),'b','linewidth',3);
xlim([1 15]),line([3 3],ylim,'color','k'),line([5 5],ylim,'color','k')
%saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
%saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
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
%saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
%saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
close(fig)


fig=figure;fig.Name=[Struc{ss},'Indiv Freq Distrib onf'];
clear fShck fNoShck
f=Spectro{3};
for mm=1:size(Files.path,2)
    fShck{mm}=[];fNoShck{mm}=[];
    subplot(ceil(size(Files.path,2)/4),4,mm)
    
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
%saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
%saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
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
%saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
%saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
close(fig)





GoodEKGMice={'484','485','490','507','508','509'}; % More restrictive
%GoodEKGMice={'483','484','485','490','507','508','509','510','512'};
GoodEKG=[];
for mm=1:length(GoodEKGMice)
    GoodEKG=[GoodEKG,find(~cellfun(@isempty,(strfind(MouseName,GoodEKGMice{mm}))))];
end
%GoodEKG=sort(GoodEKG);

SaveHR{1,1}(SaveHR{1,1}==0)=NaN;
SaveHR{2,1}(SaveHR{2,1}==0)=NaN;
SafeMoy=nanmean(SaveHR{1,1}');SafeMoy=SafeMoy(GoodEKG);
NoSafeMoy=nanmean(SaveHR{2,1}');NoSafeMoy=NoSafeMoy(GoodEKG);
pval=PlotErrorBarN([SafeMoy;NoSafeMoy]',1,1)

SaveHR{1,2}(SaveHR{1,2}==0)=NaN;
SaveHR{2,2}(SaveHR{2,2}==0)=NaN;
SafeStd=nanmean(SaveHR{1,2}');SafeStd=SafeStd(GoodEKG);
NoSafeStd=nanmean(SaveHR{2,2}');NoSafeStd=NoSafeStd(GoodEKG);
pval=PlotErrorBarN([SafeStd;NoSafeStd]',1,1,'ranksum')

SaveHR{1,3}(SaveHR{1,3}==0)=NaN;
SaveHR{2,3}(SaveHR{2,3}==0)=NaN;
SafeStdBis=nanmean(SaveHR{1,3}');SafeStdBis=SafeStdBis(GoodEKG);
NoSafeStdBis=nanmean(SaveHR{2,3}');NoSafeStdBis=NoSafeStdBis(GoodEKG);
pval=PlotErrorBarN([SafeStdBis;NoSafeStdBis]',1,1,'ranksum')

num=1;
for  mm=GoodEKG
    subplot(4,2,num)
    nhist({[SaveHRDistNoShock{mm,:}],[SaveHRDistShock{mm,:}]})
    title(MouseName{mm})
    xlim([8 14])
    num=num+1;
end


% Look at distributions of peak frequencies
fig=figure;fig.Name=[Struc{ss},'Freq Dist'];
f=Spectro{3};
AllBr=[];AllHR=[];

for  mm=GoodEKG
    fShck=[];fNoShck=[];
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
    
    plot([SaveHRDistNoShockSTD{mm,:}],fNoShck,'r*'), hold on
    plot([SaveHRDistShockSTD{mm,:}],fShck,'b*')
    title(MouseName{mm})
    pause
    clf
    AllBr=[AllBr,[fShck,fNoShck]];
    AllHR=[AllHR,[[SaveHRDistShockSTD{mm,:}],[SaveHRDistNoShockSTD{mm,:}]]];
    %     xlim([8 14])
    %     ylim([1 10])
    
end


num=1;
for  mm=GoodEKG
    subplot(4,2,num)
    HBShock=[];HBNoShock=[];
    for c=1:size(Files.path{mm},2)
        try
            HBShock=[HBShock;SaveAllHBShk{mm,c}];
            HBNoShock=[HBNoShock;SaveAllHBNoShk{mm,c}];
        end
    end
    nhist({HBShock,HBNoShock})
    legend('shck','noshck')
    title(MouseName{mm})
    num=num+1;
    
end
