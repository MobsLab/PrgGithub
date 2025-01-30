% edit Data_For_Decoding_Freezing_BM.m

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          CondPost - freezing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all

load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_all_CondPost_2sFullBins.mat','Mouse')
Session_type='CondPost';
[OutPutData.(Session_type) , Epoch1.(Session_type) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type),...
    'ob_low','heartrate','heartratevar','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_freq','hpc_theta_power','linearposition');

figure, [~ , ~ , Freq_Max_Shock] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type).ob_low.mean(:,5,:))); close
figure, [~ , ~ , Freq_Max_Safe] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type).ob_low.mean(:,6,:))); close

Params={'respi_freq_bm','heartrate','heartratevar','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_power'};

ind_mouse=1:length(Mouse);

DATA2.Shock(1,:) =Freq_Max_Shock(ind_mouse);
DATA2.Safe(1,:) = Freq_Max_Safe(ind_mouse);

for par=[2:7]
    DATA2.Shock(par,:) = OutPutData.(Session_type).(Params{par}).mean(ind_mouse,5)' 
    DATA2.Safe(par,:) = OutPutData.(Session_type).(Params{par}).mean(ind_mouse,6)';
end

save('/media/nas7/ProjetEmbReact/DataEmbReact/DataForSVM_AllStates_SB.mat','DATA2','Mouse')

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          Home cage : active, sleep, quiet wake
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Session_type={'sleep_pre'}; sess=1;
[OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),...
    'respi_freq_bm','heartrate','heartratevar','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_freq','hpc_theta_power');

GetAllSalineSessions_BM
load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_all_CondPost_2sFullBins.mat','Mouse')
clear Mouse_names
Params={'respi_freq_bm','heartrate','heartratevar','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_power'};
HabSess.M485{1} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse485/20161125/ProjectEmbReact_M485_20161125_Habituation';
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    
    Speed.(Session_type{sess}) = ConcatenateDataFromFolders_SB(HabSess.(Mouse_names{mouse}),'speed');
    Smooth_speed.(Session_type{sess}) = tsd(Range(Speed.(Session_type{sess})),runmean(Data(Speed.(Session_type{sess})),10));
    % Quiet wake
    Low_Speed_Epoch.(Session_type{sess}){mouse} = thresholdIntervals(Smooth_speed.(Session_type{sess}),1,'Direction','Below');
    Low_Speed_Epoch.(Session_type{sess}){mouse} = dropShortIntervals(Low_Speed_Epoch.(Session_type{sess}){mouse},3e4);
    Low_Speed_Epoch.(Session_type{sess}){mouse} = mergeCloseIntervals(Low_Speed_Epoch.(Session_type{sess}){mouse},0.5e4);
    
    
    % Active period
    High_Speed_Epoch.(Session_type{sess}){mouse} = thresholdIntervals(Smooth_speed.(Session_type{sess}),5,'Direction','Above');
    High_Speed_Epoch.(Session_type{sess}){mouse} = dropShortIntervals(High_Speed_Epoch.(Session_type{sess}){mouse},3e4);
    High_Speed_Epoch.(Session_type{sess}){mouse} = mergeCloseIntervals(High_Speed_Epoch.(Session_type{sess}){mouse},0.5e4);

    
    for par=1:7
        MeanData_QW.(Session_type{sess}).(Params{par})(mouse) = nanmean(Data(Restrict(OutPutData.(Session_type{sess}).(Params{par}).tsd{mouse,1} , Low_Speed_Epoch.(Session_type{sess}){mouse})));
        MeanData_Act.(Session_type{sess}).(Params{par})(mouse) = nanmean(Data(Restrict(OutPutData.(Session_type{sess}).(Params{par}).tsd{mouse,1} , High_Speed_Epoch.(Session_type{sess}){mouse})));
        MeanData_Sleep.(Session_type{sess}).(Params{par})(mouse) = nanmean(Data(Restrict(OutPutData.(Session_type{sess}).(Params{par}).tsd{mouse,1} , Epoch1.(Session_type{sess}){mouse,3})));
        
    end
    disp(Mouse_names{mouse})
end

for par=1:7
    DATA2.QuietWake(par,:) = MeanData_QW.sleep_pre.(Params{par});
    DATA2.ActiveWake(par,:) = MeanData_Act.sleep_pre.(Params{par});
    DATA2.Sleep(par,:) = MeanData_Sleep.sleep_pre.(Params{par});
end
save('/media/nas7/ProjetEmbReact/DataEmbReact/DataForSVM_AllStates_SB.mat','DATA2','Mouse')




%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          Habituation : active, quiet wake
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%