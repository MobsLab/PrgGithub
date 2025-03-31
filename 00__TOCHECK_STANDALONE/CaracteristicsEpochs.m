function Dur=CaracteristicsEpochs(testEpoch,plo)

try 
    plo;
catch
    plo=0;
end


Dur(1)=length(Start(testEpoch));
Dur(2)=sum(End(testEpoch,'s')-Start(testEpoch,'s'));
Dur(3)=nanmean(End(testEpoch,'s')-Start(testEpoch,'s'));

en=End(testEpoch,'s');
st=Start(testEpoch,'s');
Dur(4)=nanmean(st(2:end)-en(1:end-1));
temp=st(2:end)-en(1:end-1);
Dur(5)=nanmean(temp(temp<1000));

bin=0:10:700;

figure('color',[1 1 1])
[h,b]=hist(End(testEpoch,'s')-Start(testEpoch,'s'),bin);
% subplot(2,1,1), bar(b,h,1,'facecolor','k')
subplot(2,2,1), a1=area(b,h);
set(a1, 'facecolor', 'k')
yl=ylim;
hold on, line([Dur(3) Dur(3)],yl,'color','r')
ylabel('Mean duration (s)')

b(1)=9;
subplot(2,2,2), plot(b,h,'k','linewidth',2);
hold on, plot(b,h,'ko','markerfacecolor','k');
set(gca,'xscale','log')
%set(gca,'yscale','log')
yl=ylim;
hold on, line([Dur(3) Dur(3)],yl,'color','r')
xl=xlim;
xlim([8.5 xl(2)])

[h2,b2]=hist(st(2:end)-en(1:end-1),bin);
% subplot(2,1,2), bar(b2,h2,1,'facecolor','k')
subplot(2,2,3), a2=area(b2,h2);
set(a2, 'facecolor', 'k')
yl=ylim;
hold on, line([Dur(4) Dur(4)],yl,'color','r')
hold on, line([Dur(5) Dur(5)],yl,'color','m')
ylabel('Mean ISI (s)')

b2(1)=9;
subplot(2,2,4), plot(b2,h2,'k','linewidth',2);
hold on, plot(b2,h2,'ko','markerfacecolor','k');
set(gca,'xscale','log')
%set(gca,'yscale','log')
yl=ylim;
hold on, line([Dur(4) Dur(4)],yl,'color','r')
hold on, line([Dur(5) Dur(5)],yl,'color','m')
xl=xlim;
xlim([8.5 xl(2)])

disp(' ')
disp(' ')
disp('******************************')
disp(['Number of epochs: ',num2str(floor(Dur(1)))])
disp('******************************')
disp(['Total duration of epochs: ',num2str(floor(Dur(2))),' sec'])
disp('******************************')
disp(['Mean duration of epochs: ',num2str(floor(Dur(3))),' sec'])
disp('******************************')
disp(['Mean ISI of epochs: ',num2str(floor(Dur(4))),' sec'])
disp('******************************')
disp(' ')
disp(' ')



