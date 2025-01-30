


%% PFC, SB

clear all, close all
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/FiguresAllMice
MiceNumber=[490,507,508,509,514]; % 510,512 don't have tipples
GetUsefulDataRipplesReactivations_UMaze_SB


SpeedLim = 2;
Session_type={'Cond','Ext','Fear'};

for sess=1%:length(Session_type)
    for mm=1:length(MiceNumber)

        Spikes = ConcatenateDataFromFolders_SB(Dir{mm}.(Session_type{sess}),'spikes');
        cd(Dir{mm}.(Session_type{sess}){1})
        [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx');
        Spikes = Spikes(numNeurons);

        LinPos = ConcatenateDataFromFolders_SB(Dir{mm}.(Session_type{sess}),'linearposition');
        Vtsd = ConcatenateDataFromFolders_SB(Dir{mm}.(Session_type{sess}),'speed');
                Position = ConcatenateDataFromFolders_SB(Dir{mm}.(Session_type{sess}),'alignedposition');
        D = Data(Position);
        Xtsd = tsd(Range(Position) , D(:,1));
        Ytsd = tsd(Range(Position) , D(:,2));

        FreezeEpoch = ConcatenateDataFromFolders_SB(Dir{mm}.(Session_type{sess}),'epoch','epochname','freezeepoch');
        StimEpoch = ConcatenateDataFromFolders_SB(Dir{mm}.(Session_type{sess}),'epoch','epochname','stimepoch');
        MovEpoch = thresholdIntervals(Vtsd,SpeedLim,'Direction','Above');
        MovEpoch = mergeCloseIntervals(MovEpoch,2*1e4);

        NoiseEpoch = ConcatenateDataFromFolders_SB(Dir{mm}.(Session_type{sess}),'epoch','epochname','noiseepoch');

        Ripples =  ConcatenateDataFromFolders_SB(Dir{mm}.(Session_type{sess}),'ripples_thr');


        cd('~/Dropbox/Mobs_member/BaptisteMaheo/Data/Data_BM/Ripples_Reactivations')

        save(['RippleReactInfo_NewRipples_SWR_05042024_' Session_type{sess} '_M',num2str(MiceNumber(mm)),'.mat'],'Ripples','MovEpoch','StimEpoch',...
            'LinPos','Vtsd','Spikes','FreezeEpoch','NoiseEpoch','Xtsd','Ytsd')

    end
end





%% HPC, DB

% clear all, close all
% SpeedLim = 2;
% 
% Dir = PathForExperimentsERC('UMazePAG');
% mice_PAG_neurons = [905,906,911,994,1161,1162,1168,1182,1186,1230,1239];
% CondSessionsId = [7:10];
% 
% for ff = 1:length(Dir.name)
%     if ismember(eval(Dir.name{ff}(6:end)),mice_PAG_neurons)
%         cd(Dir.path{ff}{1})
%         disp(Dir.path{ff}{1})
%         
%         load('behavResources.mat')
%         % Get the right sessions - just cond
%         CondSess = SessionEpoch.Cond1;
%         for ss = 2:4
%             CondSess = or(CondSess,SessionEpoch.(['Cond' num2str(ss)]));
%         end
% 
%         load('SpikeData.mat')
%         [numNeurons, numtt, TT]=GetSpikesFromStructure('dHPC');
%         Spikes = S(numNeurons);
%         Spikes = Restrict(Spikes,CondSess);
%         
%         LinPos = Restrict(LinearDist,CondSess);
%         Xtsd = Restrict(AlignedXtsd,CondSess);
%         Ytsd = Restrict(AlignedYtsd,CondSess);
%         Vtsd = Restrict(Vtsd,CondSess);
%         FreezeEpoch = and(FreezeEpoch,CondSess);
%         StimEpoch=intervalSet(Start(TTLInfo.StimEpoch),Stop(TTLInfo.StimEpoch)+0.2*1e4);
%         length(Start(and(StimEpoch,CondSess)))
%         MovEpoch = thresholdIntervals(Vtsd,SpeedLim,'Direction','Above');
%         MovEpoch = mergeCloseIntervals(MovEpoch,2*1e4);
%         
%         load('SleepScoring_Accelero.mat', 'TotalNoiseEpoch')
%         NoiseEpoch = and(TotalNoiseEpoch,CondSess);
%         
%         
%         load('SWR.mat', 'tRipples')
%         Ripples =  Restrict(tRipples,CondSess);
%         
%         
%         cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/HPC_Reactivations/Data
%         
%         save(['RippleReactInfo_NewRipples_',Dir.name{ff},'.mat'],'Ripples','MovEpoch','StimEpoch',...
%             'LinPos','Vtsd','Spikes','FreezeEpoch','NoiseEpoch','Xtsd','Ytsd')
%         
%     end
% end





%%











