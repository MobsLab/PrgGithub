
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                          %  MICE PART   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Sleep scoring based on OB
cd('/media/nas7/ProjetEmbReact/Mouse1379/20221020/')
load('SleepScoring_OBGamma.mat', 'Epoch', 'Wake', 'Sleep' ,'SWSEpoch', 'REMEpoch', 'SmoothGamma', 'SmoothTheta')
smootime = 3;
SmoothThetam = SmoothTheta;
SmoothGammam = SmoothGamma;
Wakem = Wake;
Sleepm = Sleep;
SWSEpochm = SWSEpoch;
REMEpochm = REMEpoch;
Epochm = Epoch;


% Raw signals
for l=[6 12 21 31 18] % EMG, EKG, OBm, PFCm, HPCm
    load(['LFPData/LFP' num2str(l) '.mat'])
    LFP_mouse{l} = LFP;
end

figure
subplot(121)
i=0;
for l=[6 12 21 31 18]
    plot(Range(LFP_mouse{l},'s') , Data(LFP_mouse{l})-i*1e4 , 'k')
%     plot(Range(LFP_mouse{l},'s') , abs(hilbert(Data(FilterLFP(LFP_mouse{l},[1 500],1024))))-i*1e4 , 'k')
    hold on
    i=i+1;
end
xlim([286 288]), axis off


% EMG / OB gamma --> Wake-Sleep
load('ChannelsToAnalyse/EMG.mat', 'channel')
load(['LFPData/LFP' num2str(channel) '.mat'])

LFP = Restrict(LFP, Epoch);
FilLFP=FilterLFP(LFP,[50 300],1024);
EMGDatam=tsd(Range(FilLFP),runmean(Data((FilLFP)).^2,ceil(smootime/median(diff(Range(FilLFP,'s'))))));

SmoothGammam = Restrict(SmoothGamma,Epoch);
SmoothGamma_intm = Restrict(SmoothGamma,EMGDatam);
SmoothGamma_int2m = Restrict(SmoothGamma,SmoothThetam);

figure
subplot(6,6,32:36)
[Y,X] = hist(log10(Data(SmoothGammam)),1000);
a = area(X , runmean(Y,3)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
box off
v1=vline(2.4,'-r'); v1.LineWidth=5;
xlabel('OB gamma power (log scale)'); xlim([2 3.1])

subplot(6,6,[25 19 13 7 1])
[Y,X] = hist(log10(Data(EMGDatam)),1000);
a = area(X , runmean(Y,3)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
set(gca,'XDir','reverse'), camroll(270), box off
v2=vline(4.5,'-r'); v2.LineWidth=5;
xlabel('EMG power (log scale)');
 
subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
X = log10(Data(SmoothGamma_intm)); Y = log10(Data(EMGDatam)); 
plot(X(1:2000:end) , Y(1:2000:end) , '.k')
axis square
v1=vline(2.4,'-r'); v1.LineWidth=5;
v2=hline(4.5,'-r'); v2.LineWidth=5;
xlim([2 3.1])


% REM
figure
subplot(6,6,32:36)
[Y,X] = hist(log10(Data(SmoothGammam)),1000);
a = area(X , runmean(Y,3)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
box off
v1=vline(2.4,'-r'); v1.LineWidth=5;
xlabel('OB gamma power (log scale)');

subplot(6,6,[25 19 13 7 1])
[Y,X] = hist(log10(Data(Restrict(SmoothThetam , Sleepm))),1000);
a = area(X , runmean(Y,3)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
set(gca,'XDir','reverse'), camroll(270), box off
v2=vline(.45,'-r'); v2.LineWidth=5;
xlabel('theta / delta power (a.u.)'); 
 
subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
X = log10(Data(Restrict(SmoothGamma_int2m , Wakem))); Y = log10(Data(Restrict(SmoothThetam , Wakem))); 
plot(X(1:1000:end) , Y(1:1000:end) , '.b'), hold on
X = log10(Data(Restrict(SmoothGamma_int2m , SWSEpochm))); Y = log10(Data(Restrict(SmoothThetam , SWSEpochm))); 
plot(X(1:1000:end) , Y(1:1000:end) , '.r')
X = log10(Data(Restrict(SmoothGamma_int2m , REMEpochm))); Y = log10(Data(Restrict(SmoothThetam , REMEpochm))); 
plot(X(1:1000:end) , Y(1:1000:end) , '.g')
axis square
f=get(gca,'Children'); l=legend([f([3 2 1])],'Wake','NREM','REM'); l.FontSize=20;


% Mean spectrum
for m=1:6
    if m==1
        load('B_Low_Spectrum.mat')
        RANGE = Spectro{3};
        Range_Low = Spectro{3};
    elseif m==2
        load('PFCx_Low_Spectrum.mat')
    elseif m==3
        load('H_Low_Spectrum.mat')
    elseif m==4
        load('B_Middle_Spectrum.mat')
        RANGE = Spectro{3};
        Range_Middle = Spectro{3};
    elseif m==5
        load('PFCx_Middle_Spectrum.mat')
    elseif m==6
        load('H_Middle_Spectrum.mat')
    end
    
    Sptsd_m{m} = tsd(Spectro{2}*1e4 , Spectro{1});
    for states=1:3
        if states==1
            State = Wakem;
        elseif states==2
            State = SWSEpochm;
        elseif states==3
            State = REMEpochm;
        end
        
        Sp_ByState_m{m}{states} = Restrict(Sptsd_m{m} , State);
        if m<4
%             Sp_ByState_m{m}{states} = CleanSpectro(Sp_ByState_m{m}{states} , RANGE , 8);
            Mean_Spec_m{m}(states,:) = nanmean(Data(Sp_ByState_m{m}{states}));
        else
            Mean_Spec_m{m}(states,:) = nanmean(log10(Data(Sp_ByState_m{m}{states})));
        end
    end
end
clear Sp_ByState_m Sptsd_m

Cols={'b','r','g'};
figure
for m=1:6
    subplot(2,6,m)
    for states=1:3
        if m<4
            plot(Range_Low , Mean_Spec_m{m}(states,:) , Cols{states} , 'LineWidth' , 2), hold on
        else
            plot(Range_Middle , Mean_Spec_m{m}(states,:) , Cols{states} , 'LineWidth' , 2), hold on
        end
        if m==1; legend('Wake','NREM','REM'), end
    end
end


% State analysis
edit Ferret_states_proportion.m






%% Head restraint sleep



load('H_Low_Spectrum.mat')
load('B_Middle_Spectrum.mat')




        
save('/media/nas7/React_Passive_AG/Data_Paper/Fig1.mat')

