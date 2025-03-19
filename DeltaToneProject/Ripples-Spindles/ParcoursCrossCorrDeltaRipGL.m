% ParcoursCrossCorrDeltaRipGL


bin1=10;bin2=400;
Generate=0;

   % exp='BASAL';
    exp='DeltaTone';
    
    
  cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback  
  
if Generate
    
        Dir=PathForExperimentsDeltaSleepNew(exp);

        a=1;
        for i=1:length(Dir.path)
            try
                
            eval(['cd(Dir.path{',num2str(i),'}'')'])
            disp(pwd)
            load StateEpochSB SWSEpoch

            clear Dpac
            clear Dpfc
            clear tDelta
  
            load newDeltaPFCx
            Dpfc=ts(tDelta);


            clear dHPCrip
            clear rip

            try
                load RipplesdHPC25
                dHPCrip;

            catch

            %% FIND RIPPLES
            disp(' ')
            disp('   ________ FIND RIPPLES ________ ')
            clear dHPCrip
            clear rip
            res=pwd;
            load StateEpochSB SWSEpoch
            tempchHPC=load([res,'/ChannelsToAnalyse/dHPC_rip.mat'],'channel'); % changed by Marie 3june2015
            chHPC=tempchHPC.channel;
            eval(['tempLoad=load([res,''/LFPData/LFP',num2str(chHPC),'.mat''],''LFP'');'])
            eegRip=tempLoad.LFP;
            [dHPCrip,EpochRip]=FindRipplesKarimSB(eegRip,SWSEpoch,[2 5]);
            save([res,'/RipplesdHPC25.mat'],'dHPCrip','EpochRip','chHPC');
            clear dHPCrip EpochRip chHPC
            end

            load RipplesdHPC25
            rip=ts(dHPCrip(:,2)*1E4);

            clear MPEaverageRip
            clear TPEaverageRip
            
            try
                load DataPEaverageRip
                MPEaverageRip;
            catch
%                 keyboard
                clear LFPrip
                load ChannelsToAnalyse/dHPC_rip
                eval(['load LFPData/LFP',num2str(channel)])
                LFPrip=LFP;
                clear LFP
                clear Mtemp
                [MPEaverageRip,TPEaverageRip]=PlotRipRaw(LFPrip,Range(rip)/1E4);close
                save DataPEaverageRip MPEaverageRip TPEaverageRip
            end
            
            tpsRip=MPEaverageRip(:,1);
            Mrip(a,:)=MPEaverageRip(:,2);
            
            clear MPEaverageDeltaPFCxDeep
            clear TPEaverageDeltaPFCxDeep
            clear MPEaverageDeltaPFCxSup
            clear TPEaverageDeltaPFCxSup
%             !rm PEaverageDeltaPFCx.mat
            try
                load DataPEaverageDeltaPFCx
                MPEaverageDeltaPFCxDeep;
            catch
                load ChannelsToAnalyse/PFCx_deep
                eval(['load LFPData/LFP',num2str(channel)])
                LFPd=LFP;
                clear LFP
                load ChannelsToAnalyse/PFCx_sup
                eval(['load LFPData/LFP',num2str(channel)])
                LFPs=LFP;
                clear LFP
                [MPEaverageDeltaPFCxDeep,TPEaverageDeltaPFCxDeep]=PlotRipRaw(LFPd,Range(Dpfc)/1E4,1000);close
                [MPEaverageDeltaPFCxSup,TPEaverageDeltaPFCxSup]=PlotRipRaw(LFPs,Range(Dpfc)/1E4,1000);close
                save DataPEaverageDeltaPFCx MPEaverageDeltaPFCxDeep TPEaverageDeltaPFCxDeep MPEaverageDeltaPFCxSup TPEaverageDeltaPFCxSup
            end
            
            tpsDelta=MPEaverageDeltaPFCxDeep(:,1);
            MDeltaD(a,:)=MPEaverageDeltaPFCxDeep(:,2);
            MDeltaS(a,:)=MPEaverageDeltaPFCxSup(:,2);
            
            DurationSWS=End(SWSEpoch,'s')-Start(SWSEpoch,'s');
            c=cumsum(DurationSWS);
            id1=find(c>sum(DurationSWS)/5);
            id2=find(c>4*sum(DurationSWS)/5);
            
            Epoch1=subset(SWSEpoch,1:id1(1));
            Epoch2=subset(SWSEpoch,id2(1):length(Start(SWSEpoch)));
              
            load EpochToAnalyse
             for jk=1:5
                 EpochToAnalyse{jk}=and(EpochToAnalyse{jk},SWSEpoch);
             end
             
            [C1(a,:),B1]=CrossCorr(Range(Restrict(Dpfc,SWSEpoch)),dHPCrip(:,2)*1E4,bin1,bin2);
            [C2(a,:),B2]=CrossCorr(Range(Restrict(Dpfc,Epoch1)),dHPCrip(:,2)*1E4,bin1,bin2);
            [C3(a,:),B3]=CrossCorr(Range(Restrict(Dpfc,Epoch2)),dHPCrip(:,2)*1E4,bin1,bin2);    
            
            [CEp1(a,:),BEp1]=CrossCorr(Range(Restrict(Dpfc,EpochToAnalyse{1})),dHPCrip(:,2)*1E4,bin1,bin2);
            [CEp2(a,:),BEp2]=CrossCorr(Range(Restrict(Dpfc,EpochToAnalyse{2})),dHPCrip(:,2)*1E4,bin1,bin2);              
            [CEp3(a,:),BEp3]=CrossCorr(Range(Restrict(Dpfc,EpochToAnalyse{3})),dHPCrip(:,2)*1E4,bin1,bin2);             
            [CEp4(a,:),BEp4]=CrossCorr(Range(Restrict(Dpfc,EpochToAnalyse{4})),dHPCrip(:,2)*1E4,bin1,bin2);  
            [CEp5(a,:),BEp5]=CrossCorr(Range(Restrict(Dpfc,EpochToAnalyse{5})),dHPCrip(:,2)*1E4,bin1,bin2);             
            
            
            FreqRipEpoch(a,1)=length(Range(Restrict(rip,SWSEpoch)))/sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));
            FreqRipEpoch(a,2)=length(Range(Restrict(rip,Epoch1)))/sum(End(Epoch1,'s')-Start(Epoch1,'s'));
            FreqRipEpoch(a,3)=length(Range(Restrict(rip,Epoch2)))/sum(End(Epoch2,'s')-Start(Epoch2,'s'));
            FreqRipEpoch(a,4)=length(Range(Restrict(rip,EpochToAnalyse{1})))/sum(End(EpochToAnalyse{1},'s')-Start(EpochToAnalyse{1},'s'));
            FreqRipEpoch(a,5)=length(Range(Restrict(rip,EpochToAnalyse{2})))/sum(End(EpochToAnalyse{2},'s')-Start(EpochToAnalyse{2},'s'));
            FreqRipEpoch(a,6)=length(Range(Restrict(rip,EpochToAnalyse{3})))/sum(End(EpochToAnalyse{3},'s')-Start(EpochToAnalyse{3},'s'));
            FreqRipEpoch(a,7)=length(Range(Restrict(rip,EpochToAnalyse{4})))/sum(End(EpochToAnalyse{4},'s')-Start(EpochToAnalyse{4},'s'));
            FreqRipEpoch(a,8)=length(Range(Restrict(rip,EpochToAnalyse{5})))/sum(End(EpochToAnalyse{5},'s')-Start(EpochToAnalyse{5},'s'));
            
            
            FreqDeltaEpoch(a,1)=length(Range(Restrict(Dpfc,SWSEpoch)))/sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));
            FreqDeltaEpoch(a,2)=length(Range(Restrict(Dpfc,Epoch1)))/sum(End(Epoch1,'s')-Start(Epoch1,'s'));
            FreqDeltaEpoch(a,3)=length(Range(Restrict(Dpfc,Epoch2)))/sum(End(Epoch2,'s')-Start(Epoch2,'s'));
            FreqDeltaEpoch(a,4)=length(Range(Restrict(Dpfc,EpochToAnalyse{1})))/sum(End(EpochToAnalyse{1},'s')-Start(EpochToAnalyse{1},'s'));
            FreqDeltaEpoch(a,5)=length(Range(Restrict(Dpfc,EpochToAnalyse{2})))/sum(End(EpochToAnalyse{2},'s')-Start(EpochToAnalyse{2},'s'));
            FreqDeltaEpoch(a,6)=length(Range(Restrict(Dpfc,EpochToAnalyse{3})))/sum(End(EpochToAnalyse{3},'s')-Start(EpochToAnalyse{3},'s'));
            FreqDeltaEpoch(a,7)=length(Range(Restrict(Dpfc,EpochToAnalyse{4})))/sum(End(EpochToAnalyse{4},'s')-Start(EpochToAnalyse{4},'s'));
            FreqDeltaEpoch(a,8)=length(Range(Restrict(Dpfc,EpochToAnalyse{5})))/sum(End(EpochToAnalyse{5},'s')-Start(EpochToAnalyse{5},'s'));
            
            
            
            
            MiceName{a}=Dir.name{i};
            PathOK{a}=Dir.path{i};

            a=a+1;
            end % try 58 
            
        end

        for i=1:length(MiceName)
            id(i)=str2num(MiceName{i}(end-2:end));
        end
        listMice=unique(id);
        
        clear LFPrip
        clear LFPd
        clear LFPs
        cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback
        eval(['save DataParcoursCrossCorrDeltaRipGL',exp])

else
    
     
        cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback
        eval(['load DataParcoursCrossCorrDeltaRipGL',exp])    
end





%-------------------------------------------------------------------------------------------
%-------------------------------------------------------------------------------------------
%-------------------------------------------------------------------------------------------


xl=[-0.5 0.5];


figure('color',[1 1 1])
 for i=1:length(listMice)
    subplot(length(listMice),1,i), hold on,
    plot(tpsRip,Mrip(find(id==listMice(i)),:),'k')
    plot(tpsRip,mean(Mrip(find(id==listMice(i)),:)),'b','linewidth',2), ylabel(num2str(listMice(i)))
    
 end


figure('color',[1 1 1])
 for i=1:length(listMice)
    subplot(length(listMice),1,i), hold on,
    plot(tpsDelta,MDeltaD(find(id==listMice(i)),:),'r')
    plot(tpsDelta,MDeltaS(find(id==listMice(i)),:),'k')
    plot(tpsDelta,mean(MDeltaD(find(id==listMice(i)),:)),'m','linewidth',2), ylabel(num2str(listMice(i)))
    plot(tpsDelta,mean(MDeltaS(find(id==listMice(i)),:)),'b','linewidth',2), ylabel(num2str(listMice(i)))   
 end


 
figure('color',[1 1 1])
 for i=1:length(listMice)
    subplot(length(listMice),4,i*4-3), hold on,
    plot(B1/1E3,C1(find(id==listMice(i)),:),'k')
    plot(B1/1E3,mean(C1(find(id==listMice(i)),:)),'color',[0.6 0.6 0.6],'linewidth',2), ylabel(num2str(listMice(i))), xlim([xl(1) xl(2)])
    subplot(length(listMice),4,i*4-3+1), hold on
    plot(B2/1E3,C2(find(id==listMice(i)),:),'k')
    hold on, plot(B2/1E3,mean(C2(find(id==listMice(i)),:)),'b','linewidth',2), xlim([xl(1) xl(2)])
    subplot(length(listMice),4,i*4-3+2), hold on
    plot(B3/1E3,C3(find(id==listMice(i)),:),'k')
    hold on, plot(B3/1E3,mean(C3(find(id==listMice(i)),:)),'r','linewidth',2), xlim([xl(1) xl(2)])
    subplot(length(listMice),4,i*4-3+3), hold on
    plot(B2/1E3,mean(C1(find(id==listMice(i)),:)),'color',[0.6 0.6 0.6],'linewidth',2)
    hold on, plot(B2/1E3,mean(C2(find(id==listMice(i)),:)),'b','linewidth',2)
    hold on, plot(B3/1E3,mean(C3(find(id==listMice(i)),:)),'r','linewidth',2), xlim([xl(1) xl(2)])        
 end


figure('color',[1 1 1])
subplot(1,4,1), hold on,
plot(B1/1E3,C1,'k')
plot(B1/1E3,mean(C1),'color',[0.6 0.6 0.6],'linewidth',2), xlim([xl(1) xl(2)])
subplot(1,4,2), hold on
plot(B2/1E3,C2,'k')
hold on, plot(B2/1E3,mean(C2),'b','linewidth',2), xlim([xl(1) xl(2)])
subplot(1,4,3), hold on
plot(B3/1E3,C3,'k')
hold on, plot(B3/1E3,mean(C3),'r','linewidth',2), xlim([xl(1) xl(2)])
subplot(1,4,4), hold on
plot(B2/1E3,mean(C1),'color',[0.6 0.6 0.6],'linewidth',1)
hold on, plot(B2/1E3,mean(C2),'b','linewidth',2)
hold on, plot(B3/1E3,mean(C3),'r','linewidth',2), xlim([xl(1) xl(2)])


figure('color',[1 1 1]), hold on

subplot(1,6,1), hold on,
plot(BEp1/1E3,CEp1,'color',[0.6 0.6 0.6])
plot(BEp1/1E3,nanmean(CEp1),'k','linewidth',2)

subplot(1,6,2), hold on,
plot(BEp1/1E3,CEp2,'color',[0.6 0.6 0.6])
plot(BEp2/1E3,nanmean(CEp2),'b','linewidth',2)

subplot(1,6,3), hold on,
plot(BEp1/1E3,CEp3,'color',[0.6 0.6 0.6])
plot(BEp2/1E3,nanmean(CEp3),'r','linewidth',2)

subplot(1,6,4), hold on,
plot(BEp1/1E3,CEp4,'color',[0.6 0.6 0.6])
plot(BEp2/1E3,nanmean(CEp4),'g','linewidth',2)

subplot(1,6,5), hold on,
plot(BEp1/1E3,CEp5,'color',[0.6 0.6 0.6])
plot(BEp2/1E3,nanmean(CEp5),'c','linewidth',2)

subplot(1,6,6), hold on
plot(BEp1/1E3,nanmean(CEp1),'k')
plot(BEp2/1E3,nanmean(CEp2),'b')
plot(BEp2/1E3,nanmean(CEp3),'r')
plot(BEp2/1E3,nanmean(CEp4),'g')
plot(BEp2/1E3,nanmean(CEp5),'c')

