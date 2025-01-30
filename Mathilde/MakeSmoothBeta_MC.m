function SmoothBeta = MakeSmoothBeta_MC

% adapted from Sophie's sleep scoring algorithm (part to get the
% SmoothGamma).


%load OB LFP
foldername=pwd;
nam='Bulb_deep';
eval(['tempchOB=load([foldername,''/ChannelsToAnalyse/',nam,'''],''channel'');'])
chOB=tempchOB.channel;
eval(['load(''',foldername,'','/LFPData/LFP',num2str(chOB),'.mat'');'])

Time = Range(LFP);
TotalEpoch = intervalSet(Time(1),Time(end));
if exist('StimEpoch')
    LFP = Restrict(LFP,TotalEpoch-StimEpoch);
end

% params
try
    smootime;
catch
    smootime=3;
end

%get instantaneous beta power
FilBeta = FilterLFP(LFP,[10 30],1024); % filtering
tEnveloppeBeta = tsd(Range(LFP), abs(hilbert(Data(FilBeta))) ); %tsd: hilbert transform then enveloppe

%smooth beta power
SmoothBeta = tsd(Range(tEnveloppeBeta), runmean(Data(tEnveloppeBeta), ceil(smootime/median(diff(Range(tEnveloppeBeta,'s'))))));
end
