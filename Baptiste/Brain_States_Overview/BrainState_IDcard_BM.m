
Cols = {[1 0.5 0.5],[0.5 0.5 1]};
X = [1,2];
Legends = {'Shock','Safe'};

cd('/media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_TestPre_PreDrug/TestPre2')
load('H_Low_Spectrum.mat'); RangeLow=Spectro{3};
load('B_Middle_Spectrum.mat'); RangeMiddle=Spectro{3};
load('B_High_Spectrum.mat'); RangeHigh=Spectro{3};
load('H_VHigh_Spectrum.mat'); RangeVHigh=Spectro{3};
Session_type={'Cond','Ext'};

%% Electrophy figure
Mouse=[688 739 777 779 849 893 1170,1189,1251,1253,1254];
for sess=1:length(Session_type) % generate all data required for analyses
    [OutPutData.(Session_type{sess}) , Epoch.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('drugs',Mouse,lower(Session_type{sess}),'ob_low','ob_middle','hpc_low','h_vhigh','pfc_low','ripples','ob_high_on_respi_phase_pref','respi_meanwaveform','ob_pfc_coherence');
end

PlotBrainState_IDcard_BM


%% Somatic figure
Mouse=[688 739 777 779 849 893 1170,1189,1251,1253,1254];
for sess=1:length(Session_type) % generate all data required for analyses
    [OutPutData.(Session_type{sess}) , Epoch.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('drugs',Mouse,lower(Session_type{sess}),'heartrate','heartratevar','respi_freq_bm','respivar','tailtemperature','masktemperature','emg','accelero');
end

PlotBodyState_IDcard_BM


%% Behaviour figure
% explosive escape
% risk assessment
% exploration pre/post
% escape latency
% distance to door
% speed/accelero
% freezing proportion

Mouse=[666 668 688 739 777 779 849 893];
[OutPutData , Epoch , NameEpoch , OutPutTSD] = MeanValuesPhysiologicalParameters_BM(Mouse,'fear','accelero','speed');


%% Baseline sleep
Mouse=[739 740 750 775 849 829 851 856 857];
[OutPutData.BaselineSleep , Epoch.BaselineSleep , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,'slbs','ob_low','ob_middle','hpc_low','h_vhigh','pfc_low','phase_pref','respi_meanwaveform','ob_pfc_coherence','sleep_ripples');
[OutPutData.BaselineSleep , Epoch.BaselineSleep , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,'slbs','heartrate','heartratevar','respi_freq_bm','respivar','tailtemperature','masktemperature','emg','accelero');

PlotBrainState_BaselineSleep_BM
PlotBrainState_NREMSleep_BM
PlotBodyState_BaselineSleep_BM

%% Head-restrained
Mouse=[1189 1227];
[OutPutData , Epoch , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,'head_restraint','ob_low','ob_middle','hpc_low','h_vhigh','sleep_ripples','phase_pref','respi_meanwaveform','pfc_low','ob_pfc_coherence');
[OutPutData , Epoch , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,'head_restraint','heartrate','heartratevar','respi_freq_bm','respivar','tailtemperature','masktemperature','emg','accelero');

PlotBrainState_HeadRestraint_BM

[OutPutData3 , Epoch , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,'head_restraint','sleep_ripples');





