% PulseOxiVsEegAmplitude
% 28.03.2018 KJ
%
% Infos
%    
%
% SEE 
%    
%

clear
Dir = ListOfDreemRecordsStimImpact('all');

for p=1:length(Dir.filereference)
    
    clearvars -except Dir p

    NameStages = {'N1','N2','N3','REM','Wake'};
    name_channels = {'Fpz-O1', 'Fpz-O2', 'Fpz-F7', 'F8-F7', 'F7-O1', 'F8-O2'};


    %% load data
    [signals, ~, stimulations, StageEpochs, labels_eeg, pulse_oximeter] = GetRecordDreem(Dir.filename{p});
    [channel_quality, NoiseEpoch, TotalNoise] = GetDreemQuality(Dir.filereference{p});


    %% restrict to Sleep stage with good signals
    for ch=1:length(channel_quality)
        for st=1:5
            HypnoChannel{ch,st} = dropShortIntervals(StageEpochs{st} - NoiseEpoch{ch},20e4);

        end
    end



    %% compute    
    for ch=1:length(channel_quality)
        for st=1:5
            Epoch = HypnoChannel{ch,st};

            func_std = @(a) measureOnSignal(a,'std');
            [eeg_amplitude{ch,st}, ~, ~] = functionOnEpochs(signals{ch}, Epoch, func_std);
            [pulseoxy_amplitude{ch,st}, ~, ~] = functionOnEpochs(pulse_oximeter, Epoch, func_std);

        end
    end


    %% Plot

    figure, hold on
    for ch=1:length(channel_quality)
        for st=1:4

            k = 4*(st-1) + ch;
            subplot(4,4,k), hold on
            x = pulseoxy_amplitude{ch,st};
            y = eeg_amplitude{ch,st};

    %         [r,p] = corrcoef(x,y)

            scatter(x, y, 25,'filled'), hold on
            ylim([0 60]),  
            xlim([0 130]), 

            if st==1
                title(name_channels{ch})
            elseif st==4
                xlabel('pulse oximeter amplitude (std)')
            end
            if ch==1
                ylabel(['EEG amplitude (std) in ' NameStages{st}])
            end
        end


    end
    suplabel([Dir.subject{p} ' - ' Dir.condition{p} ' - '  num2str(Dir.filereference{p})],'t');

end


