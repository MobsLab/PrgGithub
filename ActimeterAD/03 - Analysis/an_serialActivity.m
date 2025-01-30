%an_serialActivity.m

dataDir='\\NASDELUXE2\DataMOBsRAID\ProjetSLEEPActi\';
channelIDs = 1:12;

% jour TEST0 / TEST
acqID_TEST=[36 37 38 59 69];
simulateStim=false;

% jour BASAL
acqID_BASAL=[29 31 34 45];

% BASAL dont overnight
acqID_BON=[32 40];

numData=9:69;
MatA={};
MatB={};
MatC={};
for i=1:length(numData)
    clear A B C temp
    
    try
        try
            d = dir(strcat(dataDir, sprintf('SLEEPActi-*-%04d*', numData(i))));
            nameTosave = strcat(d(end).name, '\', sprintf('%04d-anProbeTest.mat', numData(i)));
            temp=load([dataDir,nameTosave],'sleepWakeDuration','deltaT_sleepToWakeHist',...
                'deltaT_wakeToSleepHist','deltaTs','deltaTMax_true','channelIDs');
            disp([nameTosave,' already exists... loading'])
            A= temp.sleepWakeDuration;
            B= temp.deltaT_sleepToWakeHist;
            C= temp.deltaT_wakeToSleepHist;
            deltaTMax_true=temp.deltaTMax_true;
            deltaTs=temp.deltaTs;
        catch
            if ismember(numData(i),acqID_TEST)
                
                simulateStim=true;
                %A: sleepWakeDuration;
                %B: deltaT_sleepToWakeHist;
                %C: deltaT_wakeToSleepHist
                [A,B,C, deltaTs,deltaTMax_true]=an_probe_testML(numData(i),channelIDs,simulateStim);
                
            else
                simulateStim=true;
                [A,B,C, deltaTs,deltaTMax_true]=an_probe_testML(numData(i),channelIDs,simulateStim);
                
            end
        end
        MatA{numData(i)}=A;
        MatB{numData(i)}=B;
        MatC{numData(i)}=C;
        close all
        
    catch
        disp(['problem ',sprintf('SLEEPActi-*-%04d*', numData(i))]); disp(' ');
    end
end

save Analy_serialActivity MatA MatB MatC deltaTs deltaTMax_true ...
    acqID_TEST acqID_BASAL numData channelIDs


