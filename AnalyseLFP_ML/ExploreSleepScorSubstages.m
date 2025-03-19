function ExploreSleepScorSubstages(dir)

% ActimetrySleepScorCompar.m
%
% plot results from 3 types of sleep scoring :
%   - sleepscoringML.m (StateEpoch.mat)
%   - BulbSleepScriptGL.m (StateEpochSB.mat and B_High_Spectrum.mat)
%   - ActiToData.m (Actimeter.mat)
%
% other related scripts and functions :
%   - ActimetrySleepScorCompar.m

%% argin
if ~exist('dir','var')
    dir=pwd;
end

cd(dir)
saveFolder='/home/mobsyoda/Dropbox/MOBs_ProjetAstro/FIGURES/FigureNovembre2015/';
%saveFolder=pwd;

%% variables
Spectro={};
Mmov=tsd([],[]);
ThetaRatioTSD=Mmov;
I=intervalSet([],[]);
TotalNoiseEpoch=I;
SWS=I;
REM=I;
SWSEpoch=I;
REMEpoch=I;
SLEEPuMvtEpoch=I;
ThetaEpoch=I;
lookInStateEpoch=0;
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
%% load StateEpoch, spectrogram
disp('...Loading StateEpoch.mat for sleepscoringML')
try 
    load('StateEpochSubStages.mat','lookInStateEpoch','Mmov','TotalNoiseEpoch','MovEpoch',...
        'SWS','REM','SWSEpoch','REMEpoch','SLEEPuMvtEpoch','ThetaRatioTSD','ThetaEpoch'); 
    if lookInStateEpoch
        load('StateEpoch.mat','Spectro');
    end
end

ratio_display_mov=(max(Data(ThetaRatioTSD))-min(Data(ThetaRatioTSD)))/(max(Data(Mmov))-min(Data(Mmov)));

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


%% display spectrogram
Sp=Spectro{1};
t=Spectro{2};
f=Spectro{3};

subplot(5,1,1:2),imagesc(t,f,10*log10(Sp)'), axis xy, caxis([20 65]);
title(['SleepscoringML (Spectrogramm from dHPC) - ',pwd]); 
colormap jet; xl=[0 max(t)]; xlim(xl);


%% prepare display movements and epochs

% --------- prepare Display Noise ---------
MatD=nan(ceil(1E4/mean(diff(Range(Mmov,'s')))),length(Start(TotalNoiseEpoch)));
MatT=MatD;
for s=1:length(Start(TotalNoiseEpoch))
    temp=Restrict(Mmov,subset(TotalNoiseEpoch,s));
    MatD(1:length(Range(temp)),s)=Data(temp);
    MatT(1:length(Range(temp)),s)=Range(temp,'s');
end
NoiseMat=[MatT(:),MatD(:)];

% --------- prepare Display SWS ---------
MatD=nan(ceil(1E4/mean(diff(Range(Mmov,'s')))),length(Start(SWS)));
MatT=MatD;
for s=1:length(Start(SWS))
    temp=Restrict(Mmov,subset(SWS,s));
    MatD(1:length(Range(temp)),s)=Data(temp);
    MatT(1:length(Range(temp)),s)=Range(temp,'s');
end
SwsMat=[MatT(:),MatD(:)];

% --------- prepare Display REM ---------
MatD=nan(ceil(1E4/mean(diff(Range(Mmov,'s')))),length(Start(REM)));
MatT=MatD;
for s=1:length(Start(REM))
    temp=Restrict(Mmov,subset(REM,s));
    MatD(1:length(Range(temp)),s)=Data(temp);
    MatT(1:length(Range(temp)),s)=Range(temp,'s');
end
RemMat=[MatT(:),MatD(:)];

% --------- prepare Display Noise ---------
MatD=nan(ceil(1E4/mean(diff(Range(Mmov,'s')))),length(Start(SLEEPuMvtEpoch)));
MatT=MatD;
for s=1:length(Start(SLEEPuMvtEpoch))
    temp=Restrict(Mmov,subset(SLEEPuMvtEpoch,s));
    MatD(1:length(Range(temp)),s)=Data(temp);
    MatT(1:length(Range(temp)),s)=Range(temp,'s');
end
uMvtMat=[MatT(:),MatD(:)];

%% display movements and epochs

subplot(5,1,3), plot(Range(Restrict(ThetaRatioTSD,ThetaEpoch),'s'),Data(Restrict(ThetaRatioTSD,ThetaEpoch)),'r.');
hold on, plot(Range(ThetaRatioTSD,'s'),Data(ThetaRatioTSD),'k'); xlim([0,max(Range(ThetaRatioTSD,'s'))]);
title('Theta/Delta Ratio, ThetaEpoch in red')
xlim([0 max(t)]);

subplot(5,1,4), 
plot(Range(Mmov,'s'),Data(Mmov),'b');
hold on, plot(NoiseMat(:,1),NoiseMat(:,2),'w')
hold on, plot(SwsMat(:,1),SwsMat(:,2),'r')
hold on, plot(RemMat(:,1),RemMat(:,2),'g')
hold on, plot(uMvtMat(:,1),uMvtMat(:,2),'c')
title('SleepMicroMovement=cyan, SWS=red, REM=green');
xlim([0 max(t)]);


%% display polysomno
%
subplot(5,1,5),hold on, 
PlotPolysomnoML(I,and(SWSEpoch,SLEEPuMvtEpoch),SWSEpoch,REMEpoch,MovEpoch,1);
title('PlotPolysomnoML'); legend({'SleepStages','Mov','REM','SWS','uMvt'})


% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
%% function InputXlim
    function InputXlim(obj,event)
        answer = inputdlg({'xlim start (s)','duration (s)'},'define xlim',1,{'0','100'});
        if ~isempty(answer)
            xl=str2double(answer{1})+[0,str2double(answer{2})];
            subplot(5,1,1:2), xlim(xl);
            subplot(5,1,3),xlim(xl);%ylim([-1 2])
            subplot(5,1,4),xlim(xl);%ylim([-1 2])
            subplot(5,1,5),xlim(xl);ylim([-1 5])
            %if nsub, subplot(4+nsub,1,5),xlim(xl);end;%ylim([-1 2])
        end
    end
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
%% function ginputXlim
    function ginputXlim(obj,event)
        a=ginput(2);
        xl=[a(1,1),a(2,1)];
        subplot(5,1,1:2), xlim(xl);
        subplot(5,1,3),xlim(xl);%ylim([-1 2])
        subplot(5,1,4),xlim(xl);%ylim([-1 10])
        subplot(5,1,5),xlim(xl);ylim([-1 5])
        %if nsub, subplot(4+nsub,1,5),xlim(xl);end; %ylim([-1 2])
    end

% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
%% function resetXlim
    function resetXlim(obj,event)
        xl=[0 max(t)];
        subplot(5,1,1:2), xlim(xl);
        subplot(5,1,3),xlim(xl);%ylim([-1 2])
        subplot(5,1,4),xlim(xl);%ylim([-1 10])
        subplot(5,1,5),xlim(xl);ylim([-1 5])
        %if nsub, subplot(4+nsub,1,5),xlim(xl);ylim([-1 2]);end
    end

% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
%% function saveFig
    function saveFig(obj,event)
       namefig=inputdlg({'Name of Figure'},'Name figure',1,{'SleepScorMouse100-date'});
       saveFigure(FigActi,namefig{1},saveFolder);
       disp([namefig{1},'.png and .eps has been saved in current path'])
    end

end