% Load the data
clear all
FoldValidation = 5;
Opts.TempBinsize = 1;
PossibleBinNumbers = [5,10];
SaveFolder = '/media/DataMOBsRAIDN/PFC_InteroceptiveTuning/PhaseLocking';
Variables = {'HR','BR'};
Regions = {'PFC','HPC'};
Periods{1} = {'All','Wake','Habituation','Conditionning','Conditionning_NoFreeze','Habituation_NoFreeze','Sleep','Wake_Home','Freezing','Sound_Hab','EPM'};
Periods{2} = {'All','Wake','Habituation','Conditionning','Conditionning_NoFreeze','Habituation_NoFreeze','Sleep','Wake_Home','Freezing','Sound_Hab','EPM'};

for reg = 1:2
    for var = 1:length(Variables)
        if var <3 & reg ==2
            Periods{var}(end-1:end) = [];
        end
        Opts.BinNumber = PossibleBinNumbers(1);
        clear VarOfInterest spike_dat        
        for per = 1:length(Periods{var})
            disp(['Loading ' Periods{var}{per}])
            clear spikephase spikefreq
            switch Regions{reg}
                case 'PFC'
                    [spikephase,spikefreq] = PFC_DataSpikePhaseLocking(Variables{var},Periods{var}{per},Opts)
                case 'HPC'
                    [spikephase,spikefreq] = HPC_DataSpikePhaseLocking(Variables{var},Periods{var}{per},Opts)
            end
            save([SaveFolder filesep 'DataPhaseLocking_',Regions{reg},'_',Variables{var},'_',Periods{var}{per},'.mat'],'spikephase','spikefreq','-v7.3')
        end
    end
end
