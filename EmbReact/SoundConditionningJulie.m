clear all,
experiment= 'Fear-electrophy';
Dir=PathForExperimentFEAR(experiment);
Dir=RestrictPathForExperiment(Dir,'nMice',[ 244 241 248 253 254 258 259 299, 230 250 291 297 298]);
Dir=RestrictPathForExperiment(Dir,'Group','CTRL');
for d=1:length(Dir.path)
    if not(any(strfind(Dir.path{d},'24h')))
        Dir.path{d}=[];
    end
end
Dir.path=Dir.path(~cellfun('isempty',Dir.path));
WndwSz=2*1e4; % size of little window to extract frequency data
LimFreq=20;
SaveFigName='/media/DataMOBsRAID/ProjectEmbReact/Figures/Oct2016/20161006/ClassicalConditionning';


for mm=1:length(Dir.path)
    cd(Dir.path{mm})
    clear FreezeEpoch TotalNoiseEpoch Sp t TotalNoiseEpoch
    %     load('ChannelsToAnalyse/Bulb_deep.mat')
    %     LowSpectrumSB([cd,filesep],channel,'B');
    load('B_Low_Spectrum.mat')
    load('behavResources.mat')
    load('StateEpoch.mat','TotalNoiseEpoch')
        
    LitEp=FreezeEpoch-TotalNoiseEpoch;
    count1=1;
    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
    % Average Spectra
    if not(isempty(Start(LitEp)))
        if sum(Stop(LitEp)-Start(LitEp))>2*1e4
            SaveSpec{mm,1}(1,:)=nanmean((Data(Restrict(Sptsd,LitEp))));
        else
            SaveSpec{mm,1}(1,:)=nan(1,length(Spectro{3}));
        end
    else
        SaveSpec{mm,1}(1,:)=nan(1,length(Spectro{3}));
    end
    
    
    
    % Average Spectra sound by sound
    for i=1:3
        for c=1:length(CSPLUS)
            LitEp=and(FreezeEpoch-TotalNoiseEpoch,intervalSet(CSPLUS(c)*1e4+(i-1)*30*1e4,CSPLUS(c)*1e4+i*30*1e4));
            DurFz{i}(mm,c)=sum(Stop(LitEp,'s')-Start(LitEp,'s'));
            if not(isempty(Start(LitEp)))
                if sum(Stop(LitEp)-Start(LitEp))>2*1e4
                    SaveSpecCS{i}{mm,c}(1,:)=nanmean((Data(Restrict(Sptsd,LitEp))));
                else
                    SaveSpecCS{i}{mm,c}(1,:)=nan(1,length(Spectro{3}));
                end
            else
                SaveSpecCS{i}{mm,c}(1,:)=nan(1,length(Spectro{3}));
            end
        end
    end
    
    % Spectra cutting up total freezing up until change point
    for c=1:length(CSPLUS)
        LitEp=and(FreezeEpoch-TotalNoiseEpoch,intervalSet(CSPLUS(c)*1e4,CSPLUS(c)*1e4+60*1e4));
        DurFzTot(mm,c)=sum(Stop(LitEp,'s')-Start(LitEp,'s'));
    end
%     subplot(211)
%     plot(cumsum(zscore((DurFzTot(mm,:)))),'k'), hold on
%     [val,ind]=max(cumsum(zscore((DurFzTot(mm,:)))));plot(ind,val,'r*')
%     subplot(212)
%     plot(DurFzTot(mm,:),'b'), hold on
%     plot(ind,DurFzTot(mm,ind),'r*')
%     pause
    LitEp=and(FreezeEpoch-TotalNoiseEpoch,intervalSet(CSPLUS(:)*1e4,CSPLUS(:)*1e4+60*1e4));
    TimeToUse=(Range(Restrict(Sptsd,LitEp))); ChunkSz=floor(length(TimeToUse)/8);
    for c=1:8
        SaveSpecFz{1,mm}(c,:)=nanmean((Data(Restrict(Sptsd,ts(TimeToUse(1+(c-1)*ChunkSz:(c)*ChunkSz))))));
    end

    % Spectra cutting up first 150s freezing 
    LitEp=and(FreezeEpoch-TotalNoiseEpoch,intervalSet(CSPLUS(:)*1e4,CSPLUS(:)*1e4+60*1e4));
    TimeToUse=(Range(Restrict(Sptsd,LitEp)));TimeToUse=TimeToUse(1:min(floor(150/median(diff(Range(Sptsd,'s')))),length(TimeToUse))); 
    ChunkSz=floor(min(floor(150/median(diff(Range(Sptsd,'s')))),length(TimeToUse))/8);
    for c=1:8
        SaveSpecFz{2,mm}(c,:)=nanmean((Data(Restrict(Sptsd,ts(TimeToUse(1+(c-1)*ChunkSz:(c)*ChunkSz))))));
    end


    LitEp=FreezeEpoch-TotalNoiseEpoch;
    % Distributions of peak frequency
    if sum(Stop(LitEp)-Start(LitEp))>2*1e4
        for s=1:length(Start(LitEp))
            dur=(Stop(subset(LitEp,s))-Start(subset(LitEp,s)));
            Str=Start(subset(LitEp,s));
            if  dur<3.5*1e4 & dur>1.5*1e4
                SaveLItSpec{mm,1}(count1,:)=nanmean(Data(Restrict(Sptsd,subset(LitEp,s))));
                count1=count1+1;
            else
                numbins=round(dur/WndwSz);
                epdur=dur/numbins;
                for nn=1:numbins
                    SaveLItSpec{mm,1}(count1,:)=nanmean(Data(Restrict(Sptsd,intervalSet(Str+epdur*(nn-1),Str+epdur*(nn)))));
                    count1=count1+1;
                end
                
            end
        end
    end
end

% Look at distributions of peak frequencies
fig=figure;fig.Name=['B Freq Dist SoundCondOrig'];
f=Spectro{3};
fCond=[];
for mm=1:length(Dir.path)
    mm
    for c=1
        if not(isempty(SaveLItSpec{mm,c}))
            for k=1:size(SaveLItSpec{mm,c},1)
                [val,ind]=max(SaveLItSpec{mm,c}(k,LimFreq:end)); ind=ind+LimFreq;
                fCond=[fCond,f(ind)];
            end
        end
    end
    
end
nhist({fCond},'samebins','numbins',1)
xlim([1 15]),line([3 3],ylim,'color','k'),line([5 5],ylim,'color','k')
saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
close(fig)


% Look at distributions of peak frequencies one on f
fig=figure;fig.Name=['B Freq Dist 1 on of SoundCondOrig'];
f=Spectro{3};
fCond=[];
for mm=1:length(Dir.path)
    mm
    for c=1
        if not(isempty(SaveLItSpec{mm,c}))
            for k=1:size(SaveLItSpec{mm,c},1)
                [val,ind]=max(Spectro{3}(LimFreq:end).*SaveLItSpec{mm,c}(k,LimFreq:end)); ind=ind+LimFreq-1;
                fCond=[fCond,f(ind)];
            end
        end
    end
    
end
nhist({fCond},'samebins','numbins',1)
xlim([1 15]),line([3 3],ylim,'color','k'),line([5 5],ylim,'color','k')
xlabel('freq')
saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
close(fig)


% Individual frequency distributions
fig=figure;fig.Name=['B Indiv Freq Distrib SoundCondOrig'];
clear fTest fCond
f=Spectro{3};
for mm=1:length(Dir.path)
    fCond{mm}=[];
    subplot(ceil(length(Dir.path)/2),2,mm)
    
    for c=1
        if not(isempty(SaveLItSpec{mm,c}))
            for k=1:size(SaveLItSpec{mm,c},1)
                [val,ind]=max(SaveLItSpec{mm,c}(k,LimFreq:end)); ind=ind+LimFreq;
                fCond{mm}=[fCond{mm},f(ind)];
            end
        end
    end
    
    nhist({fCond{mm}},'samebins')
    xlim([1 15]),line([3 3],ylim,'color','k','linewidth',2,'linestyle',':'),line([5 5],ylim,'color','k','linewidth',2,'linestyle',':')
end
saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
close(fig)



% Averaged individual frequency distributions
fig=figure;fig.Name='BFreq Dist Av Of Mice SoundCondOrig';
clear YCond YTest
BinLims=[0.25:0.25:20]
for mm=1:length(Dir.path)
    if not(isempty(fCond{mm}))
        [YCond(mm,:),X]=hist(fCond{mm},BinLims);YCond(mm,:)=YCond(mm,:)./sum(YCond(mm,:));
    else
        YCond(mm,:)=nan(1,length(BinLims));
    end
end
stairs(BinLims,smooth(nanmean(YCond),5),'r','linewidth',3);
xlim([1 15]),line([3 3],ylim,'color','k','linewidth',2,'linestyle',':'),line([5 5],ylim,'color','k','linewidth',2,'linestyle',':')
xlabel('freq')
saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
close(fig)


% Individual frequency distributions 1 over f correction
fig=figure;fig.Name=['B Indiv Freq Distrib 1 on f SoundCondOrig'];
clear fTest fCond
f=Spectro{3};
for mm=1:length(Dir.path)
    fCond{mm}=[];
    subplot(ceil(length(Dir.path)/2),2,mm)
    
    for c=1
        if not(isempty(SaveLItSpec{mm,c}))
            for k=1:size(SaveLItSpec{mm,c},1)
                [val,ind]=max(Spectro{3}(LimFreq:end).*SaveLItSpec{mm,c}(k,LimFreq:end)); ind=ind+LimFreq-1;
                fCond{mm}=[fCond{mm},f(ind)];
            end
        end
    end
    
    nhist({fCond{mm}},'samebins')
    xlim([1 15]),line([3 3],ylim,'color','k','linewidth',2,'linestyle',':'),line([5 5],ylim,'color','k','linewidth',2,'linestyle',':')
end
saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
close(fig)


% Averaged individual frequency distributions 1 over f correction
fig=figure;fig.Name='BFreq Dist Av Of Mice SoundCondOrig';
clear YCond YTest
BinLims=[0.1:0.1:20]
for mm=1:length(Dir.path)
    if not(isempty(fCond{mm}))
        [YCond(mm,:),X]=hist(fCond{mm},BinLims);YCond(mm,:)=YCond(mm,:)./sum(YCond(mm,:));
    else
        YCond(mm,:)=nan(1,length(BinLims));
    end
end
stairs(BinLims,smooth(nanmean(YCond),5),'r','linewidth',3);
line([3 3],ylim,'color','k','linewidth',2,'linestyle',':'),line([5 5],ylim,'color','k','linewidth',2,'linestyle',':')
xlabel('freq')
saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
close(fig)


% Average Spectra one on f
fig=figure;fig.Name=['B Av spec onf SoundCondOrig'];
MeanSpecTest=[];    MeanSpecCond=[];
for mm=1:length(Dir.path)
    if not(isempty(SaveSpec{mm,1}))
        % normalize by total power for between mice
        % averaging
        MeanSpecCond=[MeanSpecCond;Spectro{3}.*(nanmean(SaveSpec{mm,1},1)./nanmean(nanmean(SaveSpec{mm,1}(LimFreq:end),1)))];
    end
end
hold on
g=shadedErrorBar(Spectro{3},nanmean(MeanSpecCond),[stdError(MeanSpecCond);stdError(MeanSpecCond)],'r')
xlim([1 15]),line([3 3],ylim,'color','k'),line([5 5],ylim,'color','k')
xlabel('freq')
saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
close(fig)


% Average Spectra
fig=figure;fig.Name=['B Av spec SoundCondOrig'];
MeanSpecTest=[];    MeanSpecCond=[];
for mm=1:length(Dir.path)
    if not(isempty(SaveSpec{mm,1}))
        MeanSpecCond=[MeanSpecCond;nanmean(SaveSpec{mm,1},1)./nanmean(nanmean(SaveSpec{mm,1}(LimFreq:end)))];
    end
end
hold on
g=shadedErrorBar(Spectro{3},nanmean(MeanSpecCond),[stdError(MeanSpecCond);stdError(MeanSpecCond)],'r')
xlim([1 15]),line([3 3],ylim,'color','k'),line([5 5],ylim,'color','k')
xlabel('freq')
saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
close(fig)

% Look at how frequencies evolve
fig=figure;fig.Name=['B Evolution of frequencies SoundCondOrig'];
Titre={'Sound','Sound+30','Sound+60'};
clear PeakVals
for i=1:3
AllDat=zeros(263,12);
AllDatIsNan=zeros(263,12);
for mm=1:length(Dir.path)
    ThisDat=(reshape([SaveSpecCS{i}{mm,:}],263,12));
    ThisDat=ThisDat./nanmean(nanmean(ThisDat));
    [val,ind]=max(ThisDat);
    PeakVals(mm,:)=Spectro{3}(ind);
    PeakVals(mm, PeakVals(mm,:)==0)=NaN;
    PeakValsPower(mm,:)=val;
    for c=1:12
        MeanVals(mm,c)=mean(ThisDat(1:100,c).*Spectro{3}(1:100)')./mean(ThisDat(1:100,c));
    end
    
    for c=1:12
        for f=1:263
            AllDat(f,c)=nansum([AllDat(f,c),ThisDat(f,c)]);
            AllDatIsNan(f,c)=AllDatIsNan(f,c)+double(isnan(ThisDat(f,c)));
        end
    end
end

subplot(3,3,i)
imagesc([1:12],Spectro{3},((AllDat./(mm-AllDatIsNan)))), axis xy
ylim([0 15])
title(Titre{i})
if i==1
    ylabel('Frequency')
end
subplot(3,3,i+3)
hold on
errorbar(nanmean(PeakVals),stdError(PeakVals),'r','linewidth',3), axis xy
errorbar(nanmean(MeanVals),stdError(MeanVals),'b','linewidth',3), axis xy
a=[1:12]'*ones(1,length(Dir.path));a=a(:);
mn=MeanVals';mn=mn(:);
amn=a;amn(isnan(mn))=[];mn(isnan(mn))=[];
[R1,P1]=corrcoef(amn,mn);
pk=PeakVals';pk=pk(:);
apk=a;apk(isnan(pk))=[];pk(isnan(pk))=[];
[R2,P2]=corrcoef(apk,pk);
l=legend(sprintf(['PeakVal \nP=',num2str(round(P2(1,2),3)),' R=',num2str(round(R2(1,2),2))]),...
sprintf(['Barycentre \nP=',num2str(round(P1(1,2),3)),' R=',num2str(round(R1(1,2),2))]));
set(l,'FontSize',5)
xlim([1 12]),ylim([3 6])
if i==1
    ylabel('Frequency')
end
subplot(3,3,i+6)
hold on
errorbar(nanmean(DurFz{i}),stdError(DurFz{i}),'k','linewidth',3), axis xy
xlim([1 12])
if i==1
    ylabel('Time Fz')
end
xlabel('CS+ num')
end
saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
close(fig)

fig=figure;fig.Name=['B Evolution of frequencies dur Fz SoundCondOrig'];
clear PeakVals MeanVals
subplot(221)
AllDat=zeros(263,8);
for mm=1:length(Dir.path)
    try
    ThisDat=SaveSpecFz{1,mm}';
    AllDat=AllDat+SaveSpecFz{1,mm}'./nanmean(nanmean(SaveSpecFz{1,mm}'));
    [val,ind]=max(ThisDat);
    PeakVals(mm,:)=Spectro{3}(ind);
    PeakVals(mm, PeakVals(mm,:)==0)=NaN;
    for c=1:8
        MeanVals(mm,c)=mean(ThisDat(1:100,c).*Spectro{3}(1:100)')./mean(ThisDat(1:100,c));
    end
    end
end
imagesc([1:8]/8,Spectro{3},AllDat)
ylim([0 15])
axis xy
title('Data up to change point')
subplot(223)
hold on
errorbar(nanmean(PeakVals),stdError(PeakVals),'r','linewidth',3), axis xy
errorbar(nanmean(MeanVals),stdError(MeanVals),'b','linewidth',3), axis xy
a=[1:8]'*ones(1,length(Dir.path));a=a(:);
mn=MeanVals';mn=mn(:);
amn=a;amn(isnan(mn))=[];mn(isnan(mn))=[];
[R1,P1]=corrcoef(amn,mn);
pk=PeakVals';pk=pk(:);
apk=a;apk(isnan(pk))=[];pk(isnan(pk))=[];
[R2,P2]=corrcoef(apk,pk);
l=legend(sprintf(['PeakVal \nP=',num2str(round(P2(1,2),3)),' R=',num2str(round(R2(1,2),2))]),...
sprintf(['Barycentre \nP=',num2str(round(P1(1,2),3)),' R=',num2str(round(R1(1,2),2))]));
set(l,'FontSize',5)
xlim([1 8]),ylim([3.5 6])
clear PeakVals MeanVals
subplot(222)
AllDat=zeros(263,8);
for mm=1:length(Dir.path)
    ThisDat=SaveSpecFz{2,mm}';
AllDat=AllDat+SaveSpecFz{2,mm}'./nanmean(nanmean(SaveSpecFz{2,mm}'));
[val,ind]=max(ThisDat);
    PeakVals(mm,:)=Spectro{3}(ind);
    PeakVals(mm, PeakVals(mm,:)==0)=NaN;
    for c=1:8
        MeanVals(mm,c)=mean(ThisDat(1:100,c).*Spectro{3}(1:100)')./mean(ThisDat(1:100,c));
    end
end
imagesc([1:8]/8,Spectro{3},AllDat)
ylim([0 15])
axis xy
title('Data for first 150s ')
subplot(224)
hold on
errorbar(nanmean(PeakVals),stdError(PeakVals),'r','linewidth',3), axis xy
errorbar(nanmean(MeanVals),stdError(MeanVals),'b','linewidth',3), axis xy
a=[1:8]'*ones(1,length(Dir.path));a=a(:);
mn=MeanVals';mn=mn(:);
amn=a;amn(isnan(mn))=[];mn(isnan(mn))=[];
[R1,P1]=corrcoef(amn,mn);
pk=PeakVals';pk=pk(:);
apk=a;apk(isnan(pk))=[];pk(isnan(pk))=[];
[R2,P2]=corrcoef(apk,pk);
l=legend(sprintf(['PeakVal \nP=',num2str(round(P2(1,2),3)),' R=',num2str(round(R2(1,2),2))]),...
sprintf(['Barycentre \nP=',num2str(round(P1(1,2),3)),' R=',num2str(round(R1(1,2),2))]));
set(l,'FontSize',5)
xlim([1 8]),ylim([3.5 6])
saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
close(fig)


