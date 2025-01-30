%ProcessAnalogInput


l
xlim([1900 9000])
d_ON_per5=intervalSet(738*1E4,762*1E4);
d_ON_per6=intervalSet(2039*1E4,3690*1E4);
d_ON_per7=intervalSet(5477.5*1E4,7888.3*1E4);
d_OFF_segt=union(d_ON_per6,d_ON_per7)-d_ON_segt;
d_OFF_per=intervalSet([800*1E4; 3690*1E4;7888.3*1E4],[2039*1E4;5477.5*1E4; 9165*1E4]);


save Diode d_ON_per5 d_ON_per6 d_ON_per7 d_ON_segt d_OFF_per d_OFF_segt

% d_ON_per1=intervalSet(2057.5*1E4,2154.3*1E4);
% d_ON_per2=intervalSet(2417.5*1E4,2791.3*1E4);

% for M255-256-01092015

% diode on 256
d_ON_per1=intervalSet(0,100*1E4);
d_ON_per2=intervalSet(110*1E4,220*1E4);
d_ON_per3=intervalSet(240*1E4,290*1E4);
d_ON_per4=intervalSet(310*1E4,365*1E4);
d_ON_per5=intervalSet(365*1E4,390*1E4);
d_ON_per5b=intervalSet(390*1E4,770*1E4);
d_ON_per6=intervalSet(993*1E4,1850*1E4);
% diode on 255
d_ON_per7=intervalSet(2738*1E4,3948*1E4);

d_ON_segt=thresholdIntervals(LFP,0.0001,'Direction','Below');
d_ON_segt=dropShortIntervals(d_ON_segt,8000);

d_OFF_per=intervalSet([770*1E4; 1850*1E4;3948*1E4],[993*1E4; 2738*1E4;4584*1E4]);
d_OFF_per1=intervalSet([770*1E4],[993*1E4]);
d_OFF_per2=intervalSet([1850*1E4],[2738*1E4]);
d_OFF_per3=intervalSet([3948*1E4],[4584*1E4]);
d_OFF_per=d_OFF_per-d_ON_per1-d_ON_per2-d_ON_segt;

% M256
DiodeOnMouse=intervalSet(390*1E4,1860*1E4);
% M255
DiodeOnMouse=intervalSet(1860*1E4,4583*1E4);
save DiodeOnMouse DiodeOnMouse
% visual check
figure, plot(Range(LFP,'s'), Data(LFP)),hold on,
colorplot=jet(7);
for i=1:7
      eval([ 'line([Start(d_ON_per' num2str(i) ',''s'') End(d_ON_per' num2str(i)  ',''s'')],[-10 -10],''color'',colorplot(i,:),''linewidth'',4)'])
end
hold on,  line([Start(d_ON_per2,'s') End(d_ON_per2,'s')],[1500 1500],'color','o','linewidth',4)
 line([Start(d_ON_segt,'s') End(d_ON_segt,'s')],[1500 1500],'color','g','linewidth',4)
 
 title('blue analog input / Red LFP hipp / black OFF period / green ON period')
 
 xlabel('ne semble pas correspondre - ne pas cntinuer avec cet enregistrement')