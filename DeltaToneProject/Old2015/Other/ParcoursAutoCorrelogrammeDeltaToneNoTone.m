% ParcoursAutoCorrelogrammeDeltaToneNoTone

cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback  

% exp='DeltaT320';  
%  exp='DeltaT140';
 exp='DeltaTone';
 exp='RdmTone';


Generate=1;

if Generate
    
        Dir=PathForExperimentsDeltaSleepNew(exp);

        a=1;
        for i=1:length(Dir.path)
%             try
            disp(' ')
            disp('****************************************************************')
            eval(['cd(Dir.path{',num2str(i),'}'')'])
            disp(pwd)
      
            load newDeltaPFCx
            Dpfc=ts(tDelta);
                 
            load DeltaSleepEvent
            Tones=TONEtime2_SWS+Dir.delay{i}*1E4;

            clear do
            do=Range(Dpfc);
            dpfcTone=[];
            dpfcNoTone=[];
            for j=1:length(do)
                id=find(Tones<do(j));
                try
                    if (do(j)-Tones(id(end)))<0.2E4
                        dpfcTone=[dpfcTone,j];
                    else
                        dpfcNoTone=[dpfcNoTone,j];
                    end
                end
            end



            [C1(a,:),B]=CrossCorr(do(dpfcTone),do,300,100);C1(a,find(B==0))=0;
            [C2(a,:),B]=CrossCorr(do(dpfcNoTone),do,300,100);C2(a,find(B==0))=0;
            [C1b(a,:),Bb]=CrossCorr(do(dpfcTone),do,1000,500);C1b(a,find(B==0))=0;
            [C2b(a,:),Bb]=CrossCorr(do(dpfcNoTone),do,1000,500);C2b(a,find(B==0))=0;
            
             tps=B;
             tpsb=Bb;             
             
            MiceName{a}=Dir.name{i};
            PathOK{a}=Dir.path{i};

            a=a+1;
            
%             end
        end
          
end

smo=3;
figure('color',[1 1 1]), 
subplot(2,2,1), plot(tps/1E3,nanmean(C1),'k'), hold on, plot(tps/1E3,nanmean(C2),'r'), title(exp), xlim([tps(1) tps(end)]/1E3)
subplot(2,2,2), plot(tpsb/1E3,nanmean(C1b),'k'), hold on, plot(tpsb/1E3,nanmean(C2b),'r'), title('Tone vs NoTone'), xlim([tpsb(1) tpsb(end)]/1E3)
subplot(2,2,3), plot(tps/1E3,smooth(nanmean(C1),smo),'k'), hold on, plot(tps/1E3,smooth(nanmean(C2),smo),'r'), title(exp), xlim([tps(1) tps(end)]/1E3)
subplot(2,2,4), plot(tpsb/1E3,smooth(nanmean(C1b),smo),'k'), hold on, plot(tpsb/1E3,smooth(nanmean(C2b),smo),'r'), xlim([tpsb(1) tpsb(end)]/1E3)
set(gcf,'position',[ 754    82   570   940])


            