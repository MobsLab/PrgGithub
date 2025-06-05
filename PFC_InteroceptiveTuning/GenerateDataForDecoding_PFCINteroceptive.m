% Load the data
clear all
FoldValidation = 5;
Opts.TempBinsize = 1;
PossibleBinNumbers = [5,10];
SaveFolder = '/media/DataMOBsRAIDN/PFC_InteroceptiveTuning/DecodingAnalysis';
Variables = {'HR','BR','speed','position'};
Regions = {'PFC','HPC'};
Periods{1} = {'Habituation','Conditionning','Conditionning_NoFreeze','Habituation_NoFreeze','Sleep','Wake_Home','Freezing','Sound_Hab','EPM'};
Periods{2} = {'Habituation','Conditionning','Conditionning_NoFreeze','Habituation_NoFreeze','Sleep','Wake_Home','Freezing','Sound_Hab','EPM'};
Periods{3} = {'Habituation','Conditionning','Conditionning_NoFreeze','Habituation_NoFreeze','Freezing'};
Periods{4} = {'Habituation','Conditionning','Conditionning_NoFreeze','Habituation_NoFreeze','Freezing'};

for reg = 1:2
    for var = 1:length(Variables)
        if var <3 & reg ==2
            Periods{var}(end-1:end) = [];
        end
        Opts.BinNumber = PossibleBinNumbers(1);
        clear VarOfInterest spike_dat
        for per = 1:length(Periods{var})
            disp(['Loading ' Periods{var}{per}])
            switch Regions{reg}
                case 'PFC'
                    [VarOfInterest.(Periods{var}{per}),spike_dat.(Periods{var}{per}),Opts] = PFC_DataSpikesAndParameter_ByState(Variables{var}, (Periods{var}{per}),Opts);
                case 'HPC'
                    [VarOfInterest.(Periods{var}{per}),spike_dat.(Periods{var}{per}),Opts] = HPC_DataSpikesAndParameter_ByState(Variables{var}, (Periods{var}{per}),Opts);
            end
        end
    
    
    save([SaveFolder filesep 'DataDecoding_',Regions{reg},'_',Variables{var},'.mat'],'VarOfInterest','spike_dat','Opts','-v7.3')
    end
end

