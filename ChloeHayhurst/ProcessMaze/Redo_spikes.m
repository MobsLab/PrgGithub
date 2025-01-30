%% Careful, all the data has to be concatenated! (at least the .fil)

GUI_StepOne_ExperimentInfo
%%
load('ExpeInfo.mat')
WriteExpeInfoToXml(ExpeInfo)
BaseFileName = ['M' num2str(ExpeInfo.nmouse) '_' ExpeInfo.date '_' ExpeInfo.SessionType];

% Do subtraction if necessary
if sum(ExpeInfo.SpikeGroupInfo.UseForElecSub)>0
    
    % get the electrodes to make the subtraction on
    ElecPerformSub = [];
    for sp = 1:length(ExpeInfo.SpikeGroupInfo.UseForElecSub)
        if ExpeInfo.SpikeGroupInfo.UseForElecSub(sp) ==1
            ElecPerformSub = [ElecPerformSub,str2num(ExpeInfo.SpikeGroupInfo.ChanNames{sp})];
        end
    end
    
    
    % New version with different reference channels
    LeftOverChannels = 0:ExpeInfo.PreProcessingInfo.TotalChannels-1;
    ToDel = [];
    numtet = 1;
    for tet = 1:length(ExpeInfo.SpikeGroupInfo.ChanNames)
        if ~isempty(ExpeInfo.SpikeGroupInfo.ElecsToSub{tet})
            ChannelsToPerfSub{numtet} = str2num(ExpeInfo.SpikeGroupInfo.ChanNames{tet});
            ChannelsToAverageForSub{numtet} = str2num(ExpeInfo.SpikeGroupInfo.ElecsToSub{tet});
            ToDel = [ToDel, str2num(ExpeInfo.SpikeGroupInfo.ChanNames{tet})];
            
            numtet =  numtet +1;
        end
    end
    LeftOverChannels(ismember(LeftOverChannels,ToDel)) = [];
    
    RefSubtraction_GroupByGroup([BaseFileName '.dat'],ExpeInfo.PreProcessingInfo.TotalChannels,1,'SpikeRef', ...
        ChannelsToPerfSub, ChannelsToAverageForSub, LeftOverChannels);
    system(['mv ' BaseFileName '_original.dat ' BaseFileName '.dat'])
    copyfile([BaseFileName '.xml'], [BaseFileName '_SpikeRef.xml'])
    
    
    % Do the preprcessing steps
    system(['ndm_hipass ' BaseFileName '_SpikeRef'])
    system(['ndm_extractspikes ' BaseFileName '_SpikeRef'])
    
    if strcmp(ExpeInfo.PreProcessingInfo.CleanSpikes, 'Yes')
        disp('I will clean bad spikes...');
        
        if exist('UnfilteredChans', 'dir') ~= 7 || isempty(dir([FinalFolder filesep 'UnfilteredChans/*.mat']))
            MakeData_Detection(FinalFolder, ExpeInfo.ChannelToAnalyse.Ref);
        end
        
        % Get spikes without artefacts
        files = dir([FinalFolder filesep 'UnfilteredChans/*.mat']);
        CleanEpoch = DefineCleanSpikesEpochs([files(1).folder filesep files(1).name], FinalFolder,...
            ExpeInfo.PreProcessingInfo.StimDur);
        
        % Remove spikes
        RemoveArtefactualSpikes(FinalFolder, CleanEpoch, [BaseFileName '_SpikeRef']);
        
    end
    
    system(['ndm_pca ' BaseFileName '_SpikeRef'])
    
else
    
    system(['ndm_hipass ' BaseFileName])
    system(['ndm_extractspikes ' BaseFileName])
    
    if strcmp(ExpeInfo.PreProcessingInfo.CleanSpikes, 'Yes')
        disp('I will clean bad spikes...');
        
        if exist('UnfilteredChans', 'dir') ~= 7 || isempty(dir([FinalFolder filesep 'UnfilteredChans/*.mat']))
            MakeData_Detection(FinalFolder, ExpeInfo.ChannelToAnalyse.Ref);
        end
        
        % Get spikes without artefacts
        files = dir([FinalFolder filesep 'UnfilteredChans/*.mat']);
        CleanEpoch = DefineCleanSpikesEpochs([files(1).folder filesep files(1).name], FinalFolder,...
            ExpeInfo.PreProcessingInfo.StimDur);
        
        % Remove spikes
        RemoveArtefactualSpikes(FinalFolder, CleanEpoch, BaseFileName);
        
    end
    
    system(['ndm_pca ' BaseFileName])
end

    