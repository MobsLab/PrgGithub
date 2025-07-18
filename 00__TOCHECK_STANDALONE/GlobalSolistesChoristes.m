% GlobalSolistesChoristes
try
     cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback/
     load DataSolistesCoristesLimit2

catch
    
             [C,Cz,B,h,b,CSspkS,BSspkS,CEspkS,BEspkS,CSspkC,BSspkC,CEspkC,BEspkC,MiceNameSoliste,PathSoliste,NeuronIDSoliste,NombreNeuronsS,PathSolisteBis]=solistesCoristes('BASAL');    
             [C1,Cz1,B1,h1,b1,CSspkS1,BSspkS1,CEspkS1,BEspkS1,CSspkC1,BSspkC1,CEspkC1,BEspkC1,MiceNameSoliste1,PathSoliste1,NeuronIDSoliste1,NombreNeuronsS1,PathSolisteBis1]=solistesCoristes('RdmTone');
             [C2,Cz2,B2,h2,b2,CSspkS2,BSspkS2,CEspkS2,BEspkS2,CSspkC2,BSspkC2,CEspkC2,BEspkC2,MiceNameSoliste2,PathSoliste2,NeuronIDSoliste2,NombreNeuronsS2,PathSolisteBis2]=solistesCoristes('DeltaTone');
             cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback/
             save DataSolistesCoristesLimit2Part1

            close all




            %-------------------------------------------------------------------------------------------

            ki=1;
            for i=1:length(PathSoliste)

                eval(['cd(PathSoliste{',num2str(i),'})'])
                load SpikeData
                load RipplesdHPC25
                load DownSpk
                load StateEpochSB SWSEpoch
                DownExt=intervalSet(Start(Down)-0.02E4,End(Down)+0.02E4);DownExt=mergeCloseintervals(DownExt,1);
            %     SWSEpoch=SWSEpoch-intervalSet(Start(Down),End(Down));
                [Cs(i,:),B]=CrossCorr(dHPCrip(:,2)*1E4, Range(S{NeuronIDSoliste(i)}),10,500);
                Epoch1=intervalSet(Start(Down)-0.04E4,Start(Down));Epoch1=mergeCloseIntervals(Epoch1,1);
                Epoch2=intervalSet(End(Down),End(Down)+0.04*1E4);Epoch2=mergeCloseIntervals(Epoch2,1);
                FrS(i,1)=length(Range(Restrict(S{NeuronIDSoliste(i)},SWSEpoch)))/sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));
                FrS(i,2)=length(Range(Restrict(S{NeuronIDSoliste(i)},SWSEpoch-DownExt)))/sum(End(SWSEpoch-DownExt,'s')-Start(SWSEpoch-DownExt,'s'));
                FrS(i,3)=length(Range(Restrict(S{NeuronIDSoliste(i)},Epoch1)))/sum(End(Epoch1,'s')-Start(Epoch1,'s'));
                FrS(i,4)=length(Range(Restrict(S{NeuronIDSoliste(i)},Epoch2)))/sum(End(Epoch2,'s')-Start(Epoch2,'s'));
                FrS(i,5)=length(Range(Restrict(S{NeuronIDSoliste(i)},SWSEpoch-Epoch1-Epoch2)))/sum(End(SWSEpoch-Epoch1-Epoch2,'s')-Start(SWSEpoch-Epoch1-Epoch2,'s'));

                Q=BinTsd(S{NeuronIDSoliste(i)},10000);    
                data1=(Range(Restrict((Q),SWSEpoch),'s'));
                data2=(Data(Restrict((Q),SWSEpoch)));
            %     data1=(Range(Restrict((Q),SWSEpoch-intervalSet(Start(Down),End(Down)),'s'));
            %     data2=(Data(Restrict((Q),SWSEpoch-intervalSet(Start(Down),End(Down)))));      
                data1(find(data2==0))=[];
                data2(find(data2==0))=[];
                [rtemp,ptemp]=corrcoef(data1,data2);
                var=polyfit(data1,data2,1);
                FrSolistes{i}=tsd(Range(Restrict((Q),SWSEpoch)),Data(Restrict((Q),SWSEpoch)));
                slop(i,1)=var(1);
                slop(i,2)=var(2);
                slop(i,3)=rtemp(1,2);
                slop(i,4)=ptemp(1,2);

                NumNeurons2=NumNeurons;
                NumNeurons(find(NumNeurons==NeuronIDSoliste(i)))=[];
                for k=NumNeurons2
                    [Ct(ki,:),B]=CrossCorr(dHPCrip(:,2)*1E4, Range(S{k}),10,500);

                    Epoch1=intervalSet(Start(Down)-0.04E4,Start(Down));Epoch1=mergeCloseIntervals(Epoch1,1);
                    Epoch2=intervalSet(End(Down),End(Down)+0.04*1E4);Epoch2=mergeCloseIntervals(Epoch2,1);
                    FrC(ki,1)=length(Range(Restrict(S{k},SWSEpoch)))/sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));
                    FrC(ki,2)=length(Range(Restrict(S{(k)},SWSEpoch-DownExt)))/sum(End(SWSEpoch-DownExt,'s')-Start(SWSEpoch-DownExt,'s'));
                    FrC(ki,3)=length(Range(Restrict(S{(k)},Epoch1)))/sum(End(Epoch1,'s')-Start(Epoch1,'s'));
                    FrC(ki,4)=length(Range(Restrict(S{(k)},Epoch2)))/sum(End(Epoch2,'s')-Start(Epoch2,'s'));
                    FrC(ki,5)=length(Range(Restrict(S{(k)},SWSEpoch-Epoch1-Epoch2)))/sum(End(SWSEpoch-Epoch1-Epoch2,'s')-Start(SWSEpoch-Epoch1-Epoch2,'s'));


                    Qs=BinTsd(S{k},10000);
                    data1=(Range(Restrict((Qs),SWSEpoch),'s'));
                    data2=(Data(Restrict((Qs),SWSEpoch)));
                %     data1=(Range(Restrict((Qs),SWSEpoch-intervalSet(Start(Down),End(Down)),'s'));
                %     data2=(Data(Restrict((Qs),SWSEpoch-intervalSet(Start(Down),End(Down)))));        
                    data1(find(data2==0))=[];
                    data2(find(data2==0))=[];
                    [rtemp,ptemp]=corrcoef(data1,data2);
                    var=polyfit(data1,data2,1);
                    slopt(ki,1)=var(1);
                    slopt(ki,2)=var(2);
                    slopt(ki,3)=rtemp(1,2);
                    slopt(ki,4)=ptemp(1,2);
                    FrChoristes{ki}=tsd(Range(Restrict((Qs),SWSEpoch)),Data(Restrict((Qs),SWSEpoch)));
                    ki=ki+1;
                end
            end



            ki=1;
            for i=1:length(PathSoliste1)
                clear TONEtime2_SWS
                clear dHPCrip
                eval(['cd(PathSoliste1{',num2str(i),'})'])
                load SpikeData
                load RipplesdHPC25
                load DownSpk
                load DeltaSleepEvent
                load StateEpochSB SWSEpoch    
                DownExt=intervalSet(Start(Down)-0.02E4,End(Down)+0.02E4);DownExt=mergeCloseintervals(DownExt,1);                
            %     SWSEpoch=SWSEpoch-intervalSet(Start(Down),End(Down));    
                [CripS1(i,:),B1]=CrossCorr(dHPCrip(:,2)*1E4, Range(S{NeuronIDSoliste1(i)}),10,500);
                [CtoneS1(i,:),B2]=CrossCorr(TONEtime2_SWS, Range(S{NeuronIDSoliste1(i)}),10,500);

                Epoch1=intervalSet(Start(Down)-0.04E4,Start(Down));Epoch1=mergeCloseIntervals(Epoch1,1);
                Epoch2=intervalSet(End(Down),End(Down)+0.04*1E4);Epoch2=mergeCloseIntervals(Epoch2,1);
                Fr1S(i,1)=length(Range(Restrict(S{NeuronIDSoliste1(i)},SWSEpoch)))/sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));
                Fr1S(i,2)=length(Range(Restrict(S{NeuronIDSoliste1(i)},SWSEpoch-DownExt)))/sum(End(SWSEpoch-DownExt,'s')-Start(SWSEpoch-DownExt,'s'));
                Fr1S(i,3)=length(Range(Restrict(S{NeuronIDSoliste1(i)},Epoch1)))/sum(End(Epoch1,'s')-Start(Epoch1,'s'));
                Fr1S(i,4)=length(Range(Restrict(S{NeuronIDSoliste1(i)},Epoch2)))/sum(End(Epoch2,'s')-Start(Epoch2,'s'));
                Fr1S(i,5)=length(Range(Restrict(S{NeuronIDSoliste1(i)},SWSEpoch-Epoch1-Epoch2)))/sum(End(SWSEpoch-Epoch1-Epoch2,'s')-Start(SWSEpoch-Epoch1-Epoch2,'s'));


                Q=BinTsd(S{NeuronIDSoliste1(i)},10000);    
                data1=(Range(Restrict((Q),SWSEpoch),'s'));
                data2=(Data(Restrict((Q),SWSEpoch)));
            %     data1=(Range(Restrict((Q),SWSEpoch-intervalSet(Start(Down),End(Down)),'s'));
            %     data2=(Data(Restrict((Q),SWSEpoch-intervalSet(Start(Down),End(Down)))));     
                data1(find(data2==0))=[];
                data2(find(data2==0))=[];
                [rtemp,ptemp]=corrcoef(data1,data2);
                var=polyfit(data1,data2,1);
                FrSolistes1{i}=tsd(Range(Restrict((Q),SWSEpoch)),Data(Restrict((Q),SWSEpoch)));
                slopS1(i,1)=var(1);
                slopS1(i,2)=var(2);
                slopS1(i,3)=rtemp(1,2);
                slopS1(i,4)=ptemp(1,2);


                NumNeurons2=NumNeurons;
                NumNeurons(find(NumNeurons==NeuronIDSoliste1(i)))=[];
                for k=NumNeurons2
                [CripC1(ki,:),B]=CrossCorr(dHPCrip(:,2)*1E4, Range(S{k}),10,500);
                [CtoneC1(ki,:),B]=CrossCorr(TONEtime2_SWS, Range(S{k}),10,500);

                  Epoch1=intervalSet(Start(Down)-0.04E4,Start(Down));Epoch1=mergeCloseIntervals(Epoch1,1);
                Epoch2=intervalSet(End(Down),End(Down)+0.04*1E4);Epoch2=mergeCloseIntervals(Epoch2,1);
                FrC1(ki,1)=length(Range(Restrict(S{(k)},SWSEpoch)))/sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));
                FrC1(ki,2)=length(Range(Restrict(S{(k)},SWSEpoch-DownExt)))/sum(End(SWSEpoch-DownExt,'s')-Start(SWSEpoch-DownExt,'s'));
                FrC1(ki,3)=length(Range(Restrict(S{(k)},Epoch1)))/sum(End(Epoch1,'s')-Start(Epoch1,'s'));
                FrC1(ki,4)=length(Range(Restrict(S{(k)},Epoch2)))/sum(End(Epoch2,'s')-Start(Epoch2,'s'));
                FrC1(ki,5)=length(Range(Restrict(S{(k)},SWSEpoch-Epoch1-Epoch2)))/sum(End(SWSEpoch-Epoch1-Epoch2,'s')-Start(SWSEpoch-Epoch1-Epoch2,'s'));

                Qs=BinTsd(S{k},10000);
                data1=(Range(Restrict((Qs),SWSEpoch),'s'));
                data2=(Data(Restrict((Qs),SWSEpoch)));
            %     data1=(Range(Restrict((Qs),SWSEpoch-intervalSet(Start(Down),End(Down)),'s'));
            %     data2=(Data(Restrict((Qs),SWSEpoch-intervalSet(Start(Down),End(Down)))));        
                data1(find(data2==0))=[];
                data2(find(data2==0))=[];
                [rtemp,ptemp]=corrcoef(data1,data2);
                var=polyfit(data1,data2,1);
                sloptC1(ki,1)=var(1);
                sloptC1(ki,2)=var(2);
                sloptC1(ki,3)=rtemp(1,2);
                sloptC1(ki,4)=ptemp(1,2);
                FrChoristes1{ki}=tsd(Range(Restrict((Qs),SWSEpoch)),Data(Restrict((Qs),SWSEpoch)));
                ki=ki+1;
                end    
            end




            ki=1;
            for i=1:length(PathSoliste2)
                clear TONEtime2_SWS
                clear dHPCrip
                eval(['cd(PathSoliste2{',num2str(i),'})'])
                load SpikeData
                load RipplesdHPC25
                load DownSpk
                load DeltaSleepEvent
                load StateEpochSB SWSEpoch    
                DownExt=intervalSet(Start(Down)-0.02E4,End(Down)+0.02E4);DownExt=mergeCloseintervals(DownExt,1);                
            %     SWSEpoch=SWSEpoch-intervalSet(Start(Down),End(Down));    
                [CripS2(i,:),B1]=CrossCorr(dHPCrip(:,2)*1E4, Range(S{NeuronIDSoliste2(i)}),10,500);
                [CtoneS2(i,:),B2]=CrossCorr(TONEtime2_SWS, Range(S{NeuronIDSoliste2(i)}),10,500);

                Epoch1=intervalSet(Start(Down)-0.04E4,Start(Down));Epoch1=mergeCloseIntervals(Epoch1,1);
                Epoch2=intervalSet(End(Down),End(Down)+0.04*1E4);Epoch2=mergeCloseIntervals(Epoch2,1);
                Fr2S(i,1)=length(Range(Restrict(S{NeuronIDSoliste2(i)},SWSEpoch)))/sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));
                Fr2S(i,2)=length(Range(Restrict(S{NeuronIDSoliste2(i)},SWSEpoch-DownExt)))/sum(End(SWSEpoch-DownExt,'s')-Start(SWSEpoch-DownExt,'s'));
                Fr2S(i,3)=length(Range(Restrict(S{NeuronIDSoliste2(i)},Epoch1)))/sum(End(Epoch1,'s')-Start(Epoch1,'s'));
                Fr2S(i,4)=length(Range(Restrict(S{NeuronIDSoliste2(i)},Epoch2)))/sum(End(Epoch2,'s')-Start(Epoch2,'s'));
                Fr2S(i,5)=length(Range(Restrict(S{NeuronIDSoliste2(i)},SWSEpoch-Epoch1-Epoch2)))/sum(End(SWSEpoch-Epoch1-Epoch2,'s')-Start(SWSEpoch-Epoch1-Epoch2,'s'));

                Q=BinTsd(S{NeuronIDSoliste2(i)},10000);    
                data1=(Range(Restrict((Q),SWSEpoch),'s'));
                data2=(Data(Restrict((Q),SWSEpoch)));
            %     data1=(Range(Restrict((Q),SWSEpoch-intervalSet(Start(Down),End(Down)),'s'));
            %     data2=(Data(Restrict((Q),SWSEpoch-intervalSet(Start(Down),End(Down)))));      
                data1(find(data2==0))=[];
                data2(find(data2==0))=[];
                [rtemp,ptemp]=corrcoef(data1,data2);
                var=polyfit(data1,data2,1);
                FrSolistes2{i}=tsd(Range(Restrict((Q),SWSEpoch)),Data(Restrict((Q),SWSEpoch)));

                slopS2(i,1)=var(1);
                slopS2(i,2)=var(2);
                slopS2(i,3)=rtemp(1,2);
                slopS2(i,4)=ptemp(1,2);

                NumNeurons2=NumNeurons;
                NumNeurons(find(NumNeurons==NeuronIDSoliste2(i)))=[];
                for k=NumNeurons2
                [CripC2(ki,:),B]=CrossCorr(dHPCrip(:,2)*1E4, Range(S{k}),10,500);
                [CtoneC2(ki,:),B]=CrossCorr(TONEtime2_SWS, Range(S{k}),10,500);
                  Epoch1=intervalSet(Start(Down)-0.04E4,Start(Down));Epoch1=mergeCloseIntervals(Epoch1,1);
                Epoch2=intervalSet(End(Down),End(Down)+0.04*1E4);Epoch2=mergeCloseIntervals(Epoch2,1);
                FrC2(ki,1)=length(Range(Restrict(S{(k)},SWSEpoch)))/sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));
                FrC2(ki,2)=length(Range(Restrict(S{(k)},SWSEpoch-DownExt)))/sum(End(SWSEpoch-DownExt,'s')-Start(SWSEpoch-DownExt,'s'));
                FrC2(ki,3)=length(Range(Restrict(S{(k)},Epoch1)))/sum(End(Epoch1,'s')-Start(Epoch1,'s'));
                FrC2(ki,4)=length(Range(Restrict(S{(k)},Epoch2)))/sum(End(Epoch2,'s')-Start(Epoch2,'s'));
                FrC2(ki,5)=length(Range(Restrict(S{(k)},SWSEpoch-Epoch1-Epoch2)))/sum(End(SWSEpoch-Epoch1-Epoch2,'s')-Start(SWSEpoch-Epoch1-Epoch2,'s'));

                Qs=BinTsd(S{k},10000);
                data1=(Range(Restrict((Qs),SWSEpoch),'s'));
                data2=(Data(Restrict((Qs),SWSEpoch)));
            %     data1=(Range(Restrict((Qs),SWSEpoch-intervalSet(Start(Down),End(Down)),'s'));
            %     data2=(Data(Restrict((Qs),SWSEpoch-intervalSet(Start(Down),End(Down)))));    
                data1(find(data2==0))=[];
                data2(find(data2==0))=[];
                [rtemp,ptemp]=corrcoef(data1,data2);
                var=polyfit(data1,data2,1);
                FrChoristes2{ki}=tsd(Range(Restrict((Qs),SWSEpoch)),Data(Restrict((Qs),SWSEpoch)));
                sloptC2(ki,1)=var(1);
                sloptC2(ki,2)=var(2);
                sloptC2(ki,3)=rtemp(1,2);
                sloptC2(ki,4)=ptemp(1,2);

                ki=ki+1;
                end    
            end


    cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback/
    save DataSolistesCoristesLimit2

end


%-------------------------------------------------------------------------------------------
%-------------------------------------------------------------------------------------------
       



figure('color',[1 1 1]), 
subplot(1,2,1), hold on, plot(sort(Cz(:,252)),'k'),plot(sort(Cz2(:,252)),'r')
subplot(1,2,2), hold on, plot(b,h,'k'), plot(b2,h2,'r')

 %--------------------------------------------------------------------------------------------    
%--------------------------------------------------------------------------------------------
    
figure('color',[1 1 1]), subplot(2,1,1), imagesc(B/1E3,1:size(C,1),zscore(C')'), xlim([-0.5 0.5]), title('BASAL')
subplot(2,1,2), plot(B/1E3,zscore(C')), xlim([-0.5 0.5])     


figure('color',[1 1 1]), 
subplot(2,2,1), plot(BSspkS/1E3,CSspkS./((max(CSspkS')'*ones(1,size(CSspkS,2)))),'k'), hold on, plot(BSspkS/1E3,mean(CSspkS./((max(CSspkS')'*ones(1,size(CSspkS,2))))),'r','linewidth',2),  ylim([0 1.2])
subplot(2,2,2), plot(BEspkS/1E3,CEspkS./((max(CEspkS')'*ones(1,size(CEspkS,2)))),'k'), hold on, plot(BEspkS/1E3,mean(CEspkS./((max(CEspkS')'*ones(1,size(CEspkS,2))))),'r','linewidth',2),  ylim([0 1.2])
subplot(2,2,3), plot(BSspkC/1E3,CSspkC./((max(CSspkC')'*ones(1,size(CSspkC,2)))),'k'), hold on, plot(BSspkC/1E3,mean(CSspkC./((max(CSspkC')'*ones(1,size(CSspkC,2))))),'r','linewidth',2),  ylim([0 1.2])
subplot(2,2,4), plot(BEspkC/1E3,CEspkC./((max(CEspkC')'*ones(1,size(CEspkC,2)))),'k'), hold on, plot(BEspkC/1E3,mean(CEspkC./((max(CEspkC')'*ones(1,size(CEspkC,2))))),'r','linewidth',2),  ylim([0 1.2])


figure('color',[1 1 1]), subplot(2,1,1), imagesc(B1/1E3,1:size(C1,1),zscore(C1')'), xlim([-0.5 0.5]), title('Tone Delta')
subplot(2,1,2), plot(B1/1E3,zscore(C1')), xlim([-0.5 0.5])     


figure('color',[1 1 1]), 
subplot(2,2,1), plot(BSspkS1/1E3,CSspkS1./((max(CSspkS1')'*ones(1,size(CSspkS1,2)))),'k'), hold on, plot(BSspkS1/1E3,mean(CSspkS1./((max(CSspkS1')'*ones(1,size(CSspkS1,2))))),'r','linewidth',2),  ylim([0 1.2])  
subplot(2,2,2), plot(BEspkS1/1E3,CEspkS1./((max(CEspkS1')'*ones(1,size(CEspkS1,2)))),'k'), hold on, plot(BEspkS1/1E3,mean(CEspkS1./((max(CEspkS1')'*ones(1,size(CEspkS1,2))))),'r','linewidth',2),  ylim([0 1.2])
subplot(2,2,3), plot(BSspkC1/1E3,CSspkC1./((max(CSspkC1')'*ones(1,size(CSspkC1,2)))),'k'), hold on, plot(BSspkC1/1E3,mean(CSspkC1./((max(CSspkC1')'*ones(1,size(CSspkC1,2))))),'r','linewidth',2),  ylim([0 1.2])
subplot(2,2,4), plot(BEspkC1/1E3,CEspkC1./((max(CEspkC1')'*ones(1,size(CEspkC1,2)))),'k'), hold on, plot(BEspkC1/1E3,mean(CEspkC1./((max(CEspkC1')'*ones(1,size(CEspkC1,2))))),'r','linewidth',2),  ylim([0 1.2])  



 
figure('color',[1 1 1]), subplot(2,1,1), imagesc(B2/1E3,1:size(C2,1),zscore(C2')'), xlim([-0.5 0.5]), title('Tone Delta')
subplot(2,1,2), plot(B2/1E3,zscore(C2')), xlim([-0.5 0.5])     


figure('color',[1 1 1]), 
subplot(2,2,1), plot(BSspkS2/1E3,CSspkS2./((max(CSspkS2')'*ones(1,size(CSspkS2,2)))),'k'), hold on, plot(BSspkS2/1E3,mean(CSspkS2./((max(CSspkS2')'*ones(1,size(CSspkS2,2))))),'r','linewidth',2),  ylim([0 1.2])  
subplot(2,2,2), plot(BEspkS2/1E3,CEspkS2./((max(CEspkS2')'*ones(1,size(CEspkS2,2)))),'k'), hold on, plot(BEspkS2/1E3,mean(CEspkS2./((max(CEspkS2')'*ones(1,size(CEspkS2,2))))),'r','linewidth',2),  ylim([0 1.2])
subplot(2,2,3), plot(BSspkC2/1E3,CSspkC2./((max(CSspkC2')'*ones(1,size(CSspkC2,2)))),'k'), hold on, plot(BSspkC2/1E3,mean(CSspkC2./((max(CSspkC2')'*ones(1,size(CSspkC2,2))))),'r','linewidth',2),  ylim([0 1.2])
subplot(2,2,4), plot(BEspkC2/1E3,CEspkC2./((max(CEspkC2')'*ones(1,size(CEspkC2,2)))),'k'), hold on, plot(BEspkC2/1E3,mean(CEspkC2./((max(CEspkC2')'*ones(1,size(CEspkC2,2))))),'r','linewidth',2),  ylim([0 1.2])  



%-------------------------------------------------------------------------------------------
%-------------------------------------------------------------------------------------------
       
figure('color',[1 1 1]), 
subplot(3,2,1), hold on
for i=1:length(FrChoristes)
plot(Range(FrChoristes{i},'s'),Data(FrChoristes{i}),'color',[0.8 0.8 0.8])
end
for i=1:length(FrChoristes)
    plot(Range(FrChoristes{i},'s'),SmoothDec(Data(FrChoristes{i}),10),'color','k','linewidth',2)
end
subplot(3,2,2), hold on
for i=1:length(FrSolistes)
plot(Range(FrSolistes{i},'s'),Data(FrSolistes{i}),'color',[0.8 0.8 0.8])
end
for i=1:length(FrSolistes)
    plot(Range(FrSolistes{i},'s'),SmoothDec(Data(FrSolistes{i}),10),'color','r','linewidth',2)
end

subplot(3,2,3), hold on
for i=1:length(FrChoristes1)
plot(Range(FrChoristes1{i},'s'),Data(FrChoristes1{i}),'color',[0.8 0.8 0.8])
end
for i=1:length(FrChoristes1)
    plot(Range(FrChoristes1{i},'s'),SmoothDec(Data(FrChoristes1{i}),10),'color','k','linewidth',2)
end
subplot(3,2,4), hold on
for i=1:length(FrSolistes1)
plot(Range(FrSolistes1{i},'s'),Data(FrSolistes1{i}),'color',[0.8 0.8 0.8])
end
for i=1:length(FrSolistes1)
    plot(Range(FrSolistes1{i},'s'),SmoothDec(Data(FrSolistes1{i}),10),'color','r','linewidth',2)
end


subplot(3,2,5), hold on
for i=1:length(FrChoristes2)
plot(Range(FrChoristes2{i},'s'),Data(FrChoristes2{i}),'color',[0.8 0.8 0.8])
end
for i=1:length(FrChoristes2)
    plot(Range(FrChoristes2{i},'s'),SmoothDec(Data(FrChoristes2{i}),10),'color','k','linewidth',2)
end
subplot(3,2,6), hold on
for i=1:length(FrSolistes2)
plot(Range(FrSolistes2{i},'s'),Data(FrSolistes2{i}),'color',[0.8 0.8 0.8])
end
for i=1:length(FrSolistes2)
    plot(Range(FrSolistes2{i},'s'),SmoothDec(Data(FrSolistes2{i}),10),'color','r','linewidth',2)
end




%-------------------------------------------------------------------------------------------
       
figure('color',[1 1 1]), 
subplot(3,2,1), hold on
for i=1:length(FrChoristes)
plot(Range(FrChoristes{i},'s'),Data(FrChoristes{i})/max(Data(FrChoristes{i})),'color',[0.8 0.8 0.8])
end
for i=1:length(FrChoristes)
    plot(Range(FrChoristes{i},'s'),SmoothDec(Data(FrChoristes{i})/max(Data(FrChoristes{i})),10),'color','k','linewidth',2)
end
subplot(3,2,2), hold on
for i=1:length(FrSolistes)
plot(Range(FrSolistes{i},'s'),Data(FrSolistes{i})/max(Data(FrSolistes{i})),'color',[0.8 0.8 0.8])
end
for i=1:length(FrSolistes)
    plot(Range(FrSolistes{i},'s'),SmoothDec(Data(FrSolistes{i})/max(Data(FrSolistes{i})),10),'color','r','linewidth',2)
end

subplot(3,2,3), hold on
for i=1:length(FrChoristes1)
plot(Range(FrChoristes1{i},'s'),Data(FrChoristes1{i})/max(Data(FrChoristes1{i})),'color',[0.8 0.8 0.8])
end
for i=1:length(FrChoristes1)
    plot(Range(FrChoristes1{i},'s'),SmoothDec(Data(FrChoristes1{i})/max(Data(FrChoristes1{i})),10),'color','k','linewidth',2)
end
subplot(3,2,4), hold on
for i=1:length(FrSolistes1)
plot(Range(FrSolistes1{i},'s'),Data(FrSolistes1{i})/max(Data(FrSolistes1{i})),'color',[0.8 0.8 0.8])
end
for i=1:length(FrSolistes1)
    plot(Range(FrSolistes1{i},'s'),SmoothDec(Data(FrSolistes1{i})/max(Data(FrSolistes1{i})),10),'color','r','linewidth',2)
end


subplot(3,2,5), hold on
for i=1:length(FrChoristes2)
plot(Range(FrChoristes2{i},'s'),Data(FrChoristes2{i})/max(Data(FrChoristes2{i})),'color',[0.8 0.8 0.8])
end
for i=1:length(FrChoristes2)
    plot(Range(FrChoristes2{i},'s'),SmoothDec(Data(FrChoristes2{i})/max(Data(FrChoristes2{i})),10),'color','k','linewidth',2)
end
subplot(3,2,6), hold on
for i=1:length(FrSolistes2)
plot(Range(FrSolistes2{i},'s'),Data(FrSolistes2{i})/max(Data(FrSolistes2{i})),'color',[0.8 0.8 0.8])
end
for i=1:length(FrSolistes2)
    plot(Range(FrSolistes2{i},'s'),SmoothDec(Data(FrSolistes2{i})/max(Data(FrSolistes2{i})),10),'color','r','linewidth',2)
end


%-----------------------------------------------------------------------------------------------------------------

   figure('color',[1 1 1]), 
   subplot(1,4,1), PlotErrorBar2(slop(:,1),slopt(:,1),0,0), [h,p]=ttest2(slop(:,1),slopt(:,1));title(num2str(floor(1000*p)/1000))
   subplot(1,4,2), PlotErrorBar2(slop(:,2),slopt(:,2),0,0), [h,p]=ttest2(slop(:,2),slopt(:,2));title(num2str(floor(1000*p)/1000))
   subplot(1,4,3), PlotErrorBar2(slop(:,3),slopt(:,3),0,0), [h,p]=ttest2(slop(:,3),slopt(:,3));title(num2str(floor(1000*p)/1000))
   subplot(1,4,4), PlotErrorBar2(slop(:,4),slopt(:,4),0,0), [h,p]=ttest2(slop(:,4),slopt(:,4));title(num2str(floor(1000*p)/1000))
   
    
   figure('color',[1 1 1]), 
   subplot(1,4,1), PlotErrorBar2(slopS1(:,1),sloptC1(:,1),0,0), [h,p]=ttest2(slopS1(:,1),sloptC1(:,1));title(num2str(floor(1000*p)/1000))
   subplot(1,4,2), PlotErrorBar2(slopS1(:,2),sloptC1(:,2),0,0), [h,p]=ttest2(slopS1(:,2),sloptC1(:,2));title(num2str(floor(1000*p)/1000))
   subplot(1,4,3), PlotErrorBar2(slopS1(:,3),sloptC1(:,3),0,0), [h,p]=ttest2(slopS1(:,3),sloptC1(:,3));title(num2str(floor(1000*p)/1000))
   subplot(1,4,4), PlotErrorBar2(slopS1(:,4),sloptC1(:,4),0,0), [h,p]=ttest2(slopS1(:,4),sloptC1(:,4));title(num2str(floor(1000*p)/1000))
   
   figure('color',[1 1 1]), 
   subplot(1,4,1), PlotErrorBar2(slopS2(:,1),sloptC2(:,1),0,0), [h,p]=ttest2(slopS2(:,1),sloptC2(:,1));title(num2str(floor(1000*p)/1000))
   subplot(1,4,2), PlotErrorBar2(slopS2(:,2),sloptC2(:,2),0,0), [h,p]=ttest2(slopS2(:,2),sloptC2(:,2));title(num2str(floor(1000*p)/1000))
   subplot(1,4,3), PlotErrorBar2(slopS2(:,3),sloptC2(:,3),0,0), [h,p]=ttest2(slopS2(:,3),sloptC2(:,3));title(num2str(floor(1000*p)/1000))
   subplot(1,4,4), PlotErrorBar2(slopS2(:,4),sloptC2(:,4),0,0), [h,p]=ttest2(slopS2(:,4),sloptC2(:,4));title(num2str(floor(1000*p)/1000))
   
%-----------------------------------------------------------------------------------------------------------------

   figure('color',[1 1 1]), 
   subplot(1,5,1), PlotErrorBar2(FrS(:,1),FrC(:,1),0,0), [h,p]=ttest2(FrS(:,1),FrC(:,1));title(num2str(floor(1000*p)/1000))
   subplot(1,5,2), PlotErrorBar2(FrS(:,2),FrC(:,2),0,0), [h,p]=ttest2(FrS(:,2),FrC(:,2));title(num2str(floor(1000*p)/1000))
   subplot(1,5,3), PlotErrorBar2(FrS(:,3),FrC(:,3),0,0), [h,p]=ttest2(FrS(:,3),FrC(:,3));title(num2str(floor(1000*p)/1000))
   subplot(1,5,4), PlotErrorBar2(FrS(:,4),FrC(:,4),0,0), [h,p]=ttest2(FrS(:,4),FrC(:,4));title(num2str(floor(1000*p)/1000))
   subplot(1,5,5), PlotErrorBar2(FrS(:,5),FrC(:,5),0,0), [h,p]=ttest2(FrS(:,5),FrC(:,5));title(num2str(floor(1000*p)/1000))
 
   
      figure('color',[1 1 1]), 
   subplot(1,5,1), PlotErrorBar2(Fr1S(:,1),FrC1(:,1),0,0), [h,p]=ttest2(Fr1S(:,1),FrC1(:,1));title(num2str(floor(1000*p)/1000))
   subplot(1,5,2), PlotErrorBar2(Fr1S(:,2),FrC1(:,2),0,0), [h,p]=ttest2(Fr1S(:,2),FrC1(:,2));title(num2str(floor(1000*p)/1000))
   subplot(1,5,3), PlotErrorBar2(Fr1S(:,3),FrC1(:,3),0,0), [h,p]=ttest2(Fr1S(:,3),FrC1(:,3));title(num2str(floor(1000*p)/1000))
   subplot(1,5,4), PlotErrorBar2(Fr1S(:,4),FrC1(:,4),0,0), [h,p]=ttest2(Fr1S(:,4),FrC1(:,4));title(num2str(floor(1000*p)/1000))
   subplot(1,5,5), PlotErrorBar2(Fr1S(:,5),FrC1(:,5),0,0), [h,p]=ttest2(Fr1S(:,5),FrC1(:,5));title(num2str(floor(1000*p)/1000))
   
   
      figure('color',[1 1 1]), 
   subplot(1,5,1), PlotErrorBar2(Fr2S(:,1),FrC2(:,1),0,0), [h,p]=ttest2(Fr2S(:,1),FrC2(:,1));title(num2str(floor(1000*p)/1000))
   subplot(1,5,2), PlotErrorBar2(Fr2S(:,2),FrC2(:,2),0,0), [h,p]=ttest2(Fr2S(:,2),FrC2(:,2));title(num2str(floor(1000*p)/1000))
   subplot(1,5,3), PlotErrorBar2(Fr2S(:,3),FrC2(:,3),0,0), [h,p]=ttest2(Fr2S(:,3),FrC2(:,3));title(num2str(floor(1000*p)/1000))
   subplot(1,5,4), PlotErrorBar2(Fr2S(:,4),FrC2(:,4),0,0), [h,p]=ttest2(Fr2S(:,4),FrC2(:,4));title(num2str(floor(1000*p)/1000))
   subplot(1,5,5), PlotErrorBar2(Fr2S(:,5),FrC2(:,5),0,0), [h,p]=ttest2(Fr2S(:,5),FrC2(:,5));title(num2str(floor(1000*p)/1000))
   
   
   %---------------------------------------------------------------------------------------------   
   %---------------------------------------------------------------------------------------------
      %---------------------------------------------------------------------------------------------
      
      
   
   if 0
   
   figure('color',[1 1 1]), 
    subplot(2,2,1), hold on, plot(B/1E3,zscore(C')','k')
    subplot(2,2,2), hold on, plot(B/1E3,zscore(Ct')','k')
    subplot(2,2,3), imagesc(B/1E3,1:size(C,1),zscore(C')')
    subplot(2,2,4),  imagesc(B/1E3,1:size(Ct,1),zscore(Ct')')
    

    
  
    figure('color',[1 1 1]), 
    subplot(2,2,1), hold on, plot(B2/1E3,zscore(CripS1')','k')
    subplot(2,2,2), hold on, plot(B2/1E3,zscore(CtoneS1')','k')
    subplot(2,2,3), hold on, plot(B2/1E3,zscore(CripC1')','k')
    subplot(2,2,4), hold on, plot(B2/1E3,zscore(CtoneC1')','k')  

    
     figure('color',[1 1 1]), 
    subplot(2,2,1), imagesc(B2/1E3,1:size(CripS1,1),zscore(CripS1')')
    subplot(2,2,2),  imagesc(B2/1E3,1:size(CtoneS1,1),zscore(CtoneS1')')
    subplot(2,2,3),  imagesc(B2/1E3,1:size(CripC1,1),zscore(CripC1')')
    subplot(2,2,4),  imagesc(B2/1E3,1:size(CtoneC1,1),zscore(CtoneC1')')  
    
   
    
   
    figure('color',[1 1 1]), 
    subplot(2,2,1), hold on, plot(B2/1E3,zscore(CripS2')','k')
    subplot(2,2,2), hold on, plot(B2/1E3,zscore(CtoneS2')','k')
    subplot(2,2,3), hold on, plot(B2/1E3,zscore(CripC2')','k')
    subplot(2,2,4), hold on, plot(B2/1E3,zscore(CtoneC2')','k')  

    
     figure('color',[1 1 1]), 
    subplot(2,2,1), imagesc(B2/1E3,1:size(CripS2,1),zscore(CripS2')')
    subplot(2,2,2),  imagesc(B2/1E3,1:size(CtoneS2,1),zscore(CtoneS2')')
    subplot(2,2,3),  imagesc(B2/1E3,1:size(CripC2,1),zscore(CripC2')')
    subplot(2,2,4),  imagesc(B2/1E3,1:size(CtoneC2,1),zscore(CtoneC2')')  
    
    
   end
   