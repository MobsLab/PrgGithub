function makePosterFigures()

doThetaExample1 = true;
doThetaExample2 = true;
doThetaVel = false;
hm = getenv('HOME');
parent_dir = [ hm '/Data/LPPA'];
A = Analysis(parent_dir);
datasets = List2Cell([ parent_dir filesep 'datasets_pos.list' ] );


global FIGURE_DIR ;
FIGURE_DIR = '/home/fpbatta/Data/LPPA/poster_figures';
global N_FIGURE
N_FIGURE = 1;



fig_st = {};


if doThetaExample1
    fig = [];


    load([parent_dir filesep 'Rat12/0407/0407eeg1'])
    EEGhc = Restrict(EEG1, 32960000, 33020000);
    clear EEG1

    load([parent_dir filesep 'Rat12/0407/EEG5filt50'])
    EEGpfc = Restrict(EEG5filt50, 32960000, 33020000);
    clear EEG5filt50

    load([parent_dir filesep 'Rat12/0407/EEG5theta'])
    EEGpfcTheta = Restrict(EEG5theta, 32960000, 33020000);
    clear EEG5theta

    EEGhcTheta = Filter_7hz(EEGhc)

    shift = 1.*(max(Data(EEGpfc)) - min(Data(EEGpfc)));

    fig.figureType = 'plot';
    fig.figureName = 'Rat12ThetaExample';
    fig.x{1} = Range(EEGpfc,'s');
    fig.n{1} = Data(EEGpfc);
    fig.style{1} = 'k';

    fig.x{2}  = Range(EEGpfcTheta, 's');
    fig.n{2} = Data(EEGpfcTheta);
    fig.style{2} = 'r';


    fig.x{3} = Range(EEGhc,'s');
    fig.n{3} = Data(EEGhc)/2 + shift;
    fig.style{3} = 'k';

    fig.x{4}  = Range(EEGhcTheta, 's');
    fig.n{4} = Data(EEGhcTheta)/2 +shift;
    fig.style{4} = 'r';

    fig.noXTick = 0;
    fig.noYTick = 0;
    fig.xLim = ([3297 3301]);
    fig.position = [117         487        1160         420];
    
    fig_st = [fig_st { fig } ];

end

if doThetaExample2
    fig = [];


    load([parent_dir filesep 'Rat18/1021/1021eeg6'])
    EEGhc = Restrict(EEG6, 23250000, 23320000);
    clear EEG1

    load([parent_dir filesep 'Rat18/1021/EEG4filt50'])
    EEGpfc = Restrict(EEG4filt50, 23250000, 23320000);
    clear EEG4filt50

    
    EEGpfcTheta = Filter_7hz(EEGpfc);
    EEGhcTheta = Filter_7hz(EEGhc);

    shift = 2.5*(max(Data(EEGpfc)) - min(Data(EEGpfc)));

    fig.figureType = 'plot';
    fig.figureName = 'Rat12ThetaExample2';
    fig.x{1} = Range(EEGpfc,'s');
    fig.n{1} = 2*Data(EEGpfc);
    fig.style{1} = 'k';

    fig.x{2}  = Range(EEGpfcTheta, 's');
    fig.n{2} = 2*Data(EEGpfcTheta);
    fig.style{2} = 'r';


    fig.x{3} = Range(EEGhc,'s');
    fig.n{3} = Data(EEGhc)/2 + shift;
    fig.style{3} = 'k';

    fig.x{4}  = Range(EEGhcTheta, 's');
    fig.n{4} = Data(EEGhcTheta)/2 +shift;
    fig.style{4} = 'r';

    fig.noXTick = 0;
    fig.noYTick = 0;
    fig.xLim = ([2326 2330]);
    fig.position = [117         487        1160         420];
    
    fig_st = [fig_st { fig } ];

end

if doThetaVel
    ix = 5:29;
    ix = setdiff(ix, [ 7 8 11 12 13]);
    datasets = List2Cell('datasets_pos.list');
    datasets = datasets(ix);
    A = getResource(A, 'PfcThetaVelCorr', datasets);
    A = getResource(A, 'HcThetaVelCorr', datasets);

    h = [pfcThetaVelCorr, hcThetaVelCorr];

    fig = [];
    fig.x = 1:length(ix);
    fig.n = h;
    fig.figureName = 'SpeedThetaPowerCorrBySession';
    fig.figureType = 'hist';
    fig.xLabel = ('Session');
    fig.yLabel = ('Speed/Theta power correlation');
    fig.xLim = [0 21];
    fig_st = [fig_st { fig } ] ;
    
    
    %%%%%%%%%%%%
    load /home/fpbatta/Data/LPPA/PfcHcSpecgramFreq
    datasets = List2Cell('datasets_pos.list');
    dset = datasets{17};
    A = getResource(A, 'PfcSpecgram', dset);
    pfcSpecgram = pfcSpecgram{1};

    A = getResource(A, 'HcSpecgram', dset);
    hcSpecgram = hcSpecgram{1};

    A = getResource(A, 'BinnedVelocity', dset);
    binnedVelocity = binnedVelocity{1};

    A = getResource(A, 'PfcThetaThresh', dset);
    A = getResource(A, 'HcThetaThresh', dset);
    
    fMin = min(find(PfcHcSpecgramFreq > 5));
    fMax = min(find(PfcHcSpecgramFreq > 10));

    dpfc = Data(pfcSpecgram);
    dpfc = sum(dpfc(:,fMin:fMax), 2);
    dhc = Data(hcSpecgram);
    dhc = sum(dhc(:,fMin:fMax), 2);
    bv = Data(binnedVelocity);

    ix = find(dpfc < pfcThetaThresh);
    fig = [];
    fig.x{1} = bv(ix);
    fig.n{1} =  dpfc(ix);
    fig.style{1} = 'k.';
    fig.figureType = 'plot';
    fig.figureName = 'PfcSpeedTheta';
    fig.xLabel = 'Running speed (cm/s)';
    fig.yLabel = 'Theta power';

    fig_st = [fig_st { fig } ] ;

    ix = find(dhc < hcThetaThresh);
    fig = [];
    fig.x{1} = bv(ix);
    fig.n{1} =  dhc(ix);
    fig.style{1} = 'k.';
    fig.figureType = 'plot';
    fig.figureName = 'hcSpeedTheta';
    fig.xLabel = 'Running speed (cm/s)';
    fig.yLabel = 'Theta power';

    fig_st = [fig_st { fig } ] ;


end
makeFigure(fig_st);

