%% Un petit code pour s'entrainer :)

clear all;
clf;

SpectroHLow = load('H_Low_Spectrum.mat');
SpectroBHigh = load('B_High_Spectrum.mat');

FreqHLow = SpectroHLow.Spectro{3};
FreqBHigh = SpectroBHigh.Spectro{3};

Sp_tsd_Hlow = tsd(SpectroHLow.Spectro{2}*1e4 , SpectroHLow.Spectro{1});
Sp_tsd_BHigh = tsd(SpectroBHigh.Spectro{2}*1e4 , SpectroBHigh.Spectro{1});

figure;
subplot(321);
imagesc(SpectroHLow.Spectro{2} , SpectroHLow.Spectro{3} , 10*log10(SpectroHLow.Spectro{1})');axis xy;
title 'HPC Low'; 

subplot(323);
imagesc(SpectroBHigh.Spectro{2} , SpectroBHigh.Spectro{3} , 10*log10(SpectroBHigh.Spectro{1})');axis xy;
title 'Bulb High';

subplot(325);
load('behavResources_SB.mat');
MovAcctsd=Behav.MovAcctsd;
plot(Range(MovAcctsd,'s'),Data(MovAcctsd));
xlim([0 900]);
title 'Accelero';

subplot(322);
plot(FreqHLow, mean(Data(Sp_tsd_Hlow)));
title 'Mean Spectrum HPC Low';

subplot(324);
plot(FreqBHigh, mean(Data(Sp_tsd_BHigh)));
title 'Mean Spectrum Bulb High';

subplot(326);
load('HeartBeatInfo.mat', 'EKG');
plot(Range(EKG.HBRate,'s'),Data(EKG.HBRate));
xlim([0 900]);
title 'Heartbeat Rate';

%%
figure
load('StateEpochSB.mat')
Sp_tsd_HlowREM = Restrict(Sp_tsd_Hlow,REMEpoch);
% plot(Range(Sp_tsd_HlowREM,'s'), Data(Sp_tsd_HlowREM),'.')
Sp_tsd_HlowREM_mean = mean(Data(Sp_tsd_HlowREM));
Sp_tsd_BHigh_Wake = Restrict(Sp_tsd_BHigh,Wake);

subplot(121);
plot(FreqHLow,mean(Data(Restrict(Sp_tsd_Hlow,REMEpoch))));
title 'HPC Low REM';

subplot(122);
plot(FreqBHigh,mean(Data(Restrict(Sp_tsd_BHigh,Wake))));
title 'Bulb High Wake'

% a=a+1; hold on, plot(FreqHLow,mean(Data(Restrict(Sp_tsd_Hlow,subset(REMEpoch,a)))))
figure
plot(FreqHLow,mean(Data(Restrict(Sp_tsd_Hlow,REMEpoch))));
hold on;
plot(FreqBHigh,mean(Data(Restrict(Sp_tsd_BHigh,Wake))));

%%

clear all;
clf;
load('behavResources_SB.mat');
load('HeartBeatInfo.mat', 'EKG');

MovAcctsd=Behav.MovAcctsd;

SpectroHLow = load('H_Low_Spectrum.mat');
SpectroBLow = load('B_Low_Spectrum.mat');

FreqHLow = SpectroHLow.Spectro{3};
FreqBLow = SpectroBLow.Spectro{3};

Sp_tsd_Hlow = tsd(SpectroHLow.Spectro{2}*1e4 , SpectroHLow.Spectro{1});
Sp_tsd_BLow = tsd(SpectroBLow.Spectro{2}*1e4 , SpectroBLow.Spectro{1});

MovAcctsd_Fz = Restrict(MovAcctsd,Behav.FreezeAccEpoch);
HR_Fz = Restrict(EKG.HBRate,Behav.FreezeAccEpoch);

figure;
subplot(3,4,1:3);
imagesc(SpectroHLow.Spectro{2} , SpectroHLow.Spectro{3} , 10*log10(SpectroHLow.Spectro{1})');axis xy;
ylim([0 15]);
makepretty;
title 'HPC Low'; 

subplot(3,4,5:7);
imagesc(SpectroBLow.Spectro{2} , SpectroBLow.Spectro{3} , 10*log10(SpectroBLow.Spectro{1})');axis xy;
ylim([0 12]);
makepretty;
title 'Bulb Low';

subplot(325);
MovAcctsd=Behav.MovAcctsd;
plot(Range(MovAcctsd,'s'),Data(MovAcctsd));
hold on;
plot(Range(MovAcctsd_Fz,'s'),Data(MovAcctsd_Fz));
xlim([0 900]);
title 'Accelero';

subplot(344);
plot(FreqHLow, mean(Data(Sp_tsd_Hlow)));
xlim([0 15]);
makepretty;
title 'Mean Spectrum HPC Low';

subplot(348);
plot(FreqBLow, mean(Data(Sp_tsd_BLow)));
xlim([0 12]);
makepretty;
title 'Mean Spectrum Bulb Low';

subplot(326);
plot(Range(EKG.HBRate,'s'),Data(EKG.HBRate));
hold on;
plot(Range(HR_Fz,'s'),Data(HR_Fz));
xlim([0 900]);
title 'Heartbeat Rate';


%%
figure;
load('behavResources_SB.mat');
Xtsd = Behav.AlignedXtsd;
Ytsd = Behav.AlignedYtsd;

SpectroHLow = load('H_Low_Spectrum.mat');
SpectroBLow = load('B_Low_Spectrum.mat');

FreqHLow = SpectroHLow.Spectro{3};
FreqBLow = SpectroBLow.Spectro{3};

Sp_tsd_Hlow = tsd(SpectroHLow.Spectro{2}*1e4 , SpectroHLow.Spectro{1});
Sp_tsd_BLow = tsd(SpectroBLow.Spectro{2}*1e4 , SpectroBLow.Spectro{1});

ShockFreezeEpoch = and(Behav.FreezeAccEpoch,Behav.ZoneEpoch{1})
SafeFreezeEpoch = and(Behav.FreezeAccEpoch,or(Behav.ZoneEpoch{2},Behav.ZoneEpoch{5}))

SpectroBLow_Fz =  Restrict(Sp_tsd_BLow,Behav.FreezeAccEpoch);
SpectroBLow_Shock = Restrict(Sp_tsd_BLow,ShockFreezeEpoch);
SpectroBLow_Safe = Restrict(Sp_tsd_BLow,SafeFreezeEpoch);

plot(Data(Xtsd),Data(Ytsd))
hold on;
plot(Data(Restrict(Xtsd,Behav.ZoneEpoch{1})),Data(Restrict(Ytsd,Behav.ZoneEpoch{1, 1})))

figure;
plot(FreqBLow,mean(Data(SpectroBLow_Shock)),'r')
hold on
plot(FreqBLow,mean(Data(SpectroBLow_Safe)),'b')
xlim([0 12]);
makepretty;
title 'Mean Spectrum Freezing Safe';


figure
imagesc((10*log10(Data(SpectroBLow_Fz)))'), axis xy


A=mtitle('jhillkS'); A.FontSize=20; A.FontWeight='bold';

%%
% Figure that gives HPC low and Bulb Low spectrograms during either active
% or freezing epochs, next to mean spectrograms during freezing or active
% epochs
clear all

Mouse = 1447

load('behavResources_SB.mat');
Xtsd = Behav.AlignedXtsd;
Ytsd = Behav.AlignedYtsd;

load('StateEpochSB.mat', 'Epoch')

SpectroHLow = load('H_Low_Spectrum.mat');
SpectroBLow = load('B_Low_Spectrum.mat');

FreqHLow = SpectroHLow.Spectro{3};
FreqBLow = SpectroBLow.Spectro{3};

Sp_tsd_HLow = tsd(SpectroHLow.Spectro{2}*1e4 , SpectroHLow.Spectro{1});
Sp_tsd_BLow = tsd(SpectroBLow.Spectro{2}*1e4 , SpectroBLow.Spectro{1});

ShockFreezeEpoch = and(Behav.FreezeAccEpoch,Behav.ZoneEpoch{1})
SafeFreezeEpoch = and(Behav.FreezeAccEpoch,or(Behav.ZoneEpoch{2},Behav.ZoneEpoch{5}))
ActEpoch = Epoch-Behav.FreezeAccEpoch;

SpectroBLow_Fz =  Restrict(Sp_tsd_BLow,Behav.FreezeAccEpoch);
SpectroBLow_Shock = Restrict(Sp_tsd_BLow,ShockFreezeEpoch);
SpectroBLow_Safe = Restrict(Sp_tsd_BLow,SafeFreezeEpoch);
SpectroBLow_Act =  Restrict(Sp_tsd_BLow,ActEpoch);

SpectroHLow_Fz =  Restrict(Sp_tsd_HLow,Behav.FreezeAccEpoch);
SpectroHLow_Act =  Restrict(Sp_tsd_BLow,ActEpoch);


figure;
subplot(2,8,[1,2,3]);
imagesc(SpectroHLow.Spectro{2} , SpectroHLow.Spectro{3} , 10*log10(SpectroHLow.Spectro{1})');axis xy;
ylim([0 15]);
makepretty;
title 'HPC Active'; 

subplot(2,8,[9,10,11]);
imagesc(SpectroBLow.Spectro{2} , SpectroBLow.Spectro{3} , 10*log10(SpectroBLow.Spectro{1})');axis xy;
ylim([0 12]);
makepretty;
title 'Bulb Active';

subplot(2,8,[7,8]);
plot(FreqHLow, mean(Data(SpectroHLow_Fz)),'r');
hold on
plot(FreqHLow,mean(Data(SpectroHLow_Act)),'b')
xlim([0 15]);
makepretty;
title 'Mean Spectrum HPC';
legend('Freezing','Active');

subplot(2,8,[15,16]);
plot(FreqBLow, mean(Data(SpectroBLow_Fz)),'r');
hold on
plot(FreqBLow,mean(Data(SpectroBLow_Act)),'b')
xlim([0 12]);
makepretty;
title 'Mean Spectrum Bulb';
legend('Freezing','Active');


subplot(2,8,[4,5,6]);
imagesc(linspace(0,39,195), SpectroHLow.Spectro{3} , (10*log10(Data(SpectroHLow_Fz)))'), axis xy
ylim([0 15]);
makepretty;
title 'HPC Freezing'; 


subplot(2,8,[12,13,14]);
imagesc(linspace(0,39,195), SpectroHLow.Spectro{3} , (10*log10(Data(SpectroBLow_Fz)))'), axis xy
ylim([0 15]);
makepretty;
title 'Bulb Freezing'; 



A=mtitle(['Mouse' num2str(Mouse)]); A.FontSize=20; A.FontWeight='bold';
u=text(-200,5,'HPC'); set(u,'Rotation',90,'FontWeight','bold','FontSize',25)
u=text(-200,-15,'Bulb'); set(u,'Rotation',90,'FontWeight','bold','FontSize',25)

%% Occupation maps

h=hist2d(Data(Behav.AlignedXtsd) , Data(Behav.AlignedYtsd) , 100 , 100);

H=log(h); H(H==-Inf)=0; % Permet d'augmenter les différences entre les petites valeurs, puis de convertir les -Inf en 0

imagesc(runmean(runmean(H',5)',5)'), axis xy % runmean permet de smooth les valeurs de x et y, les apostrophes permettent de remettre le Maze à l'endroit
caxis([0 1.5])
colormap hot
colormap bone

%%

figure
plot(Range(HR.Wake,'s')/60,runmean(Data(HR.Wake),100) , '.b','MarkerSize', 3);hold on 
% runmean (Data; x) is used to calculate the mean value of data on x (here
% for example the 126th value is the mean frequency between the 26th and
% the 226th value.
plot(Range(HR.SWS,'s')/60,runmean(Data(HR.SWS),100) , '.r','MarkerSize', 3);hold on
plot(Range(HR.REM,'s')/60,runmean(Data(HR.REM),100) , '.g','MarkerSize', 3);hold on
PlotPerAsLine(Wake, 14, 'b', 'timescaling', 60e4, 'linewidth',5)
PlotPerAsLine(SWSEpoch, 14, 'r', 'timescaling', 60e4, 'linewidth',10)
PlotPerAsLine(REMEpoch, 14, 'g', 'timescaling', 60e4, 'linewidth',10)
ylim([5 14])
ylabel('Frequency (Hz)'), xlabel('Time (minutes)')
title('HR Wake (blue), SWS (red), REM (green)')


%%

for f=1:length(FolderName)
    cd(FolderName{f})
    
    load('ExpeInfo.mat')
    ExpeInfo.ChannelToAnalyse.Bulb_deep=19;
    save('ExpeInfo.mat','ExpeInfo')
    channel=19;
    save('ChannelsToAnalyse/Bulb_deep.mat','channel')
    
end

%%

load('/media/nas6/ProjetEmbReact/transfer/Sess.mat')

GetEmbReactMiceFolderList_BM


for mouse=1:length(Mouse)
    for sess=1:length(Sess.(Mouse_names{mouse}))
                
        load([Sess.(Mouse_names{mouse}){sess} filesep 'StateEpochSB.mat'], 'Epoch')
        JumpEp = FindJumpsWithAccelerometer_SB(Sess.(Mouse_names{mouse}){sess},Epoch);
        load([Sess.(Mouse_names{mouse}){sess} filesep 'behavResources_SB.mat'], 'Behav')
        Behav.JumpEpoch = JumpEp;
        save([Sess.(Mouse_names{mouse}){sess} filesep 'behavResources_SB.mat'], 'Behav','-append')
        clear Behav
        
    end
    disp(Mouse_names{mouse})
end
