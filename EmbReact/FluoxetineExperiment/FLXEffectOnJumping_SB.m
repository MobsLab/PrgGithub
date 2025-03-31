clear all

% % Mice with drugs
% SessNames={'UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug' 'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug',...
%     'UMazeCondBlockedShock_PreDrug_TempProt' 'UMazeCondBlockedSafe_PreDrug_TempProt',...
%     'UMazeCondBlockedShock_EyeShock' 'UMazeCondBlockedSafe_EyeShock'};

SessNames={'HabituationBlockedShock_PreDrug' 'HabituationBlockedSafe_PreDrug' 'TestPre_PreDrug',...
    'UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug','UMazeCondExplo_PreDrug',...
    'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug','UMazeCondExplo_PostDrug',...
    'TestPost_PostDrug',...
    'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug' };
% SessNames = {'UMazeCondBlockedShock_PostDrug'};

CalcJumps = 0;
ReloadData = 0;
if CalcJumps
    for ss = 1:length(SessNames)
        Dir=PathForExperimentsEmbReact(SessNames{ss});
        for d=1:length(Dir.path)
            for dd=1:length(Dir.path{d})
                cd(Dir.path{d}{dd})
                if length(Dir.ExpeInfo{d}{dd}.RecordElecs.channel)>32
                    load('behavResources_SB.mat','Behav')
                    %                     if not(isfield(Behav,'JumpEpoch'))
                    disp(Dir.path{d}{dd})
                    JumpEpoch = FindJumpsWithAccelerometer_SB(Dir.path{d}{dd},intervalSet(0,max(Range(Behav.MovAcctsd))));
                    load('behavResources_SB.mat','Behav')
                    Behav.JumpEpoch = JumpEpoch;
                    save('behavResources_SB.mat','Behav','-append')
                    clear Behav JumpEpoch
                    %                     end
                end
            end
        end
    end
end

if ReloadData
    SALMice = [688,739,777,779];
    FLXMice = [740,750,778,775];

    for ss = 1:length(SessNames)
        Dir=PathForExperimentsEmbReact(SessNames{ss});
        for d=1:length(Dir.path)
            for dd=1:length(Dir.path{d})
                cd(Dir.path{d}{dd})
                clear Behav ExpeInfo
                load('ExpeInfo.mat')
                load('behavResources_SB.mat','Behav')
                
                              
                if (double(strcmp(ExpeInfo.DrugInjected,'FLX'))+double(strcmp(ExpeInfo.DrugInjected,'FLX-Ineff'))*4)==0
                    MouseNum = find(SALMice==ExpeInfo.nmouse);
                    MouseType = 'Sal';
                else
                    MouseNum = find(FLXMice==ExpeInfo.nmouse);
                    MouseType = 'Flx';
                end
                
                if isfield(Behav,'EscapeLat')
                    Behav.JumpEpoch = and(Behav.JumpEpoch,intervalSet(0,300*1e4));
                    EpochDur = 300;
                else
                    EpochDur =  max(Range(Behav.MovAcctsd,'s'));
                end
            
                JumpNumber.(SessNames{ss}).(MouseType)(MouseNum,dd) = length(Start(Behav.JumpEpoch))./EpochDur;
                MouseNumber.(SessNames{ss}).(MouseType)(d) = ExpeInfo.nmouse;
            end
        end
    end
else
    load('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/FluoxetineAnalysis/AnalysisSpet2018/FLX_JumpEffect.mat')
end
% save('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/FluoxetineAnalysis/AnalysisSpet2018/FLX_JumpEffect.mat','JumpNumber','MouseNumber')



figure
clf
for ss = 1:length(SessNames)
    subplot(3,4,ss)
    PlotErrorBarN_KJ([nanmean(JumpNumber.(SessNames{ss}).Sal,2),nanmean(JumpNumber.(SessNames{ss}).Flx,2)],'newfig',0,'paired',0),
    ylim([0 0.2])
    ylabel('Jump Rate')
    set(gca,'XTick',[1:2],'XTickLabel',{'Sal','Flx'})
    title((SessNames{ss}))
end

