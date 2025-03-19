%%DownstatesSubpopulationAnalysisFiringRate
%
% 11.03.2018 KJ
%
%   Takes all the down computed in DownstatesSubpopulationAnalysis, remove
%   shoort and long events, and compute density curves and then:
%   - overlap, distance to density...
%
% see
%   DownstatesSubpopulationAnalysis
%


% load
clear
load(fullfile(FolderDeltaDataKJ,'DownstatesSubpopulationAnalysis.mat'))


for p=1:length(downsub_res.path)
    
    disp(' ')
    disp('****************************************************************')
    disp(downsub_res.path{p})
    
    clearvars -except downsub_res p subfr_res range_nbneurons
    
    subfr_res.path{p}   = downsub_res.path{p};
    subfr_res.manipe{p} = downsub_res.manipe{p};
    subfr_res.name{p}   = downsub_res.name{p};
    subfr_res.date{p}   = downsub_res.date{p};
    
    
    %params
    binsize=10;
    binsize_met = 5; %for mETAverage  
    nbBins_met  = 240; %for mETAverage 
    
    %load
    load(fullfile(downsub_res.path{p}, 'IdFigureData2.mat'), 'night_duration')
    load(fullfile(downsub_res.path{p}, 'DownState.mat'), 'down_PFCx','down_PFCx_Info')
    down_tmp = (Start(down_PFCx)+End(down_PFCx)) / 2;
    min_duration = down_PFCx_Info.min_duration;
    max_duration = down_PFCx_Info.max_duration;
    
    %MUA
    load(fullfile(downsub_res.path{p}, 'SpikeData.mat'), 'S')
    if exist(fullfile(downsub_res.path{p},'SpikesToAnalyse', 'PFCx_down.mat'),'file')==2
        load(fullfile(downsub_res.path{p},'SpikesToAnalyse', 'PFCx_down.mat'))
    else
        load(fullfile(downsub_res.path{p},'SpikesToAnalyse', 'PFCx_Neurons.mat'))
    end
    NumNeurons=number;
    clear number
    
    
    %% True Down distribution
    %pool all neurons
    if isa(S,'tsdArray')
        MUA = MakeQfromS(S(NumNeurons), binsize*10);
    else
        MUA = MakeQfromS(tsdArray(S(NumNeurons)),binsize*10);
    end

    MUA = tsd(Range(MUA), sum(full(Data(MUA)),2));

    
    %% subpopulation
    for i=1:length(range_nbneurons)
        if ~isempty(downsub_res.sub.real.sws{p,i})
            %subpopulation down    
            sub_Down = downsub_res.sub.real.sws{p,i};
            sub_Down = dropShortIntervals(sub_Down, min_duration);
            sub_Down = dropLongIntervals(sub_Down, max_duration);
            
            
            %mean curves of firing rate on down
            [m,~,tps] = mETAverage(Start(sub_Down), Range(MUA), Data(MUA), binsize_met, nbBins_met);
            subfr_res.meansub{p,i}(:,1) = tps; 
            subfr_res.meansub{p,i}(:,2) = m;
            
            %
            subfr_res.firingDown{p,i} = sum(Data(Restrict(MUA, sub_Down)));
            subfr_res.subdown_dur{p,i} = tot_length(sub_Down);
            
            
            %save
            subfr_res.nb_neuron{p,i}  = downsub_res.sub.nb_neuron{p,i};
            subfr_res.sws.fr{p,i}     = downsub_res.sub.firingrate.sws{p,i};
            subfr_res.wake.fr{p,i}    = downsub_res.sub.firingrate.wake{p,i};
        
        end
    end
    
end

%saving data
cd([FolderProjetDelta 'Data/'])
save DownstatesSubpopulationAnalysisFiringRate.mat -v7.3 subfr_res range_nbneurons binsize binsize_met nbBins_met




