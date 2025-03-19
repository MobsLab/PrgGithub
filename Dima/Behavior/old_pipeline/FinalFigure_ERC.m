%%% FinalFigure_ERC

clear
%% Parameters
% General
nmouse = 861;
sav=1; % Do you want to save a figure?
old = 0;
dir_out = '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Behavior/Mouse861/'; % Where?
fig_post = 'FinaleERCBehavior'; % Name of the output file

calibration_prepro = 0; % have you already preprocessed calibration sessions?
contextual = 0; % do you have data of contextaul memory test?
Avoidance = 1; % do you have data for avoidance UMaze protocol?
h24 = 0; % Do you have data for 24h later?

% Path to AnatomyFigures
figpath = '/media/DataMOBsRAIDN/ProjetERC2/Mouse-753/question.png';
% Path to accelerometer proceesing xml
calibdir = '/media/mobsrick/DataMOBS87/Mouse-861/20190225/Calib/';
PathToXMLTemplate = '/media/DataMOBsRAIDN/ProjetERC2/AccelerometerCalibrationTemplate.xml';
NameXMLTemplate = 'AccelerometerCalibrationTemplate.xml';

% Intensities from calibration test
Intensities = [0 0.5 1 1.5 2 2.5 3.0 3.5 4.0];

% Highlight selected intensity
% chosen = [0 0 0 0]; % Nothing
% chosen = [0.12 0.78 0.02 0.04]; % 1.5V
% chosen = [0.143 0.78 0.02 0.05]; % 2V
% chosen = [0.165 0.78 0.02 0.05]; % 2.5V
% chosen = [0.182 0.78 0.02 0.05]; % 3V
% chosen = [0.205 0.78 0.02 0.05]; % 3.5V
chosen = [0.224 0.78 0.02 0.05]; % 4V
% chosen = [0.246 0.78 0.02 0.05]; % 4.5V
% chosen = [0.267 0.78 0.02 0.05]; % 5V
% chosen = [0.308 0.78 0.02 0.05]; % 6V

clrs = {'ko', 'bo', 'ro','go'; 'k','b', 'r', 'g'; 'kp', 'bp', 'rp', 'gp'};

%% Axes
fbilan = figure('units', 'normalized', 'outerposition', [0 0 1 1],  'Color',[1 1 1]);
if Avoidance
    TrajPreTest_Axes = axes('position', [0.03 0.4 0.3 0.3]);
    TrajCond_Axes = axes('position', [0.35 0.4 0.3 0.3]);
    TrajTestPost_Axes = axes('position', [0.67 0.4 0.3 0.3]);
else
    annotation(fbilan,'textbox',[0.35 0.45 0.3 0.15],'String','No Experiment Performed','LineWidth',3,...
        'HorizontalAlignment','center', 'FontSize', 46, 'FontWeight','bold',...
        'FitBoxToText','on');
end

Calib_Axes = axes('position',[0.07 0.8 0.35 0.15]);
ContextMemory_Axes = axes('position',[0.50 0.75 0.2 0.2]);
Anatomy_Axes = axes('position', [0.63 0.725 0.45 0.25]);

if h24
    TrajTestPost24_Axes = axes('position', [0.38 0.05 0.27 0.27]);
else
    annotation(fbilan,'textbox',[0.65 0.15 0.2 0.1],'String','No tests 24 h later Performed','LineWidth',3,...
        'HorizontalAlignment','center', 'FontSize', 36, 'FontWeight','bold',...
        'FitBoxToText','on');
end

if Avoidance
    OccupPost_Axes = axes('position', [0.05 0.22 0.12 0.12]);
    TimePost_Axes = axes('position', [0.23 0.22 0.12 0.12]);
    FirstPost_Axes = axes('position', [0.05 0.05 0.12 0.12]);
    SpeedPost_Axes = axes('position', [0.23 0.05 0.12 0.12]);
end

if h24
    OccupPost24_Axes = axes('position', [0.7 0.22 0.12 0.12]);
    TimePost24_Axes = axes('position', [0.87 0.22 0.12 0.12]);
    FirstPost24_Axes = axes('position', [0.7 0.05 0.12 0.12]);
    SpeedPost24_Axes = axes('position', [0.87 0.05 0.12 0.12]);
end

if Avoidance
    boxpost = [0.1 0.365 0.18 0.02];
    annotation(fbilan,'textbox',boxpost,'String','After 2-3h of Sleep','LineWidth',1,'HorizontalAlignment','center','FontWeight','bold',...
        'FitBoxToText','off');
    
    boxpost24 = [0.75 0.365 0.18 0.02];
    annotation(fbilan,'textbox',boxpost24,'String','After 24h','LineWidth',1,'HorizontalAlignment','center','FontWeight','bold',...
        'FitBoxToText','off');
end

annotation(fbilan,'ellipse', chosen, 'LineWidth',2);

% Supertitle
mtit(fbilan,['Mouse ' num2str(nmouse)], 'fontsize',16, 'xoff', -0.1);

%% Calculate Data Calibration
% Load data
% if calibration_prepro
%     Dir_Calib = PathForExperimentsERC_Dima('Calib');
%     Dir_Calib = RestrictPathForExperiment(Dir_Calib,'nMice',nmouse);
%     for i = 1:length(Dir_Calib.path{1})
%         F{i} = load([Dir_Calib.path{1}{i} 'behavResources.mat'],'FreezeAccEpoch', 'TTLInfo', 'StartleIndex');
%     end
%     
%     % Allocate space
%     Freezing = zeros(1,length(Intensities));
%     Freezingperc = zeros(1,length(Intensities));
%     FreezingBeforeratio = zeros(1,length(Intensities));
%     FreezingAfterratio = zeros(1,length(Intensities));
%     FreezingRatio = zeros(1,length(Intensities));
%     FreezingBeforeRatioSingleShot = zeros(1,length(Intensities));
%     FreezingAfterRatioSingleShot = zeros(1,length(Intensities));
%     StartleIdxs = zeros(1,length(Intensities));
%     
%     % Calculate
%     for i=1:length(Intensities)
%         FreezeEpoch = minus(F{i}.FreezeAccEpoch,F{i}.TTLInfo.StimEpoch);
%         Freezing(i) = sum(End(F{i}.FreezeAccEpoch)-Start(F{i}.FreezeAccEpoch))/1e4;
%         Freezingperc(i) = Freezing(i)/180*100;
%         
%         A = Start(F{i}.TTLInfo.StimEpoch);
%         BeforeEpoch = intervalSet(F{i}.TTLInfo.StartSession,A(1));
%         lBefore = sum(End(BeforeEpoch) - Start(BeforeEpoch))/1e4;
%         AfterEpoch = intervalSet(A(1), F{i}.TTLInfo.StopSession);
%         lAfter = sum(End(AfterEpoch) - Start(AfterEpoch))/1e4;
%         AfterEpoch = minus(AfterEpoch,F{i}.TTLInfo.StimEpoch);
%         BeforeSingleShot = intervalSet(A(1)-10e4,A(1));
%         AfterSingleShot = intervalSet(A(1),A(1)+10e4);
%         len=10;
%         
%         
%         FreezeBefore = and(F{i}.FreezeAccEpoch, BeforeEpoch);
%         FreezingBeforeratio(i) = sum(End(FreezeBefore)-Start(FreezeBefore))/1e4/lBefore;
%         FreezeAfter = and(F{i}.FreezeAccEpoch, AfterEpoch);
%         FreezingAfterratio(i) = sum(End(FreezeAfter)-Start(FreezeAfter))/1e4/lAfter;
%         FreezingRatio(i) = FreezingAfterratio(i)/FreezingBeforeratio(i);
%         
%         FreezeBeforeSingleShot = and(F{i}.FreezeAccEpoch, BeforeSingleShot);
%         FreezingBeforeRatioSingleShot(i) = sum(End(FreezeBeforeSingleShot)-Start(FreezeBeforeSingleShot))/1e4/len;
%         FreezeAfterSingleShot = and(F{i}.FreezeAccEpoch, AfterSingleShot);
%         FreezingAfterRatioSingleShot(i) = sum(End(FreezeAfterSingleShot)-Start(FreezeAfterSingleShot))/1e4/len;
%         
%         StartleIdxs(i) = F{i}.StartleIndex;
%     end
%     
%     clear Freezing FreezeEpoch A BeforeEpoch lBefore AfterEpoch lAfter FreezeBefore FreezeAfter
% else
%     % Path
%     FilesList = dir(fullfile(calibdir, '**', '*auxiliary.dat'));
%     
%     % To calculate freezing and startle
%     thtps_immob=2;
%     smoofact_Acc = 30; % Smoothing factor for freezing
%     th_immob_Acc = 17000000;
%     sm = 5; % Smoothing factor for startle index
%     
%     % Channels
%     DigChannelNumber = 4;
%     DigChanStim = 3;
%     
%     % Freezing calculation parameters
%     LSession = 180; % Duration of one calibration session (in s)
%     BeforeAfter = 10; % Duration of epoch before and after the first stimulus in each calibration session (in s)
%     
%     % Allocate space
%     Freezing = zeros(1,length(Intensities));
%     FreezingBeforeRatioSingleShot = zeros(1,length(Intensities));
%     FreezingAfterRatioSingleShot = zeros(1,length(Intensities));
%     AccRatio = zeros(1,length(Intensities));
%     
%     %
%     for j = 1:length(Intensities)
%         % Preprocess the data
%         
%         % Create subfolder to preprocess data
%         flnme = [num2str(Intensities(j)) 'V'];
%         cd(FilesList(j).folder);
%         mkdir(flnme);
%         copyfile([FilesList(j).folder '/auxiliary.dat'], [FilesList(j).folder '/' flnme]);
%         copyfile([FilesList(j).folder '/digitalin.dat'], [FilesList(j).folder '/' flnme]);
%         cd([FilesList(j).folder '/' flnme]);
%         movefile([FilesList(j).folder '/' flnme '/auxiliary.dat'], [flnme '-accelero.dat']);
%         movefile([FilesList(j).folder '/' flnme '/digitalin.dat'], [flnme '-digin.dat']);
%         copyfile(PathToXMLTemplate, [FilesList(j).folder '/' flnme]);
%         movefile([FilesList(j).folder '/' flnme '/' NameXMLTemplate], [flnme '.xml']);
%         
%         SetCurrentSession([flnme '.xml']);
%         system(['ndm_mergedat ' flnme '.xml']);
%         system(['ndm_lfp ' flnme '.xml']);
%         
%         % Get three axes of accelerometer
%         X = GetLFP(0);
%         X = tsd(X(:,1)*1E4, X(:,2));
%         Y = GetLFP(1);
%         Y = tsd(Y(:,1)*1E4, Y(:,2));
%         Z = GetLFP(2);
%         Z = tsd(Z(:,1)*1E4, Z(:,2));
%         
%         % Create MovAcctsd
%         MX = Data(X);
%         MY = Data(Y);
%         MZ = Data(Z);
%         Rg = Range(X);
%         Acceleration = MX.^2 + MY.^2 + MZ.^2;
%         %Acc=sqrt(MX.*MX+MY.*MY+MZ.*MZ);
%         disp('... DownSampling at 50Hz');
%         MovAcctsd{j} = tsd(Rg(1:25:end), double(abs([0;diff(Acceleration(1:25:end))])) );
%         clear X Y Z MX MY MZ Rg Acceleration
%         
%         % Digin
%         DigIn=GetWideBandData(3);
%         DigIn=DigIn(1:16:end,:);
%         DataDigIn=DigIn(:,2);
%         TimeDigIn=DigIn(:,1);
%         
%         for k=0:DigChannelNumber
%             a(k+1)=2^k-0.1;
%         end
%         
%         try
%             for k=DigChannelNumber:-1:1
%                 DigOUT(k,:)=double(DataDigIn>a(k));
%                 DataDigIn(DataDigIn>a(k))=  DataDigIn(DataDigIn>a(k))-a(k)+0.1;
%                 DigTSD{j}{k}=tsd(TimeDigIn*1e4,DigOUT(k,:)');
%             end
%         catch
%             disp('problem for digin')
%         end
%         clear DigIn DataDigIn TimeDigIn a DigOUT
%         
%         % Get Stims
%         StimEpoch{j}=thresholdIntervals(DigTSD{j}{DigChanStim},0.9,'Direction','Above');
%         
%         % Get Freezing
%         NewMovAcctsd{j}=tsd(Range(MovAcctsd{j}),runmean(Data(MovAcctsd{j}),smoofact_Acc));
%         FreezeAccEpoch{j}=thresholdIntervals(NewMovAcctsd{j},th_immob_Acc,'Direction','Below');
%         FreezeAccEpoch{j}=mergeCloseIntervals(FreezeAccEpoch{j},0.3*1e4);
%         FreezeAccEpoch{j}=dropShortIntervals(FreezeAccEpoch{j},thtps_immob*1e4);
%         
%         % Get Startle Index
%         SmallEpoch = intervalSet((Start(StimEpoch{j})-1*1E4), End(StimEpoch{j})+1*1E4); % Parametrize 1
%         
%         LSamples=100; % No reason - it works
%         for i=1:length(Start(SmallEpoch))
%             try
%                 AccSmallData(i, 1:LSamples) = Data(Restrict(MovAcctsd{j}, subset(SmallEpoch,i)));
%                 delme1 = runmean(AccSmallData(i, LSamples/2+1:end),sm);
%                 delme2 = runmean(AccSmallData(i, 1:LSamples/2),sm);
%                 AccSmallData(i,1:LSamples) = [delme2 delme1];
%             catch
%                 rmme = Data(Restrict(MovAcctsd{j}, subset(SmallEpoch,i)));
%                 AccSmallData(i, 1:LSamples) = rmme(1:end-1);
%                 delme1 = runmean(AccSmallData(i, LSamples/2+1:end),sm);
%                 delme2 = runmean(AccSmallData(i, 1:LSamples/2),sm);
%                 AccSmallData(i,1:LSamples) = [delme2 delme1];
%             end
%         end
%         lSmall = LSamples;
%         
%         AccSmallDataMean = mean(AccSmallData,1);
%         AccSmallDataSTD = std(AccSmallData,1);
%         
%         [rSmall,iSmall] = Sync(Range(MovAcctsd{j})/1e4,Start(StimEpoch{j})/1e4,'durations',[-1 1]);
%         [m,tSmall] = SyncMap(rSmall,iSmall,'durations', [-1 1], 'nBins', lSmall);
%         
%         ID_TimeMoreZeroSmall = find(tSmall>0, 1,'first');
%         ID_TimeLessZeroSmall = find(tSmall<0, 1,'last');
%         MSmallAfter(j) = max(AccSmallDataMean(ID_TimeMoreZeroSmall:end)); % Find max after stimulation
%         MSmallBefore(j) = max(AccSmallDataMean(1:ID_TimeLessZeroSmall)); % Find max before stimulation
%         ind_maxSmallAfter = find(AccSmallDataMean==MSmallAfter(j));
%         ind_maxSmallBefore = find(AccSmallDataMean==MSmallBefore(j));
%         
%         AccRatio(j) = MSmallAfter(j)/MSmallBefore(j);
%         clear SmallEpoch LSamples AccSmallData delme1 delme2 rmme lSmall AccSmallDataMean AccSmallDataSTD rSmall iSmall m ...
%             tSmall ID_TimeMoreZeroSmall ID_TimeLessZeroSmall ind_maxSmallAfter ind_maxSmallBefore
%         
%         % Calculate freezing and startle index
%         
%         FreezeEpoch{j} = minus(FreezeAccEpoch{j},StimEpoch{j}); % Load diginfo
%         Freezing(j) = sum(End(FreezeEpoch{j})-Start(FreezeEpoch{j}))/1e4;
%         Freezingperc(j) = Freezing(j)/LSession*100; %
%         
%         StartStims = Start(StimEpoch{j});
%         BeforeSingleShot = intervalSet(StartStims(1)-10e4,StartStims(1));
%         AfterSingleShot = intervalSet(StartStims(1),StartStims(1)+10e4);
%         
%         FreezeBeforeSingleShot = and(FreezeEpoch{j}, BeforeSingleShot);
%         FreezingBeforeRatioSingleShot(j) = sum(End(FreezeBeforeSingleShot)-Start(FreezeBeforeSingleShot))/1e4/BeforeAfter;
%         FreezeAfterSingleShot = and(FreezeEpoch{j}, AfterSingleShot);
%         FreezingAfterRatioSingleShot(j) = sum(End(FreezeAfterSingleShot)-Start(FreezeAfterSingleShot))/1e4/BeforeAfter;
%         
%         clear StartStims BeforeSingleShot AfterSingleShot FreezeBeforeSingleShot FreezeAfterSingleShot
%         
%     end
% end
% 
%% Contextual Memory Data

% Load data
if contextual
    % Get Directories
    Dir_Day1A = PathForExperimentsERC_Dima('NeutralContextDay1');
    Dir_Day1A = RestrictPathForExperiment(Dir_Day1A,'nMice',nmouse);    
    Dir_Day2A = PathForExperimentsERC_Dima('NeutralContextDay2');
    Dir_Day2A = RestrictPathForExperiment(Dir_Day2A,'nMice',nmouse);
    Dir_Day1B = PathForExperimentsERC_Dima('AversiveContextDay1');
    Dir_Day1B = RestrictPathForExperiment(Dir_Day1B,'nMice',nmouse);
    Dir_Day2B = PathForExperimentsERC_Dima('AversiveContextDay2');
    Dir_Day2B = RestrictPathForExperiment(Dir_Day2B,'nMice',nmouse);
    
    Day1A = load([Dir_Day1A.path{1}{1} 'behavResources.mat'],'FreezeAccEpoch', 'TTLInfo');
    Day2A = load([Dir_Day2A.path{1}{1} 'behavResources.mat'],'FreezeAccEpoch', 'TTLInfo');
    
    Day1B = load([Dir_Day1B.path{1}{1} 'behavResources.mat'],'FreezeAccEpoch', 'TTLInfo');
    Day2B = load([Dir_Day2B.path{1}{1} 'behavResources.mat'],'FreezeAccEpoch', 'TTLInfo');

    
    %Day1A
    Epoch = intervalSet(Day1A.TTLInfo.StopSession-180*1E4,Day1A.TTLInfo.StopSession);
    FreezeEpoch = and(Day1A.FreezeAccEpoch,Epoch);
    Freezing(1,1) = sum(End(FreezeEpoch)-Start(FreezeEpoch))/1e4;
    Freezingperc(1,1) = Freezing(1,1)/(sum(End(Epoch)-Start(Epoch))/1e4)*100;
    
    %Day2A
    Epoch = intervalSet(Day2A.TTLInfo.StartSession,Day2A.TTLInfo.StartSession+180*1E4);
    FreezeEpoch = and(Day2A.FreezeAccEpoch,Epoch);
    FreezingMemo(1,2) = sum(End(FreezeEpoch)-Start(FreezeEpoch))/1e4;
    FreezingpercMemo(1,2) = FreezingMemo(1,2)/(sum(End(Epoch)-Start(Epoch))/1e4)*100;
    %Day1B
    FreezeEpoch = minus(Day1B.FreezeAccEpoch,Day1B.TTLInfo.StimEpoch);
    FreezingMemo(2,1) = sum(End(Day1B.FreezeAccEpoch)-Start(Day1B.FreezeAccEpoch))/1e4;
    FreezingpercMemo(2,1) = FreezingMemo(2,1)/((Day1B.TTLInfo.StopSession-Day1B.TTLInfo.StartSession)/1e4)*100;
    %Day2B
    Epoch = intervalSet(Day2B.TTLInfo.StartSession,Day2B.TTLInfo.StartSession+180*1E4);
    FreezeEpoch = and(Day2B.FreezeAccEpoch,Epoch);
    FreezingMemo(2,2) = sum(End(FreezeEpoch)-Start(FreezeEpoch))/1e4;
    FreezingpercMemo(2,2) = FreezingMemo(2,2)/(sum(End(Epoch)-Start(Epoch))/1e4)*100;
end

%% Get the data Avodance
Dir = PathForExperimentsERC_Dima('UMazePAG');
Dir = RestrictPathForExperiment(Dir,'nMice', nmouse);
if h24
    Dir_Post24 = PathForExperimentsERC_Dima('TestPost24h');
    Dir_Post24 = RestrictPathForExperiment(Dir_Post24,'nMice',nmouse);
end

if Avoidance
    for i = 1:length(Dir.path)
        a{i} = load([Dir.path{i}{1} '/behavResources.mat'], 'behavResources');
    end
    
    % PostTests h24 later
    if h24
        for i = 1:length(Dir_Post24.path{1}) 
            d = load([Dir_Post24.path{1}{i} 'behavResources.mat'],'Occup', 'PosMat','Xtsd', 'Ytsd', 'Vtsd',...
                'mask', 'Zone', 'ZoneIndices', 'Ratio_IMAonREAL');
            Post24_Xtsd{i} = d.Xtsd;
            Post24_Ytsd{i} = d.Ytsd;
            Post24_Vtsd{i} = d.Vtsd;
            Post24_PosMat{i} = d.PosMat;
            Post24_occup(i,1:7) = d.Occup;
            Post24_ZoneIndices{i} = d.ZoneIndices;
            Post24_mask = d.mask;
            Post24_Zone = d.Zone;
            Post24_Ratio_IMAonREAL = d.Ratio_IMAonREAL;
        end
    end
end

%% Find indices of PreTests, Cond and PostTest session in the structure
id_Pre = cell(1,length(a));
id_Cond = cell(1,length(a));
id_Post = cell(1,length(a));


for i=1:length(a)
    id_Pre{i} = zeros(1,length(a{i}.behavResources));
    id_Cond{i} = zeros(1,length(a{i}.behavResources));
    id_Post{i} = zeros(1,length(a{i}.behavResources));
    for k=1:length(a{i}.behavResources)
        if ~isempty(strfind(a{i}.behavResources(k).SessionName,'TestPre'))
            id_Pre{i}(k) = 1;
        end
        if ~isempty(strfind(a{i}.behavResources(k).SessionName,'Cond'))
            id_Cond{i}(k) = 1;
        end
        if ~isempty(strfind(a{i}.behavResources(k).SessionName,'TestPost'))
            id_Post{i}(k) = 1;
        end
    end
    id_Pre{i}=find(id_Pre{i});
    id_Cond{i}=find(id_Cond{i});
    id_Post{i}=find(id_Post{i});
end
%% Get stimulation idxs for conditioning sessions
if Avoidance
    for i=1:length(a)
        for k=1:length(id_Cond{i})
            StimT_beh{i}{k} = find(a{i}.behavResources(id_Cond{i}(k)).PosMat(:,4)==1);
        end
    end
end

%% Calculate average occupancy
% Mean and STD across 4 Pre- and PostTests
if Avoidance
    for i=1:length(a)
        for k=1:length(id_Pre{i})
            for t=1:length(a{i}.behavResources(id_Pre{i}(k)).Zone)
                Pre_Occup(i,k,t)=size(a{i}.behavResources(id_Pre{i}(k)).ZoneIndices{t},1)./...
                    size(Data(a{i}.behavResources(id_Pre{i}(k)).Xtsd),1);
            end
        end
        for k=1:length(id_Post{i})
            for t=1:length(a{i}.behavResources(id_Post{i}(k)).Zone)
                Post_Occup(i,k,t)=size(a{i}.behavResources(id_Post{i}(k)).ZoneIndices{t},1)./...
                    size(Data(a{i}.behavResources(id_Post{i}(k)).Xtsd),1);
            end
        end
    end
    Pre_Occup = squeeze(Pre_Occup(:,:,1));
    Post_Occup = squeeze(Post_Occup(:,:,1));
    
    Pre_Occup_mean = mean(Pre_Occup,2);
    Pre_Occup_std = std(Pre_Occup,0,2);
    Post_Occup_mean = mean(Post_Occup,2);
    Post_Occup_std = std(Post_Occup,0,2);
    % Wilcoxon signed rank task between Pre and PostTest
    p_pre_post = signrank(Pre_Occup_mean, Post_Occup_mean);
    point_pre_post = [Pre_Occup; Post_Occup]';
end

if h24
    Post24_occup = Post24_occup*100;
    Post24_Occup_mean = mean(Post24_occup,1);
    Post24_Occup_std = std(Post24_occup,1);
    p_pre_post24 = signrank(Pre_Occup_mean,Post24_occup(:,1));
    point_pre_post24 = [Pre_Occup_mean Post24_occup(:,1)];
end

%% Prepare the 'first enter to shock zone' array
if Avoidance
    for i = 1:length(a)
        for k=1:length(id_Pre{i})
            if isempty(a{i}.behavResources(id_Pre{i}(k)).ZoneIndices{1})
                Pre_FirstTime(i,k) = 240;
            else
                Pre_FirstZoneIndices{i}{k} = a{i}.behavResources(id_Pre{i}(k)).ZoneIndices{1}(1);
                Pre_FirstTime(i,k) = a{i}.behavResources(id_Pre{i}(k)).PosMat(Pre_FirstZoneIndices{i}{k}(1),1)-...
                    a{i}.behavResources(id_Pre{i}(k)).PosMat(1,1);
            end
        end
        
        for k=1:length(id_Post{i})
            if isempty(a{i}.behavResources(id_Post{i}(k)).ZoneIndices{1})
                Post_FirstTime(i,k) = 240;
            else
                Post_FirstZoneIndices{i}{k} = a{i}.behavResources(id_Post{i}(k)).ZoneIndices{1}(1);
                Post_FirstTime(i,k) = a{i}.behavResources(id_Post{i}(k)).PosMat(Post_FirstZoneIndices{i}{k}(1),1)-...
                    a{i}.behavResources(id_Post{i}(k)).PosMat(1,1);
            end
        end
    end
    
    Pre_FirstTime_mean = mean(Pre_FirstTime,2);
    Pre_FirstTime_std = std(Pre_FirstTime,0,2);
    Post_FirstTime_mean = mean(Post_FirstTime,2);
    Post_FirstTime_std = std(Post_FirstTime,0,2);
    Pre_Post_FirstTime = [Pre_FirstTime; Post_FirstTime]';
    % Wilcoxon test
    p_FirstTime_pre_post = signrank(Pre_FirstTime_mean,Post_FirstTime_mean);
end
Mice = [863 913 934 935 938];

if h24
    for u = 1:length(Dir_Post24.path{1})
        if isempty(Post24_ZoneIndices{u}{1})
            Post24_FirstTime(u) = 240;
        else
            Post24_FirstZoneIndices(u) = Post24_ZoneIndices{u}{1}(1);
            Post24_FirstTime(u) = Post24_PosMat{u}(Post24_FirstZoneIndices(u),1);
        end
        Pre_Post24_FirstTime(u, 1:2) = [Pre_FirstTime(1,u) Post24_FirstTime(u)];
    end
    Pre_Post24_FirstTime_mean = mean(Pre_Post24_FirstTime,1);
    Pre_Post24_FirstTime_std = std(Pre_Post24_FirstTime,1);
    p_FirstTime_pre_post24 = signrank(Pre_Post_FirstTime(:,1),Pre_Post24_FirstTime(:,2));
end

%% Calculate number of entries into the shock zone
% Check with smb if it's correct way to calculate (plus one entry even if one frame it was outside )
if Avoidance
for i = 1:length(a)
    for k=1:length(id_Pre{i})
        if isempty(a{i}.behavResources(id_Pre{i}(k)).ZoneIndices{1})
            Pre_entnum(i,k) = 0;
        else
            Pre_entnum(i,k)=length(find(diff(a{i}.behavResources(id_Pre{i}(k)).ZoneIndices{1})>1))+1;
        end
    end
    
    for k=1:length(id_Post{i})   
        if isempty(a{i}.behavResources(id_Post{i}(k)).ZoneIndices{1})
            Post_entnum(i,k) = 0;
        else
            Post_entnum(i,k)=length(find(diff(a{i}.behavResources(id_Post{i}(k)).ZoneIndices{1})>1))+1;
        end
    end
    
end
Pre_entnum_mean = mean(Pre_entnum,2);
Pre_entnum_std = std(Pre_entnum,0,2);
Post_entnum_mean = mean(Post_entnum,2);
Post_entnum_std = std(Post_entnum,0,2);
% Wilcoxon test
p_entnum_pre_post = signrank(Pre_entnum_mean, Post_entnum_mean);
Pre_Post_entnum = [Pre_entnum; Post_entnum]';
end

if h24
    for m = 1:length(Dir_Post24.path{1})
        if isempty(Post24_ZoneIndices{m}{1})
            Post24_entnum(m)=0;
        else
            Post24_entnum(m)=length(find(diff(Post24_ZoneIndices{m}{1})>1))+1;
        end
            
        end
        Pre_Post24_entnum = [Pre_entnum(i,:)'; Post24_entnum]';
        Pre_Post24_entnum_mean = mean(Pre_Post24_entnum,1);
        Pre_Post24_entnum_std = std(Pre_Post24_entnum,1);
        p_entnum_pre_post24 = signrank(Pre_entnum, Post24_entnum);
end

%% Calculate speed in the shock zone and in the noshock + shock vs everything else
% I skip the last point in ZoneIndices because length(Xtsd)=length(Vtsd)+1
if Avoidance
    for i = 1:length(a)
        for k=1:length(id_Pre{i})
            % PreTest SafeZone speed
            if isempty(a{i}.behavResources(id_Pre{i}(k)).ZoneIndices{2})
                VZmean_pre(i,k) = 0;
            else
                if old
                    Vtemp_pre{i}{k} = tsd(Range(a{i}.behavResources(id_Pre{i}(k)).Vtsd),...
                        (Data(a{i}.behavResources(id_Pre{i}(k)).Vtsd)./...
                        ([diff(a{i}.behavResources(id_Pre{i}(k)).PosMat(:,1));-1])));
                else
                    Vtemp_pre{i}{k}=Data(a{i}.behavResources(id_Pre{i}(k)).Vtsd);
                end
                VZone_pre{i}{k}=Vtemp_pre{i}{k}(a{i}.behavResources(id_Pre{i}(k)).ZoneIndices{2}(1:end-1),1);
                VZmean_pre(i,k)=mean(VZone_pre{i}{k},1);
            end
        end
        
        % PostTest SafeZone speed
        for k=1:length(id_Post{i})
            % PreTest SafeZone speed
            if isempty(a{i}.behavResources(id_Post{i}(k)).ZoneIndices{2})
                VZmean_post(i,k) = 0;
            else
                if old
                    Vtemp_post{i}{k} = tsd(Range(a{i}.behavResources(id_Post{i}(k)).Vtsd),...
                        (Data(a{i}.behavResources(id_Post{i}(k)).Vtsd)./...
                        ([diff(a{i}.behavResources(id_Post{i}(k)).PosMat(:,1));-1])));
                else
                    Vtemp_post{i}{k}=Data(a{i}.behavResources(id_Post{i}(k)).Vtsd);
                end
                VZone_post{i}{k}=Vtemp_post{i}{k}(a{i}.behavResources(id_Post{i}(k)).ZoneIndices{2}(1:end-1),1);
                VZmean_post(i,k)=mean(VZone_post{i}{k},1);
            end
        end
        
    end

Pre_VZmean_mean = mean(VZmean_pre,2);
Pre_VZmean_std = std(VZmean_pre,0,2);
Post_VZmean_mean = mean(VZmean_post,2);
Post_VZmean_std = std(VZmean_post,0,2);
% Wilcoxon test
p_VZmean_pre_post = signrank(Pre_VZmean_mean, Post_VZmean_mean);
Pre_Post_VZmean = [VZmean_pre; VZmean_post]';
end

if h24
    for r=1:length(Dir_Post24.path{1})
        if h24
            % PostTesth24 ShockZone speed
            if isempty(Post24_ZoneIndices{r}{2})
                VZmean_post24(r) = 0;
            else
                Vtemp_post24{r}=Data(Post24_Vtsd{r});
                VZone_post24{r}=Vtemp_post24{r}(Post24_ZoneIndices{r}{2}(1:end-1),1);
                VZmean_post24(r)=mean(VZone_post24{r},1);
            end
        end
        
    end
    
    Pre_Post24_VZmean = [VZmean_pre; VZmean_post24]';
    Pre_Post24_VZmean_mean = mean(Pre_Post24_VZmean,1);
    Pre_Post24_VZmean_std = std(Pre_Post24_VZmean,1);
    p_VZmean_pre_post24 = signrank(VZmean_pre, VZmean_post24);
end

%% Plot the figure

% Plot Calibration
% axes(Calib_Axes);
% yyaxis left
% h1 = plot(Intensities, Freezingperc, '-ko', 'LineWidth', 2);
% hold on
% h2 = plot(Intensities, FreezingBeforeRatioSingleShot*100, 'b--o');
% hold on
% h3 = plot(Intensities, FreezingAfterRatioSingleShot*100, 'r--o');
% ylim([0 100]);
% set(gca, 'YColor', 'k');
% ylabel('%Freezing');
% yyaxis right
% h4 = plot(Intensities, AccRatio, '-mo');
% ylabel('Startle Index');
% set(gca, 'YColor', 'm');
% xlabel('Intensities in V');
% xlim([0 8.5]);
% title('Calibration');
% legend([h1 h2 h3 h4], 'Overall freezing', 'Freezing before the first stim', 'Freezing after the first stim', 'Startle Index',...
%     'Location', 'SouthEast');

% Plot Contextual Memory
if contextual
    axes(ContextMemory_Axes);
    bar(FreezingpercMemo);
    set(gca,'Xtick',[1:2],'XtickLabel', {'ContextA (Neutral)', 'ContextB (Aversive)'});
    title('Contextual Memory');
    ylabel('%Freezing');
    ylim([0 100]);
    lg = legend('Day1', 'Day2');
end

% Anatomy figure
axes(Anatomy_Axes);
imshow(figpath, 'InitialMagnification', 'fit');
title('PAG position');

% Trajectories in PreTests
if Avoidance
    axes(TrajPreTest_Axes);
    imagesc(a{1}.behavResources(id_Pre{1}(1)).mask);
    colormap(gray)
    hold on
    imagesc(a{1}.behavResources(id_Pre{1}(1)).Zone{1}, 'AlphaData', 0.3);
    hold on
    for p=1:1:length(id_Pre{1})
        plot(a{1}.behavResources(id_Pre{1}(p)).PosMat(:,2)*...
            a{1}.behavResources(id_Pre{1}(p)).Ratio_IMAonREAL,...
            a{1}.behavResources(id_Pre{1}(p)).PosMat(:,3)*...
            a{1}.behavResources(id_Pre{i}(k)).Ratio_IMAonREAL,...
            clrs{2,p},'linewidth',1.5)
        hold on
    end
    legend ('Test1','Test2','Test3','Test4', 'Location', 'NorthWest');
    set(gca, 'XTickLabel', []);
    set(gca, 'YTickLabel', []);
    title ('Trajectories during PreTests');
end

% Trajectories in Cond
if Avoidance
    axes(TrajCond_Axes);
    imagesc(a{1}.behavResources(id_Cond{1}(1)).mask);
    colormap(gray)
    hold on
    imagesc(a{1}.behavResources(id_Cond{1}(1)).Zone{1}, 'AlphaData', 0.3);
    hold on
    for p=1:1:length(id_Cond{1})
        plot(a{1}.behavResources(id_Cond{1}(p)).PosMat(:,2)*...
            a{1}.behavResources(id_Cond{1}(p)).Ratio_IMAonREAL,...
            a{1}.behavResources(id_Cond{1}(p)).PosMat(:,3)*...
            a{1}.behavResources(id_Cond{1}(1)).Ratio_IMAonREAL,...
            clrs{2,p},'linewidth',1.5)
        hold on
    end
    set(gca, 'XTickLabel', []);
    set(gca, 'YTickLabel', []);
    for p=1:1:length(id_Cond{1})
        for j = 1:length(StimT_beh{1}{p})
            if p < 4
                h1 = plot(a{1}.behavResources(id_Cond{1}(p)).PosMat(StimT_beh{1}{p}(j),2)*...
                    a{1}.behavResources(id_Cond{1}(p)).Ratio_IMAonREAL,...
                    a{1}.behavResources(id_Cond{1}(p)).PosMat(StimT_beh{1}{p}(j),3)*...
                    a{1}.behavResources(id_Cond{1}(p)).Ratio_IMAonREAL,...
                    clrs{3,p}, 'MarkerSize', 14, 'MarkerFaceColor', clrs{2,p});
                uistack(h1,'top');
            else
                h1 = plot(a{1}.behavResources(id_Cond{1}(p)).PosMat(StimT_beh{1}{p}(j),2)*...
                    a{1}.behavResources(id_Cond{1}(p)).Ratio_IMAonREAL,...
                    a{1}.behavResources(id_Cond{1}(p)).PosMat(StimT_beh{1}{p}(j),3)*...
                    a{1}.behavResources(id_Cond{1}(p)).Ratio_IMAonREAL,...
                    clrs{3,p}, 'MarkerEdgeColor', [0.1 0.4 0.3], 'MarkerSize', 14, 'MarkerFaceColor', [0.1 0.4 0.3]);
            end
            z(p) = length(StimT_beh{1}{p});
        end
    end
    title (['Trajectories during conditioning: ' num2str(sum(z)) ' stims']);
    clear z
end

% Trajectories in PostTests
if Avoidance
    axes(TrajTestPost_Axes);
    imagesc(a{1}.behavResources(id_Post{1}(1)).mask);
    colormap(gray)
    hold on
    imagesc(a{1}.behavResources(id_Post{1}(1)).Zone{1}, 'AlphaData', 0.3);
    hold on
    for l=1:1:length(id_Post{1})
        plot(a{1}.behavResources(id_Post{1}(l)).PosMat(:,2)*...
            a{1}.behavResources(id_Post{1}(l)).Ratio_IMAonREAL,...
            a{1}.behavResources(id_Post{1}(l)).PosMat(:,3)*...
            a{1}.behavResources(id_Post{1}(l)).Ratio_IMAonREAL,...
            clrs{2,l},'linewidth',1.5)
        hold on
    end
    set(gca, 'XTickLabel', []);
    set(gca, 'YTickLabel', []);
    title ('Trajectories during PostTests (after 2-3h of sleep)');
end


% Occupancy BarPlot
if Avoidance
    axes(OccupPost_Axes);
    bar([Pre_Occup_mean Post_Occup_mean], 'FaceColor', [0 0.4 0.4], 'LineWidth',3)
    hold on
    errorbar([Pre_Occup_mean Post_Occup_mean], [Pre_Occup_std Post_Occup_std],'.', 'Color', 'r');
    hold on
    for k = 1:length(id_Post{1})
        plot([1 2],point_pre_post(k,:), ['-' clrs{1,k}], 'MarkerFaceColor','white', 'LineWidth',1.8);
    end
    hold on
    set(gca,'Xtick',[1,2],'XtickLabel',{'PreTest', 'PostTest'})
    ylabel('% time spent')
    xlim([0.5 2.5])
    if p_pre_post < 0.05
        H = sigstar({{'PreTest', 'PostTest'}}, p_pre_post);
    end
    hold off
    box off
    title ('Percentage of occupancy', 'FontSize', 10);

    %Number of entries into the shock zone BarPlot
    axes(TimePost_Axes);
    bar([Pre_entnum_mean Post_entnum_mean] , 'FaceColor', [0 0.4 0.4], 'LineWidth',3)
    hold on
    errorbar([Pre_entnum_mean Post_entnum_mean], [Pre_entnum_std Post_entnum_std],'.', 'Color', 'r');
    hold on
    for g = 1:length(id_Post{1})
        plot([1 2],Pre_Post_entnum(g,:), ['-' clrs{1,g}], 'MarkerFaceColor','white', 'LineWidth',1.8);
    end
    hold on
    set(gca,'Xtick',[1,2],'XtickLabel',{'PreTest', 'PostTest'})
    ylabel('Number of entries')
    xlim([0.5 2.5])
    if p_entnum_pre_post < 0.05
        H = sigstar({{'PreTest', 'PostTest'}}, p_entnum_pre_post);
    end
    box off
    hold off
    title ('# of entries to the shockzone', 'FontSize', 10);

    % First time to enter the shock zone BarPlot
    axes(FirstPost_Axes);
    bar([Pre_FirstTime_mean Post_FirstTime_mean], 'FaceColor', [0 0.4 0.4], 'LineWidth',3)
    hold on
    errorbar([Pre_FirstTime_mean Post_FirstTime_mean], [Pre_FirstTime_std Post_FirstTime_std],'.', 'Color', 'r');
    hold on
    for g = 1:length(id_Post{1})
        plot([1 2],Pre_Post_FirstTime(g,:), ['-' clrs{1,g}], 'MarkerFaceColor','white', 'LineWidth',1.8);
    end
    hold on
    set(gca,'Xtick',[1,2],'XtickLabel',{'PreTest', 'PostTest'})
    ylabel('Time (s)')
    xlim([0.5 2.5])
    if p_FirstTime_pre_post < 0.05
        H = sigstar({{'PreTest', 'PostTest'}}, p_FirstTime_pre_post);
    end
    box off
    hold off
    title ('First time to enter the shockzone', 'FontSize', 10);

    % Average speed into the safe zone BarPlot
    axes(SpeedPost_Axes);
    bar([Pre_VZmean_mean Post_VZmean_mean], 'FaceColor', [0 0.4 0.4], 'LineWidth',3)
    hold on
    errorbar([Pre_VZmean_mean Post_VZmean_mean], [Pre_VZmean_std Post_VZmean_std],'.', 'Color', 'r');
    hold on
    for g = 1:length(id_Post{1})
        plot([1 2],Pre_Post_VZmean(g,:), ['-' clrs{1,g}], 'MarkerFaceColor','white', 'LineWidth',1.8);
    end
    hold on
    set(gca,'Xtick',[1,2],'XtickLabel',{'PreTest', 'PostTest'})
    ylabel('Average speed (cm/s)')
    xlim([0.5 2.5])
    if p_VZmean_pre_post < 0.05
        H = sigstar({{'PreTest', 'PostTest'}}, p_VZmean_pre_post);
    end
    box off
    hold off
    title ('Average speed in the SafeZone', 'FontSize', 10);
end

if h24
    % Trajectories in PostTests  h24 later
    axes(TrajTestPost24_Axes);
    imagesc(Post24_mask);
    colormap(gray)
    hold on
    imagesc(Post24_Zone{1}, 'AlphaData', 0.3);
    hold on
    for l=1:1:length(Dir_Post24.path{1})
        plot(Post24_PosMat{l}(:,2)*Post24_Ratio_IMAonREAL,Post24_PosMat{l}(:,3)*Post24_Ratio_IMAonREAL,...
            clrs{2,l},'linewidth',1.5)
        hold on
    end
    title ('Trajectories h24 later');
    set(gca, 'XTickLabel', []);
    set(gca, 'YTickLabel', []);

    % Occupancy BarPlot h24 later
    axes(OccupPost24_Axes);
    bar([Pre_Occup_mean(1) Post24_Occup_mean(1)], 'FaceColor', [0 0.4 0.4], 'LineWidth',3)
    hold on
    errorbar([Pre_Occup_mean(1) Post24_Occup_mean(1)], [Pre_Occup_std(1) Post24_Occup_std(1)],'.', 'Color', 'r');
    hold on
    for k = 1:length(Dir_Post24.path{1})
        plot([1 2],point_pre_post24(k,:), ['-' clrs{1,k}], 'MarkerFaceColor','white', 'LineWidth',1.8);
    end
    hold on
    set(gca,'Xtick',[1,2],'XtickLabel',{'PreTest', 'h24 later'})
    ylabel('% time spent')
    xlim([0.5 2.5])
    if p_pre_post24 < 0.05
        H = sigstar({{'PreTest', 'h24 later'}}, p_pre_post24);
    end
    hold off
    box off
    title ('Percentage of occupancy', 'FontSize', 10);

    %Number of entries into the shock zone BarPlot
    axes(TimePost24_Axes);
    bar([Pre_Post24_entnum_mean(1) Pre_Post24_entnum_mean(2)], 'FaceColor', [0 0.4 0.4], 'LineWidth',3)
    hold on
    errorbar(Pre_Post24_entnum_mean, Pre_Post24_entnum_std,'.', 'Color', 'r');
    hold on
    for g = 1:length(Dir_Post24.path{1})
        plot([1 2],Pre_Post24_entnum(g,:), ['-' clrs{1,g}], 'MarkerFaceColor','white', 'LineWidth',1.8);
    end
    hold on
    set(gca,'Xtick',[1,2],'XtickLabel',{'PreTest', 'h24 later'})
    ylabel('Number of entries')
    xlim([0.5 2.5])
    if p_entnum_pre_post24 < 0.05
        H = sigstar({{'PreTest', 'h24 later'}}, p_entnum_pre_post24);
    end
    box off
    hold off
    title ('# of entries to the shockzone', 'FontSize', 10);

    % First time to enter the shock zone BarPlot
    axes(FirstPost24_Axes);
    bar([Pre_Post24_FirstTime_mean(1) Pre_Post24_FirstTime_mean(2)], 'FaceColor', [0 0.4 0.4], 'LineWidth',3)
    hold on
    errorbar(Pre_Post24_FirstTime_mean, Pre_Post24_FirstTime_std,'.', 'Color', 'r');
    hold on
    for g = 1:length(Dir_Post24.path{1})
        plot([1 2],Pre_Post24_FirstTime(g,:), ['-' clrs{1,g}], 'MarkerFaceColor','white', 'LineWidth',1.8);
    end
    hold on
    set(gca,'Xtick',[1,2],'XtickLabel',{'PreTest', 'h24 later'})
    ylabel('Time (s)')
    xlim([0.5 2.5])
    if p_FirstTime_pre_post24 < 0.05
        H = sigstar({{'PreTest', 'h24 later'}}, p_FirstTime_pre_post24);
    end
    box off
    hold off
    title ('First time to enter the shockzone', 'FontSize', 10);

    % Average speed into the shock zone BarPlot
    axes(SpeedPost24_Axes);
    bar([Pre_Post24_VZmean_mean(1) Pre_Post24_VZmean_mean(2)], 'FaceColor', [0 0.4 0.4], 'LineWidth',3)
    hold on
    errorbar(Pre_Post24_VZmean_mean, Pre_Post24_VZmean_std,'.', 'Color', 'r');
    hold on
    for g = 1:length(Dir_Post24.path{1})
        plot([1 2],Pre_Post24_VZmean(g,:), ['-' clrs{1,g}], 'MarkerFaceColor','white', 'LineWidth',1.8);
    end
    hold on
    set(gca,'Xtick',[1,2],'XtickLabel',{'PreTest', 'h24 later'})
    ylabel('Average speed (cm/s)')
    xlim([0.5 2.5])
    if p_VZmean_pre_post24 < 0.05
        H = sigstar({{'PreTest', 'h24 later'}}, p_VZmean_pre_post24);
    end
    box off
    hold off
    title ('Average speed in the ShockZone', 'FontSize', 10);
end


%% Save
if sav
    saveas(gcf, [dir_out 'M' num2str(nmouse) '_' fig_post '.fig']);
    saveFigure(gcf,['M' num2str(nmouse) '_' fig_post],dir_out);
end

%% Clear
clear