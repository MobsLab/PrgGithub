clear all
SessionNames = {'SleepPreUMaze','UMazeCond'};
Binsize = 0.2*1e4;
MinPoints = 300;
MiceNumber=[490,508,509,510,512,514]; % 509 excluded, not enought low activity in homecage
for ss=1:length(SessionNames)
    Dir_Sep{ss} = PathForExperimentsEmbReact(SessionNames{ss});
end
for ii = 1 :length(Dir_Sep{ss}.ExpeInfo)
    MouseID(ii) = Dir_Sep{ss}.ExpeInfo{ii}{1}.nmouse;
end

SaveLoc = '/media/DataMOBsRAIDN/ProjectEmbReact/Figures/PFC_DecodeStates/';

for mm=1:length(MiceNumber)
    
    % Get the list of folders for this mouse
    FolderList = {};
    for ss=1:length(SessionNames)
        FolderList = [FolderList,Dir_Sep{ss}.path{find(MouseID==MiceNumber(mm))}];
    end
    
    % load the data
    SessionId =  ConcatenateDataFromFolders_SB(FolderList,'epoch','epochname','sessiontype');
    
    SessionId.Cond{1} = SessionId.UMazeCond{1};
    for ii = 2:3%length(SessionId.UMazeCond)
        SessionId.Cond{1} = or(SessionId.Cond{1},SessionId.UMazeCond{ii});
    end
    SessionId = rmfield(SessionId,'UMazeCond');
    SessionNames = fieldnames(SessionId);
    for ss=1:length(SessionNames)
        SessionId.(SessionNames{ss}) = SessionId.(SessionNames{ss}){1};
    end
    
    
    OBGammaPow = ConcatenateDataFromFolders_SB(FolderList,'ob_gamma_power');
    SleepEpochs = ConcatenateDataFromFolders_SB(FolderList,'epoch','epochname','sleepstates'); % wake - nrem -rem
    Linpos = ConcatenateDataFromFolders_SB(FolderList,'LinearPosition');
    SafeSide = thresholdIntervals(Linpos,0.6,'Direction','Above');
    ShockSide = thresholdIntervals(Linpos,0.4,'Direction','Below');
    
    FreezeEpoch = ConcatenateDataFromFolders_SB(FolderList,'epoch','epochname','fz_epoch_withsleep_withnoise');
    
    figure
    SleepData = Data(Restrict(OBGammaPow,and(SleepEpochs{2},SessionId.SleepPre)));
    WakeData = Data(Restrict(OBGammaPow,and(SleepEpochs{1},SessionId.SleepPre)));
    FzSfData = Data(Restrict(OBGammaPow,and(and(FreezeEpoch,SessionId.Cond),SafeSide)));
    FzSkData = Data(Restrict(OBGammaPow,and(and(FreezeEpoch,SessionId.Cond),ShockSide)));
    
    mycols = [[0.6,0.6,0.6];[0,0,0];[0.4,0.4,1];[1,0.4,0.4]];
    colormap(mycols)
    nhist({WakeData,SleepData,FzSfData,FzSkData},'color','colormap','smooth','binfactor',0.1)
    legend('Wake','Sleep','Sf','Sk')
    
    Lim = prctile(SleepData,95);
    PropBelowLim(1,mm) = nanmean(WakeData<Lim);
    PropBelowLim(2,mm) = nanmean(FzSfData<Lim);
    PropBelowLim(3,mm) = nanmean(FzSkData<Lim);

end

%   0.0006    0.1185    0.0594