clear all
SessNames={'UMazeCond','UMazeCondNight'};
close all
num=0;
for ss=1:length(SessNames)
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    Dir=RemoveElementsFromDir(Dir,'nmouse',117);
    disp(SessNames{ss})
    for d=1:length(Dir.path)
        for dd=1:length(Dir.path{d})
            clear channel
            cd(Dir.path{d}{dd})
                if dd==1
                    num=num+1;
                    Dir.path{d}{dd}
                end
                clear SleepyEpoch Behav
                load('behavResources_SB.mat')
                if not(isempty(Behav.FreezeAccEpoch))
                    Behav.FreezeEpoch=Behav.FreezeAccEpoch;
                end
                load('StateEpochSB.mat','TotalNoiseEpoch','SleepyEpoch','smooth_ghi')
                RemovEpoch=or(or(TTLInfo.StimEpoch,TotalNoiseEpoch),SleepyEpoch);
                TotEpoch=intervalSet(0,max(Range(smooth_ghi)));
                clear EKG
                if exist('HeartBeatInfo.mat')>0
                    load('HeartBeatInfo.mat')
                end
                

                LitEp=and(Behav.FreezeEpoch,(Behav.ZoneEpoch{1}))-RemovEpoch;
                GammaVal.Shc{dd,num}=nanmean(Data(Restrict(smooth_ghi,LitEp)));
                if exist('EKG')>0
                    HRVal.Shc{dd,num}=nanmean(Data(Restrict(EKG.HBRate,LitEp)));
                else
                    HRVal.Shc{dd,num}=NaN;
                end
                
                LitEp=and(Behav.FreezeEpoch,or(Behav.ZoneEpoch{2},Behav.ZoneEpoch{5}))-RemovEpoch;
                GammaVal.Sf{dd,num}=nanmean(Data(Restrict(smooth_ghi,LitEp)));
                if exist('EKG')>0
                    HRVal.Sf{dd,num}=nanmean(Data(Restrict(EKG.HBRate,LitEp)));
                else
                    HRVal.Sf{dd,num}=NaN;
                end

                GammaVal.Fz{dd,num}=nanmean(Data(Restrict(smooth_ghi,(Behav.FreezeEpoch-RemovEpoch))));
                GammaVal.NoFz{dd,num}=nanmean(Data(Restrict(smooth_ghi,TotEpoch-(Behav.FreezeEpoch-RemovEpoch))));
                if exist('EKG')>0
                    HRVal.Fz{dd,num}=nanmean(Data(Restrict(EKG.HBRate,(Behav.FreezeEpoch-RemovEpoch))));
                    HRVal.NoFz{dd,num}=nanmean(Data(Restrict(EKG.HBRate,TotEpoch-(Behav.FreezeEpoch-RemovEpoch))));
                else
                    HRVal.Fz{dd,num}=NaN;
                    HRVal.NoFz{dd,num}=NaN;
                end
                MouseName1(num)=Dir.ExpeInfo{d}{1}.nmouse;
                
        end
    end
end


SessNames={'SleepPostUMaze','SleepPostNight'};
close all
num=0;
for ss=1:length(SessNames)
Dir=PathForExperimentsEmbReact(SessNames{ss});
disp(SessNames{ss})
    for d=1:length(Dir.path)
        for dd=1
            clear channel
            cd(Dir.path{d}{dd})
                if dd==1
                    num=num+1;
                    Dir.path{d}{dd}
                end
                clear SleepyEpoch
                load('StateEpochSB.mat','TotalNoiseEpoch','SWSEpoch','smooth_ghi')
                GammaVal.Sl{dd,num}=nanmean(Data(Restrict(smooth_ghi,SWSEpoch)));
                clear EKG
                if exist('HeartBeatInfo.mat')>0
                    load('HeartBeatInfo.mat')
                end

                if exist('EKG')>0
                    HRVal.Sl{dd,num}=nanmean(Data(Restrict(EKG.HBRate,SWSEpoch)));
                else
                     HRVal.Sl{dd,num}=NaN;
                end

                
                try,
                                    MouseName2(num)=Dir.ExpeInfo{d}{1}.nmouse;
                catch
                                    MouseName2(num)=Dir.ExpeInfo{d}.nmouse;
                end

                
        end
    end
end

temp1=[];    temp2=[];    temp3=[];    temp4=[]; temp5=[];
for nn=1:length(MouseName1)
    nnbis=find(MouseName2==MouseName1(nn));
    
    temp3=[temp3,nanmean([HRVal.Sf{:,nn}])];
    temp4=[temp4,nanmean([HRVal.Shc{:,nn}])];
    temp5=[temp5,nanmean([HRVal.Sl{:,nnbis}])];
    
    
end

figure
A = {temp5,temp3,temp4};
Cols2 = {[0.6 0.6 0.6],UMazeColors('Safe'),UMazeColors('Shock')}
MakeSpreadAndBoxPlot_SB(A,Cols2,[1,2,3])
set(gca,'XTick',[1:3],'XTickLabel',{'Sleep','Fz-Safe','Fz-Shock'},'Linewidth',2,'FontSize',10)
ylabel('Heart rate (Hz)Z')


temp1=[];    temp2=[];    temp3=[];    temp4=[]; temp5=[];
for nn=1:length(MouseName1)
nnbis=find(MouseName2==MouseName1(nn));
temp1=[temp1,nanmean([GammaVal.NoFz{:,nn}])./nanmean([GammaVal.Sl{:,nnbis}])];
temp2=[temp2,nanmean([GammaVal.Fz{:,nn}])./nanmean([GammaVal.Sl{:,nnbis}])];
temp3=[temp3,nanmean([GammaVal.Sf{:,nn}])./nanmean([GammaVal.Sl{:,nnbis}])];
temp4=[temp4,nanmean([GammaVal.Shc{:,nn}])./nanmean([GammaVal.Sl{:,nnbis}])];
temp5=[temp5,nanmean([GammaVal.Sl{:,nnbis}])./nanmean([GammaVal.Sl{:,nnbis}])];
end

figure
A = {temp5,temp3,temp4};
Cols2 = {[0.6 0.6 0.6],UMazeColors('Safe'),UMazeColors('Shock')}
MakeSpreadAndBoxPlot_SB(A,Cols2,[1,2,3])
set(gca,'XTick',[1:3],'XTickLabel',{'Sleep','Fz-Safe','Fz-Shock'})
ylabel('averaged gamma power')
set(gca,'XTick',[1:3],'XTickLabel',{'Sleep','Fz-Safe','Fz-Shock'},'Linewidth',2,'FontSize',10)