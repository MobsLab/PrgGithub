function [Res_Basal,Res_DeltaToneAll,Res_DeltaTone]=ParcoursQuantifTonesDeltaEffect2016(Generate,exp,ton)

cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback

exp='Basal';ton=1;
eval(['load ParcoursQuantifTonesDeltaCorticesRipples2016',exp,'-Tone',num2str(ton)])
Res_Basal=Res;
% 19:30 => mouse 293.294.296

exp='DeltaTone';ton=1;
eval(['load ParcoursQuantifTonesDeltaCorticesRipples2016',exp,'-Tone',num2str(ton)])
Res_DeltaTone=Res;
% 5:7 => mouse 293.294.296

exp='DeltaToneAll';ton=2;
eval(['load ParcoursQuantifTonesDeltaCorticesRipples2016',exp,'-Tone',num2str(ton)])
Res_DeltaToneAll=Res;
% 5:7 => mouse 293.294.296

exp='RdmTone';ton=1;
eval(['load ParcoursQuantifTonesDeltaCorticesRipples2016',exp,'-Tone',num2str(ton)])
Res_RdmDeltaTone=Res;
% 5:8 => mouse 293.294.296

k=0;
k=k+1; ti{k}='SPW-Rs (number)';
k=k+1; ti{k}='Delta Pfc (number)';
k=k+1; ti{k}='SWS';
k=k+1; ti{k}='SPW-Rs (freq)';
k=k+1; ti{k}='Delta Pfc (freq)';

% Compare All Experimentsf
S1_Basal=Res_Basal(1:30,6)./Res_Basal(1:30,11);
S2_Basal=Res_Basal(1:30,7)./Res_Basal(1:30,12);

S1_DeltaToneAll=Res_DeltaToneAll(1:17,6)./Res_DeltaToneAll(1:17,11);
S2_DeltaToneAll=Res_DeltaToneAll(1:17,7)./Res_DeltaToneAll(1:17,12);

S1_DeltaTone140=Res_DeltaTone(1:7,6)./Res_DeltaTone(1:7,11);
S2_DeltaTone140=Res_DeltaTone(1:7,7)./Res_DeltaTone(1:7,12);

S1_RdmDeltaTone=Res_RdmDeltaTone(1:8,6)./Res_RdmDeltaTone(1:8,11);
S2_RdmDeltaTone=Res_RdmDeltaTone(1:8,7)./Res_RdmDeltaTone(1:8,12);

% Figure Basal > no Tone
a=1;
figure('color',[1 1 1])
for i=1:5:15
    subplot(2,3,a), PlotErrorBarN(Res_Basal(:,i:i+4),0);title(ti{a})
    a=a+1;
end
for i=1:5:10
    subplot(2,3,a), PlotErrorBarN(Res_Basal(:,i:i+4)./Res_Basal(:,11:15),0);title(ti{a})
    a=a+1;
end
subplot(2,3,a)
hold on, scatter(S1_Basal(1:18),S2_Basal(1:18),'MarkerEdgeColor','k','MarkerFaceColor',[0.8 0.8 0.8],'LineWidth',2); title('S1vsS2  Delta Freq- Basal')
hold on, scatter(S1_Basal(19:30),S2_Basal(19:30),'MarkerEdgeColor','k','MarkerFaceColor','k','LineWidth',2); title('S1vsS2  Delta Freq- Basal')
hold on, xlabel('Delta Frequency (S1)'),ylabel('Delta Frequency (S2)')

% Figure Triggered Delta Tone (140ms delay)
a=1;
figure('color',[1 1 1])
for i=1:5:15
    subplot(2,3,a), PlotErrorBarN(Res_DeltaTone(:,i:i+4),0);title(ti{a})
    a=a+1;
end
for i=1:5:10
    subplot(2,3,a), PlotErrorBarN(Res_DeltaTone(:,i:i+4)./Res_DeltaTone(:,11:15),0);title(ti{a})
    a=a+1;
end
subplot(2,3,a)
hold on, scatter(S1_DeltaTone140(1:4),S2_DeltaTone140(1:4),'MarkerEdgeColor','r','MarkerFaceColor','y','LineWidth',2); title('S1vsS2 - 140ms DeltaTone')
hold on, scatter(S1_DeltaTone140(5:7),S2_DeltaTone140(5:7),'MarkerEdgeColor','r','MarkerFaceColor','r','LineWidth',2); title('S1vsS2 - 140ms DeltaTone')
hold on, xlabel('Delta Frequency (S1)'),ylabel('Delta Frequency (S2)')

% Figure Triggered Delta Tone (all experiments)
a=1;
figure('color',[1 1 1])
for i=1:5:15
    subplot(2,3,a), PlotErrorBarN(Res_DeltaToneAll(:,i:i+4),0);title(ti{a})
    a=a+1;
end
for i=1:5:10
    subplot(2,3,a), PlotErrorBarN(Res_DeltaToneAll(:,i:i+4)./Res_DeltaToneAll(:,11:15),0);title(ti{a})
    a=a+1;
end
subplot(2,3,a)
hold on, scatter(S1_DeltaToneAll([1:4,8:17]),S2_DeltaToneAll([1:4,8:17]),'MarkerEdgeColor','b','MarkerFaceColor','c','LineWidth',2); title(' S1vsS2 - All DeltaTone')
hold on, scatter(S1_DeltaToneAll(5:7),S2_DeltaToneAll(5:7),'MarkerEdgeColor','b','MarkerFaceColor','b','LineWidth',2); title(' S1vsS2 - All DeltaTone')
hold on, xlabel('Delta Frequency (S1)'),ylabel('Delta Frequency (S2)')

% Figure Random Delta Tone
a=1;
figure('color',[1 1 1])
for i=1:5:15
    subplot(2,3,a), PlotErrorBarN(Res_RdmDeltaTone(:,i:i+4),0);title(ti{a})
    a=a+1;
end
for i=1:5:10
    subplot(2,3,a), PlotErrorBarN(Res_RdmDeltaTone(:,i:i+4)./Res_RdmDeltaTone(:,11:15),0);title(ti{a})
    a=a+1;
end
subplot(2,3,a)
hold on, scatter(S1_RdmDeltaTone(1:4),S2_RdmDeltaTone(1:4),'MarkerEdgeColor','g','MarkerFaceColor',[0 0.5 0],'LineWidth',2); title(' S1vsS2 - Rdm DeltaTone')
hold on, scatter(S1_RdmDeltaTone(5:8),S2_RdmDeltaTone(5:8),'MarkerEdgeColor','g','MarkerFaceColor','g','LineWidth',2); title(' S1vsS2 - Rdm DeltaTone')
hold on, xlabel('Delta Frequency (S1)'),ylabel('Delta Frequency (S2)')

PlotErrorBar4(Res_Basal(1:30,7), Res_DeltaToneAll(1:17,7), Res_DeltaTone(1:7,7), Res_RdmDeltaTone(1:8,7));title('Delta Quantity (S2)')
PlotErrorBar4(Res_Basal(find(S1_Basal>0.8),7), Res_DeltaToneAll(find(S1_DeltaToneAll>0.8),7), Res_DeltaTone(find(S1_DeltaTone140>0.8),7), Res_RdmDeltaTone(find(S1_RdmDeltaTone>0.8),7));title('Delta Quantity (S2) for High Fq S1')

PlotErrorBar4(S2_Basal(1:30), S2_DeltaToneAll(1:17), S2_DeltaTone140(1:7), S2_RdmDeltaTone(1:8));title('Delta frequency (S2)')
PlotErrorBar4(S2_Basal(find(S1_Basal>0.8)),S2_DeltaToneAll(find(S1_DeltaToneAll>0.8)), S2_DeltaTone140(find(S1_DeltaTone140>0.8)), S2_RdmDeltaTone(find(S1_RdmDeltaTone>0.8)));title('Delta frequency(S2) for High Fq S1')

end



% -------------------------------------------------------------------------------------------------------------------------------
% ----------------------------------------- Comparison old mice VS new mice -----------------------------------------------------
% -------------------------------------------------------------------------------------------------------------------------------

% Analyse Delta quantity for all mice  (n=7; year 2016)
exp='DeltaToneAll';ton=2;
eval(['load ParcoursQuantifTonesDeltaCorticesRipples2016',exp,'-Tone',num2str(ton)])
Res_DeltaToneAll=Res;
S1_DeltaToneAll=Res_DeltaToneAll(1:17,6)./Res_DeltaToneAll(1:17,11);
S2_DeltaToneAll=Res_DeltaToneAll(1:17,7)./Res_DeltaToneAll(1:17,12);

PlotErrorBar2(Res_Basal(:,7), Res_DeltaToneAll(:,7));title('Delta Quantity (S2)')
PlotErrorBar2(S2_Basal, S2_DeltaToneAll);title('Delta frequency (S2)')
PlotErrorBar2(S2_Basal(find(S1_Basal>0.75)), S2_DeltaToneAll(find(S1_DeltaToneAll>0.75)));title('Delta frequency (S2) for High Fq S1')

figure('color',[1 1 1])
x=[0.75,1.05,1.05,0.75];y=[0.1,0.1,1.05,1.05];patch(x,y,[0.8 0.8 0.8])
hold on, scatter(S1_Basal(1:18),S2_Basal(1:18),'MarkerEdgeColor','k','MarkerFaceColor',[0.8 0.8 0.8],'LineWidth',3);
hold on, scatter(S1_Basal(1:30),S2_Basal(1:30),'MarkerEdgeColor','k','MarkerFaceColor','k','LineWidth',3);
hold on, scatter(S1_DeltaToneAll(1:17),S2_DeltaToneAll(1:17),'MarkerEdgeColor','b','MarkerFaceColor','b','LineWidth',2);
hold on, plot([0.15 1.05],[0.15 1.05],'k')
hold on, axis([0.4 1.04 0.4 1.04])
hold on, xlabel('Delta Frequency (S1)'),ylabel('Delta Frequency (S2)')
hold on, title('S1vsS2 Delta Frequency (mice 243,244,251,252)')

% Analyse Delta quantity only for PhD mice (n=5; year 2016)
exp='DeltaToneAll';ton=1;
eval(['load ParcoursQuantifTonesDeltaCorticesRipples2015',exp,'-Tone',num2str(ton)])
Res_DeltaToneAll=Res;
S1_DeltaToneAll=Res_DeltaToneAll(:,6)./Res_DeltaToneAll(:,11);
S2_DeltaToneAll=Res_DeltaToneAll(:,7)./Res_DeltaToneAll(:,12);

PlotErrorBar2(Res_Basal(:,7), Res_DeltaToneAll(:,7));title('Delta Quantity (S2)')
PlotErrorBar2(S2_Basal, S2_DeltaToneAll);title('Delta frequency (S2)')
PlotErrorBar2(S2_Basal(find(S1_Basal>0.75)), S2_DeltaToneAll(find(S1_DeltaToneAll>0.75)));title('Delta frequency (S2) for High Fq S1')


figure('color',[1 1 1])
x=[0.75,1.05,1.05,0.75];y=[0.1,0.1,1.05,1.05];patch(x,y,[0.8 0.8 0.8])
hold on, scatter(S1_Basal(1:18),S2_Basal(1:18),'MarkerEdgeColor','k','MarkerFaceColor',[0.8 0.8 0.8],'LineWidth',3);
hold on, scatter(S1_DeltaToneAll(1:12),S2_DeltaToneAll(1:12),'MarkerEdgeColor','b','MarkerFaceColor','c','LineWidth',2);
hold on, plot([0.15 1.05],[0.15 1.05],'k')
hold on, axis([0.4 1.04 0.4 1.04])
hold on, xlabel('Delta Frequency (S1)'),ylabel('Delta Frequency (S2)')
hold on, title('S1vsS2 Delta Frequency (mice 243,244,251,252)')
