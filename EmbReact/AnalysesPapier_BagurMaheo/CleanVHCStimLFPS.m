function CleanVHCStimLFPS(folder,channel)
cd(folder)

load(['LFPData/LFP',num2str(channel),'.mat'])

% Load stim
try
    load('behavResources_SB.mat','TTLInfo')
    TTLInfo.StimEpoch2;
catch
    try
        load('behavResources.mat','TTLInfo')
        TTLInfo.StimEpoch2;
    catch
        load('behavResources.mat','StimEpoch2')
        TTLInfo.StimEpoch2 = StimEpoch2;
    end
end
TTLTimes = Start(TTLInfo.StimEpoch2,'s');


AllDat = Data(LFP);
AllTime = Range(LFP,'s');
for t = 1:length(TTLTimes)
    try
    DataSnip(t,:) = Data(Restrict(LFP,intervalSet(TTLTimes(t)*1e4,TTLTimes(t)*1e4+2*1e4)));
    time = Range(Restrict(LFP,intervalSet(TTLTimes(t)*1e4,TTLTimes(t)*1e4+2*1e4)),'s') - TTLTimes(t);
    realtime = Range(Restrict(LFP,intervalSet(TTLTimes(t)*1e4,TTLTimes(t)*1e4+2*1e4)),'s') ;
    % fit exponential function
    f = fit(time(20:end),DataSnip(t,20:end)' ,'exp1','StartPoint',[DataSnip(t,20),-2]);
    
    % subtract exponentiel and set to nans the data very clos to the stim
    StartPoint = find(AllTime>realtime(1));
    AllDat(StartPoint-5:StartPoint+19) = NaN;
    AllDat(StartPoint+20:StartPoint+20+length(time(21:end))) = DataSnip(t,20:end)' - feval(f,time(20:end));
    catch
       disp('fail') 
    end
end
AllDat = naninterp(AllDat);
LFP = tsd(Range(LFP),AllDat(1:length(Range(LFP))));

save(['LFPData/LFP',num2str(channel),'_VHCClean.mat'],'LFP')

end