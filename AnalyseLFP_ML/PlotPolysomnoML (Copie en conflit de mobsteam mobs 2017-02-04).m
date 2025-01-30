%PlotPolysomnoML.m

function [SleepStages,Epochs,nameEpochs,fac]=PlotPolysomnoML(N1,N2,N3,SWS,REM,WAKE,numF,swaOB)

% [SleepStages,Epochs,nameEpochs]=PlotPolysomnoML(N1,N2,N3,SWS,REM,WAKE)
%
% inputs:
% intervalSets from AnalyseNREMsubstagesML.m
% respect order
% N1 = light SWS, N2 = deeper, N3 = deep SWS/ delta burst period
% numF (optional) = 1 to include in existing figure, 0 otherwise (default)
%
% outputs:
% WAKE=4, REM=3, N1=2, N2=1.5, N3=1, undetermined/noise=0
% SleepStages = tsd containing regular value polysomno
% Epochs={WAKE,REM,N1,N2,N3};
% nameEpochs={'WAKE','REM','N1','N2','N3'};
% fac=[4 3 2 1.5 1]; values corresponding to each stage (0 for undefined)

if ~exist('numF','var')
    numF=0;
end
if ~exist('swaOB','var') || (exist('swaOB','var') && isempty(swaOB))
    doOB=0;
else
    doOB=1;
end
% scale for plot
%facT=1; legT='s'; % in second
facT=60; legT='min';% in minutes
%facT=3600; legT='h';% in hours

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% check exculsivity and merge/drop intervals
% % % done in DefineSubStages.m
% % % REM=mergeCloseIntervals(REM,10*1E4);
% % % REM=dropShortIntervals(REM,5E4);
% % % 
% % % SWS=SWS-REM;
% % % SWS=mergeCloseIntervals(SWS,5*1E4);
% % % WAKE=WAKE-SWS-REM;
% % % WAKE=mergeCloseIntervals(WAKE,1*1E3);
% % % 
% % % N3=and(SWS,N3);
% % % N3=mergeCloseIntervals(N3,10*1E4);
% % % N3=dropShortIntervals(N3,3E4);
% % % 
% % % N1=and(SWS,N1)-N3;
% % % N1=mergeCloseIntervals(N1,5*1E4);
% % % N1=dropShortIntervals(N1,3E4);
% % % N1=N1-N3;
% % % 
% % % N2=SWS-N1;
% % % N2=N2-N3;
% % % N2=mergeCloseIntervals(N2,1*1E3);

if doOB
    swaOB=mergeCloseIntervals(swaOB,10*1E4);
    swaOB=dropShortIntervals(swaOB,3E4);
end

%%
nameEpochs={'WAKE','REM','N1','N2','N3'};
Rec=or(or(SWS,REM),WAKE);
Epochs={WAKE,REM,N1,N2,N3};
fac=[4 3 2 1.5 1];

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% disp length periods
for ep=length(Epochs):-1:1
    disp([nameEpochs{ep},' = ',num2str(floor(sum(Stop(Epochs{ep},'s')-Start(Epochs{ep},'s')))),'s'])
end
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<< PLOT SUBSTAGES <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% see PlotPolysomnoML.m
if 1
    %colori=[0.5 0.2 0.1; 0.1 0.7 0 ; 0.8 0 0.7 ; 1 0 1 ; 0.7 0.2 0.8; ]; %1 0.5 1;
    colori=[0.5 0.2 0.1; 0.1 0.7 0 ; 0.5 0.3 1; 1 0.5 1 ;0.8 0 0.7 ];
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
    for ep=1:length(Epochs)
        plot(Range(Restrict(SleepStages,Epochs{ep}),'s')/facT,Data(Restrict(SleepStages,Epochs{ep})),'.','Color',colori(ep,:));
    end
    legend([{'SleepStages'},nameEpochs])
    xlim([0 max(Range(SleepStages,'s')/facT)]); 
    if numF==0, ylim([0.5 5]); set(gca,'Ytick',[]);end
    title(pwd); xlabel(['Time (',legT,')'])
end

if doOB
    OBtsd=zeros(1,length(Range(timeTsd)));
    id=find(ismember(rg,Range(Restrict(timeTsd,swaOB)))==1);
    OBtsd(id)=0.3;
    OBtsd=tsd(rg,OBtsd');
    hold on, plot(Range(OBtsd,'s')/facT,Data(OBtsd)+4.3,'k')
    plot(Range(Restrict(OBtsd,swaOB),'s')/facT,Data(Restrict(OBtsd,swaOB))+4.3,'.b');
    legend([{'SleepStages'},nameEpochs,{'OB','swaOB'}]); 
    if numF==0, ylim([0 5]);end
end
