eidt %%MakeNeuronInfoData_DB
% 20-26.06.2018 DB
% Adapted from the same-name code of KJ
%
% see
%   MakeNeuronInfoData_KJ
%

clear

% Folders with data
Dir.path = '/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/AllSpikes';
% Dir = PathForExperimentsERC_Dima('AllSpikes');

for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p
    
    
    %% load data
    load('SpikeData.mat', 'S');
    load ('behavResources.mat');
    
    clear number Epoch NameEpoch
    
    % Get indexes of MUA and SUA
    for i = 1:length(TT)
        if TT{i}(2) == 1
            idx_MUA(i) = i;
        else
            idx_SUA(i) = i;
        end
    end
    idx_MUA(idx_MUA==0) = [];
    idx_SUA(idx_SUA==0) = [];
    
    %% Get info
    
    %Firing rate
    firingrates = GetFiringRate(S);
    
    %% TO ADD
    
    % Spatial info
    map = cell(1,length(S));
    mapS = cell(1,length(S));
    stats = cell(1,length(S));
    for i=1:length(S)
        [map{i},mapS{i},stats{i}] = PlaceField(S{i}, Xtsd, Ytsd, 'smoothing', 2, 'size', 75, 'plotresults', 0);
    end
    
    spatialinfo = zeros(1,length(S));
    for i=1:length(S)
        spatialinfo(i) = stats{i}.spatialInfo;
    end
    
   % Theta modulation
    dHPC_rip = load(['LFPData/LFP' ExpeInfo.Ripples '.mat']);
    LFP_theta = FilterLFP(dHPC_rip.LFP, [6 12], 2048); % Bandwidth - 6-12 Hz
    t = Range(dHPC_rip.LFP);
    TotalEpoch = intervalSet(t(1),t(end));
    
    ph = cell(1,length(S));
    mu = zeros(1,length(S));
    Kappa = zeros(1,length(S));
    pval = zeros(1,length(S));
    B = cell(1,length(S));
    C = cell(1,length(S));
    
    for i=1:length(S)
        [ph{i},mu(i), Kappa(i), pval(i), B{i},C{i}]=ModulationTheta(S{i},LFP_theta,TotalEpoch,60,0);
    end
    
    % Average response to ripples!!!!!!!!!!!!!!!!
    [ripples,stdev] = FindRipples_DB (dHPC_rip, nonrip, [2 5]);
    % Write a function of resrticting and seeing how much neuron is firing


    %%
    %% Plot histogram of spatial information across all PCs
spatialinfo_SUA = spatialinfo(idx_SUA);
idx_Pyr_all = find(UnitID_SUA(:,1)>0);
spinfo_id = figure;
histogram(spatialinfo_SUA(idx_Pyr), 10, 'FaceColor', [0 0.4 0.4]);
xlim([0 3]);
title('Distribution of spatial infomation for all PCs');

%% Plot distribution of kappa (concentration factor)
Kappa_SUA = Kappa(idx_SUA);
kappaid= figure;
histogram(Kappa_SUA, 25, 'FaceColor', [0 0.4 0.4]);
title ('Concentration factor across all SUA neurons');

%% Plot distribution of mean phase of all SUA
mu_SUA = mu(idx_SUA);
muid = figure;
histogram(mu_SUA, 25, 'FaceColor', [0 0.4 0.4]);
title('Distribution of mean theta phases of all SUA');
    
    
    
    %% save
    MatInfoNeurons = nan(length(NumNeurons), 6);
    
    MatInfoNeurons(:,1) = NumNeurons';
    MatInfoNeurons(:,2) = firingrates;
    MatInfoNeurons(:,3) = neuron_type;
    
    
    InfoNeurons.structure   = 'dHPC';
    InfoNeurons.NumNeurons  = NumNeurons;
    InfoNeurons.firingrate  = firingrates;
    InfoNeurons.putative    = neuron_type;

    save('InfoNeuronsERC', 'MatInfoNeurons', 'InfoNeurons')
    
end





