Response = inputdlg({'Mouse Number','SessionName','Stim Type (PAG,Eyeshock,MFB)','ExperimentDay','StimInt','VirusInjected',...
    'OptoStimulation','MouseStrain'},'Inputs for Mouse',1);
% Mouse and date info
ExpeInfo.nmouse=eval(Response{1});
ExpeInfo.SessionName=(Response{2});
ExpeInfo.StimElecs=Response{3}; % PAG or MFB or Eyeshock or OpticFiber
ExpeInfo.Date=eval(Response{4});
ExpeInfo.StimulationInt=Response{5};
ExpeInfo.VirusInjected=Response{6};
ExpeInfo.OptoStimulation=Response{7};
ExpeInfo.MouseStrain=Response{8};

save('ExpeInfo.mat','ExpeInfo');

