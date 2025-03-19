%%DownDuringSubstages

clear

%params


%% load
%Down states
try
    load newDownState Down
catch
    try
        load DownSpk Down
    catch
        Down = intervalSet([],[]);
    end
end
start_down = Start(Down);
%Delta waves
try
    load DeltaPFCx DeltaOffline
catch
    load newDeltaPFCx DeltaEpoch
    DeltaOffline = DeltaEpoch;
    clear DeltaEpoch
end
start_deltas = Start(DeltaOffline);

load ChannelsToAnalyse/PFCx_deep
eval(['load LFPData/LFP',num2str(channel)])
LFPdeep=LFP;
clear LFP

%Substages
clear op noise
load NREMepochsML.mat op noise
disp('Loading epochs from NREMepochsML')
[Substages,~]=DefineSubStages(op,noise);


%% Restrict down and delta to substages
for st=1:6
    delta_substage{st} = Range(Restrict(ts(start_deltas),Substages{st}))/1E4;
    down_substage{st} = Range(Restrict(ts(start_down),Substages{st}))/1E4;
end





