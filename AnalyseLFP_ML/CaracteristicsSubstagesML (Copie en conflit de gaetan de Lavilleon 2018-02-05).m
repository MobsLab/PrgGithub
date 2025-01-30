% waiting for a new script :)

%% 
load('StateEpoch.mat')
Sp=Spectro{1};
t=Spectro{2};
f=Spectro{3};

%% display
figure('color',[1 1 1],'Unit','normalized','Position',[0.1 0.1 0.6 0.7]),Gf=gcf;
subplot(3,1,1),imagesc(t,f,10*log10(Sp)'), axis xy, caxis([20 65]);
title('Spectrogramm');
subplot(3,1,2), plot(Range(Restrict(ThetaRatioTSD,ThetaEpoch),'s'),Data(Restrict(ThetaRatioTSD,ThetaEpoch)),'r.');
hold on, plot(Range(ThetaRatioTSD,'s'),Data(ThetaRatioTSD),'k','linewidth',2);  xlim([0,max(Range(ThetaRatioTSD,'s'))]);

ratio_display_mov=(max(Data(ThetaRatioTSD))-min(Data(ThetaRatioTSD)))/(max(Data(Mmov))-min(Data(Mmov)));
figure(Gf),
hold on, subplot(3,1,2), plot(Range(ThetaRatioTSD,'s'),Data(ThetaRatioTSD),'k','linewidth',2);  xlim([0,max(Range(ThetaRatioTSD,'s'))]);
hold on, subplot(3,1,2), plot(Range(Mmov,'s'),ratio_display_mov*Data(Mmov)+5,'b');
try hold on, line([Start(TrackingEpoch,'s') Start(TrackingEpoch,'s')]',[0 20],'color','k','linewidth',2);end
title('Theta/Delta ratio (black) and Movement (blue)');

figure(Gf), subplot(3,1,2), hold off, plot(Range(Restrict(ThetaRatioTSD,ThetaEpoch),'s'),Data(Restrict(ThetaRatioTSD,ThetaEpoch)),'r.');
hold on, plot(Range(ThetaRatioTSD,'s'),Data(ThetaRatioTSD),'k','linewidth',2); xlim([0,max(Range(ThetaRatioTSD,'s'))]);

hold on, subplot(3,1,2), plot(Range(Mmov,'s'),ratio_display_mov*Data(Mmov)+5,'b'); 
hold on, plot(Range(Restrict(Mmov,MovEpoch),'s'),ratio_display_mov*Data(Restrict(Mmov,MovEpoch))+5,'c');

subplot(3,1,2), line([Start(SWSEpoch,'s') Start(SWSEpoch,'s')],[0 10],'color','r','linewidth',1)
hold on, plot(Range(Restrict(Mmov,SWSEpoch),'s'),ratio_display_mov*Data(Restrict(Mmov,SWSEpoch))+5,'r');

if isempty(Start(REMEpoch))==0
    subplot(3,1,2), line([Start(REMEpoch,'s') Start(REMEpoch,'s')],[0 10],'color','g','linewidth',1)
    hold on, plot(Range(Restrict(Mmov,REMEpoch),'s'),ratio_display_mov*Data(Restrict(Mmov,REMEpoch))+5,'g');
end
title('Wake=cyan, SWS=red, REM=green');

%% *
load('StateEpoch.mat','SWSEpoch','REMEpoch','MovEpoch')
I=intervalSet([],[]);
EP={I,I,SWSEpoch,REMEpoch,MovEpoch};
[SleepStages,Epochs,NamesStages]=PlotPolysomnoML(I,SWSEpoch,SWSEpoch,REMEpoch,MovEpoch);
%PlotPolysomnoML(N1,N3,SWS,REM,WAKE)

% substages
Sta=[];
for ep=1:5
    if ~isempty(EP{ep})
        Sta=[Sta ; [Start(EP{ep},'s'),zeros(length(Start(EP{ep})),1)+ep] ];
    end
end
if ~isempty(Sta)
    Sta=sortrows(Sta,1);
    ind=find(diff(Sta(:,2))==0);
    Sta(ind+1,:)=[];
    
    % check REM -> WAKE transition
    a=find([Sta(:,2);0]==4 & [0;Sta(:,2)]==5 );
    ep='';if ~isempty(a),ep=[ep,' Warning! t=[',sprintf(' %g',floor(Sta(a,1))),' ]s'];end
    disp([sprintf('%d transitions WAKE -> REM ',length(a)),ep]);
end
