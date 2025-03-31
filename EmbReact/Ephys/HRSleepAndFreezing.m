clear all
SessNames={'UMazeCond','UMazeCondNight','UMazeCond_EyeShock'};
close all
num=0;
Lims=[10,15];
for ss=1:length(SessNames)
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    MouseToAvoid=[117,431]; % mice with noisy data to exclude
    Dir=RemoveElementsFromDir(Dir,'nmouse',MouseToAvoid);
    
    disp(SessNames{ss})
    for d=1:length(Dir.path)
        for dd=1:length(Dir.path{d})
            clear channel
            cd(Dir.path{d}{dd})
            if exist('ChannelsToAnalyse/EKG.mat')>0
                if dd==1
                    num=num+1;
                    Dir.path{d}{dd}
                end
                clear SleepyEpoch Behav
                load('behavResources_SB.mat')
                if not(isempty(Behav.FreezeAccEpoch))
                    Behav.FreezeEpoch=Behav.FreezeAccEpoch;
                end
                clear SleepyEpoch
                load('StateEpochSB.mat','TotalNoiseEpoch','SleepyEpoch')
                TTLInfo.StimEpoch=intervalSet(Start(TTLInfo.StimEpoch),Stop(TTLInfo.StimEpoch)+1*1e4);
                if exist('SleepyEpoch')
                    RemovEpoch=or(or(TTLInfo.StimEpoch,TotalNoiseEpoch),SleepyEpoch);
                else
                    RemovEpoch=(or(TTLInfo.StimEpoch,TotalNoiseEpoch)); 
                end
                clear EKG
                if exist('HeartBeatInfo.mat')>0
                   load('HeartBeatInfo.mat') 
                end
                
                load('B_Low_Spectrum.mat')
                fHi=find(Spectro{3}<Lims(2),1,'last');fLo=find(Spectro{3}<Lims(1),1,'last');
                Sptsd=tsd(Spectro{2}*1e4,mean(Spectro{1}(:,fLo:fHi)')');
                TotEpoch=intervalSet(0,max(Range(EKG.HBTimes)));
                
                LitEp=and(Behav.FreezeEpoch,(Behav.ZoneEpoch{1}))-RemovEpoch;
                [HRInfo.Shc{num}{dd},HRSliceBySlice.Shc{num}{dd},SliceDur.Shc{num}{dd}]=CharacterizeHeartRateEpoch(EKG,LitEp,2);
                BetaVal(num).Shc(dd)=mean(Data(Restrict(Sptsd,LitEp)));
                
                LitEp=and(Behav.FreezeEpoch,or(Behav.ZoneEpoch{2},Behav.ZoneEpoch{5}))-RemovEpoch;
                [HRInfo.Sf{num}{dd},HRSliceBySlice.Sf{num}{dd},SliceDur.Sf{num}{dd}]=CharacterizeHeartRateEpoch(EKG,LitEp,2);
                BetaVal(num).Sf(dd)=mean(Data(Restrict(Sptsd,LitEp)));

                [HRInfo.Fz{num}{dd},HRSliceBySlice.Fz{num}{dd},SliceDur.Fz{num}{dd}]=CharacterizeHeartRateEpoch(EKG,(Behav.FreezeEpoch-RemovEpoch),2);
                BetaVal(num).Fz(dd)=mean(Data(Restrict(Sptsd,Behav.FreezeEpoch-RemovEpoch)));
                
                [HRInfo.NoFz{num}{dd},HRSliceBySlice.NoFz{num}{dd},SliceDur.NoFz{num}{dd}]=CharacterizeHeartRateEpoch(EKG,(TotEpoch-Behav.FreezeEpoch)-RemovEpoch,2);
                BetaVal(num).NoFz(dd)=mean(Data(Restrict(Sptsd,(TotEpoch-Behav.FreezeEpoch)-RemovEpoch)));


                MouseName1(num)=Dir.ExpeInfo{d}{1}.nmouse;
                
            end
        end
    end
end

SessNames={'Habituation','HabituationNight'};
close all
num=0;
for ss=1:length(SessNames)
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    MouseToAvoid=[117,431]; % mice with noisy data to exclude
    Dir=RemoveElementsFromDir(Dir,'nmouse',MouseToAvoid);
    disp(SessNames{ss})
    for d=1:length(Dir.path)
        for dd=1:length(Dir.path{d})
            if Dir.ExpeInfo{d}{dd}.nmouse==485
                HRInfo.Hab{num}{dd}.MeanHR=NaN;
                HRInfo.Hab{num}{dd}.StdHR=NaN;
                HRInfo.Hab{num}{dd}.StdInterHB=NaN;
            else
                clear channel
                cd(Dir.path{d}{dd})
                if exist('ChannelsToAnalyse/EKG.mat')>0
                    if dd==1
                        num=num+1;
                        Dir.path{d}{dd}
                    end
                    clear SleepyEpoch
                    load('behavResources.mat')
                    if not(isempty(Behav.FreezeAccEpoch))
                        Behav.FreezeEpoch=Behav.FreezeAccEpoch;
                    end
                    load('StateEpochSB.mat','TotalNoiseEpoch','SleepyEpoch')
                    RemovEpoch=(or(TTLInfo.StimEpoch,TotalNoiseEpoch));
                    
                    load('B_Low_Spectrum.mat')
                    fHi=find(Spectro{3}<Lims(2),1,'last');fLo=find(Spectro{3}<Lims(1),1,'last');
                    Sptsd=tsd(Spectro{2}*1e4,mean(Spectro{1}(:,fLo:fHi)')');
                    
                    load('HeartBeatInfo.mat')
                    TotEpoch=intervalSet(0,max(Range(EKG.HBTimes)));
                    
                    [HRInfo.Hab{num}{dd},HRSliceBySlice.Hab{num}{dd},SliceDur.Hab{num}{dd}]=CharacterizeHeartRateEpoch(EKG,TotEpoch-RemovEpoch,2);
                    BetaVal(num).Hab(dd)=mean(Data(Restrict(Sptsd,TotEpoch-RemovEpoch)));

                end
            end
        end
    end
end

SessNames={'SleepPostUMaze','SleepPostNight'};
close all
num=0;
for ss=1:length(SessNames)
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    MouseToAvoid=[117,431]; % mice with noisy data to exclude
    Dir=RemoveElementsFromDir(Dir,'nmouse',MouseToAvoid);
    disp(SessNames{ss})
    for d=1:length(Dir.path)
        for dd=1
            clear channel
            cd(Dir.path{d}{dd})
            if exist('ChannelsToAnalyse/EKG.mat')>0
                
                if dd==1
                    num=num+1;
                    Dir.path{d}{dd}
                end
                
                load('HeartBeatInfo.mat')
                load('StateEpochSB.mat','TotalNoiseEpoch','SWSEpoch','REMEpoch','Wake')
                
                load('B_Low_Spectrum.mat')
                fHi=find(Spectro{3}<Lims(2),1,'last');fLo=find(Spectro{3}<Lims(1),1,'last');
                Sptsd=tsd(Spectro{2}*1e4,mean(Spectro{1}(:,fLo:fHi)')');

                [HRInfo.SWS{num}{dd},HRSliceBySlice.SWS{num}{dd},SliceDur.SWS{num}{dd}]=CharacterizeHeartRateEpoch(EKG,SWSEpoch,2);
                BetaVal(num).SWS(dd)=nanmean(Data(Restrict(Sptsd,SWSEpoch)));
                [HRInfo.REM{num}{dd},HRSliceBySlice.REM{num}{dd},SliceDur.REM{num}{dd}]=CharacterizeHeartRateEpoch(EKG,REMEpoch,2);
                BetaVal(num).REM(dd)=nanmean(Data(Restrict(Sptsd,REMEpoch)));
                [HRInfo.WK{num}{dd},HRSliceBySlice.WK{num}{dd},SliceDur.WK{num}{dd}]=CharacterizeHeartRateEpoch(EKG,Wake,2);
                BetaVal(num).WK(dd)=nanmean(Data(Restrict(Sptsd,Wake)));

                try,
                    MouseName2(num)=Dir.ExpeInfo{d}{1}.nmouse;
                catch
                    MouseName2(num)=Dir.ExpeInfo{d}.nmouse;
                end
                
            end
        end
    end
end


%%%
Epochs={'Shc','Sf','NoFz','Hab','WK','SWS','REM',};
clear tempMn tempStd MnHR StdHR
for nn=1:length(MouseName2)-1
    nnbis=find(MouseName2==MouseName1(nn));
    if not(isempty(nnbis))
    for ep=1:length(Epochs)
        tempMn{ep}=[];
        tempStd{ep}=[];
    end
    
    for dd=1:size(HRInfo.Fz{nn},2)
        if not(isempty(HRInfo.Fz{nn}{dd}))
            for ep=1:3
                tempMn{ep}=[tempMn{ep},HRInfo.(Epochs{ep}){nn}{dd}.MeanHR];
                tempStd{ep}=[tempStd{ep},HRInfo.(Epochs{ep}){nn}{dd}.StdHR];
            end
        end
    end
    
    for ep=1:3
        MnHR.(Epochs{ep})(nn)=nanmean(tempMn{ep});
        StdHR.(Epochs{ep})(nn)=nanmean(tempStd{ep});
    end
    MnHR.(Epochs{4})(nn)=HRInfo.(Epochs{4}){nn}{1}.MeanHR;
    StdHR.(Epochs{4})(nn)=HRInfo.(Epochs{4}){nn}{1}.StdHR;
    for ep=5:length(Epochs)
        MnHR.(Epochs{ep})(nn)=HRInfo.(Epochs{ep}){nnbis}{1}.MeanHR;
        StdHR.(Epochs{ep})(nn)=HRInfo.(Epochs{ep}){nnbis}{1}.StdHR;
    end 
    end
    
end
figure
bar(1,nanmean(MnHR.SWS),'FaceColor',[0.6 0.6 0.6]), hold on
bar(2,nanmean(MnHR.Sf),'FaceColor',[0.6 0.6 1])
bar(3,nanmean(MnHR.Shc),'FaceColor',[1 0.6 0.6])
plotSpread({MnHR.SWS;MnHR.Shc;MnHR.Sf},'distributionColors',[ 0 0 0;0 0 0;0 0 0])
set(gca,'XTick',[1:3],'XTickLabel',{'Sleep','Fz-Safe','Fz-Shock'})
ylabel('heart rate')
[p(1),h]=ranksum(MnHR.NoFz,MnHR.Sf)
[p(2),h]=ranksum(MnHR.Sf,MnHR.Shc)
[p(3),h]=ranksum(MnHR.NoFz,MnHR.Shc)
sigstar({[1,2],[2,3],[1,3]},p)
ylim([0 1.8])
box off


for nn=1:11
    
    for ep=1:3
        tempMn{ep}=[];
        tempStd{ep}=[];
    end
    
    for dd=1:size(HRInfo.Fz{nn},2)
        if not(isempty(HRInfo.Fz{nn}{dd}))
            for ep=1:3
                tempMn{ep}=[tempMn{ep},HRInfo.(Epochs{ep}){nn}{dd}.MeanHR];
                tempStd{ep}=[tempStd{ep},HRInfo.(Epochs{ep}){nn}{dd}.StdHR];
            end
        end
    end
    
    for ep=1:3
        MnHR.(Epochs{ep})(nn)=nanmean(tempMn{ep});
        StdHR.(Epochs{ep})(nn)=nanmean(tempStd{ep});
    end
    
end

figure
bar(1,nanmean(StdHR.NoFz),'FaceColor',[0.6 0.6 0.6]), hold on
bar(2,nanmean(StdHR.Sf),'FaceColor',[0.6 0.6 1])
bar(3,nanmean(StdHR.Shc),'FaceColor',[1 0.6 0.6])
plotSpread({StdHR.Sf;StdHR.Sf;StdHR.Shc},'distributionColors',[0 0 0;0 0 0;0 0 0])
set(gca,'XTick',[1:3],'XTickLabel',{'NoFz','Fz-Safe','Fz-Shock'})
ylabel('std heart rate')
[p(1),h]=ranksum(StdHR.NoFz,StdHR.Sf)
[p(2),h]=ranksum(StdHR.Sf,StdHR.Shc)
[p(3),h]=ranksum(StdHR.NoFz,StdHR.Shc)
sigstar({[1,2],[2,3],[1,3]},p)
ylim([0 1.8])
box off

figure
bar(1,nanmean(MnHR.NoFz),'FaceColor',[0.6 0.6 0.6]), hold on
bar(2,nanmean(MnHR.Sf),'FaceColor',[0.6 0.6 1])
bar(3,nanmean(MnHR.Shc),'FaceColor',[1 0.6 0.6])
plotSpread({MnHR.NoFz;MnHR.Sf;MnHR.Shc},'distributionColors',[0 0 0;0 0 0;0 0 0])
set(gca,'XTick',[1:3],'XTickLabel',{'NoFz','Fz-Safe','Fz-Shock'})
ylabel('mean heart rate')
[p(1),h]=ranksum(MnHR.NoFz,MnHR.Sf)
[p(2),h]=ranksum(MnHR.Sf,MnHR.Shc)
[p(3),h]=ranksum(MnHR.NoFz,MnHR.Shc)
sigstar({[1,2],[2,3],[1,3]},p)
ylim([0 18])
box off

AllDatMn=[];
AllDatStd=[];
for ep=1:length(Epochs)
    AllDatMn=[AllDatMn;MnHR.(Epochs{ep})];
    AllDatStd=[AllDatStd;StdHR.(Epochs{ep})];
    
end

figure
subplot(121)
plotSpread(AllDatMn','showMM',2), set(gca,'XTick',[1:7],'XTickLabel',Epochs)
ylabel('Mean HR')
subplot(122)
plotSpread(AllDatStd','showMM',2), set(gca,'XTick',[1:7],'XTickLabel',Epochs)
ylabel('Std HR')

%%
Epochs={'Shc','Sf','NoFz','Hab','WK','SWS','REM',};
clear tempMn tempStd 
for nn=1:length(MouseName1)-1
    nnbis=find(MouseName2==MouseName1(nn));
    
    for ep=1:length(Epochs)
        tempBeta{ep}=[];
    end
    
    for dd=1:size(HRInfo.Fz{nn},2)
        if not(isempty(HRInfo.Fz{nn}{dd}))
            for ep=1:3
                tempBeta{ep}=[tempBeta{ep},BetaVal(nn).(Epochs{ep})(dd)];
            end
        end
    end
    
    for ep=1:3
        MnBeta.(Epochs{ep})(nn)=nanmean(tempBeta{ep});
    end
    MnBeta.(Epochs{4})(nn)=BetaVal(nn).(Epochs{4});
    for ep=5:length(Epochs)
        MnBeta.(Epochs{ep})(nn)=BetaVal(nn).(Epochs{ep});
    end
    
end

AllDatMn=[];
for ep=1:length(Epochs)
    AllDatMn=[AllDatMn;MnBeta.(Epochs{ep})];
end

figure
plotSpread(nanzscore(AllDatMn)','showMM',2), set(gca,'XTick',[1:7],'XTickLabel',Epochs)
ylabel('Mean Beta')


figure
for ep=1:length(Epochs)
    subplot(121)
    plot(MnBeta.(Epochs{ep}),MnHR.(Epochs{ep}),'*')
    hold on
    subplot(122)
    plot(MnBeta.(Epochs{ep}),StdHR.(Epochs{ep}),'*')
    hold on
end
legend(Epochs)
% 
% 
% 
% figure
% 
% for d=1:size(HRInfo.Shc,2)
%     temp1=[];    temp2=[];    temp3=[];    temp4=[];
% 
%     for dd=1:size(HRInfo.Shc{d},2)
%         if not(isempty(HRInfo.Shc{d}{dd}))
%            temp1=[temp1,HRInfo.Shc{d}{dd}.MeanHR];
%            temp2=[temp2,HRInfo.Sf{d}{dd}.MeanHR];
%            temp3=[temp3,HRInfo.Shc{d}{dd}.StdHR];
%            temp4=[temp4,HRInfo.Sf{d}{dd}.StdHR];
%         end
%     end
%     MnHR.Shc(d)=nanmean(temp1');
%     MnHR.Sf(d)=nanmean(temp2');
%     SdHR.Shc(d)=nanmean(temp3');
%     SdHR.Sf(d)=nanmean(temp4');
% 
% end
% 
% PlotErrorBar([SdHR.Shc;SdHR.Sf]')
