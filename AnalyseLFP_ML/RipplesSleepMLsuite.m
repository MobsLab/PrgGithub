function RipplesSleepMLsuite(Res,Ti,partRipp)
% 
% Ti{1}='num' ;
% Ti{2}='c';
% 
% Ti{3}='DurationPeriod';
% Ti{4}='DurationSWS';
% Ti{5}='DurationREM';
% Ti{6}='floor(DurationREM/DurationSWS*100*10)/10';
% Ti{7}='ripSWS';
% Ti{8}='ripREM';
% Ti{9}='ripSWS/DurationSWS';
% Ti{10}='ripREM/DurationREM';
% Ti{11}='ripBurstiness' ;
% Ti{12}='NombreSpikes SleepEpoch'; 
% Ti{13}='NbStimREM' ;
% Ti{14}='NbStimSWS'  ;
% Ti{15}='FreqStimTheta';  
% Ti{16}='FreqStimSWS' ;
% Ti{17}='PercStimRipples' ;
% Ti{18}='NbSpikeRipples' ;
% Ti{19}='NbRipplesWithSpikes' ;
% Ti{20}='OccurenceBefore';
% Ti{21}='FreqBefore';
% Ti{22}='NombreRipples';

disp(['Fraction of neuron population active within a ripple :',num2str(mean(floor(10*sum(partRipp,2)/14*100)/10)),'%'])
disp(['Averaged participation to ripple for a given neuron :',num2str(floor(10*mean(Res(19,:))./Res(22,1)*100)/10),'%'])

figure('color',[1 1 1]),  

%%
    % plot firing frequency during sleep versus sessions before
    


llim= max(max(Res(15,:)),max(Res(21,:)));
hold on, subplot(2,3,1)
title('Frequence REM/Theta vs Frequence before');
xlabel(Ti{21});ylabel(Ti{15});
line([0 llim],[0 llim],'Color','r')

llim= max(max(Res(16,:)),max(Res(21,:)));
hold on, subplot(2,3,4)
title('Frequence SWS vs Frequence before');
xlabel(Ti{21});ylabel(Ti{16});
line([0 llim],[0 llim],'Color','r')

for c=1:size(Res,2)
    hold on, subplot(2,3,1), plot((Res(21,c)),(Res(15,c)),'bo');
    hold on, subplot(2,3,4), plot((Res(21,c)),(Res(16,c)),'bo');
end



%%
    % plot Ripples with spike versus frequency of spike  

for c=1:size(Res,2)
    hold on, subplot(2,3,2), plot((Res(21,c)),(Res(19,c)),'bo');
end
title('Ripples with spike versus frequency of spike before');
xlabel(Ti{21});ylabel(Ti{19});
    

 
%%
    % for a given neuron % ripple with spike  versus % spike dans une
    % ripples

hold on, subplot(2,3,3),plot(log10(Res(19,:)),log10(Res(17,:)),'bo');

title('% ripple with spike versus % spike dans une ripples');
xlabel(Ti{19});ylabel(Ti{17});
    

  
%%
    % plot Fraction of neuron population active within a ripple 
    
figure('color',[1 1 1]),
ssum=floor(10*sum(partRipp,2)/size(Res,2)*100)/10;
Uu=unique(ssum);
for u=1:length(Uu)
    U(u)=length(find(ssum==Uu(u)));
end
bar(unique(ssum),U);
title('Fraction of neuron population active within a ripple');
xlabel('percent of neuron participating'); ylabel('number of ripples');
hold on, line([mean(ssum) mean(ssum)],[0 max(U)],'Color','r','linewidth',3)
text(mean(ssum)+10,max(U)/3*2,['\fontsize{16}\color{red}mean=',num2str(floor(10*mean(ssum))/10)]);
 
 
%%
    % Averaged participation to ripple for a given neuron
figure('color',[1 1 1]),

for c=1:size(Res,2)
    A=floor(10*Res(19,c)/Res(22,1)*Res(12,c)/Res(3,c)*100)/10;
end
plot(Res(2,:),A,'bo');

title('Participation to ripple for a given neuron normalized with FR');
xlabel(Ti{2});ylabel('%participation');


