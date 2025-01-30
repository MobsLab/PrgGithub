load('Latence_all_stim.mat')
load('Latence_all_mice1000.mat')

figure

subplot(1,2,1)
plot(A(:,2),A(:,3),'*')
title('Stimulations')
xlabel('Time of the REM before the Stimulation (s)')
ylabel('Time of the REM after the Stimulation (s)')
xlim([0 60])
ylim([0 200])

subplot(1,2,2)
plot(TransREMSWS(:,2),TransREMSWS(:,3),'*')
title('Baseline')
xlabel('Time of the REM before the Stimulation (s)')
ylabel('Time of the REM after the Stimulation (s)')
xlim([0 60])
ylim([0 200])

figure
plot(TransREMSWS(:,2),TransREMSWS(:,3),'*')
xlabel('Time of the REM before the Stimulation (s)')
ylabel('Time of the REM after the Stimulation (s)')
xlim([0 60])
ylim([0 200])
hold on, plot(A(:,2),A(:,3),'r*')