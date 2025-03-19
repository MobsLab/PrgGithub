%% This script analyse the signals from the VLPO-anesthesia experiment and after the pre-processing

clear all
clc
close all

% paths of the folders of the different proportions of isoflurane to analyse together, choose one experiment

% % M645_1,0_to_1,8_2
% DataLocation{1}='/media/mobschapeau/DATAMOBS85/Anesthesie_TG/Mouse645/manip 2/M645_Isoflurane_1,0_Stim_180524_122843';
% DataLocation{2}='/media/mobschapeau/DATAMOBS85/Anesthesie_TG/Mouse645/manip 2/M645_Isoflurane_1,2_Stim_180524_132038';
% DataLocation{3}='/media/mobschapeau/DATAMOBS85/Anesthesie_TG/Mouse645/manip 2/M645_Isoflurane_1,5_Stim_180524_141356';
% DataLocation{4}='/media/mobschapeau/DATAMOBS85/Anesthesie_TG/Mouse645/manip 2/M645_Isoflurane_1,8_Stim_180524_150246';

% % M645_0,8_to_1,5_1
% DataLocation{1}='/media/mobschapeau/DATAMOBS85/Anesthesie_TG/Mouse645/manip 1/M645_Isoflurane_0,8_Stim_180522_172049';
% DataLocation{2}='/media/mobschapeau/DATAMOBS85/Anesthesie_TG/Mouse645/manip 1/M645_Isoflurane_1,5_Base_180522_175957';
 
% % M711_0,8_to_1,5_1
% DataLocation{1}='/media/mobschapeau/DATAMOBS85/Anesthesie_TG/Mouse711/manip 1/M711_Isoflurane_080_Stim_180613_125800';
% DataLocation{2}='/media/mobschapeau/DATAMOBS85/Anesthesie_TG/Mouse711/manip 1/M711_Isoflurane_100_Stim_180613_134926';
% DataLocation{3}='/media/mobschapeau/DATAMOBS85/Anesthesie_TG/Mouse711/manip 1/M711_Isoflurane_125_Stim_180613_144012';
% DataLocation{4}='/media/mobschapeau/DATAMOBS85/Anesthesie_TG/Mouse711/manip 1/M711_Isoflurane_150_Stim_180613_154039';

% M711_0,8_to_1,8_2
% DataLocation{1}='/media/mobschapeau/DATAMOBS85/Anesthesie_TG/Mouse711/manip 2/M711_Isoflurane_080_Stim_180619_150113';
DataLocation{1}='/media/mobschapeau/DATAMOBS85/Anesthesie_TG/Mouse711/manip 2/M711_Isoflurane_100_Stim_180619_152512';
DataLocation{2}='/media/mobschapeau/DATAMOBS85/Anesthesie_TG/Mouse711/manip 2/M711_Isoflurane_125_Stim_180619_161517';
DataLocation{3}='/media/mobschapeau/DATAMOBS85/Anesthesie_TG/Mouse711/manip 2/M711_Isoflurane_150_Stim_180619_170524';
DataLocation{4}='/media/mobschapeau/DATAMOBS85/Anesthesie_TG/Mouse711/manip 2/M711_Isoflurane_180_Stim_180619_175803';

% % M645_0,8_to_1,5_3
% DataLocation{1}='/media/mobschapeau/DATAMOBS85/Anesthesie_TG/Mouse645/manip 3/M645_Isoflurane_080_Stim_180620_140352';
% DataLocation{2}='/media/mobschapeau/DATAMOBS85/Anesthesie_TG/Mouse645/manip 3/M645_Isoflurane_100_Stim_180620_145201';
% DataLocation{3}='/media/mobschapeau/DATAMOBS85/Anesthesie_TG/Mouse645/manip 3/M645_Isoflurane_125_Stim_180620_154927';
% DataLocation{4}='/media/mobschapeau/DATAMOBS85/Anesthesie_TG/Mouse645/manip 3/M645_Isoflurane_150_Stim_180620_163656';


%% initialisation
M_NoOpto = {};
M_Opto = {};
Datas = {};
Max_opto = {};
Max_no_opto = {};
Mean_opto = {};
Mean_no_opto = {};
Area_opto = {};
Area_no_opto = {};


for i=1:length(DataLocation) %loop on the folders of the different isoflurane rates
    
    % change folder
    cd(DataLocation{i})
    DataLocation{i}
    
    % Data for the name of the experiment (mouse, night, percentage of
    % isoflurane)
    ind = strfind(DataLocation{i},'/M');
    Mouse_Nb = DataLocation{i}(ind(2)+1:ind(2)+4);
    Isoflurane = [DataLocation{i}(ind(2)+17) '.' DataLocation{i}(ind(2)+18:ind(2)+19)];
    Night_Stim = DataLocation{i}(ind(2)+26:ind(2)+31);
    Datas{i}{1} = Mouse_Nb;
    Datas{i}{2} = Isoflurane;
    Datas{i}{3} = Night_Stim;

    %load the accelero signal
    load(fullfile(cd,'behavResources.mat'))

    % load eyeshock stim file
    load('LFPData/DigInfo3.mat')
    TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above');
    TTLEpoch_merged = mergeCloseIntervals(TTLEpoch,1e4);
    Stim_Times = ts((Start(TTLEpoch_merged)));

    % load opto stim file
    load('LFPData/DigInfo2.mat')
    TTLEpoch = thresholdIntervals(DigTSD,0.99,'Direction','Above');
    TTLEpoch_merged_opto = mergeCloseIntervals(TTLEpoch,1e4);
    Stim_Times_Opto = (Start(TTLEpoch_merged_opto,'s'));
    Stim_Times_Opto_Epoch = intervalSet(Stim_Times_Opto*1e4,Stim_Times_Opto*1e4+60*1e4);
    
    TotalEpoch = intervalSet(0,max(Range(MovAcctsd)));
  
    %extraction of the accelero signal for each eyeshock stim during opto stim and make the average
    [M_Opto{i},T]=PlotRipRaw(MovAcctsd,Range(Restrict(Stim_Times,Stim_Times_Opto_Epoch),'s'),3000,0,0);
    
    %calculate the max, the mean, and the area of the pic of the accelero
    %signal due to the eyeshock stim (signal between the time of the tim + 0.5s
    restrict = find(((M_Opto{1}(:,1))>=0)&(M_Opto{1}(:,1))<=0.5);
    Max_opto{i} = max(T(:,restrict),[],2)';
    Mean_opto{i} = mean(T(:,restrict),2)';
    Area_opto{i} = trapz(M_Opto{1}(restrict,1),T(:,restrict),2);
    
    %plot of the pic of the accelero signal due by each eyeshock stim
    figure
    for t = 1:length(T(:,1))
        subplot(5,2,t)
        plot(M_Opto{i}(:,1),T(t,:))
%         ylim([0,4e8])
    end
    suptitle([Mouse_Nb ' - Isoflurane ' Isoflurane ' - Stim ' Night_Stim ' - opto' ])
    
    %extraction of the accelero signal for each eyeshock stim without opto stim and make the average
    [M_NoOpto{i},T]=PlotRipRaw(MovAcctsd,Range(Restrict(Stim_Times,TotalEpoch-Stim_Times_Opto_Epoch),'s'),3000,0,0);
    
    %calculate the max, the mean, and the area of the pic of the accelero
    %signal due to the eyeshock stim (signal between the time of the tim + 0.5s
    restrict = find(((M_NoOpto{1}(:,1))>=0)&(M_NoOpto{1}(:,1))<=0.5);
    Max_no_opto{i} = max(T(:,restrict),[],2)';
    Mean_no_opto{i} = mean(T(:,restrict),2)';
    Area_no_opto{i} = trapz(M_NoOpto{1}(restrict,1),T(:,restrict),2);
    
    %plot of the pic of the accelero signal due by each eyeshock stim
    figure
    for t = 1:length(T(:,1))
        subplot(5,2,t)
        plot(M_NoOpto{i}(:,1),T(t,:))
%         ylim([0,4e8])
    end
    suptitle([Mouse_Nb ' - Isoflurane ' Isoflurane ' - no opto' ])
    
    %% spectrum
    
    % decide the middle of the spectrum
    event_opto=(Start(TTLEpoch_merged_opto)/1E4)+30;
    event_no_opto = (Start(TTLEpoch_merged_opto)/1E4)+105;
    
    %create the spectrum of the PFC deep and HPC deep if it does not exist
    %yet
    if ~(exist(fullfile(cd,'PFCx_deep_Low_Spectrum.mat'), 'file') == 2)
        %Calcul du spectre PFCx
        load('ChannelsToAnalyse/PFCx_deep.mat')
        LowSpectrumjulien([cd filesep],channel,'PFCx_deep');
    end
    if ~(exist(fullfile(cd,'dHPC_deep_Low_Spectrum.mat'), 'file') == 2)
        %%Pour les plots Spectre du dHPC_deep
        load('ChannelsToAnalyse/dHPC_deep.mat')
        LowSpectrumjulien([cd filesep],channel,'dHPC_deep');
    end
    
    %Calculate the average spectrum of the PFC deep 30s before and after the events calculated before (with and without opto)
    load('PFCx_deep_Low_Spectrum.mat')
    [MV,SV,tV]=AverageSpectrogram_Anesthesia(tsd(Spectro{2}*1E4,10*log10(Spectro{1})),Spectro{3},ts(event_opto*1E4),500,150);
    title(['PFC - Isoflurane ' Isoflurane ' - opto'])
    colorbar
    [MV,SV,tV]=AverageSpectrogram_Anesthesia(tsd(Spectro{2}*1E4,10*log10(Spectro{1})),Spectro{3},ts(event_no_opto*1E4),500,150);
    title(['PFC - Isoflurane ' Isoflurane ' - no opto'])
    colorbar
    
    %Calculate the average spectrum of the HPC deep 30s before and after the events calculated before (with and without opto)
    load('dHPC_deep_Low_Spectrum.mat')
    [MV,SV,tV]=AverageSpectrogram_Anesthesia(tsd(Spectro{2}*1E4,10*log10(Spectro{1})),Spectro{3},ts(event_opto*1E4),500,150);
    title(['dHPC - Isoflurane ' Isoflurane ' - opto'])
    colorbar
    [MV,SV,tV]=AverageSpectrogram_Anesthesia(tsd(Spectro{2}*1E4,10*log10(Spectro{1})),Spectro{3},ts(event_no_opto*1E4),500,150);
    title(['dHPC - Isoflurane ' Isoflurane ' - no opto'])
    colorbar
    
    %saving the spectrogram
%     cd('/home/mobschapeau/Dropbox/Mobs_member/Apolline/Anesthesia/Spectrum')
%     
%     figure(2*i+1)
%     SaveName = [Mouse_Nb '_exp2_spectrum_PFC_' DataLocation{i}(ind(2)+17:ind(2)+19) '_opto'];
%     saveas(gcf,SaveName,'png') ;
%     saveas(gcf,SaveName,'fig') ;
%     
%     figure(2*i+2)
%     SaveName = [Mouse_Nb '_exp2_spectrum_PFC_' DataLocation{i}(ind(2)+17:ind(2)+19) '_no_opto'];
%     saveas(gcf,SaveName,'png') ;
%     saveas(gcf,SaveName,'fig') ;
%     
%     figure(2*i+3)
%     SaveName = [Mouse_Nb '_exp2_spectrum_dHPC_' DataLocation{i}(ind(2)+17:ind(2)+19) '_opto'];
%     saveas(gcf,SaveName,'png') ;
%     saveas(gcf,SaveName,'fig') ;
%     
%     figure(2*i+4)
%     SaveName = [Mouse_Nb '_exp2_spectrum_dHPC_' DataLocation{i}(ind(2)+17:ind(2)+19) '_no_opto'];
%     saveas(gcf,SaveName,'png') ;
%     saveas(gcf,SaveName,'fig') ;
%     
%     close(2*i+1)
%     close(2*i+2)
%     close(2*i+3)
%     close(2*i+4)
    
end



%% plot of the average accelero signal during eyeshock stim, with and without opto stim, for each isoflurane rate
figure
labels = {};

restrict = find((abs(M_Opto{1}(:,1)))<=0.6);

%with opto
subplot(1,2,1)
for j = 1:length(DataLocation)
    hold on, plot(M_Opto{j}(restrict,1),M_Opto{j}(restrict,2))
    labels{j} = Datas{j}{2};
end
legend(labels)
title('Opto')
xlabel('time(s)')
ylabel('voltage')
yl=ylim;

%without opto
subplot(1,2,2)
for j = 1:length(DataLocation)
    hold on, plot(M_NoOpto{j}(restrict,1),M_NoOpto{j}(restrict,2))
    labels{j} = Datas{j}{2};
end
legend(labels)
title('No Opto')
ylabel('voltage')
xlabel('time(s)')
ylim(yl)

suptitle([Datas{1}{1} ' - exp 2'])


%% max of the average accelero signal during eyeshock for each isoflurane rate
% PlotErrorBarN_KJ(Max_opto,'paired',0)
% title([Data{1}{1} ' - opto'])
% xticks(1:length(DataLocation))
% q={};
% for d = 1:length(DataLocation)
%     q{d} = DataLocation{d}(ind(2)+17:ind(2)+19);
% end
% xticklabels(q)
% xlabel('percent of Isoflurane')
% ylabel('maximum of the response signal')
% yl2 = ylim;
% 
% PlotErrorBarN_KJ(Max_no_opto,'paired',0)
% title([Data{1}{1} ' - no opto'])
% xticks(1:length(DataLocation))
% q={};
% for h = 1:length(DataLocation)
%     q{h} = DataLocation{h}(ind(2)+17:ind(2)+19);
% end
% xticklabels(q)
% xlabel('percent of Isoflurane')
% ylabel('maximum of the response signal')
% ylim(yl2)

FigureAnesthesia_Ap(Max_opto,Max_no_opto,1)
title([Datas{1}{1} ' - Maximum of the accelero signal during eyeshock'])
xticks(1:length(DataLocation))
q={};
for h = 1:length(DataLocation)
    q{h} = Datas{h}{2};
end
xticklabels(q)
xlabel('percent of Isoflurane')
ylabel('Average maximum of the accelero signal')


%% Mean of the average accelero signal during eyeshock for each isoflurane rate

FigureAnesthesia_Ap(Mean_opto,Mean_no_opto,1)
title([Datas{1}{1} ' - Average of the accelero signal during eyeshock'])
xticks(1:length(DataLocation))
q={};
for h = 1:length(DataLocation)
    q{h} = Datas{h}{2};
end
xticklabels(q)
xlabel('percent of Isoflurane')
ylabel('Average of the accelero signal betwen 0s and 0.5s after the stim')


%% Area of the average accelero signal during eyeshock for each isoflurane rate

FigureAnesthesia_Ap(Area_opto,Area_no_opto,1)
title([Datas{1}{1} ' - Area of the accelero signal during eyeshock'])
xticks(1:length(DataLocation))
q={};
for h = 1:length(DataLocation)
    q{h} = Datas{h}{2};
end
xticklabels(q)
xlabel('percent of Isoflurane')
ylabel('Area of the accelero signal betwen 0s and 0.5s after the stim')



cd('/home/mobschapeau/Dropbox/Mobs_member/Apolline/Anesthesia')
