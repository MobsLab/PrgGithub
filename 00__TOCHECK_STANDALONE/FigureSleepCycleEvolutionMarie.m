%FigureSleepCycleEvolutionMarie

ti=' ';

try
    listMice;
catch
    listMice=0;
end

if listMice(end)==13
    ti='Mice GcL'; nbCycle=10;
elseif listMice(end)==28
    ti='All mice'; nbCycle=10;
elseif listMice==0
    ti='Human'; nbCycle=2;
end

smo=100;
sc=1;


figure('color',[1 1 1]), 
plot(mean(R1t(1:nbCycle,:),1), 'color',[0.5 0.5 0.5],'linewidth',1), hold on, plot(mean(R1t(end-nbCycle+1:end,:),1), 'color',[1 0.5 0.5],'linewidth',1),xlim([0 10001]), title('N1')
plot(smooth(mean(R1t(1:nbCycle,:),1),smo), 'k','linewidth',2), hold on, plot(smooth(mean(R1t(end-nbCycle+1:end,:),1),smo), 'r','linewidth',2),xlim([0 10001]), title('N1')
if sc
    ylim([0 1])
end
title(['N1, ',ti])


figure('color',[1 1 1]),
plot(mean(R2t(1:nbCycle,:),1), 'color',[0.5 0.5 0.5],'linewidth',1), hold on, plot(mean(R2t(end-nbCycle+1:end,:),1), 'color',[1 0.5 0.5],'linewidth',1),xlim([0 10001]), title('N2')
plot(smooth(mean(R2t(1:nbCycle,:),1),smo), 'k','linewidth',2), hold on, plot(smooth(mean(R2t(end-nbCycle+1:end,:),1),smo), 'r','linewidth',2),xlim([0 10001]), title('N2')
if sc
    ylim([0 1])
end
title(['N2, ',ti])

figure('color',[1 1 1]),
plot(mean(R3t(1:nbCycle,:),1), 'color',[0.5 0.5 0.5],'linewidth',1), hold on, plot(mean(R3t(end-nbCycle+1:end,:),1), 'color',[1 0.5 0.5],'linewidth',1),xlim([0 10001]), title('N3')
plot(smooth(mean(R3t(1:nbCycle,:),1),smo), 'k','linewidth',2), hold on, plot(smooth(mean(R3t(end-nbCycle+1:end,:),1),smo), 'r','linewidth',2),xlim([0 10001]), title('N3')
if sc
    ylim([0 1])
end
title(['N3, ',ti])

figure('color',[1 1 1]),
plot(mean(R4t(1:nbCycle,:),1), 'color',[0.5 0.5 0.5],'linewidth',1), hold on, plot(mean(R4t(end-nbCycle+1:end,:),1), 'color',[1 0.5 0.5],'linewidth',1),xlim([0 10001]), title('REM')
plot(smooth(mean(R4t(1:nbCycle,:),1),smo), 'k','linewidth',2), hold on, plot(smooth(mean(R4t(end-nbCycle+1:end,:),1),smo), 'r','linewidth',2),xlim([0 10001]), title('REM')
if sc
    ylim([0 1])
end
title(['REM, ',ti])

figure('color',[1 1 1]),
plot(mean(R5t(1:nbCycle,:),1), 'color',[0.5 0.5 0.5],'linewidth',1), hold on, plot(mean(R5t(end-nbCycle+1:end,:),1), 'color',[1 0.5 0.5],'linewidth',1),xlim([0 10001]), title('Wake')
plot(smooth(mean(R5t(1:nbCycle,:),1),smo), 'k','linewidth',2), hold on, plot(smooth(mean(R5t(end-nbCycle+1:end,:),1),smo), 'r','linewidth',2),xlim([0 10001]), title('Wake')
if sc
    ylim([0 1])
end
title(['Wake, ',ti])
