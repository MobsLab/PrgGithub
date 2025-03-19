[Dir,KeepFirstSessionOnly,CtrlEphys]=GetRightSessionsFor4HzPaper('CtrlAllData')
WndwSz=2*1e4; % size of little window to extract frequency data
cd /media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse244/20150506-EXT-24h-envC
load('behavResources.mat')

for mm = 1:length(Dir.path)
    cd(Dir.path{mm})
    clear FreezeEpoch TotalNoiseEpoch Sp t TotalNoiseEpoch
    
    load('B_Low_Spectrum.mat')
    load('behavResources.mat')
    try
        load('StateEpoch.mat','TotalNoiseEpoch')
    catch
        load('StateEpochSB.mat','TotalNoiseEpoch')
        
    end
    
    load('behavResources.mat')
    try FreezeAccEpoch
    catch FreezeAccEpoch=[];
    end
    if isempty(FreezeAccEpoch)
        FreezeEpoch=FreezeEpoch-TotalNoiseEpoch;
    else
        FreezeEpoch=FreezeAccEpoch-TotalNoiseEpoch;
    end
    
    LitEp=FreezeEpoch-TotalNoiseEpoch;
    FreezeDur(mm) = sum(Stop(LitEp,'s')-Start(LitEp,'s'));

    count1=1;
    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
    
    % Average Spectra
    if not(isempty(Start(LitEp)))
        if sum(Stop(LitEp)-Start(LitEp))>2*1e4
            SaveSpec{mm,1}(1,:)=nanmean((Data(Restrict(Sptsd,LitEp))));
            SaveSpec{mm,1}(1,:) = SaveSpec{mm,1}(1,:)./nansum(SaveSpec{mm,1}(1,14:end));

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
    
    % Spectra cutting up frezing into 8 parts
    for c=1:length(CSPLUS)
        LitEp=and(FreezeEpoch-TotalNoiseEpoch,intervalSet(CSPLUS(c)*1e4,CSPLUS(c)*1e4+60*1e4));
        DurFzTot(mm,c)=sum(Stop(LitEp,'s')-Start(LitEp,'s'));
    end
    
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
    
    
    if exist('ChannelsToAnalyse/dHPC_rip.mat')>0
        LitEp=FreezeEpoch-TotalNoiseEpoch;
        load('Ripples.mat')
        RippleDens(mm) = length(Start(and(RipplesEpochR,LitEp)))./sum(Stop(LitEp,'s')-Start(LitEp,'s'));
        
    else
        RippleDens(mm) = NaN;
    end
    
end

% Values are taken from eyeshock mice
% compare ripple number
Cols = {[0.6 0.6 0.6],[0.6 0.6 1]};
figure
line([0.6 1.4],[0.089 0.089],'color',UMazeColors('Shock'),'linewidth',3)
hold on
line([0.6 1.4],[0.697 0.697],'color',UMazeColors('Safe'),'linewidth',3)
MakeSpreadAndBoxPlot_SB({RippleDens,RippleDens},Cols,1:2)
xlim([0.5 1.5])
ylim([0 1.1])
set(gca,'LineWidth',2,'FontSize',10,'XTick',[])
ylabel('Ripples /sec')
set(gca,'LineWidth',2,'FontSize',15)

% compare spectra
figure
hold on
ylim([0 0.018])
line([4.34 4.34],ylim,'color',UMazeColors('Shock'),'linewidth',3)
line([2.13 2.13],ylim,'color',UMazeColors('Safe'),'linewidth',3)
MeanSpecTest=[];    MeanSpecCond=[];
for mm=1:length(Dir.path)
    if not(isempty(SaveSpec{mm,1}))
        MeanSpecCond=[MeanSpecCond;nanmean(SaveSpec{mm,1},1)];
    end
end
g=shadedErrorBar(Spectro{3},nanmean(MeanSpecCond),[stdError(MeanSpecCond);stdError(MeanSpecCond)],'k')
set(g.patch,'FaceColor',Cols{1},'FaceAlpha',0.5)
set(g.mainLine,'Color',Cols{1},'linewidth',2), hold on
xlim([1 15])
box off
set(gca,'LineWidth',2,'FontSize',15)
xlabel('Frequency(Hz)')
ylabel('Power (AU)')

% show that even though frequency changes during conditionning not in line
% with UMaze
fig=figure;
clear PeakVals MeanVals
AllDat=zeros(263,8);
for mm=1:length(Dir.path)
    try
    ThisDat=SaveSpecFz{1,mm}';
    AllDat=AllDat+SaveSpecFz{1,mm}'./nanmean(nansum(SaveSpecFz{1,mm}'));
    [val,ind]=max(ThisDat);
    PeakVals(mm,:)=Spectro{3}(ind);
    PeakVals(mm, PeakVals(mm,:)==0)=NaN;
    for c=1:8
        MeanVals(mm,c)=mean(ThisDat(1:100,c).*Spectro{3}(1:100)')./sum(ThisDat(1:100,c));
    end
    end
end
imagesc([1:8]/8,Spectro{3},AllDat)
hold on
line(xlim,[4.34 4.34],'color','w','linewidth',8)
line(xlim,[2.13 2.13],'color','w','linewidth',8)
line(xlim,[4.34 4.34],'color',UMazeColors('Shock'),'linewidth',5)
line(xlim,[2.13 2.13],'color',UMazeColors('Safe'),'linewidth',5)
ylim([0 10])
axis xy
errorbar([1:8]/8,nanmean(PeakVals),stdError(PeakVals),'k','linewidth',3), axis xy
a=[1:8]'*ones(1,length(Dir.path));a=a(:);
pk=PeakVals';pk=pk(:);
apk=a;apk(isnan(pk))=[];pk(isnan(pk))=[];
[R2,P2]=corrcoef(apk,pk);
clear PeakVals MeanVals
box off
set(gca,'LineWidth',2,'FontSize',15)
ylabel('Frequency(Hz)')
xlabel('Total freezing duration (norm)')
colorbar
