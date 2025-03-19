cd '/media/mobs/DataMOBS94/M0936/SleepStimTest/test4_04-07-2019/4-sleepstimrem2/'
load('SleepScoring_OBGamma.mat');

%set folders
[parentdir,~,~]=fileparts(pwd);
pathOut = [pwd '/Figures/'];
if ~exist(pathOut,'dir')
    mkdir(pathOut);
end

%%% load online sleepScoring data
filename = '/media/mobs/DataMOBS94/M0936/SleepStimTest/test4_04-07-2019/4-sleepstimrem2/ERC-M0936-SleepStimTest-rem2_190704_174620/sleepScoring.txt';
delimiter = ';';
formatSpec = '%s%s%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN, 'ReturnOnError', false);
fclose(fileID);
onlineSleepScoring = dataArray{:, 2};
gamma = dataArray{:, 3};
theta = dataArray{:, 4};
clearvars filename delimiter formatSpec fileID dataArray ans;


%%% Get timing of all offline epoches
startWake = Start(Wake);
stopWake = Stop(Wake);
startREM = Start(REMEpoch);
stopREM = Stop(REMEpoch);
startSWS = Start(SWSEpoch);
stopSWS = Stop(SWSEpoch);
% startWake = Start(WakeWiNoise);
% stopWake = Stop(WakeWiNoise);
% startREM = Start(REMEpochWiNoise);
% stopREM = Stop(REMEpochWiNoise);
% startSWS = Start(SWSEpochWiNoise);
% stopSWS = Stop(SWSEpochWiNoise);


%%% Creates one data object with all the intervalSets
length = max([stopSWS(end) stopWake(end) stopREM(end)]);
t=0;
offlineSleepScoring = {};
while t<length

	if (~isempty(startWake)) && (startWake(1)==t)
		sleepStage='Wake';
		t = stopWake(1);
		epochDuration = stopWake(1) - startWake(1); 
		startWake = startWake(2:end);
		stopWake = stopWake(2:end);

	elseif (~isempty(startSWS)) &&  (startSWS(1)==t)
		sleepStage='NREM';
		t = stopSWS(1);
		epochDuration = stopSWS(1) - startSWS(1); 
		startSWS = startSWS(2:end);
		stopSWS = stopSWS(2:end);

	elseif(~isempty(startREM)) &&   (startREM(1)==t)
		sleepStage='REM';
		t = stopREM(1);
		epochDuration = stopREM(1) - startREM(1); 
		startREM = startREM(2:end);
		stopREM = stopREM(2:end);

	else
		sleepStage='Undefined';
        epochend = [];
        if ~isempty(startWake)
            epochend = [epochend startWake(1)];
        end
        if ~isempty(startSWS)
            epochend = [epochend startSWS(1)];
        end
        if ~isempty(startREM)
            epochend = [epochend startREM(1)];
        end
        if isempty(epochend)
            t = length;
        else
            epochDuration = min(epochend) - t;
            t = t + epochDuration;
        end

	end

	for i=1:round(epochDuration/10000)
		offlineSleepScoring = [offlineSleepScoring; sleepStage];
	end

end

clearvars -except offlineSleepScoring onlineSleepScoring gamma theta

figure;

plt1 = subplot(3,1,1);
plot(gamma);
title('Gamma power');

plt2 = subplot(3,1,2);
plot(theta);
title('Theta power');

plt3 = subplot(3,1,3);
plotSleepScoring(onlineSleepScoring,'b');
hold on;
plotSleepScoring(offlineSleepScoring,'r');
legend('online','offline');
title('Offline & Online sleep scroring');

linkaxes([plt1,plt2,plt3],'x');

AddScriptName;
%saveas(gcf,strcat('/home/',getenv('USER'),'/Pictures/compareSleepScoring.png'));
saveas([pathOut '/compareSleepScoring.png']);