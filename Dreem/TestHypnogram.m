%TestHypnogram

clear
filereference = 26655;

[Hypnograms, ~, ~] = GetHypnogramClinic(filereference);
StageEpochs = Hypnograms{4};
N1=StageEpochs{1}; N2=StageEpochs{2}; N3=StageEpochs{3}; REM=StageEpochs{4}; WAKE=StageEpochs{5};

%% Sleep Stages
Rec=or(or(or(N1,or(N2,N3)),REM),WAKE);
Epochs={N1,N2,N3,REM,WAKE};
num_substage=[2 1.5 1 3 4]; %ordinate in graph
indtime=min(Start(Rec)):1E4:max(Stop(Rec));
timeTsd=tsd(indtime,zeros(length(indtime),1));
SleepStages=zeros(1,length(Range(timeTsd)))+4.5;
rg=Range(timeTsd);
sample_size = median(diff(rg))/10; %in ms
time_stages = zeros(1,5);
meanDuration_sleepstages = zeros(1,5);
for ep=1:length(Epochs)
    idx=find(ismember(rg,Range(Restrict(timeTsd,Epochs{ep})))==1);
    SleepStages(idx)=num_substage(ep);
    time_stages(ep) = length(idx) * sample_size;
    meanDuration_sleepstages(ep) = mean(diff([0;find(diff(idx)~=1);length(idx)])) * sample_size;
end
SleepStages=tsd(rg,SleepStages');
percentvalues_NREM = zeros(1,3);
for ep=1:3
    percentvalues_NREM(ep) = time_stages(ep)/sum(time_stages(1:3));
end
percentvalues_NREM = round(percentvalues_NREM*100,2);


figure, hold on;
ylabel_substage = {'N3','N2','N1','REM','WAKE'};
ytick_substage = [1 1.5 2 3 4]; %ordinate in graph
colori = {[0.5 0.3 1], [1 0.5 1], [0.8 0 0.7], [0.1 0.7 0], [0.5 0.2 0.1]}; %substage color
plot(Range(SleepStages,'s')/3600,Data(SleepStages),'k'), hold on,
for ep=1:length(Epochs)
    plot(Range(Restrict(SleepStages,Epochs{ep}),'s')/3600 ,Data(Restrict(SleepStages,Epochs{ep})),'.','Color',colori{ep}), hold on,
end
xlim([0 max(Range(SleepStages,'s')/3600)]), ylim([0.5 5]), set(gca,'Ytick',ytick_substage,'YTickLabel',ylabel_substage), hold on,
title('Hypnogram'); xlabel('Time (h)')
