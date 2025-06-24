function [OutPutData , Epoch , NameEpoch , OutPutTsd] = MeanPhysioParameters(MazeType,Mouse_List,Session_Type,varargin)
%% stolen from MeanValuesPhysiologicalParameters_BM
Dir = PathForExperimentsERC(MazeType);
Dir = RestrictPathForExperiment(Dir , 'nMice' ,Mouse_List);

for mouse=1:length(Mouse_List)

    load(fullfile(Dir.path{mouse}{1},  'SleepScoring_OBGamma.mat'), 'TotalNoiseEpoch')
    load(fullfile(Dir.path{mouse}{1},  'behavResources.mat'), 'StimEpoch', 'SessionEpoch', 'FreezeAccEpoch', 'ZoneEpoch')
    load(fullfile(Dir.path{mouse}{1},  'LFPData/LFP0.mat'))

    NoisyEpoch = or(TotalNoiseEpoch , StimEpoch);
    Epoch{mouse,1} = intervalSet(0,max( Range(LFP)))-NoisyEpoch; % total
    St = Stop(StimEpoch);
    Epoch{mouse,2} = intervalSet(St,St+1e4); % after stim
    Epoch{mouse,3} = FreezeAccEpoch; % fz
    Epoch{mouse,4} = Epoch{mouse,1} - Epoch{mouse,3}; % active
    Epoch{mouse,5}=and(Epoch{mouse,3} , ZoneEpoch.Shock);
    Epoch{mouse,6}=and(Epoch{mouse,3} , or(or(ZoneEpoch.NoShock , ZoneEpoch.FarNoShock) , ZoneEpoch.CentreNoShock));
    Epoch{mouse,7}=and(Epoch{mouse,4} , ZoneEpoch.Shock);
    Epoch{mouse,8}=and(Epoch{mouse,4} , or(or(ZoneEpoch.NoShock , ZoneEpoch.FarNoShock) , ZoneEpoch.CentreNoShock));


    NameEpoch{1}='Total';
    NameEpoch{2}='After_stim';
    NameEpoch{3}='Freezing';
    NameEpoch{4}='Active';
    NameEpoch{5}='Freezing_shock';
    NameEpoch{6}='Freezing_safe';
    NameEpoch{7}='Active_shock';
    NameEpoch{8}='Active_safe';


    for i = 1:length(varargin)
        clear OutPutVar
        if ischar(varargin{i})
            switch(lower(varargin{i}))

                case 'heartrate'
                    try
                        OutPutVar = load([Dir.path{mouse}{1}  'HeartBeatInfo.mat']);
                        OutPutTsd = OutPutVar.EKG.HBRate;
                    catch
                        OutPutTsd = tsd([],[]);
                    end

                case 'speed'
                    OutPutVar = load([Dir.path{mouse}{1}  'behavResources.mat'],'Vtsd');
                    OutPutTsd = OutPutVar.Vtsd;

                case ''


            end
        end
        for states=1:8
            try
                OutPutData.(varargin{i}).mean(mouse,states,:) = nanmean(Data(Restrict(OutPutTsd , Epoch{mouse,states})));
                OutPutData.(varargin{i}).tsd{mouse,states} = Restrict(OutPutTsd , Epoch{mouse,states});
            end
        end
    end
    disp(Dir.name{mouse})
end

end





