FreezingMet=Freeze_a(MatNum(2,:));
FreezingSal=Freeze_a(MatNum(1,:));


JumpMet=x(2,:);
JumpSal=x(1,:);

TempDebMet=x1(2,:);
TempFinMet=x1(4,:);
TempDebSal=x1(1,:);
TempFinSal=x1(3,:);



figure, 
subplot(2,3,1),hold on
plot(JumpMet,FreezingMet,'ro','markerfacecolor','r'), xlabel('jump'), ylabel('Freezing')
plot(JumpSal,FreezingSal,'ko','markerfacecolor','k')

subplot(2,3,2),hold on
plot(TempDebMet,JumpMet,'ro','markerfacecolor','r'), ylabel('jump'), xlabel('Temp Deb')
plot(TempDebSal,JumpSal,'ko','markerfacecolor','k')

subplot(2,3,3),hold on
plot(TempFinMet,JumpMet,'ro','markerfacecolor','r'), ylabel('jump'), xlabel('Temp fin')
plot(TempFinSal,JumpSal,'ko','markerfacecolor','k')

subplot(2,3,4),hold on
plot(TempDebMet,FreezingMet,'ro','markerfacecolor','r'), xlabel('Temp deb'), ylabel('Freezing')
plot(TempDebSal,FreezingSal,'ko','markerfacecolor','k')

subplot(2,3,5),hold on
plot(TempFinMet,FreezingMet,'ro','markerfacecolor','r'), xlabel('Temp fin'), ylabel('Freezing')
plot(TempFinSal,FreezingSal,'ko','markerfacecolor','k')

subplot(2,3,6),hold on
plot(TempFinMet-TempDebMet,FreezingMet,'ro','markerfacecolor','r'), xlabel('diff temp'), ylabel('Freezing')
plot(TempFinSal-TempDebSal,FreezingSal,'ko','markerfacecolor','k')


