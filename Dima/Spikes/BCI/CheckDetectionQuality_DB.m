% CheckDetectionQuality_DB

%% Case 'boxes'

% Parameters
Dir = '/media/mobsrick/DataMOBS101/Mouse-979/20190917/Decoding_checks/Threshold/_Concatenated/';
numclust = 3;
dir_out= '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/Thibault_test/September2019/Threshoid/';

cd(Dir);
load('DetectionTSD.mat');
load('SpikeData.mat');
load([Dir 'Waveforms/Waveforms' cellnames{numclust} '.mat']);

% Do
Detected = thresholdIntervals(DetectionTSD,0.99,'Direction','Above');
NumStimDetected = length(Start(Detected));
NumSpikesClustered = length(S{numclust});

SpikesTimes = ts(Data(S{numclust}));
SpikesDetectedCorrectly = Restrict(SpikesTimes,Detected);
NumSpikesDetectedCorr = length(Data(SpikesDetectedCorrectly));

DetectedArray = Start(Detected);
SpikesDetectedCorrArray = Data(SpikesDetectedCorrectly);
AllSpikesArray = Data(S{numclust});

AllSpikesArraySamples = round(AllSpikesArray/1e4*2e4);
DetectedArraySamples = round(DetectedArray/1e4*2e4);
SpikesDetectedCorrArraySamples = round(SpikesDetectedCorrArray/1e4*2E4);

id_found = zeros(1,length(DetectedArraySamples));
for i = 1:length(SpikesDetectedCorrArraySamples)
    [m(i),id] = min(abs((DetectedArraySamples+14)-SpikesDetectedCorrArraySamples(i)));
    if m(i)<4
        id_found(i) = id;
    end
end
id_found = nonzeros(id_found);

DetectionWOSpikesIDX = setdiff([1:length(DetectedArraySamples)],id_found);
[D,SpikesDetectedCorrIDX] = intersect(AllSpikesArray,SpikesDetectedCorrArray);
[D,SpikesWODetectionIDX] = setdiff(AllSpikesArray,SpikesDetectedCorrArray);

clear D
%
% Spikes that were detected but did not appear after Kustakwik

disp('Initializing GPU')
gpudev = gpuDevice(1); % initialize GPU (will erase any existing GPU arrays)

NchanTOT = 73;
NT=32832;
ntbuff=64;
Nchan = 5;
nt0=32;
fbinary = [Dir 'M979_20190917_Decoding_Threshold_Clu6.fil'];
d = dir(fbinary);
ForceMaxRAMforDat   = 10000000000;
memallocated = ForceMaxRAMforDat;
nint16s      = memallocated/2;

ExtractArray = round(DetectedArray(DetectionWOSpikesIDX)/1e4*20000);


NTbuff      = NT + ntbuff;
Nbatch      = ceil(d.bytes/2/NchanTOT /(NT-ntbuff));
Nbatch_buff = floor(4/5 * nint16s/Nchan /(NT-ntbuff)); % factor of 4/5 for storing PCs of spikes
Nbatch_buff = min(Nbatch_buff, Nbatch);

DATA =zeros(NT, NchanTOT,Nbatch_buff,'int16');
fid = fopen(fbinary, 'r');
indicesTokeep = [64 51 53 54 55]';

waveforms_all = zeros(length(indicesTokeep),nt0,size(ExtractArray,1));

fprintf('Extraction of waveforms begun \n')
for ibatch = 1:Nbatch
    if mod(ibatch,10)==0
        if ibatch~=10
            fprintf(repmat('\b',[1 length([num2str(round(100*(ibatch-10)/Nbatch)), ' percent complete'])]))
        end
        fprintf('%d percent complete', round(100*ibatch/Nbatch));
    end
    
    offset = max(0, 2*NchanTOT*((NT - ntbuff) * (ibatch-1) - 2*ntbuff));
    if ibatch==1
        ioffset = 0;
    else
        ioffset = ntbuff;
    end
    fseek(fid, offset, 'bof');
    buff = fread(fid, [NchanTOT NTbuff], '*int16');
    
    nsampcurr = size(buff,2);
    if nsampcurr<NTbuff
        buff(:, nsampcurr+1:NTbuff) = repmat(buff(:,nsampcurr), 1, NTbuff-nsampcurr);
    end
        dataRAW = gpuArray(buff);
        
        dataRAW = dataRAW';
        dataRAW = dataRAW(:, indicesTokeep);
        DATA = gather_try(int16( dataRAW(ioffset + (1:NT),:)));
        dat_offset = offset/NchanTOT/2+ioffset;
        
        for i = 1:length(indicesTokeep)
            temp = find(ismember(ExtractArray, [nt0/2+1:size(DATA,1)-nt0/2] + dat_offset));
            temp2 = ExtractArray(temp)-dat_offset;
            
            startIndicies = temp2;
            stopIndicies = startIndicies+31;
            X = cumsum(accumarray(cumsum([1;stopIndicies(:)-startIndicies(:)+1]),[startIndicies(:);0]-[0;stopIndicies(:)]-1)+1);
            X = X(1:end-1);
            waveforms_all(:,:,temp) = reshape(DATA(X,1:length(indicesTokeep))',size(indicesTokeep,1),nt0,[]);
        end
        
end

SpikesNotFoundbyClustering = permute(waveforms_all,[3 1 2]);

%% Plot

% Detected spikes that match
step = 20;
f = figure('units', 'normalized', 'outerposition', [0 0 0.65 1]);
for elec = 1:size(W,2)
    subplot(13,15,[((elec-1)*30)+1:((elec-1)*30)+5 ((elec-1)*30)+16:((elec-1)*30)+20])
    dat1 = W(SpikesDetectedCorrIDX,elec,:);
    dat1 = dat1(1:step:end,:);
    dat2 = W(SpikesWODetectionIDX,elec,:);
    dat2 = dat2(1:step:end,:);
    add1 = plot(dat1','color',[0.6 0.6 0.6]);
    hold on
    add2 = plot(dat2','color',[1 0.714 0.757]);
    for i=1:length(add2)
        add2(i).Color(4) = 0.1;
    end
    hold on
    main1 = plot(nanmean(dat1),'color','k','linewidth',2);
    ylim([-3000 1000])
    xlim([0 35])
    hold on
    main2 = plot(nanmean(dat2),'color','r','linewidth',2);
    main2.Color(4) = 0.4;
    ylim([-3000 1000])
    xlim([0 35])
    set(gca,'FontWeight','bold','FontSize',14,'LineWidth',3);
    if elec == 1
        line(xlim,[-1041 -1041],'Color','r');
        title(['Algorithm detected correctly ' num2str(round(length(SpikesDetectedCorrIDX)/length(AllSpikesArray)*100))...
            '% of spikes']);
        set(gca, 'YTickLabel',[],'XTickLabel',[]);
    elseif elec == 4
        xlabel('Time in samples')
        legend([main1 main2], {'Detected','Not detected'},'FontSize',10, 'Location','SouthEast')
    else
        set(gca, 'YTickLabel',[],'XTickLabel',[]);
    end
end

step = 10;
for elec = 1:size(W,2)
    subplot(13,15,[((elec-1)*30)+11:((elec-1)*30)+15 ((elec-1)*30)+26:((elec-1)*30)+30])
    dat = SpikesNotFoundbyClustering(:,elec,:);
    dat = dat(1:step:end,:);
    plot(dat','color',[0.6 0.6 0.6]), hold on
    plot(nanmean(dat),'color','k','linewidth',2)
    ylim([-3000 1000])
    xlim([0 35])
    set(gca,'FontWeight','bold','FontSize',14,'LineWidth',3);
    if elec == 1
        line(xlim,[-1041 -1041],'Color','r');
        title([num2str(round(length(DetectionWOSpikesIDX)/length(DetectedArray)*100))...
            '% of detected spikes were not found offline']);
        set(gca, 'YTickLabel',[],'XTickLabel',[]);
    elseif elec == 4
        xlabel('Time in samples')
    else
        set(gca, 'YTickLabel',[],'XTickLabel',[]);
    end
end

subplot(13,15,[151:155 166:170])
[C,B]=CrossCorr(AllSpikesArray,AllSpikesArray,1,50);C(B==0)=0;
bar(B,C,'FaceColor','k','EdgeColor','k')
set(gca,'FontWeight','bold','FontSize',14,'LineWidth',3);
xlabel('time (ms)')
ylim([0 20])
title('Autocorrelogram of offline detected cluster')

string = [num2str(NumSpikesClustered) ' spikes found offline' newline num2str(NumStimDetected) ' spikes found offline'];
annotation(f,'textbox',[0.41 0.03 0.2 0.1],'String',string, 'LineWidth',3,...
        'HorizontalAlignment','center', 'FontSize', 14, 'FontWeight','bold',...
        'FitBoxToText','on');

subplot(13,15,[161:165 176:180])
[C,B]=CrossCorr(DetectedArray(DetectionWOSpikesIDX),DetectedArray(DetectionWOSpikesIDX),1,50);C(B==0)=0;
bar(B,C,'FaceColor','k','EdgeColor','k')
set(gca,'FontWeight','bold','FontSize',14,'LineWidth',3);
xlabel('time (ms)')
ylim([0 20])
title('Autocorrelogram of over-detected spikes')

% Saving
saveas(f, [dir_out 'Clu7_M979_SpikeShapes.fig']);
saveFigure(f,'Clu7_M979_SpikeShapes',dir_out);

%% Cross correlograms
f2 = figure('units', 'normalized', 'outerposition', [0 0 0.65 0.65]);
for i=2:length(S)
    [C,B]=CrossCorr((Start(Detected)+6),Range(S{i}),10,50);
    subplot(5,2,i-1)
    bar(B/1E3,C,1,'k')
    ylim([0 100])
    line([0 0], ylim,'color','r')
    set(gca,'FontWeight','bold','FontSize',14,'LineWidth',3);
    title(['Detected vs Cl#' num2str(i)])
    if i<10
        set(gca,'XTickLabel',[]);
    else
        xlabel('Time (ms)');
    end
end
mtit(f2, 'Correctly detected spikes vs each cluster detected offline', 'zoff', 0.03, 'yoff', 0.01,...
    'fontsize',16,'fontweight','bold');

% Saving
saveas(f2, [dir_out 'Clu7_M979_CrossCorrect.fig']);
saveFigure(f2,'Clu7_M979_CrossCorrect',dir_out);

f3 = figure('units', 'normalized', 'outerposition', [0 0 0.65 0.65]);
for i=2:length(S)
    [C,B]=CrossCorr((DetectedArray(DetectionWOSpikesIDX)+6),Range(S{i}),10,50);
    subplot(5,2,i-1)
    bar(B/1E3,C,1,'k')
    ylim([0 100])
    line([0 0], ylim,'color','r')
    set(gca,'FontWeight','bold','FontSize',14,'LineWidth',3);
    title(['Over-detected vs Cl#' num2str(i)])
    if i<10
        set(gca,'XTickLabel',[]);
    else
        xlabel('Time (ms)');
    end
end
mtit(f3, 'Spikes not found in correct cluster vs each cluster detected offline', 'zoff', 0.03, 'yoff', 0.01,...
    'fontsize',16,'fontweight','bold');


% Saving
saveas(f3, [dir_out 'Clu7_M979_CrossNotFound.fig']);
saveFigure(f3,'Clu7_M979_CrossNotFound',dir_out);

%%
%% Plot

% Detected spikes that match
step = 20;
f = figure('units', 'normalized', 'outerposition', [0 0 0.65 1]);
for elec = 1:size(W,2)
    subplot(13,15,[((elec-1)*30)+1:((elec-1)*30)+5 ((elec-1)*30)+16:((elec-1)*30)+20])
    dat1 = W(SpikesDetectedCorrIDX,elec,:);
    dat1 = dat1(1:step:end,:);
    add1 = plot(dat1','color',[0.6 0.6 0.6]);
    hold on
    main1 = plot(nanmean(dat1),'color','k','linewidth',2);
    ylim([-3000 1000])
    xlim([0 35])
    hold on
    set(gca,'FontWeight','bold','FontSize',14,'LineWidth',3);
    if elec == 1
        line(xlim,[-1041 -1041],'Color','r');
        title(['Spikes detected offline']);
        set(gca, 'YTickLabel',[],'XTickLabel',[]);
    elseif elec == 4
        xlabel('Time in samples')
    else
        set(gca, 'YTickLabel',[],'XTickLabel',[]);
    end
end

step = 20;
dat2 = W(SpikesDetectedCorrIDX,:,:);
SpikesOnline = cat(1, dat2, SpikesNotFoundbyClustering);
for elec = 1:size(W,2)
    subplot(13,15,[((elec-1)*30)+11:((elec-1)*30)+15 ((elec-1)*30)+26:((elec-1)*30)+30])
    dat = SpikesOnline(:,elec,:);
    dat = dat(1:step:end,:);
    plot(dat','color',[0.6 0.6 0.6]), hold on
    plot(nanmean(dat),'color','k','linewidth',2)
    ylim([-3000 1000])
    xlim([0 35])
    set(gca,'FontWeight','bold','FontSize',14,'LineWidth',3);
    if elec == 1
        line(xlim,[-1041 -1041],'Color','r');
        title(['Spikes detected online']);
        set(gca, 'YTickLabel',[],'XTickLabel',[]);
    elseif elec == 4
        xlabel('Time in samples')
    else
        set(gca, 'YTickLabel',[],'XTickLabel',[]);
    end
end

subplot(13,15,[151:155 166:170])
[C,B]=CrossCorr(AllSpikesArray,AllSpikesArray,1,50);C(B==0)=0;
bar(B,C,'FaceColor','k','EdgeColor','k')
set(gca,'FontWeight','bold','FontSize',14,'LineWidth',3);
xlabel('time (ms)')
ylim([0 20])
title('Autocorrelogram of offline detected cluster')

string = [num2str(NumSpikesClustered) ' spikes found offline' newline num2str(NumStimDetected) ' spikes found online'];
annotation(f,'textbox',[0.41 0.03 0.2 0.1],'String',string, 'LineWidth',3,...
        'HorizontalAlignment','center', 'FontSize', 14, 'FontWeight','bold',...
        'FitBoxToText','on');

subplot(13,15,[161:165 176:180])
[C,B]=CrossCorr(DetectedArray,DetectedArray,1,50);C(B==0)=0;
bar(B,C,'FaceColor','k','EdgeColor','k')
set(gca,'FontWeight','bold','FontSize',14,'LineWidth',3);
xlabel('time (ms)')
ylim([0 20])
title('Autocorrelogram of online detected spikes')

% Saving
saveas(f, [dir_out 'Clu7_M979_SpikeShapesOriginal.fig']);
saveFigure(f,'Clu7_M979_SpikeShapes_Original',dir_out);

%% Plot from Karim

f = figure('units', 'normalized', 'outerposition', [0 0 1 1]);
binSize=80E4;

Q=MakeQfromS(S,binSize);
Qs=full(Data(Q));
Qtsd=tsd(Range(Q),Qs(:,10));

stim=tsdArray(tsd(Start(Detected),Start(Detected)));
Qstim=MakeQfromS(stim,binSize);
Qs2=full(Data(Qstim));
Qstimtsd=tsd(Range(Qstim),Qs2(:,1));

[X,lag]=xcorr(Data(Qtsd),Data(Qstimtsd),100);

[C,B]=CrossCorr(Range(S{10}),Start(Detected),1,100);

subplot(3,3,1:3), plot(Range(Qtsd,'s'),Data(Qtsd),'LineWidth',3)
hold on, plot(Range(Qstimtsd,'s'),Data(Qstimtsd),'r','LineWidth',3)
set(gca,'FontWeight','bold','FontSize',14,'LineWidth',3);
xlabel('Time (s)')
ylabel('Count')
title('FR across recording')
legend('All Spikes','Detected Spikes')
subplot(3,3,4:6), imagesc(zscore(Qs)')
set(gca,'FontWeight','bold','FontSize',14,'LineWidth',3);
axis xy
title('FR across recording')
ylabel('#Cluster')
xlabel('#Bin')
subplot(3,3,7), bar(B/10,C,1,'k'), line([0 0],ylim,'color','r','LineWidth',3)
set(gca,'FontWeight','bold','FontSize',14,'LineWidth',3);
ylabel('Count')
xlabel('Time (ms)')
ylim([0 10])
title('Cross-correlation offline vs online')
subplot(3,3,8), plot(lag,X,'k','Linewidth',3)
hold on
line([0 0],ylim,'color','r','LineWidth',3)
xlabel('Lag')
ylabel('Cross-correlation')
title('Cross-correlation offline vs online')
set(gca,'FontWeight','bold','FontSize',14,'LineWidth',3);
subplot(3,3,9), plot(Data(Qtsd),Data(Restrict(Qstimtsd,Qtsd)),'ko','markerfacecolor','k', 'Linewidth', 3)
hold on
h1 = plot(Data(Qtsd),Data(Qtsd)*0.3,'r.');
h2 = plot(Data(Qtsd),Data(Qtsd)*0.5,'b.');
set(gca,'FontWeight','bold','FontSize',14,'LineWidth',3);
xlabel('FR of all spikes')
ylabel('FR of detected spikes')
title('FR of all spikes vs detected spikes')
legend([h1 h2], '1/3 of offline spikes', '1/2 of offline spikes')

saveas(f, [dir_out 'Clu7_M979_Karim.fig']);
saveFigure(f,'Clu7_M979_Karim',dir_out);