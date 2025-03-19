clear all,close all
% Files1=PathForExperimentsEmbReactMontreal('UMazeCond');
% Files2=PathForExperimentsEmbReactMontreal('UMazeCondNight');
% Files.path=[Files1.path,Files2.path];
% Files.ExpeInfo=[Files1.ExpeInfo,Files2.ExpeInfo];
% MouseToAvoid=[117,431]; % mice with noisy data to exclude
% Files=RemoveElementsFromDir(Files,'nmouse',MouseToAvoid);
% Get average spectra
clear SaveSpec
Struc={'B','H','PFCx'};
StrucName={'Bulb','dHPC','PFCx'};
WndwSz=2*1e4; % size of little window to extract frequency data
LimFreq=20;



SessNames={ 'Habituation24HPre_PreDrug' 'Habituation_PreDrug' 'HabituationBlockedShock_PreDrug' 'HabituationBlockedSafe_PreDrug',...
    'TestPre_PreDrug' 'UMazeCondExplo_PreDrug' 'UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug' ...
    'UMazeCondExplo_PostDrug' 'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug',...
    'TestPost_PostDrug'  'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug'};
fig=figure;
cols = {'r','b','g','m','c'};
for ss=1:length(SessNames)
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    disp(SessNames{ss})
    for d=1:length(Dir.path)
        for dd=1:length(Dir.path{d})
            if not(Dir.ExpeInfo{d}{dd}.nmouse==117)
                
                cd(Dir.path{d}{dd})
                disp(Dir.path{d}{dd})

                
                clear SaveSpecNoShck SaveSpecShck SaveSpec
                %AvailStruc=Dir.ExpeInfo{d}{dd}.RecordElecs.structure;AvailStruc=[AvailStruc{:}];
                load('B_Low_Spectrum.mat')
                imagesc(Spectro{2},Spectro{3},log(Spectro{1}')), axis xy, hold on
                load('behavResources_SB.mat')
                if not(isempty(Start(TTLInfo.StimEpoch,'s')))
                    plot(Start(TTLInfo.StimEpoch,'s'),16,'w*')
                end
                for k=1:5
                    line([Start(Behav.ZoneEpoch{k},'s') Stop(Behav.ZoneEpoch{k},'s')]',[Start(Behav.ZoneEpoch{k},'s') Stop(Behav.ZoneEpoch{k},'s')]'*0+19,'color',cols{k},'linewidth',4)
                end
                if exist('HeartBeatInfo.mat')>0
                    load('HeartBeatInfo.mat')
                    plot(Range(EKG.HBRate,'s'),Data(EKG.HBRate),'.'), hold on
                end
                if not(isempty((Behav.FreezeAccEpoch)))
                line([Start(Behav.FreezeAccEpoch,'s') Stop(Behav.FreezeAccEpoch,'s')]',[Start(Behav.FreezeAccEpoch,'s') Stop(Behav.FreezeAccEpoch,'s')]'*0+10,'color','c','linewidth',1)
                end
                plot(Range(Behav.MovAcctsd,'s'),Data(Behav.MovAcctsd)/3e8+2)

                %saveas(fig.Number,'BehaviourOverview.png')
                %saveas(fig.Number,'BehaviourOverview.fig')
                clf
                clear EKG Behav TTLInfo
                
            end
        end
        
    end
end

clear all,close all
Files1=PathForExperimentsEmbReactMontreal('SoundCond');
Files2=PathForExperimentsEmbReactMontreal('SoundTest');
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
cols=jet(5);
fig=figure;
for mm=1:size(Files.path,2)
    mm
    MouseName{mm}=num2str(Files.ExpeInfo{mm}{1}.nmouse);
    AvailStruc=Files.ExpeInfo{mm}{1}.RecordElecs.structure;AvailStruc=[AvailStruc{:}];
    if  not(isempty(findstr(AvailStruc,StrucName{ss})))
        for c=1:size(Files.path{mm},2)
            cd( Files.path{mm}{c})
            load('B_Low_Spectrum.mat')
            imagesc(Spectro{2},Spectro{3},log(Spectro{1}')), axis xy, hold on
            load('behavResources.mat')
            if not(isempty(Start(TTLInfo.StimEpoch,'s')))
                plot(Start(TTLInfo.StimEpoch,'s'),16,'w*')
            end
            plot(Start(TTLInfo.SoundEpoch,'s'),14,'r*')
            
            if exist('HeartBeatInfo.mat')>0
                load('HeartBeatInfo.mat')
                plot(Range(EKG.HBRate,'s'),Data(EKG.HBRate),'.'), hold on
            end
            line([Start(Behav.FreezeEpoch,'s') Stop(Behav.FreezeEpoch,'s')]',[Start(Behav.FreezeEpoch,'s') Stop(Behav.FreezeEpoch,'s')]'*0+10,'color','c','linewidth',1)
            pause
            saveas(fig.Number,'BehaviourOverview.png')
            saveas(fig.Number,'BehaviourOverview.fig')
            
            clf
            clear EKG Behav TTLInfo
            
        end
    end
end