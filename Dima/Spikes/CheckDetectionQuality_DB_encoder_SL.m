% CheckDetectionQuality_DB

%% Case 'boxes'

% Parameters
Dir = '/media/mobs/DataMOBS94/M0936/SleepStimTest/test3_30-06-2019/sleepstim/';
% Dir = '/media/nas5/ProjetERC1/SleepStim_thib/';
dir_out= '/home/mobs/Dropbox/MOBS_workingON/Sam/Thibault_test/';

% var init
numclust = 6; %targeted cluster
nbclust = 8; %total nbr of clusters on this tetrode


cd(Dir);
load('DetectionTSD.mat');
load('SpikeData.mat');
load([Dir 'Waveforms/Waveforms' cellnames{numclust} '.mat']);
load('IdFigureData2.mat', 'night_duration')  % for testing-restrict to trash

%% GET SPIKES DATA
StimSent = thresholdIntervals(DetectionTSD,0.001,'Direction','Above');
NumStimSent = length(Start(StimSent));
NumSpikesClustered = length(S{numclust});

SpikesTimes = ts(Data(S{numclust}));
SpikesDetected = Restrict(SpikesTimes,StimSent);
NumSpikesDetected = length(Data(SpikesDetected));

% seperating good detections from bad
begin = Start(StimSent);
ending = End(StimSent);
sp = Data(SpikesTimes);
gotspike = 0;
offdetect = 0;
ondetect_id = 0;
for ispike=1:length(begin)
    gotspike = find(begin(ispike) < sp & sp < ending(ispike));
    if gotspike
        offdetect(end+1) = sp(gotspike);
        ondetect_id(end+1) = ispike;
        gotspike=0;
    end    
end
% taking out good detections
begin_bad = begin(setdiff(1:end,ondetect_id)); 
ending_bad = ending(setdiff(1:end,ondetect_id));
badspikes = intervalSet(begin_bad,ending_bad);
% selcting bad
badsp = Restrict(SpikesTimes,badspikes);


for iclu=1:nbclust
    Spik = ts(Data(S{iclu}));
    SpikDetected = Restrict(Spik,StimSent);
    NumSpikclu(iclu) = length(Data(SpikDetected));
end

StimSentArray = Start(StimSent);
SpikesDetectedArray = Data(SpikesDetected);
AllSpikesArray = Data(S{numclust});
badspArray = Data(badsp);

AllSpikesArraySamples = round(AllSpikesArray/1e4*2e4);
StimSentArraySamples = round(StimSentArray/1e4*2e4);
SpikesDetectedArraySamples = round(SpikesDetectedArray/1e4*2E4);
badspArraySamples = round(badspArray/1e4*2E4);


id_found = zeros(1,length(AllSpikesArraySamples));
for i = 1:length(AllSpikesArraySamples)
    [m(i),id] = min(abs((StimSentArraySamples+16)-AllSpikesArraySamples(i)));
    if m(i)<4
        id_found(i) = id;
    end
end

StimsWOSpikesIDX = setdiff([1:length(StimSentArraySamples)],id_found);
[D,SpikesDetectedIDX] = intersect(AllSpikesArray,SpikesDetectedArray);
[D,SpikesWODetectionIDX] = setdiff(AllSpikesArray,SpikesDetectedArray);

clear D
%
% Spikes that were detected but did not appear after Kustakwik


%% Waveforms extraction


disp('Initializing GPU')
% gpudev = gpuDevice(1); % initialize GPU (will erase any existing GPU arrays)

NchanTOT = 37;
NT=32832;
ntbuff=64;
Nchan = 4;
nt0=32;
fbinary = [Dir 'M936_20190630_SleepStimTest.fil'];
d = dir(fbinary);
ForceMaxRAMforDat   = 10000000000;
memallocated = ForceMaxRAMforDat;
nint16s      = memallocated/2;

ExtractArray_good = SpikesDetectedArraySamples;
ExtractArray_bad = badspArraySamples;
ExtractArray = StimSentArraySamples;


NTbuff      = NT + ntbuff;
Nbatch      = ceil(d.bytes/2/NchanTOT /(NT-ntbuff));
Nbatch_buff = floor(4/5 * nint16s/Nchan /(NT-ntbuff)); % factor of 4/5 for storing PCs of spikes
Nbatch_buff = min(Nbatch_buff, Nbatch);

DATA =zeros(NT, NchanTOT,Nbatch_buff,'int16');
fid = fopen(fbinary, 'r');
indicesTokeep = [21 22 23 24]';

waveforms_good = zeros(length(indicesTokeep),nt0,size(ExtractArray_good,1));
waveforms_bad = zeros(length(indicesTokeep),nt0,size(ExtractArray_bad,1));
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
    dataRAW = buff;
    
    dataRAW = dataRAW';
    dataRAW = dataRAW(:, indicesTokeep);
    DATA = gather_try(int16( dataRAW(ioffset + (1:NT),:)));
    dat_offset = offset/NchanTOT/2+ioffset;
    
    for i = 1:length(indicesTokeep)
        %good
        temp_g = find(ismember(ExtractArray_good, [nt0+1:size(DATA,1)] + dat_offset));
        temp2_g = ExtractArray_good(temp_g)-dat_offset;
        if temp2_g < 32800
            startIndicies = temp2_g;
            stopIndicies = startIndicies+31;
            Xg = cumsum(accumarray(cumsum([1;stopIndicies(:)-startIndicies(:)+1]),[startIndicies(:);0]-[0;stopIndicies(:)]-1)+1);
            Xg = Xg(1:end-1);
            waveforms_good(:,:,temp_g) = reshape(DATA(Xg,[1:4]')',size([1:4]',1),nt0,[]);
        end
        
        %bad
        temp_b = find(ismember(ExtractArray_bad, [nt0+1:size(DATA,1)] + dat_offset));
        temp2_b = ExtractArray_bad(temp_b)-dat_offset;
        if temp2_b < 32800
            startIndicies = temp2_b;
            stopIndicies = startIndicies+31;
            Xb = cumsum(accumarray(cumsum([1;stopIndicies(:)-startIndicies(:)+1]),[startIndicies(:);0]-[0;stopIndicies(:)]-1)+1);
            Xb = Xb(1:end-1);
            waveforms_bad(:,:,temp_b) = reshape(DATA(Xb,[1:4]')',size([1:4]',1),nt0,[]);
        end
        
        %all
        temp = find(ismember(ExtractArray, [nt0+1:size(DATA,1)] + dat_offset));
        temp2 = ExtractArray(temp)-dat_offset;
        
        if temp2 < 32800
            startIndicies = temp2;
            stopIndicies = startIndicies+31;
            X = cumsum(accumarray(cumsum([1;stopIndicies(:)-startIndicies(:)+1]),[startIndicies(:);0]-[0;stopIndicies(:)]-1)+1);
            X = X(1:end-1);
            waveforms_all(:,:,temp) = reshape(DATA(X,[1:4]')',size([1:4]',1),nt0,[]);
        end
    end
end

SpikesOnline_good = permute(waveforms_good,[3 1 2]);
SpikesOnline_bad = permute(waveforms_bad,[3 1 2]);
SpikesOnline = permute(waveforms_all,[3 1 2]);


%%  Reallign spikes

% for isig=1:4 %for each line
%     for i = 1:size(SpikesOnline,1)
%         [z,id] = min(SpikesOnline(i,isig,:));
%         if id>5 && id<20
%             shiftvalue = 16-id;
%             if shiftvalue>0
%                 delme = squeeze(SpikesOnline(i,isig,:));
%                 SpikesOnline(i,isig,:) = [nan(1,shiftvalue) delme(1:end-shiftvalue)'];
%             elseif shiftvalue<0
%                 delme = squeeze(SpikesOnline(i,isig,:));
%                 SpikesOnline(i,isig,:) = [delme(1:end-abs(shiftvalue))' nan(1,abs(shiftvalue))];
%             end
%         else
%             SpikesOnline(i,isig,:) = nan(1,size(SpikesOnline,3));
%         end
%     end
% end


%% Plot

% % Detected spikes that match
% step = 20;
% f = figure('units', 'normalized', 'outerposition', [0 0 0.65 1]);
% for elec = 1:size(W,2)
%     subplot(13,15,[((elec-1)*30)+1:((elec-1)*30)+5 ((elec-1)*30)+16:((elec-1)*30)+20])
%     dat1 = W(SpikesDetectedIDX,elec,:);
%     dat1 = dat1(1:step:end,:);
%     dat2 = W(SpikesWODetectionIDX,elec,:);
%     dat2 = dat2(1:step:end,:);
%     add1 = plot(dat1','color',[0.6 0.6 0.6]);
%     hold on
%     add2 = plot(dat2','color',[1 0.714 0.757]);
%     for i=1:length(add)
%         add2(i).Color(4) = 0.1;
%     end
%     hold on
%     main1 = plot(nanmean(dat1),'color','k','linewidth',2);
%     ylim([-3000 1000])
%     xlim([0 35])
%     hold on
%     main2 = plot(nanmean(dat2),'color','r','linewidth',2);
%     main2.Color(4) = 0.4;
%     ylim([-3000 1000])
%     xlim([0 35])
%     set(gca,'FontWeight','bold','FontSize',14,'LineWidth',3);
%     if elec == 1
%         line(xlim,[-1041 -1041],'Color','r');
%         title(['Algorithm detected correctly ' num2str(round(length(SpikesDetectedIDX)/length(AllSpikesArray)*100))...
%             '% of spikes']);
%         set(gca, 'YTickLabel',[],'XTickLabel',[]);
%     elseif elec == 4
%         xlabel('Time in samples')
%         legend([main1 main2], {'Detected','Not detected'},'FontSize',10, 'Location','SouthEast')
%     else
%         set(gca, 'YTickLabel',[],'XTickLabel',[]);
%     end
% end
% 
% step = 10;
% for elec = 1:size(W,2)
%     subplot(13,15,[((elec-1)*30)+11:((elec-1)*30)+15 ((elec-1)*30)+26:((elec-1)*30)+30])
%     dat = SpikesNotFoundbyClustering(:,elec,:);
%     dat = dat(1:step:end,:);
%     plot(dat','color',[0.6 0.6 0.6]), hold on
%     plot(nanmean(dat),'color','k','linewidth',2)
%     ylim([-3000 1000])
%     xlim([0 35])
%     set(gca,'FontWeight','bold','FontSize',14,'LineWidth',3);
%     if elec == 1
%         line(xlim,[-1041 -1041],'Color','r');
%         title([num2str(round(length(StimsWOSpikesIDX)/length(StimSentArray)*100))...
%             '% of detected spikes were not found offline']);
%         set(gca, 'YTickLabel',[],'XTickLabel',[]);
%     elseif elec == 4
%         xlabel('Time in samples')
%     else
%         set(gca, 'YTickLabel',[],'XTickLabel',[]);
%     end
% end
% 
% subplot(13,15,[151:155 166:170])
% [C,B]=CrossCorr(AllSpikesArray,AllSpikesArray,1,50);C(B==0)=0;
% bar(B,C,'FaceColor','k','EdgeColor','k')
% set(gca,'FontWeight','bold','FontSize',14,'LineWidth',3);
% xlabel('time (ms)')
% ylim([0 20])
% title('Autocorrelogram of offline deteFollowing the discussion between Dima, Thibault and I here's the figure showing the misalignment between online and offline detected spikes.cted cluster')
% 
% string = [num2str(NumSpikesClustered) ' spikes found offline' newline num2str(NumStimSent) ' spikes found offline'];
% annotation(f,'textbox',[0.41 0.03 0.2 0.1],'String',string, 'LineWidth',3,...
%         'HorizontalAlignment','center', 'FontSize', 14, 'FontWeight','bold',...
%         'FitBoxToText','on');
% 
% subplot(13,15,[161:165 176:180])
% [C,B]=CrossCorr(StimSentArray(StimsWOSpikesIDX),StimSentArray(StimsWOSpikesIDX),1,50);C(B==0)=0;
% bar(B,C,'FaceColor','k','EdgeColor','k')
% set(gca,'FontWeight','bold','FontSize',14,'LineWidth',3);
% xlabel('time (ms)')
% ylim([0 20])
% title('Autocorrelogram of over-detected spikes')
% 
% % Saving
% saveas(f, [dir_out 'Boxes1_M936_SpikeShapes.fig']);
% saveFigure(f,'Boxes1_M936_SpikeShapes',dir_out);

%% Cross correlograms
f2 = figure('units', 'normalized', 'outerposition', [0 0 0.3 0.65]);
for i=1:nbclust
    [C,B]=CrossCorr((Start(StimSent)+7),Range(S{i}),10,50);
    subplot(6,2,i)
    bar(B/1E3,C,1,'k')
    ylim([0 50])
    line([0 0], ylim,'color','r')
    set(gca,'FontWeight','bold','FontSize',12,'LineWidth',3);
    title(['Detected vs Cl#' num2str(i) ' (incl. ' num2str(NumSpikclu(i)) ' online spikes)'], 'FontSize', 10)
    
    if i<10
        set(gca,'XTickLabel',[]);
    else
        xlabel('Time (ms)');
    end
end
mtit(f2, 'Correctly detected spikes vs each cluster detected offline', 'zoff', 0.03, 'yoff', 0.01,...
   'fontsize',16,'fontweight','bold');

% Saving
saveas(f2, [dir_out 'Boxes1_M936_CrossCorrect.fig']);
saveFigure(f2,'Boxes1_M936_CrossCorrect',dir_out);

% f3 = figure('units', 'normalized', 'outerposition', [0 0 0.65 0.65]);
% for i=2:length(S)
%     [C,B]=CrossCorr((StimSentArray(StimsWOSpikesIDX)+7),Range(S{i}),10,50);
%     subplot(5,2,i-1)
%     bar(B/1E3,C,1,'k')
%     ylim([0 100])
%     line([0 0], ylim,'color','r')
%     set(gca,'FontWeight','bold','FontSize',14,'LineWidth',3);
%     title(['Over-detected vs Cl#' num2str(i)])
%     if i<10
%         set(gca,'XTickLabel',[]);
%     else
%         xlabel('Time (ms)');
%     endf = figure('units', 'normalized', 'outerposition', [0 0 1 1]);
binSize=80E4;

Q=MakeQfromS(S,binSize);
Qs=full(Data(Q));
Qtsd=tsd(Range(Q),Qs(:,numclust));

stim=tsdArray(tsd(Start(StimSent),Start(StimSent)));
Qstim=MakeQfromS(stim,binSize);
Qs2=full(Data(Qstim));
Qstimtsd=tsd(Range(Qstim),Qs2(:,1));

[X,lag]=xcorr(Data(Qtsd),Data(Qstimtsd),100);

[C,B]=CrossCorr(Range(S{numclust}),Start(StimSent),1,100);

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
% end
% mtit(f3, 'Spikes not found in correct cluster vs each cluster detected offline', 'zoff', 0.03, 'yoff', 0.01,...
%     'fontsize',16,'fontweight','bold');
% % 
% % 
% % Saving
% % saveas(f3, [dir_out 'Boxes1_M936_CrossNotFound.fig']);
% % saveFigure(f3,'Boxes1_M936_CrossNotFound',dir_out);

%%
%% Plot

% Detected spikes that match
step = 1;
f = figure('units', 'normalized', 'outerposition', [0 0 1 1]);
for elec = 1:size(W,2)
    subplot(13,15,[((elec-1)*30)+1:((elec-1)*30)+5 ((elec-1)*30)+16:((elec-1)*30)+20])
    dat1 = W(SpikesDetectedIDX,elec,:);
    dat1 = dat1(1:step:end,:);
    add1 = plot(dat1','color',[0.6 0.6 0.6]);
    hold on
    main1 = plot(nanmean(dat1),'color','k','linewidth',2);
    ylim([-1000 1000])
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

step = 1;

for elec = 1:size(W,2)
    subplot(13,15,[((elec-1)*30)+11:((elec-1)*30)+15 ((elec-1)*30)+26:((elec-1)*30)+30])
    dat = SpikesOnline_good(:,elec,:);
    dat = dat(1:step:end,:);
    plot(dat','color',[0.6 0.6 0.6]), hold on
    plot(nanmean(dat),'color','k','linewidth',2)
    ylim([-1000 1000])
    xlim([0 35])
    set(gca,'FontWeight','bold','FontSize',14,'LineWidth',3);
    if elec == 1
        line(xlim,[-1041 -1041],'Color','r');
        title(['Good spikes detected online']);
        set(gca, 'YTickLabel',[],'XTickLabel',[]);
    elseif elec == 4
        xlabel('Time in samples')
    else
        set(gca, 'YTickLabel',[],'XTickLabel',[]);
    end
end

% extra/bad spikes
step = 1;

for elec = 1:size(W,2)
    subplot(13,15,[((elec-1)*30)+21:((elec-1)*30)+25 ((elec-1)*30)+36:((elec-1)*30)+40])
    dat = SpikesOnline_bad(:,elec,:);
    dat = dat(1:step:end,:);
    plot(dat','color',[0.6 0.6 0.6]), hold on
    plot(nanmean(dat),'color','k','linewidth',2)
    ylim([-1000 1000])
    xlim([0 35])
    set(gca,'FontWeight','bold','FontSize',14,'LineWidth',3);
    if elec == 1
        line(xlim,[-1041 -1041],'Color','r');
        title(['Bad spikes detected online']);
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

string = [num2str(NumSpikesClustered) ' spikes found offline' newline num2str(NumStimSent) ' spikes found online'];
annotation(f,'textbox',[0.41 0.03 0.2 0.1],'String',string, 'LineWidth',3,...
        'HorizontalAlignment','center', 'FontSize', 14, 'FontWeight','bold',...
        'FitBoxToText','on');

subplot(13,15,[161:165 176:180])
[C,B]=CrossCorr(StimSentArray,StimSentArray,1,50);C(B==0)=0;
bar(B,C,'FaceColor','k','EdgeColor','k')
set(gca,'FontWeight','bold','FontSize',14,'LineWidth',3);
xlabel('time (ms)')
ylim([0 20])
title('Autocorrelogram of online detected spikes')

% Saving
saveas(f, [dir_out 'Boxes1_M936_SpikeShapesOriginal.fig']);
saveFigure(f,'Boxes1_M936_SpikeShapes_Original',dir_out);

%% Plot from Karim

f = figure('units', 'normalized', 'outerposition', [0 0 1 1]);
binSize=80E4;

Q=MakeQfromS(S,binSize);
Qs=full(Data(Q));
Qtsd=tsd(Range(Q),Qs(:,numclust));

stim=tsdArray(tsd(Start(StimSent),Start(StimSent)));
Qstim=MakeQfromS(stim,binSize);
Qs2=full(Data(Qstim));
Qstimtsd=tsd(Range(Qstim),Qs2(:,1));

[X,lag]=xcorr(Data(Qtsd),Data(Qstimtsd),100);

[C,B]=CrossCorr(Range(S{numclust}),Start(StimSent),1,100);

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

saveas(f, [dir_out 'Boxes1_M936_Karim.fig']);
saveFigure(f,'Boxes1_M936_Karim',dir_out);