

%% What can influence freezing frequency

Mouse=[849];

for mouse = 1:length(Mouse) % generate all sessions of interest
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    Sess.(Mouse_names{mouse}) = GetAllMouseTaskSessions(Mouse(mouse));
    TestPostSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPost')))));
    TestSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Test')))));
    CondSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Cond')))));
    CondSessCorrections
    ExtSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Ext')))));
    FearSess.(Mouse_names{mouse}) =  [CondSess.(Mouse_names{mouse}) ExtSess.(Mouse_names{mouse})];
    TestPreSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPre')))));
end


for mouse = 1:length(Mouse_names)
    OBSpec.Fear.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FearSess.(Mouse_names{mouse}),'spectrum','prefix','B_Low');
    Freeze_Epoch.Fear.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FearSess.(Mouse_names{mouse}),'Epoch','epochname','freezeepoch');
    ZoneEpoch.Fear.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FearSess.(Mouse_names{mouse}),'Epoch','epochname','zoneepoch');
    
    ShockEpoch.Fear.(Mouse_names{mouse}) = ZoneEpoch.Fear.(Mouse_names{mouse}){1};
    SafeEpoch.Fear.(Mouse_names{mouse}) = or(ZoneEpoch.Fear.(Mouse_names{mouse}){2},ZoneEpoch.Fear.(Mouse_names{mouse}){5});
    
    OBSpec.Fear.Fz.(Mouse_names{mouse})=Restrict(OBSpec.Fear.(Mouse_names{mouse}),Freeze_Epoch.Fear.(Mouse_names{mouse}));
    OBSpec.Fear.Fz_Shock.(Mouse_names{mouse})=Restrict(OBSpec.Fear.Fz.(Mouse_names{mouse}),ShockEpoch.Fear.(Mouse_names{mouse}) );
    OBSpec.Fear.Fz_Safe.(Mouse_names{mouse})=Restrict(OBSpec.Fear.Fz.(Mouse_names{mouse}),SafeEpoch.Fear.(Mouse_names{mouse}));

    OBSpec.Cond.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'spectrum','prefix','B_Low');
    Freeze_Epoch.Cond.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'Epoch','epochname','freezeepoch');
    ZoneEpoch.Cond.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'Epoch','epochname','zoneepoch');
    
    ShockEpoch.Cond.(Mouse_names{mouse}) = ZoneEpoch.Cond.(Mouse_names{mouse}){1};
    SafeEpoch.Cond.(Mouse_names{mouse}) = or(ZoneEpoch.Cond.(Mouse_names{mouse}){2},ZoneEpoch.Cond.(Mouse_names{mouse}){5});
    
    OBSpec.Cond.Fz.(Mouse_names{mouse})=Restrict(OBSpec.Cond.(Mouse_names{mouse}),Freeze_Epoch.Cond.(Mouse_names{mouse}));
    OBSpec.Cond.Fz_Shock.(Mouse_names{mouse})=Restrict(OBSpec.Cond.Fz.(Mouse_names{mouse}),ShockEpoch.Cond.(Mouse_names{mouse}) );
    OBSpec.Cond.Fz_Safe.(Mouse_names{mouse})=Restrict(OBSpec.Cond.Fz.(Mouse_names{mouse}),SafeEpoch.Cond.(Mouse_names{mouse}));
for mouse = 1:length(Mouse_names)

    MaskTempeature.Fear.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FearSess.(Mouse_names{mouse}),'masktemperature');
    TailTempeature.Fear.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FearSess.(Mouse_names{mouse}),'tailtemperature');

    MaskTempeature.Fear.Fz.(Mouse_names{mouse})=Restrict(MaskTempeature.Fear.(Mouse_names{mouse}),Freeze_Epoch.Fear.(Mouse_names{mouse}));
    MaskTempeature.Fear.Fz_Shock.(Mouse_names{mouse})=Restrict(MaskTempeature.Fear.Fz.(Mouse_names{mouse}),ShockEpoch.Fear.(Mouse_names{mouse}) );
    MaskTempeature.Fear.Fz_Safe.(Mouse_names{mouse})=Restrict(MaskTempeature.Fear.Fz.(Mouse_names{mouse}),SafeEpoch.Fear.(Mouse_names{mouse}));

        TailTempeature.Fear.Fz.(Mouse_names{mouse})=Restrict(TailTempeature.Fear.(Mouse_names{mouse}),Freeze_Epoch.Fear.(Mouse_names{mouse}));
    TailTempeature.Fear.Fz_Shock.(Mouse_names{mouse})=Restrict(TailTempeature.Fear.Fz.(Mouse_names{mouse}),ShockEpoch.Fear.(Mouse_names{mouse}) );
    TailTempeature.Fear.Fz_Safe.(Mouse_names{mouse})=Restrict(TailTempeature.Fear.Fz.(Mouse_names{mouse}),SafeEpoch.Fear.(Mouse_names{mouse}));

end

load('B_Low_Spectrum.mat'); thr=1;

for mouse = 1:length(Mouse_names)
    
    Spectrum_Frequency.Fear.Fz.(Mouse_names{mouse}) = ConvertSpectrum_in_Frequencies_BM(Spectro{3} , Range(OBSpec.Fear.Fz.(Mouse_names{mouse})), Data(OBSpec.Fear.Fz.(Mouse_names{mouse})) , thr);
    Spectrum_Frequency.Fear.Fz_Shock.(Mouse_names{mouse}) = ConvertSpectrum_in_Frequencies_BM(Spectro{3} , Range(OBSpec.Fear.Fz_Shock.(Mouse_names{mouse})), Data(OBSpec.Fear.Fz_Shock.(Mouse_names{mouse})) , thr);
    Spectrum_Frequency.Fear.Fz_Safe.(Mouse_names{mouse}) = ConvertSpectrum_in_Frequencies_BM(Spectro{3} , Range(OBSpec.Fear.Fz_Safe.(Mouse_names{mouse})), Data(OBSpec.Fear.Fz_Safe.(Mouse_names{mouse})) , thr);
    
end






% plot OB frequencies and temperature

figure
histogram(Data(Spectrum_Frequency.Fear.Fz.(Mouse_names{mouse})))

figure
histogram(Data(Spectrum_Frequency.Cond.Fz_Shock.(Mouse_names{mouse})))

figure
histogram(Data(Spectrum_Frequency.Cond.Fz_Safe.(Mouse_names{mouse})))



figure
plot(runmean(Data(Spectrum_Frequency.Fear.Fz.(Mouse_names{mouse})),30))
makepretty
ylabel('OB frequency (Hz)')
xlabel('time (a.u.)')
title('OB oscillations evolution during concatenated freezing epochs')
vline(1833,'--r')

% Interpolation of temperature times on spectrum times
MaskTempOnSpTimes.Fear.Fz.(Mouse_names{mouse}) = Restrict(MaskTempeature.Fear.Fz.(Mouse_names{mouse}) , ts(Range(Spectrum_Frequency.Fear.Fz.(Mouse_names{mouse}))));
TailTempOnSpTimes.Fear.Fz.(Mouse_names{mouse}) = Restrict(TailTempeature.Fear.Fz.(Mouse_names{mouse}) , ts(Range(Spectrum_Frequency.Fear.Fz.(Mouse_names{mouse}))));

figure
subplot(131)
plot(Data(MaskTempOnSpTimes.Fear.Fz.(Mouse_names{mouse})) , runmean(Data(Spectrum_Frequency.Fear.Fz.(Mouse_names{mouse})),30) , '.r')
ylabel('OB frequency (Hz)')
xlabel('Temperature (°C)')
title('Mask temperature')
makepretty
[R,P] = corrcoef_BM( Data(MaskTempOnSpTimes.Fear.Fz.(Mouse_names{mouse})) , runmean(Data(Spectrum_Frequency.Fear.Fz.(Mouse_names{mouse})),30) )
legend(['R = ' num2str(R(2,1)) '     P = ' num2str(P(2,1))])
%u=xlim; v=ylim; axis_lim(1)=u(1)+(u(2)-u(1))/10; axis_lim(2)=v(1)+(v(2)-v(1))/10;
%line([u(1),] , [v(1),])

subplot(132)
plot(Data(TailTempOnSpTimes.Fear.Fz.(Mouse_names{mouse})) , runmean(Data(Spectrum_Frequency.Fear.Fz.(Mouse_names{mouse})),30) , '.r')
xlabel('Temperature (°C)')
makepretty
title('Tail temperature')
[R,P] = corrcoef_BM( Data(TailTempOnSpTimes.Fear.Fz.(Mouse_names{mouse})) , Data(Spectrum_Frequency.Fear.Fz.(Mouse_names{mouse})) )
legend(['R = ' num2str(R(2,1)) '     P = ' num2str(P(2,1))])

subplot(133)
plot(Data(MaskTempOnSpTimes.Fear.Fz.(Mouse_names{mouse})) , Data(TailTempOnSpTimes.Fear.Fz.(Mouse_names{mouse})) , '.r')
xlabel('Mask temperature (°C)')
ylabel('Tail temperature (°C)')
makepretty
title('Tail temperature = f(MaskTemperature)')
[R,P] = corrcoef_BM( Data(MaskTempOnSpTimes.Fear.Fz.(Mouse_names{mouse})) , Data(TailTempOnSpTimes.Fear.Fz.(Mouse_names{mouse}))  )
legend(['R = ' num2str(R(2,1)) '     P = ' num2str(P(2,1))])


a=suptitle('OB low frequency = f(Temperature)'); a.FontSize=20;



