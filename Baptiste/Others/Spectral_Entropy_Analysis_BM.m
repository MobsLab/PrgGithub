


Mouse=1226;
Session_type={'Fear','Fear','Ext'};
cd('/media/nas6/ProjetEmbReact/transfer')
load('Sess.mat')

for mouse = 1:length(Mouse) % generate all sessions of interest
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    FearSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Fear')))));
    ExtSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Ext')))));
    FearSessCorrections
    FearSess.(Mouse_names{mouse}) =  [FearSess.(Mouse_names{mouse}) ExtSess.(Mouse_names{mouse})];
end
for mouse = 1:length(Mouse_names)
    for sess=1:length(Session_type)
        if sess==1; Sess_To_use=FearSess.(Mouse_names{mouse});
        elseif sess==2; Sess_To_use=FearSess.(Mouse_names{mouse});
        else Sess_To_use=ExtSess.(Mouse_names{mouse});
        end
        OBSpec.(Session_type{sess}).(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(Sess_To_use,'spectrum','prefix','B_Low');
        Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(Sess_To_use,'Epoch','epochname','freezeepoch');
        ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(Sess_To_use,'Epoch','epochname','zoneepoch');
        ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){1};
        SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = or(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){2},ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){5});
        OBSpec.(Session_type{sess}).Fz.(Mouse_names{mouse})=Restrict(OBSpec.(Session_type{sess}).(Mouse_names{mouse}),Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}));
        OBSpec.(Session_type{sess}).Fz_Shock.(Mouse_names{mouse})=Restrict(OBSpec.(Session_type{sess}).Fz.(Mouse_names{mouse}),ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}) );
        OBSpec.(Session_type{sess}).Fz_Safe.(Mouse_names{mouse})=Restrict(OBSpec.(Session_type{sess}).Fz.(Mouse_names{mouse}),SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}));
    end
end

DataSpectro=Data(OBSpec.Fear.(Mouse_names{mouse}));
RangeSpectro=Range(OBSpec.Fear.(Mouse_names{mouse}));
                
load('B_Low_Spectrum.mat')
clear Entropy Entropy2 RangeEntropy2
for t=6:6:length(DataSpectro)-6
    P=sum(abs(fft(DataSpectro([t:t+6],:).*Spectro{1, 3})).^2);
    %Normalization
    d=P(:);
    d=d/sum(d+ 1e-12);
    %Entropy Calculation
    logd = log2(d + 1e-12);
    Entropy(t/6) = -sum(d.*logd)/log2(length(d));
    % Entropy(t/6) = Entropy(t/6)./log(sum(mean(DataSpectro([t:t+6],26:78).*Spectro{1, 3}(26:78))));
    Entropy2(t/6) = Entropy(t/6)/(sum(mean(DataSpectro([t:t+6],26:78)).*Spectro{1, 3}(26:78))./sum(mean(DataSpectro([t:t+6],[1:26 78:261])).*Spectro{1, 3}([1:26 78:261])));
    RangeEntropy2(t/6) = RangeSpectro(t);
end

Entropy_tsd=tsd(RangeEntropy2',runmean(Entropy,5)');
Entropy_Fz=Restrict(Entropy_tsd,Freeze_Epoch.Fear.(Mouse_names{mouse}));

figure
imagesc(RangeSpectro/1e4 , Spectro{1, 3} , (DataSpectro.*Spectro{1, 3})'); axis xy
caxis([0 2e6])
hold on
line([Start(Freeze_Epoch.Fear.(Mouse_names{mouse}))/1e4 Stop(Freeze_Epoch.Fear.(Mouse_names{mouse}))/1e4],[18 18],'Color','r','linewidth',4)
makepretty
plot(Range(Entropy_tsd,'s') , Data(Entropy_tsd)*20 , 'lineWidth',2,'Color','y')
plot(Range(Entropy_Fz,'s') , Data(Entropy_Fz)*20 , 'lineWidth',2,'Color','r')
legend('Freezing')
xlabel('time (s)')
ylabel('Frequency (Hz)')
title('OB Low spectrum on a full Maze session')

figure
h = histogram(Data(Entropy_tsd),300);
hold on
histogram(Data(Entropy_Fz),300);
xlabel('Entropy value')
ylabel('#')
title('Entropy values distribution for OB spectrogram along a Maze session')
legend('All','Freezing')
makepretty

figure
plot(Range(Entropy_tsd) , Data(Entropy_tsd))
hold on
plot(Range(Entropy_Fz) , Data(Entropy_Fz))
hline(1,'-r')


%%
LowEntropy_Epoch = thresholdIntervals(Entropy_tsd,0.75,'Direction','Below');
LowEntropy_Epoch=mergeCloseIntervals(LowEntropy_Epoch,0.3*1e4);
LowEntropy_Epoch=dropShortIntervals(LowEntropy_Epoch,2*1e4);
Entropy_tsd_Fz=Restrict(Entropy_tsd,LowEntropy_Epoch);
DataSpectro_LowEntropy=Restrict(OBSpec.Fear.(Mouse_names{mouse}),LowEntropy_Epoch);

figure
plot(Range(Entropy_tsd,'s'),Data(Entropy_tsd))
hold on
plot(Range(Entropy_tsd_Fz,'s'),Data(Entropy_tsd_Fz),'g')
makepretty
legend('All','Low entropy values')
xlabel('time (s)')
ylabel('Entropy')
title('Entropy values along a Maze session')

figure
imagesc(Range(DataSpectro_LowEntropy)/1e4 , Spectro{1, 3} ,(Data(DataSpectro_LowEntropy).*Spectro{1, 3})'); axis xy; caxis([0 2e6])
xlabel('time (s)')
ylabel('Frequency (Hz)')
title('OB spectrograms for epochs with low entropy')
makepretty

line([Start(LowEntropy_Epoch)/1e4 Stop(LowEntropy_Epoch)/1e4],[19 19],'Color','g','linewidth',4)


%% Power method

for t=6:6:length(DataSpectro)-6
    P_2_6(t/6) = sum(mean(DataSpectro([t:t+6],26:78)).*Spectro{1, 3}(26:78))./sum(mean(DataSpectro([t:t+6],[1:26 78:261])).*Spectro{1, 3}([1:26 78:261]));
end

P_2_6_tsd = tsd(RangeEntropy2',runmean(P_2_6,5)');
P_2_6_Epoch = thresholdIntervals(P_2_6_tsd,1.5,'Direction','Above');
P_2_6_Epoch=mergeCloseIntervals(P_2_6_tsd,0.3*1e4);
P_2_6_Epoch=dropShortIntervals(P_2_6_tsd,2*1e4);
P_2_6_High=Restrict(P_2_6_tsd,P_2_6_Epoch);
DataSpectro_P_2_6_High=Restrict(OBSpec.Fear.(Mouse_names{mouse}),P_2_6_Epoch);


line([Start(P_2_6_Epoch)/1e4 Stop(P_2_6_Epoch)/1e4],[19.5 19.5],'Color','k','linewidth',4)

figure
imagesc(Range(DataSpectro_P_2_6_High)/1e4 , Spectro{1, 3} ,(Data(DataSpectro_P_2_6_High).*Spectro{1, 3})'); axis xy; caxis([0 2e6])
xlabel('time (s)')
ylabel('Frequency (Hz)')
title('OB spectrograms for epochs with high 2-6 power')
makepretty

figure
histogram(Data(P_2_6_tsd),300)
hold on
histogram(Data(P_2_6_High),300);
xlabel('Power value')
ylabel('#')
title('Power values distribution for OB spectrogram along a Maze session')
legend('All','Freezing')
vline(1.5,'-r')
makepretty

figure
plot(Range(P_2_6_tsd),Data(P_2_6_tsd))
hold on
plot(Range(P_2_6_High),Data(P_2_6_High),'k')
makepretty
legend('All','High power values')
xlabel('time (s)')
ylabel('Power (a.u)')
title('Power values along a Maze session')



