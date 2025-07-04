% %DifferenceDeltaRipplesEarlyLate


Generate=0;
exp='BASAL';
ton=2;

 cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback  
  
 
 
 
if Generate
    
        Dir=PathForExperimentsDeltaSleepNew(exp);

        a=1;
        for i=1:length(Dir.path)
%            try
                disp(' ')
                disp('****************************************************************')
            eval(['cd(Dir.path{',num2str(i),'}'')'])
            disp(pwd)
            
            clear TPEaverageDeltaPFCxDeep
            clear TPEaverageDeltaPFCxSup
            clear tps
            
            load DataPEaverageDeltaPFCx
            le=size(TPEaverageDeltaPFCxDeep,1);
            tps=MPEaverageDeltaPFCxDeep(:,1);
            
            figure('color',[1 1 1]), hold on
            plot(tps,nanmean(TPEaverageDeltaPFCxDeep(1:1000,:)),'k')
            plot(tps,nanmean(TPEaverageDeltaPFCxSup(1:1000,:)),'r')
            plot(tps,nanmean(TPEaverageDeltaPFCxDeep(le-1000:le,:)),'b')
            plot(tps,nanmean(TPEaverageDeltaPFCxSup(le-1000:le,:)),'m')    
            title([Dir.name{i},' Early vs late sleep'])
            
            MdeltaEarlyDeep(a,:)=nanmean(TPEaverageDeltaPFCxDeep(1:1000,:));
            MdeltaEarlySup(a,:)=nanmean(TPEaverageDeltaPFCxSup(1:1000,:));
            MdeltaLateDeep(a,:)=nanmean(TPEaverageDeltaPFCxDeep(le-1000:le,:));
            MdeltaLateSup(a,:)=nanmean(TPEaverageDeltaPFCxSup(le-1000:le,:));
            
            
            load newDeltaPFCx
            Dpfc=ts(tDelta);
            load RipplesdHPC25
            
                clear do
                do=Range(Dpfc);
                dpfcRip=[];
                dpfcNoRip=[];
                for j=1:length(do)
                    id=find(dHPCrip(:,2)*1E4<do(j));
                    try
                        if (do(j)-dHPCrip(id(end),2)*1E4)<0.2E4
                            dpfcRip=[dpfcRip,j];
                        else
                            dpfcNoRip=[dpfcNoRip,j];
                        end
                    end
                end
                
            figure('color',[1 1 1]), hold on
            plot(tps,nanmean(TPEaverageDeltaPFCxDeep(dpfcNoRip,:)),'k')
            plot(tps,nanmean(TPEaverageDeltaPFCxSup(dpfcNoRip,:)),'r')
            plot(tps,nanmean(TPEaverageDeltaPFCxDeep(dpfcRip,:)),'b')
            plot(tps,nanmean(TPEaverageDeltaPFCxSup(dpfcRip,:)),'m')    
            title([Dir.name{i},' SPW vs no SPW'])
            
            MdeltaNoRipDeep(a,:)=nanmean(TPEaverageDeltaPFCxDeep(dpfcNoRip,:));
            MdeltaNoRipSup(a,:)=nanmean(TPEaverageDeltaPFCxSup(dpfcNoRip,:));
            MdeltaRipDeep(a,:)=nanmean(TPEaverageDeltaPFCxDeep(dpfcRip,:));
            MdeltaRipSup(a,:)=nanmean(TPEaverageDeltaPFCxSup(dpfcRip,:));
            
            
            load SpikeData
            load DownSpk
                 clear do
                do=Start(Down);enn=End(Down);
                doRip=[];
                doNoRip=[];
                for j=1:length(do)
                    id=find(dHPCrip(:,2)*1E4<do(j));
                    try
                        if (do(j)-dHPCrip(id(end),2)*1E4)<0.1E4
                            doRip=[doRip,j];
                        else
                            doNoRip=[doNoRip,j];
                        end
                    end
                end
            [TPEaverageDownSTRip(a,:),tps2]=CrossCorr(do(doRip),Range(S{NumNeurons}),10,100);
            [TPEaverageDownENRip(a,:),tps2]=CrossCorr(enn(doRip),Range(S{NumNeurons}),10,100);
            [TPEaverageDownSTNoRip(a,:),tps2]=CrossCorr(do(doNoRip),Range(S{NumNeurons}),10,100);
            [TPEaverageDownENNoRip(a,:),tps2]=CrossCorr(enn(doNoRip),Range(S{NumNeurons}),10,100);
                        
           
            
            DurDownNoRip(a)=nanmean(enn(doNoRip)/1E4-do(doNoRip)/1E4);
            DurDownRip(a)=nanmean(enn(doRip)/1E4-do(doRip)/1E4);
            [hNoRip(a,:),bi]=hist(enn(doNoRip)/1E4-do(doNoRip)/1E4,[0:0.005:0.8]);
            [hRip(a,:),bi]=hist(enn(doRip)/1E4-do(doRip)/1E4,[0:0.005:0.8]);
            
            MiceName{a}=Dir.name{i};
            PathOK{a}=Dir.path{i};

             a=a+1;
%            end
        end
  cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback
 save DataDifferenceDeltaRipplesEarlyLate      
else
    cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback
 load DataDifferenceDeltaRipplesEarlyLate    
    
end


 
%  
% figure('color',[1 1 1]), 
% subplot(2,2,1), plot(MdeltaNoRipDeep(:),MdeltaRipDeep(:),'k.'), ylim([-1500 2000]), xlim([-1500 2000]), yl=ylim; xl=xlim; line([min(xl,yl) max(xl,yl)],[min(xl,yl) max(xl,yl)],'color','r'), title('Deep, no Rip vs Rip')
% subplot(2,2,2), plot(MdeltaNoRipSup(:),MdeltaRipSup(:),'k.'), ylim([-1500 2000]), xlim([-1500 2000]), yl=ylim; xl=xlim; line([min(xl,yl) max(xl,yl)],[min(xl,yl) max(xl,yl)],'color','r'), title('Sup, no Rip vs Rip')
% subplot(2,2,3), plot(MdeltaEarlyDeep(:),MdeltaLateDeep(:),'k.'), ylim([-1500 2000]), xlim([-1500 2000]), yl=ylim; xl=xlim; line([min(xl,yl) max(xl,yl)],[min(xl,yl) max(xl,yl)],'color','r'), title('Deep, Early vs Late')
% subplot(2,2,4), plot(MdeltaEarlySup(:),MdeltaLateSup(:),'k.'), ylim([-1500 2000]), xlim([-1500 2000]), yl=ylim; xl=xlim; line([min(xl,yl) max(xl,yl)],[min(xl,yl) max(xl,yl)],'color','r'), title('Sup, Early vs Late')

% 
% for a=1:13
% figure('color',[1 1 1]), 
% subplot(2,2,1), plot(MdeltaNoRipDeep(a,:),MdeltaRipDeep(a,:),'k.'), ylim([-1500 2000]), xlim([-1500 2000]), yl=ylim; xl=xlim; line([min(xl,yl) max(xl,yl)],[min(xl,yl) max(xl,yl)],'color','r'), title('Deep, no Rip vs Rip')
% subplot(2,2,2), plot(MdeltaNoRipSup(a,:),MdeltaRipSup(a,:),'k.'), ylim([-1500 2000]), xlim([-1500 2000]), yl=ylim; xl=xlim; line([min(xl,yl) max(xl,yl)],[min(xl,yl) max(xl,yl)],'color','r'), title('Sup, no Rip vs Rip')
% subplot(2,2,3), plot(MdeltaEarlyDeep(a,:),MdeltaLateDeep(a,:),'k.'), ylim([-1500 2000]), xlim([-1500 2000]), yl=ylim; xl=xlim; line([min(xl,yl) max(xl,yl)],[min(xl,yl) max(xl,yl)],'color','r'), title('Deep, Early vs Late')
% subplot(2,2,4), plot(MdeltaEarlySup(a,:),MdeltaLateSup(a,:),'k.'), ylim([-1500 2000]), xlim([-1500 2000]), yl=ylim; xl=xlim; line([min(xl,yl) max(xl,yl)],[min(xl,yl) max(xl,yl)],'color','r'), title('Sup, Early vs Late')
% end


figure('color',[1 1 1]), hold on
plot(tps2,mean(TPEaverageDownSTNoRip),'k')
plot(tps2,mean(TPEaverageDownENNoRip),'r')
plot(tps2,mean(TPEaverageDownSTRip),'b')
plot(tps2,mean(TPEaverageDownENRip),'m')    
title(['SPW vs no SPW'])
            
 
     
figure('color',[1 1 1]), 
subplot(2,2,1), plot(MdeltaNoRipDeep(:),MdeltaRipDeep(:),'k.'), ylim([-1500 2000]), xlim([-1500 2000]), yl=ylim; xl=xlim; line([min(xl,yl) max(xl,yl)],[min(xl,yl) max(xl,yl)],'color','r'), title('Deep, no Rip vs Rip')
subplot(2,2,2), plot(MdeltaNoRipSup(:),MdeltaRipSup(:),'k.'), ylim([-1500 2000]), xlim([-1500 2000]), yl=ylim; xl=xlim; line([min(xl,yl) max(xl,yl)],[min(xl,yl) max(xl,yl)],'color','r'), title('Sup, no Rip vs Rip')
subplot(2,2,3), plot(MdeltaEarlyDeep(:),MdeltaLateDeep(:),'k.'), ylim([-1500 2000]), xlim([-1500 2000]), yl=ylim; xl=xlim; line([min(xl,yl) max(xl,yl)],[min(xl,yl) max(xl,yl)],'color','r'), title('Deep, Early vs Late')
subplot(2,2,4), plot(MdeltaEarlySup(:),MdeltaLateSup(:),'k.'), ylim([-1500 2000]), xlim([-1500 2000]), yl=ylim; xl=xlim; line([min(xl,yl) max(xl,yl)],[min(xl,yl) max(xl,yl)],'color','r'), title('Sup, Early vs Late')



temp1=MdeltaNoRipDeep;
temp2=MdeltaRipDeep;
temp3=MdeltaNoRipSup;
temp4=MdeltaRipSup;

temp5=MdeltaEarlyDeep;
temp6=MdeltaLateDeep;
temp7=MdeltaEarlySup;
temp8=MdeltaLateSup;


temp1(isnan(temp1))=[];
temp2(isnan(temp2))=[];
temp3(isnan(temp3))=[];
temp4(isnan(temp4))=[];
temp5(isnan(temp5))=[];
temp6(isnan(temp6))=[];
temp7(isnan(temp7))=[];
temp8(isnan(temp8))=[];

[ht,p1]=ttest2(max(temp1'),max(temp2'));
[ht,p2]=ttest2(max(temp3'),max(temp4'));
[ht,p3]=ttest2(min(temp1'),min(temp2'));
[ht,p4]=ttest2(min(temp3'),min(temp4'));

[ht,p5]=ttest2(max(temp5'),max(temp6'));
[ht,p6]=ttest2(max(temp7'),max(temp8'));
[ht,p7]=ttest2(min(temp5'),min(temp6'));
[ht,p8]=ttest2(min(temp7'),min(temp8'));


figure('color',[1 1 1])
subplot(1,2,1), PlotErrorBar4(max(MdeltaNoRipDeep'),max(MdeltaRipDeep'),max(MdeltaNoRipSup'),max(MdeltaRipSup'),0), ylabel('Delta Wave Peak Amplitude'), xlabel('No Rip vs Rip'), title(['p= ',num2str(floor(p1*100)/100),', p= ',num2str(floor(p2*100)/100)])
subplot(1,2,2),PlotErrorBar4(min(MdeltaNoRipDeep'),min(MdeltaRipDeep'),min(MdeltaNoRipSup'),min(MdeltaRipSup'),0), ylabel('Delta Wave Through Amplitude'), xlabel('No Rip vs Rip'),title(['p= ',num2str(floor(p3*100)/100),', p= ',num2str(floor(p4*100)/100)])


figure('color',[1 1 1])
subplot(1,2,1), PlotErrorBar4(max(MdeltaEarlyDeep'),max(MdeltaLateDeep'),max(MdeltaEarlySup'),max(MdeltaLateSup'),0), ylabel('Delta Wave Peak Amplitude'), xlabel('Early vs Late'),title(['p= ',num2str(floor(p5*100)/100),', p= ',num2str(floor(p6*100)/100)])
subplot(1,2,2),PlotErrorBar4(min(MdeltaEarlyDeep'),min(MdeltaLateDeep'),min(MdeltaEarlySup'),min(MdeltaLateSup'),0), ylabel('Delta Wave Through Amplitude'), xlabel('Early vs Late'), title(['p= ',num2str(floor(p7*100)/100),', p= ',num2str(floor(p8*100)/100)])


PlotErrorBar2(DurDownNoRip(DurDownNoRip<0.3),DurDownRip(DurDownRip<0.3)), ylabel('Duration Down states'), xlabel('No Rip vs Rip')
% figure, plot(bi(1:2:end),zscore(hRip(:,1:2:end)')','r'), hold on, plot(bi(1:2:end),zscore(hNoRip(:,1:2:end)')','k')





%  

%             
% MT1=zeros(2001,1);
% MT2=zeros(2001,1);
% for a=1:13
%     MMT1=MMT1+MM1{a}(:,2);
%     MMT2=MMT2+MM2{a}(:,2);
% end
% subplot(1,2,2), 
% plot(MM1{a}(:,1),MMT1/13,'k','linewidth',2)
% hold on, plot(MM2{a}(:,1),MMT2/13,'r','linewidth',2)


