function [Ctotal,CTot2,B,Nb,CspkT,CspkTc,CspkTcb,TCspkt]=SpindlesRipplesN1N2N3(SleepPeriod)

spike=1;

% fac1=5;fac2=400;
fac1=10;fac2=200;
windRipDel=400;%ms
smo=3;

Dir1=PathForExperimentsDeltaSleepNew('BASAL');
Dir1=RestrictPathForExperiment(Dir1,'nMice',[243 244 251 252]);
Dir2=PathForExperimentsML('BASAL');
Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
Dir=MergePathForExperiment(Dir1,Dir2);

TCspk1=[];
TCspk2=[];
TCspk3=[];
TCspk4=[];
TCspk5=[];
TCspk6=[];
TCspk7=[];
TCspk8=[];
TCspk9=[];
TCspk10=[];
TCspk11=[];

 a=1;
for man=1:length(Dir.path)
        disp(' '); disp(Dir.path{man})
        cd(Dir.path{man})
        
         try

        [WAKE,REM,N1,N2,N3,NamesStages]=RunSubstages;close
                
        eval(['Epoch=',SleepPeriod,';'])
        
             % get delta
            clear tDelta Dpfc
            load('AllDeltaPFCx.mat','tDelta');
            tDelta(tDelta<windRipDel*10)=[];
            Dpfc=ts(tDelta);
            
            % get ripples
            clear dHPCrip chHPC rip
            load('AllRipplesdHPC25.mat','dHPCrip','chHPC');
            rip=ts(dHPCrip(:,2)*1E4);
            
            % separate ripples followed by delta or not
            clear PreDelt PostDel OutDelt RipPeD RipPoD RipPeD RipOuD
            PreDelt=intervalSet(tDelta-windRipDel*10,tDelta-0.1*1E4);
            PreDelt=mergeCloseIntervals(PreDelt,1);% if delta closer than windRipDel
            PostDelt=intervalSet(tDelta+0.1*1E4,tDelta+windRipDel*10);
            PostDelt=mergeCloseIntervals(PostDelt,1);% if delta closer than windRipDel
            TotalRipEpoch=intervalSet(tDelta(1)-1000,tDelta(end)+1000);
            OutDelt=TotalRipEpoch-intervalSet(tDelta-windRipDel*10,tDelta+windRipDel*10);
            OutDelt=mergeCloseIntervals(OutDelt,1);
            
            RipPeD=Restrict(rip,PreDelt);% ripples before delta
            RipPoD=Restrict(rip,PostDelt);% ripples before delta
            RipOuD=Restrict(rip,OutDelt);% ripples without delta
            
          
            
             spiHfs=[];
             spiLfs=[];
             spiHfd=[];
             spiLfd=[];

            [SpiTot,SpiHigh,SpiLow,SpiULow]=GetSpindlesML('PFCx_sup');
            
            
            if ~isempty(SpiHigh)
                spiHfs=[spiHfs;SpiHigh(:,2)];
                spiHfsT=SpiHigh;
            end
            if ~isempty(SpiLow)
                spiLfs=[spiLfs;SpiLow(:,2)];
                spiLfsT=SpiLow;
            end
            
            
             [SpiTot,SpiHigh,SpiLow,SpiULow]=GetSpindlesML('PFCx_deep');
            if ~isempty(SpiHigh)
                spiHfd=[spiHfd;SpiHigh(:,2)];
                spiHfdT=SpiHigh;
            end
            if ~isempty(SpiLow)
                spiLfd=[spiLfd;SpiLow(:,2)];
                spiLfdT=SpiLow;
            end           
            
            
            clear Spfc

                Spfc=[spiHfs;spiLfs;spiHfd;spiLfd];
                SpfcT=[spiHfsT;spiLfsT;spiHfdT;spiLfdT];
%                 [BE,id]=sort(SpfcT(:,2));
%                 SpfcT=SpfcT(id,:);
%                 
               Spi1=intervalSet(spiHfsT(:,1)*1E4,spiHfsT(:,3)*1E4);
               Spi2=intervalSet(spiLfsT(:,1)*1E4,spiLfsT(:,3)*1E4);
               Spi3=intervalSet(spiHfdT(:,1)*1E4,spiHfdT(:,3)*1E4);
               Spi4=intervalSet(spiLfdT(:,1)*1E4,spiLfdT(:,3)*1E4);
               SpiEpoch=or(or(Spi1,Spi2),or(Spi3,Spi4));
               stSp=Start(SpiEpoch);enSp=End(SpiEpoch);
                %SpfcT=ts(SpfcT(:,2)*1E4);          

            SpiEpoch=intervalSet(stSp-0.5*1E4,enSp+0.5*1E4);
            SpiEpoch=mergeCloseIntervals(SpiEpoch,1);% if delta closer than windRipDel      
            ripSpi=Restrict(rip,SpiEpoch);
            ripNoSpi=Restrict(rip,TotalRipEpoch-SpiEpoch);
        
        tps1=ts(spiHfs*1E4);
        tps2=ts(spiHfd*1E4);
        tps3=ts(spiLfs*1E4);
        tps4=ts(spiLfd*1E4);
        tps5=Dpfc;
        tps6=rip;
        tps7=RipPeD;
        tps8=RipPoD;
        tps9=RipOuD;
        tps10=ripSpi;
        tps11=ripNoSpi;       
        
            Nb(a,1)=length(Range(Restrict(RipPeD,Epoch)));
            Nb(a,2)=length(Range(Restrict(RipPoD,Epoch)));
            Nb(a,3)=length(Range(Restrict(RipOuD,Epoch)));
            Nb(a,4)=length(Range(Restrict(rip,Epoch)));
            Nb(a,5)=length(Range(Restrict(Dpfc,Epoch)));
            Nb(a,6)=length(Range(Restrict(tps1,Epoch)));
            Nb(a,7)=length(Range(Restrict(tps2,Epoch)));         
            Nb(a,8)=length(Range(Restrict(tps3,Epoch)));
            Nb(a,9)=length(Range(Restrict(tps4,Epoch))); 
            Nb(a,10)=length(Range(Restrict(tps10,Epoch))); 
            Nb(a,11)=length(Range(Restrict(tps11,Epoch))); 
%         Epoch=N2;tpsA=Restrict(tps5,Epoch);tpsB=Restrict(tps6,Epoch);
%         [C,B]=CrossCorr(Range(tpsA),Range(tpsB),100,100);
%         figure('color',[1 1 1]), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r') 
%   
if 0
        
%         figure('color',[1 1 1]),
        tpsA=Restrict(tps1,Epoch);tpsB=Restrict(tps5,Epoch);
        [C1(a,:),B]=CrossCorrKB(Range(tpsA),Range(tpsB),fac1,fac2);
%         subplot(3,3,1), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r'), title(Dir.path{man})
        tpsA=Restrict(tps2,Epoch);tpsB=Restrict(tps5,Epoch);
        [C2(a,:),B]=CrossCorrKB(Range(tpsA),Range(tpsB),fac1,fac2);
%         subplot(3,3,2), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r') 
        tpsA=Restrict(tps3,Epoch);tpsB=Restrict(tps5,Epoch);
        [C3(a,:),B]=CrossCorrKB(Range(tpsA),Range(tpsB),fac1,fac2);
%         subplot(3,3,3), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r') 
        tpsA=Restrict(tps4,Epoch);tpsB=Restrict(tps5,Epoch);
        [C4(a,:),B]=CrossCorrKB(Range(tpsA),Range(tpsB),fac1,fac2);
%         subplot(3,3,4), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r') 
        tpsA=Restrict(tps5,Epoch);tpsB=Restrict(tps5,Epoch);
        [Ctemp,B]=CrossCorrKB(Range(tpsA),Range(tpsB),fac1,fac2);Ctemp(B==0)=0;C5(a,:)=Ctemp;
%         subplot(3,3,5), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r')        
        tpsA=Restrict(tps6,Epoch);tpsB=Restrict(tps5,Epoch);
        [C6(a,:),B]=CrossCorrKB(Range(tpsA),Range(tpsB),fac1,fac2);
%         subplot(3,3,6), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r')         
        tpsA=Restrict(tps7,Epoch);tpsB=Restrict(tps5,Epoch);
        [C7(a,:),B]=CrossCorrKB(Range(tpsA),Range(tpsB),fac1,fac2);
%         subplot(3,3,7), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r') 
        tpsA=Restrict(tps8,Epoch);tpsB=Restrict(tps5,Epoch);
        [C8(a,:),B]=CrossCorrKB(Range(tpsA),Range(tpsB),fac1,fac2);
%         subplot(3,3,8), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r') 
        tpsA=Restrict(tps9,Epoch);tpsB=Restrict(tps5,Epoch);
        [C9(a,:),B]=CrossCorrKB(Range(tpsA),Range(tpsB),fac1,fac2);
%         subplot(3,3,9), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r')       
        

%         figure('color',[1 1 1]),
        tpsA=Restrict(tps7,Epoch);tpsB=Restrict(tps1,Epoch);
        [C10(a,:),B]=CrossCorrKB(Range(tpsA),Range(tpsB),fac1,fac2);
%         subplot(3,4,1), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r'), title(Dir.path{man})
        tpsA=Restrict(tps7,Epoch);tpsB=Restrict(tps2,Epoch);
        [C11(a,:),B]=CrossCorrKB(Range(tpsA),Range(tpsB),fac1,fac2);
%         subplot(3,4,2), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r') 
        tpsA=Restrict(tps7,Epoch);tpsB=Restrict(tps3,Epoch);
        [C12(a,:),B]=CrossCorrKB(Range(tpsA),Range(tpsB),fac1,fac2);
%         subplot(3,4,3), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r') 
        tpsA=Restrict(tps7,Epoch);tpsB=Restrict(tps4,Epoch);
        [C13(a,:),B]=CrossCorrKB(Range(tpsA),Range(tpsB),fac1,fac2);
%         subplot(3,4,4), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r') 
        
        tpsA=Restrict(tps8,Epoch);tpsB=Restrict(tps1,Epoch);
        [C14(a,:),B]=CrossCorrKB(Range(tpsA),Range(tpsB),fac1,fac2);
%         subplot(3,4,5), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r') 
        tpsA=Restrict(tps8,Epoch);tpsB=Restrict(tps2,Epoch);
        [C15(a,:),B]=CrossCorrKB(Range(tpsA),Range(tpsB),fac1,fac2);
%         subplot(3,4,6), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r') 
        tpsA=Restrict(tps8,Epoch);tpsB=Restrict(tps3,Epoch);
        [C16(a,:),B]=CrossCorrKB(Range(tpsA),Range(tpsB),fac1,fac2);
%         subplot(3,4,7), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r') 
        tpsA=Restrict(tps8,Epoch);tpsB=Restrict(tps4,Epoch);
        [C17(a,:),B]=CrossCorrKB(Range(tpsA),Range(tpsB),fac1,fac2);
%         subplot(3,4,8), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r') 
        
        tpsA=Restrict(tps9,Epoch);tpsB=Restrict(tps1,Epoch);
        [C18(a,:),B]=CrossCorrKB(Range(tpsA),Range(tpsB),fac1,fac2);
%         subplot(3,4,9), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r') 
        tpsA=Restrict(tps9,Epoch);tpsB=Restrict(tps2,Epoch);
        [C19(a,:),B]=CrossCorrKB(Range(tpsA),Range(tpsB),fac1,fac2);
%         subplot(3,4,10), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r') 
        tpsA=Restrict(tps9,Epoch);tpsB=Restrict(tps3,Epoch);
        [C20(a,:),B]=CrossCorrKB(Range(tpsA),Range(tpsB),fac1,fac2);
%         subplot(3,4,11), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r') 
        tpsA=Restrict(tps9,Epoch);tpsB=Restrict(tps4,Epoch);        
        [C21(a,:),B]=CrossCorrKB(Range(tpsA),Range(tpsB),fac1,fac2);
%         subplot(3,4,12), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r') 
 

        tpsA=Restrict(tps6,Epoch);tpsB=Restrict(tps1,Epoch);
        [C22(a,:),B]=CrossCorrKB(Range(tpsA),Range(tpsB),fac1,fac2);
%         subplot(3,4,9), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r') 
        tpsA=Restrict(tps6,Epoch);tpsB=Restrict(tps2,Epoch);
        [C23(a,:),B]=CrossCorrKB(Range(tpsA),Range(tpsB),fac1,fac2);
%         subplot(3,4,10), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r') 
        tpsA=Restrict(tps6,Epoch);tpsB=Restrict(tps3,Epoch);
        [C24(a,:),B]=CrossCorrKB(Range(tpsA),Range(tpsB),fac1,fac2);
%         subplot(3,4,11), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r') 
        tpsA=Restrict(tps6,Epoch);tpsB=Restrict(tps4,Epoch);        
        [C25(a,:),B]=CrossCorrKB(Range(tpsA),Range(tpsB),fac1,fac2);
%         subplot(3,4,12), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r') 

else
    
   %figure('color',[1 1 1]),
        tpsA=Restrict(tps1,Epoch);tpsB=Restrict(tps5,Epoch);
        try
        [C1(a,:),B]=CrossCorrKB(Range(tpsB),Range(tpsA),fac1,fac2);
        catch
        C1(a,:)=zeros(1,201)*nan;   
        end
%         subplot(3,3,1), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r'), title(Dir.path{man})
        tpsA=Restrict(tps2,Epoch);tpsB=Restrict(tps5,Epoch);
        try
            [C2(a,:),B]=CrossCorrKB(Range(tpsB),Range(tpsA),fac1,fac2);
        catch
        C2(a,:)=zeros(1,201)*nan;   
        end
%         subplot(3,3,2), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r') 
        tpsA=Restrict(tps3,Epoch);tpsB=Restrict(tps5,Epoch);
        try
            [C3(a,:),B]=CrossCorrKB(Range(tpsB),Range(tpsA),fac1,fac2);
        catch
        C3(a,:)=zeros(1,201)*nan;   
        end
%         subplot(3,3,3), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r') 
        tpsA=Restrict(tps4,Epoch);tpsB=Restrict(tps5,Epoch);
        try
            [C4(a,:),B]=CrossCorrKB(Range(tpsB),Range(tpsA),fac1,fac2);
        catch
        C4(a,:)=zeros(1,201)*nan;   
        end
%         subplot(3,3,4), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r') 
        tpsA=Restrict(tps5,Epoch);tpsB=Restrict(tps5,Epoch);
        try
            [Ctemp,B]=CrossCorrKB(Range(tpsB),Range(tpsA),fac1,fac2);Ctemp(B==0)=0;C5(a,:)=Ctemp;
        catch
        C5(a,:)=zeros(1,201)*nan;   
        end
        %         subplot(3,3,5), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r')        
        tpsA=Restrict(tps6,Epoch);tpsB=Restrict(tps5,Epoch);
        try
            [C6(a,:),B]=CrossCorrKB(Range(tpsB),Range(tpsA),fac1,fac2);
        catch
        C6(a,:)=zeros(1,201)*nan;   
        end
%         subplot(3,3,6), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r')         
        tpsA=Restrict(tps7,Epoch);tpsB=Restrict(tps5,Epoch);
        try
            [C7(a,:),B]=CrossCorrKB(Range(tpsB),Range(tpsA),fac1,fac2);
        catch
        C7(a,:)=zeros(1,201)*nan;   
        end
%         subplot(3,3,7), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r') 
        tpsA=Restrict(tps8,Epoch);tpsB=Restrict(tps5,Epoch);
        try
            [C8(a,:),B]=CrossCorrKB(Range(tpsB),Range(tpsA),fac1,fac2);
        catch
        C8(a,:)=zeros(1,201)*nan;   
        end
%         subplot(3,3,8), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r') 
        tpsA=Restrict(tps9,Epoch);tpsB=Restrict(tps5,Epoch);
        try
            [C9(a,:),B]=CrossCorrKB(Range(tpsB),Range(tpsA),fac1,fac2);
        catch
        C9(a,:)=zeros(1,201)*nan;   
        end
%         subplot(3,3,9), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r')       
   




%         figure('color',[1 1 1]),
        tpsA=Restrict(tps7,Epoch);tpsB=Restrict(tps1,Epoch);
        try
            [C10(a,:),B]=CrossCorrKB(Range(tpsB),Range(tpsA),fac1,fac2);
        catch
        C10(a,:)=zeros(1,201)*nan;   
        end
%         subplot(3,4,1), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r'), title(Dir.path{man})
        tpsA=Restrict(tps7,Epoch);tpsB=Restrict(tps2,Epoch);
        try
            [C11(a,:),B]=CrossCorrKB(Range(tpsB),Range(tpsA),fac1,fac2);
        catch
        C11(a,:)=zeros(1,201)*nan;   
        end
%         subplot(3,4,2), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r') 
        tpsA=Restrict(tps7,Epoch);tpsB=Restrict(tps3,Epoch);
        try
            [C12(a,:),B]=CrossCorrKB(Range(tpsB),Range(tpsA),fac1,fac2);
        catch
        C12(a,:)=zeros(1,201)*nan;   
        end
%         subplot(3,4,3), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r') 
        tpsA=Restrict(tps7,Epoch);tpsB=Restrict(tps4,Epoch);
        try
            [C13(a,:),B]=CrossCorrKB(Range(tpsB),Range(tpsA),fac1,fac2);
        catch
        C13(a,:)=zeros(1,201)*nan;   
        end
%         subplot(3,4,4), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r') 
        
        tpsA=Restrict(tps8,Epoch);tpsB=Restrict(tps1,Epoch);
        try
            [C14(a,:),B]=CrossCorrKB(Range(tpsB),Range(tpsA),fac1,fac2);
        catch
        C14(a,:)=zeros(1,201)*nan;   
        end
%         subplot(3,4,5), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r') 
        tpsA=Restrict(tps8,Epoch);tpsB=Restrict(tps2,Epoch);
        try
            [C15(a,:),B]=CrossCorrKB(Range(tpsB),Range(tpsA),fac1,fac2);
        catch
        C15(a,:)=zeros(1,201)*nan;   
        end
%         subplot(3,4,6), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r') 
        tpsA=Restrict(tps8,Epoch);tpsB=Restrict(tps3,Epoch);
        try
            [C16(a,:),B]=CrossCorrKB(Range(tpsB),Range(tpsA),fac1,fac2);
        catch
        C16(a,:)=zeros(1,201)*nan;   
        end
%         subplot(3,4,7), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r') 
        tpsA=Restrict(tps8,Epoch);tpsB=Restrict(tps4,Epoch);
        try
            [C17(a,:),B]=CrossCorrKB(Range(tpsB),Range(tpsA),fac1,fac2);
        catch
        C17(a,:)=zeros(1,201)*nan;   
        end
%         subplot(3,4,8), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r') 
        
        tpsA=Restrict(tps9,Epoch);tpsB=Restrict(tps1,Epoch);
        try
            [C18(a,:),B]=CrossCorrKB(Range(tpsB),Range(tpsA),fac1,fac2);
        catch
        C18(a,:)=zeros(1,201)*nan;   
        end
%         subplot(3,4,9), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r') 
        tpsA=Restrict(tps9,Epoch);tpsB=Restrict(tps2,Epoch);
        try
            [C19(a,:),B]=CrossCorrKB(Range(tpsB),Range(tpsA),fac1,fac2);
        catch
        C19(a,:)=zeros(1,201)*nan;   
        end
%         subplot(3,4,10), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r') 
        tpsA=Restrict(tps9,Epoch);tpsB=Restrict(tps3,Epoch);
        try
            [C20(a,:),B]=CrossCorrKB(Range(tpsB),Range(tpsA),fac1,fac2);
        catch
        C20(a,:)=zeros(1,201)*nan;   
        end
%         subplot(3,4,11), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r') 
        tpsA=Restrict(tps9,Epoch);tpsB=Restrict(tps4,Epoch);        
        try
            [C21(a,:),B]=CrossCorrKB(Range(tpsB),Range(tpsA),fac1,fac2);
        catch
        C21(a,:)=zeros(1,201)*nan;   
        end
%         subplot(3,4,12), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r') 
 

        tpsA=Restrict(tps6,Epoch);tpsB=Restrict(tps1,Epoch);
        try
            [C22(a,:),B]=CrossCorrKB(Range(tpsB),Range(tpsA),fac1,fac2);
        catch
        C22(a,:)=zeros(1,201)*nan;   
        end
%         subplot(3,4,9), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r') 
        tpsA=Restrict(tps6,Epoch);tpsB=Restrict(tps2,Epoch);
        try
            [C23(a,:),B]=CrossCorrKB(Range(tpsB),Range(tpsA),fac1,fac2);
        catch
        C23(a,:)=zeros(1,201)*nan;   
        end
%         subplot(3,4,10), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r') 
        tpsA=Restrict(tps6,Epoch);tpsB=Restrict(tps3,Epoch);
        try
            [C24(a,:),B]=CrossCorrKB(Range(tpsB),Range(tpsA),fac1,fac2);
        catch
        C24(a,:)=zeros(1,201)*nan;   
        end
%         subplot(3,4,11), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r') 
        tpsA=Restrict(tps6,Epoch);tpsB=Restrict(tps4,Epoch);        
        try
            [C25(a,:),B]=CrossCorrKB(Range(tpsB),Range(tpsA),fac1,fac2);
        catch
        C25(a,:)=zeros(1,201)*nan;   
        end
%         subplot(3,4,12), plot(B/1E3,C,'k'), line([0 0 ],ylim,'color','r') 
    if spike
            load SpikeData S
            [S,numNeurons]=GetSpikesFromStructure('PFCx',S);
            
           for i=1:length(numNeurons)
                    try
                    [tempp,B]=CrossCorrKB(Range(Restrict(S{numNeurons(i)},Epoch)),Range(Restrict(tps1,Epoch)),fac1,fac2);
                    TCspk1=[TCspk1;tempp'];
                    end
                    try
                    [tempp,B]=CrossCorrKB(Range(Restrict(S{numNeurons(i)},Epoch)),Range(Restrict(tps2,Epoch)),fac1,fac2);
                    TCspk2=[TCspk2;tempp'];
                    end
                    try
                    [tempp,B]=CrossCorrKB(Range(Restrict(S{numNeurons(i)},Epoch)),Range(Restrict(tps3,Epoch)),fac1,fac2);
                    TCspk3=[TCspk3;tempp'];
                    end
                    try
                    [tempp,B]=CrossCorrKB(Range(Restrict(S{numNeurons(i)},Epoch)),Range(Restrict(tps4,Epoch)),fac1,fac2);
                    TCspk4=[TCspk4;tempp'];
                    end
                    try
                    [tempp,B]=CrossCorrKB(Range(Restrict(S{numNeurons(i)},Epoch)),Range(Restrict(tps5,Epoch)),fac1,fac2);
                    TCspk5=[TCspk5;tempp'];
                    end
                    try
                    [tempp,B]=CrossCorrKB(Range(Restrict(S{numNeurons(i)},Epoch)),Range(Restrict(tps6,Epoch)),fac1,fac2);
                    TCspk6=[TCspk6;tempp'];
                    end
                    try
                    [tempp,B]=CrossCorrKB(Range(Restrict(S{numNeurons(i)},Epoch)),Range(Restrict(tps7,Epoch)),fac1,fac2);
                    TCspk7=[TCspk7;tempp'];
                    end
                    try
                    [tempp,B]=CrossCorrKB(Range(Restrict(S{numNeurons(i)},Epoch)),Range(Restrict(tps8,Epoch)),fac1,fac2);
                    TCspk8=[TCspk8;tempp'];
                    end
                    try
                    [tempp,B]=CrossCorrKB(Range(Restrict(S{numNeurons(i)},Epoch)),Range(Restrict(tps9,Epoch)),fac1,fac2);
                    TCspk9=[TCspk9;tempp'];
                    end
                    try
                    [tempp,B]=CrossCorrKB(Range(Restrict(S{numNeurons(i)},Epoch)),Range(Restrict(tps10,Epoch)),fac1,fac2);
                    TCspk10=[TCspk10;tempp'];
                    end
                    try
                    [tempp,B]=CrossCorrKB(Range(Restrict(S{numNeurons(i)},Epoch)),Range(Restrict(tps11,Epoch)),fac1,fac2);
                    TCspk11=[TCspk11;tempp'];
                    end
                    
           end
                
                          
            try
                [Cspk1(a,:),B]=CrossCorrKB(Range(Restrict(PoolNeurons(S,numNeurons),Epoch)),Range(Restrict(tps1,Epoch)),fac1,fac2);              
            catch
            Cspk1(a,:)=zeros(1,201)*nan;   
            end
            try
                [Cspk2(a,:),B]=CrossCorrKB(Range(Restrict(PoolNeurons(S,numNeurons),Epoch)),Range(Restrict(tps2,Epoch)),fac1,fac2);
            catch
            Cspk2(a,:)=zeros(1,201)*nan;   
            end
            try
                [Cspk3(a,:),B]=CrossCorrKB(Range(Restrict(PoolNeurons(S,numNeurons),Epoch)),Range(Restrict(tps3,Epoch)),fac1,fac2);
            catch
            Cspk3(a,:)=zeros(1,201)*nan;   
            end
            try
                [Cspk4(a,:),B]=CrossCorrKB(Range(Restrict(PoolNeurons(S,numNeurons),Epoch)),Range(Restrict(tps4,Epoch)),fac1,fac2);
            catch
            Cspk4(a,:)=zeros(1,201)*nan;   
            end
            try
                [Cspk5(a,:),B]=CrossCorrKB(Range(Restrict(PoolNeurons(S,numNeurons),Epoch)),Range(Restrict(tps5,Epoch)),fac1,fac2);
            catch
            Cspk5(a,:)=zeros(1,201)*nan;   
            end
            try
                [Cspk6(a,:),B]=CrossCorrKB(Range(Restrict(PoolNeurons(S,numNeurons),Epoch)),Range(Restrict(tps6,Epoch)),fac1,fac2);
            catch
            Cspk6(a,:)=zeros(1,201)*nan;   
            end
            try
                [Cspk7(a,:),B]=CrossCorrKB(Range(Restrict(PoolNeurons(S,numNeurons),Epoch)),Range(Restrict(tps7,Epoch)),fac1,fac2);
            catch
            Cspk7(a,:)=zeros(1,201)*nan;   
            end
            try
                [Cspk8(a,:),B]=CrossCorrKB(Range(Restrict(PoolNeurons(S,numNeurons),Epoch)),Range(Restrict(tps8,Epoch)),fac1,fac2);
            catch
            Cspk8(a,:)=zeros(1,201)*nan;   
            end
            try
                [Cspk9(a,:),B]=CrossCorrKB(Range(Restrict(PoolNeurons(S,numNeurons),Epoch)),Range(Restrict(tps9,Epoch)),fac1,fac2);
            catch
            Cspk9(a,:)=zeros(1,201)*nan;   
            end
            try
                [Cspk10(a,:),B]=CrossCorrKB(Range(Restrict(PoolNeurons(S,numNeurons),Epoch)),Range(Restrict(tps10,Epoch)),fac1,fac2);
            catch
            Cspk10(a,:)=zeros(1,201)*nan;   
            end
            try
                [Cspk11(a,:),B]=CrossCorrKB(Range(Restrict(PoolNeurons(S,numNeurons),Epoch)),Range(Restrict(tps11,Epoch)),fac1,fac2); 
            catch
            Cspk11(a,:)=zeros(1,201)*nan;   
            end       

    end

end
         
         
        nameSession{a}=Dir.path{man};
        a=a+1;
       
         end    % try
        
        
end
      
a=1;
figure('color',[1 1 1])
for i=1:25
    if a==10
        a=a+3;
    end
    eval(['subplot(7,4,',num2str(a),'), hold on, imagesc(B/1E3,1:size(C',num2str(i),',1),C',num2str(i),')'])
    eval(['plot(B/1E3,rescale(nanmean(C',num2str(i),'),10,20),''w'',''linewidth'',2)'])
    xlim([B(1) B(end)]/1E3)
    a=a+1;
end


% C13r=resample(C13',3,1)';
% C17r=resample(C17',3,1)';
% C21r=resample(C21',3,1)';

% 
% xl=[-0.4 0.4];
% smo=10;
% figure('color',[1 1 1]), 
% subplot(2,2,1), hold on
% plot(B/1E3,smooth(mean(C13),smo),'k','linewidth',2)
% plot(B/1E3,smooth(mean(C17),smo),'r','linewidth',2)
% plot(B/1E3,smooth(mean(C21),smo),'b')
% plot(B/1E3,smooth(mean(C25),smo),'g')
% xlim(xl)
% 
% subplot(2,2,2), hold on
% plot(B/1E3,smooth(mean(C12),smo),'k','linewidth',2)
% plot(B/1E3,smooth(mean(C16),smo),'r','linewidth',2)
% plot(B/1E3,smooth(mean(C20),smo),'b')
% plot(B/1E3,smooth(mean(C24),smo),'g')
% xlim(xl)
% 
% subplot(2,2,3), hold on
% plot(B/1E3,smooth(mean(C11),smo),'k','linewidth',2)
% plot(B/1E3,smooth(mean(C15),smo),'r','linewidth',2)
% plot(B/1E3,smooth(mean(C19),smo),'b')
% plot(B/1E3,smooth(mean(C23),smo),'g')
% xlim(xl)
% 
% subplot(2,2,4), hold on
% plot(B/1E3,smooth(mean(C10),smo),'k','linewidth',2)
% plot(B/1E3,smooth(mean(C14),smo),'r','linewidth',2)
% plot(B/1E3,smooth(mean(C18),smo),'b')
% plot(B/1E3,smooth(mean(C22),smo),'g')
% xlim(xl)
if spike
CspkT{1}=Cspk1;
CspkT{2}=Cspk2;
CspkT{3}=Cspk3;
CspkT{4}=Cspk4;
CspkT{5}=Cspk5;
CspkT{6}=Cspk6;
CspkT{7}=Cspk7;
CspkT{8}=Cspk8;
CspkT{9}=Cspk9;
CspkT{10}=Cspk10;
CspkT{11}=Cspk11;
else
CspkT{1}=[];
CspkT{2}=[];
CspkT{3}=[];
CspkT{4}=[];
CspkT{5}=[];
CspkT{6}=[];
CspkT{7}=[];
CspkT{8}=[];
CspkT{9}=[];
CspkT{10}=[];
CspkT{11}=[];
end



Ctotal{1}=C13;
Ctotal{2}=C17;
Ctotal{3}=C21;
Ctotal{4}=C25;
Ctotal{5}=C12;
Ctotal{6}=C16;
Ctotal{7}=C20;
Ctotal{8}=C24;
Ctotal{9}=C11;
Ctotal{10}=C15;
Ctotal{11}=C19;
Ctotal{12}=C23;
Ctotal{13}=C10;
Ctotal{14}=C14;
Ctotal{15}=C18;
Ctotal{16}=C22;

CTot2{1}=C1;
CTot2{2}=C2;
CTot2{3}=C3;
CTot2{4}=C4;
CTot2{5}=C5;
CTot2{6}=C6;
CTot2{7}=C7;
CTot2{8}=C8;
CTot2{9}=C9;

TCspkt{1}=TCspk1;
TCspkt{2}=TCspk2;
TCspkt{3}=TCspk3;
TCspkt{4}=TCspk4;
TCspkt{5}=TCspk5;
TCspkt{6}=TCspk6;
TCspkt{7}=TCspk7;
TCspkt{8}=TCspk8;
TCspkt{9}=TCspk9;
TCspkt{10}=TCspk10;
TCspkt{11}=TCspk11;

if 1

xl=[-0.4 0.4];

figure('color',[1 1 1]), 
subplot(2,2,1), hold on
plot(B/1E3,smooth(nanmean(Ctotal{1}),smo),'k','linewidth',2)
plot(B/1E3,smooth(nanmean(Ctotal{2}),smo),'r','linewidth',2)
%plot(B/1E3,smooth(mean(Ctotal{3}),smo),'b')
%plot(B/1E3,smooth(mean(Ctotal{4}),smo),'g')
title('Slow Spindles Deep')
xlim(xl)

subplot(2,2,2), hold on
plot(B/1E3,smooth(nanmean(Ctotal{5}),smo),'k','linewidth',2)
plot(B/1E3,smooth(nanmean(Ctotal{6}),smo),'r','linewidth',2)
%plot(B/1E3,smooth(mean(Ctotal{7}),smo),'b')
%plot(B/1E3,smooth(mean(Ctotal{8}),smo),'g')
title('Slow Spindles Sup')
xlim(xl)

subplot(2,2,3), hold on
plot(B/1E3,smooth(nanmean(Ctotal{9}),smo),'k','linewidth',2)
plot(B/1E3,smooth(nanmean(Ctotal{10}),smo),'r','linewidth',2)
%plot(B/1E3,smooth(mean(Ctotal{11}),smo),'b')
%plot(B/1E3,smooth(mean(Ctotal{12}),smo),'g')
title('Fast Spindles Deep')
xlim(xl)

subplot(2,2,4), hold on
plot(B/1E3,smooth(nanmean(Ctotal{13}),smo),'k','linewidth',2)
plot(B/1E3,smooth(nanmean(Ctotal{14}),smo),'r','linewidth',2)
%plot(B/1E3,smooth(mean(Ctotal{15}),smo),'b')
%plot(B/1E3,smooth(mean(Ctotal{16}),smo),'g')
title('Fast Spindles Sup')
xlim(xl)

xl=[-1 1];

figure('color',[1 1 1]), 
subplot(2,2,1), hold on
plot(B/1E3,smooth(nanmean(Ctotal{1}),smo),'k','linewidth',1)
plot(B/1E3,smooth(nanmean(Ctotal{2}),smo),'r','linewidth',1)
%plot(B/1E3,smooth(mean(Ctotal{3}),smo),'b')
%plot(B/1E3,smooth(mean(Ctotal{4}),smo),'g')
title('Slow Spindles Deep')
xlim(xl)

subplot(2,2,2), hold on
plot(B/1E3,smooth(nanmean(Ctotal{5}),smo),'k','linewidth',1)
plot(B/1E3,smooth(nanmean(Ctotal{6}),smo),'r','linewidth',1)
%plot(B/1E3,smooth(mean(Ctotal{7}),smo),'b')
%plot(B/1E3,smooth(mean(Ctotal{8}),smo),'g')
title('Slow Spindles Sup')
xlim(xl)

subplot(2,2,3), hold on
plot(B/1E3,smooth(nanmean(Ctotal{9}),smo),'k','linewidth',1)
plot(B/1E3,smooth(nanmean(Ctotal{10}),smo),'r','linewidth',1)
%plot(B/1E3,smooth(mean(Ctotal{11}),smo),'b')
%plot(B/1E3,smooth(mean(Ctotal{12}),smo),'g')
title('Fast Spindles Deep')
xlim(xl)

subplot(2,2,4), hold on
plot(B/1E3,smooth(nanmean(Ctotal{13}),smo),'k','linewidth',1)
plot(B/1E3,smooth(nanmean(Ctotal{14}),smo),'r','linewidth',1)
%plot(B/1E3,smooth(mean(Ctotal{15}),smo),'b')
%plot(B/1E3,smooth(mean(Ctotal{16}),smo),'g')
title('Fast Spindles Sup')
xlim(xl)



% 
% 
% figure('color',[1 1 1]),
% subplot(2,2,1), imagesc(B/1E3,1:size(Ctotal{9},1), Ctotal{9})
% subplot(2,2,3), imagesc(B/1E3,1:size(Ctotal{10},1), Ctotal{10})
% subplot(2,2,2), hold on
% plot(B/1E3,smooth(mean(Ctotal{9}),smo),'k','linewidth',2)
% plot(B/1E3,smooth(mean(Ctotal{10}),smo),'r','linewidth',2)

% smooth(mean(Ctotal{9}),smo)
fil1=tsd((B-B(1))/1E3*1E4,nanmean(Ctotal{9})'-nanmean(nanmean(Ctotal{9})));
Fil1=FilterLFP(fil1,[10 15],256);
fil2=tsd((B-B(1))/1E3*1E4,nanmean(Ctotal{10})'-nanmean(nanmean(Ctotal{10})));
Fil2=FilterLFP(fil2,[10 15],256);

figure('color',[1 1 1]),
subplot(2,2,1), hold on
plot(B/1E3,smooth(nanmean(Ctotal{9}),smo),'k','linewidth',1)
plot(B/1E3,Data(Fil1),'k','linewidth',2)
line([0 0],ylim,'color',[0.8 0.8 0.8])
subplot(2,2,2), hold on
plot(B/1E3,smooth(nanmean(Ctotal{9}),smo),'k','linewidth',1)
plot(B/1E3,smooth(nanmean(Ctotal{10}),smo),'r','linewidth',1)
line([0 0],ylim,'color',[0.8 0.8 0.8])
subplot(2,2,3), hold on
plot(B/1E3,smooth(nanmean(Ctotal{10}),smo),'r','linewidth',1)
plot(B/1E3,Data(Fil2),'r','linewidth',2)
line([0 0],ylim,'color',[0.8 0.8 0.8])
subplot(2,2,4), hold on
plot(B/1E3,Data(Fil2),'r','linewidth',1)
plot(B/1E3,Data(Fil1),'k','linewidth',1)
line([0 0],ylim,'color',[0.8 0.8 0.8])


figure('color',[1 1 1]), hold on
subplot(2,1,1), hold on 
plot(B/1E3,smooth(nanmean(Ctotal{4}),smo),'k')
plot(B/1E3,smooth(nanmean(Ctotal{8}),smo),'r')
title('All ripples - k:Sd, r:Ss, b:Fd, m:Fs')
subplot(2,1,2), hold on 
plot(B/1E3,smooth(nanmean(Ctotal{12}),smo),'b')
plot(B/1E3,smooth(nanmean(Ctotal{16}),smo),'m')


figure('color',[1 1 1]), hold on
for i=1:4
plot(B/1E3,smooth(nanmean(CTot2{i}),smo),'color',[i/4 0 0])
end
plot(B/1E3,smooth(nanmean(CTot2{6}),smo),'b','linewidth',2)
line([0 0],ylim,'color',[0.7 0.7 0.7])

end



namv{1}='rip pre';
namv{2}='rip post';
namv{3}='rip out';
namv{4}='rip';
namv{5}='Delta';
namv{6}='SpiFs';
namv{7}='SpiFd';
namv{8}='SpiSs';
namv{9}='SpiSd';
namv{10}='rip Spi';
namv{11}='rip out Spi';

PlotErrorBar(Nb)
set(gca,'xtick',[1:11])
set(gca,'xticklabel',namv)
set(gca,'yscale','log')


namvar{1}='SpiFs';
namvar{2}='SpiFd';
namvar{3}='SpiSs';
namvar{4}='SpiSd';
namvar{5}='Delta';
namvar{6}='rip';
namvar{7}='rip Pre D';
namvar{8}='rip Post D';
namvar{9}='rip out D';
namvar{10}='rip Spi';
namvar{11}='rip out Spi';


      
le=size(CspkT{1},1);
    

figure('color',[1 1 1])
for i=1:11
    try
    subplot(3,4,i), imagesc(B/1E3,1:le,CspkT{i}(1:le,:)), title(namvar{i})
    end
end

figure('color',[1 1 1])
for i=1:11
    try
    subplot(3,4,i), plot(B/1E3,nanmean(CspkT{i}(1:le,:)),'k'), title(namvar{i})
    line([0 0],ylim,'color',[0.8 0.8 0.8])
    end
end


figure('color',[1 1 1]), 
for i=1:11
    testi=CspkT{i}(1:le,:);
    testO=nanzscore(CspkT{i}(1:le,:)')';
    if i<5
        val=testO(:,100)-testO(:,105);
        r=corrcoef(nanmean(testO),nanmean((sign(val)*ones(1,size(testO,2))).*testO));
        if r(2,1)<0
           testf=-(sign(val)*ones(1,size(testO,2))).*testO;
           testfi=-(sign(val)*ones(1,size(testi,2))).*testi;
           CspkTc{i}=testf;
           CspkTcb{i}=testfi;
        else
            testf=(sign(val)*ones(1,size(testO,2))).*testO;
            testfi=(sign(val)*ones(1,size(testi,2))).*testi;
            CspkTc{i}=testf;
            CspkTcb{i}=testfi;
        end
    else
%         testf=zscore(CspkT{i}(1:le,:)')';
        CspkTc{i}=testO;
        CspkTcb{i}=testi;
    end

    subplot(3,4,i), 
    plot(B/1E3,nanmean(testf),'k'), title(namvar{i})
    line([0 0],ylim,'color',[0.8 0.8 0.8])
end
