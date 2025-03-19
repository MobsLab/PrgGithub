function ActimetrySleepScorCompar(dir,DoAD)

% ActimetrySleepScorCompar.m
%
% plot results from 3 types of sleep scoring :
%   - sleepscoringML.m (StateEpoch.mat)
%   - BulbSleepScriptGL.m (StateEpochSB.mat and B_High_Spectrum.mat)
%   - ActiToData.m (Actimeter.mat)
%
% other related scripts and functions :
%   - AnalyseActimeterML.m 
%   - ActimetryQuantifSleep.m
%   - PoolDataActi.m
%   - GetAllDataActi.m
%   - an_actiML.m

%% argin
if ~exist('dir','var')
    dir=pwd;
end

if ~exist('DoAD','var')
    DoAD=0;
end

cd(dir)
if DoAD, nsub=1; else nsub=0;end
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
%% generate figure interface
FigActi=figure('color',[1 1 1],'units','normalized','position',[0.1 0.08 0.5 0.7]);
uicontrol(FigActi,'style','pushbutton',...
    'units','normalized','position',[0.05 0.8 0.05 0.05],...
    'string','xlim','callback', @InputXlim);
uicontrol(FigActi,'style','pushbutton',...
    'units','normalized','position',[0.05 0.7 0.05 0.05],...
    'string','xmin xmax','callback', @ginputXlim);
uicontrol(FigActi,'style','pushbutton',...
    'units','normalized','position',[0.05 0.6 0.05 0.05],...
    'string','reset lim','callback', @resetXlim);
uicontrol(FigActi,'style','pushbutton',...
    'units','normalized','position',[0.05 0.3 0.05 0.05],...
    'string','SaveFigure','callback', @saveFig);

% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
%% StateEpoch, spectrogram
clear REMEpoch SWSEpoch Spectro
disp('...Loading StateEpoch.mat for sleepscoringML')
load StateEpoch REMEpoch SWSEpoch Spectro Mmov
Sp=Spectro{1};
t=Spectro{2};
f=Spectro{3};

subplot(4+nsub,1,1:2),imagesc(t,f,10*log10(Sp)'), axis xy, caxis([20 65]);
title(['SleepscoringML (Spectrogramm from dHPC) - ',pwd]); 
colormap jet; xl=[0 max(t)]; xlim(xl);


%% StateEpoch, movements and epochs
subplot(4+nsub,1,3), plot(Range(Mmov,'s'),rescale(double(Data(Mmov)),-1,2),'k')
repart=ones(size(t));
for si=1:length(Start(SWSEpoch))
    repart(t>=Start(subset(SWSEpoch,si),'s') & t<Stop(subset(SWSEpoch,si),'s'))=0;
end
for si=1:length(Start(REMEpoch))
    repart(t>=Start(subset(REMEpoch,si),'s') & t<Stop(subset(REMEpoch,si),'s'))=-0.2;
end

hold on, plot(t,repart,'-r','Linewidth',1.2); xlim(xl);
title('SleepscoringML  (Movements from videotracking)')


% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
%% StateEpochSB, spectrogram
clear REMEpoch SWSEpoch MovEpoch Spectro

disp('...Loading StateEpochSB.mat for sleepscoringSB')
load B_High_Spectrum Spectro
load StateEpochSB REMEpoch SWSEpoch
Sp=sum(Spectro{1}(1:10:end,:),2);
t=Spectro{2}(1:10:end);

%% StateEpochSB, epochs
subplot(4+nsub,1,4), plot(t,rescale(Sp,-1,2),'k')
repart=ones(size(t));
for si=1:length(Start(SWSEpoch))
    repart(t>=Start(subset(SWSEpoch,si),'s') & t<Stop(subset(SWSEpoch,si),'s'))=0;
end
for si=1:length(Start(REMEpoch))
    repart(t>=Start(subset(REMEpoch,si),'s') & t<Stop(subset(REMEpoch,si),'s'))=-0.2;
end

hold on, plot(t,repart,'-r','Linewidth',1.2); xlim(xl);
title('SleepscoringSB  (sum gamma spectro from Bulb)')

% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
%% SleepScoringAD actimetry 
if DoAD
    disp('...Loading Actimeter.mat for ScoringAD')
    clear ActiData ActiScoring
    load Actimeter ActiData ActiScoring
    
    ActiTSD=tsd(1E4*(ActiData(:,1)-ActiData(1,1)),ActiData(:,2));
    FilActi=FilterLFP(ActiTSD,[1 40],1024);
    HilActi=abs(hilbert(Data(FilActi)));
    
    subplot(4+nsub,1,5),
    plot(Range(FilActi,'s'),rescale(HilActi,-1,2),'k')
    hold on, plot(ActiScoring(:,1)-ActiScoring(1,1),rescale(ActiScoring(:,2),0,1),'-r','Linewidth',1.2)
    xlim(xl);
    title('Actimetry scoringAD (movements frequency)')
end

% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
%% function InputXlim
    function InputXlim(obj,event)
        answer = inputdlg({'xlim start (s)','duration (s)'},'define xlim',1,{'0','100'});
        if ~isempty(answer)
            xl=str2double(answer{1})+[0,str2double(answer{2})];
            subplot(4+nsub,1,1:2), xlim(xl);
            subplot(4+nsub,1,3),xlim(xl);%ylim([-1 2])
            subplot(4+nsub,1,4),xlim(xl);%ylim([-1 2])
            if nsub, subplot(4+nsub,1,5),xlim(xl);end;%ylim([-1 2])
        end
    end
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
%% function ginputXlim
    function ginputXlim(obj,event)
        a=ginput(2);
        xl=[a(1,1),a(2,1)];
        subplot(4+nsub,1,1:2), xlim(xl);
        subplot(4+nsub,1,3),xlim(xl);%ylim([-1 2])
        subplot(4+nsub,1,4),xlim(xl);%ylim([-1 2])
        if nsub, subplot(4+nsub,1,5),xlim(xl);end; %ylim([-1 2])
    end

% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
%% function resetXlim
    function resetXlim(obj,event)
        xl=[0 max(t)];
        subplot(4+nsub,1,1:2), xlim(xl);
        subplot(4+nsub,1,3),xlim(xl);ylim([-1 2])
        subplot(4+nsub,1,4),xlim(xl);ylim([-1 2])
        if nsub, subplot(4+nsub,1,5),xlim(xl);ylim([-1 2]);end
    end

% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
%% function saveFig
    function saveFig(obj,event)
       namefig=inputdlg({'Name of Figure'},'Name figure',1,{'ActiMouse242-REM'});
       saveFigure(FigActi,namefig{1},pwd);
       disp([namefig{1},'.png and .eps has been saved in current path'])
    end

end