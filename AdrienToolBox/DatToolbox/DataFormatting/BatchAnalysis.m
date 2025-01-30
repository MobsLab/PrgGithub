
% To create datasets.list: "ls M* -d > datasets.list" if all directories
% begin with M*

datasets = List2Cell('datasets_Mouse12.list');

%RunAnalysis('MakeSpikeData_FromRes',datasets,0,'(1:8)')
RunAnalysis('FindHDCells',datasets,0)
%RunAnalysis('ThetaPhase',datasets,0,'65')
RunAnalysis('FindSpindles_Thalamus',datasets,0)


