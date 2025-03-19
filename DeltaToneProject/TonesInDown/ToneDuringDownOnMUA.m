%%ToneDuringDownOnMUA
% 29.03.2018 KJ
%
%
% see
%   
%


clear


Dir1=PathForExperimentsDeltaSleepSpikes('RdmTone');
Dir2=PathForExperimentsDeltaSleepSpikes('DeltaT0');
Dir = MergePathForExperiment(Dir1,Dir2);



for p=1:length(Dir.path)
    
    disp('')
    disp('***************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p

    %params
    binsize_met = 10;
    nbBins_met = 80;
    binsize_mua=2;
    
    %% load
    

    %MUA
    MUA = GetMuaNeurons_KJ('PFCx','binsize',binsize_mua); %2ms
    load('DownState.mat')
    st_down = Start(down_PFCx);
    end_down = End(down_PFCx);
    down_duration = End(down_PFCx) - Start(down_PFCx);

    %Down
    down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', 30,'maxDuration', 600, 'mergeGap', binsize_mua, 'predown_size', 20, 'method', 'mono');

    %Substages
    if exist('SleepSubstages.mat','file')==2
        load('SleepSubstages.mat', 'Epoch', 'NameEpoch')
        Substages = Epoch([1:5 7]);
        NamesSubstages = NameEpoch([1:5 7]);
    else
        clear op NamesOp Dpfc Epoch noise
        load NREMepochsML.mat op NamesOp Dpfc Epoch noise
        disp('Loading epochs from NREMepochsML.m')
        [Substages,NamesSubstages]=DefineSubStages(op,noise);
    end

    %tones
    load('DeltaSleepEvent.mat', 'TONEtime2')
    if ~exist('TONEtime2','var')
        continue
    end
    tones_tmp = TONEtime2 + Dir.delay{p}*1E4;
    ToneEvent = ts(tones_tmp);
    nb_tones = length(tones_tmp);


    %% 

    %predown epoch
    prewindow = 2000;
    befDown = intervalSet(Start(down_PFCx)-prewindow, Start(down_PFCx)); 
    postwindow = 1000;
    aftDown = intervalSet(End(down_PFCx), End(down_PFCx)+postwindow);

    %tones in and out down states
    Allnight = intervalSet(0,max(Range(MUA)));
    ToneDown = Restrict(ToneEvent, down_PFCx);
    ToneBef = Restrict(ToneEvent, befDown);
    ToneAft = Restrict(ToneEvent, aftDown);
    ToneOut = Restrict(ToneEvent, CleanUpEpoch(Allnight-or(or(down_PFCx,befDown),aftDown)));


    %% in N2, N3 , NREM
    figure, hold on
    
    smoothing=[0 1];
    for j=1:2 %smoothing
        k=0;
        for sst=[2 3 6]

            k=k+1;
            % IN down
            tTones = Restrict(ToneDown, Substages{sst});
            [m,~,tps] = mETAverage(Range(tTones), Range(MUA), Data(MUA), binsize_met, nbBins_met);
            met_in{sst}(:,1) = tps; met_in{sst}(:,2) = Smooth(m,smoothing(j));
            nb_in{sst} = length(tTones);

            % Before down
            tTones = Restrict(ToneBef, Substages{sst});
            [m,~,tps] = mETAverage(Range(tTones), Range(MUA), Data(MUA), binsize_met, nbBins_met);
            met_before{sst}(:,1) = tps; met_before{sst}(:,2) = Smooth(m,smoothing(j));
            nb_before{sst} = length(tTones);

            % After down
            tTones = Restrict(ToneAft, Substages{sst});
            [m,~,tps] = mETAverage(Range(tTones), Range(MUA), Data(MUA), binsize_met, nbBins_met);
            met_after{sst}(:,1) = tps; met_after{sst}(:,2) = Smooth(m,smoothing(j));
            nb_after{sst} = length(tTones);

            % out of down
            tTones = Restrict(ToneOut, Substages{sst});
            [m,~,tps] = mETAverage(Range(tTones), Range(MUA), Data(MUA), binsize_met, nbBins_met);
            met_out{sst}(:,1) = tps; met_out{sst}(:,2) = Smooth(m,smoothing(j));
            nb_out{sst} = length(tTones);


            subplot(2,3, 3*(j-1) + k), hold on
            h(1) = plot(met_in{sst}(:,1), met_in{sst}(:,2), 'b'); hold on
            h(2) = plot(met_before{sst}(:,1), met_before{sst}(:,2), 'r'); hold on
            h(3) = plot(met_after{sst}(:,1), met_after{sst}(:,2), 'g'); hold on
            h(4) = plot(met_out{sst}(:,1), met_out{sst}(:,2), 'color', [0.6 0.6 0.6]); hold on


            xlabel('time relative to tones (ms)'), ylabel(''), %xlim([-400 800])
            line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
            lgd = legend(h, ['In down - ' num2str(nb_in{sst})], ['Before down - ' num2str(nb_before{sst})], ['After down - ' num2str(nb_after{sst})], ['Out of down - ' num2str(nb_out{sst})]);
            lgd.Location = 'northwest';
            title(NamesSubstages{sst}),

        end
    end
    
    suplabel([Dir.name{p} ' - ' Dir.date{p} ' (' Dir.manipe{p} ')'], 't');

end


%% Plot

% for s=1:6
%     tTones = Restrict(ToneOut, Substages{s});
%     [m,~,tps] = mETAverage(Range(tTones), Range(MUA), Data(MUA), binsize_met, nbBins_met);
%     met_out{s}(:,1) = tps; met_out{s}(:,2) = m;
%     nb_out{s} = length(tTones); 
%     
%     tTones = Restrict(ToneDown, Substages{s});
%     [m,~,tps] = mETAverage(Range(tTones), Range(MUA), Data(MUA), binsize_met, nbBins_met);
%     met_in{s}(:,1) = tps; met_in{s}(:,2) = m;
%     nb_in{s} = length(tTones);
%     
% end
% 
% figure, hold on
% 
% for s=1:6
%     
%     subplot(2,3,s), hold on
%     h(1)=plot(met_in{s}(:,1), met_in{s}(:,2), 'b'); hold on
%     h(2)=plot(met_out{s}(:,1), met_out{s}(:,2), 'r'); hold on
%     
%     
%     xlabel('time relative to tones (ms)'), ylabel(''), %xlim([-400 800])
%     line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
%     legend(h, ['In down - ' num2str(nb_in{s})], ['Out of down - ' num2str(nb_out{s})]),
%     title(NamesSubstages{s}),
%     
% 
% end











