

function FigureResult=MakeFiguresPhysiologicalParameters_Sleep(all_mice_array,PhysioParam,all_mice_sleep_time,Zones)

%for time=1:length(all_mice_sleep_time)
time=1;

switch PhysioParam
    case 'Acc'
        LegendToPut='Movement quantity (AU)';
    case 'HR'
        LegendToPut='Frequency (Hz)';
    case 'HRVar'
        LegendToPut='Variability';
    case 'Respi'
        LegendToPut='Frequency (Hz)';
    case 'MTemp'
        LegendToPut='Normalized temperature (°C)';
    otherwise
        disp('ERROR')
end

PhysioParam={PhysioParam};
X = [1,2];



figure

zones=1;
subplot(241)
Conf_Inter=nanstd(all_mice_array.(all_mice_sleep_time{time}).(Zones{zones}).(PhysioParam{1}))/sqrt(size(all_mice_array.(all_mice_sleep_time{time}).(Zones{zones}).(PhysioParam{1}),1));
shadedErrorBar([1:50],nanmean(all_mice_array.(all_mice_sleep_time{time}).(Zones{zones}).(PhysioParam{1})(:,1:50)),Conf_Inter(1:50),{'-b','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_array.(all_mice_sleep_time{time}).(Zones{zones}).(PhysioParam{1})(:,51:100)),Conf_Inter(51:100),{'-r','Linewidth',2},1); hold on
f=get(gca,'Children');
a=legend([f(8),f(4)],'Wake','NREM');
xticks([0:20:100])
xticklabels({'-10','-6','-2','2','6','10'})
xlabel('time (s)')
makepretty
Max1=max(nanmean(all_mice_array.(all_mice_sleep_time{time}).(Zones{zones}).(PhysioParam{1}))+Conf_Inter);
Min1=min(nanmean(all_mice_array.(all_mice_sleep_time{time}).(Zones{zones}).(PhysioParam{1}))-Conf_Inter);
ylabel(LegendToPut)

subplot(245); clear A; 
A(:,1)=mean(all_mice_array.(all_mice_sleep_time{time}).(Zones{zones}).(PhysioParam{1})(:,1:10)');
A(:,2)=mean(all_mice_array.(all_mice_sleep_time{time}).(Zones{zones}).(PhysioParam{1})(:,91:100)');
MakeSpreadAndBoxPlot_SB(A,{[0 0 1],[1 0 0]},X,{'Wake' 'NREM'},0,1)
ylabel(LegendToPut)
makepretty


subplot(242)
zones=3;
Conf_Inter=nanstd(all_mice_array.(all_mice_sleep_time{time}).(Zones{zones}).(PhysioParam{1}))/sqrt(size(all_mice_array.(all_mice_sleep_time{time}).(Zones{zones}).(PhysioParam{1}),1));
shadedErrorBar([1:50],nanmean(all_mice_array.(all_mice_sleep_time{time}).(Zones{zones}).(PhysioParam{1})(:,1:50)),Conf_Inter(1:50),{'-r','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_array.(all_mice_sleep_time{time}).(Zones{zones}).(PhysioParam{1})(:,51:100)),Conf_Inter(51:100),{'-b','Linewidth',2},1); hold on
makepretty
xticks([0:20:100])
xticklabels({'-10','-6','-2','2','6','10'})
xlabel('time (s)')
Max2=max(nanmean(all_mice_array.(all_mice_sleep_time{time}).(Zones{zones}).(PhysioParam{1}))+Conf_Inter);
Min2=min(nanmean(all_mice_array.(all_mice_sleep_time{time}).(Zones{zones}).(PhysioParam{1}))-Conf_Inter);

subplot(246); clear A;
A(:,1)=mean(all_mice_array.(all_mice_sleep_time{time}).(Zones{zones}).(PhysioParam{1})(:,1:10)');
A(:,2)=mean(all_mice_array.(all_mice_sleep_time{time}).(Zones{zones}).(PhysioParam{1})(:,91:100)');
MakeSpreadAndBoxPlot_SB(A,{[1 0 0],[0 0 1]},X,{'NREM' 'Wake'},0,1)
makepretty

zones=2;
subplot(243)
Conf_Inter=nanstd(all_mice_array.(all_mice_sleep_time{time}).(Zones{zones}).(PhysioParam{1}))/sqrt(size(all_mice_array.(all_mice_sleep_time{time}).(Zones{zones}).(PhysioParam{1}),1));
shadedErrorBar([1:50],nanmean(all_mice_array.(all_mice_sleep_time{time}).(Zones{zones}).(PhysioParam{1})(:,1:50)),Conf_Inter(1:50),{'-r','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_array.(all_mice_sleep_time{time}).(Zones{zones}).(PhysioParam{1})(:,51:100)),Conf_Inter(51:100),{'-g','Linewidth',2},1); hold on
makepretty
f=get(gca,'Children');
a=legend([f(8),f(4)],'NREM','REM');
xticks([0:20:100])
xticklabels({'-10','-6','-2','2','6','10'})
xlabel('time (s)')
makepretty
Max3=max(nanmean(all_mice_array.(all_mice_sleep_time{time}).(Zones{zones}).(PhysioParam{1}))+Conf_Inter);
Min3=min(nanmean(all_mice_array.(all_mice_sleep_time{time}).(Zones{zones}).(PhysioParam{1}))-Conf_Inter);

subplot(247); clear A;
A(:,1)=mean(all_mice_array.(all_mice_sleep_time{time}).(Zones{zones}).(PhysioParam{1})(:,1:10)');
A(:,2)=mean(all_mice_array.(all_mice_sleep_time{time}).(Zones{zones}).(PhysioParam{1})(:,91:100)');
MakeSpreadAndBoxPlot_SB(A,{[1 0 0],[0 1 0]},X,{'NREM' 'REM'},0,1)
makepretty


subplot(244)
zones=4;
Conf_Inter=nanstd(all_mice_array.(all_mice_sleep_time{time}).(Zones{zones}).(PhysioParam{1}))/sqrt(size(all_mice_array.(all_mice_sleep_time{time}).(Zones{zones}).(PhysioParam{1}),1));
shadedErrorBar([1:50],nanmean(all_mice_array.(all_mice_sleep_time{time}).(Zones{zones}).(PhysioParam{1})(:,1:50)),Conf_Inter(1:50),{'-g','Linewidth',2},1); hold on
shadedErrorBar([51:100],nanmean(all_mice_array.(all_mice_sleep_time{time}).(Zones{zones}).(PhysioParam{1})(:,51:100)),Conf_Inter(51:100),{'-r','Linewidth',2},1); hold on
makepretty
xticks([0:20:100])
xticklabels({'-10','-6','-2','2','6','10'})
xlabel('time (s)')
Max4=max(nanmean(all_mice_array.(all_mice_sleep_time{time}).(Zones{zones}).(PhysioParam{1}))+Conf_Inter);
Min4=min(nanmean(all_mice_array.(all_mice_sleep_time{time}).(Zones{zones}).(PhysioParam{1}))-Conf_Inter);

subplot(248); clear A;
A(:,1)=mean(all_mice_array.(all_mice_sleep_time{time}).(Zones{zones}).(PhysioParam{1})(:,1:10)');
A(:,2)=mean(all_mice_array.(all_mice_sleep_time{time}).(Zones{zones}).(PhysioParam{1})(:,91:100)');
MakeSpreadAndBoxPlot_SB(A,{[0 1 0],[1 0 0]},X,{'REM' 'NREM'},0,1)
makepretty

MaxAll=max([Max1 Max2 Max3 Max4]);
MinAll=min([Min1 Min2 Min3 Min4]);

subplot(241)
ylim([MinAll MaxAll])
b=vline(50,'--r'); b.LineWidth=2;
subplot(242)
ylim([MinAll MaxAll])
b=vline(50,'--r'); b.LineWidth=2;
subplot(243)
ylim([MinAll MaxAll])
b=vline(50,'--r'); b.LineWidth=2;
subplot(244)
ylim([MinAll MaxAll])
b=vline(50,'--r'); b.LineWidth=2;

    FigureResult=0;
    
%end

end