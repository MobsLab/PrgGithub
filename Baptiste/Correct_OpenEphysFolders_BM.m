
%% Correction of non synchronisation of open ephys files


for sess=[27 28 30 31]
    
    cd(FolderName{sess})
    
    delete B_High_Spectrum.mat
    delete B_Low_Spectrum.mat
    delete H_Low_Spectrum.mat
    delete H_VHigh_Spectrum.mat
    delete EKGCheck.fig
    delete EKGCheck.png
    delete HeartBeatInfo.mat
    delete InstantaneousFrequencyEstimate_B.png
    delete InstFreqAndPhase_B.mat
    delete PFCx_Low_Spectrum.mat
    delete Rippleraw.png
    delete SWR.mat
    delete StateEpochSB.mat
    delete swr.evt.swr
    delete behavResources_SB.mat
    rmdir('Ripples','s')
    
    load('behavResources.mat', 'TTLInfo','MovAccstd')
    GoodEpoch = intervalSet(TTLInfo.StartSession,TTLInfo.StopSession+2e4);

    for lfp=0:34
        load(['LFPData/LFP' num2str(lfp)])
        old_LFP = LFP;
        R=Range(LFP);
        LFP_New = Restrict(LFP,GoodEpoch);
        R2=Range(LFP_New)-TTLInfo.StartSession;
        LFP = tsd(R2 , Data(LFP_New));
        save(['LFPData/LFP' num2str(lfp) '.mat'] , 'LFP')
    end
    
    % correct stims, behavResources
    TTLInfo.StimEpoch = intervalSet(Start(TTLInfo.StimEpoch)- TTLInfo.StartSession+1e4 , Stop(TTLInfo.StimEpoch)- TTLInfo.StartSession+1e4);
    
    FileName=FolderName{sess}(max(regexp(FolderName{sess},filesep))+1:end);
    if isempty(findstr(FileName,'ProjectEmbReact'))
        All=regexp(FolderName{sess},filesep);
        FileName=FolderName{sess}(All(end-1)+1:end);
        FileName=strrep(FileName,filesep,'_');
    end
    
    load('ExpeInfo.mat')
    SetCurrentSession(FileName)
    MakeData_Accelero(pwd,'recompute',1)
    StartFile = dir(['./OpenEphys/structure.oebin']);
    TTLInfo_sess{2} = MakeData_TTLInfo_OpenEphys([pwd '/OpenEphys/events/RippleDetector-107.0_TTL_2.mat'] , StartFile.folder , StartFile.folder , ExpeInfo);
    % correct TTL for stim to be synchronised and only during Matlab recording
    sta=Start(TTLInfo_sess{2});
    sta=sta-TTLInfo.StartSession;
    sta=sta(sta>0);
    sta=sta(sta<max(Range(MovAcctsd)));
    sto=Stop(TTLInfo_sess{2});
    sto=sto-TTLInfo.StartSession;
    sto=sto(sto>0);
    sto=sto(sto<max(Range(MovAcctsd)));

    TTLInfo.StimEpoch2 = intervalSet(sta , sto);
    save('behavResources.mat', 'TTLInfo','-append')
    
end



load('behavResources.mat', 'Xtsd')
load('behavResources.mat', 'Imdifftsd')
load('LFPData/LFP0.mat')

figure
plot(Range(LFP) , Data(LFP))
hold on
plot(Range(Xtsd) , Data(Xtsd)*5e3)
xlim([0 4e4])

figure
plot(Range(LFP) , Data(LFP))
hold on
plot(Range(Xtsd) , Data(Xtsd)*5e3)
xlim([478e4 483e4])


plot(Range(Imdifftsd) , Data(Imdifftsd)*1e2)




