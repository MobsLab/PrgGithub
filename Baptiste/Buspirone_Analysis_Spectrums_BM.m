
cd('/media/nas6/ProjetEmbReact/transfer/')
load('Sess.mat','Sess')
Cols = {[1 0 0],[0 0 1]};
X = [1,2];
Legends = {'Saline','Chronic Flx'};
Session_type={'Hab','TestPre','Cond','TestPost'};

%% Mean OB Spectrum
GetEmbReactMiceFolderList_BM

%[69 65 72 75]
for mouse=[70 67 73 74]
    for sess=1:2
        
        cd(SleepSess.(Mouse_names{mouse}){sess})
        
        load('H_Low_Spectrum.mat')
        load('StateEpochSB.mat')
        
        HPC_Sp = tsd(Spectro{2}*1e4 , Spectro{1});
        HPC_Sp_Wake = Restrict(HPC_Sp , Wake);
        HPC_Sp_NREM = Restrict(HPC_Sp , SWSEpoch);
        HPC_Sp_REM = Restrict(HPC_Sp , REMEpoch);
        
        
        subplot(2,3,1+(sess-1)*3)
        plot(Spectro{3} , nanmean(Data(HPC_Sp_Wake)))
        hold on
        if and(mouse==69 , sess==1); ylabel('Sleep Pre'); end
        if and(mouse==69 , sess==2); ylabel('Sleep Post'); end
        if sess==1; legend('Saline','DZP','Acute BUS','Chronic BUS'); end
        if sess==2; xlabel('Frequency (Hz)'); end
        set(gca, 'YScale', 'log'); xlim([0 15])
        if sess==1; title('Wake'); end
        makepretty
        
        subplot(2,3,2+(sess-1)*3)
        plot(Spectro{3} , nanmean(Data(HPC_Sp_NREM)))
        hold on
        if sess==2; xlabel('Frequency (Hz)'); end
        if sess==1; title('NREM'); end
        makepretty;  xlim([0 15])
        
        subplot(2,3,3+(sess-1)*3)
        plot(Spectro{3} , nanmean(Data(HPC_Sp_REM)))
        hold on
        if sess==2; xlabel('Frequency (Hz)'); end
        if sess==1; title('REM'); end
        makepretty;  xlim([0 15])
        
    end
end


for mouse=[70 67 73 74] 
    for sess=1:3
        
    if sess==1
        FolderList=TestPreSess;
    elseif sess==2
        FolderList=CondSess;
    elseif sess==3
        FolderList=TestPostSess;
    end
    
    HPC_Sp.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'spectrum','prefix','H_Low');
    Speed.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'speed');
    
    NewSpeed_tsd=tsd(Range(Speed.(Mouse_names{mouse})) , runmean(Data(Speed.(Mouse_names{mouse})) , 7));
    
    MovingEpoch=thresholdIntervals(NewSpeed_tsd,3,'Direction','Above');
    MovingEpoch=mergeCloseIntervals(MovingEpoch,0.3*1e4);
    MovingEpoch=dropShortIntervals(MovingEpoch,1e4);
        
    ImmobileEpoch=thresholdIntervals(NewSpeed_tsd,3,'Direction','Below');
    ImmobileEpoch=mergeCloseIntervals(ImmobileEpoch,0.3*1e4);
    ImmobileEpoch=dropShortIntervals(ImmobileEpoch,1e4);

    HPC_Sp.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'spectrum','prefix','H_Low');
    HPC_Sp_Moving = Restrict(HPC_Sp.(Mouse_names{mouse}) , MovingEpoch);
    HPC_Sp_Immobile = Restrict(HPC_Sp.(Mouse_names{mouse}) , ImmobileEpoch);
    
    subplot(3,2,1+(sess-1)*2)
    plot(Spectro{3} , nanmean(Data(HPC_Sp_Moving)))
    hold on
    
    subplot(3,2,2+(sess-1)*2)
    plot(Spectro{3} , nanmean(Data(HPC_Sp_Immobile)))
    
    end
end




figure
plot(Spectro{3} , nanmean(Data(HPC_Sp_Moving)))
hold on
plot(Spectro{3} , nanmean(Data(HPC_Sp_Immobile)))








