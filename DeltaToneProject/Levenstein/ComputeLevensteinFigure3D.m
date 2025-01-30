%ComputeLevensteinFigure3D
%30.01.2018 KJ  
%
%
% see
%   Figure3D
%

clear

%%WCadapt_DwellStats
dropboxroot = '/Users/dlevenstein/Dropbox/Research/';
%dropboxroot = '/mnt/data1/Dropbox/research/';
figfolder = fullfile(FolderFigureDelta,'Levenstein');%fullfile(dropboxroot,'Current Projects/SlowOscillation/Modeling/Figures');
simdatafolder =  fullfile(FolderDeltaDataKJ,'Levenstein_model'); %fullfile(dropboxroot,'Current Projects/SlowOscillation/AnalysisScripts/simdata/');
rmpath(fullfile(FolderDropBox,'Dropbox/Kteam/PrgMatlab/chronux2/spectral_analysis/continuous'))



%% I-W space

simdatafilename = 'dwellmatch6.mat';
simdatafullfile = fullfile(simdatafolder,simdatafilename);

resim=false;
if ~exist(simdatafullfile,'file') || resim
  % UP/DOWN Duration Map
    numI = 20;
    numW = 20;
    testI = linspace(-3.3,-1,numI);
    testbw = linspace(3.5,7.5,numW);
    testI = repmat(testI,numW,1);testI = testI(:);
    testbw = repmat(testbw,1,numI);testbw = testbw(:);
    numsims = length(testI);

    for nn = 1:numsims
        modelparms(nn).N_neurons = 1;
        modelparms(nn).I_in = testI(nn);
        modelparms(nn).W = testbw(nn);
        modelparms(nn).beta = 1;
        modelparms(nn).tau_r = 1;
        modelparms(nn).tau_a = 25;
        modelparms(nn).A0 = 0.5;
        modelparms(nn).Ak = 15;
        modelparms(nn).noiseamp =0.25;
        modelparms(nn).noisefreq = 0.05;
    end

    simparms.simtime = 60000;
    simparms.dt = 1;

    [ dwelltimes_sim,ratehist ] = BatchSimulate_WCadapt( modelparms,simparms );
    save(simdatafullfile,'dwelltimes_sim','ratehist','modelparms','simparms');
else 
    load(simdatafullfile);
end


%% I-B space

simdatafilename = 'dwellmatch_IB2.mat';
simdatafullfile = fullfile(simdatafolder,simdatafilename);

resim=false;
if ~exist(simdatafullfile,'file') || resim
  % UP/DOWN Duration Map
    numI = 50;
    numB = 50;
    testI = linspace(-5,0,numI);
    testb = linspace(0,3.5,numB);
    testI = repmat(testI,numB,1);testI = testI(:);
    testb = repmat(testb,1,numI);testb = testb(:);
    numsims = length(testI);

    for nn = 1:numsims
        modelparms(nn).N_neurons = 1;
        modelparms(nn).I_in = testI(nn);
        modelparms(nn).W = 6;
        modelparms(nn).beta = testb(nn);
        modelparms(nn).tau_r = 1;
        modelparms(nn).tau_a = 25;
        modelparms(nn).A0 = 0.5;
        modelparms(nn).Ak = 15;
        modelparms(nn).noiseamp =0.25;
        modelparms(nn).noisefreq = 0.05;
    end

    simparms.simtime = 60000;
    simparms.dt = 1;

    [ dwelltimes_sim,ratehist ] = BatchSimulate_WCadapt( modelparms,simparms );
    save(simdatafullfile,'dwelltimes_sim','ratehist','modelparms','simparms');
else 
    load(simdatafullfile);
end


%% I-W space: b=0

simdatafilename = 'dwellmatch_IWb0.mat';
simdatafullfile = fullfile(simdatafolder,simdatafilename);

resim=false;
if ~exist(simdatafullfile,'file') || resim
  % UP/DOWN Duration Map
    numI = 10;
    numW = 10;
    testI = linspace(-4,-1,numI);
    testw = linspace(3.5,7.5,numW);
    testI = repmat(testI,numW,1);testI = testI(:);
    testw = repmat(testw,1,numI);testw = testw(:);
    numsims = length(testI);

    for nn = 1:numsims
        modelparms(nn).N_neurons = 1;
        modelparms(nn).I_in = testI(nn);
        modelparms(nn).W = testw(nn);
        modelparms(nn).beta = 0;
        modelparms(nn).tau_r = 1;
        modelparms(nn).tau_a = 20;
        modelparms(nn).A0 = 0.5;
        modelparms(nn).Ak = 15;
        modelparms(nn).noiseamp =0.8;
        modelparms(nn).noisefreq = 0.05;
    end

    simparms.simtime = 30000;
    simparms.dt = 1;

    [ dwelltimes_sim,ratehist ] = BatchSimulate_WCadapt( modelparms,simparms );
    save(simdatafullfile,'dwelltimes_sim','ratehist','modelparms','simparms');
else 
    load(simdatafullfile);
end


%% Rescaled
simdatafilename = 'dwellmatch_rescale2.mat';
simdatafullfile = fullfile(simdatafolder,simdatafilename);

resim=false;
if ~exist(simdatafullfile,'file') || resim
  % UP/DOWN Duration Map
    numI = 50;
    numbw = 50;
    testI_rs = linspace(-1,1,numI);
    testbw = linspace(0,6,numbw);
    testI_rs = repmat(testI_rs,numbw,1);testI_rs = testI_rs(:);
    testbw = repmat(testbw,1,numI);testbw = testbw(:);
    numsims = length(testI_rs);
    
    %Resale parameters to "raw" WC model
    w_rs = 2;
    k = 15;
    tau = 20;
    I0 = 0;
    testb_rs = testbw.*w_rs;
    [ testI,w,testb ] = WCadapt_RescaleParms( testI_rs,w_rs,testb_rs,k,I0,tau );

    for nn = 1:numsims
        modelparms(nn).N_neurons = 1;
        modelparms(nn).I_in = testI(nn);
        modelparms(nn).I_rs = testI_rs(nn);
        modelparms(nn).W = w;
        modelparms(nn).W_rs = w_rs;
        modelparms(nn).beta = testb(nn);
        modelparms(nn).b_rs = testb_rs(nn);
        modelparms(nn).tau_r = 1;
        modelparms(nn).tau_a = 20;
        modelparms(nn).A0 = 0.5;
        modelparms(nn).Ak = 15;
        modelparms(nn).noiseamp =0.8;
        modelparms(nn).noisefreq = 0.05;
    end

    simparms.simtime = 50000;
    simparms.dt = 1;

    [ dwelltimes_sim,ratehist ] = BatchSimulate_WCadapt( modelparms,simparms );
    save(simdatafullfile,'dwelltimes_sim','ratehist','modelparms','simparms');
else 
    load(simdatafullfile);
end




