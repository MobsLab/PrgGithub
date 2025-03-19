%% input dir


DirSleepInhibPFC=PathForExperiments_DREADD_MC('retroCre_PFC_VLPO_CNO');
% DirSleepInhibPFC=PathForExperiments_DREADD_MC('dreadd_PFC_CNO');



%%dir baseline sleep


% %%saline
% DirSaline_dreadd_PFC = PathForExperiments_DREADD_MC('dreadd_PFC_Nacl');
% DirSaline_dreadd_VLPO = PathForExperiments_DREADD_MC('OneInject_Nacl');
% Dir_sal = MergePathForExperiment(DirSaline_dreadd_PFC,DirSaline_dreadd_VLPO);
% DirSaline_retoCre = PathForExperiments_DREADD_MC('retroCre_PFC_VLPO_Nacl');
% DirSaline = MergePathForExperiment(Dir_sal,DirSaline_retoCre);
% DirSaline=RestrictPathForExperiment(DirSaline,'nMice',[1245 1247 1248 1300 1301 1302 1303]);% %1107

DirSaline = PathForExperiments_DREADD_MC('retroCre_PFC_VLPO_Nacl');

DirSocialDefeat = PathForExperimentsSD_MC('SleepPostSD');

DirBasal_opto = PathForExperiments_Opto_MC('PFC_Baseline');
DirBasal_opto=RestrictPathForExperiment(DirBasal_opto,'nMice',[1109]);
DirBasal_SD = PathForExperimentsSD_MC('BaselineSleep');
DirMyBasal = MergePathForExperiment(DirBasal_opto,DirBasal_SD);
Dir_dreadd = PathForExperiments_DREADD_MC('BaselineSleep');
DirMyBasal = MergePathForExperiment(DirMyBasal,Dir_dreadd);
DirMyBasal=RestrictPathForExperiment(DirMyBasal,'nMice',[1075 1107 1112 1148 1149 1150 1217 1218 1219 1220]);

DirSocialDefeat_inhibPFC = PathForExperimentsSD_MC('SleepPostSD_retroCre');


%% parameters
en_epoch_preInj = 1.4*1E8;
st_epoch_postInj = 1.65*1E8;


%%
%%get data : saline
for o=1:length(DirSaline.path)
    cd(DirSaline.path{o}{1});
    f{o} = load( 'SleepScoring_Accelero.mat', 'Wake', 'REMEpoch', 'SWSEpoch');
          f{o} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
%         f{o}.SWSEpoch = mergeCloseIntervals(f{o}.SWSEpoch, 1e4);
%         f{o}.REMEpoch = mergeCloseIntervals(f{o}.REMEpoch, 1e4);
%         f{o}.Wake = mergeCloseIntervals(f{o}.Wake, 1e4);
        
        
    durtotal_sal{o} = max([max(End(f{o}.Wake)),max(End(f{o}.SWSEpoch))]);
    
    %all post
    epoch_allPost_sal{o}=intervalSet(st_epoch_postInj,durtotal_sal{o});%%
    
        
        
    %3h post
    epoch_3hPost_sal{o}=intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1E4);
    %3h post up to the end
%     epoch_3hPost_to_the_end_sal{o}=intervalSet(End(epoch_3hPost_sal{o}),durtotal_sal{o});
    
    %percentage all post (post injection)
    SleepStagePerc_sal{o} = ComputeSleepStagesPercentagesMC(f{o}.Wake,f{o}.SWSEpoch,f{o}.REMEpoch);
    percWAKE_allPost_sal(o) = SleepStagePerc_sal{o}(1,3);
    percSWS_allPost_sal(o) = SleepStagePerc_sal{o}(2,3);
    percREM_allPost_sal(o) = SleepStagePerc_sal{o}(3,3);
    %percentage 3h after injection
    SleepStagePerc_sal2{o} = ComputeSleepStagesPercentagesMC(f{o}.Wake,f{o}.SWSEpoch,f{o}.REMEpoch);
    percWAKE_3hPost_sal(o) = SleepStagePerc_sal2{o}(1,4);  percWAKE_3hPost_sal(percWAKE_3hPost_sal==0)=NaN;
    percSWS_3hPost_sal(o) = SleepStagePerc_sal2{o}(2,4); percSWS_3hPost_sal(percSWS_3hPost_sal==0)=NaN;
    percREM_3hPost_sal(o) = SleepStagePerc_sal2{o}(3,4); percREM_3hPost_sal(percREM_3hPost_sal==0)=NaN;
    
%     %percentage 3h after injection to the end
%     SleepStagePerc_sal3{o} = ComputeSleepStagesPercentagesMC(f{o}.Wake,f{o}.SWSEpoch,f{o}.REMEpoch);
%     percWAKE_3hPost_to_the_end_sal(o) = SleepStagePerc_sal3{o}(1,6);  percWAKE_3hPost_sal(percWAKE_3hPost_sal==0)=NaN;
%     percSWS_3hPost_to_the_end_sal(o) = SleepStagePerc_sal3{o}(2,6); percSWS_3hPost_sal(percSWS_3hPost_sal==0)=NaN;
%     percREM_3hPost_to_the_end_sal(o) = SleepStagePerc_sal3{o}(3,6); percREM_3hPost_sal(percREM_3hPost_sal==0)=NaN;
    
    %%percentage of REM out of total sleep
    Restemp_totSleep_sal{o}=ComputeSleepStagesPercentagesWithoutWakeMC(f{o}.Wake,f{o}.SWSEpoch,f{o}.REMEpoch);
    %percentage post injection
    percREM_totSleep_allPost_sal(o)=Restemp_totSleep_sal{o}(3,3);
    percREM_totSleep_allPost_sal(percREM_totSleep_allPost_sal==0)=NaN;
    %percentage 3h post injection
    percREM_totSleep_sal_3hPost(o)=Restemp_totSleep_sal{o}(3,4);
    percREM_totSleep_sal_3hPost(percREM_totSleep_sal_3hPost==0)=NaN;
%     %percentage 3h post injection up to the end
%     percREM_totSleep_sal_3hPost_to_the_end(o)=Restemp_totSleep_sal{o}(3,6);
%     percREM_totSleep_sal_3hPost_to_the_end(percREM_totSleep_sal_3hPost_to_the_end==0)=NaN;
    
    %number of bouts
    NumWAKE_allPost_sal(o) = length(length(and(f{o}.Wake,epoch_allPost_sal{o})));
    NumSWS_allPost_sal(o) = length(length(and(f{o}.SWSEpoch,epoch_allPost_sal{o})));
    NumREM_allPost_sal(o) = length(length(and(f{o}.REMEpoch,epoch_allPost_sal{o})));
    %number of  bouts 3h post SD
    NumWAKE_3hPost_sal(o) = length(length(and(f{o}.Wake,epoch_3hPost_sal{o}))); NumWAKE_3hPost_sal(NumWAKE_3hPost_sal==0)=NaN;
    NumSWS_3hPost_sal(o) = length(length(and(f{o}.SWSEpoch,epoch_3hPost_sal{o}))); NumSWS_3hPost_sal(NumSWS_3hPost_sal==0)=NaN;
    NumREM_3hPost_sal(o) = length(length(and(f{o}.REMEpoch,epoch_3hPost_sal{o}))); NumREM_3hPost_sal(NumREM_3hPost_sal==0)=NaN;
    
    %%duration all post
    %mean duration of bouts (all post session)
    durWAKE_allPost_sal(o) = mean(End(and(f{o}.Wake,epoch_allPost_sal{o}),'s')-Start(and(f{o}.Wake,epoch_allPost_sal{o}),'s'));
    durSWS_allPost_sal(o) = mean(End(and(f{o}.SWSEpoch,epoch_allPost_sal{o}),'s')-Start(and(f{o}.SWSEpoch,epoch_allPost_sal{o}),'s'));
    durREM_allPost_sal(o) = mean(End(and(f{o}.REMEpoch,epoch_allPost_sal{o}),'s')-Start(and(f{o}.REMEpoch,epoch_allPost_sal{o}),'s'));
    %total duration (all post session)
    durTREM_allPost_sal(o) = sum(End(and(f{o}.REMEpoch,epoch_allPost_sal{o}),'s')-Start(and(f{o}.REMEpoch,epoch_allPost_sal{o}),'s'));
    durTSWS_allPost_sal(o) = sum(End(and(f{o}.SWSEpoch,epoch_allPost_sal{o}),'s')-Start(and(f{o}.SWSEpoch,epoch_allPost_sal{o}),'s'));
    durTWAKE_allPost_sal(o) = sum(End(and(f{o}.Wake,epoch_allPost_sal{o}),'s')-Start(and(f{o}.Wake,epoch_allPost_sal{o}),'s'));
   
    %%duration 3h post
    %mean duration of bouts (3h post)
    durWAKE_3hPost_sal(o) = mean(End(and(f{o}.Wake,epoch_3hPost_sal{o}),'s')-Start(and(f{o}.Wake,epoch_3hPost_sal{o}),'s')); durWAKE_3hPost_sal(durWAKE_3hPost_sal==0)=NaN;
    durSWS_3hPost_sal(o) = mean(End(and(f{o}.SWSEpoch,epoch_3hPost_sal{o}),'s')-Start(and(f{o}.SWSEpoch,epoch_3hPost_sal{o}),'s')); durSWS_3hPost_sal(durSWS_3hPost_sal==0)=NaN;
    durREM_3hPost_sal(o) = mean(End(and(f{o}.REMEpoch,epoch_3hPost_sal{o}),'s')-Start(and(f{o}.REMEpoch,epoch_3hPost_sal{o}),'s')); durREM_3hPost_sal(durREM_3hPost_sal==0)=NaN;
    %total dration (3h post)
    durTREM_3hPost_sal(o) = sum(End(and(f{o}.REMEpoch,epoch_3hPost_sal{o}),'s')-Start(and(f{o}.REMEpoch,epoch_3hPost_sal{o}),'s')); durTREM_3hPost_sal(durTREM_3hPost_sal==0)=NaN;
    durTSWS_3hPost_sal(o) = sum(End(and(f{o}.SWSEpoch,epoch_3hPost_sal{o}),'s')-Start(and(f{o}.SWSEpoch,epoch_3hPost_sal{o}),'s')); durTSWS_3hPost_sal(durTSWS_3hPost_sal==0)=NaN;
    durTWAKE_3hPost_sal(o) = sum(End(and(f{o}.Wake,epoch_3hPost_sal{o}),'s')-Start(and(f{o}.Wake,epoch_3hPost_sal{o}),'s')); durTWAKE_3hPost_sal(durTWAKE_3hPost_sal==0)=NaN;
%     %total duration (3h post to the end)
%     durTREM_3hPost_to_the_end_sal(o) = sum(End(and(f{o}.REMEpoch,epoch_3hPost_to_the_end_sal{o}),'s')-Start(and(f{o}.REMEpoch,epoch_3hPost_to_the_end_sal{o}),'s')); durTREM_3hPost_to_the_end_sal(durTREM_3hPost_to_the_end_sal==0)=NaN;
%     durTSWS_3hPost_to_the_end_sal(o) = sum(End(and(f{o}.SWSEpoch,epoch_3hPost_to_the_end_sal{o}),'s')-Start(and(f{o}.SWSEpoch,epoch_3hPost_to_the_end_sal{o}),'s')); durTSWS_3hPost_to_the_end_sal(durTSWS_3hPost_to_the_end_sal==0)=NaN;
%     durTWAKE_3hPost_to_the_end_sal(o) = sum(End(and(f{o}.Wake,epoch_3hPost_to_the_end_sal{o}),'s')-Start(and(f{o}.Wake,epoch_3hPost_to_the_end_sal{o}),'s')); durTWAKE_3hPost_to_the_end_sal(durTWAKE_3hPost_to_the_end_sal==0)=NaN;
end

%%
%%get data : PFC inhibition
for n=1:length(DirSleepInhibPFC.path)
    cd(DirSleepInhibPFC.path{n}{1});
    if exist('SleepScoring_Accelero.mat')
        e{n} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
%                 e{n}.SWSEpoch = mergeCloseIntervals(e{n}.SWSEpoch, 1e4);
%         e{n}.REMEpoch = mergeCloseIntervals(e{n}.REMEpoch, 1e4);
%         e{n}.Wake = mergeCloseIntervals(e{n}.Wake, 1e4);
        
        durtotal_SleepInhibPFC{n} = max([max(End(e{n}.Wake)),max(End(e{n}.SWSEpoch))]);
        %all post
        epoch_allPostSD_SleepInhibPFC{n}=intervalSet(st_epoch_postInj,durtotal_SleepInhibPFC{n});
                %3h post injection
        epoch_3hPostSD_SleepInhibPFC{n}=intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1E4);
        %3h post up to the end
%         epoch_3hPost_to_the_end_SleepInhibPFC{n}=intervalSet(End(epoch_3hPostSD_SleepInhibPFC{n}),durtotal_SleepInhibPFC{n});
        
        if isempty(e{n})==0
            %percentage
            SleepStagePerc_SleepInhibPFC1{n} = ComputeSleepStagesPercentagesMC(e{n}.Wake,e{n}.SWSEpoch,e{n}.REMEpoch);
            percWAKE_allPost_SleepInhibPFC(n) = SleepStagePerc_SleepInhibPFC1{n}(1,3);
            percSWS_allPost_SleepInhibPFC(n) = SleepStagePerc_SleepInhibPFC1{n}(2,3);
            percREM_allPost_SleepInhibPFC(n) = SleepStagePerc_SleepInhibPFC1{n}(3,3);
            %percentage 3h after SD
            SleepStagePerc_SleepInhibPFC2{n} = ComputeSleepStagesPercentagesMC(e{n}.Wake,e{n}.SWSEpoch,e{n}.REMEpoch);
            percWAKE_3hPost_SleepInhibPFC(n) = SleepStagePerc_SleepInhibPFC2{n}(1,4);
            percSWS_3hPost_SleepInhibPFC(n) = SleepStagePerc_SleepInhibPFC2{n}(2,4);
            percREM_3hPost_SleepInhibPFC(n) = SleepStagePerc_SleepInhibPFC2{n}(3,4);
            %percentage 3h after injection to the end
%             SleepStagePerc_SleepInhibPFC3{n} = ComputeSleepStagesPercentagesMC(e{n}.Wake,e{n}.SWSEpoch,e{n}.REMEpoch);
%             percWAKE_3hPost_to_the_end_SleepInhibPFC(n) = SleepStagePerc_SleepInhibPFC3{n}(1,6);  percWAKE_3hPost_SleepInhibPFC(percWAKE_3hPost_SleepInhibPFC==0)=NaN;
%             percSWS_3hPost_to_the_end_SleepInhibPFC(n) = SleepStagePerc_SleepInhibPFC3{n}(2,6); percSWS_3hPost_SleepInhibPFC(percSWS_3hPost_SleepInhibPFC==0)=NaN;
%             percREM_3hPost_to_the_end_SleepInhibPFC(n) = SleepStagePerc_SleepInhibPFC3{n}(3,6); percREM_3hPost_SleepInhibPFC(percREM_3hPost_SleepInhibPFC==0)=NaN;
            
            %%percentage of REM out of total sleep
            Restemp_totSleep_SleepInhibPFC{n}=ComputeSleepStagesPercentagesWithoutWakeMC(e{n}.Wake,e{n}.SWSEpoch,e{n}.REMEpoch);
            %percentage post injection
            percREM_totSleep_allPost_SleepInhibPFC(n)=Restemp_totSleep_SleepInhibPFC{n}(3,3);
            percREM_totSleep_allPost_SleepInhibPFC(percREM_totSleep_allPost_SleepInhibPFC==0)=NaN;
            %percentage 3h post injection
            percREM_totSleep_SleepInhibPFC_3hPost(n)=Restemp_totSleep_SleepInhibPFC{n}(3,4);
            percREM_totSleep_SleepInhibPFC_3hPost(percREM_totSleep_SleepInhibPFC_3hPost==0)=NaN;
            %percentage 3h post injection up to the end
%             percREM_totSleep_SleepInhibPFC_3hPost_to_the_end(o)=Restemp_totSleep_SleepInhibPFC{o}(3,6);
%             percREM_totSleep_SleepInhibPFC_3hPost_to_the_end(percREM_totSleep_SleepInhibPFC_3hPost_to_the_end==0)=NaN;
            
            %number of bouts
            NumWAKE_allPost_SleepInhibPFC(n) = length(length(and(e{n}.Wake,epoch_allPostSD_SleepInhibPFC{n})));
            NumSWS_allPost_SleepInhibPFC(n) = length(length(and(e{n}.SWSEpoch,epoch_allPostSD_SleepInhibPFC{n})));
            NumREM_allPost_SleepInhibPFC(n) = length(length(and(e{n}.REMEpoch,epoch_allPostSD_SleepInhibPFC{n})));
            %number of  bouts 3h post SD
            NumWAKE_3hPost_SleepInhibPFC(n) = length(length(and(e{n}.Wake,epoch_3hPostSD_SleepInhibPFC{n}))); NumWAKE_3hPost_SleepInhibPFC(NumWAKE_3hPost_SleepInhibPFC==0)=NaN;
            NumSWS_3hPost_SleepInhibPFC(n) = length(length(and(e{n}.SWSEpoch,epoch_3hPostSD_SleepInhibPFC{n}))); NumSWS_3hPost_SleepInhibPFC(NumSWS_3hPost_SleepInhibPFC==0)=NaN;
            NumREM_3hPost_SleepInhibPFC(n) = length(length(and(e{n}.REMEpoch,epoch_3hPostSD_SleepInhibPFC{n}))); NumREM_3hPost_SleepInhibPFC(NumREM_3hPost_SleepInhibPFC==0)=NaN;
            
            %mean duration of bouts (all post session)
            durWAKE_allPost_SleepInhibPFC(n) = mean(End(and(e{n}.Wake,epoch_allPostSD_SleepInhibPFC{n}),'s')-Start(and(e{n}.Wake,epoch_allPostSD_SleepInhibPFC{n}),'s'));
            durSWS_allPost_SleepInhibPFC(n) = mean(End(and(e{n}.SWSEpoch,epoch_allPostSD_SleepInhibPFC{n}),'s')-Start(and(e{n}.SWSEpoch,epoch_allPostSD_SleepInhibPFC{n}),'s'));
            durREM_allPost_SleepInhibPFC(n) = mean(End(and(e{n}.REMEpoch,epoch_allPostSD_SleepInhibPFC{n}),'s')-Start(and(e{n}.REMEpoch,epoch_allPostSD_SleepInhibPFC{n}),'s'));
            %total duration (all post session)
            durTREM_allPost_SleepInhibPFC(n) = sum(End(and(e{n}.REMEpoch,epoch_allPostSD_SleepInhibPFC{n}),'s')-Start(and(e{n}.REMEpoch,epoch_allPostSD_SleepInhibPFC{n}),'s'));
            durTSWS_allPost_SleepInhibPFC(n) = sum(End(and(e{n}.SWSEpoch,epoch_allPostSD_SleepInhibPFC{n}),'s')-Start(and(e{n}.SWSEpoch,epoch_allPostSD_SleepInhibPFC{n}),'s'));
            durTWAKE_allPost_SleepInhibPFC(n) = sum(End(and(e{n}.Wake,epoch_allPostSD_SleepInhibPFC{n}),'s')-Start(and(e{n}.Wake,epoch_allPostSD_SleepInhibPFC{n}),'s'));
            
            %mean duration of bouts 3h post
            durWAKE_3hPost_SleepInhibPFC(n) = mean(End(and(e{n}.Wake,epoch_3hPostSD_SleepInhibPFC{n}),'s')-Start(and(e{n}.Wake,epoch_3hPostSD_SleepInhibPFC{n}),'s'));
            durWAKE_3hPost_SleepInhibPFC(durWAKE_3hPost_SleepInhibPFC==0)=NaN;
            durSWS_3hPost_SleepInhibPFC(n) = mean(End(and(e{n}.SWSEpoch,epoch_3hPostSD_SleepInhibPFC{n}),'s')-Start(and(e{n}.SWSEpoch,epoch_3hPostSD_SleepInhibPFC{n}),'s'));
            durSWS_3hPost_SleepInhibPFC(durSWS_3hPost_SleepInhibPFC==0)=NaN;
            durREM_3hPost_SleepInhibPFC(n) = mean(End(and(e{n}.REMEpoch,epoch_3hPostSD_SleepInhibPFC{n}),'s')-Start(and(e{n}.REMEpoch,epoch_3hPostSD_SleepInhibPFC{n}),'s'));
            durREM_3hPost_SleepInhibPFC(durREM_3hPost_SleepInhibPFC==0)=NaN;
            %total duration 3h post
            durTREM_3hPost_SleepInhibPFC(n) = sum(End(and(e{n}.REMEpoch,epoch_3hPostSD_SleepInhibPFC{n}),'s')-Start(and(e{n}.REMEpoch,epoch_3hPostSD_SleepInhibPFC{n}),'s'));
            durTREM_3hPost_SleepInhibPFC(durTREM_3hPost_SleepInhibPFC==0)=NaN;
            durTSWS_3hPost_SleepInhibPFC(n) = sum(End(and(e{n}.SWSEpoch,epoch_3hPostSD_SleepInhibPFC{n}),'s')-Start(and(e{n}.SWSEpoch,epoch_3hPostSD_SleepInhibPFC{n}),'s'));
            durTSWS_3hPost_SleepInhibPFC(durTSWS_3hPost_SleepInhibPFC==0)=NaN;
            durTWAKE_3hPost_SleepInhibPFC(n) = sum(End(and(e{n}.Wake,epoch_3hPostSD_SleepInhibPFC{n}),'s')-Start(and(e{n}.Wake,epoch_3hPostSD_SleepInhibPFC{n}),'s'));
            durTWAKE_3hPost_SleepInhibPFC(durTWAKE_3hPost_SleepInhibPFC==0)=NaN;
            
            %total duration (3h post to the end)
%             durTREM_3hPost_to_the_end_SleepInhibPFC(n) = sum(End(and(e{n}.REMEpoch,epoch_3hPost_to_the_end_SleepInhibPFC{n}),'s')-Start(and(e{n}.REMEpoch,epoch_3hPost_to_the_end_SleepInhibPFC{n}),'s')); durTREM_3hPost_to_the_end_SleepInhibPFC(durTREM_3hPost_to_the_end_SleepInhibPFC==0)=NaN;
%             durTSWS_3hPost_to_the_end_SleepInhibPFC(n) = sum(End(and(e{n}.SWSEpoch,epoch_3hPost_to_the_end_SleepInhibPFC{n}),'s')-Start(and(e{n}.SWSEpoch,epoch_3hPost_to_the_end_SleepInhibPFC{n}),'s')); durTSWS_3hPost_to_the_end_SleepInhibPFC(durTSWS_3hPost_to_the_end_SleepInhibPFC==0)=NaN;
%             durTWAKE_3hPost_to_the_end_SleepInhibPFC(n) = sum(End(and(e{n}.Wake,epoch_3hPost_to_the_end_SleepInhibPFC{n}),'s')-Start(and(e{n}.Wake,epoch_3hPost_to_the_end_SleepInhibPFC{n}),'s')); durTWAKE_3hPost_to_the_end_SleepInhibPFC(durTWAKE_3hPost_to_the_end_SleepInhibPFC==0)=NaN;
        else
        end
    else
    end
end

%%
%%get data : social defeat
for k=1:length(DirSocialDefeat.path)
    cd(DirSocialDefeat.path{k}{1});
    c{k} = load( 'SleepScoring_Accelero.mat', 'Wake', 'REMEpoch', 'SWSEpoch');
%     c{k}.SWSEpoch = mergeCloseIntervals(c{k}.SWSEpoch, 1e4);
%     c{k}.REMEpoch = mergeCloseIntervals(c{k}.REMEpoch, 1e4);
%     c{k}.Wake = mergeCloseIntervals(c{k}.Wake, 1e4);
    
    
    durtotal_SD{k} = max([max(End(c{k}.Wake)),max(End(c{k}.SWSEpoch))]);
    %3h post SD (from beginning to 3h)
%     epoch_3hPost_SD{k}=intervalSet(0,3*3600*1E4);

    epoch_3hPost_SD{k}=intervalSet(0,3*3600*1E4);

    %3h post SD to the end
%     epoch_3hPost_to_the_end_SD{k}=intervalSet(End(epoch_3hPost_SD{k}),durtotal_SD{k});
%     epoch_3hPost_to_the_end_SD{k}=intervalSet(1.5*1E8,durtotal_SD{k});

    
    %percentage after SD (all sleep session)
    SleepStagePerc_SD{k} = ComputeSleepStagesPercentagesMC(c{k}.Wake,c{k}.SWSEpoch,c{k}.REMEpoch);
    percWAKE_allPost_SD(k) = SleepStagePerc_SD{k}(1,1);
    percSWS_allPost_SD(k) = SleepStagePerc_SD{k}(2,1);
    percREM_allPost_SD(k) = SleepStagePerc_SD{k}(3,1);
    %percentage 3h after SD
    SleepStagePerc_SD2{k} = ComputeSleepStagesPercentagesMC(c{k}.Wake,c{k}.SWSEpoch,c{k}.REMEpoch);
    percWAKE_3hPostSD_SD(k) = SleepStagePerc_SD2{k}(1,5);  %percWAKE_3hPostSD_SD(percWAKE_3hPostSD_SD==0)=NaN;
    percSWS_3hPostSD_SD(k) = SleepStagePerc_SD2{k}(2,5); %percSWS_3hPostSD_SD(percSWS_3hPostSD_SD==0)=NaN;
    percREM_3hPostSD_SD(k) = SleepStagePerc_SD2{k}(3,5); %percREM_3hPostSD_SD(percREM_3hPostSD_SD==0)=NaN;
    
    %%percentage of REM out of total sleep
    Restemp_totSleep_SD{k}=ComputeSleepStagesPercentagesWithoutWakeMC(c{k}.Wake,c{k}.SWSEpoch,c{k}.REMEpoch);
    %percentage post injection
    percREM_totSleep_SD(k)=Restemp_totSleep_SD{k}(3,1); %percREM_totSleep_SD(percREM_totSleep_SD==0)=NaN;
    %percentage 3h post injection
    percREM_totSleep_SD_3hPostSD(k)=Restemp_totSleep_SD{k}(3,5); %percREM_totSleep_SD_3hPostSD(percREM_totSleep_SD_3hPostSD==0)=NaN;
    
    %number of bouts
    NumWAKE_allPost_SD(k) = length(length(c{k}.Wake));
    NumSWS_allPost_SD(k) = length(length(c{k}.SWSEpoch));
    NumREM_allPost_SD(k) = length(length(c{k}.REMEpoch));
    %number of  bouts 3h post SD
    NumWAKE_3hPostSD_SD(k) = length(length(and(c{k}.Wake,epoch_3hPost_SD{k}))); NumWAKE_3hPostSD_SD(NumWAKE_3hPostSD_SD==0)=NaN;
    NumSWS_3hPostSD_SD(k) = length(length(and(c{k}.SWSEpoch,epoch_3hPost_SD{k}))); NumSWS_3hPostSD_SD(NumSWS_3hPostSD_SD==0)=NaN;
    NumREM_3hPostSD_SD(k) = length(length(and(c{k}.REMEpoch,epoch_3hPost_SD{k}))); NumREM_3hPostSD_SD(NumREM_3hPostSD_SD==0)=NaN;
    
    %mean duration of bouts (all post session)
    durWAKE_allPost_SD(k) = mean(End(c{k}.Wake,'s')-Start(c{k}.Wake,'s'));
    durSWS_allPost_SD(k) = mean(End(c{k}.SWSEpoch,'s')-Start(c{k}.SWSEpoch,'s'));
    durREM_allPost_SD(k) = mean(End(c{k}.REMEpoch,'s')-Start(c{k}.REMEpoch,'s'));
    %total duration (all post session)
    durTREM_allPost_SD(k) = sum(End(c{k}.REMEpoch,'s')-Start(c{k}.REMEpoch,'s'));
    durTSWS_allPost_SD(k) = sum(End(c{k}.SWSEpoch,'s')-Start(c{k}.SWSEpoch,'s'));
    durTWAKE_allPost_SD(k) = sum(End(c{k}.Wake,'s')-Start(c{k}.Wake,'s'));
    
    %mean duration of bouts 3h post SD
    durWAKE_3hPostSD_SD(k) = mean(End(and(c{k}.Wake,epoch_3hPost_SD{k}),'s')-Start(and(c{k}.Wake,epoch_3hPost_SD{k}),'s')); durWAKE_3hPostSD_SD(durWAKE_3hPostSD_SD==0)=NaN;
    durSWS_3hPostSD_SD(k) = mean(End(and(c{k}.SWSEpoch,epoch_3hPost_SD{k}),'s')-Start(and(c{k}.SWSEpoch,epoch_3hPost_SD{k}),'s')); durSWS_3hPostSD_SD(durSWS_3hPostSD_SD==0)=NaN;
    durREM_3hPostSD_SD(k) = mean(End(and(c{k}.REMEpoch,epoch_3hPost_SD{k}),'s')-Start(and(c{k}.REMEpoch,epoch_3hPost_SD{k}),'s')); durREM_3hPostSD_SD(durREM_3hPostSD_SD==0)=NaN;
    %total duration 3h post SD
    durTREM_3hPostSD_SD(k) = sum(End(and(c{k}.REMEpoch,epoch_3hPost_SD{k}),'s')-Start(and(c{k}.REMEpoch,epoch_3hPost_SD{k}),'s')); durTREM_3hPostSD_SD(durTREM_3hPostSD_SD==0)=NaN;
    durTSWS_3hPostSD_SD(k) = sum(End(and(c{k}.SWSEpoch,epoch_3hPost_SD{k}),'s')-Start(and(c{k}.SWSEpoch,epoch_3hPost_SD{k}),'s')); durTSWS_3hPostSD_SD(durTSWS_3hPostSD_SD==0)=NaN;
    durTWAKE_3hPostSD_SD(k) = sum(End(and(c{k}.Wake,epoch_3hPost_SD{k}),'s')-Start(and(c{k}.Wake,epoch_3hPost_SD{k}),'s')); durTWAKE_3hPostSD_SD(durTWAKE_3hPostSD_SD==0)=NaN;
    %total duration 3h post SD tot he end
%     durTREM_3hPost_to_the_end_SD(k) = sum(End(and(c{k}.REMEpoch,epoch_3hPost_to_the_end_SD{k}),'s')-Start(and(c{k}.REMEpoch,epoch_3hPost_to_the_end_SD{k}),'s')); durTREM_3hPost_to_the_end_SD(durTREM_3hPost_to_the_end_SD==0)=NaN;
%     durTSWS_3hPost_to_the_end_SD(k) = sum(End(and(c{k}.SWSEpoch,epoch_3hPost_to_the_end_SD{k}),'s')-Start(and(c{k}.SWSEpoch,epoch_3hPost_to_the_end_SD{k}),'s')); durTSWS_3hPost_to_the_end_SD(durTSWS_3hPost_to_the_end_SD==0)=NaN;
%     durTWAKE_3hPost_to_the_end_SD(k) = sum(End(and(c{k}.Wake,epoch_3hPost_to_the_end_SD{k}),'s')-Start(and(c{k}.Wake,epoch_3hPost_to_the_end_SD{k}),'s')); durTWAKE_3hPost_to_the_end_SD(durTWAKE_3hPost_to_the_end_SD==0)=NaN;
end

%%
%%get data : social defeat + inhibition PFC
for m=1:length(DirSocialDefeat_inhibPFC.path)
    cd(DirSocialDefeat_inhibPFC.path{m}{1});
    d{m} = load( 'SleepScoring_Accelero.mat', 'Wake', 'REMEpoch', 'SWSEpoch','WakeWiNoise');
%     d{m}.SWSEpoch = mergeCloseIntervals(d{m}.SWSEpoch, 1e4);
%     d{m}.REMEpoch = mergeCloseIntervals(d{m}.REMEpoch, 1e4);
%     d{m}.Wake = mergeCloseIntervals(d{m}.Wake, 1e4);
        
        
    d{m}.Wake = d{m}.WakeWiNoise;
    durtotal_SD_inhibPFC{m} = max([max(End(d{m}.Wake)),max(End(d{m}.SWSEpoch))]);
    %3h post SD (from beginning to 3h)
    epoch_3hPost_SD_inhibPFC{m}=intervalSet(0,3*3600*1E4);
    %3h post SD to the end
%     epoch_3hPost_to_the_end_SD_inhibPFC{m}=intervalSet(End(epoch_3hPost_SD_inhibPFC{m}),durtotal_SD_inhibPFC{m});
    
    %percentage aftet SD (all sleep session)
    SleepStagePerc_SD_inhibPFC{m} = ComputeSleepStagesPercentagesMC(d{m}.Wake,d{m}.SWSEpoch,d{m}.REMEpoch);
    percWAKE_SD_inhibPFC(m) = SleepStagePerc_SD_inhibPFC{m}(1,1);
    percSWS_SD_inhibPFC(m) = SleepStagePerc_SD_inhibPFC{m}(2,1);
    percREM_SD_inhibPFC(m) = SleepStagePerc_SD_inhibPFC{m}(3,1);
    %percentage 3h after SD
    SleepStagePerc_SD2_inhibPFC{m} = ComputeSleepStagesPercentagesMC(d{m}.Wake,d{m}.SWSEpoch,d{m}.REMEpoch);
    percWAKE_3hPostSD_SD_inhibPFC(m) = SleepStagePerc_SD2_inhibPFC{m}(1,5); percWAKE_3hPostSD_SD_inhibPFC(percWAKE_3hPostSD_SD_inhibPFC==0)=NaN;
    percSWS_3hPostSD_SD_inhibPFC(m) = SleepStagePerc_SD2_inhibPFC{m}(2,5); percSWS_3hPostSD_SD_inhibPFC(percSWS_3hPostSD_SD_inhibPFC==0)=NaN;
    percREM_3hPostSD_SD_inhibPFC(m) = SleepStagePerc_SD2_inhibPFC{m}(3,5); percREM_3hPostSD_SD_inhibPFC(percREM_3hPostSD_SD_inhibPFC==0)=NaN;
    
    %%percentage of REM out of total sleep
    Restemp_totSleep_inhibPFC{m}=ComputeSleepStagesPercentagesWithoutWakeMC(d{m}.Wake,d{m}.SWSEpoch,d{m}.REMEpoch);
    %percentage post injection
    percREM_totSleep_SD_inhibPFC(m)=Restemp_totSleep_inhibPFC{m}(3,1); percREM_totSleep_SD_inhibPFC(percREM_totSleep_SD_inhibPFC==0)=NaN;
    %percentage 3h post injection
    percREM_totSleep_SD_inhibPFC_3hPostSD(m)=Restemp_totSleep_inhibPFC{m}(3,5); percREM_totSleep_SD_inhibPFC_3hPostSD(percREM_totSleep_SD_inhibPFC_3hPostSD==0)=NaN;
    
    %number of bouts
    NumWAKE_SD_inhibPFC(m) = length(length(d{m}.Wake));
    NumSWS_SD_inhibPFC(m) = length(length(d{m}.SWSEpoch));
    NumREM_SD_inhibPFC(m) = length(length(d{m}.REMEpoch));
    %number of  bouts 3h post SD
    NumWAKE_3hPostSD_SD_inhibPFC(m) = length(length(and(d{m}.Wake,epoch_3hPost_SD_inhibPFC{m}))); NumWAKE_3hPostSD_SD_inhibPFC(NumWAKE_3hPostSD_SD_inhibPFC==0)=NaN;
    NumSWS_3hPostSD_SD_inhibPFC(m) = length(length(and(d{m}.SWSEpoch,epoch_3hPost_SD_inhibPFC{m}))); NumSWS_3hPostSD_SD_inhibPFC(NumSWS_3hPostSD_SD_inhibPFC==0)=NaN;
    NumREM_3hPostSD_SD_inhibPFC(m) = length(length(and(d{m}.REMEpoch,epoch_3hPost_SD_inhibPFC{m}))); NumREM_3hPostSD_SD_inhibPFC(NumREM_3hPostSD_SD_inhibPFC==0)=NaN;
    
    %mean duration of bouts (all post session)
    durWAKE_SD_inhibPFC(m) = mean(End(d{m}.Wake,'s')-Start(d{m}.Wake,'s'));
    durSWS_SD_inhibPFC(m) = mean(End(d{m}.SWSEpoch,'s')-Start(d{m}.SWSEpoch,'s'));
    durREM_SD_inhibPFC(m) = mean(End(d{m}.REMEpoch,'s')-Start(d{m}.REMEpoch,'s'));
    
    %total duration (all post session)
    durTREM_SD_inhibPFC(m) = sum(End(d{m}.REMEpoch,'s')-Start(d{m}.REMEpoch,'s'));
    durTSWS_SD_inhibPFC(m) = sum(End(d{m}.SWSEpoch,'s')-Start(d{m}.SWSEpoch,'s'));
    durTWAKE_SD_inhibPFC(m) = sum(End(d{m}.Wake,'s')-Start(d{m}.Wake,'s'));
    
    %mean duration of bouts (3h post SD)
    durWAKE_3hPostSD_SD_inhibPFC(m) = mean(End(and(d{m}.Wake,epoch_3hPost_SD_inhibPFC{m}),'s')-Start(and(d{m}.Wake,epoch_3hPost_SD_inhibPFC{m}),'s'));
    durSWS_3hPostSD_SD_inhibPFC(m) = mean(End(and(d{m}.SWSEpoch,epoch_3hPost_SD_inhibPFC{m}),'s')-Start(and(d{m}.SWSEpoch,epoch_3hPost_SD_inhibPFC{m}),'s'));
    durREM_3hPostSD_SD_inhibPFC(m) = mean(End(and(d{m}.REMEpoch,epoch_3hPost_SD_inhibPFC{m}),'s')-Start(and(d{m}.REMEpoch,epoch_3hPost_SD_inhibPFC{m}),'s'));
    %total duration (3h post)
    durTREM_3hPostSD_SD_inhibPFC(m) = sum(End(and(d{m}.REMEpoch,epoch_3hPost_SD_inhibPFC{m}),'s')-Start(and(d{m}.REMEpoch,epoch_3hPost_SD_inhibPFC{m}),'s'));
    durTSWS_3hPostSD_SD_inhibPFC(m) = sum(End(and(d{m}.SWSEpoch,epoch_3hPost_SD_inhibPFC{m}),'s')-Start(and(d{m}.SWSEpoch,epoch_3hPost_SD_inhibPFC{m}),'s'));
    durTWAKE_3hPostSD_SD_inhibPFC(m) = sum(End(and(d{m}.Wake,epoch_3hPost_SD_inhibPFC{m}),'s')-Start(and(d{m}.Wake,epoch_3hPost_SD_inhibPFC{m}),'s'));

    %total duration (3h post up to the end)
%     durTREM_3hPostSD_to_the_end_SD_inhibPFC(m) = sum(End(and(d{m}.REMEpoch,epoch_3hPost_to_the_end_SD_inhibPFC{m}),'s')-Start(and(d{m}.REMEpoch,epoch_3hPost_to_the_end_SD_inhibPFC{m}),'s'));
%     durTSWS_3hPostSD_to_the_end_SD_inhibPFC(m) = sum(End(and(d{m}.SWSEpoch,epoch_3hPost_to_the_end_SD_inhibPFC{m}),'s')-Start(and(d{m}.SWSEpoch,epoch_3hPost_to_the_end_SD_inhibPFC{m}),'s'));
%     durTWAKE_3hPostSD_to_the_end_SD_inhibPFC(m) = sum(End(and(d{m}.Wake,epoch_3hPost_to_the_end_SD_inhibPFC{m}),'s')-Start(and(d{m}.Wake,epoch_3hPost_to_the_end_SD_inhibPFC{m}),'s'));


end

%% figure (boxplot)
%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% run the 'load data' of CompareBasalSleepToTimePeriodsPostInjectionAndSD.m
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CompareBasalSleepToTimePeriodsPostInjectionAndSD
ComputeSleepStagesPercentagesBaselineMC

%% ALL POST
col_basal = [0.9 0.9 0.9];
col_sal = [0.5 0.5 0.5];
col_PFCinhib = [1 .4 .2];
col_SD = [1 0 0];
col_PFCinhib_SD = [.4 0 0];

figure
%%percentage
ax(1)=subplot(341),MakeSpreadAndBoxPlot2_SB({percWAKE_basal_13_end...
    percWAKE_allPost_sal percWAKE_allPost_SleepInhibPFC percWAKE_basal_10_end percWAKE_allPost_SD percWAKE_SD_inhibPFC},...
    {col_basal,col_sal,col_PFCinhib,col_basal, col_SD,col_PFCinhib_SD},[1:6],{},'ShowPoints',1,'paired',0,'optiontest','ranksum','showsigstar','none');
xticks([1:6]); xticklabels({'Baseline (13-end)','Saline','Inhibition_sleep','Baseline (10-end)','Social defeat','Inhibition-Social def'}); xtickangle(25);
makepretty
ylabel('WAKE percentage (%)')

ax(2)=subplot(342),MakeSpreadAndBoxPlot2_SB({percSWS_basal_13_end...
    percSWS_allPost_sal percSWS_allPost_SleepInhibPFC percSWS_basal_10_end percSWS_allPost_SD percSWS_SD_inhibPFC},...
    {col_basal,col_sal,col_PFCinhib,col_basal, col_SD,col_PFCinhib_SD},[1:6],{},'ShowPoints',1,'paired',0,'optiontest','ranksum','showsigstar','none');
xticks([1:6]); xticklabels({'Baseline (13-end)','Saline','Inhibition_sleep','Baseline (10-end)','Social defeat','Inhibition-Social def'}); xtickangle(25);
makepretty
makepretty
ylabel('NREM percentage (%)')

ax(3)=subplot(343),MakeSpreadAndBoxPlot2_SB({percREM_basal_13_end...
    percREM_allPost_sal percREM_allPost_SleepInhibPFC percREM_basal_10_end percREM_allPost_SD percREM_SD_inhibPFC},...
    {col_basal,col_sal,col_PFCinhib,col_basal, col_SD,col_PFCinhib_SD},[1:6],{},'ShowPoints',1,'paired',0,'optiontest','ranksum','showsigstar','none');
xticks([1:6]); xticklabels({'Baseline (13-end)','Saline','Inhibition_sleep','Baseline (10-end)','Social defeat','Inhibition-Social def'}); xtickangle(25);
makepretty
ylabel('REM percentage (%)')
title('/ total session')

ax(4)=subplot(344),MakeSpreadAndBoxPlot2_SB({percREM_totSleep_basal_13_end...
    percREM_totSleep_allPost_sal percREM_totSleep_allPost_SleepInhibPFC percREM_totSleep_basal_10_end percREM_totSleep_SD percREM_totSleep_SD_inhibPFC},...
    {col_basal,col_sal,col_PFCinhib,col_basal, col_SD,col_PFCinhib_SD},[1:6],{},'ShowPoints',1,'paired',0,'optiontest','ranksum','showsigstar','none');
xticks([1:6]); xticklabels({'Baseline (13-end)','Saline','Inhibition_sleep','Baseline (10-end)','Social defeat','Inhibition-Social def'}); xtickangle(25);
makepretty
ylabel('REM percentage (%)')
title('/total sleep')

%%Number
ax(5)=subplot(345),MakeSpreadAndBoxPlot2_SB({NumWAKE_basal_13_end...
    NumWAKE_allPost_sal NumWAKE_allPost_SleepInhibPFC NumWAKE_basal_10_end NumWAKE_allPost_SD NumWAKE_SD_inhibPFC},...
    {col_basal,col_sal,col_PFCinhib,col_basal, col_SD,col_PFCinhib_SD},[1:6],{},'ShowPoints',1,'paired',0,'optiontest','ranksum','showsigstar','none');
xticks([1:6]); xticklabels({'Baseline (13-end)','Saline','Inhibition_sleep','Baseline (10-end)','Social defeat','Inhibition-Social def'}); xtickangle(25);
makepretty
ylabel('# WAKE')

ax(6)=subplot(346),MakeSpreadAndBoxPlot2_SB({NumSWS_basal_13_end...
    NumSWS_allPost_sal NumSWS_allPost_SleepInhibPFC NumSWS_basal_10_end NumSWS_allPost_SD NumSWS_SD_inhibPFC},...
    {col_basal,col_sal,col_PFCinhib,col_basal, col_SD,col_PFCinhib_SD},[1:6],{},'ShowPoints',1,'paired',0,'optiontest','ranksum','showsigstar','none');
xticks([1:6]); xticklabels({'Baseline (13-end)','Saline','Inhibition_sleep','Baseline (10-end)','Social defeat','Inhibition-Social def'}); xtickangle(25);
makepretty
ylabel('# NREM')

ax(7)=subplot(347),MakeSpreadAndBoxPlot2_SB({NumREM_basal_13_end...
    NumREM_allPost_sal NumREM_allPost_SleepInhibPFC NumREM_basal_10_end NumREM_allPost_SD NumREM_SD_inhibPFC},...
    {col_basal,col_sal,col_PFCinhib,col_basal, col_SD,col_PFCinhib_SD},[1:6],{},'ShowPoints',1,'paired',0,'optiontest','ranksum','showsigstar','none');
xticks([1:6]); xticklabels({'Baseline (13-end)','Saline','Inhibition_sleep','Baseline (10-end)','Social defeat','Inhibition-Social def'}); xtickangle(25);
makepretty
ylabel('# REM')
set(ax,'Xticklabels',[])

%%duration
ax1(1)=subplot(349),MakeSpreadAndBoxPlot2_SB({durWAKE_basal_13_end...
    durWAKE_allPost_sal durWAKE_allPost_SleepInhibPFC durWAKE_basal_10_end durWAKE_allPost_SD durWAKE_SD_inhibPFC},...
    {col_basal,col_sal,col_PFCinhib,col_basal, col_SD,col_PFCinhib_SD},[1:6],{},'ShowPoints',1,'paired',0,'optiontest','ranksum','showsigstar','none');
xticks([1:6]); xticklabels({'Baseline (13-end)','Saline','Inhibition_sleep','Baseline (10-end)','Social defeat','Inhibition-Social def'}); xtickangle(25);
makepretty
ylabel('Mean duration WAKE (s)')

ax1(3)=subplot(3,4,10),MakeSpreadAndBoxPlot2_SB({durSWS_basal_13_end...
    durSWS_allPost_sal durSWS_allPost_SleepInhibPFC durSWS_basal_10_end durSWS_allPost_SD durSWS_SD_inhibPFC},...
    {col_basal,col_sal,col_PFCinhib,col_basal, col_SD,col_PFCinhib_SD},[1:6],{},'ShowPoints',1,'paired',0,'optiontest','ranksum','showsigstar','none');
xticks([1:6]); xticklabels({'Baseline (13-end)','Saline','Inhibition_sleep','Baseline (10-end)','Social defeat','Inhibition-Social def'}); xtickangle(25);
makepretty
ylabel('Mean duration NREM (s)')

ax1(3)=subplot(3,4,11),MakeSpreadAndBoxPlot2_SB({durREM_basal_13_end...
    durREM_allPost_sal durREM_allPost_SleepInhibPFC durREM_basal_10_end durREM_allPost_SD durREM_SD_inhibPFC},...
    {col_basal,col_sal,col_PFCinhib,col_basal, col_SD,col_PFCinhib_SD},[1:6],{},'ShowPoints',1,'paired',0,'optiontest','ranksum','showsigstar','none');
xticks([1:6]); xticklabels({'Baseline (13-end)','Saline','Inhibition_sleep','Baseline (10-end)','Social defeat','Inhibition-Social def'}); xtickangle(25);
makepretty
ylabel('Mean duration REM (s)')


%% ADD STATS



ax1(1)=subplot(341)
[h,p_basal_sal]=ttest2(percWAKE_basal_13_end, percWAKE_allPost_sal);
[h,p_sal_sleepInhib]=ttest(percWAKE_allPost_sal, percWAKE_allPost_SleepInhibPFC);
[h,p_basal_sleepInhib]=ttest2(percWAKE_basal_13_end, percWAKE_allPost_SleepInhibPFC);

[h,p_basal_SD]=ttest(percWAKE_basal_10_end, percWAKE_allPost_SD);
[h,p_SD_SDInhib]=ttest2(percWAKE_allPost_SD, percWAKE_SD_inhibPFC);
[h,p_basal_SDInhib]=ttest2(percWAKE_basal_10_end, percWAKE_SD_inhibPFC);

if p_basal_sal<0.05; sigstar_DB({[1 2]},p_basal_sal,0,'LineWigth',16,'StarSize',24);end
if p_sal_sleepInhib<0.05; sigstar_DB({[2 3]},p_sal_sleepInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_sleepInhib<0.05; sigstar_DB({[1 3]},p_basal_sleepInhib,0,'LineWigth',16,'StarSize',24);end

if p_basal_SD<0.05; sigstar_DB({[4 5]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDInhib<0.05; sigstar_DB({[5 6]},p_SD_SDInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDInhib<0.05; sigstar_DB({[4 6]},p_basal_SDInhib,0,'LineWigth',16,'StarSize',24);end

ax1(2)=subplot(3,4,2),
[h,p_basal_sal]=ttest2(percSWS_basal_13_end, percSWS_allPost_sal);
[h,p_sal_sleepInhib]=ttest(percSWS_allPost_sal, percSWS_allPost_SleepInhibPFC);
[h,p_basal_sleepInhib]=ttest2(percSWS_basal_13_end, percSWS_allPost_SleepInhibPFC);

[h,p_basal_SD]=ttest(percSWS_basal_10_end, percSWS_allPost_SD);
[h,p_SD_SDInhib]=ttest2(percSWS_allPost_SD, percSWS_SD_inhibPFC);
[h,p_basal_SDInhib]=ttest2(percSWS_basal_10_end, percSWS_SD_inhibPFC);

if p_basal_sal<0.05; sigstar_DB({[1 2]},p_basal_sal,0,'LineWigth',16,'StarSize',24);end
if p_sal_sleepInhib<0.05; sigstar_DB({[2 3]},p_sal_sleepInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_sleepInhib<0.05; sigstar_DB({[1 3]},p_basal_sleepInhib,0,'LineWigth',16,'StarSize',24);end

if p_basal_SD<0.05; sigstar_DB({[4 5]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDInhib<0.05; sigstar_DB({[5 6]},p_SD_SDInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDInhib<0.05; sigstar_DB({[4 6]},p_basal_SDInhib,0,'LineWigth',16,'StarSize',24);end


ax1(3)=subplot(3,4,3),
[h,p_basal_sal]=ttest2(percREM_basal_13_end, percREM_allPost_sal);
[h,p_sal_sleepInhib]=ttest(percREM_allPost_sal, percREM_allPost_SleepInhibPFC);
[h,p_basal_sleepInhib]=ttest2(percREM_basal_13_end, percREM_allPost_SleepInhibPFC);

[h,p_basal_SD]=ttest(percREM_basal_10_end, percREM_allPost_SD);
[h,p_SD_SDInhib]=ttest2(percREM_allPost_SD, percREM_SD_inhibPFC);
[h,p_basal_SDInhib]=ttest2(percREM_basal_10_end, percREM_SD_inhibPFC);

if p_basal_sal<0.05; sigstar_DB({[1 2]},p_basal_sal,0,'LineWigth',16,'StarSize',24);end
if p_sal_sleepInhib<0.05; sigstar_DB({[2 3]},p_sal_sleepInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_sleepInhib<0.05; sigstar_DB({[1 3]},p_basal_sleepInhib,0,'LineWigth',16,'StarSize',24);end

if p_basal_SD<0.05; sigstar_DB({[4 5]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDInhib<0.05; sigstar_DB({[5 6]},p_SD_SDInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDInhib<0.05; sigstar_DB({[4 6]},p_basal_SDInhib,0,'LineWigth',16,'StarSize',24);end




ax1(4)=subplot(3,4,4),
[h,p_basal_sal]=ttest2(percREM_totSleep_basal_13_end, percREM_totSleep_allPost_sal);
[h,p_sal_sleepInhib]=ttest(percREM_totSleep_allPost_sal, percREM_totSleep_allPost_SleepInhibPFC);
[h,p_basal_sleepInhib]=ttest2(percREM_totSleep_basal_13_end, percREM_totSleep_allPost_SleepInhibPFC);

[h,p_basal_SD]=ttest(percREM_totSleep_basal_10_end, percREM_totSleep_SD);
[h,p_SD_SDInhib]=ttest2(percREM_totSleep_SD, percREM_totSleep_SD_inhibPFC);
[h,p_basal_SDInhib]=ttest2(percREM_totSleep_basal_10_end, percREM_totSleep_SD_inhibPFC);

if p_basal_sal<0.05; sigstar_DB({[1 2]},p_basal_sal,0,'LineWigth',16,'StarSize',24);end
if p_sal_sleepInhib<0.05; sigstar_DB({[2 3]},p_sal_sleepInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_sleepInhib<0.05; sigstar_DB({[1 3]},p_basal_sleepInhib,0,'LineWigth',16,'StarSize',24);end

if p_basal_SD<0.05; sigstar_DB({[4 5]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDInhib<0.05; sigstar_DB({[5 6]},p_SD_SDInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDInhib<0.05; sigstar_DB({[4 6]},p_basal_SDInhib,0,'LineWigth',16,'StarSize',24);end

%%Number
ax1(5)=subplot(345)
[h,p_basal_sal]=ttest2(NumWAKE_basal_13_end, NumWAKE_allPost_sal);
[h,p_sal_sleepInhib]=ttest(NumWAKE_allPost_sal, NumWAKE_allPost_SleepInhibPFC);
[h,p_basal_sleepInhib]=ttest2(NumWAKE_basal_13_end, NumWAKE_allPost_SleepInhibPFC);

[h,p_basal_SD]=ttest(NumWAKE_basal_10_end, NumWAKE_allPost_SD);
[h,p_SD_SDInhib]=ttest2(NumWAKE_allPost_SD, NumWAKE_SD_inhibPFC);
[h,p_basal_SDInhib]=ttest2(NumWAKE_basal_10_end, NumWAKE_SD_inhibPFC);

if p_basal_sal<0.05; sigstar_DB({[1 2]},p_basal_sal,0,'LineWigth',16,'StarSize',24);end
if p_sal_sleepInhib<0.05; sigstar_DB({[2 3]},p_sal_sleepInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_sleepInhib<0.05; sigstar_DB({[1 3]},p_basal_sleepInhib,0,'LineWigth',16,'StarSize',24);end

if p_basal_SD<0.05; sigstar_DB({[4 5]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDInhib<0.05; sigstar_DB({[5 6]},p_SD_SDInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDInhib<0.05; sigstar_DB({[4 6]},p_basal_SDInhib,0,'LineWigth',16,'StarSize',24);end

ax1(6)=subplot(3,4,6),
[h,p_basal_sal]=ttest2(NumSWS_basal_13_end, NumSWS_allPost_sal);
[h,p_sal_sleepInhib]=ttest(NumSWS_allPost_sal, NumSWS_allPost_SleepInhibPFC);
[h,p_basal_sleepInhib]=ttest2(NumSWS_basal_13_end, NumSWS_allPost_SleepInhibPFC);

[h,p_basal_SD]=ttest(NumSWS_basal_10_end, NumSWS_allPost_SD);
[h,p_SD_SDInhib]=ttest2(NumSWS_allPost_SD, NumSWS_SD_inhibPFC);
[h,p_basal_SDInhib]=ttest2(NumSWS_basal_10_end, NumSWS_SD_inhibPFC);

if p_basal_sal<0.05; sigstar_DB({[1 2]},p_basal_sal,0,'LineWigth',16,'StarSize',24);end
if p_sal_sleepInhib<0.05; sigstar_DB({[2 3]},p_sal_sleepInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_sleepInhib<0.05; sigstar_DB({[1 3]},p_basal_sleepInhib,0,'LineWigth',16,'StarSize',24);end

if p_basal_SD<0.05; sigstar_DB({[4 5]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDInhib<0.05; sigstar_DB({[5 6]},p_SD_SDInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDInhib<0.05; sigstar_DB({[4 6]},p_basal_SDInhib,0,'LineWigth',16,'StarSize',24);end


ax1(7)=subplot(3,4,7),
[h,p_basal_sal]=ttest2(NumREM_basal_13_end, NumREM_allPost_sal);
[h,p_sal_sleepInhib]=ttest(NumREM_allPost_sal, NumREM_allPost_SleepInhibPFC);
[h,p_basal_sleepInhib]=ttest2(NumREM_basal_13_end, NumREM_allPost_SleepInhibPFC);

[h,p_basal_SD]=ttest(NumREM_basal_10_end, NumREM_allPost_SD);
[h,p_SD_SDInhib]=ttest2(NumREM_allPost_SD, NumREM_SD_inhibPFC);
[h,p_basal_SDInhib]=ttest2(NumREM_basal_10_end, NumREM_SD_inhibPFC);

if p_basal_sal<0.05; sigstar_DB({[1 2]},p_basal_sal,0,'LineWigth',16,'StarSize',24);end
if p_sal_sleepInhib<0.05; sigstar_DB({[2 3]},p_sal_sleepInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_sleepInhib<0.05; sigstar_DB({[1 3]},p_basal_sleepInhib,0,'LineWigth',16,'StarSize',24);end

if p_basal_SD<0.05; sigstar_DB({[4 5]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDInhib<0.05; sigstar_DB({[5 6]},p_SD_SDInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDInhib<0.05; sigstar_DB({[4 6]},p_basal_SDInhib,0,'LineWigth',16,'StarSize',24);end

%%duration
ax1(9)=subplot(349)
[h,p_basal_sal]=ttest2(durWAKE_basal_13_end, durWAKE_allPost_sal);
[h,p_sal_sleepInhib]=ttest(durWAKE_allPost_sal, durWAKE_allPost_SleepInhibPFC);
[h,p_basal_sleepInhib]=ttest2(durWAKE_basal_13_end, durWAKE_allPost_SleepInhibPFC);

[h,p_basal_SD]=ttest(durWAKE_basal_10_end, durWAKE_allPost_SD);
[h,p_SD_SDInhib]=ttest2(durWAKE_allPost_SD, durWAKE_SD_inhibPFC);
[h,p_basal_SDInhib]=ttest2(durWAKE_basal_10_end, durWAKE_SD_inhibPFC);

if p_basal_sal<0.05; sigstar_DB({[1 2]},p_basal_sal,0,'LineWigth',16,'StarSize',24);end
if p_sal_sleepInhib<0.05; sigstar_DB({[2 3]},p_sal_sleepInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_sleepInhib<0.05; sigstar_DB({[1 3]},p_basal_sleepInhib,0,'LineWigth',16,'StarSize',24);end

if p_basal_SD<0.05; sigstar_DB({[4 5]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDInhib<0.05; sigstar_DB({[5 6]},p_SD_SDInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDInhib<0.05; sigstar_DB({[4 6]},p_basal_SDInhib,0,'LineWigth',16,'StarSize',24);end

ax1(10)=subplot(3,4,10),
[h,p_basal_sal]=ttest2(durSWS_basal_13_end, durSWS_allPost_sal);
[h,p_sal_sleepInhib]=ttest(durSWS_allPost_sal, durSWS_allPost_SleepInhibPFC);
[h,p_basal_sleepInhib]=ttest2(durSWS_basal_13_end, durSWS_allPost_SleepInhibPFC);

[h,p_basal_SD]=ttest(durSWS_basal_10_end, durSWS_allPost_SD);
[h,p_SD_SDInhib]=ttest2(durSWS_allPost_SD, durSWS_SD_inhibPFC);
[h,p_basal_SDInhib]=ttest2(durSWS_basal_10_end, durSWS_SD_inhibPFC);

if p_basal_sal<0.05; sigstar_DB({[1 2]},p_basal_sal,0,'LineWigth',16,'StarSize',24);end
if p_sal_sleepInhib<0.05; sigstar_DB({[2 3]},p_sal_sleepInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_sleepInhib<0.05; sigstar_DB({[1 3]},p_basal_sleepInhib,0,'LineWigth',16,'StarSize',24);end

if p_basal_SD<0.05; sigstar_DB({[4 5]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDInhib<0.05; sigstar_DB({[5 6]},p_SD_SDInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDInhib<0.05; sigstar_DB({[4 6]},p_basal_SDInhib,0,'LineWigth',16,'StarSize',24);end


ax1(11)=subplot(3,4,11),
[h,p_basal_sal]=ttest2(durREM_basal_13_end, durREM_allPost_sal);
[h,p_sal_sleepInhib]=ttest(durREM_allPost_sal, durREM_allPost_SleepInhibPFC);
[h,p_basal_sleepInhib]=ttest2(durREM_basal_13_end, durREM_allPost_SleepInhibPFC);

[h,p_basal_SD]=ttest(durREM_basal_10_end, durREM_allPost_SD);
[h,p_SD_SDInhib]=ttest2(durREM_allPost_SD, durREM_SD_inhibPFC);
[h,p_basal_SDInhib]=ttest2(durREM_basal_10_end, durREM_SD_inhibPFC);

if p_basal_sal<0.05; sigstar_DB({[1 2]},p_basal_sal,0,'LineWigth',16,'StarSize',24);end
if p_sal_sleepInhib<0.05; sigstar_DB({[2 3]},p_sal_sleepInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_sleepInhib<0.05; sigstar_DB({[1 3]},p_basal_sleepInhib,0,'LineWigth',16,'StarSize',24);end

if p_basal_SD<0.05; sigstar_DB({[4 5]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDInhib<0.05; sigstar_DB({[5 6]},p_SD_SDInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDInhib<0.05; sigstar_DB({[4 6]},p_basal_SDInhib,0,'LineWigth',16,'StarSize',24);end






%% 3H POST SD
figure
%%percentage
ax(1)=subplot(341),MakeSpreadAndBoxPlot2_SB({percWAKE_basal_13_16...
    percWAKE_3hPost_sal percWAKE_3hPost_SleepInhibPFC percWAKE_basal_10_13 percWAKE_3hPostSD_SD percWAKE_3hPostSD_SD_inhibPFC},...
    {col_basal,col_sal,col_PFCinhib,col_basal, col_SD,col_PFCinhib_SD},[1:6],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
xticks([1:6]); xticklabels({'Baseline (13-16)','Saline','PFC inhib','Basaline (10-13)','SD','SD + PFC inhib'}); xtickangle(45);
ylabel('WAKE percentage (%)')

ax(2)=subplot(342),MakeSpreadAndBoxPlot2_SB({percSWS_basal_13_16...
    percSWS_3hPost_sal percSWS_3hPost_SleepInhibPFC percSWS_basal_10_13 percSWS_3hPostSD_SD percSWS_3hPostSD_SD_inhibPFC},...
    {col_basal,col_sal,col_PFCinhib,col_basal, col_SD,col_PFCinhib_SD},[1:6],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
xticks([1:6]); xticklabels({'Baseline (13-16)','Saline','PFC inhib','Basaline (10-13)','SD','SD + PFC inhib'}); xtickangle(45);
ylabel('NREM percentage (%)')

ax(3)=subplot(343),MakeSpreadAndBoxPlot2_SB({percREM_basal_13_16...
    percREM_3hPost_sal percREM_3hPost_SleepInhibPFC percREM_basal_10_13 percREM_3hPostSD_SD percREM_3hPostSD_SD_inhibPFC},...
    {col_basal,col_sal,col_PFCinhib,col_basal, col_SD,col_PFCinhib_SD},[1:6],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
xticks([1:6]); xticklabels({'Baseline (13-16)','Saline','PFC inhib','Baseline (10-13)','SD','SD + PFC inhib'}); xtickangle(45);
ylabel('REM percentage (%)')
title('/ total session')

ax(4)=subplot(344),MakeSpreadAndBoxPlot2_SB({percREM_totSleep_basal_13_16...
    percREM_totSleep_sal_3hPost percREM_totSleep_SleepInhibPFC_3hPost percREM_totSleep_basal_10_13 percREM_totSleep_SD_3hPostSD percREM_totSleep_SD_inhibPFC_3hPostSD},...
    {col_basal,col_sal,col_PFCinhib,col_basal, col_SD,col_PFCinhib_SD},[1:6],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
xticks([1:6]); xticklabels({'Baseline (13-16)','Saline','PFC inhib','Basaline (10-13)','SD','SD + PFC inhib'}); xtickangle(45);
ylabel('REM percentage (%)')
title('/total sleep')

%%Number
ax(5)=subplot(345),MakeSpreadAndBoxPlot2_SB({NumWAKE_basal_13_16...
    NumWAKE_3hPost_sal NumWAKE_3hPost_SleepInhibPFC NumWAKE_basal_10_13 NumWAKE_3hPostSD_SD NumWAKE_3hPostSD_SD_inhibPFC},...
    {col_basal,col_sal,col_PFCinhib,col_basal, col_SD,col_PFCinhib_SD},[1:6],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
xticks([1:6]); xticklabels({'Baseline (13-16)','Saline','PFC inhib','Basaline (10-13)','SD','SD + PFC inhib'}); xtickangle(45);
ylabel('# WAKE')

ax(6)=subplot(346),MakeSpreadAndBoxPlot2_SB({NumSWS_basal_13_16...
    NumSWS_3hPost_sal NumSWS_3hPost_SleepInhibPFC NumSWS_basal_10_13 NumSWS_3hPostSD_SD NumSWS_3hPostSD_SD_inhibPFC},...
    {col_basal,col_sal,col_PFCinhib,col_basal, col_SD,col_PFCinhib_SD},[1:6],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
xticks([1:6]); xticklabels({'Baseline (13-16)','Saline','PFC inhib','Basaline (10-13)','SD','SD + PFC inhib'}); xtickangle(45);
ylabel('# NREM')

ax(7)=subplot(347),MakeSpreadAndBoxPlot2_SB({NumREM_basal_13_16...
    NumREM_3hPost_sal NumREM_3hPost_SleepInhibPFC NumREM_basal_10_13 NumREM_3hPostSD_SD NumREM_3hPostSD_SD_inhibPFC},...
    {col_basal,col_sal,col_PFCinhib,col_basal, col_SD,col_PFCinhib_SD},[1:6],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
xticks([1:6]); xticklabels({'Baseline (13-16)','Saline','PFC inhib','Basaline (10-13)','SD','SD + PFC inhib'}); xtickangle(45);
ylabel('# REM')
set(ax,'Xticklabels',[])

%%duration
ax1(1)=subplot(349),MakeSpreadAndBoxPlot2_SB({durWAKE_basal_13_16...
    durWAKE_3hPost_sal durWAKE_3hPost_SleepInhibPFC durWAKE_basal_10_13 durWAKE_3hPostSD_SD durWAKE_3hPostSD_SD_inhibPFC},...
    {col_basal,col_sal,col_PFCinhib,col_basal, col_SD,col_PFCinhib_SD},[1:6],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
xticks([1:6]); xticklabels({'Baseline (13-16)','Saline','PFC inhib','Basaline (10-13)','SD','SD + PFC inhib'}); xtickangle(45);
ylabel('Mean duration WAKE (s)')

ax1(3)=subplot(3,4,10),MakeSpreadAndBoxPlot2_SB({durSWS_basal_13_16...
    durSWS_3hPost_sal durSWS_3hPost_SleepInhibPFC durSWS_basal_10_13 durSWS_3hPostSD_SD durSWS_3hPostSD_SD_inhibPFC},...
    {col_basal,col_sal,col_PFCinhib,col_basal, col_SD,col_PFCinhib_SD},[1:6],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
xticks([1:6]); xticklabels({'Baseline (13-16)','Saline','PFC inhib','Basaline (10-13)','SD','SD + PFC inhib'}); xtickangle(45);
ylabel('Mean duration NREM (s)')

ax1(3)=subplot(3,4,11),MakeSpreadAndBoxPlot2_SB({durREM_basal_13_16...
    durREM_3hPost_sal durREM_3hPost_SleepInhibPFC durREM_basal_10_13 durREM_3hPostSD_SD durREM_3hPostSD_SD_inhibPFC},...
    {col_basal,col_sal,col_PFCinhib,col_basal, col_SD,col_PFCinhib_SD},[1:6],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
xticks([1:6]); xticklabels({'Baseline (13-16)','Saline','PFC inhib','Basaline (10-13)','SD','SD + PFC inhib'}); xtickangle(45);
ylabel('Mean duration REM (s)')




%% total duration
figure
subplot(231)
MakeSpreadAndBoxPlot2_SB({durTWake_13_end_basal./60 durTWAKE_allPost_sal./60 durTWAKE_allPost_SleepInhibPFC./60 durTWake_10_end_basal./60 durTWAKE_allPost_SD./60 durTWAKE_SD_inhibPFC./60},...
    {col_basal,col_sal,col_PFCinhib,col_basal,col_SD,col_PFCinhib_SD},[1:6],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
xticks([1:6]); xticklabels({'Baseline (13-end)','Saline','PFC inhib','Baseline (10-end)','SD','SD + PFC inhib'}); %xtickangle(45);
ylabel('Total duration WAKE (min)')

subplot(232)
MakeSpreadAndBoxPlot2_SB({durTSWS_13_end_basal./60 durTSWS_allPost_sal./60 durTSWS_allPost_SleepInhibPFC./60 durTSWS_10_end_basal./60 durTSWS_allPost_SD./60 durTSWS_SD_inhibPFC./60},...
    {col_basal,col_sal,col_PFCinhib,col_basal,col_SD,col_PFCinhib_SD},[1:6],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
xticks([1:6]); xticklabels({'Baseline (13-end)','Saline','PFC inhib','Baseline (10-end)','SD','SD + PFC inhib'}); %xtickangle(45);
ylabel('Total duration NREM (min)')

subplot(233)
MakeSpreadAndBoxPlot2_SB({durTREM_13_end_basal./60 durTREM_allPost_sal./60 durTREM_allPost_SleepInhibPFC./60 durTREM_10_end_basal./60 durTREM_allPost_SD./60 durTREM_SD_inhibPFC./60},...
    {col_basal,col_sal,col_PFCinhib,col_basal,col_SD,col_PFCinhib_SD},[1:6],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
xticks([1:6]); xticklabels({'Baseline (13-end)','Saline','PFC inhib','Baseline (10-end)','SD','SD + PFC inhib'}); %xtickangle(45);
ylabel('Total duration REM (min)')

subplot(234)
MakeSpreadAndBoxPlot2_SB({durTWake_13_16_basal./60 durTWAKE_3hPost_sal./60 durTWAKE_3hPost_SleepInhibPFC./60 durTWake_10_13_basal./60 durTWAKE_3hPostSD_SD./60 durTWAKE_3hPostSD_SD_inhibPFC./60},...
    {col_basal,col_sal,col_PFCinhib,col_basal,col_SD,col_PFCinhib_SD},[1:6],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
xticks([1:6]); xticklabels({'Baseline (13-16)','Saline','PFC inhib','Baseline (10-13)','SD','SD + PFC inhib'}); %xtickangle(45);
ylabel('Total duration WAKE (min)')

subplot(235)
MakeSpreadAndBoxPlot2_SB({durTSWS_13_16_basal./60 durTSWS_3hPost_sal./60 durTSWS_3hPost_SleepInhibPFC./60 durTSWS_10_13_basal./60 durTSWS_3hPostSD_SD./60 durTSWS_3hPostSD_SD_inhibPFC./60},...
    {col_basal,col_sal,col_PFCinhib,col_basal,col_SD,col_PFCinhib_SD},[1:6],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
xticks([1:6]); xticklabels({'Baseline (13-16)','Saline','PFC inhib','Baseline (10-13)','SD','SD + PFC inhib'}); %xtickangle(45);
ylabel('Total duration NREM (min)')

subplot(236)
MakeSpreadAndBoxPlot2_SB({ durTREM_13_16_basal./60 durTREM_3hPost_sal./60 durTREM_3hPost_SleepInhibPFC./60 durTREM_10_13_basal./60 durTREM_3hPostSD_SD./60 durTREM_3hPostSD_SD_inhibPFC./60},...
    {col_basal,col_sal,col_PFCinhib,col_basal,col_SD,col_PFCinhib_SD},[1:6],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
xticks([1:6]); xticklabels({'Baseline (13-16)','Saline','PFC inhib','Baseline (10-13)','SD','SD + PFC inhib'}); %xtickangle(45);
ylabel('Total duration REM (min)')


%% to see if rebound ?
%% TOTAL DURATION (en ajoutant le slot fin des 3h jusqu'à la fin)
figure
subplot(321)
MakeSpreadAndBoxPlot2_SB({durTWake_13_16_basal./60 durTWAKE_3hPost_sal./60 durTWAKE_3hPost_SleepInhibPFC./60 durTWake_10_13_basal./60 durTWAKE_3hPostSD_SD./60 durTWAKE_3hPostSD_SD_inhibPFC./60},...
    {col_basal,col_sal,col_PFCinhib,col_basal,col_SD,col_PFCinhib_SD},[1:6],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
xticks([1:6]); xticklabels({'Baseline (13-16)','Saline','PFC inhib','Baseline (10-13)','SD','SD + PFC inhib'}); %xtickangle(45);
ylabel('Total duration WAKE (min)')
set(gca,'xticklabel',[])

subplot(323)
MakeSpreadAndBoxPlot2_SB({durTSWS_13_16_basal./60 durTSWS_3hPost_sal./60 durTSWS_3hPost_SleepInhibPFC./60 durTSWS_10_13_basal./60 durTSWS_3hPostSD_SD./60 durTSWS_3hPostSD_SD_inhibPFC./60},...
    {col_basal,col_sal,col_PFCinhib,col_basal,col_SD,col_PFCinhib_SD},[1:6],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
xticks([1:6]); xticklabels({'Baseline (13-16)','Saline','PFC inhib','Baseline (10-13)','SD','SD + PFC inhib'}); %xtickangle(45);
ylabel('Total duration NREM (min)')
set(gca,'xticklabel',[])

subplot(325)
MakeSpreadAndBoxPlot2_SB({ durTREM_13_16_basal./60 durTREM_3hPost_sal./60 durTREM_3hPost_SleepInhibPFC./60 durTREM_10_13_basal./60 durTREM_3hPostSD_SD./60 durTREM_3hPostSD_SD_inhibPFC./60},...
    {col_basal,col_sal,col_PFCinhib,col_basal,col_SD,col_PFCinhib_SD},[1:6],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
xticks([1:6]); xticklabels({'Baseline (13-16)','Saline','PFC inhib','Baseline (10-13)','SD','SD + PFC inhib'}); %xtickangle(45);
ylabel('Total duration REM (min)')

subplot(322)
MakeSpreadAndBoxPlot2_SB({durTWake_16_end_basal./60 durTWAKE_3hPost_to_the_end_sal./60 durTWAKE_3hPost_to_the_end_SleepInhibPFC./60 durTWake_13_end_basal./60 durTWAKE_3hPost_to_the_end_SD./60 durTWAKE_3hPostSD_to_the_end_SD_inhibPFC./60},...
    {col_basal,col_sal,col_PFCinhib,col_basal,col_SD,col_PFCinhib_SD},[1:6],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
xticks([1:6]); xticklabels({'Baseline (16-end)','Saline','PFC inhib','Baseline (13-end)','SD','SD + PFC inhib'}); %xtickangle(45);
ylabel('Total duration WAKE (min)')
set(gca,'xticklabel',[])
set(gca,'xticklabel',[])

subplot(324)
MakeSpreadAndBoxPlot2_SB({durTSWS_16_end_basal./60 durTSWS_3hPost_to_the_end_sal./60 durTSWS_3hPost_to_the_end_SleepInhibPFC./60 durTSWS_13_end_basal./60 durTSWS_3hPost_to_the_end_SD./60 durTSWS_3hPostSD_to_the_end_SD_inhibPFC./60},...
    {col_basal,col_sal,col_PFCinhib,col_basal,col_SD,col_PFCinhib_SD},[1:6],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
xticks([1:6]); xticklabels({'Baseline (16-end)','Saline','PFC inhib','Baseline (13-end)','SD','SD + PFC inhib'}); %xtickangle(45);
ylabel('Total duration NREM (min)')
set(gca,'xticklabel',[])

subplot(326)
MakeSpreadAndBoxPlot2_SB({ durTREM_16_end_basal./60 durTREM_3hPost_to_the_end_sal./60 durTREM_3hPost_to_the_end_SleepInhibPFC./60 durTREM_13_end_basal./60 durTREM_3hPost_to_the_end_SD./60 durTREM_3hPostSD_to_the_end_SD_inhibPFC./60},...
    {col_basal,col_sal,col_PFCinhib,col_basal,col_SD,col_PFCinhib_SD},[1:6],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
xticks([1:6]); xticklabels({'Baseline (16-end)','Saline','PFC inhib','Baseline (13-end)','SD','SD + PFC inhib'}); %xtickangle(45);
ylabel('Total duration REM (min)')



%%
% 
% figure
% MakeSpreadAndBoxPlot2_SB({(mean(durTREM_allPost_sal./60)-(durTREM_allPost_SleepInhibPFC./60)), (mean(durTREM_allPost_SD./60)-(durTREM_SD_inhibPFC./60))},...
%     {col_PFCinhib,col_PFCinhib_SD},[1:2],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
% xticks([1:2]); xticklabels({'basal sleep','SD'}); xtickangle(0);
% % ylabel('Total duration WAKE (min)')
% 
% % ylabel('difference of WAKE total duration (min)')
% 
% 
% % figure
% % MakeSpreadAndBoxPlot2_SB({(mean(percWAKE_allPost_sal./60)-(percWAKE_allPost_SleepInhibPFC./60)) (mean(percWAKE_allPost_SD./60)-(percWAKE_SD_inhibPFC./60))},...
% %     {col_PFCinhib,col_PFCinhib_SD},[1:2],{},'ShowPoints',1,'paired',1,'optiontest','ranksum');
% % xticks([1:2]); xticklabels({'basal sleep','SD'}); xtickangle(0);

%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %    run the 'load section' of CompareSleepDifferentTimePeriods_MC
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% col_basal = [0.9 0.9 0.9];
% col_sal = [0.5 0.5 0.5];
% col_PFCinhib = [1 .4 .2];
% col_SD = [1 0 0];
% col_PFCinhib_SD = [.4 0 0];
% 
% 
% figure
% %%percentage
% ax(1)=subplot(341),MakeSpreadAndBoxPlot2_SB({percWAKE_LabBasal percWAKE_basal_8_10 percWAKE_basal_10_13, percWAKE_basal_13_16 percWAKE_basal_16_end...
%     percWAKE_sal percWAKE_SleepInhibPFC percWAKE_SD percWAKE_SD_inhibPFC},...
%     {col_basal, col_basal,col_basal,col_basal,col_basal,col_sal,col_PFCinhib,col_SD,col_PFCinhib_SD},[1:9],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
% xticks([1:9]); xticklabels({'all','start-10','10-13','13-16','16-end','Saline','PFC inhib','SD','SD + PFC inhib'}); xtickangle(45);
% ylabel('WAKE percentage (%)')
% 
% ax(2)=subplot(342),MakeSpreadAndBoxPlot2_SB({percSWS_LabBasal percSWS_basal_8_10 percSWS_basal_10_13, percSWS_basal_13_16 percSWS_basal_16_end...
%     percSWS_sal percSWS_SleepInhibPFC percSWS_SD percSWS_SD_inhibPFC},...
%     {col_basal, col_basal,col_basal,col_basal,col_basal,col_sal,col_PFCinhib,col_SD,col_PFCinhib_SD},[1:9],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
% xticks([1:9]); xticklabels({'all','start-10','10-13','13-16','16-end','Saline','PFC inhib','SD','SD + PFC inhib'}); xtickangle(45);
% ylabel('NREM êrcentage (%)')
% 
% ax(3)=subplot(343),MakeSpreadAndBoxPlot2_SB({percREM_LabBasal percREM_basal_8_10 percREM_basal_10_13, percREM_basal_13_16 percREM_basal_16_end...
%     percREM_sal percREM_SleepInhibPFC percREM_SD percREM_SD_inhibPFC},...
%     {col_basal, col_basal,col_basal,col_basal,col_basal,col_sal,col_PFCinhib,col_SD,col_PFCinhib_SD},[1:9],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
% xticks([1:9]); xticklabels({'all','start-10','10-13','13-16','16-end','Saline','PFC inhib','SD','SD + PFC inhib'}); xtickangle(45);
% ylabel('REM percentage (%)')
% title('/ total session')
% 
% ax(4)=subplot(344),MakeSpreadAndBoxPlot2_SB({percREM_totSleep_basal percREM_totSleep_basal_8_10 percREM_totSleep_basal_10_13, percREM_totSleep_basal_13_16 percREM_totSleep_basal_16_end...
%     percREM_totSleep_sal percREM_totSleep_SleepInhibPFC percREM_totSleep_SD percREM_totSleep_SD_inhibPFC},...
%     {col_basal, col_basal,col_basal,col_basal,col_basal,col_sal,col_PFCinhib,col_SD,col_PFCinhib_SD},[1:9],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
% xticks([1:9]); xticklabels({'all','start-10','10-13','13-16','16-end','Saline','PFC inhib','SD','SD + PFC inhib'}); xtickangle(45);
% ylabel('REM percentage (%)')
% title('/total sleep')
% 
% 
% %%Number
% ax(5)=subplot(345),MakeSpreadAndBoxPlot2_SB({NumWAKE_LabBasal NumWAKE_basal_8_10 NumWAKE_basal_10_13, NumWAKE_basal_13_16 NumWAKE_basal_16_end...
%     NumWAKE_sal NumWAKE_SleepInhibPFC NumWAKE_SD NumWAKE_SD_inhibPFC},...
%     {col_basal, col_basal,col_basal,col_basal,col_basal,col_sal,col_PFCinhib,col_SD,col_PFCinhib_SD},[1:9],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
% xticks([1:9]); xticklabels({'all','start-10','10-13','13-16','16-end','Saline','PFC inhib','SD','SD + PFC inhib'}); xtickangle(45);
% ylabel('# WAKE')
% 
% ax(6)=subplot(346),MakeSpreadAndBoxPlot2_SB({NumSWS_LabBasal NumSWS_basal_8_10 NumSWS_basal_10_13, NumSWS_basal_13_16 NumSWS_basal_16_end...
%     NumSWS_sal NumSWS_SleepInhibPFC NumSWS_SD NumSWS_SD_inhibPFC},...
%     {col_basal, col_basal,col_basal,col_basal,col_basal,col_sal,col_PFCinhib,col_SD,col_PFCinhib_SD},[1:9],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
% xticks([1:9]); xticklabels({'all','start-10','10-13','13-16','16-end','Saline','PFC inhib','SD','SD + PFC inhib'}); xtickangle(45);
% ylabel('# NREM')
% 
% ax(7)=subplot(347),MakeSpreadAndBoxPlot2_SB({NumREM_LabBasal NumREM_basal_8_10 NumREM_basal_10_13, NumREM_basal_13_16 NumREM_basal_16_end...
%     NumREM_sal NumREM_SleepInhibPFC NumREM_SD NumREM_SD_inhibPFC},...
%     {col_basal, col_basal,col_basal,col_basal,col_basal,col_sal,col_PFCinhib,col_SD,col_PFCinhib_SD},[1:9],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
% xticks([1:9]); xticklabels({'all','start-10','10-13','13-16','16-end','Saline','PFC inhib','SD','SD + PFC inhib'}); xtickangle(45);
% ylabel('# REM')
% 
% set(ax,'Xticklabels',[])
% 
% %%duration
% ax1(1)=subplot(349),MakeSpreadAndBoxPlot2_SB({durWAKE_LabBasal durWAKE_basal_8_10 durWAKE_basal_10_13, durWAKE_basal_13_16 durWAKE_basal_16_end...
%     durWAKE_sal durWAKE_SleepInhibPFC durWAKE_SD durWAKE_SD_inhibPFC},...
%     {col_basal, col_basal,col_basal,col_basal,col_basal,col_sal,col_PFCinhib,col_SD,col_PFCinhib_SD},[1:9],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
% xticks([1:9]); xticklabels({'all','start-10','10-13','13-16','16-end','Saline','PFC inhib','SD','SD + PFC inhib'}); xtickangle(45);
% ylabel('Mean duration WAKE (s)')
% 
% ax1(3)=subplot(3,4,10),MakeSpreadAndBoxPlot2_SB({durSWS_LabBasal durSWS_basal_8_10 durSWS_basal_10_13, durSWS_basal_13_16 durSWS_basal_16_end...
%     durSWS_sal durSWS_SleepInhibPFC durSWS_SD durSWS_SD_inhibPFC},...
%     {col_basal, col_basal,col_basal,col_basal,col_basal,col_sal,col_PFCinhib,col_SD,col_PFCinhib_SD},[1:9],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
% xticks([1:9]); xticklabels({'all','start-10','10-13','13-16','16-end','Saline','PFC inhib','SD','SD + PFC inhib'}); xtickangle(45);
% ylabel('Mean duration NREM (s)')
% 
% ax1(3)=subplot(3,4,11),MakeSpreadAndBoxPlot2_SB({durREM_LabBasal durREM_basal_8_10 durREM_basal_10_13, durREM_basal_13_16 durREM_basal_16_end...
%     durREM_sal durREM_SleepInhibPFC durREM_SD durREM_SD_inhibPFC},...
%     {col_basal, col_basal,col_basal,col_basal,col_basal,col_sal,col_PFCinhib,col_SD,col_PFCinhib_SD},[1:9],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
% xticks([1:9]); xticklabels({'all','start-10','10-13','13-16','16-end','Saline','PFC inhib','SD','SD + PFC inhib'}); xtickangle(45);
% ylabel('Mean duration REM (s)')
% 
% 
% %% 3H POST SD
% 
% figure
% %%percentage
% ax(1)=subplot(341),MakeSpreadAndBoxPlot2_SB({percWAKE_LabBasal percWAKE_basal_8_10 percWAKE_basal_10_13, percWAKE_basal_13_16 percWAKE_basal_16_end...
%     percWAKE_3hPostSD_sal percWAKE_3hPostSD_SleepInhibPFC percWAKE_3hPostSD_SD percWAKE_3hPostSD_SD_inhibPFC},...
%     {col_basal, col_basal,col_basal,col_basal,col_basal,col_sal,col_PFCinhib,col_SD,col_PFCinhib_SD},[1:9],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
% xticks([1:9]); xticklabels({'all','start-10','10-13','13-16','16-end','Saline','PFC inhib','SD','SD + PFC inhib'}); xtickangle(45);
% ylabel('WAKE percentage (%)')
% 
% ax(2)=subplot(342),MakeSpreadAndBoxPlot2_SB({percSWS_LabBasal percSWS_basal_8_10 percSWS_basal_10_13, percSWS_basal_13_16 percSWS_basal_16_end...
%     percSWS_3hPostSD_sal percSWS_3hPostSD_SleepInhibPFC percSWS_3hPostSD_SD percSWS_3hPostSD_SD_inhibPFC},...
%     {col_basal, col_basal,col_basal,col_basal,col_basal,col_sal,col_PFCinhib,col_SD,col_PFCinhib_SD},[1:9],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
% xticks([1:9]); xticklabels({'all','start-10','10-13','13-16','16-end','Saline','PFC inhib','SD','SD + PFC inhib'}); xtickangle(45);
% ylabel('NREM êrcentage (%)')
% 
% ax(3)=subplot(343),MakeSpreadAndBoxPlot2_SB({percREM_LabBasal percREM_basal_8_10 percREM_basal_10_13, percREM_basal_13_16 percREM_basal_16_end...
%     percREM_3hPostSD_sal percREM_3hPostSD_SleepInhibPFC percREM_3hPostSD_SD percREM_3hPostSD_SD_inhibPFC},...
%     {col_basal, col_basal,col_basal,col_basal,col_basal,col_sal,col_PFCinhib,col_SD,col_PFCinhib_SD},[1:9],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
% xticks([1:9]); xticklabels({'all','start-10','10-13','13-16','16-end','Saline','PFC inhib','SD','SD + PFC inhib'}); xtickangle(45);
% ylabel('REM percentage (%)')
% title('/ total session')
% 
% ax(4)=subplot(344),MakeSpreadAndBoxPlot2_SB({percREM_totSleep_basal percREM_totSleep_basal_8_10 percREM_totSleep_basal_10_13, percREM_totSleep_basal_13_16 percREM_totSleep_basal_16_end...
%     percREM_totSleep_sal_3hPostSD percREM_totSleep_SleepInhibPFC_3hPostSD percREM_totSleep_SD_3hPostSD percREM_totSleep_SD_inhibPFC_3hPostSD},...
%     {col_basal, col_basal,col_basal,col_basal,col_basal,col_sal,col_PFCinhib,col_SD,col_PFCinhib_SD},[1:9],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
% xticks([1:9]); xticklabels({'all','start-10','10-13','13-16','16-end','Saline','PFC inhib','SD','SD + PFC inhib'}); xtickangle(45);
% ylabel('REM percentage (%)')
% title('/total sleep')
% 
% 
% %%Number
% ax(5)=subplot(345),MakeSpreadAndBoxPlot2_SB({NumWAKE_LabBasal NumWAKE_basal_8_10 NumWAKE_basal_10_13, NumWAKE_basal_13_16 NumWAKE_basal_16_end...
%     NumWAKE_3hPostSD_sal NumWAKE_3hPostSD_SleepInhibPFC NumWAKE_3hPostSD_SD NumWAKE_3hPostSD_SD_inhibPFC},...
%     {col_basal, col_basal,col_basal,col_basal,col_basal,col_sal,col_PFCinhib,col_SD,col_PFCinhib_SD},[1:9],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
% xticks([1:9]); xticklabels({'all','start-10','10-13','13-16','16-end','Saline','PFC inhib','SD','SD + PFC inhib'}); xtickangle(45);
% ylabel('# WAKE')
% 
% ax(6)=subplot(346),MakeSpreadAndBoxPlot2_SB({NumSWS_LabBasal NumSWS_basal_8_10 NumSWS_basal_10_13, NumSWS_basal_13_16 NumSWS_basal_16_end...
%     NumSWS_3hPostSD_sal NumSWS_3hPostSD_SleepInhibPFC NumSWS_3hPostSD_SD NumSWS_3hPostSD_SD_inhibPFC},...
%     {col_basal, col_basal,col_basal,col_basal,col_basal,col_sal,col_PFCinhib,col_SD,col_PFCinhib_SD},[1:9],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
% xticks([1:9]); xticklabels({'all','start-10','10-13','13-16','16-end','Saline','PFC inhib','SD','SD + PFC inhib'}); xtickangle(45);
% ylabel('# NREM')
% 
% ax(7)=subplot(347),MakeSpreadAndBoxPlot2_SB({NumREM_LabBasal NumREM_basal_8_10 NumREM_basal_10_13, NumREM_basal_13_16 NumREM_basal_16_end...
%     NumREM_3hPostSD_sal NumREM_3hPostSD_SleepInhibPFC NumREM_3hPostSD_SD NumREM_3hPostSD_SD_inhibPFC},...
%     {col_basal, col_basal,col_basal,col_basal,col_basal,col_sal,col_PFCinhib,col_SD,col_PFCinhib_SD},[1:9],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
% xticks([1:9]); xticklabels({'all','start-10','10-13','13-16','16-end','Saline','PFC inhib','SD','SD + PFC inhib'}); xtickangle(45);
% ylabel('# REM')
% 
% set(ax,'Xticklabels',[])
% 
% %%duration
% ax1(1)=subplot(349),MakeSpreadAndBoxPlot2_SB({durWAKE_LabBasal durWAKE_basal_8_10 durWAKE_basal_10_13, durWAKE_basal_13_16 durWAKE_basal_16_end...
%     durWAKE_3hPostSD_sal durWAKE_3hPostSD_SleepInhibPFC durWAKE_3hPostSD_SD durWAKE_3hPostSD_SD_inhibPFC},...
%     {col_basal, col_basal,col_basal,col_basal,col_basal,col_sal,col_PFCinhib,col_SD,col_PFCinhib_SD},[1:9],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
% xticks([1:9]); xticklabels({'all','start-10','10-13','13-16','16-end','Saline','PFC inhib','SD','SD + PFC inhib'}); xtickangle(45);
% ylabel('Mean duration WAKE (s)')
% 
% ax1(3)=subplot(3,4,10),MakeSpreadAndBoxPlot2_SB({durSWS_LabBasal durSWS_basal_8_10 durSWS_basal_10_13, durSWS_basal_13_16 durSWS_basal_16_end...
%     durSWS_3hPostSD_sal durSWS_3hPostSD_SleepInhibPFC durSWS_3hPostSD_SD durSWS_3hPostSD_SD_inhibPFC},...
%     {col_basal, col_basal,col_basal,col_basal,col_basal,col_sal,col_PFCinhib,col_SD,col_PFCinhib_SD},[1:9],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
% xticks([1:9]); xticklabels({'all','start-10','10-13','13-16','16-end','Saline','PFC inhib','SD','SD + PFC inhib'}); xtickangle(45);
% ylabel('Mean duration NREM (s)')
% 
% ax1(3)=subplot(3,4,11),MakeSpreadAndBoxPlot2_SB({durREM_LabBasal durREM_basal_8_10 durREM_basal_10_13, durREM_basal_13_16 durREM_basal_16_end...
%     durREM_3hPostSD_sal durREM_3hPostSD_SleepInhibPFC durREM_3hPostSD_SD durREM_3hPostSD_SD_inhibPFC},...
%     {col_basal, col_basal,col_basal,col_basal,col_basal,col_sal,col_PFCinhib,col_SD,col_PFCinhib_SD},[1:9],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
% xticks([1:9]); xticklabels({'all','start-10','10-13','13-16','16-end','Saline','PFC inhib','SD','SD + PFC inhib'}); xtickangle(45);
% ylabel('Mean duration REM (s)')





%%
%% get the data
% goodNum=[];
% %lab baseline
% for i=1:length(DirMyBasal.path)
%     cd(DirMyBasal.path{i}{1});
%     if exist('SleepScoring_Accelero.mat')
%         a{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
%         durtotal_basal{i} = max([max(End(a{i}.Wake)),max(End(a{i}.SWSEpoch))]);
%         
%         %all post
%         epoch_allPostSD_LabBasal{i}=intervalSet(0.7*1E8,durtotal_basal{i});
%         %3h post SD
%         epoch_3hPostSD_LabBasal{i}=intervalSet(0,3*3600*1E4);
%         
%         if isempty(a{i})==0
%             %percentage all sleep session
%             %SleepStagePerc_LabBasal1{i} = ComputeSleepStagesPercentagesMC(a{i}.Wake,a{i}.SWSEpoch,a{i}.REMEpoch);
%             SleepStagePerc_LabBasal1{i} = ComputeSleepStagesPercentagesMC(and(a{i}.Wake,epoch_allPostSD_LabBasal{i}),and(a{i}.SWSEpoch,epoch_allPostSD_LabBasal{i}),and(a{i}.REMEpoch,epoch_allPostSD_LabBasal{i}));
%             percWAKE_LabBasal(i) = SleepStagePerc_LabBasal1{i}(1,1); percWAKE_LabBasal(percWAKE_LabBasal==0)=NaN;
%             percSWS_LabBasal(i) = SleepStagePerc_LabBasal1{i}(2,1);  percSWS_LabBasal(percSWS_LabBasal==0)=NaN;
%             percREM_LabBasal(i) = SleepStagePerc_LabBasal1{i}(3,1); percREM_LabBasal(percREM_LabBasal==0)=NaN;
%             %percentage 3h after SD
%             SleepStagePerc_LabBasal2{i} = ComputeSleepStagesPercentagesMC(a{i}.Wake,a{i}.SWSEpoch,a{i}.REMEpoch);
%             percWAKE_3hPostSD_LabBasal(i) = SleepStagePerc_LabBasal2{i}(1,5); percWAKE_3hPostSD_LabBasal(percWAKE_3hPostSD_LabBasal==0)=NaN;
%             percSWS_3hPostSD_LabBasal(i) = SleepStagePerc_LabBasal2{i}(2,5); percSWS_3hPostSD_LabBasal(percSWS_3hPostSD_LabBasal==0)=NaN;
%             percREM_3hPostSD_LabBasal(i) = SleepStagePerc_LabBasal2{i}(3,5); percREM_3hPostSD_LabBasal(percREM_3hPostSD_LabBasal==0)=NaN;
%             
%             %%percentage of REM out of total sleep
%             %Restemp_totSleep_basal{i}=ComputeSleepStagesPercentagesWithoutWakeMC(a{i}.Wake,a{i}.SWSEpoch,a{i}.REMEpoch);
%             Restemp_totSleep_basal{i}=ComputeSleepStagesPercentagesWithoutWakeMC(and(a{i}.Wake,epoch_allPostSD_LabBasal{i}),and(a{i}.SWSEpoch,epoch_allPostSD_LabBasal{i}),and(a{i}.REMEpoch,epoch_allPostSD_LabBasal{i}));
%             %percentage post injection
%             percREM_totSleep_basal(i)=Restemp_totSleep_basal{i}(3,1); percREM_totSleep_basal(percREM_totSleep_basal==0)=NaN;
%             %percentage 3h post injection
%             percREM_totSleep_basal_3hPostSD(i)=Restemp_totSleep_basal{i}(3,5); percREM_totSleep_basal_3hPostSD(percREM_totSleep_basal_3hPostSD==0)=NaN;
%             
%             %number of  bouts all sleep session
%             NumWAKE_LabBasal(i) = length(length(and(a{i}.Wake,epoch_allPostSD_LabBasal{i}))); NumWAKE_LabBasal(NumWAKE_LabBasal==0)=NaN;
%             NumSWS_LabBasal(i) = length(length(and(a{i}.SWSEpoch,epoch_allPostSD_LabBasal{i}))); NumSWS_LabBasal(NumSWS_LabBasal==0)=NaN;
%             NumREM_LabBasal(i) = length(length(and(a{i}.REMEpoch,epoch_allPostSD_LabBasal{i}))); NumREM_LabBasal(NumREM_LabBasal==0)=NaN;
%             %number of  bouts 3h post SD
%             NumWAKE_3hPostSD_LabBasal(i) = length(length(and(a{i}.Wake,epoch_3hPostSD_LabBasal{i}))); NumWAKE_3hPostSD_LabBasal(NumWAKE_3hPostSD_LabBasal==0)=NaN;
%             NumSWS_3hPostSD_LabBasal(i) = length(length(and(a{i}.SWSEpoch,epoch_3hPostSD_LabBasal{i}))); NumSWS_3hPostSD_LabBasal(NumSWS_3hPostSD_LabBasal==0)=NaN;
%             NumREM_3hPostSD_LabBasal(i) = length(length(and(a{i}.REMEpoch,epoch_3hPostSD_LabBasal{i}))); NumREM_3hPostSD_LabBasal(NumREM_3hPostSD_LabBasal==0)=NaN;
%             
%             %%duration of bouts all sleep session
%             durWAKE_LabBasal(i) = mean(End(and(a{i}.Wake,epoch_allPostSD_LabBasal{i}),'s')-Start(and(a{i}.Wake,epoch_allPostSD_LabBasal{i}),'s')); durWAKE_LabBasal(durWAKE_LabBasal==0)=NaN;
%             durSWS_LabBasal(i) = mean(End(and(a{i}.SWSEpoch,epoch_allPostSD_LabBasal{i}),'s')-Start(and(a{i}.SWSEpoch,epoch_allPostSD_LabBasal{i}),'s')); durSWS_LabBasal(durSWS_LabBasal==0)=NaN;
%             durREM_LabBasal(i) = mean(End(and(a{i}.REMEpoch,epoch_allPostSD_LabBasal{i}),'s')-Start(and(a{i}.REMEpoch,epoch_allPostSD_LabBasal{i}),'s')); durREM_LabBasal(durREM_LabBasal==0)=NaN;
%             %dur total
%             durTREM_LabBasal(i) = sum(End(and(a{i}.REMEpoch,epoch_allPostSD_LabBasal{i}),'s')-Start(and(a{i}.REMEpoch,epoch_allPostSD_LabBasal{i}),'s')); durTREM_LabBasal(durTREM_LabBasal==0)=NaN;
%             durTSWS_LabBasal(i) = sum(End(and(a{i}.SWSEpoch,epoch_allPostSD_LabBasal{i}),'s')-Start(and(a{i}.SWSEpoch,epoch_allPostSD_LabBasal{i}),'s')); durTSWS_LabBasal(durTSWS_LabBasal==0)=NaN;
%             durTWAKE_LabBasal(i) = sum(End(and(a{i}.Wake,epoch_allPostSD_LabBasal{i}),'s')-Start(and(a{i}.Wake,epoch_allPostSD_LabBasal{i}),'s')); durTWAKE_LabBasal(durTWAKE_LabBasal==0)=NaN;
%             
%             %%duration of bouts 3h post SD
%             durWAKE_3hPostSD_LabBasal(i) = mean(End(and(a{i}.Wake,epoch_3hPostSD_LabBasal{i}),'s')-Start(and(a{i}.Wake,epoch_3hPostSD_LabBasal{i}),'s'));
%             durWAKE_3hPostSD_LabBasal(durWAKE_3hPostSD_LabBasal==0)=NaN;
%             durSWS_3hPostSD_LabBasal(i) = mean(End(and(a{i}.SWSEpoch,epoch_3hPostSD_LabBasal{i}),'s')-Start(and(a{i}.SWSEpoch,epoch_3hPostSD_LabBasal{i}),'s'));
%             durSWS_3hPostSD_LabBasal(durSWS_3hPostSD_LabBasal==0)=NaN;
%             durREM_3hPostSD_LabBasal(i) = mean(End(and(a{i}.REMEpoch,epoch_3hPostSD_LabBasal{i}),'s')-Start(and(a{i}.REMEpoch,epoch_3hPostSD_LabBasal{i}),'s'));
%             durREM_3hPostSD_LabBasal(durREM_3hPostSD_LabBasal==0)=NaN;
%             
%             %dur total 3h post SD
%             durTREM_3hPostSD_LabBasal(i) = sum(End(and(a{i}.REMEpoch,epoch_3hPostSD_LabBasal{i}),'s')-Start(and(a{i}.REMEpoch,epoch_3hPostSD_LabBasal{i}),'s'));
%             durTREM_3hPostSD_LabBasal(durTREM_3hPostSD_LabBasal==0)=NaN;
%             durTSWS_3hPostSD_LabBasal(i) = sum(End(and(a{i}.SWSEpoch,epoch_3hPostSD_LabBasal{i}),'s')-Start(and(a{i}.SWSEpoch,epoch_3hPostSD_LabBasal{i}),'s'));
%             durTSWS_3hPostSD_LabBasal(durTSWS_3hPostSD_LabBasal==0)=NaN;
%             durTWAKE_3hPostSD_LabBasal(i) = sum(End(and(a{i}.Wake,epoch_3hPostSD_LabBasal{i}),'s')-Start(and(a{i}.Wake,epoch_3hPostSD_LabBasal{i}),'s'));
%             durTWAKE_3hPostSD_LabBasal(durTWAKE_3hPostSD_LabBasal==0)=NaN;
%         else
%             
%         end
%     else
%         
%         a{i}=[];
%     end
%     
% end
