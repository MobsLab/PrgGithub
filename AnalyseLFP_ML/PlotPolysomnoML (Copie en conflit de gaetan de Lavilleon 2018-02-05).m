%PlotPolysomnoML.m

function [SleepStages,Epochs,nameEpochs,fac]=PlotPolysomnoML(N1,N3,SWS,REM,WAKE)

% [SleepStages,Epochs,nameEpochs]=PlotPolysomnoML(N1,N3,SWS,REM,WAKE)
%
% inputs:
% intervalSets from AnalyseNREMsubstagesML.m
% respect order
% N1 = light SWS, N2 = deeper, N3 = deep SWS/ delta burst period
%
% outputs:
% SleepStages = tsd containing regular value polysomno
% Epochs={WAKE,REM,N1,N2,N3};
% nameEpochs={'WAKE','REM','N1','N2','N3'};
% fac=[4 3 2 1.5 1]; values corresponding to each stage (0 for undefined)


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% check exculsivity and merge/drop intervals
REM=mergeCloseIntervals(REM,10*1E4);
REM=dropShortIntervals(REM,5E4);

SWS=SWS-REM;
SWS=mergeCloseIntervals(SWS,5*1E4);
WAKE=WAKE-SWS-REM;

N3=and(SWS,N3);
N3=mergeCloseIntervals(N3,10*1E4);
N3=dropShortIntervals(N3,3E4);

N1=and(SWS,N1)-N3;
N1=mergeCloseIntervals(N1,5*1E4);
N1=dropShortIntervals(N1,3E4);
N1=N1-N3;

N2=SWS-N1;
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
    colori=[0.5 0.2 0.1; 0.1 0.7 0 ; 0.8 0 0.7 ; 1 0 1 ; 0.7 0.2 0.8; ]; %1 0.5 1;
    timeTsd=tsd(min(Start(Rec)):500:max(Stop(Rec)),zeros(length(min(Start(Rec)):500:max(Stop(Rec))),1));
    SleepStages=zeros(1,length(Range(timeTsd)));
    rg=Range(timeTsd);
    
    for ep=1:length(Epochs)
        id=find(ismember(rg,Range(Restrict(timeTsd,Epochs{ep})))==1);
        SleepStages(id)=fac(ep);
    end
    SleepStages=tsd(rg,SleepStages');

    figure('color',[1 1 1]),hold on,  ylim([-4.5 0.5])
    plot(Range(SleepStages,'s'),Data(SleepStages),'k')
    for ep=1:length(Epochs)
        plot(Range(Restrict(SleepStages,Epochs{ep}),'s'),Data(Restrict(SleepStages,Epochs{ep})),'.','Color',colori(ep,:));
    end
    legend([{'SleepStages'},nameEpochs])
    ylim([-3.5 0]); xlim([0 max(Range(SleepStages,'s'))]); set(gca,'Ytick',[])
end
