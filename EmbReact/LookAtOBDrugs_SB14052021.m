clear all
clear Dir
Sessnames = {'UMazeCondExplo_PostDrug','UMazeCondBlockedShock_PostDrug','UMazeCondBlockedSafe_PostDrug'};
for d = 1:3
    Dir{d} = PathForExperimentsEmbReact(Sessnames{d});
end

for mouse = 29:length(Dir{1}.path)
    try
        mouse
        VarCond.DrugType{mouse} = Dir{1}.ExpeInfo{mouse}{1}.DrugInjected;
        VarCond.MouseID(mouse) = Dir{1}.ExpeInfo{mouse}{1}.nmouse;
        
        AllPaths = [];
        for d = 1:3
            AllPaths = [AllPaths,Dir{d}.path{mouse}];
        end
        try
            SpecOB = ConcatenateDataFromFolders_SB(AllPaths,'spectrum','spec_chan_num',num2str(Dir.ExpeInfo{mouse}{1}.ChannelsToAnalyse.Bulb_deep));
        catch
            SpecOB = ConcatenateDataFromFolders_SB(AllPaths,'spectrum','prefix','B_Low');
        end
        
       clear SpecHPC_High 
try
    SpecHPC_High = ConcatenateDataFromFolders_SB(AllPaths,'spectrum','prefix','H_VHigh');
end   
        FreezeEpoch = ConcatenateDataFromFolders_SB(AllPaths,'epoch','epochname','freezeepoch');
        FreezeEpoch = dropShortIntervals(FreezeEpoch,3*1E4);
        ZoneEpoch = ConcatenateDataFromFolders_SB(AllPaths,'epoch', 'epochname','zoneepoch');
        LinPos = ConcatenateDataFromFolders_SB(AllPaths,'linearposition');
        OBFreq_WV = ConcatenateDataFromFolders_SB(AllPaths,'instfreq','suffix_instfreq','B','method','WV');
        OBFreq_PT = ConcatenateDataFromFolders_SB(AllPaths,'instfreq','suffix_instfreq','B','method','PT');
        
        SpecHPC = [];
        try
            try
                if isfield(Dir.ExpeInfo{mouse}{1}.ChannelsToAnalyse,'dHPC_deep')
                    SpecHPC = ConcatenateDataFromFolders_SB(AllPaths,'spectrum','spec_chan_num',num2str(Dir.ExpeInfo{mouse}{1}.ChannelsToAnalyse.dHPC_deep));
                elseif isfield(Dir.ExpeInfo{mouse}{1}.ChannelsToAnalyse,'dHPC_rip')
                    SpecHPC = ConcatenateDataFromFolders_SB(AllPaths,'spectrum','spec_chan_num',num2str(Dir.ExpeInfo{mouse}{1}.ChannelsToAnalyse.dHPC_rip));
                else
                    SpecHPC = ConcatenateDataFromFolders_SB(AllPaths,'spectrum','spec_chan_num',num2str(Dir.ExpeInfo{mouse}{1}.ChannelsToAnalyse.dHPC_sup));
                end
                
            catch
                SpecHPC = ConcatenateDataFromFolders_SB(AllPaths,'spectrum','prefix','H_Low');
            end
        end
        
        % get ratio hi vs low power
        Sp = Data(SpecOB);
        HiBreath = tsd(Range(SpecOB),nanmean(Sp(:,10:40),2));
        LoBreath = tsd(Range(SpecOB),nanmean(Sp(:,40:70),2));
        
        NewTs = ts(Range(Restrict(HiBreath,FreezeEpoch)));
        OBFreq_WV = Restrict(OBFreq_WV,NewTs,'align','prev');
        OBFreq_PT = Restrict(OBFreq_PT,NewTs,'align','prev');
        LinPos = Restrict(LinPos,NewTs,'align','prev');
        
        %% Variables to study
        VarCond.MnShockSpec(mouse,:) = nanmean(Data(Restrict(SpecOB,and(FreezeEpoch,ZoneEpoch{1}))));
        VarCond.MnSafeSpec(mouse,:) = nanmean(Data(Restrict(SpecOB,and(FreezeEpoch,or(ZoneEpoch{2},ZoneEpoch{4})))));
        
        if not(isempty(SpecHPC))
            SpH = Data(SpecHPC);
            VarCond.MnShockSpec_H(mouse,:) = nanmean(Data(Restrict(SpecHPC,and(FreezeEpoch,ZoneEpoch{1}))));
            VarCond.MnSafeSpec_H(mouse,:) = nanmean(Data(Restrict(SpecHPC,and(FreezeEpoch,or(ZoneEpoch{2},ZoneEpoch{4})))));
            LowTheta = tsd(Range(SpecHPC),nanmean(SpH(:,80:120),2)./nanmean(SpH(:,20:end),2));
            VarCond.LowHPCTheta{mouse} = Data(Restrict(LowTheta,FreezeEpoch));
        end
        
        
        VarCond.HiOBPower{mouse} = Data(Restrict(HiBreath,FreezeEpoch));
        VarCond.LoOBPower{mouse} = Data(Restrict(LoBreath,FreezeEpoch));
        VarCond.PosFz{mouse} = Data((LinPos));
        
        VarCond.OB_WVFreq{mouse} = Data((OBFreq_WV));
        VarCond.OB_PTFreq{mouse} = Data((OBFreq_PT));
        
        try
        VarCond.MnShockSpec_HPC(mouse,:) = nanmean(Data(Restrict(SpecHPC_High,and(FreezeEpoch,ZoneEpoch{1}))));
        VarCond.MnSafeSpec_HPC(mouse,:) = nanmean(Data(Restrict(SpecHPC_High,and(FreezeEpoch,or(ZoneEpoch{2},ZoneEpoch{4})))));
        end
        %
    catch
        keyboard
        disp('error')
    end
end



clear Dir VarE
Sessnames = {'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug'};
for d = 1:2
    Dir{d} = PathForExperimentsEmbReact(Sessnames{d});
end

for mouse = 47:length(Dir{1}.path)
    mouse
    try
        VarE.DrugType{mouse} = Dir{1}.ExpeInfo{mouse}{1}.DrugInjected;
        VarE.MouseID(mouse) = Dir{1}.ExpeInfo{mouse}{1}.nmouse;
        
        AllPaths = [];
        for d = 1:2
            AllPaths = [AllPaths,Dir{d}.path{mouse}];
        end
        try
            SpecOB = ConcatenateDataFromFolders_SB(AllPaths,'spectrum','spec_chan_num',num2str(Dir.ExpeInfo{mouse}{1}.ChannelsToAnalyse.Bulb_deep));
        catch
            SpecOB = ConcatenateDataFromFolders_SB(AllPaths,'spectrum','prefix','B_Low');
        end
        FreezeEpoch = ConcatenateDataFromFolders_SB(AllPaths,'epoch','epochname','freezeepoch');
        FreezeEpoch = dropShortIntervals(FreezeEpoch,3*1E4);
        ZoneEpoch = ConcatenateDataFromFolders_SB(AllPaths,'epoch', 'epochname','zoneepoch');
        LinPos = ConcatenateDataFromFolders_SB(AllPaths,'linearposition');
        OBFreq_WV = ConcatenateDataFromFolders_SB(AllPaths,'instfreq','suffix_instfreq','B','method','WV');
        OBFreq_PT = ConcatenateDataFromFolders_SB(AllPaths,'instfreq','suffix_instfreq','B','method','PT');
        clear SpecHPC_High
        try
            SpecHPC_High = ConcatenateDataFromFolders_SB(AllPaths,'spectrum','prefix','H_VHigh');
        end
        
        SpecHPC = [];
        try
            try
                if isfield(Dir.ExpeInfo{mouse}{1}.ChannelsToAnalyse,'dHPC_deep')
                    SpecHPC = ConcatenateDataFromFolders_SB(AllPaths,'spectrum','spec_chan_num',num2str(Dir.ExpeInfo{mouse}{1}.ChannelsToAnalyse.dHPC_deep));
                elseif isfield(Dir.ExpeInfo{mouse}{1}.ChannelsToAnalyse,'dHPC_rip')
                    SpecHPC = ConcatenateDataFromFolders_SB(AllPaths,'spectrum','spec_chan_num',num2str(Dir.ExpeInfo{mouse}{1}.ChannelsToAnalyse.dHPC_rip));
                else
                    SpecHPC = ConcatenateDataFromFolders_SB(AllPaths,'spectrum','spec_chan_num',num2str(Dir.ExpeInfo{mouse}{1}.ChannelsToAnalyse.dHPC_sup));
                end
                
            catch
                SpecHPC = ConcatenateDataFromFolders_SB(AllPaths,'spectrum','prefix','H_Low');
            end
        end
        
        % get ratio hi vs low power
        Sp = Data(SpecOB);
        HiBreath = tsd(Range(SpecOB),nanmean(Sp(:,10:40),2));
        LoBreath = tsd(Range(SpecOB),nanmean(Sp(:,40:70),2));
        
        % resample everything
        NewTs = ts(Range(Restrict(HiBreath,FreezeEpoch)));
        OBFreq_WV = Restrict(OBFreq_WV,NewTs);
        OBFreq_PT = Restrict(OBFreq_PT,NewTs);
        LinPos = Restrict(LinPos,NewTs);
        
        %% Variables to study
        VarE.MnShockSpec(mouse,:) = nanmean(Data(Restrict(SpecOB,and(FreezeEpoch,ZoneEpoch{1}))));
        VarE.MnSafeSpec(mouse,:) = nanmean(Data(Restrict(SpecOB,and(FreezeEpoch,or(ZoneEpoch{2},ZoneEpoch{4})))));
        
        if not(isempty(SpecHPC))
            SpH = Data(SpecHPC);
            VarE.MnShockSpec_H(mouse,:) = nanmean(Data(Restrict(SpecHPC,and(FreezeEpoch,ZoneEpoch{1}))));
            VarE.MnSafeSpec_H(mouse,:) = nanmean(Data(Restrict(SpecHPC,and(FreezeEpoch,or(ZoneEpoch{2},ZoneEpoch{4})))));
            LowTheta = tsd(Range(SpecHPC),nanmean(Sp(:,80:120),2)./nanmean(Sp(:,20:end),2));
            VarE.LowHPCTheta{mouse} = Data(Restrict(LowTheta,FreezeEpoch));
        end
        
        VarE.HiOBPower{mouse} = Data(Restrict(HiBreath,FreezeEpoch));
        VarE.LoOBPower{mouse} = Data(Restrict(LoBreath,FreezeEpoch));
        VarE.PosFz{mouse} = Data((LinPos));
        
        VarE.OB_WVFreq{mouse} = Data((OBFreq_WV));
        VarE.OB_PTFreq{mouse} = Data((OBFreq_PT));
        
        try
            VarE.MnShockSpec_HPC(mouse,:) = nanmean(Data(Restrict(SpecHPC_High,and(FreezeEpoch,ZoneEpoch{1}))));
            VarE.MnSafeSpec_HPC(mouse,:) = nanmean(Data(Restrict(SpecHPC_High,and(FreezeEpoch,or(ZoneEpoch{2},ZoneEpoch{4})))));
        end
    catch
        keyboard
        disp('error')
    end
    
end

clear all
clear Dir
Sessnames = {'SleepPost_PreDrug'};
for d = 1
    Dir{d} = PathForExperimentsEmbReact(Sessnames{d});
end

for mouse = 29:length(Dir{1}.path)
    try
        mouse
        VarSleepPre.DrugType{mouse} = Dir{1}.ExpeInfo{mouse}{1}.DrugInjected;
        VarSleepPre.MouseID(mouse) = Dir{1}.ExpeInfo{mouse}{1}.nmouse;
        
        AllPaths = [];
        for d = 1:3
            AllPaths = [AllPaths,Dir{d}.path{mouse}];
        end
        try
            SpecOB = ConcatenateDataFromFolders_SB(AllPaths,'spectrum','spec_chan_num',num2str(Dir.ExpeInfo{mouse}{1}.ChannelsToAnalyse.Bulb_deep));
        catch
            SpecOB = ConcatenateDataFromFolders_SB(AllPaths,'spectrum','prefix','B_Low');
        end
        
       clear SpecHPC_High 
try
    SpecHPC_High = ConcatenateDataFromFolders_SB(AllPaths,'spectrum','prefix','H_VHigh');
end   
        FreezeEpoch = ConcatenateDataFromFolders_SB(AllPaths,'epoch','epochname','freezeepoch');
        FreezeEpoch = dropShortIntervals(FreezeEpoch,3*1E4);
        ZoneEpoch = ConcatenateDataFromFolders_SB(AllPaths,'epoch', 'epochname','zoneepoch');
        LinPos = ConcatenateDataFromFolders_SB(AllPaths,'linearposition');
        OBFreq_WV = ConcatenateDataFromFolders_SB(AllPaths,'instfreq','suffix_instfreq','B','method','WV');
        OBFreq_PT = ConcatenateDataFromFolders_SB(AllPaths,'instfreq','suffix_instfreq','B','method','PT');
        
        SpecHPC = [];
        try
            try
                if isfield(Dir.ExpeInfo{mouse}{1}.ChannelsToAnalyse,'dHPC_deep')
                    SpecHPC = ConcatenateDataFromFolders_SB(AllPaths,'spectrum','spec_chan_num',num2str(Dir.ExpeInfo{mouse}{1}.ChannelsToAnalyse.dHPC_deep));
                elseif isfield(Dir.ExpeInfo{mouse}{1}.ChannelsToAnalyse,'dHPC_rip')
                    SpecHPC = ConcatenateDataFromFolders_SB(AllPaths,'spectrum','spec_chan_num',num2str(Dir.ExpeInfo{mouse}{1}.ChannelsToAnalyse.dHPC_rip));
                else
                    SpecHPC = ConcatenateDataFromFolders_SB(AllPaths,'spectrum','spec_chan_num',num2str(Dir.ExpeInfo{mouse}{1}.ChannelsToAnalyse.dHPC_sup));
                end
                
            catch
                SpecHPC = ConcatenateDataFromFolders_SB(AllPaths,'spectrum','prefix','H_Low');
            end
        end
        
        % get ratio hi vs low power
        Sp = Data(SpecOB);
        HiBreath = tsd(Range(SpecOB),nanmean(Sp(:,10:40),2));
        LoBreath = tsd(Range(SpecOB),nanmean(Sp(:,40:70),2));
        
        NewTs = ts(Range(Restrict(HiBreath,FreezeEpoch)));
        OBFreq_WV = Restrict(OBFreq_WV,NewTs,'align','prev');
        OBFreq_PT = Restrict(OBFreq_PT,NewTs,'align','prev');
        LinPos = Restrict(LinPos,NewTs,'align','prev');
        
        %% Variables to study
        VarSleepPre.MnShockSpec(mouse,:) = nanmean(Data(Restrict(SpecOB,and(FreezeEpoch,ZoneEpoch{1}))));
        VarSleepPre.MnSafeSpec(mouse,:) = nanmean(Data(Restrict(SpecOB,and(FreezeEpoch,or(ZoneEpoch{2},ZoneEpoch{4})))));
        
        if not(isempty(SpecHPC))
            SpH = Data(SpecHPC);
            VarSleepPre.MnShockSpec_H(mouse,:) = nanmean(Data(Restrict(SpecHPC,and(FreezeEpoch,ZoneEpoch{1}))));
            VarSleepPre.MnSafeSpec_H(mouse,:) = nanmean(Data(Restrict(SpecHPC,and(FreezeEpoch,or(ZoneEpoch{2},ZoneEpoch{4})))));
            LowTheta = tsd(Range(SpecHPC),nanmean(SpH(:,80:120),2)./nanmean(SpH(:,20:end),2));
            VarSleepPre.LowHPCTheta{mouse} = Data(Restrict(LowTheta,FreezeEpoch));
        end
        
        
        VarSleepPre.HiOBPower{mouse} = Data(Restrict(HiBreath,FreezeEpoch));
        VarSleepPre.LoOBPower{mouse} = Data(Restrict(LoBreath,FreezeEpoch));
        VarSleepPre.PosFz{mouse} = Data((LinPos));
        
        VarSleepPre.OB_WVFreq{mouse} = Data((OBFreq_WV));
        VarSleepPre.OB_PTFreq{mouse} = Data((OBFreq_PT));
        
        try
        VarSleepPre.MnShockSpec_HPC(mouse,:) = nanmean(Data(Restrict(SpecHPC_High,and(FreezeEpoch,ZoneEpoch{1}))));
        VarSleepPre.MnSafeSpec_HPC(mouse,:) = nanmean(Data(Restrict(SpecHPC_High,and(FreezeEpoch,or(ZoneEpoch{2},ZoneEpoch{4})))));
        end
        %
    catch
        keyboard
        disp('error')
    end
end

cd /media/nas6/ProjetEmbReact/SB_Data
save('VarSleepPre.mat','VarSleepPre')


clear all
clear Dir
Sessnames = {'SleepPost_PreDrug'};
for d = 1
    Dir{d} = PathForExperimentsEmbReact(Sessnames{d});
end

for mouse = 1:length(Dir{1}.path)
    try
        mouse
        VarSleepPre.DrugType{mouse} = Dir{1}.ExpeInfo{mouse}{1}.DrugInjected;
        VarSleepPre.MouseID(mouse) = Dir{1}.ExpeInfo{mouse}{1}.nmouse;
        
        AllPaths = [];
        for d = 1
            AllPaths = [AllPaths,Dir{d}.path{mouse}];
        end
        
        clear SpecHPC_High
        try
            SpecHPC_High = ConcatenateDataFromFolders_SB(AllPaths,'spectrum','prefix','H_VHigh');
        end
        
        
        SleepEpoch = ConcatenateDataFromFolders_SB(AllPaths,'epoch','epochname','sleepstates');
        
        
        
        
        try
            VarSleepPre.MnNREM_HPC(mouse,:) = nanmean(Data(Restrict(SpecHPC_High,SleepEpoch{2})));
        end
        %
    catch
        keyboard
        disp('error')
    end
end

cd /media/nas6/ProjetEmbReact/SB_Data
save('VarSleepPre.mat','VarSleepPre')

clear all
clear Dir
Sessnames = {'SleepPost_PostDrug'};
for d = 1
    Dir{d} = PathForExperimentsEmbReact(Sessnames{d});
end

for mouse = 1:length(Dir{1}.path)
    try
        mouse
        VarSleepPost.DrugType{mouse} = Dir{1}.ExpeInfo{mouse}{1}.DrugInjected;
        VarSleepPost.MouseID(mouse) = Dir{1}.ExpeInfo{mouse}{1}.nmouse;
        
        AllPaths = [];
        for d = 1
            AllPaths = [AllPaths,Dir{d}.path{mouse}];
        end
        
        clear SpecHPC_High
        try
            SpecHPC_High = ConcatenateDataFromFolders_SB(AllPaths,'spectrum','prefix','H_VHigh');
        end
        
        
        SleepEpoch = ConcatenateDataFromFolders_SB(AllPaths,'epoch','epochname','sleepstates');
        
        
        
        
        try
            VarSleepPost.MnNREM_HPC(mouse,:) = nanmean(Data(Restrict(SpecHPC_High,SleepEpoch{2})));
        end
        %
    catch
        keyboard
        disp('error')
    end
end

cd /media/nas6/ProjetEmbReact/SB_Data
save('VarSleepPost.mat','VarSleepPost')


cd /media/nas6/ProjetEmbReact/SB_Data

VarCond.DrugType{find(VarCond.MouseID ==11184)} = 'DIAZEPAM';
MiceID.DZP = find(not(cellfun(@isempty,strfind(VarCond.DrugType,'DIAZEPAM'))));
MiceID.SAL = find(not(cellfun(@isempty,strfind(VarCond.DrugType,'SAL'))) | not(cellfun(@isempty,strfind(VarCond.DrugType,'SALINE'))));
MiceID.FlxCh =  find(not(cellfun(@isempty,strfind(VarCond.DrugType,'CHRONIC FLUOXETINE'))) | not(cellfun(@isempty,strfind(VarCond.DrugType,'CHRONIC_FLUOXETINE'))) | not(cellfun(@isempty,strfind(VarCond.DrugType,'FLXCHRONIC'))));
MiceID.FlxAc = find(not(cellfun(@isempty,strfind(VarCond.DrugType,'FLX'))));
MiceID.FlxAc(ismember(MiceID.FlxAc,MiceID.FlxCh)) = [];
MiceID.SALEarly = MiceID.SAL(1:7);
MiceID.SALLate= MiceID.SAL(8:end);
load('B_Low_Spectrum.mat')
f = Spectro{3};

%% Figures
%% Extinction
%% Extinction
DrugTypes = {'SAL','FlxCh','FlxAc','DZP'};
figure
for dtype = 1:length(DrugTypes)
    
    subplot(4,3,(dtype*3)-2)
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
    
    subplot(4,3,(dtype*3)-1)
    imagesc(f(5:end),1:length(MiceID.(DrugTypes{dtype})),zscore(AllSpecSk(:,5:end)')')
    caxis([-3 3])
    if dtype==1
        title('shock')
    end
    xlim([1 10])
    xlabel('Freq (Hz)')
    grid on
    
    subplot(4,3,(dtype*3))
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
DrugTypes = {'SAL','FlxCh','FlxAc','DZP'};
figure
for dtype = 1:length(DrugTypes)
    
    subplot(4,3,(dtype*3)-2)
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
    
    subplot(4,3,(dtype*3)-1)
    imagesc(f(5:end),1:length(MiceID.(DrugTypes{dtype})),zscore(AllSpecSk(:,5:end)')')
    caxis([-3 3])
    if dtype==1
        title('shock')
    end
    xlim([1 10])
    xlabel('Freq (Hz)')
    grid on
    
    subplot(4,3,(dtype*3))
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
DrugTypes = {'SAL','FlxCh','FlxAc','DZP'};
figure
for dtype = 1:length(DrugTypes)
    
    subplot(4,3,(dtype*3)-2)
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
    
    subplot(4,3,(dtype*3)-1)
    imagesc(f(5:end),1:length(MiceID.(DrugTypes{dtype})),zscore(AllSpecSk(:,5:end)')')
    caxis([-3 3])
    if dtype==1
        title('shock')
    end
    xlim([1 10])
    xlabel('Freq (Hz)')
    grid on
    
    subplot(4,3,(dtype*3))
    imagesc(f(5:end),1:length(MiceID.(DrugTypes{dtype})),zscore(AllSpecSf(:,5:end)')')
    caxis([-3 3])
    if dtype ==1
        title('safe')
    end
    xlim([1 10])
    xlabel('Freq (Hz)')
    grid on
    
end


%%
DrugTypes = {'SAL','FlxCh','FlxAc','DZP'};
figure
for dtype = 1:length(DrugTypes)
    
    subplot(4,3,(dtype*3)-2)
    FzPosHist = [];
    
    for mm = 1:length(MiceID.(DrugTypes{dtype}))
        [Y,X] = hist(VarCond.PosFz{MiceID.(DrugTypes{dtype})(mm)},[0:0.1:1]);
        FzPosHist = [FzPosHist;Y/sum(Y)];
    end
    
    plot(X,FzPosHist','color',[0.6 0.6 0.6])
    hold on
    plot(X,nanmean(FzPosHist),'color','k','linewidth',3)
    ylabel(DrugTypes{dtype})
    if dtype==1
        title('Cond')
    end
    xlabel('Lin Pos')
    ylabel('Prop Fz')
    
    subplot(4,3,(dtype*3)-1)
    FzPosHist = [];
    for mm = 1:length(MiceID.(DrugTypes{dtype}))
        [Y,X] = hist(VarE.PosFz{MiceID.(DrugTypes{dtype})(mm)},[0:0.1:1]);
        FzPosHist = [FzPosHist;Y/sum(Y)];
    end
    plot(X,FzPosHist','color',[0.6 0.6 0.6])
    hold on
    plot(X,nanmean(FzPosHist),'color','k','linewidth',3)
    if dtype==1
        title('Ext')
    end
    xlabel('Lin Pos')
    ylabel('Prop Fz')
    
    subplot(4,3,(dtype*3))
    FzPosHist = [];
    
    for mm = 1:length(MiceID.(DrugTypes{dtype}))
        [Y,X] = hist([VarE.PosFz{MiceID.(DrugTypes{dtype})(mm)};VarCond.PosFz{MiceID.(DrugTypes{dtype})(mm)}],[0:0.1:1]);
        FzPosHist = [FzPosHist;Y/sum(Y)];
    end
    plot(X,FzPosHist','color',[0.6 0.6 0.6])
    hold on
    plot(X,nanmean(FzPosHist),'color','k','linewidth',3)
    if dtype==1
        title('Ext + Cond')
    end
    xlabel('Lin Pos')
    ylabel('Prop Fz')
end


%% Correlate with space
figure
for dtype = 1:length(DrugTypes)
    
    subplot(4,3,(dtype*3)-2)
    AllX = [];
    AllPow = [];
    
    for mm = 1:length(MiceID.(DrugTypes{dtype}))
        mouse = MiceID.(DrugTypes{dtype})(mm);
        X = VarCond.PosFz{mouse};
        Pow = (VarCond.HiOBPower{mouse}-VarCond.LoOBPower{mouse})./(VarCond.HiOBPower{mouse}+VarCond.LoOBPower{mouse});
        AllX =  [AllX;X];
        AllPow =  [AllPow;Pow];
        [R,P] = corr(X,Pow);
        RIndivC.(DrugTypes{dtype})(mm) = R;
        PIndivC.(DrugTypes{dtype})(mm) = P;
        
    end
    BadGuys = isnan(AllX) | isnan(AllPow);
    AllX(BadGuys) = [];
    AllPow(BadGuys) = [];
    dscatter(AllX,AllPow)
    [R,P] = corr(AllX,AllPow);
    title(num2str(R))
    xlabel('Lin pos')
    ylabel('Low vs Hi OB power')    
    
    subplot(4,3,(dtype*3)-1)
    AllX = [];
    AllPow = [];
    
    for mm = 1:length(MiceID.(DrugTypes{dtype}))
        mouse = MiceID.(DrugTypes{dtype})(mm);
        X = VarE.PosFz{mouse};
        Pow = (VarE.HiOBPower{mouse}-VarE.LoOBPower{mouse})./(VarE.HiOBPower{mouse}+VarE.LoOBPower{mouse});
        AllX =  [AllX;X];
        AllPow =  [AllPow;Pow];
        [R,P] = corr(X,Pow);
        RIndivE.(DrugTypes{dtype})(mm) = R;
        PIndivE.(DrugTypes{dtype})(mm) = P;
    end
    BadGuys = isnan(AllX) | isnan(AllPow);
    AllX(BadGuys) = [];
    AllPow(BadGuys) = [];
    dscatter(AllX,AllPow)
    [R,P] = corr(AllX,AllPow);
    title(num2str(R))
    xlabel('Lin pos')
    ylabel('Low vs Hi OB power')
    
    subplot(4,3,(dtype*3))
    AllX = [];
    AllPow = [];
    
      for mm = 1:length(MiceID.(DrugTypes{dtype}))
        mouse = MiceID.(DrugTypes{dtype})(mm);
        X = [VarE.PosFz{mouse};VarCond.PosFz{mouse}];
        Pow = [(VarE.HiOBPower{mouse}-VarE.LoOBPower{mouse})./(VarE.HiOBPower{mouse}+VarE.LoOBPower{mouse});...
            (VarCond.HiOBPower{mouse}-VarCond.LoOBPower{mouse})./(VarCond.HiOBPower{mouse}+VarCond.LoOBPower{mouse})];
        AllX =  [AllX;X];
        AllPow =  [AllPow;Pow];
        [R,P] = corr(X,Pow);
        RIndivEC.(DrugTypes{dtype})(mm) = R;
        PIndivEC.(DrugTypes{dtype})(mm) = P;
    end
    BadGuys = isnan(AllX) | isnan(AllPow);
    AllX(BadGuys) = [];
    AllPow(BadGuys) = [];
    dscatter(AllX,AllPow)
    [R,P] = corr(AllX,AllPow);
    title(num2str(R))
    xlabel('Lin pos')
    ylabel('Low vs Hi OB power')

end


figure
subplot(3,3,1)
PlotErrorBarN_KJ(struct2cell(RIndivC),'paired',0,'newfig',0)
set(gca,'XTick',1:4,'XTickLabel',DrugTypes)
xtickangle(45)
ylabel('R')

subplot(3,3,4)
PlotErrorBarN_KJ(struct2cell(RIndivE),'paired',0,'newfig',0)
set(gca,'XTick',1:4,'XTickLabel',DrugTypes)
xtickangle(45)
ylabel('R')

subplot(3,3,7)
PlotErrorBarN_KJ(struct2cell(RIndivEC),'paired',0,'newfig',0)
set(gca,'XTick',1:4,'XTickLabel',DrugTypes)
xtickangle(45)
ylabel('R')

subplot(3,3,2)
AllR = struct2cell(RIndivC);
Sig = cellfun(@(x) x<0.05,struct2cell(PIndivC),'UniformOutput',0);
for dtype = 1:length(DrugTypes)
    AllR{dtype} = AllR{dtype}(Sig{dtype});
end
PlotErrorBarN_KJ(AllR,'paired',0,'newfig',0)
set(gca,'XTick',1:4,'XTickLabel',DrugTypes)
xtickangle(45)
ylabel('R')

subplot(3,3,5)
AllR = struct2cell(RIndivE);
Sig = cellfun(@(x) x<0.05,struct2cell(PIndivE),'UniformOutput',0);
for dtype = 1:length(DrugTypes)
    AllR{dtype} = AllR{dtype}(Sig{dtype});
end
PlotErrorBarN_KJ(AllR,'paired',0,'newfig',0)
set(gca,'XTick',1:4,'XTickLabel',DrugTypes)
xtickangle(45)
ylabel('R')

subplot(3,3,8)
AllR = struct2cell(RIndivEC);
Sig = cellfun(@(x) x<0.05,struct2cell(PIndivEC),'UniformOutput',0);
for dtype = 1:length(DrugTypes)
    AllR{dtype} = AllR{dtype}(Sig{dtype});
end
PlotErrorBarN_KJ(AllR,'paired',0,'newfig',0)
set(gca,'XTick',1:4,'XTickLabel',DrugTypes)
xtickangle(45)
ylabel('R')

subplot(3,3,3)
Sig = cellfun(@(x) x<0.05,struct2cell(PIndivC),'UniformOutput',0);
bar(cellfun(@mean,Sig))
set(gca,'XTick',1:4,'XTickLabel',DrugTypes)
xtickangle(45)
ylabel('Prop corr')

subplot(3,3,6)
Sig = cellfun(@(x) x<0.05,struct2cell(PIndivE),'UniformOutput',0);
bar(cellfun(@mean,Sig))
set(gca,'XTick',1:4,'XTickLabel',DrugTypes)
xtickangle(45)
ylabel('Prop corr')

subplot(3,3,9)
Sig = cellfun(@(x) x<0.05,struct2cell(PIndivEC),'UniformOutput',0);
bar(cellfun(@mean,Sig))
set(gca,'XTick',1:4,'XTickLabel',DrugTypes)
xtickangle(45)
ylabel('Prop corr')

%%
figure
for dtype = 1:length(DrugTypes)
    
    subplot(4,3,(dtype*3)-2)
    AllX = [];
    AllPow = [];
    
    for mm = 1:length(MiceID.(DrugTypes{dtype}))
        mouse = MiceID.(DrugTypes{dtype})(mm);
        X = VarCond.PosFz{mouse};
        Pow = VarCond.OB_PTFreq{mouse}; Pow(Pow>8) = NaN;
        BadGuys = isnan(X) | isnan(Pow);
        X(BadGuys) = [];
        Pow(BadGuys) = [];
        
        AllX =  [AllX;X];
        AllPow =  [AllPow;Pow];
        try
            [R,P] = corr(X,Pow);
            RIndivC.(DrugTypes{dtype})(mm) = R;
            PIndivC.(DrugTypes{dtype})(mm) = P;
        catch
            RIndivC.(DrugTypes{dtype})(mm) = NaN;
            PIndivC.(DrugTypes{dtype})(mm) = NaN;
            
        end
        
    end
    
    dscatter(AllX,AllPow)
    [R,P] = corr(AllX,AllPow);
    title(num2str(R))
    
    subplot(4,3,(dtype*3)-1)
    AllX = [];
    AllPow = [];
    
    for mm = 1:length(MiceID.(DrugTypes{dtype}))
        mouse = MiceID.(DrugTypes{dtype})(mm);
        X = VarE.PosFz{mouse};
        Pow = VarE.OB_PTFreq{mouse};Pow(Pow>8) = NaN;
        BadGuys = isnan(X) | isnan(Pow);
        X(BadGuys) = [];
        Pow(BadGuys) = [];
        AllX =  [AllX;X];
        AllPow =  [AllPow;Pow];
        try
            [R,P] = corr(X,Pow);
            RIndivE.(DrugTypes{dtype})(mm) = R;
            PIndivE.(DrugTypes{dtype})(mm) = P;
        catch
            RIndivE.(DrugTypes{dtype})(mm) = NaN;
            PIndivE.(DrugTypes{dtype})(mm) = NaN;
        end
    end
    BadGuys = isnan(AllX) | isnan(AllPow);
    AllX(BadGuys) = [];
    AllPow(BadGuys) = [];
    
    dscatter(AllX,AllPow)
    [R,P] = corr(AllX,AllPow);
    title(num2str(R))
    
    subplot(4,3,(dtype*3))
    AllX = [];
    AllPow = [];
    
    for mm = 1:length(MiceID.(DrugTypes{dtype}))
        mouse = MiceID.(DrugTypes{dtype})(mm);
        X = [VarE.PosFz{mouse};VarCond.PosFz{mouse}];
        Pow = [VarE.OB_PTFreq{mouse};VarCond.OB_PTFreq{mouse}];Pow(Pow>8) = NaN;
        BadGuys = isnan(X) | isnan(Pow);
        X(BadGuys) = [];
        Pow(BadGuys) = [];
        AllX =  [AllX;X];
        AllPow =  [AllPow;Pow];
        try
            [R,P] = corr(X,Pow);
            RIndivEC.(DrugTypes{dtype})(mm) = R;
            PIndivEC.(DrugTypes{dtype})(mm) = P;
        catch
            RIndivEC.(DrugTypes{dtype})(mm) = NaN;
            PIndivEC.(DrugTypes{dtype})(mm) = NaN;
        end
    end
    BadGuys = isnan(AllX) | isnan(AllPow);
    AllX(BadGuys) = [];
    AllPow(BadGuys) = [];
    
    dscatter(AllX,AllPow)
    [R,P] = corr(AllX,AllPow);
    title(num2str(R))
    xlabel('Lin Pos')
end


figure
subplot(3,3,1)
PlotErrorBarN_KJ(struct2cell(RIndivC),'paired',0,'newfig',0)
set(gca,'XTick',1:4,'XTickLabel',DrugTypes)
xtickangle(45)
ylabel('R')

subplot(3,3,4)
PlotErrorBarN_KJ(struct2cell(RIndivE),'paired',0,'newfig',0)
set(gca,'XTick',1:4,'XTickLabel',DrugTypes)
xtickangle(45)
ylabel('R')

subplot(3,3,7)
PlotErrorBarN_KJ(struct2cell(RIndivEC),'paired',0,'newfig',0)
set(gca,'XTick',1:4,'XTickLabel',DrugTypes)
xtickangle(45)
ylabel('R')

subplot(3,3,2)
AllR = struct2cell(RIndivC);
Sig = cellfun(@(x) x<0.05,struct2cell(PIndivC),'UniformOutput',0);
for dtype = 1:length(DrugTypes)
    AllR{dtype} = AllR{dtype}(Sig{dtype});
end
PlotErrorBarN_KJ(AllR,'paired',0,'newfig',0)
set(gca,'XTick',1:4,'XTickLabel',DrugTypes)
xtickangle(45)
ylabel('R')

subplot(3,3,5)
AllR = struct2cell(RIndivE);
Sig = cellfun(@(x) x<0.05,struct2cell(PIndivE),'UniformOutput',0);
for dtype = 1:length(DrugTypes)
    AllR{dtype} = AllR{dtype}(Sig{dtype});
end
PlotErrorBarN_KJ(AllR,'paired',0,'newfig',0)
set(gca,'XTick',1:4,'XTickLabel',DrugTypes)
xtickangle(45)
ylabel('R')

subplot(3,3,8)
AllR = struct2cell(RIndivEC);
Sig = cellfun(@(x) x<0.05,struct2cell(PIndivEC),'UniformOutput',0);
for dtype = 1:length(DrugTypes)
    AllR{dtype} = AllR{dtype}(Sig{dtype});
end
PlotErrorBarN_KJ(AllR,'paired',0,'newfig',0)
set(gca,'XTick',1:4,'XTickLabel',DrugTypes)
xtickangle(45)
ylabel('R')

subplot(3,3,3)
Sig = cellfun(@(x) x<0.05,struct2cell(PIndivC),'UniformOutput',0);
bar(cellfun(@mean,Sig))
set(gca,'XTick',1:4,'XTickLabel',DrugTypes)
xtickangle(45)
ylabel('Prop corr')

subplot(3,3,6)
Sig = cellfun(@(x) x<0.05,struct2cell(PIndivE),'UniformOutput',0);
bar(cellfun(@mean,Sig))
set(gca,'XTick',1:4,'XTickLabel',DrugTypes)
xtickangle(45)
ylabel('Prop corr')

subplot(3,3,9)
Sig = cellfun(@(x) x<0.05,struct2cell(PIndivEC),'UniformOutput',0);
bar(cellfun(@mean,Sig))
set(gca,'XTick',1:4,'XTickLabel',DrugTypes)
xtickangle(45)
ylabel('Prop corr')


figure
for dtype = 1:length(DrugTypes)
    
    subplot(4,3,(dtype*3)-2)
    ShockHist = [];
    SafeHist = [];
    
    for mm = 1:length(MiceID.(DrugTypes{dtype}))
        mouse = MiceID.(DrugTypes{dtype})(mm);
        X = VarCond.PosFz{mouse};
        Pow = (VarCond.OB_WVFreq{mouse}+VarCond.OB_PTFreq{mouse})/2; Pow(Pow>8) = NaN;
        Y = hist(Pow(X<0.2),[0:0.5:8]);Y = Y/sum(Y);
        ShockHist = [ShockHist;Y];
        Y = hist(Pow(X>0.7),[0:0.5:8]);Y = Y/sum(Y);
        SafeHist = [SafeHist;Y];
    end
    f = [0:0.5:8];
    %       plot(f,ShockHist','color',[1 0.4 0.4])
    hold on
    %     plot(f,SafeHist','color',[0.4 0.4 1])
    plot(f,nanmean(ShockHist)/nanmean(ShockHist(:)),'r','linewidth',3)
    plot(f,nanmean(SafeHist)/nanmean(SafeHist(:)),'b','linewidth',3)
    ylabel(DrugTypes{dtype})
    set(gca,'XTick',1:10,'XScale','linear'), grid on
    title('Cond')
    
    
    subplot(4,3,(dtype*3)-1)
    ShockHist = [];
    SafeHist = [];
    
    for mm = 1:length(MiceID.(DrugTypes{dtype}))
        mouse = MiceID.(DrugTypes{dtype})(mm);
        X = VarE.PosFz{mouse};
        Pow =(VarE.OB_WVFreq{mouse}+VarE.OB_PTFreq{mouse})/2; Pow(Pow>8) = NaN;
        Y = hist(Pow(X<0.2),[0:0.5:8]);Y = Y/sum(Y);
        ShockHist = [ShockHist;Y];
        Y = hist(Pow(X>0.7),[0:0.5:8]);Y = Y/sum(Y);
        SafeHist = [SafeHist;Y];
    end
    f = [0:0.5:8];
    %       plot(f,ShockHist','color',[1 0.4 0.4])
    hold on
    %     plot(f,SafeHist','color',[0.4 0.4 1])
    plot(f,nanmean(ShockHist)/nanmean(ShockHist(:)),'r','linewidth',3)
    plot(f,nanmean(SafeHist)/nanmean(SafeHist(:)),'b','linewidth',3)
    ylabel(DrugTypes{dtype})
    set(gca,'XTick',1:10,'XScale','linear'), grid on
    title('Ext')

    
    subplot(4,3,(dtype*3))
    ShockHist = [];
    SafeHist = [];
    
    for mm = 1:length(MiceID.(DrugTypes{dtype}))
        mouse = MiceID.(DrugTypes{dtype})(mm);
        X = [VarCond.PosFz{mouse};VarE.PosFz{mouse}];
        Pow = [(VarCond.OB_WVFreq{mouse}+VarCond.OB_PTFreq{mouse})/2;(VarE.OB_WVFreq{mouse}+VarE.OB_PTFreq{mouse})/2]; Pow(Pow>8) = NaN;
        Y = hist(Pow(X<0.2),[0:0.5:8]);Y = Y/sum(Y);
        ShockHist = [ShockHist;Y];
        Y = hist(Pow(X>0.7),[0:0.5:8]);Y = Y/sum(Y);
        SafeHist = [SafeHist;Y];
    end
    f = [0:0.5:8];
    %       plot(f,ShockHist','color',[1 0.4 0.4])
    hold on
    %     plot(f,SafeHist','color',[0.4 0.4 1])
    plot(f,nanmean(ShockHist)/nanmean(ShockHist(:)),'r','linewidth',3)
    plot(f,nanmean(SafeHist)/nanmean(SafeHist(:)),'b','linewidth',3)
    ylabel(DrugTypes{dtype})
    set(gca,'XTick',1:10,'XScale','linear'), grid on
    title('Both')
end

