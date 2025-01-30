
function [OsciEpoch,WholeEpoch,SWAEpoch,BurstEpoch,spindles,sdTH,ISI_th]=FindOsciEpochs(LFP,SWS,sdTH,ISI_th)

% [OsciEpoch,WholeEpoch,SWAEpoch,BurstEpoch,spindles,sdTH,ISI_th]=FindOsciEpochs(LFP,SWS,sdTH,ISI_th)
%
% e.g. OsciEpoch=FindOsciEpochs(53,SWSEpoch);
%
% inputs:
% LFP = tsd with electrophy data
% SWS = epoch of analysis, usually SWSEpoch
% sdTH (option) = standard deviation threshold for detection of oscillations
% ISI_th (option) = Inter Spike Interval threshold for oscillation burst detection
%
% subfunctions (see below):
% FindExtremPeaksML.m
% ObsExtremPeaksML.m
% FindSpindlesML.m

%% INITIATION


%standard deviation threshold for detection of oscillations
if ~exist('sdTH','var')
    sdTH=2;
end

if ~exist('ISI_th','var')
    ISI_th=1; % in seconds
end


%% Find oscillations
% disp('        FindExtremPeaksML')
[tpeaks]=FindExtremPeaksML(LFP,sdTH,dropShortIntervals(SWS,1.5E4)); %SB output = tsd with time of all peaks and all troughs after filtering in all freq bands

% disp('        ObsExtremPeaksML')
[h,BurstEpoch]=ObsExtremPeaksML(tpeaks,ISI_th); %SB BurstEpoch is all the epochs with at least 3 peaks in freq between 2-20Hz that are closer than 1s

% disp('        FindSpindlesML')
[spindles,SWA]=FindSpindlesML(LFP,[2 20],SWS,'off');
SWAEpoch=intervalSet(SWA(:,1)*1E4,SWA(:,2)*1E4);


%% OUTPUT EPOCHS DEFINITION
OsciEpoch=or(SWAEpoch,BurstEpoch);
rg=Range(LFP);
WholeEpoch=intervalSet(rg(1),rg(end));

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<< FindExtremPeaksML <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    function [tpeaks,t_waveP,t_waveT,brst]=FindExtremPeaksML(lfp,thD,Epoch)
        % inputs
        % lfp = tsd electrophy signal
        % thD = threshold for std detection
        % Epoch = restricted epoch
        
        rg=Range(lfp);
        lfp=ResampleTSD(lfp,250);
        
        % INITIATION
        if ~exist('Epoch','var')
            Epoch=intervalSet(rg(1),rg(end));
        end
        Epoch=CleanUpEpoch(Epoch);
        
        % filter for 2Hz freq step [2-20Hz], for each epoch of Epoch
%         disp('Calculating variance...');
        for j=1:10
            Filt_EEGd = [];
            for i=1:length(Start(Epoch))
                lfpr=Restrict(lfp,subset(Epoch,i));
                % concatenate filtered signal
                try
                    Filt_EEGd = [Filt_EEGd ; Data(FilterLFP(lfpr, [2*j 2*(j+1)], 512))];
                end
            end
            % std for each freq band
            std_freq(j)=std((Filt_EEGd));
        end
        
        h = waitbar(0,'Please wait...');
        t_T=[]; t_P=[];
        for i=1:length(Start(Epoch))
            
            lfpr=Restrict(lfp,subset(Epoch,i));
            waitbar(i/length(Start(Epoch)),h)
            if ~isempty(Range(lfpr))
                for j=1:10
                    try
                        Filt_EEGd = FilterLFP(lfpr, [2*j 2*(j+1)], 256);
                    catch
                        try
                            Filt_EEGd = FilterLFP(lfpr, [2*j 2*(j+1)], 128);
                        catch
                            try
                                Filt_EEGd = FilterLFP(lfpr, [2*j 2*(j+1)], 64);
                            catch
                                Filt_EEGd = FilterLFP(lfpr, [2*j 2*(j+1)], 32);
                            end
                        end
                    end
                    
                    eegd=Data(Filt_EEGd)';
                    td=Range(Filt_EEGd,'s')';
                    
                    de = diff(eegd);
                    de1 = [de 0];
                    de2 = [0 de];
                    
                    %finding peaks
                    upPeaksIdx = find(de1 < 0 & de2 > 0);
                    downPeaksIdx = find(de1 > 0 & de2 < 0);
                    
                    PeaksIdx = [upPeaksIdx downPeaksIdx];
                    PeaksIdx = sort(PeaksIdx);
                    Peaks = eegd(PeaksIdx);
                    %   Peaks = abs(Peaks);
                    
                    t_peaks=td(PeaksIdx);
                    % relative thresshold
                    DetectThresholdP=+mean(Data(Filt_EEGd))+thD*std_freq(j)*log(j+2);
                    DetectThresholdT=-mean(Data(Filt_EEGd))-thD*std_freq(j)*log(j+2);
                    
                    % find peaks above/below std*thD
                    t_peaksT=t_peaks(find(Peaks<DetectThresholdT));
                    t_peaksP=t_peaks(find(Peaks>DetectThresholdP));
                    
                    % t_T and t_P contain the times in the first column and
                    % the corresponding frequency band in the second of
                    % peaks and troughs detected after filtering in that
                    % band
                    try
                        t_T=[t_T;[t_peaksT',(2*j+1)*ones(length(t_peaksT),1)]];
                        t_P=[t_P;[t_peaksP',(2*j+1)*ones(length(t_peaksP),1)]];
                    catch
                        disp('line 303 t_T/t_P');keyboard
                        t_T=zeros(size(t_peaksT',1),size(t_peaksT',2));
                        t_T(:,1)=[t_peaksT'];
                        t_T(:,2)=[2*(j+1)*ones(length(t_peaksT),1)];
                        
                        t_P=zeros(size(t_peaksP',1),size(t_peaksP',2));
                        t_P(:,1)=[t_peaksP'];
                        t_P(:,2)=[2*(j+1)*ones(length(t_peaksP),1)];
                    end
                end
            end
        end
        close (h)
        
        % TERMINATION
        [BE,idx]=sort(t_T(:,1)); % sort by timestamp
        tdeltaT=[t_T(idx,1)*1E4 t_T(idx,2)]; % right time step
        t_waveT=tdeltaT(find(tdeltaT(:,1)+1E4<rg(end)&tdeltaT(:,1)-1E4>0),:); % only keep events that are more than one second from beginning and end of session
        t_waveT=tsd(t_waveT(:,1),t_waveT(:,2)); % make a tsd
        
        [BE,idx]=sort(t_P(:,1));
        tdeltaP=[t_P(idx,1)*1E4 t_P(idx,2)];
        t_waveP=tdeltaP(find(tdeltaP(:,1)+1E4<rg(end)&tdeltaP(:,1)-1E4>0),:);
        t_waveP=tsd(t_waveP(:,1),t_waveP(:,2));
        
        [tps,id]=sort([Range(t_waveP);Range(t_waveT)]); % put the troughs and peaks into one matrix
        Mat=[Data(t_waveP);Data(t_waveT)];
        
        % burstinfo_2.m
        tpeaks=tsd(tps,Mat(id,:)); % tsd with time of all peaks and all troughs
        brst = burstinfo_2(Range(tpeaks,'s'), 5,Inf,3); % 5 = minimum interval between evts, 3 = min number of events
    end


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<< ObsExtremPeaksML <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    function [Distrib,BurstEpoch,brst]=ObsExtremPeaksML(t1,ISI_th)
        
        brst = burstinfo(Range(t1,'s'), ISI_th); % at least three events with less than 1s between
        BurstEpoch=intervalSet(brst.t_start*1E4,brst.t_end*1E4);
        
        Distrib=zeros(length(Start(BurstEpoch)),length([1:2:23]));
        for i=1:length(Start(BurstEpoch))
            Distrib(i,:)=hist(Data(Restrict(t1,subset(BurstEpoch,i))),[1:2:23]);
        end
    end


%%
%% <<<<<<<<<<<<<<<<<<<<<<<< FindSpindlesML <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

    function [Spi,SWA,stdev]=FindSpindlesML(LFP,freq,Epoch,showingORnot)
        % each row in Spi corresponds to a detecter spidles:
        % Spi(i,1:3)=[tStartSpindles, tPeakSpindles, tEndSpindles]
        
        % INITIATION
        LFP=ResampleTSD(LFP,1250);
        if freq==[2 20]
            thfreq=[1.5 4];
        else
            thfreq=[3 5];
        end
        
        if ~exist('showingORnot','var')
            showingORnot='off';
        end
        
        if ~exist('Epoch','var')
            rg=Range(LFP);
            Epoch=intervalSet(rg(1),rg(end));
        end
        
        if sum(End(Epoch,'s')-Start(Epoch,'s'))>12000
            Epoch2=subset(Epoch,1:floor(length(Start(Epoch))/3));
        else
            Epoch2=Epoch;
        end
        
        % -----------------------------------------------------------------
        % params
        signal = Data(Restrict(FilterLFP(LFP,freq,512),Epoch2));
        frequency=round(1/median(diff(Range(LFP,'s'))));
        windowLength = round(frequency/1250*11);
        squaredSignal = signal.^2;
        window = ones(windowLength,1)/windowLength;
        
        [~, sd] = unity(Filter0(window,sum(squaredSignal,2)),[],[]);
        
        % -----------------------------------------------------------------
        vari=sd*2/3;
        SWA=[];
        Spi=[];
        for i=1:length(Start(Epoch))
            
            try
                Fil=FilterLFP(Restrict(LFP,subset(Epoch,i)),freq,512);
                rgFil=Range(Fil,'s');
                filtered=[rgFil-rgFil(1) Data(Fil)];
%                 disp([' ']); disp(['Epoch ',num2str(i)])
                
                % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                [spindles,swa,stdev] = FindspindlesMarie(filtered,'durations',[100 350 200000],...
                    'stdev',vari,'thresholds',thfreq,'show',showingORnot);
                %ripples=[start_t peak_t end_t peakNormalizedPower]
                % swa = [t_starts, t_ends] of ripples epoch
                % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                
                spindles(:,1:3)=spindles(:,1:3)+rgFil(1);
                Spi=[Spi;spindles];
                swa=swa+rgFil(1);
                SWA=[SWA;swa];
            end
        end
        
        % refilter
        if length(Spi)<10
            Spi=[];SWA=[];
            for i=1:length(Start(Epoch))
                try
                    Fil=FilterLFP(Restrict(LFP,subset(Epoch,i)),freq,1024);
                    rgFil=Range(Fil,'s');
                    filtered=[rgFil-rgFil(1) Data(Fil)];
                    
                    % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                    [spindles,swa, stdev,] = FindspindlesMarie(filtered,'durations',[100 350 200000],...
                        'thresholds',thfreq,'show',showingORnot);
                    % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                    
                    spindles(:,1:3)=spindles(:,1:3)+rgFil(1);
                    Spi=[Spi;spindles];
                    swa=swa+rgFil(1);
                    SWA=[SWA;swa];
                end
            end
        end
        
        
        % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        % function Filter0
        function y = Filter0(b,x)
            if size(x,1) == 1
                x = x(:);
            end
            if mod(length(b),2)~=1
                error('filter order should be odd');
            end
            shift = (length(b)-1)/2;
            [y0, z] = filter(b,1,x);
            y = [y0(shift+1:end,:) ; z(1:shift,:)];
        end
        
        % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        % function unity
        function [U,stdA] = unity(A,sd,restrict)
            if ~isempty(restrict)
                meanA = mean(A(restrict));
                stdA = std(A(restrict));
            else
                meanA = mean(A);
                stdA = std(A);
            end
            if ~isempty(sd)
                stdA = sd;
            end
            U = (A - meanA)/stdA;
        end
        
    end



end

