function [Stim,StartBlock,StopBlock,FreqBlock,ThreshCross1,ThreshCross2]=DetectStimSquare(LFP,reverse)

% function [Stim,StartBlock,StopBlock,FreqBlock]=DetectStimSquare(LFP,reverse);
%
% inputs: 
% - LFP = tsd of stim channel
% - reverse (optional) = 1 if neuralynx (default=0)
%
% outputs:
% - Stim = 
% - StartBlock = 
% - StopBlock = 
% - FreqBlock = 

%% Check inputs
MinInterBlock=1; % in second
plo=1;


if ~exist('LFP','var')
    error('Not enough input arguments. check help DetectStimSquare.m')
end

disp(' ')
disp('Detecting stim ... ')
if ~exist('reverse','var')
    reverse=input('Has the signal for stim been reversed (e.g. preprocessing for Neuralynx)? (y/n): ','s');
    if reverse=='y'; reverse=1; else reverse=0;end
end

%% Find time of stimulations

if reverse
    Dt=-Data(LFP);
else
    Dt=Data(LFP);
end
Ti=Range(LFP);
Thresh=min(Dt)+(max(Dt)-min(Dt))/2;

Dtplus1=[Thresh;Dt];
Dtplus0=[Dt;Thresh];
ThreshCross1=find(Dtplus0<Thresh & Dtplus1>Thresh);
ThreshCross2=find(Dtplus0>Thresh & Dtplus1<Thresh);


Stim=ts(Ti(ThreshCross1));


%% Find time of Blocks

Cross=sort([ThreshCross1;ThreshCross2]);
DifStim=diff([0;Cross]);

indexBlock=find(DifStim>MinInterBlock*1E4);
startT=Ti(Cross(indexBlock));
stopT=Ti(Cross([indexBlock(2:end)-1;length(Cross)]));
if stopT(end)>Ti(end), stopT(end)=Ti(end);end


%% Calculate frequency of stim within each block

for i=1:length(startT)
    Temp=Ti(ThreshCross1(Ti(ThreshCross1)>=startT(i) & Ti(ThreshCross1)<stopT(i)));
    freqT(i)=round(1E5/mean(diff(floor(Temp(2:end-1)))))/10;
end

Ufreq=unique(freqT(~isnan(freqT)));
disp('     Detected frequencies (Hz): ')
for i=1:length(Ufreq), disp(['       - ',num2str(Ufreq(i)),'Hz  (n=',num2str(sum(freqT==Ufreq(i))),')']);end

%% discard misetected frequencies
ok=input('     Are all frequencies expected (y/n)? ','s');
if ok~='y', 
    WantedFreq=input('     Enter real frequencies (e.g. [1 3 7 12 30]),other will be discarded: ');
    index=find(ismember(freqT,WantedFreq));
    startT=startT(index);
    stopT=stopT(index);
    freqT=freqT(index);
end


%%  Terminate

StartBlock=ts(startT);
StopBlock=ts(stopT);
FreqBlock=tsd(startT,freqT');


%% Display

if plo
    figure('Color',[1 1 1]),
    plot(Ti/1E4,Dt),
    hold on, plot(Ti(ThreshCross1)/1E4,Thresh*ones(1,length(ThreshCross1)),'b.')
    hold on, plot(Ti(ThreshCross2)/1E4,Thresh*ones(1,length(ThreshCross2)),'g.')
     
    for i=1:length(startT)
        hold on, line([startT(i)/1E4,startT(i)/1E4],[max(Dt),min(Dt)],'Color','r')
        text(startT(i)/1E4,max(Dt),[num2str(freqT(i)),'Hz'],'Color','r')
        hold on, line([stopT(i)/1E4,stopT(i)/1E4],[max(Dt),min(Dt)],'Color','k')
        if i==1, legend({'LFP','ThreshCross1','ThreshCross2','StartBlock','StopBlock'});end
    end
    xlabel('Time(s)');
end
disp('Done')

