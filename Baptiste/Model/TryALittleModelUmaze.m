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
AllTpsLearn = [ 1:300:max(tpsManip)];

Learning = 1./(1+exp(-LearnSlope*([0:1500]-LearnPoint)));
AllTimeToShock = [0,2,5,10,20];

% sample different learning stages
cols = jet(10);
for t = 1:length(AllTpsLearn)
    
    AlphaLearn = Learning(AllTpsLearn(t));
    
    for sk = 1:length(AllTimeToShock)
        TimeToShock = AllTimeToShock(sk);
        for Pos = 0:0.1:0.9
            OBFreq_Shock = (1-AlphaLearn) .* ((MaxFreqSk - MinFreqSk) *exp([(-[0:10] -TimeToShock)]/Tau) + MinFreqSk);
            OBFreq_Pos = (AlphaLearn) .* ((MaxFreqPos*Pos - MinFreqPos) *Pos + MinFreqPos);
            OBFreq_Tot = OBFreq_Shock + OBFreq_Pos;
            subplot(5,5,t+(sk-1)*5)
            plot(OBFreq_Tot,'color',cols(round(Pos*10+1),:),'linewidth',2)
            hold on
            ylim([0 8])
            xlabel('Time freezing (s)')
        end
    end
end

figure
plot(tpsManip,Learning,'linewidth',3)
hold on
for t = 1:length(AllTpsLearn)
    line([AllTpsLearn(t) AllTpsLearn(t)],ylim)
end


