%% This code was used for Fig1 in draft for 11th april 2016
%% Evaluate bimodality of distribution
struc={'B','H','PF','Pa'};
clear chan filename2
AllSlScoringMice;
smrange=[0.1,0.5,1,2,3,4,5];
cols=jet(length(smrange));
cc=jet(length(smrange));
figure
for file=1:m
    %Getting the right Epochs
    file
    cd(filename2{file})
    load('StateEpochSB.mat','NoiseEpoch','GndNoiseEpoch','Epoch','chB','Sleep');
    clear X Y
    load(['LFPData/LFP',num2str(chB),'.mat'])
    LFP=Restrict(LFP,and(Sleep,Epoch));
    FilBeta=FilterLFP(LFP,[10 15],1024);
    HilBeta=hilbert(Data(FilBeta));
    H=abs(HilBeta);
    tot_bet=tsd(Range(LFP),H);
    subplot(3,5,file)
    for sm=1:length(smrange)
        smooth_bet=tsd(Range(tot_bet),runmean(Data(tot_bet),ceil(smrange(sm)/median(diff(Range(tot_bet,'s'))))));
        [Y{sm},X{sm}]=hist(log(Data(smooth_bet)),700);
        hold on,
        plot(X{sm},Y{sm},'color',cols(sm,:))
    end
    save('SleepBimodBeta.mat','X','Y')
    clear X Y
    
end