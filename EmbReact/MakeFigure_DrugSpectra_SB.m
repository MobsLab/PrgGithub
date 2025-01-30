cd /media/nas6/ProjetEmbReact/SB_Data
load('VarE-Clean.mat')
load('VarEFirst-Clean.mat')
load('VarCond-Clean.mat')

VarCond.DrugType{find(VarCond.MouseID ==11184)} = 'DIAZEPAM';
MiceID.DZP = find(not(cellfun(@isempty,strfind(VarCond.DrugType,'DIAZEPAM'))));
MiceID.SAL = find(not(cellfun(@isempty,strfind(VarCond.DrugType,'SAL'))) | not(cellfun(@isempty,strfind(VarCond.DrugType,'SALINE'))));
MiceID.FlxCh =  find(not(cellfun(@isempty,strfind(VarCond.DrugType,'CHRONIC FLUOXETINE'))) | not(cellfun(@isempty,strfind(VarCond.DrugType,'CHRONIC_FLUOXETINE'))) | not(cellfun(@isempty,strfind(VarCond.DrugType,'FLXCHRONIC'))));
MiceID.FlxAc = find(not(cellfun(@isempty,strfind(VarCond.DrugType,'FLX'))));
MiceID.FlxAc(ismember(MiceID.FlxAc,MiceID.FlxCh)) = [];
MiceID.SALEarly = MiceID.SAL(1:7);
MiceID.SALLate= MiceID.SAL(8:end);
MiceID.SALLate(VarCond.MouseID(MiceID.SALLate)==1161) = [];
MiceID.SALLate(VarCond.MouseID(MiceID.SALLate)==1162) = [];
MiceID.SALLate(VarCond.MouseID(MiceID.SALLate)==1144) = [];
MiceID.SALLate(VarCond.MouseID(MiceID.SALLate)==1146) = [];
MiceID.SALLate(VarCond.MouseID(MiceID.SALLate)==1170) = [];
MiceID.SALLate(VarCond.MouseID(MiceID.SALLate)==1172) = [];
MiceID.SALLate(VarCond.MouseID(MiceID.SALLate)==1174) = [];

cd /media/nas6/ProjetEmbReact/Mouse1204/20210511/ProjectEmbReact_M11204_20210511_ExtinctionBlockedSafe_PostDrug/Ext1
load('B_Low_Spectrum.mat')
f = Spectro{3};

%% Figures
%% Extinction
%% Extinction
DrugTypes = {'SALEarly','FlxCh','FlxAc','SALLate','DZP'};
fig = figure('Name','Extinction');
for dtype = 1:length(DrugTypes)
    
    subplot(5,3,(dtype*3)-2)
    AllSpecSk = [];
    AllSpecSf = [];
    
    for mm = 1:length(MiceID.(DrugTypes{dtype}))
        Sf = VarE.MnSafeSpec(MiceID.(DrugTypes{dtype})(mm),:);
        Sk = VarE.MnShockSpec(MiceID.(DrugTypes{dtype})(mm),:);
        Norm = nanmean([Sf(10:end),Sk(10:end)]);
        AllSpecSk = [AllSpecSk;Sk/Norm];
        AllSpecSf = [AllSpecSf;Sf/Norm];
    end
    plot(f,AllSpecSk','color',[1 0.4 0.4])
    hold on
    plot(f,AllSpecSf','color',[0.4 0.4 1])
    plot(f,nanmean(AllSpecSk),'r','linewidth',3)
    plot(f,nanmean(AllSpecSf),'b','linewidth',3)
    ylim([0 10])
    ylabel(DrugTypes{dtype})
    xlim([1 10])
    xlabel('Freq (Hz)')
    grid on
    
    subplot(5,3,(dtype*3)-1)
    imagesc(f(5:end),1:length(MiceID.(DrugTypes{dtype})),zscore(AllSpecSk(:,5:end)')')
    caxis([-3 3])
    if dtype==1
        title('shock')
    end
    xlim([1 10])
    xlabel('Freq (Hz)')
    grid on
    
    subplot(5,3,(dtype*3))
    imagesc(f(5:end),1:length(MiceID.(DrugTypes{dtype})),zscore(AllSpecSf(:,5:end)')')
    caxis([-3 3])
    if dtype ==1
        title('safe')
    end
    xlim([1 10])
    xlabel('Freq (Hz)')
    grid on
    
end

%% Extinction first 
DrugTypes = {'SALEarly','FlxCh','FlxAc','SALLate','DZP'};
fig = figure('Name','Extinction-FirstSession');
for dtype = 1:length(DrugTypes)
    
    subplot(5,3,(dtype*3)-2)
    AllSpecSk = [];
    AllSpecSf = [];
    
    for mm = 1:length(MiceID.(DrugTypes{dtype}))
        Sf = VarEFirst.MnSafeSpec(MiceID.(DrugTypes{dtype})(mm),:);
        Sk = VarEFirst.MnShockSpec(MiceID.(DrugTypes{dtype})(mm),:);
        Norm = nanmean([Sf(10:end),Sk(10:end)]);
        AllSpecSk = [AllSpecSk;Sk/Norm];
        AllSpecSf = [AllSpecSf;Sf/Norm];
    end
    plot(f,AllSpecSk','color',[1 0.4 0.4])
    hold on
    plot(f,AllSpecSf','color',[0.4 0.4 1])
    plot(f,nanmean(AllSpecSk),'r','linewidth',3)
    plot(f,nanmean(AllSpecSf),'b','linewidth',3)
    ylim([0 10])
    ylabel(DrugTypes{dtype})
    xlim([1 10])
    xlabel('Freq (Hz)')
    grid on
    
    subplot(5,3,(dtype*3)-1)
    imagesc(f(5:end),1:length(MiceID.(DrugTypes{dtype})),zscore(AllSpecSk(:,5:end)')')
    caxis([-3 3])
    if dtype==1
        title('shock')
    end
    xlim([1 10])
    xlabel('Freq (Hz)')
    grid on
    
    subplot(5,3,(dtype*3))
    imagesc(f(5:end),1:length(MiceID.(DrugTypes{dtype})),zscore(AllSpecSf(:,5:end)')')
    caxis([-3 3])
    if dtype ==1
        title('safe')
    end
    xlim([1 10])
    xlabel('Freq (Hz)')
    grid on
    
end

%% Conditionning
fig = figure('Name','Cond');
for dtype = 1:length(DrugTypes)
    
    subplot(5,3,(dtype*3)-2)
    AllSpecSk = [];
    AllSpecSf = [];
    
    for mm = 1:length(MiceID.(DrugTypes{dtype}))
        Sf = VarCond.MnSafeSpec(MiceID.(DrugTypes{dtype})(mm),:);
        Sk = VarCond.MnShockSpec(MiceID.(DrugTypes{dtype})(mm),:);
        Norm = nanmean([Sf(10:end),Sk(10:end)]);
        AllSpecSk = [AllSpecSk;Sk/Norm];
        AllSpecSf = [AllSpecSf;Sf/Norm];
    end
    plot(f,AllSpecSk','color',[1 0.4 0.4])
    hold on
    plot(f,AllSpecSf','color',[0.4 0.4 1])
    plot(f,nanmean(AllSpecSk),'r','linewidth',3)
    plot(f,nanmean(AllSpecSf),'b','linewidth',3)
    ylim([0 10])
    ylabel(DrugTypes{dtype})
    xlim([1 10])
    xlabel('Freq (Hz)')
    grid on
    
    subplot(5,3,(dtype*3)-1)
    imagesc(f(5:end),1:length(MiceID.(DrugTypes{dtype})),zscore(AllSpecSk(:,5:end)')')
    caxis([-3 3])
    if dtype==1
        title('shock')
    end
    xlim([1 10])
    xlabel('Freq (Hz)')
    grid on
    
    subplot(5,3,(dtype*3))
    imagesc(f(5:end),1:length(MiceID.(DrugTypes{dtype})),zscore(AllSpecSf(:,5:end)')')
    caxis([-3 3])
    if dtype ==1
        title('safe')
    end
    xlim([1 10])
    xlabel('Freq (Hz)')
    grid on
    
end


%% Extinction + Cond
fig = figure('Name','Extinction+Cond');
for dtype = 1:length(DrugTypes)
    
    subplot(5,3,(dtype*3)-2)
    AllSpecSk = [];
    AllSpecSf = [];
    
    for mm = 1:length(MiceID.(DrugTypes{dtype}))
        Sf = VarE.MnSafeSpec(MiceID.(DrugTypes{dtype})(mm),:);
        Sk = VarE.MnShockSpec(MiceID.(DrugTypes{dtype})(mm),:);
        
        Sf2 = VarCond.MnSafeSpec(MiceID.(DrugTypes{dtype})(mm),:);
        Sk2 = VarCond.MnShockSpec(MiceID.(DrugTypes{dtype})(mm),:);
        
        Sf(isnan(Sf)) = 0;
        Sf2(isnan(Sf2)) = 0;
        Sk(isnan(Sk)) = 0;
        Sk2(isnan(Sk2)) = 0;
        
        Sk = (Sk*sum(VarE.PosFz{MiceID.(DrugTypes{dtype})(mm)}<0.5) + Sk2*sum(VarCond.PosFz{MiceID.(DrugTypes{dtype})(mm)}<0.5))./(sum(VarE.PosFz{MiceID.(DrugTypes{dtype})(mm)}<0.5) + sum(VarCond.PosFz{MiceID.(DrugTypes{dtype})(mm)}<0.5));
        Sf = (Sf*sum(VarE.PosFz{MiceID.(DrugTypes{dtype})(mm)}>0.5) + Sf2*sum(VarCond.PosFz{MiceID.(DrugTypes{dtype})(mm)}>0.5))./(sum(VarE.PosFz{MiceID.(DrugTypes{dtype})(mm)}>0.5) + sum(VarCond.PosFz{MiceID.(DrugTypes{dtype})(mm)}>0.5));
        
        Norm = nanmean(Sf(10:end) + Sk(10:end))/2;
        AllSpecSk = [AllSpecSk;Sk/Norm];
        AllSpecSf = [AllSpecSf;Sf/Norm];
    end
    plot(f,AllSpecSk','color',[1 0.4 0.4])
    hold on
    plot(f,AllSpecSf','color',[0.4 0.4 1])
    plot(f,nanmean(AllSpecSk),'r','linewidth',3)
    plot(f,nanmean(AllSpecSf),'b','linewidth',3)
    ylim([0 10])
    ylabel(DrugTypes{dtype})
    xlim([1 10])
    xlabel('Freq (Hz)')
    grid on
    
    subplot(5,3,(dtype*3)-1)
    imagesc(f(5:end),1:length(MiceID.(DrugTypes{dtype})),zscore(AllSpecSk(:,5:end)')')
    caxis([-3 3])
    if dtype==1
        title('shock')
    end
    xlim([1 10])
    xlabel('Freq (Hz)')
    grid on
    
    subplot(5,3,(dtype*3))
    imagesc(f(5:end),1:length(MiceID.(DrugTypes{dtype})),zscore(AllSpecSf(:,5:end)')')
    caxis([-3 3])
    if dtype ==1
        title('safe')
    end
    xlim([1 10])
    xlabel('Freq (Hz)')
    grid on
    
end

