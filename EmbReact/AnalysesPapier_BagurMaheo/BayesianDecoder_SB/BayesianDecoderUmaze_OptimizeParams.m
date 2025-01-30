clear all
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/HPC_Reactivations/Data

% Session identity
MiceNumber = [905,911,994,1161,1162,1168,1186,1230,1239];
Session_type={'Hab1','Hab2','Hab','Cond'};
mm = 3; % This seems to be the best mouse
sess = 3;

% Parameters
SpeedLim = 2; % To define movepoch
curvexy = [.15 .15 .85 .85; 0 .96 .96 0]';

% Parameters to scan
Binsize_all = [0.05*1e4,0.1*1e4,0.2*1e4,0.5*1e4]; % temporal binsize for decoding
SpatialBins_all = [10,20,50,100];
SpatialInfo_Thresh_all = [0,0.2,0.5,1,1.2];


% Get linearized position
for mm = 1:length(MiceNumber)
    for sess = 3:4
        % load data
        cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/HPC_Reactivations/Data
        clear Ripples FreezeEpoch LinPos StimEpoch NoiseEpoch Vtsd Spikes Q
        load(['RippleReactInfo_NewRipples_' Session_type{sess} '_Mouse',num2str(MiceNumber(mm)),'.mat'])
        disp(['RippleReactInfo_NewRipples_' Session_type{sess} '_Mouse',num2str(MiceNumber(mm)),'.mat'])
        
        % define epochs to analyse place fields
        % Noise epoch = noise defined on LFP + 0.1s after aversive stimulation
        try
            TotalNoiseEpoch = or(StimEpoch , NoiseEpoch);
        catch
            try
                TotalNoiseEpoch = NoiseEpoch;
            catch
                TotalNoiseEpoch = intervalSet([],[]);
            end
        end
        
        AfterStimEpoch = intervalSet(Start(StimEpoch) , Start(StimEpoch)+.1e4);
        TotalNoiseEpoch = or(TotalNoiseEpoch , AfterStimEpoch);
        
        % move epoch : above threshold speed
        MovEpoch = thresholdIntervals(Vtsd,SpeedLim,'Direction','Above');
        MovEpoch = mergeCloseIntervals(MovEpoch,2*1e4)-FreezeEpoch;
        MovEpoch = MovEpoch-TotalNoiseEpoch;
        
        X_Pos = Data(Restrict(Xtsd,MovEpoch));
        Y_Pos = Data(Restrict(Ytsd,MovEpoch));
        mapxy=[X_Pos';Y_Pos']';
        [xy,distance,linpos] = distance2curve(curvexy,mapxy,'linear');
        LinPos_tsd = tsd(Range(Restrict(Xtsd,MovEpoch)),linpos);
        
        for bin_oi = 1:length(Binsize_all)
            bin_oi
            for spatbin_oi = 1:length(SpatialBins_all)
                spatbin_oi
                for spatinfo_oi = 1:length(SpatialBins_all)
                    Binsize = Binsize_all(bin_oi);
                    SpatialBins = SpatialBins_all(spatbin_oi);
                    SpatialInfo_Thresh = SpatialInfo_Thresh_all(spatinfo_oi);
                    
                    LinearizePos_time = hist(linpos,linspace(0,1,SpatialBins))*median(diff(Range(Restrict(Xtsd,MovEpoch),'s')));
                    
                    
                    % calculate spatial firing maps
                    clear LinearizeFiring_binned SpatialInfo
                    for neur=1:length(Spikes)
                        
                        if max(size(Restrict(Spikes{neur},MovEpoch)))>10 % Only use cells with at least 10 spikes in move epoch
                            X_OnSpikes = Data(Restrict(Xtsd,ts(Range(Restrict(Spikes{neur},MovEpoch)))));
                            Y_OnSpikes = Data(Restrict(Ytsd,ts(Range(Restrict(Spikes{neur},MovEpoch)))));
                            mapxy=[X_OnSpikes';Y_OnSpikes']';
                            [xy,distance,t] = distance2curve(curvexy,mapxy,'linear');
                            LinearizeFiring_binned(neur,:) = hist(t,linspace(0,1,SpatialBins));
                            
                            
                            [map_mov{neur}, mapNS_mov{neur}, stats{neur}, px{neur}, py{neur}, FR_mov(neur)] = PlaceField_DB(Spikes{neur}, Xtsd,...
                                Ytsd , 'PlotResults' , 0 , 'PlotPoisson' ,0 , 'epoch' , MovEpoch);
                            
                            if isempty(stats{neur}.spatialInfo)
                                stats{neur}.spatialInfo = 0;
                            end
                            
                            SpatialInfo(neur) = stats{neur}.spatialInfo;
                            
                            
                        else
                            FR_mov(neur) = NaN;
                            SpatialInfo(neur) = 0;
                            LinearizeFiring_binned(neur,:) = nan(1,SpatialBins);
                        end
                    end
                    
                    % Normalize by time spent
                    LinearizeFiring_binned_norm = LinearizeFiring_binned./repmat(LinearizePos_time,size(LinearizeFiring_binned,1),1);
                    LinearizeFiring_binned_norm(:,find(LinearizePos_time==0)) = 0;
                    
                    % Get data for decoding
                    Q = MakeQfromS(Restrict(Spikes,MovEpoch),Binsize); % data from the conditionning session
                    data_decoder = full(Data(Q)'/(Binsize/1e4));
                    
                    % Get rid of NaN cells
                    BadGuys = find(sum(isnan(LinearizeFiring_binned)'));
                    LinearizeFiring_binned_norm(BadGuys,:) = [];
                    data_decoder(BadGuys,:) = [];
                    SpatialInfo(BadGuys) = [];
                    
                    % Only keep cells with enough spatial info
                    GoodGuys = SpatialInfo>SpatialInfo_Thresh;
                    data_decoder = data_decoder(GoodGuys,:);
                    LinearizeFiring_binned_norm = LinearizeFiring_binned_norm(GoodGuys,:);
                    
                    
                    % Do decoding
                    clear probs_final
                    for bin = 1:size(data_decoder,2)
                        clear probs
                        for neur = 1:size(LinearizeFiring_binned_norm,1)
                            % Expected spike count
                            lam = LinearizeFiring_binned_norm(neur,:);
                            %Actual spike count
                            r = (data_decoder(neur,bin));
                            % Probability of the given neuron's spike count given tuning curve (assuming poisson distribution)
                            probs(neur,:) = exp(-lam).*(lam.^r/factorial(r));
                            
                        end
                        probs_final(bin,:) = prod(probs).* LinearizePos_time;
                    end
                    
                    % Get peak probability
                    [val,ind] = max(probs_final');
                    
                    % Can't use empty bins
                    ind(nansum(data_decoder)==0) = NaN;
                    
                    % Store the result
                    DecodedPos{bin_oi}{spatbin_oi}{spatinfo_oi} = ind/SpatialBins;
                    ActualPos{bin_oi}{spatbin_oi}{spatinfo_oi} = Data(Restrict(LinPos_tsd,Range(Q)));
                    Error(bin_oi,spatbin_oi,spatinfo_oi) =  nanmean((ind'/SpatialBins-Data(Restrict(LinPos_tsd,Range(Q)))).^2);
                    NumGoodNeur(bin_oi,spatbin_oi,spatinfo_oi) = size(LinearizeFiring_binned_norm,1);
                end
            end
        end
%         cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/HPC_Reactivations/Data
%         save(['Bayesian_Results',Session_type{sess} '_Mouse',num2str(MiceNumber(mm)),'.mat'],...
%             'DecodedPos','ActualPos','Error')
        clear DecodedPos ActualPos Error
        
    end
end


cols = summer(5);
for mm = 1:length(MiceNumber)
    for sess = 3:4
        fig = figure;
        % load data
        cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/HPC_Reactivations/Data
        clear Ripples FreezeEpoch LinPos StimEpoch NoiseEpoch Vtsd Spikes Q
        load(['Bayesian_Results',Session_type{sess} '_Mouse',num2str(MiceNumber(mm)),'.mat'])
        
        subplot(231)
        % Fix spatial info limit
        SpatInfoFix = 1;
        for ii = 1:4
            plot(SpatialBins_all,squeeze(Error(ii,:,SpatInfoFix)),'color',cols(ii,:))
            hold on
        end
        xlabel('Spatial binsize')
        legend('50ms','100ms','200ms','500ms')
        makepretty
        ylim([0 0.3])
        xlim([0 110])
        
        subplot(232)
        % Fix temporal binsize
        TempBinFix = 3;
        for ii = 1:4
            plot(SpatialBins_all,squeeze(Error(TempBinFix,:,ii)),'color',cols(ii,:))
            hold on
        end
        xlabel('Spatial binsize')
        legend('0bit','0.2','0.5','1')
        makepretty
        ylim([0 0.3])
        xlim([0 110])
        
        subplot(233)
        bin_oi = 4;
        spatbin_oi = 2;
        spatinfo_oi = 1;
        x = DecodedPos{bin_oi}{spatbin_oi}{spatinfo_oi};
        y = ActualPos{bin_oi}{spatbin_oi}{spatinfo_oi}';
        BadGuys  =isnan(x) | isnan(y);
        x(BadGuys) = [];
        y(BadGuys) = [];
        dscatter(x',y')
        
        
        subplot(413)
        bin_oi = 4;
        spatbin_oi = 2;
        spatinfo_oi = 1;
        hold on
        plot(DecodedPos{bin_oi}{spatbin_oi}{spatinfo_oi},'k')
        act = ActualPos{bin_oi}{spatbin_oi}{spatinfo_oi};
        act(isnan(DecodedPos{bin_oi}{spatbin_oi}{spatinfo_oi})) = NaN;
        plot(act,'linewidth',2,'color','r')
        
        subplot(414)
        bin_oi = 3;
        spatbin_oi = 2;
        spatinfo_oi = 1;
        hold on
        plot(DecodedPos{bin_oi}{spatbin_oi}{spatinfo_oi},'k')
        act = ActualPos{bin_oi}{spatbin_oi}{spatinfo_oi};
        act(isnan(DecodedPos{bin_oi}{spatbin_oi}{spatinfo_oi})) = NaN;
        plot(act,'linewidth',2,'color','r')
%         saveas(fig.Number,['Bayesian_Results',Session_type{sess} '_Mouse',num2str(MiceNumber(mm)),'.png'])
    end
end
      