function Figure_SleepScoring_OBGamma_Delta(foldername)

%% Initiation
if nargin < 1
    foldername = pwd;
end
if foldername(end)~=filesep
    foldername(end+1) = filesep;
end

% colors for plotting
Colors.S1 = 'r';
Colors.S2 = [1, 0.67, 0];
Colors.Wake = 'b';
Colors.Noise = [0 0 0];

% Variables that indicate if specta exist
SpecOk.OB = 0;
SpecOk.UL = 0;

% load sleep scoring info
load([foldername 'SleepScoring_OBGamma'])


%% Load OB spectrum
if exist([foldername,'B_High_Spectrum.mat'])>0
    load([foldername,'B_High_Spectrum.mat']);

    % Smooth the spectrum for visualization:
    datb = Spectro{1};
    clear datbnew
    
    for k = 1:size(datb,2)
        datbnew(:,k) = runmean(datb(:,k),100);
    end
    
    % make tsd
    sptsdB=tsd(Spectro{2}*1e4,datbnew);
    fB=Spectro{3};
    clear Spectro
    
    % get caxis lims
    CMax.OB = max(max(Data(Restrict(sptsdB,Epoch))))/1.25e3;
    CMin.OB = min(min(Data(Restrict(sptsdB,Epoch))))*1.2;
    
    SpecOk.OB = 1;
end

%% Load ultralow spectrum
if exist([foldername,'B_Low_Spectrum.mat'])>0
    load([foldername,'B_Low_Spectrum.mat']);

    sptsdUL=tsd(Spectro{2}*1e4,Spectro{1});
    fUl=Spectro{3};
    clear Spectro
    
    CMax.UL = max(max(Data(Restrict(sptsdUL,Epoch))))/4e5;
    CMin.UL = min(min(Data(Restrict(sptsdUL,Epoch))))*0.7e1;
       
    SpecOk.UL = 1;
end

%% Gamma and 0.1-0.5Hz power: restrict to non-noisy epoch
SmoothGammaNew=Restrict(SmoothGamma,Epoch);
Smooth_Delta_new=Restrict(smooth_delta,Epoch);

%% Gamma and 0.1-0.5Hz power: subsample to same bins (need to think about this)
t=Range(Smooth_Delta_new);
ti=t(5:1200:end);
SmoothGammaNew=(Restrict(SmoothGammaNew,ts(ti)));
Smooth_Delta_new=(Restrict(Smooth_Delta_new,ts(ti)));

%% Beginning and end of session
try
    begin=Start(Epoch)/1e4;
    begin=begin(1);
    endin=Stop(Epoch)/1e4;
    endin=endin(end);
catch
    begin=t(1)/1e4;
    endin=t(end)/1e4;
end

%% Plot figure
% create figure
SleepScoringFigureOB_Delta = figure;
set(SleepScoringFigureOB_Delta,'color',[1 1 1],'Position',[1 1 1600 600])

% 0.1-0.5Hz spectrum
subplot(6,3,[1:2,4:5])
if SpecOk.UL
    
    imagesc(Range(sptsdUL,'s'),fUl,10*log10(Data(sptsdUL))'), axis xy, caxis([40 65]);
    
    hold on
    % Lines to indicate epochs
    LineHeight = 19;
    
    line([begin endin],[LineHeight LineHeight],'linewidth',10,'color','w')
    PlotPerAsLine(NREM,LineHeight,Colors.S1);
    PlotPerAsLine(IS,LineHeight,Colors.S2);
    PlotPerAsLine(Wake,LineHeight,Colors.Wake);
    PlotPerAsLine(TotalNoiseEpoch,LineHeight,Colors.Noise);
    
    xlim([begin endin])
    set(gca,'XTick',[])
    title('Olfactory Bulb 0.5-4 Hz')
    ylabel('Frequency, Hz')
    
    f0 = subplot(6,3,[7:8]);
    plot(Range(Smooth_Delta_new,'s'),Data(Smooth_Delta_new),'linewidth',1,'color','k')
    xlim([begin endin])
    set(gca,'XTick',[])
    ylabel('0.5-4 Hz power')
    title('Signal in 0.5-4 Hz range')
end


% OB spectrum
subplot(6,3,[10:11,13:14]);

if SpecOk.OB
    
    imagesc(Range(sptsdB,'s'),fB,10*log10(Data(sptsdB))'), axis xy, caxis([20 45]);

    hold on
    % Lines to indicate epochs
    LineHeight = 95;
    line([begin endin],[LineHeight LineHeight],'linewidth',10,'color','w')
    PlotPerAsLine(NREM,LineHeight,Colors.S1);
    PlotPerAsLine(IS,LineHeight,Colors.S2);
    PlotPerAsLine(Wake,LineHeight,Colors.Wake);
    PlotPerAsLine(TotalNoiseEpoch,LineHeight,Colors.Noise);
    xlim([begin endin])
    set(gca,'XTick',[])
    title('Olfactory Bulb 40-60 Hz (γ)')
    ylabel('Frequency, Hz')

    
    % Gamma power trace 
    subplot(6,3,[16:17])
    plot(Range(SmoothGammaNew,'s'),Data(SmoothGammaNew),'linewidth',1,'color','k')
    xlim([begin endin])
    title('Signal in gamma range (40-60 Hz)')
    ylabel('Gamma power')
    xlabel('Time (s)')
        xlabel('Time (s)')

    clear sptsdH sptsdH sptsdUL datB
end


% phase space
subplot(6,12,[22:24,34:36,46:48])
hold on

% S1
Smooth_Delta_S1 = (Restrict(Smooth_Delta_new,and(Epoch,NREM)));
Smooth_Gamma_S1 = Restrict(SmoothGammaNew,ts(Range(Smooth_Delta_S1)));
plot(log(Data(Smooth_Gamma_S1)),log(Data(Smooth_Delta_S1)),'.','color', Colors.S1,'MarkerSize',1);

% S2
Smooth_Delta_S2 = (Restrict(Smooth_Delta_new,and(Epoch,IS)));
Smooth_Gamma_S2 = Restrict(SmoothGammaNew,ts(Range(Smooth_Delta_S2)));
plot(log(Data(Smooth_Gamma_S2)),log(Data(Smooth_Delta_S2)),'.','color', Colors.S2,'MarkerSize',1);

% Wake
Wake_Delta = (Restrict(Smooth_Delta_new,Wake));
Smooth_Gamma_Wake = Restrict(SmoothGammaNew,ts(Range(Wake_Delta)));
plot(log(Data(Smooth_Gamma_Wake)),log(Data(Wake_Delta)),'.','color', Colors.Wake,'MarkerSize',1);

legend('S1','S2','Wake')
findobj(gcf,'tag','legend');
[~,icons,~,~] = legend('S1','S2','Wake');
set(icons(5),'MarkerSize',20)
set(icons(7),'MarkerSize',20)
set(icons(9),'MarkerSize',20)

axphase=gca;
ys=get(axphase,'Ylim');
xs=get(axphase,'Xlim');
box on
set(gca,'XTick',[],'YTick',[])

% Histogram of 0.1-0.5Hz values
subplot(6,12,[21,33,45]), hold on
[theText, rawN, x] =nhist(log(Data(Restrict(smooth_Delta,Sleep))),'maxx',max(log(Data(Restrict(smooth_Delta,Sleep)))),'noerror','xlabel','0.1-0.5 Hz power OB','ylabel',[]); axis xy
line([log(Info.thresh_Delta) log(Info.thresh_Delta)],[0 max(rawN)],'linewidth',4,'color','r')
view(90,-90)
set(gca,'YTick',[],'Xlim',ys)

% Histogram of gamma values
subplot(6,12,[58:60]), hold on
[theText, rawN, x] =nhist(log(Data(SmoothGamma)),'maxx',max(log(Data(SmoothGamma))),'noerror','xlabel','Gamma power','ylabel',[]);
line([log(Info.gamma_thresh) log(Info.gamma_thresh)],[0 max(rawN)],'linewidth',4,'color','r')
set(gca,'YTick',[],'Xlim',xs)

FigureName = 'SleepScoringOB_Delta';

% Save figure
try
    saveFigure(SleepScoringFigureOB_Delta,FigureName,foldername)
catch
    saveFigure(SleepScoringFigureOB_Delta.Number,FigureName,foldername)
end

end