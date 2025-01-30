clear all,
MiceNumber=[507,508,509,510,512,514];
SessionNames{1}={'EPM','Habituation', 'SleepPreUMaze', 'TestPre', 'UMazeCond', 'SleepPostUMaze', 'TestPost','Extinction','SoundHab',...
    'SleepPreSound','SoundCond','SleepPostSound','SoundTest'};
RestrictToEp{1} = [0,0]; % 1 if freezing then 1 if sleep states
SessionNames{2}={'EPM'};
RestrictToEp{2} = [0,0]; % 1 if freezing then 1 if sleep states
SessionNames{3}={'Habituation'};
RestrictToEp{3} = [0,0]; % 1 if freezing then 1 if sleep states
SessionNames{4}={'UMazeCond'};
RestrictToEp{4} = [1,0]; % 1 if freezing then 1 if sleep states
SessionNames{5}={'SoundCond'};
RestrictToEp{5} = [1,0]; % 1 if freezing then 1 if sleep states
SessionNames{6}={'SoundTest'};
RestrictToEp{6} = [1,0]; % 1 if freezing then 1 if sleep states
SessionNames{7}={'SleepPreUMaze','SleepPostUMaze','SleepPreSound','SleepPostSound'};
RestrictToEp{7} = [0,1]; % 1 if freezing then 1 if sleep states

num_bootstraps = 100;
SaveFolder='/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFC_Neurons_TwoTypesOfFreezing/';
FreqLims=[0:0.25:12];

global strsz se; strsz=3; se= strel('disk',strsz);

%% Structure folders
for sess=1:length(SessionNames)
    Dir= PathForExperimentsEmbReact(SessionNames{sess}{1});
    if length(SessionNames{sess})>1
        for sess_subsess = 2:length(SessionNames{sess})
            Dirtemp= PathForExperimentsEmbReact(SessionNames{sess}{sess_subsess});
            Dir = MergePathForExperiment_SB(Dir,Dirtemp);
            
        end
    end
    
    for mm = 1:length(MiceNumber)
        AllDirPerMouse{sess}{mm} = [];
        for d = 1 : length(Dir.path)
            if Dir.ExpeInfo{d}{1}.nmouse==MiceNumber(mm)
                AllDirPerMouse{sess}{mm} = [AllDirPerMouse{sess}{mm},Dir.path{d}];
            end
        end
    end
end

%% Make plot mouse by mouse
for mm = 1:length(MiceNumber)
    for sess=1:length(SessionNames)
        clear S_concat instfreq_concat_PT_B instfreq_concat_PT_B  instfreq_concat_Both_B instfreq_concat_WV_H instfreq_concat_PT_H instfreq_concat_Both_H
        clear Ts_For_Interpol
        FolderList =  AllDirPerMouse{sess}{mm};
        %% Get concatenated variables
        
        % Spikes
        S_concat=ConcatenateDataFromFolders_SB(FolderList,'spikes');
        
        % InstFreq - OB
        instfreq_concat_PT_B=ConcatenateDataFromFolders_SB(FolderList,'instfreq','suffix_instfreq','B','method','PT');
        Ts_For_Interpol = ts([0:0.1:max(Range(instfreq_concat_PT_B,'s'))]*1e4);
        y=interp1(Range(instfreq_concat_PT_B),Data(instfreq_concat_PT_B),Range(Ts_For_Interpol));
        instfreq_concat_PT_B = tsd(Range(Ts_For_Interpol),y);
        
        instfreq_concat_WV_B=ConcatenateDataFromFolders_SB(FolderList,'instfreq','suffix_instfreq','B','method','WV');
        instfreq_concat_WV_B=Restrict(instfreq_concat_WV_B,Ts_For_Interpol);
        y=interp1(Range(instfreq_concat_WV_B),Data(instfreq_concat_WV_B),Range(Ts_For_Interpol));
        y(y>15)=NaN;
        y=naninterp(y);
        instfreq_concat_WV_B = tsd(Range(Ts_For_Interpol),y);
        instfreq_concat_Both_B = tsd(Range(Ts_For_Interpol),movmedian(nanmean([Data(instfreq_concat_WV_B),Data(instfreq_concat_PT_B)]'),10)');
        
        % InstFreq - HPC
        instfreq_concat_PT_H=ConcatenateDataFromFolders_SB(FolderList,'instfreq','suffix_instfreq','H_Loc','method','PT');
        y=interp1(Range(instfreq_concat_PT_H),Data(instfreq_concat_PT_H),Range(Ts_For_Interpol));
        instfreq_concat_PT_H = tsd(Range(Ts_For_Interpol),y);
        
        instfreq_concat_WV_H=ConcatenateDataFromFolders_SB(FolderList,'instfreq','suffix_instfreq','H_Loc','method','WV');
        instfreq_concat_WV_H=Restrict(instfreq_concat_WV_H,ts(Range(Ts_For_Interpol)));
        y=interp1(Range(instfreq_concat_WV_H),Data(instfreq_concat_WV_H),Range(Ts_For_Interpol));
        y(y>15)=NaN;
        y=naninterp(y);
        instfreq_concat_WV_H = tsd(Range(Ts_For_Interpol),y);
        instfreq_concat_Both_H = tsd(Range(Ts_For_Interpol),movmedian(nanmean([Data(instfreq_concat_WV_H),Data(instfreq_concat_PT_H)]'),10)');
        
        % NoiseEpoch
        EpochsToUse.Noise=ConcatenateDataFromFolders_SB(FolderList,'epoch','epochname','noiseepoch');
        
        %% All data
        TotalEpoch = intervalSet(0,max(Range(instfreq_concat_Both_B)))-EpochsToUse.Noise;
        Freq_B = Data(Restrict(instfreq_concat_Both_B,TotalEpoch));
        Freq_H = Data(Restrict(instfreq_concat_Both_H,TotalEpoch));
        
        % get rid of ends
        Freq_B = (Freq_B(3:end-3));
        Freq_H = (Freq_H(3:end-3));
        
        dt = median(diff(Range(instfreq_concat_Both_H,'s')));
        % HPC and OB link spikes
        Occup_HB{mm}{sess}{1}=[];
        for k=1:length(FreqLims)-1
            for l = 1:length(FreqLims)-1
                Bins{k,l}=find(Freq_H>FreqLims(k) & Freq_H<FreqLims(k+1) & Freq_B>FreqLims(l) & Freq_B<FreqLims(l+1));
                Occup_HB{mm}{sess}{1}(k,l)=length(Bins{k,l});
            end
        end
        
        MeanSpk_HB{mm}{sess}{1}=[];
        for sp=1:length(S_concat)
            [Y,X]=hist(Range(S_concat{sp}),Range(instfreq_concat_Both_H));
            if sum(Y)>0
                spike_count=tsd(X,Y');
                dat=Data((Restrict(spike_count,TotalEpoch)));
                dat = dat(3:end-3);
                for k=1:length(FreqLims)-1
                    for l = 1:length(FreqLims)-1
                        MeanSpk_HB{mm}{sess}{1}(sp,k,l)=nansum(dat(Bins{k,l}))./(length(Bins{k,l})*dt);
                    end
                end
            end
        end
        
        
        %% FreezingOnly
        if RestrictToEp{sess}(1)
            % FreezingEpoch
            EpochsToUse.Fz=ConcatenateDataFromFolders_SB(FolderList,'epoch','epochname','freezeepoch');
            
            Freq_B=Data(Restrict(instfreq_concat_Both_B,EpochsToUse.Fz));
            Freq_H=Data(Restrict(instfreq_concat_Both_H,EpochsToUse.Fz));
            
            % get rid of ends
            Freq_B = (Freq_B(3:end-3));
            Freq_H = (Freq_H(3:end-3));
            
            dt = median(diff(Range(instfreq_concat_Both_H,'s')));
            % HPC and OB link spikes
            Occup_HB{mm}{sess}{2}=[];
            for k=1:length(FreqLims)-1
                for l = 1:length(FreqLims)-1
                    Bins{k,l}=find(Freq_H>FreqLims(k) & Freq_H<FreqLims(k+1) & Freq_B>FreqLims(l) & Freq_B<FreqLims(l+1));
                    Occup_HB{mm}{sess}{2}(k,l)=length(Bins{k,l});
                end
            end
            
            MeanSpk_HB{mm}{sess}{2}=[];
            for sp=1:length(S_concat)
                [Y,X]=hist(Range(S_concat{sp}),Range(instfreq_concat_Both_H));
                if sum(Y)>0
                    spike_count=tsd(X,Y');
                    dat=Data(Restrict(spike_count,EpochsToUse.Fz));
                    dat = dat(3:end-3);
                    for k=1:length(FreqLims)-1
                        for l = 1:length(FreqLims)-1
                            MeanSpk_HB{mm}{sess}{2}(sp,k,l)=nansum(dat(Bins{k,l}))./(length(Bins{k,l})*dt);
                        end
                    end
                end
            end
        end
        
        %% SleepStates
        if RestrictToEp{sess}(2)
            % Sleep States
            EpochsToUse.Sleep=ConcatenateDataFromFolders_SB(FolderList,'epoch','epochname','sleepstates');
            
            for slst = 1:3
                Freq_B=Data(Restrict(instfreq_concat_Both_B,EpochsToUse.Sleep{slst}));
                Freq_H=Data(Restrict(instfreq_concat_Both_H,EpochsToUse.Sleep{slst}));
                
                % get rid of ends
                Freq_B = (Freq_B(3:end-3));
                Freq_H = (Freq_H(3:end-3));
                
                dt = median(diff(Range(instfreq_concat_Both_H,'s')));
                % HPC and OB link spikes
                Occup_HB{mm}{sess}{2+slst}=[];
                for k=1:length(FreqLims)-1
                    for l = 1:length(FreqLims)-1
                        Bins{k,l}=find(Freq_H>FreqLims(k) & Freq_H<FreqLims(k+1) & Freq_B>FreqLims(l) & Freq_B<FreqLims(l+1));
                        Occup_HB{mm}{sess}{2+slst}(k,l)=length(Bins{k,l});
                    end
                end
                
                MeanSpk_HB{mm}{sess}{2+slst}=[];
                for sp=1:length(S_concat)
                    [Y,X]=hist(Range(S_concat{sp}),Range(instfreq_concat_Both_H));
                    if sum(Y)>0
                        spike_count=tsd(X,Y');
                        dat=Data(Restrict(spike_count,EpochsToUse.Sleep{slst}));
                        dat = dat(3:end-3);
                        for k=1:length(FreqLims)-1
                            for l = 1:length(FreqLims)-1
                                MeanSpk_HB{mm}{sess}{2+slst}(sp,k,l)=nansum(dat(Bins{k,l}))/(length(Bins{k,l})*dt);
                            end
                        end
                    end
                end
            end
        end
        
        
    end
end

cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/AllNeuronsTuning_HPCOB
save('SpikingONHPCLocandOB.mat','MeanSpk_HB','Occup_HB')

fig = figure;
for mm=1:6
    for sp=1:size(MeanSpk_HB{mm}{1}{1},1)
        clf
        subplot(2,5,1)
        A = medfilt2(squeeze(MeanSpk_HB{mm}{1}{1}(sp,:,:)),[2 2]);
        A = A(:);
        imagesc(FreqLims,FreqLims,medfilt2(squeeze(MeanSpk_HB{mm}{1}{1}(sp,:,:)),[2 2])),hold on, axis xy
        try,clim([0 prctile(A,95)]),end
        title('AllData')
        colorbar
        subplot(2,5,2)
        A = medfilt2(squeeze(MeanSpk_HB{mm}{2}{1}(sp,:,:)),[2 2]);
        A = A(:);
        imagesc(FreqLims,FreqLims,medfilt2(squeeze(MeanSpk_HB{mm}{2}{1}(sp,:,:)),[2 2])),hold on, axis xy
        try,clim([0 prctile(A,95)]),end
        title('EPM')
        colorbar
        
        subplot(2,5,3)
        A = medfilt2(squeeze(MeanSpk_HB{mm}{3}{1}(sp,:,:)),[2 2]);
        A = A(:);
        imagesc(FreqLims,FreqLims,medfilt2(squeeze(MeanSpk_HB{mm}{3}{1}(sp,:,:)),[2 2])),hold on, axis xy
        try,clim([0 prctile(A,95)]),end
        title('Explo')
        colorbar
        subplot(2,5,4)
        A = medfilt2(squeeze(MeanSpk_HB{mm}{4}{2}(sp,:,:)),[2 2]);
        A = A(:);
        imagesc(FreqLims,FreqLims,medfilt2(squeeze(MeanSpk_HB{mm}{4}{2}(sp,:,:)),[2 2])),hold on, axis xy
        try,clim([0 prctile(A,95)]),end
        title('UMazeFreeze')
        colorbar
        subplot(2,5,5)
        A = medfilt2(squeeze(MeanSpk_HB{mm}{5}{2}(sp,:,:)),[2 2]);
        A = A(:);
        imagesc(FreqLims,FreqLims,medfilt2(squeeze(MeanSpk_HB{mm}{5}{2}(sp,:,:)),[2 2])),hold on, axis xy
        try,clim([0 prctile(A,95)]),end
        title('SoundFreeze1')
        colorbar
        subplot(2,5,6)
        A = medfilt2(squeeze(MeanSpk_HB{mm}{6}{2}(sp,:,:)),[2 2]);
        A = A(:);
        imagesc(FreqLims,FreqLims,medfilt2(squeeze(MeanSpk_HB{mm}{6}{2}(sp,:,:)),[2 2])),hold on, axis xy
        try,clim([0 prctile(A,95)]),end
        title('SoundFreeze2')
        colorbar
        subplot(2,5,7)
        A = medfilt2(squeeze(MeanSpk_HB{mm}{7}{3}(sp,:,:)),[2 2]);
        A = A(:);
        imagesc(FreqLims,FreqLims,medfilt2(squeeze(MeanSpk_HB{mm}{7}{3}(sp,:,:)),[2 2])),hold on, axis xy
        try,clim([0 prctile(A,95)]),end
        title('Wake Home')
        colorbar
        subplot(2,5,8)
        A = medfilt2(squeeze(MeanSpk_HB{mm}{7}{4}(sp,:,:)),[2 2]);
        A = A(:);
        imagesc(FreqLims,FreqLims,medfilt2(squeeze(MeanSpk_HB{mm}{7}{4}(sp,:,:)),[2 2])),hold on, axis xy
        try,clim([0 prctile(A,95)]),end
        title('NREM')
        colorbar
        subplot(2,5,9)
        A = medfilt2(squeeze(MeanSpk_HB{mm}{7}{5}(sp,:,:)),[2 2]);
        A = A(:);
        imagesc(FreqLims,FreqLims,medfilt2(squeeze(MeanSpk_HB{mm}{7}{5}(sp,:,:)),[2 2])),hold on, axis xy
        try,clim([0 prctile(A,95)]),end
        title('REM')
       colorbar
       
        saveas(fig.Number,['/media/DataMOBsRAIDN/ProjectEmbReact/Figures/AllNeuronsTuning_HPCOB/MultipleBehavStatesLocalHPC_Mouse' num2str(MiceNumber(mm)), '_Unit',num2str(sp),'.png'])

    end
    
end


%%%%
fig = figure;
for mm=1:6
    clf
    subplot(2,5,1)
    imagesc(FreqLims,FreqLims,medfilt2(squeeze(Occup_HB{mm}{1}{1}(:,:)),[2 2])),hold on, axis xy
    title('AllData')
    colorbar
    
    subplot(2,5,2)
    imagesc(FreqLims,FreqLims,medfilt2(squeeze(Occup_HB{mm}{2}{1}(:,:)),[2 2])),hold on, axis xy
    title('EPM')
    colorbar
    
    subplot(2,5,3)
    imagesc(FreqLims,FreqLims,medfilt2(squeeze(Occup_HB{mm}{3}{1}(:,:)),[2 2])),hold on, axis xy
    title('Explo')
    colorbar
    
    subplot(2,5,4)
    imagesc(FreqLims,FreqLims,medfilt2(squeeze(Occup_HB{mm}{4}{2}(:,:)),[2 2])),hold on, axis xy
    title('UMazeFreeze')
    colorbar
    
    subplot(2,5,5)
    imagesc(FreqLims,FreqLims,medfilt2(squeeze(Occup_HB{mm}{5}{2}(:,:)),[2 2])),hold on, axis xy
    title('SoundFreeze1')
    colorbar
    
    subplot(2,5,6)
    imagesc(FreqLims,FreqLims,medfilt2(squeeze(Occup_HB{mm}{6}{2}(:,:)),[2 2])),hold on, axis xy
    title('SoundFreeze2')
    colorbar
    
    subplot(2,5,7)
    imagesc(FreqLims,FreqLims,medfilt2(squeeze(Occup_HB{mm}{7}{3}(:,:)),[2 2])),hold on, axis xy
    title('Wake Home')
    colorbar
    
    subplot(2,5,8)
    imagesc(FreqLims,FreqLims,medfilt2(squeeze(Occup_HB{mm}{7}{4}(:,:)),[2 2])),hold on, axis xy
    title('NREM')
    colorbar
    
    subplot(2,5,9)
    imagesc(FreqLims,FreqLims,medfilt2(squeeze(Occup_HB{mm}{7}{5}(:,:)),[2 2])),hold on, axis xy
    title('REM')
    colorbar
    
    saveas(fig.Number,['/media/DataMOBsRAIDN/ProjectEmbReact/Figures/AllNeuronsTuning_HPCOB/MultipleBehavStatesOccupationmapLocHPC_Mouse' num2str(MiceNumber(mm)),'.png'])
    
end


