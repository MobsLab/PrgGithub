Smooth_actimetry2 = tsd(Range(Piezo_Mouse_tsd), runmean(abs(zscore(Data(FilterLFP(Piezo_Mouse_tsd,[15 20],30)))),50)); % smooth time =3s
Smooth_actimetry = tsd(Range(Piezo_Mouse_tsd), runmean(abs(zscore(Data(FilterLFP(Piezo_Mouse_tsd,[1 10],30)))),50)); % smooth time =3s
Smooth_actimetry3 = tsd(Range(Piezo_Mouse_tsd), runmean(abs(zscore(Data(Piezo_Mouse_tsd))),50)); % smooth time =3s

figure
subplot(211)
plot(Data(Smooth_actimetry),'r')
hold on
plot(Data(Smooth_actimetry2),'b')
plot(Data(Smooth_actimetry3),'g')

subplot(212)
plot(Data(Piezo_Mouse_tsd))

subplot(211)
xl = xlim
subplot(212)
xlim(xl)
