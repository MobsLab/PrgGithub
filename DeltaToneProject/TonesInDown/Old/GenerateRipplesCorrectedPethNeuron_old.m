%%GenerateRipplesCorrectedPethNeuron
% 13.09.2018 KJ
%
%
%   
%
% see
%   GenerateTonePethNeuron
%


clear

Dir = PathForExperimentsSleepRipplesSpikes('all');
Dir = CheckPathForExperiment_KJ(Dir);


for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p
    
    %params
    t_start = -5000;
    t_end   = 5000;
    binsize_peth = 50;
    binsize_cc = 5;
    nbins_cc = 200;

    
    %% load
    
    load('SpikeData.mat', 'S')
    % Substages
    load('SleepSubstages.mat', 'Epoch')
    N1 = Epoch{1}; N2 = Epoch{2}; N3 = Epoch{3}; REM = Epoch{4}; Wake = Epoch{5}; NREM = Epoch{7};
    N2N3 = or(N2,N3);
    % ripples
    load('Ripples.mat')
    tRipples = ts(Ripples(:,2)*10);
    
    %Down
    load('DownState.mat', 'down_PFCx')
    st_down = Start(down_PFCx);
    end_down = End(down_PFCx);
    %Up
    up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));
    
    
    %% Ripples corrected
    intwindow = 5000;
    aftDown = intervalSet(end_down, end_down+intwindow);    
    %ripples in and out down states
    tRipples = Restrict(tRipples, CleanUpEpoch(up_PFCx-aftDown));    
    
    
    %% Ripples
    tRipplesN23 = Restrict(tRipples, N2N3);

    
    %% Cross Corr
    MatCorr = [];
    for i=1:length(S)
        % PETH in Wake
        [C,B] = CrossCorr(Range(tRipplesN23), Range(S{i}),binsize_cc,nbins_cc);
        MatCorr = [MatCorr, C];
    end
    MatCorr = MatCorr';
    t_corr = B;
    
    %% save
    save RipplesCorrectedPeth.mat MatCorr t_corr
    
end



