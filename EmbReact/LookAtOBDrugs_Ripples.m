clear all
cd /media/nas6/ProjetEmbReact/SB_Data
load('VarSleepPre.mat')

VarSleepPre.DrugType{find(VarSleepPre.MouseID ==11184)} = 'DIAZEPAM';
MiceID.DZP = find(not(cellfun(@isempty,strfind(VarSleepPre.DrugType,'DIAZEPAM'))));
MiceID.SAL = find(not(cellfun(@isempty,strfind(VarSleepPre.DrugType,'SAL'))) | not(cellfun(@isempty,strfind(VarSleepPre.DrugType,'SALINE'))));
MiceID.MDZ = find(not(cellfun(@isempty,strfind(VarSleepPre.DrugType,'MDZ'))));
MiceID.MDZ(1) = [];
MiceID.FlxCh =  find(not(cellfun(@isempty,strfind(VarSleepPre.DrugType,'CHRONIC FLUOXETINE'))) | not(cellfun(@isempty,strfind(VarSleepPre.DrugType,'CHRONIC_FLUOXETINE'))) | not(cellfun(@isempty,strfind(VarSleepPre.DrugType,'FLXCHRONIC'))));
MiceID.FlxAc = find(not(cellfun(@isempty,strfind(VarSleepPre.DrugType,'FLX'))));
MiceID.FlxAc(ismember(MiceID.FlxAc,MiceID.FlxCh)) = [];
MiceID.FlxAc(1) = [];
MiceID.SALEarly = MiceID.SAL(1:7);
MiceID.SALLate= MiceID.SAL(8:end);
MiceID.SALLate(VarSleepPre.MouseID(MiceID.SALLate)==1161) = [];
MiceID.SALLate(VarSleepPre.MouseID(MiceID.SALLate)==1162) = [];
MiceID.SALLate(VarSleepPre.MouseID(MiceID.SALLate)==1144) = [];
MiceID.SALLate(VarSleepPre.MouseID(MiceID.SALLate)==1146) = [];
MiceID.SALLate(VarSleepPre.MouseID(MiceID.SALLate)==1170) = [];
MiceID.SALLate(VarSleepPre.MouseID(MiceID.SALLate)==1172) = [];
MiceID.SALLate(VarSleepPre.MouseID(MiceID.SALLate)==1174) = [];

MiceID.SALLate = MiceID.SALLate([1,3,4,5,6,7]);
MiceID.DZP = MiceID.DZP([2,1,4,3,5,6]);

cd /media/nas6/ProjetEmbReact/Mouse1162/20210202/ProjectEmbReact_M1162_20210202_TestPost_PostDrug/TestPost3
load('H_VHigh_Spectrum.mat')
f = Spectro{3};

%% Figures
%% Extinction
%% Extinction
DrugTypes = {'SALEarly','SALLate','FlxCh','FlxAc','MDZ','DZP'};

figure
for dtype = 1:length(DrugTypes)
    
    subplot(2,3,dtype)
    AllSpecSk = [];
    
    for mm = 1:length(MiceID.(DrugTypes{dtype}))
        Sk = (VarSleepPre.MnNREM_HPC(MiceID.(DrugTypes{dtype})(mm),:));
        Norm = nanmean([Sk(10:end)]);
        AllSpecSk = [AllSpecSk;Sk/Norm];
    end
    %     plot(f,AllSpecSk','color',[1 0.4 0.4])
    hold on
    %     plot(f,AllSpecSf','color',[0.4 0.4 1])
    plot(f,nanmean(AllSpecSk),'k','linewidth',3)
    %     ylim([0 10])
    title(DrugTypes{dtype})
    %    xlim([1 10])
    xlabel('Freq (Hz)')
    grid on
    set(gca,'YScale','log')
    
end


clear all
cd /media/nas6/ProjetEmbReact/SB_Data
load('VarE_V3.mat')

VarE.DrugType{find(VarE.MouseID ==11184)} = 'DIAZEPAM';
MiceID.DZP = find(not(cellfun(@isempty,strfind(VarE.DrugType,'DIAZEPAM'))));
MiceID.SAL = find(not(cellfun(@isempty,strfind(VarE.DrugType,'SAL'))) | not(cellfun(@isempty,strfind(VarE.DrugType,'SALINE'))));
MiceID.MDZ = find(not(cellfun(@isempty,strfind(VarE.DrugType,'MDZ'))));
MiceID.MDZ(1) = [];
MiceID.FlxCh =  find(not(cellfun(@isempty,strfind(VarE.DrugType,'CHRONIC FLUOXETINE'))) | not(cellfun(@isempty,strfind(VarE.DrugType,'CHRONIC_FLUOXETINE'))) | not(cellfun(@isempty,strfind(VarE.DrugType,'FLXCHRONIC'))));
MiceID.FlxAc = find(not(cellfun(@isempty,strfind(VarE.DrugType,'FLX'))));
MiceID.FlxAc(ismember(MiceID.FlxAc,MiceID.FlxCh)) = [];
MiceID.FlxAc(1) = [];
MiceID.SALEarly = MiceID.SAL(1:7);
MiceID.SALLate= MiceID.SAL(8:end);
MiceID.SALLate(VarE.MouseID(MiceID.SALLate)==1161) = [];
MiceID.SALLate(VarE.MouseID(MiceID.SALLate)==1162) = [];
MiceID.SALLate(VarE.MouseID(MiceID.SALLate)==1144) = [];
MiceID.SALLate(VarE.MouseID(MiceID.SALLate)==1146) = [];
MiceID.SALLate(VarE.MouseID(MiceID.SALLate)==1170) = [];
MiceID.SALLate(VarE.MouseID(MiceID.SALLate)==1172) = [];
MiceID.SALLate(VarE.MouseID(MiceID.SALLate)==1174) = [];

MiceID.SALLate = MiceID.SALLate([1,3,4,5,6,7]);
MiceID.DZP = MiceID.DZP([2,1,4,3,5,6]);

cd /media/nas6/ProjetEmbReact/Mouse1162/20210202/ProjectEmbReact_M1162_20210202_TestPost_PostDrug/TestPost3
load('H_VHigh_Spectrum.mat')
f = Spectro{3};

%% Figures
%% Extinction
%% Extinction
DrugTypes = {'SALEarly','SALLate','FlxCh','FlxAc','MDZ','DZP'};

figure
for dtype = 1:length(DrugTypes)
    
    subplot(2,3,dtype)
    AllSpecSk = [];
    AllSpecSf = [];
    
    for mm = 1:length(MiceID.(DrugTypes{dtype}))
        Sf = (VarE.MnSafeSpec_HPC(MiceID.(DrugTypes{dtype})(mm),:));
        Sk = (VarE.MnShockSpec_HPC(MiceID.(DrugTypes{dtype})(mm),:));
        Norm = nanmean([Sf(10:end),Sk(10:end)]);
        AllSpecSk = [AllSpecSk;Sk/Norm];
        AllSpecSf = [AllSpecSf;Sf/Norm];
    end
    %     plot(f,AllSpecSk','color',[1 0.4 0.4])
    hold on
    %     plot(f,AllSpecSf','color',[0.4 0.4 1])
    plot(f,nanmean(AllSpecSk),'r','linewidth',3)
    plot(f,nanmean(AllSpecSf),'b','linewidth',3)
    %     ylim([0 10])
    title(DrugTypes{dtype})
    %    xlim([1 10])
    xlabel('Freq (Hz)')
    grid on
    set(gca,'YScale','log')
    
end


%%
cd /media/nas6/ProjetEmbReact/SB_Data
load('VarCond_V3.mat')

VarCond.DrugType{find(VarCond.MouseID ==11184)} = 'DIAZEPAM';
MiceID.DZP = find(not(cellfun(@isempty,strfind(VarCond.DrugType,'DIAZEPAM'))));
MiceID.SAL = find(not(cellfun(@isempty,strfind(VarCond.DrugType,'SAL'))) | not(cellfun(@isempty,strfind(VarCond.DrugType,'SALINE'))));
MiceID.MDZ = find(not(cellfun(@isempty,strfind(VarCond.DrugType,'MDZ'))));
MiceID.MDZ(1) = [];
MiceID.FlxCh =  find(not(cellfun(@isempty,strfind(VarCond.DrugType,'CHRONIC FLUOXETINE'))) | not(cellfun(@isempty,strfind(VarCond.DrugType,'CHRONIC_FLUOXETINE'))) | not(cellfun(@isempty,strfind(VarCond.DrugType,'FLXCHRONIC'))));
MiceID.FlxAc = find(not(cellfun(@isempty,strfind(VarCond.DrugType,'FLX'))));
MiceID.FlxAc(ismember(MiceID.FlxAc,MiceID.FlxCh)) = [];
MiceID.FlxAc(1) = [];
MiceID.SALEarly = MiceID.SAL(1:7);
MiceID.SALLate= MiceID.SAL(8:end);
MiceID.SALLate(VarCond.MouseID(MiceID.SALLate)==1161) = [];
MiceID.SALLate(VarCond.MouseID(MiceID.SALLate)==1162) = [];
MiceID.SALLate(VarCond.MouseID(MiceID.SALLate)==1144) = [];
MiceID.SALLate(VarCond.MouseID(MiceID.SALLate)==1146) = [];
MiceID.SALLate(VarCond.MouseID(MiceID.SALLate)==1170) = [];
MiceID.SALLate(VarCond.MouseID(MiceID.SALLate)==1172) = [];
MiceID.SALLate(VarCond.MouseID(MiceID.SALLate)==1174) = [];

MiceID.SALLate = MiceID.SALLate([1,3,4,5,6,7]);
MiceID.DZP = MiceID.DZP([2,1,4,3,5,6]);

cd /media/nas6/ProjetEmbReact/Mouse1162/20210202/ProjectEmbReact_M1162_20210202_TestPost_PostDrug/TestPost3
load('H_VHigh_Spectrum.mat')
f = Spectro{3};

%% Figures
%% Extinction
%% Extinction
DrugTypes = {'SALEarly','SALLate','FlxCh','FlxAc','MDZ','DZP'};


for dtype = 1:length(DrugTypes)
    
    subplot(2,3,dtype)
    AllSpecSk = [];
    AllSpecSf = [];
    
    for mm = 1:length(MiceID.(DrugTypes{dtype}))
        Sf = (VarCond.MnSafeSpec_HPC(MiceID.(DrugTypes{dtype})(mm),:));
        Sk = (VarCond.MnShockSpec_HPC(MiceID.(DrugTypes{dtype})(mm),:));
        Norm = nanmean([Sf(10:end),Sk(10:end)]);
        AllSpecSk = [AllSpecSk;Sk/Norm];
        AllSpecSf = [AllSpecSf;Sf/Norm];
    end
    %     plot(f,AllSpecSk','color',[1 0.4 0.4])
    hold on
    %     plot(f,AllSpecSf','color',[0.4 0.4 1])
    plot(f,nanmean(AllSpecSk),'r','linewidth',3)
    plot(f,nanmean(AllSpecSf),'b','linewidth',3)
    %     ylim([0 10])
    title(DrugTypes{dtype})
    %    xlim([1 10])
    xlabel('Freq (Hz)')
    grid on
    set(gca,'YScale','log')
    
end