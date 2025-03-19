function FastAccelerometerCalibration(indir, Intensities)
% Gets raw accelerometer file and calculates freezing parameters and
% startle index
%

%% Parameters
% Paths
FilesList = dir(fullfile(indir, '**', '*auxiliary.dat'));
PathToXMLTemplate = '/media/mobsrick/DataMOBS87/test/AccelerometerCalibrationTemplate.xml';
NameXMLTemplate = 'AccelerometerCalibrationTemplate.xml';

% To calculate freezing and startle
thtps_immob=2;
smoofact_Acc = 30; % Smoothing factor for freezing
th_immob_Acc = 17000000;
sm = 5; % Smoothing factor for startle index

% Channels
DigChannelNumber = 4;
DigChanStim = 3;

% Freezing calculation parameters
LSession = 180; % Duration of one calibration session (in s)
BeforeAfter = 10; % Duration of epoch before and after the first stimulus in each calibration session (in s)

% Plotting
TIT = 'Mouse 828 - Calibration'; % title

%% Allocate space
Freezing = zeros(1,length(Intensities));
FreezingBeforeRatioSingleShot = zeros(1,length(Intensities));
FreezingAfterRatioSingleShot = zeros(1,length(Intensities));
AccRatio = zeros(1,length(Intensities));

%%
for j = 1:length(Intensities)
    %% Preprocess the data
    
    % Create subfolder to preprocess data
    flnme = [num2str(Intensities(j)) 'V'];
    cd(FilesList(j).folder);
    mkdir(flnme);
    copyfile([FilesList(j).folder '/auxiliary.dat'], [FilesList(j).folder '/' flnme]);
    copyfile([FilesList(j).folder '/digitalin.dat'], [FilesList(j).folder '/' flnme]);
    cd([FilesList(j).folder '/' flnme]);
    movefile([FilesList(j).folder '/' flnme '/auxiliary.dat'], [flnme '-accelero.dat']);
    movefile([FilesList(j).folder '/' flnme '/digitalin.dat'], [flnme '-digin.dat']);
    copyfile(PathToXMLTemplate, [FilesList(j).folder '/' flnme]);
    movefile([FilesList(j).folder '/' flnme '/' NameXMLTemplate], [flnme '.xml']);
    
    SetCurrentSession([flnme '.xml']); % Need names and .xml files - Creat??? - Sophie's preprocessing codes
    system(['ndm_mergedat ' flnme '.xml']);
    system(['ndm_lfp ' flnme '.xml']);
    
    % Get three axes of accelerometer
    X = GetLFP(0);
    X = tsd(X(:,1)*1E4, X(:,2));
    Y = GetLFP(1);
    Y = tsd(Y(:,1)*1E4, Y(:,2));
    Z = GetLFP(2);
    Z = tsd(Z(:,1)*1E4, Z(:,2));
    
    % Create MovAcctsd
    MX = Data(X);
    MY = Data(Y);
    MZ = Data(Z);
    Rg = Range(X);
    Acceleration = MX.^2 + MY.^2 + MZ.^2;
    %Acc=sqrt(MX.*MX+MY.*MY+MZ.*MZ);
    disp('... DownSampling at 50Hz');
    MovAcctsd{j} = tsd(Rg(1:25:end), double(abs([0;diff(Acceleration(1:25:end))])) );
    clear X Y Z MX MY MZ Rg Acceleration
    
    % Digin
    DigIn=GetWideBandData(3);
    DigIn=DigIn(1:16:end,:);
    DataDigIn=DigIn(:,2);
    TimeDigIn=DigIn(:,1);
    
    for k=0:DigChannelNumber
        a(k+1)=2^k-0.1;
    end
    
    try
        for k=DigChannelNumber:-1:1
            DigOUT(k,:)=double(DataDigIn>a(k));
            DataDigIn(DataDigIn>a(k))=  DataDigIn(DataDigIn>a(k))-a(k)+0.1;
            DigTSD{j}{k}=tsd(TimeDigIn*1e4,DigOUT(k,:)');
        end
    catch
        disp('problem for digin')
    end
    clear DigIn DataDigIn TimeDigIn a DigOUT
    
    % Get Stims
    StimEpoch{j}=thresholdIntervals(DigTSD{j}{DigChanStim},0.9,'Direction','Above');
    
    % Get Freezing
    NewMovAcctsd{j}=tsd(Range(MovAcctsd{j}),runmean(Data(MovAcctsd{j}),smoofact_Acc));
    FreezeAccEpoch{j}=thresholdIntervals(NewMovAcctsd{j},th_immob_Acc,'Direction','Below');
    FreezeAccEpoch{j}=mergeCloseIntervals(FreezeAccEpoch{j},0.3*1e4);
    FreezeAccEpoch{j}=dropShortIntervals(FreezeAccEpoch{j},thtps_immob*1e4);
    
    % Get Startle Index
    SmallEpoch = intervalSet((Start(StimEpoch{j})-1*1E4), End(StimEpoch{j})+1*1E4); % Parametrize 1
    
    LSamples=100; % No reason - it works
    for i=1:length(Start(SmallEpoch))
        try
            AccSmallData(i, 1:LSamples) = Data(Restrict(MovAcctsd{j}, subset(SmallEpoch,i)));
            delme1 = runmean(AccSmallData(i, LSamples/2+1:end),sm);
            delme2 = runmean(AccSmallData(i, 1:LSamples/2),sm);
            AccSmallData(i,1:LSamples) = [delme2 delme1];
        catch
            rmme = Data(Restrict(MovAcctsd{j}, subset(SmallEpoch,i)));
            AccSmallData(i, 1:LSamples) = rmme(1:end-1);
            delme1 = runmean(AccSmallData(i, LSamples/2+1:end),sm);
            delme2 = runmean(AccSmallData(i, 1:LSamples/2),sm);
            AccSmallData(i,1:LSamples) = [delme2 delme1];
        end
    end
    lSmall = LSamples;
    
    AccSmallDataMean = mean(AccSmallData,1);
    AccSmallDataSTD = std(AccSmallData,1);
    
    [rSmall,iSmall] = Sync(Range(MovAcctsd{j})/1e4,Start(StimEpoch{j})/1e4,'durations',[-1 1]);
    [m,tSmall] = SyncMap(rSmall,iSmall,'durations', [-1 1], 'nBins', lSmall);
    
    ID_TimeMoreZeroSmall = find(tSmall>0, 1,'first');
    ID_TimeLessZeroSmall = find(tSmall<0, 1,'last');
    MSmallAfter(j) = max(AccSmallDataMean(ID_TimeMoreZeroSmall:end)); % Find max after stimulation
    MSmallBefore(j) = max(AccSmallDataMean(1:ID_TimeLessZeroSmall)); % Find max before stimulation
    ind_maxSmallAfter = find(AccSmallDataMean==MSmallAfter(j));
    ind_maxSmallBefore = find(AccSmallDataMean==MSmallBefore(j));
    
    AccRatio(j) = MSmallAfter(j)/MSmallBefore(j);
    clear SmallEpoch LSamples AccSmallData delme1 delme2 rmme lSmall AccSmallDataMean AccSmallDataSTD rSmall iSmall m ...
        tSmall ID_TimeMoreZeroSmall ID_TimeLessZeroSmall ind_maxSmallAfter ind_maxSmallBefore
    
    %% Calculate freezing and startle index
    
    FreezeEpoch{j} = minus(FreezeAccEpoch{j},StimEpoch{j}); % Load diginfo
    Freezing(j) = sum(End(FreezeEpoch{j})-Start(FreezeEpoch{j}))/1e4;
    Freezingperc(j) = Freezing(j)/LSession*100; % 
    
    StartStims = Start(StimEpoch{j});
    BeforeSingleShot = intervalSet(StartStims(1)-10e4,StartStims(1));
    AfterSingleShot = intervalSet(StartStims(1),StartStims(1)+10e4);
    
    FreezeBeforeSingleShot = and(FreezeEpoch{j}, BeforeSingleShot);
    FreezingBeforeRatioSingleShot(j) = sum(End(FreezeBeforeSingleShot)-Start(FreezeBeforeSingleShot))/1e4/BeforeAfter;
    FreezeAfterSingleShot = and(FreezeEpoch{j}, AfterSingleShot);
    FreezingAfterRatioSingleShot(j) = sum(End(FreezeAfterSingleShot)-Start(FreezeAfterSingleShot))/1e4/BeforeAfter;
   
    clear StartStims BeforeSingleShot AfterSingleShot FreezeBeforeSingleShot FreezeAfterSingleShot
    
end

%% Plot
figure('units', 'normalized', 'outerposition', [0 1 0.7 0.5]);

yyaxis left
plot(Intensities, Freezingperc, '-ko', 'LineWidth', 2);
hold on
plot(Intensities, FreezingBeforeRatioSingleShot*100, 'b--o');
hold on
plot(Intensities, FreezingAfterRatioSingleShot*100, 'r--o');
ylim([0 100]);
set(gca, 'YColor', 'k');
yyaxis right
plot(Intensities, AccRatio, '-mo');
set(gca, 'YColor', 'm');
xlabel('Intensities in V');
set(gca, 'FontSize',13);
xlim([0 8.5]);
title(TIT);
legend('Overall Freezing', 'BeforeStim','AfterStim', 'StartleRatio');

%% Clear all
% clear

end