function [rRip,pRip,rD,pD,rDRip,pDRip,rDNoRip,pDNoRip,NbRip,NbDown,NbDownRip,NbDownNoRip,Nb,id,MiceName,PathOK]=ParcoursRipDeltaEvolution(Generate,exp,DeltaLFP,CorrectionDeltaSPW,NblimNeuronsN,FreqLimNeuronsN)


try
    Generate;
    if Generate==1
        rep=input('Are you sure about the gneration of data? (y/n) ','s');
        if rep=='y'
            Generate=1;
        else
            Generate=0;
        end
    end
        
           
catch
    Generate=0;
end

try
    exp;
catch
%      exp='BASAL';
     exp='DeltaTone';
end

try
    DeltaLFP;
catch
    DeltaLFP=1;
end

try
    CorrectionDeltaSPW;
catch
    CorrectionDeltaSPW=0;
end

try
    NblimNeuronsN;
catch
    NblimNeuronsN=25;
end
try
    FreqLimNeuronsN;
catch
FreqLimNeuronsN=100;
end

  cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback  
  
if Generate
    
        Dir=PathForExperimentsDeltaSleepNew(exp);

        a=1;
        for i=1:length(Dir.path)
            try
                disp(' ')
                disp('****************************************************************')
            eval(['cd(Dir.path{',num2str(i),'}'')'])
            disp(pwd)
            
            
            [rRip(a),pRip(a),rD(a),pD(a),rDRip(a),pDRip(a),rDNoRip(a),pDNoRip(a),NbRip(a,:),NbDown(a,:),NbDownRip(a,:),NbDownNoRip(a,:),Bs,CsRip,CeRip,CsSpk,CeSpk,Nb(a,:)]=RipDeltaEvolution(CorrectionDeltaSPW,DeltaLFP,0,NblimNeurons); % no correction & detection Down by spikes
            
            CsRipT1(a,:)=CsRip(1,:);
            CsRipT2(a,:)=CsRip(2,:);
            CsRipT3(a,:)=CsRip(3,:);
            CsRipT4(a,:)=CsRip(4,:);
            CsRipT5(a,:)=CsRip(5,:);
            
            CeRipT1(a,:)=CeRip(1,:);
            CeRipT2(a,:)=CeRip(2,:);
            CeRipT3(a,:)=CeRip(3,:);
            CeRipT4(a,:)=CeRip(4,:);
            CeRipT5(a,:)=CeRip(5,:);           
            
            CsSpkT1(a,:)=CsSpk(1,:);
            CsSpkT2(a,:)=CsSpk(2,:);
            CsSpkT3(a,:)=CsSpk(3,:);
            CsSpkT4(a,:)=CsSpk(4,:);
            CsSpkT5(a,:)=CsSpk(5,:);
            
            CeSpkT1(a,:)=CeSpk(1,:);
            CeSpkT2(a,:)=CeSpk(2,:);
            CeSpkT3(a,:)=CeSpk(3,:);
            CeSpkT4(a,:)=CeSpk(4,:);
            CeSpkT5(a,:)=CeSpk(5,:);              
            
            
            
            
            
            MiceName{a}=Dir.name{i};
            PathOK{a}=Dir.path{i};

            a=a+1;
            
            end
        end


cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback
eval(['save DataParcoursRipDeltaEvolution',exp,'DeltaLFP',num2str(DeltaLFP),'CorrectionSPW',num2str(CorrectionDeltaSPW)])

else

eval(['load DataParcoursRipDeltaEvolution',exp,'DeltaLFP',num2str(DeltaLFP),'CorrectionSPW',num2str(CorrectionDeltaSPW)])
    
end
 

NblimNeurons=NblimNeuronsN;
FreqLimNeurons=FreqLimNeuronsN;


eval(['load DataParcoursRipDeltaEvolution',exp,'DeltaLFP',num2str(DeltaLFP),'CorrectionSPW',num2str(CorrectionDeltaSPW),' Nb'])
Nb(:,2)=Nb(:,2)./Nb(:,5);


if DeltaLFP==0
%     id=find(Nb(:,2)>FreqLimNeurons);
    id=find(Nb(:,1)>NblimNeurons);
%     id=find(Nb(:,1)>NblimNeurons&NbDown(:,1)>0.5);
else
%      id=1:size(Nb,1);
     id=find(NbDown(:,1)>0);
end

tps=Bs;
    
figure('color',[1 1 1]), 
subplot(2,2,1), hold on    
plot(tps, nanmean(CsRipT1(id,:)),'k')
plot(tps, nanmean(CsRipT2(id,:)),'r')
plot(tps, nanmean(CsRipT3(id,:)),'b')
plot(tps, nanmean(CsRipT4(id,:)),'m')
plot(tps, nanmean(CsRipT5(id,:)),'color',[0.7 0.7 0.7]), title([exp,'DeltaLFP',num2str(DeltaLFP),'CorrectionSPW',num2str(CorrectionDeltaSPW)])

subplot(2,2,2), hold on    
plot(tps, nanmean(CsSpkT1(id,:)),'k')
plot(tps, nanmean(CsSpkT2(id,:)),'r')
plot(tps, nanmean(CsSpkT3(id,:)),'b')
plot(tps, nanmean(CsSpkT4(id,:)),'m')
plot(tps, nanmean(CsSpkT5(id,:)),'color',[0.7 0.7 0.7])

subplot(2,2,3), hold on  (id,:)  
plot(tps, nanmean(CeRipT1(id,:)),'k')
plot(tps, nanmean(CeRipT2(id,:)),'r')
plot(tps, nanmean(CeRipT3(id,:)),'b')
plot(tps, nanmean(CeRipT4(id,:)),'m')
plot(tps, nanmean(CeRipT5(id,:)),'color',[0.7 0.7 0.7])

subplot(2,2,4), hold on    
plot(tps, nanmean(CeSpkT1(id,:)),'k')
plot(tps, nanmean(CeSpkT2(id,:)),'r')
plot(tps, nanmean(CeSpkT3(id,:)),'b')
plot(tps, nanmean(CeSpkT4(id,:)),'m')
plot(tps, nanmean(CeSpkT5(id,:)),'color',[0.7 0.7 0.7])





figure('color',[1 1 1]),
subplot(2,2,1), PlotErrorBarN(NbRip(id,:),0); title('Nb SPW-Rs')
subplot(2,2,2), PlotErrorBarN(NbDown(id,:),0); title('Nb Down')
subplot(2,2,3), PlotErrorBarN(NbDownRip(id,:),0); title('Nb Down with SPW-Rs')
subplot(2,2,4), PlotErrorBarN(NbDownNoRip(id,:),0); title('Nb Down without SPW-Rs')


PlotErrorBar4(rRip(id),rD(id),rDRip(id),rDNoRip(id));
set(gca,'xtick',[1:4])
set(gca,'xticklabel',{'Rip','Down','D Rip','D No Rip'})
ylabel('Correlation with time')


if DeltaLFP==0
    if 0
figure('color',[1 1 1]),
subplot(2,2,1), PlotErrorBarN(NbRip(id,:)',0); title('Nb SPW-Rs')
set(gca,'xtick',[1:length(id)])
set(gca,'xticklabel',MiceName(id))
subplot(2,2,2), PlotErrorBarN(NbDown(id,:)',0); title('Nb Down')
set(gca,'xtick',[1:length(id)])
set(gca,'xticklabel',MiceName(id))
subplot(2,2,3), PlotErrorBarN(NbDownRip(id,:)',0); title('Nb Down with SPW-Rs')
set(gca,'xtick',[1:length(id)])
set(gca,'xticklabel',MiceName(id))
subplot(2,2,4), PlotErrorBarN(NbDownNoRip(id,:)',0); title('Nb Down without SPW-Rs')
set(gca,'xtick',[1:length(id)])
set(gca,'xticklabel',MiceName(id))

 set(gcf,'position',[78         215        3721         659])

% 
% Nb(1)=length(NumNeurons);
% Nb(2)=length(Range(poolNeurons(S,NumNeurons)));
% Nb(3)=length(Start(Down));
% Nb(4)=length(Range(rip));



figure('color',[1 1 1]),
subplot(4,4,1), plot(nanmean(NbRip(id,:)'),Nb(id,1),'ko','markerfacecolor','k'), xlim([0 1]), xlabel('Freq Rip'), ylabel('nb of neurons')%, ylim([0 5])
subplot(4,4,2), plot(nanmean(NbRip(id,:)'),Nb(id,2),'ko','markerfacecolor','k'), xlim([0 1]), xlabel('Freq Rip'), ylabel('nb of spikes')%, ylim([0 5])
subplot(4,4,3), plot(nanmean(NbRip(id,:)'),Nb(id,3),'ko','markerfacecolor','k'), xlim([0 1]), xlabel('Freq Rip'), ylabel('nb of Down')%, ylim([0 5])
subplot(4,4,4), plot(nanmean(NbRip(id,:)'),Nb(id,4),'ko','markerfacecolor','k'), xlim([0 1]), xlabel('Freq Rip'), ylabel('nb of Rip')%, ylim([0 5])

subplot(4,4,5), plot(nanmean(NbDown(id,:)'),Nb(id,1),'ko','markerfacecolor','k'), xlim([0 5]), xlabel('Freq Down'), ylabel('nb of neurons')%, ylim([0 5])
subplot(4,4,6), plot(nanmean(NbDown(id,:)'),Nb(id,2),'ko','markerfacecolor','k'), xlim([0 5]), xlabel('Freq Down'), ylabel('nb of spikes')%, ylim([0 5])
subplot(4,4,7), plot(nanmean(NbDown(id,:)'),Nb(id,3),'ko','markerfacecolor','k'), xlim([0 5]), xlabel('Freq Down'), ylabel('nb of Down')%, ylim([0 5])
subplot(4,4,8), plot(nanmean(NbDown(id,:)'),Nb(id,4),'ko','markerfacecolor','k'), xlim([0 5]), xlabel('Freq Down'), ylabel('nb of Rip')%, ylim([0 5])

subplot(4,4,9), plot(nanmean(NbDownRip(id,:)'),Nb(id,1),'ko','markerfacecolor','k'), xlim([0 0.5]), xlabel('Freq Down with Rip'), ylabel('nb of neurons')%, ylim([0 5])
subplot(4,4,10), plot(nanmean(NbDownRip(id,:)'),Nb(id,2),'ko','markerfacecolor','k'), xlim([0 0.5]), xlabel('Freq Down with Rip'), ylabel('nb of spikes')%, ylim([0 5])
subplot(4,4,11), plot(nanmean(NbDownRip(id,:)'),Nb(id,3),'ko','markerfacecolor','k'), xlim([0 0.5]), xlabel('Freq Down with Rip'), ylabel('nb of Down')%, ylim([0 5])
subplot(4,4,12), plot(nanmean(NbDownRip(id,:)'),Nb(id,4),'ko','markerfacecolor','k'), xlim([0 0.5]), xlabel('Freq Down with Rip'), ylabel('nb of Rip')%, ylim([0 5])

subplot(4,4,13), plot(nanmean(NbDownNoRip(id,:)'),Nb(id,1),'ko','markerfacecolor','k'), xlim([0 5]), xlabel('Freq Down without Rip'), ylabel('nb of neurons')%, ylim([0 5])
subplot(4,4,14), plot(nanmean(NbDownNoRip(id,:)'),Nb(id,2),'ko','markerfacecolor','k'), xlim([0 5]), xlabel('Freq Down without Rip'), ylabel('nb of spikes')%, ylim([0 5])
subplot(4,4,15), plot(nanmean(NbDownNoRip(id,:)'),Nb(id,3),'ko','markerfacecolor','k'), xlim([0 5]), xlabel('Freq Down without Rip'), ylabel('nb of Down')%, ylim([0 5])
subplot(4,4,16), plot(nanmean(NbDownNoRip(id,:)'),Nb(id,4),'ko','markerfacecolor','k'), xlim([0 5]), xlabel('Freq Down without Rip'), ylabel('nb of Rip')%, ylim([0 5])

    end
end

