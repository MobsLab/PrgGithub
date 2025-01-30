% NDM_shit_DB
function NDM_DB(Dir, indir, indir_beh)

%% Parameters
cd(Dir);
prefix = 'ERC-';  % Experiment prefix
postfix.amp = '-wideband.dat'; % Eletrophys data
postfix.acc = '-accelero.dat'; % Accelerometer data
postfix.din = '-digin.dat'; % Digital input data

%% Generate ExpeInfo

%check if ExpeInfo already exists 
try
    load('ExpeInfo.mat')
    disp('ExpeInfo already exists');
catch
    disp('you are gonna be asked about the experiment...');
    
    load('LFPData/InfoLFP.mat');
    % Info about the experiment
    Response = inputdlg({'Mouse Number','Stim Type (PAG,Eyeshock,MFB)','Date', 'Phase',...
    'Ripples','DeltaPF [sup (delta down) deep (delta up)]','SpindlePF', 'StimInt', 'StimDur'},'Inputs for ERC experiment',1);
    % Mouse and date info
    ExpeInfo.nmouse=eval(Response{1});
    ExpeInfo.date=eval(Response{3});
    ExpeInfo.phase=eval(Response{4});
    ExpeInfo.StimInt=eval(Response{8});
    ExpeInfo.StimDur=eval(Response{9});

    % Ephys info
    ExpeInfo.StimElecs=Response{2}; % PAG or MFB or Eyeshock
    ExpeInfo.Ripples=eval(Response{5}); % give channel
    ExpeInfo.DeltaPF=eval(Response{6}); % give sup (delta down) the deep (delta up)
    ExpeInfo.SpindlePF=eval(Response{7}); % give channel

    % Implantation info
    ExpeInfo.RecordElecs=InfoLFP;


    % Mouse characteristics
    ExpeInfo.VirusInjected={};
    ExpeInfo.OptoStimulation=0;
    ExpeInfo.MouseStrain='C57Bl6jRj';
end

save('ExpeInfo.mat', 'ExpeInfo');

%% Move files
flnme = [prefix 'Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-' ExpeInfo.phase];

load('makedataBulbeInputs.mat');

% Move file with behavioral data
if exist([Dir 'behavResources.mat'])==2
    disp('behavResources.mat copied already');
else
    copyfile([Dir indir_beh 'behavResources.mat'], Dir);
end

% Move and rename file with electrophys data
if exist([Dir 'amplifier.dat'])==2
    disp('amplifier.dat copied already');
else
    copyfile([Dir indir 'amplifier.dat'], Dir);
    movefile([Dir 'amplifier.dat'], [prefix 'Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-' ExpeInfo.phase postfix.amp]);
end

% Move and rename file with accelerometer data
if doaccelero == 1
    if exist([Dir 'auxiliary.dat'])==2
        disp('auxiliary.dat copied already');
    else
        copyfile([Dir indir 'auxiliary.dat'], Dir);
        movefile([Dir 'auxiliary.dat'], [prefix 'Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-' ExpeInfo.phase postfix.acc]);
    end
end

% Move and rename file with digital input
if dodigitalin == 1
    if exist([Dir 'digitalin.dat'])==2
        disp('digitalin.dat copied already');
    else
        copyfile([Dir indir 'digitalin.dat'], Dir);
        movefile([Dir 'digitalin.dat'], [prefix 'Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-' ExpeInfo.phase postfix.din]);
    end
end

% Create folder raw ans move your files there
mkdir ('raw');
movefile ([Dir indir], [Dir 'raw']);
movefile ([Dir indir_beh], [Dir 'raw']);

%% Do ndm shit

% Merge files (usually 36 channels: 32Elec+3Acc+1Digin)
system(['ndm_mergedat ' flnme '.xml']);

% Re-reference files (create 2 references: local for spikes and global for everything else)
Ref_ERC_DB

% Create LFP file
system(['ndm_lfp ' flnme '.xml']);

if spk == 1
    
    % Create spikes file
%     system(['ndm_hipass ' flnme '_SpikeRef.xml']);
%     system(['ndm_extractspikes ' flnme '_SpikeRef.xml']);
%     system(['ndm_pca ' flnme '_SpikeRef.xml']);

 system(['ndm_hipass ' flnme '.xml']);
    system(['ndm_extractspikes ' flnme '.xml']);
    system(['ndm_pca ' flnme '.xml']);
end

%% End
disp('LFPs are ready! Go to KlustaKwik and spike-sort, mate')

end