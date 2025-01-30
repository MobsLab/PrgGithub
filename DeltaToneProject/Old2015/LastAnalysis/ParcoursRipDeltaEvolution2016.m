function [rRip,pRip,rD,pD,rDRip,pDRip,rDNoRip,pDNoRip,NbRip,NbDown,NbDownRip,NbDownNoRip,Nb,id,MiceName,PathOK]=ParcoursRipDeltaEvolution2016(Generate,exp,DeltaLFP,CorrectionDeltaSPW)

%%
try
    Generate;
    if Generate==1
        rep=input('Are you sure about the generation of data? (y/n) ','s');
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
    CorrectionDeltaSPW=1;
end


%%
cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback

if Generate
    
    Dir=PathForExperimentsDeltaSleep2016(exp);
    
    a=1;
    for i=1:length(Dir.path)
        try
            disp(' ')
            disp('****************************************************************')
            eval(['cd(Dir.path{',num2str(i),'}'')'])
            disp(pwd)
            
            [rRip(a),pRip(a),rD(a),pD(a),rDRip(a),pDRip(a),rDNoRip(a),pDNoRip(a),NbRip(a,:),NbDown(a,:),NbDownRip(a,:),NbDownNoRip(a,:),Bs,CsRip,CeRip]=RipDeltaEvolution2016(CorrectionDeltaSPW,DeltaLFP,0); 
            
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
            
            MiceName{a}=Dir.name{i};
            PathOK{a}=Dir.path{i};
            
            a=a+1;
        end
    end
    
    cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback
    eval(['save DataParcoursRipDeltaEvolution2016',exp,'DeltaLFP',num2str(DeltaLFP),'CorrectionSPW',num2str(CorrectionDeltaSPW)])
else
    eval(['load DataParcoursRipDeltaEvolution2016',exp,'DeltaLFP',num2str(DeltaLFP),'CorrectionSPW',num2str(CorrectionDeltaSPW)])
end
eval(['load DataParcoursRipDeltaEvolution2016',exp,'DeltaLFP',num2str(DeltaLFP),'CorrectionSPW',num2str(CorrectionDeltaSPW),' Nb'])


tps=Bs;
id=[1:7];


figure('color',[1 1 1]),
subplot(1,2,1), hold on
plot(tps, nanmean(CsRipT1(1:7,:)),'k')
plot(tps, nanmean(CsRipT2(id,:)),'r')
plot(tps, nanmean(CsRipT3(id,:)),'b')
plot(tps, nanmean(CsRipT4(id,:)),'m')
plot(tps, nanmean(CsRipT5(id,:)),'color',[0.7 0.7 0.7]), title([exp,'DeltaLFP - Start - CorrectionSPW : ',num2str(CorrectionDeltaSPW)])

subplot(1,2,2), hold on
plot(tps, nanmean(CeRipT1(id,:)),'k')
plot(tps, nanmean(CeRipT2(id,:)),'r')
plot(tps, nanmean(CeRipT3(id,:)),'b')
plot(tps, nanmean(CeRipT4(id,:)),'m')
plot(tps, nanmean(CeRipT5(id,:)),'color',[0.7 0.7 0.7]), title([exp,'DeltaLFP -  End - CorrectionSPW : ',num2str(CorrectionDeltaSPW)])


figure('color',[1 1 1]),
subplot(2,2,1), PlotErrorBarN(NbRip(id,:),0); title('Nb SPW-Rs')
subplot(2,2,2), PlotErrorBarN(NbDown(id,:),0); title('Nb Down')
subplot(2,2,3), PlotErrorBarN(NbDownRip(id,:),0); title('Nb Down with SPW-Rs')
subplot(2,2,4), PlotErrorBarN(NbDownNoRip(id,:),0); title('Nb Down without SPW-Rs')


PlotErrorBar4(rRip(id),rD(id),rDRip(id),rDNoRip(id));
set(gca,'xtick',[1:4])
set(gca,'xticklabel',{'Rip','Down','D Rip','D No Rip'})
ylabel('Correlation with time')


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

end

