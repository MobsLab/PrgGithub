
clear all
clear ZoneTime
BefTime=12*1e4;
TimeForInterpol=[0:0.01:BefTime*2/1e4];
StepBackFromStart=0.5*1e4;


SessTypes = { 'UMazeCondBlockedShock_PostDrug'  'ExtinctionBlockedShock_PostDrug'};
SessTypes = { 'UMazeCondBlockedShock_PreDrug' };

clear RiskAssess
for ss=1:length(SessTypes)
    
    Files=PathForExperimentsEmbReact(SessTypes{ss});
    MouseToAvoid=[560,117,431,795,875]; % mice with noisy data to exclude
    Files=RemoveElementsFromDir(Files,'nmouse',MouseToAvoid);
    disp(SessTypes{ss})
    
    for mm=1:length(Files.path)
        
        JumpNum.(SessTypes{ss}){mm}=[];
        
        for c=1:2
            disp(Files.path{mm}{c})
            cd(Files.path{mm}{c})
            
            load('ExpeInfo.mat')
            RiskAssess.(SessTypes{ss}).MouseNum{mm} = ExpeInfo.nmouse;
            RiskAssess.(SessTypes{ss}).DRUG{mm} = ExpeInfo.DrugInjected;
            
            clear Behav
            load('behavResources_SB.mat')
            
            if not(isfield(Behav,'JumpEpoch'))
                JumpEp = FindJumpsWithAccelerometer_SB(cd,intervalSet(0,2000*1E4));
                Behav.JumpEpoch = JumpEp;

            end
            
            JumpNum.(SessTypes{ss}){mm}=[JumpNum.(SessTypes{ss}){mm},length(Start(Behav.JumpEpoch))];
        end
    end
end

DrugTypes = {'SAL','MDZ','FLX','FLXCHRONIC'};

for ss=1:length(SessTypes)
    
    for dd = 1:length(DrugTypes)
        NumEvents.(SessTypes{ss}).(DrugTypes{dd}) = [];

    end
    RiskAssess.(SessTypes{ss}).DRUG{end} = 'SAL';
    for mm = 1:length(RiskAssess.(SessTypes{ss}).DRUG)
        if not(strcmp(RiskAssess.(SessTypes{ss}).DRUG{mm},'FLX-Ineff'))
            NumEvents.(SessTypes{ss}).(RiskAssess.(SessTypes{ss}).DRUG{mm}) = [NumEvents.(SessTypes{ss}).(RiskAssess.(SessTypes{ss}).DRUG{mm});nansum(JumpNum.(SessTypes{ss}){mm})];

        end
    end
end


for dd = 1:length(DrugTypes)
    AllNumEvents.(DrugTypes{dd}) = [];
    
end

for dd = 1:length(DrugTypes)
    for mm = 1:length(NumEvents.(SessTypes{1}).(DrugTypes{dd}))
        clear tempNum tempMov tempPos tempHR
        for ss=1%:length(SessTypes)
            tempNum(ss,:) = NumEvents.(SessTypes{ss}).(DrugTypes{dd})(mm);
        end
        AllNumEvents.(DrugTypes{dd})(mm)= nansum(tempNum);
        
    end
end

figure
Cols2 = {[0.6 0.6 0.6],[0.6 1 0.6],[1 0.8 1],[0.6 0.4 0.6]};
A = {(AllNumEvents.SAL)/600,(AllNumEvents.MDZ)/600,(AllNumEvents.FLX)/600,AllNumEvents.FLXCHRONIC/600};
MakeSpreadAndBoxPlot_SB(A,Cols2,1:4)
xlim([0.5 4.5])
set(gca,'LineWidth',2,'FontSize',10,'XTick',[1:4],'XTickLabel',{'Sal','Mdz','Flx-Ac','Flx-Chr'})
ylabel('Jump frequency (Hz)')

