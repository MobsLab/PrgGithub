%% All these parameters will need to be fitetd to model
MaxFreqSk = 7;
MinFreqSk = 4;
Tau = 3; % s

MaxFreqPos = 6;
MinFreqPos = 2;

LearnPoint = 600; %s
LearnSlope = 0.01;

%% Make a simulation of 10s freezing period at different positions and learning rates depending on time since shock
tpsManip = [0:1500];
AllTpsLearn = [ 1:300:max(tpsManip)];%sample at different time points (1,301,601,901,...)

Learning = 1./(1+exp(-LearnSlope*([0:1500]-LearnPoint)));%sigmoidal curve centered at the learning point (Learning(Learnpoint)=1/2)
AllTimeToShock = [0,2,5,10,20];

% sample different learning stages
cols = jet(10); %returns the jet colormap as a three-column array with the same number of rows as the colormap of the current figure
for t = 1:length(AllTpsLearn) %iterates over the different sampling times
    
    AlphaLearn = Learning(AllTpsLearn(t)); %stocks learning value for time corresponding to the position t in AllTpsLearn
    
    for sk = 1:length(AllTimeToShock) %iterates over the different shock times
        TimeToShock = AllTimeToShock(sk); %stocks the value of AllTimeToShock corresponding to the index sk for a given iteration 
        for Pos = 0:0.1:0.9 %iterates over different positions 
            OBFreq_Shock = (1-AlphaLearn) .* ((MaxFreqSk - MinFreqSk) *exp([(-[0:10] -TimeToShock)]/Tau) + MinFreqSk);
            OBFreq_Pos = (AlphaLearn) .* ((MaxFreqPos*Pos - MinFreqPos) *Pos + MinFreqPos);
            OBFreq_Tot = OBFreq_Shock + OBFreq_Pos; 
            subplot(5,5,t+(sk-1)*5)
            plot(OBFreq_Tot,'color',cols(round(Pos*10+1),:),'linewidth',2)
            hold on
            ylim([0 8])
            xlim([0 10])
            xlabel('Time freezing (s)')
            ylabel('Frequency (Hz)')
        end
    end
end


figure
plot(tpsManip,Learning,'linewidth',3)
hold on
for t = 1:length(AllTpsLearn)
    line([AllTpsLearn(t) AllTpsLearn(t)],ylim)
end


