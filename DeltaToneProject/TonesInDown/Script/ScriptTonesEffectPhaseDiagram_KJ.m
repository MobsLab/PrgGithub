%%ScriptTonesEffectPhaseDiagram_KJ
% 17.05.2019 KJ
%
%
%   see 
%       ScriptTonesInDownOneNight


clear

%% params
step = 0.2e4; %500ms
nstep = 50;

%% load

load('SleepScoring_OBGamma.mat')
NREM = SWSEpoch;
REM = REMEpoch;
gammaTh = Info.gamma_thresh;
thetaTh = Info.theta_thresh;

%tones
load('behavResources.mat', 'ToneEvent')
tones_tmp = Range(ToneEvent);
nb_tones = length(tones_tmp);

tones_nrem = Range(Restrict(ToneEvent, NREM));
tones_rem  = Range(Restrict(ToneEvent, REM));
tones_wake = Range(Restrict(ToneEvent, Wake));


%% gamma after tones
for i=1:nstep
    %NREM
    tmp = tones_nrem + (i-1)*step;
    gammaTones.nrem{i} = log(Data(Restrict(SmoothGamma,ts(tmp))));
    %REM
    tmp = tones_rem + (i-1)*step;
    gammaTones.rem{i} = log(Data(Restrict(SmoothGamma,ts(tmp))));
    %Wake
    tmp = tones_wake + (i-1)*step;
    gammaTones.wake{i} = log(Data(Restrict(SmoothGamma,ts(tmp))));
end



%% PLOT
figure, hold on
fontsize = 16;

x_step = (0:(nstep-1))*step;

%
subplot(3,1,1), hold on
[~,h(1)]=PlotErrorLineN_KJ(gammaTones.nrem,'x_data',x_step,'newfig',0,'linecolor','b','ShowSigstar','none','errorbars',1,'linespec','-.');
subplot(3,1,2), hold on
[~,h(2)]=PlotErrorLineN_KJ(gammaTones.wake,'x_data',x_step,'newfig',0,'linecolor','r','ShowSigstar','none','errorbars',1,'linespec','-.');
subplot(3,1,3), hold on
[~,h(2)]=PlotErrorLineN_KJ(gammaTones.rem,'x_data',x_step,'newfig',0,'linecolor','g','ShowSigstar','none','errorbars',1,'linespec','-.');
xlabel('step'), ylabel('gamma')
% set(gca,'XTick',0:200:max(delay_up),'XLim',[50 max(delay_up)],'Ylim', [10 60], 'FontName','Times','Fontsize',fontsize), hold on,

