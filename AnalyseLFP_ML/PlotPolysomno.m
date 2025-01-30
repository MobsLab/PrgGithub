
function [Epochs,nameEpochs,fac]=PlotPolysomno(N1,N2,N3,SWS,REM,WAKE,numF,legT)

% [Epochs,nameEpochs,fac]=PlotPolysomnoML(N1,N2,N3,SWS,REM,WAKE,numF,legT)
%
% inputs:
% intervalSets from AnalyseNREMsubstagesML.m
% respect order
% N1 = light SWS, N2 = deeper, N3 = deep SWS/ delta burst period
% numF (optional) = 1 to include in existing figure, 0 otherwise (default)
%
% outputs:
% WAKE=4, REM=3, N1=2, N2=1.5, N3=1, undetermined/noise=0
% Epochs={WAKE,REM,N1,N2,N3};
% nameEpochs={'WAKE','REM','N1','N2','N3'};
% fac=[4 3 2 1.5 1]; values corresponding to each stage (0 for undefined)

if ~exist('numF','var')
    numF=0;
else
    if ~isnumeric(numF), numF=numF.Number;end
end
% scale for plot
if exist('legT','var') && strcmp(legT,'h'), facT=3600; % in hours
elseif exist('legT','var') && strcmp(legT,'min'), facT=60; % in minutes
else, legT='s'; facT=1; % in seconds (default)
end

%%
nameEpochs={'WAKE','REM','N1','N2','N3'};
Rec=or(or(SWS,REM),WAKE);
Epochs={WAKE,REM,N1,N2,N3};
fac=[5 4 3 2 1];

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<< PLOT SUBSTAGES <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% see PlotPolysomnoML.m

indtime=min(Start(Rec)):500:max(Stop(Rec));
timeTsd=tsd(indtime,zeros(length(indtime),1));
SleepStages=zeros(1,length(Range(timeTsd)))+4.5;
rg=Range(timeTsd);

for ep=1:length(Epochs)
    id=find(ismember(rg,Range(Restrict(timeTsd,Epochs{ep})))==1);
    SleepStages(id)=fac(ep);
end
SleepStages=tsd(rg,SleepStages');

if numF==0, figure('color',[1 1 1]);end
hold on, plot(Range(SleepStages,'s')/facT,Data(SleepStages),'k')

line([Start(Epochs{2},legT),Stop(Epochs{2},legT)],[1 1]*fac(2),'Color','k','linewidth',7);
legend([{'SleepStages'},'REM'])
try xlim([0 max(Range(SleepStages,'s')/facT)]); end
ylim([0.5 6]); set(gca,'Ytick',1:5); set(gca,'YtickLabel',nameEpochs(fac))
title(pwd); xlabel(['Time (',legT,')'])


