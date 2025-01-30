%TempEvolutionSlowBulb


% EvolSlowBulbWT{a,1}=Dir.path{man};
% EvolSlowBulbWT{a,2}=Slow;
% EvolSlowBulbWT{a,3}=SWSEpoch;
% EvolSlowBulbWT{a,4}=Wake;
% EvolSlowBulbWT{a,5}=Data(Restrict(Slow,SWSEpoch));
% EvolSlowBulbWT{a,6}=Data(Restrict(Slow,Wake));
% EvolSlowBulbWT{a,7}=Data(Restrict(USlow,SWSEpoch));
% EvolSlowBulbWT{a,8}=Data(Restrict(USlow,Wake));
% EvolSlowBulbWT{a,9}=id;
% EvolSlowBulbWT{a,10}=Data(Restrict(Movtsd,Restrict(Slow,Wake)));  
% try
% EvolSlowBulbWT{a,11}=TimeDebRec(1,1)+TimeDebRec(1,2)/60; 
% EvolSlowBulbWT{a,12}=TimeDebRec(1,1)+TimeDebRec(1,2)/60+st(1)/3600; 
% end
% 
% SlowBulbWT(a,1)=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
% SlowBulbWT(a,2)=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));
% SlowBulbWT(a,3)=sum(End(Wake,'s')-Start(Wake,'s'));  
% SlowBulbWT(a,4)=st;  
% SlowBulbWT(a,5)=str;  
% SlowBulbWT(a,6)=TimeDebRec(1,1)+TimeDebRec(1,2)/60;


%------------------------------------------------------------------------------------    
%------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------




freqSlow=[2 4];
freqUSlow=[0.5 1];
clearBadData=0;fac=1;

close all
%NameDir={'BASAL', 'DPCPX', 'LPS', 'CANAB'};
%NameDir={'BASAL', 'PLETHYSMO','DPCPX', 'LPS', 'CANAB'};
NameDir={'BASAL', 'DPCPX', 'CANAB'};
%NameDir={'PLETHYSMO'};



%------------------------------------------------------------------------------------    
%------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------

tic

  a=1;
  b=1;
  c=1;
  d=1;
  
    for i=1:length(NameDir)
        Dir=PathForExperimentsML(NameDir{i});
        
        for man=1:length(Dir.path)
            
              try
                
            disp('  ')
            disp(Dir.path{man})
            disp(Dir.group{man})
            disp(' ')
            cd(Dir.path{man})
            
            clear SWSEpoch
            clear Wake
            clear REMEpoch
            
            if 1
                try
                load StateEpochSB SWSEpoch Wake REMEpoch
                SWSEpoch;    
                catch
                    BulbSleepScriptKB
                    close all
                    load StateEpochSB SWSEpoch Wake REMEpoch
                end

            end

            clear TimeEndRec
            
            load behavResources Movtsd PreEpoch TimeEndRec tpsdeb tpsfin
            TimeEndRec;
            
            try
                SWSEpoch=and(SWSEpoch,PreEpoch);
                Wake=and(Wake,PreEpoch);
                REMEpoch=and(REMEpoch,PreEpoch);
            end
            
            clear chBulb
            clear Slow
            clear st
            clear idt
            clear idw
            clear Sp
            clear f
            clear t
            
            res=pwd;
            tempchBulb=load([res,'/ChannelsToAnalyse/Bulb_deep.mat'],'channel');
            chBulb=tempchBulb.channel;
            
            eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chBulb),'.mat'');'])
            
%             Slow=tsd(t*1E4,Dir.CorrecAmpli(man)*mean(Sp(:,find(f>freqSlow(1)&f<freqSlow(2))),2));
%             USlow=tsd(t*1E4,Dir.CorrecAmpli(man)*mean(Sp(:,find(f>freqUSlow(1)&f<freqUSlow(2))),2));
            
            Slow=tsd(t*1E4,mean(Sp(:,find(f>freqSlow(1)&f<freqSlow(2))),2));
            USlow=tsd(t*1E4,mean(Sp(:,find(f>freqUSlow(1)&f<freqUSlow(2))),2));
            
            
            st=Start(SWSEpoch,'s');
            str=Start(REMEpoch,'s');
            idt=find(t>st(1));
            
            tw=Range(Restrict(Slow,Wake),'s');          
            idw=find(tw>st(1));  
            
            id(1)=idt(1);
            id(2)=idw(1);
            
            durRec1=(tpsfin{1}-tpsdeb{1})/3600;
            en=End(SWSEpoch,'s');  
            
             if Dir.group{man}(1)=='W'
                 
                 EvolSlowBulbWT{a,1}=Dir.path{man};
                 
                 EvolSlowBulbWT{a,2}=Slow;
                 EvolSlowBulbWT{a,3}=SWSEpoch;
                 EvolSlowBulbWT{a,4}=Wake;
                 EvolSlowBulbWT{a,5}=Data(Restrict(Slow,SWSEpoch));
                 EvolSlowBulbWT{a,6}=Data(Restrict(Slow,Wake));
                 EvolSlowBulbWT{a,7}=Data(Restrict(USlow,SWSEpoch));
                 EvolSlowBulbWT{a,8}=Data(Restrict(USlow,Wake));
                 EvolSlowBulbWT{a,9}=id;
                 EvolSlowBulbWT{a,10}=Data(Restrict(Movtsd,Restrict(Slow,Wake)));  
                 try
                 EvolSlowBulbWT{a,11}=TimeEndRec(1,1)+TimeEndRec(1,2)/60-durRec1; 
                 EvolSlowBulbWT{a,12}=TimeEndRec(1,1)+TimeEndRec(1,2)/60+st(1)/3600-durRec1; 
                 end
                 EvolSlowBulbWT{a,13}=Dir.name{man};
                 
                 SlowBulbWT(a,1)=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
                 SlowBulbWT(a,2)=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));
                 SlowBulbWT(a,3)=sum(End(Wake,'s')-Start(Wake,'s'));  
                 SlowBulbWT(a,4)=st(1);  
                 SlowBulbWT(a,5)=str(1);  
                 SlowBulbWT(a,6)=TimeEndRec(1,1)+TimeEndRec(1,2)/60-durRec1;                  
                 SlowBulbWT(a,7)=TimeEndRec(1,1)+TimeEndRec(1,2)/60-durRec1+en(end)/3600;  
                                  clear EpochR
                 clear EpochS
                 clear Epoch
                 clear EpochR
                [EpochR,val,val2]=FindSlowOscBulb(Sp,t,f,REMEpoch,0,[10 12]);
                [EpochS,val,val2]=FindSlowOscBulb(Sp,t,f,SWSEpoch,0,[10 12]);
                [Epoch,val,val2]=FindSlowOscBulb(Sp,t,f,Wake,0,[10 12]);
                 nbO=1;
                 SloOwt(c,1)=sum(End(EpochR{nbO},'s')-Start(EpochR{nbO},'s'))/sum(End(REMEpoch,'s')-Start(REMEpoch,'s'))*100;
                 SloOwt(c,2)=sum(End(EpochS{nbO},'s')-Start(EpochS{nbO},'s'))/sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'))*100;
                 SloOwt(c,3)=sum(End(Epoch{nbO},'s')-Start(Epoch{nbO},'s'))/sum(End(Wake,'s')-Start(Wake,'s'))*100;
                 
                 SloOwt(c,4)=nanmean(Data(Restrict(Slow,EpochR{nbO})));  
                 SloOwt(c,5)=nanmean(Data(Restrict(Slow,EpochS{nbO}))); 
                 SloOwt(c,6)=nanmean(Data(Restrict(Slow,Epoch{nbO}))); 
                  
                 SloOwt(c,7)=nanmean(Data(Restrict(Slow,REMEpoch-EpochR{nbO})));  
                 SloOwt(c,8)=nanmean(Data(Restrict(Slow,SWSEpoch-EpochS{nbO}))); 
                 SloOwt(c,9)=nanmean(Data(Restrict(Slow,Wake-Epoch{nbO})));   
                 
                    nbO=9;
                 SloOwt(c,10)=sum(End(EpochR{nbO},'s')-Start(EpochR{nbO},'s'))/sum(End(REMEpoch,'s')-Start(REMEpoch,'s'))*100;
                 SloOwt(c,11)=sum(End(EpochS{nbO},'s')-Start(EpochS{nbO},'s'))/sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'))*100;
                 SloOwt(c,12)=sum(End(Epoch{nbO},'s')-Start(Epoch{nbO},'s'))/sum(End(Wake,'s')-Start(Wake,'s'))*100;

                 SloOwt(c,13)=nanmean(Data(Restrict(Slow,EpochR{nbO})));  
                 SloOwt(c,14)=nanmean(Data(Restrict(Slow,EpochS{nbO}))); 
                 SloOwt(c,15)=nanmean(Data(Restrict(Slow,Epoch{nbO}))); 
                 
                 SloOwt(c,16)=nanmean(Data(Restrict(Slow,REMEpoch-EpochR{nbO})));  
                 SloOwt(c,17)=nanmean(Data(Restrict(Slow,SWSEpoch-EpochS{nbO}))); 
                 SloOwt(c,18)=nanmean(Data(Restrict(Slow,Wake-Epoch{nbO})));  
                 
                 c=c+1;
                 a=a+1;
                 
                 
             else
                 
                 
                 EvolSlowBulbKO{b,1}=Dir.path{man};
                 EvolSlowBulbKO{b,2}=Slow;
                 EvolSlowBulbKO{b,3}=SWSEpoch;
                 EvolSlowBulbKO{b,4}=Wake;
                 EvolSlowBulbKO{b,5}=Data(Restrict(Slow,SWSEpoch));
                 EvolSlowBulbKO{b,6}=Data(Restrict(Slow,Wake));
                 EvolSlowBulbKO{b,7}=Data(Restrict(USlow,SWSEpoch));
                 EvolSlowBulbKO{b,8}=Data(Restrict(USlow,Wake));                 
                 EvolSlowBulbKO{b,9}=id;    
                 EvolSlowBulbKO{b,10}=Data(Restrict(Movtsd,Restrict(Slow,Wake)));      
                 try
                 EvolSlowBulbKO{b,11}=TimeEndRec(1,1)+TimeEndRec(1,2)/60-durRec1;   
                 EvolSlowBulbKO{b,12}=TimeEndRec(1,1)+TimeEndRec(1,2)/60+st(1)/3600-durRec1;   
                 end
                 EvolSlowBulbKO{b,13}=Dir.name{man};
 
                 SlowBulbKO(b,1)=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
                 SlowBulbKO(b,2)=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));
                 SlowBulbKO(b,3)=sum(End(Wake,'s')-Start(Wake,'s'));  
                 SlowBulbKO(b,4)=st(1);  
                 SlowBulbKO(b,5)=str(1);  
                 SlowBulbKO(b,6)=TimeEndRec(1,1)+TimeEndRec(1,2)/60-durRec1;  
                 SlowBulbKO(b,7)=TimeEndRec(1,1)+TimeEndRec(1,2)/60-durRec1+en(end)/3600;  
                 b=b+1;
                 
                 clear EpochR
                 clear EpochS
                 clear Epoch
                 [EpochR,val,val2]=FindSlowOscBulb(Sp,t,f,REMEpoch,0,[10 12]);
                [EpochS,val,val2]=FindSlowOscBulb(Sp,t,f,SWSEpoch,0,[10 12]);
                [Epoch,val,val2]=FindSlowOscBulb(Sp,t,f,Wake,0,[10 12]);
                 nbO=1;
                 SloOko(d,1)=sum(End(EpochR{nbO},'s')-Start(EpochR{nbO},'s'))/sum(End(REMEpoch,'s')-Start(REMEpoch,'s'))*100;
                 SloOko(d,2)=sum(End(EpochS{nbO},'s')-Start(EpochS{nbO},'s'))/sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'))*100;
                 SloOko(d,3)=sum(End(Epoch{nbO},'s')-Start(Epoch{nbO},'s'))/sum(End(Wake,'s')-Start(Wake,'s'))*100;    
                 
                 SloOko(d,4)=nanmean(Data(Restrict(Slow,EpochR{nbO})));  
                 SloOko(d,5)=nanmean(Data(Restrict(Slow,EpochS{nbO}))); 
                 SloOko(d,6)=nanmean(Data(Restrict(Slow,Epoch{nbO}))); 
 
                 SloOko(d,7)=nanmean(Data(Restrict(Slow,REMEpoch-EpochR{nbO})));  
                 SloOko(d,8)=nanmean(Data(Restrict(Slow,SWSEpoch-EpochS{nbO}))); 
                 SloOko(d,9)=nanmean(Data(Restrict(Slow,Wake-Epoch{nbO}))); 
                 
                 
                 nbO=9;
                 SloOko(d,10)=sum(End(EpochR{nbO},'s')-Start(EpochR{nbO},'s'))/sum(End(REMEpoch,'s')-Start(REMEpoch,'s'))*100;
                 SloOko(d,11)=sum(End(EpochS{nbO},'s')-Start(EpochS{nbO},'s'))/sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'))*100;
                 SloOko(d,12)=sum(End(Epoch{nbO},'s')-Start(Epoch{nbO},'s'))/sum(End(Wake,'s')-Start(Wake,'s'))*100;    
                 
                 SloOko(d,13)=nanmean(Data(Restrict(Slow,EpochR{nbO})));  
                 SloOko(d,14)=nanmean(Data(Restrict(Slow,EpochS{nbO}))); 
                 SloOko(d,15)=nanmean(Data(Restrict(Slow,Epoch{nbO}))); 

                 SloOko(d,16)=nanmean(Data(Restrict(Slow,REMEpoch-EpochR{nbO})));  
                 SloOko(d,17)=nanmean(Data(Restrict(Slow,SWSEpoch-EpochS{nbO}))); 
                 SloOko(d,18)=nanmean(Data(Restrict(Slow,Wake-Epoch{nbO}))); 
                 
                 d=d+1;
                 
             end
             
             
             
            
             end
            
            
        end
        
        
    end
    

   
toc

    
%------------------------------------------------------------------------------------    
% clearBadData ----------------------------------------------------------------------
%------------------------------------------------------------------------------------

a=size(EvolSlowBulbWT,1)+1;
b=size(EvolSlowBulbKO,1)+1;

    for i=1:a-1
        if clearBadData
        EvolSlowBulbWT{i,5}(find(EvolSlowBulbWT{i,7}>fac*EvolSlowBulbWT{i,5}))=nan;  
        EvolSlowBulbWT{i,7}(find(EvolSlowBulbWT{i,7}>fac*EvolSlowBulbWT{i,5}))=nan;    
        end
        leSWSWT(i)=length(EvolSlowBulbWT{i,5});
    end

    for i=1:b-1
        if clearBadData
        EvolSlowBulbKO{i,5}(find(EvolSlowBulbKO{i,7}>fac*EvolSlowBulbKO{i,5}))=nan; 
        EvolSlowBulbKO{i,7}(find(EvolSlowBulbKO{i,7}>fac*EvolSlowBulbKO{i,5}))=nan;     
        end  
        leSWSKO(i)=length(EvolSlowBulbKO{i,5});
    end



    for i=1:a-1
        if clearBadData
        EvolSlowBulbWT{i,6}(find(EvolSlowBulbWT{i,8}>fac*EvolSlowBulbWT{i,6}))=nan; 
        EvolSlowBulbWT{i,10}(find(EvolSlowBulbWT{i,8}>fac*EvolSlowBulbWT{i,6}))=nan;  
        EvolSlowBulbWT{i,8}(find(EvolSlowBulbWT{i,8}>fac*EvolSlowBulbWT{i,6}))=nan;     
        end
        leWakeWT(i)=length(EvolSlowBulbWT{i,6});
    end

    for i=1:b-1
        if clearBadData
        EvolSlowBulbKO{i,6}(find(EvolSlowBulbKO{i,8}>fac*EvolSlowBulbKO{i,6}))=nan;  
        EvolSlowBulbKO{i,10}(find(EvolSlowBulbKO{i,8}>fac*EvolSlowBulbKO{i,6}))=nan;
        EvolSlowBulbKO{i,8}(find(EvolSlowBulbKO{i,8}>fac*EvolSlowBulbKO{i,6}))=nan;     
        end   
        leWakeKO(i)=length(EvolSlowBulbKO{i,6});
    end


%------------------------------------------------------------------------------------    
%------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------


MSWSWT=zeros(a-1,max(leSWSWT));
MSWSKO=zeros(b-1,max(leSWSKO));
MWakeWT=zeros(a-1,max(leWakeWT));
MWakeKO=zeros(b-1,max(leWakeKO));

MSWSWT(MSWSWT==0)=nan;
MSWSKO(MSWSKO==0)=nan;
MWakeWT(MWakeWT==0)=nan;
MWakeKO(MWakeKO==0)=nan;

for i=1:a-1
  
  temp=EvolSlowBulbWT{i,5};
  MSWSWT(i,1:length(temp))=temp;
  
  temp=EvolSlowBulbWT{i,6};
  MWakeWT(i,1:length(temp))=temp;
  
end

for i=1:b-1
  
  temp=EvolSlowBulbKO{i,5};
  MSWSKO(i,1:length(temp))=temp;
  
  temp=EvolSlowBulbKO{i,6};
  MWakeKO(i,1:length(temp))=temp;
  
end
% 
% MSWSWT(MSWSWT==0)=nan;
% MSWSKO(MSWSKO==0)=nan;
% MWakeWT(MWakeWT==0)=nan;
% MWakeKO(MWakeKO==0)=nan;
% 


%------------------------------------------------------------------------------------    
%------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------

smo=5;
pas=50;

if 0

    figure('color',[1 1 1]), 
    subplot(2,1,1), hold on
    plot(nanmean(MSWSWT),'k')
    plot(nanmean(MSWSKO),'r')
    ylabel('SWS')
    xlim([0 4E4])

    subplot(2,1,2), hold on
    plot(nanmean(MWakeWT),'k')
    plot(nanmean(MWakeKO),'r')
    ylabel('Wake')
    xlim([0 4E4])

    figure('color',[1 1 1]),
    subplot(2,2,1),imagesc(MSWSWT),caxis([0 9E5])
    subplot(2,2,2), imagesc(MSWSKO),caxis([0 9E5])
    subplot(2,2,3), imagesc(MWakeWT),caxis([0 9E5])
    subplot(2,2,4), imagesc(MWakeKO),caxis([0 9E5])



    figure('color',[1 1 1]), 
    subplot(2,1,1), hold on
    plot(smooth(nanmean(MSWSWT(:,1:pas:end)),smo),'k','linewidth',2)
    plot(smooth(nanmean(MSWSWT(:,1:pas:end))+nanstd(MSWSWT(:,1:pas:end))/sqrt(a-1),smo),'k','linewidth',1)
    plot(smooth(nanmean(MSWSWT(:,1:pas:end))-nanstd(MSWSWT(:,1:pas:end))/sqrt(a-1),smo),'k','linewidth',1)
    plot(smooth(nanmean(MSWSKO(:,1:pas:end)),smo),'r','linewidth',2)
    plot(smooth(nanmean(MSWSKO(:,1:pas:end))+nanstd(MSWSKO(:,1:pas:end))/sqrt(b-1),smo),'r','linewidth',1)
    plot(smooth(nanmean(MSWSKO(:,1:pas:end))-nanstd(MSWSKO(:,1:pas:end))/sqrt(b-1),smo),'r','linewidth',1)
    ylabel('SWS')
    xlim([0 4E4/pas])

    subplot(2,1,2), hold on
    plot(smooth(nanmean(MWakeWT(:,1:pas:end)),smo),'k','linewidth',2)
    plot(smooth(nanmean(MWakeWT(:,1:pas:end))+nanstd(MWakeWT(:,1:pas:end))/sqrt(a-1),smo),'k','linewidth',1)
    plot(smooth(nanmean(MWakeWT(:,1:pas:end))-nanstd(MWakeWT(:,1:pas:end))/sqrt(a-1),smo),'k','linewidth',1)
    plot(smooth(nanmean(MWakeKO(:,1:pas:end)),smo),'r','linewidth',2)
    plot(smooth(nanmean(MWakeKO(:,1:pas:end))+nanstd(MWakeKO(:,1:pas:end))/sqrt(b-1),smo),'r','linewidth',1)
    plot(smooth(nanmean(MWakeKO(:,1:pas:end))-nanstd(MWakeKO(:,1:pas:end))/sqrt(b-1),smo),'r','linewidth',1)
    ylabel('Wake')
    xlim([0 4E4/pas])



    %------------------------------------------------------------------------------------



    figure('color',[1 1 1])

    subplot(2,2,1), hold on
    for i=1:a-1
    plot(EvolSlowBulbWT{i,5},'k')
    end
    yl1=ylim;
    ylabel('SWS')

    subplot(2,2,2), hold on
    for i=1:b-1
    plot(EvolSlowBulbKO{i,5},'r')
    end
    yl2=ylim;

    subplot(2,2,1),ylim([0 max(yl1(2),yl2(2))])
    subplot(2,2,2),ylim([0 max(yl1(2),yl2(2))])


    subplot(2,2,3), hold on
    for i=1:a-1
    plot(EvolSlowBulbWT{i,6},'k')
    end
    ylabel('Wake')
    yl1=ylim;

    subplot(2,2,4), hold on
    for i=1:b-1
    plot(EvolSlowBulbKO{i,6},'r')
    end
    yl2=ylim;

    subplot(2,2,3),ylim([0 max(yl1(2),yl2(2))])
    subplot(2,2,4),ylim([0 max(yl1(2),yl2(2))])





    %------------------------------------------------------------------------------------



    CorrSlowMovWT=[];
    CorrSlowMovKO=[];
    figure('color',[1 1 1])
    subplot(2,1,1),hold on
    for i=1:a-1
     plot(EvolSlowBulbWT{i,10},EvolSlowBulbWT{i,6},'k.')  
     CorrSlowMovWT=[CorrSlowMovWT;[EvolSlowBulbWT{i,10},EvolSlowBulbWT{i,6}]];
    end
    xl1=xlim;
    yl1=ylim;

    subplot(2,1,2),hold on
    for i=1:b-1
     plot(EvolSlowBulbKO{i,10},EvolSlowBulbKO{i,6},'r.')  
     CorrSlowMovKO=[CorrSlowMovKO;[EvolSlowBulbKO{i,10},EvolSlowBulbKO{i,6}]];
    end
    xl2=xlim;
    yl2=ylim;


    subplot(2,1,1)
    xlim([0 max(xl1(2),xl2(2))])
    ylim([0 max(yl1(2),yl2(2))])
    subplot(2,1,2)
    xlim([0 max(xl1(2),xl2(2))])
    ylim([0 max(yl1(2),yl2(2))])


    idWT=find(CorrSlowMovWT(:,1)<0.5);
    idKO=find(CorrSlowMovKO(:,1)<0.5);

     [rWT,pWT,varWT,accumulatedWT,MAPWT]=PlotCorrelationDensity(CorrSlowMovWT(idWT,1),CorrSlowMovWT(idWT,2),3E5,0,50);
     [rKO,pKO,varKO,accumulatedKO,MAPKO]=PlotCorrelationDensity(CorrSlowMovKO(idKO,1),CorrSlowMovKO(idKO,2),3E5,0,50);


    % idWT=find(CorrSlowMovWT(:,1).*CorrSlowMovWT(:,2)>0);
    % idKO=find(CorrSlowMovKO(:,1).*CorrSlowMovKO(:,2)>0);
    %[rWT,pWT,varWT,accumulatedWT,MAPWT]=PlotCorrelationDensity(CorrSlowMovWT(idWT,1),CorrSlowMovWT(idWT,2),1E7,'log',100);
    %[rKO,pKO,varKO,accumulatedKO,MAPKO]=PlotCorrelationDensity(CorrSlowMovKO(idKO,1),CorrSlowMovKO(idKO,2),1E7,'log',100);

end


%------------------------------------------------------------------------------------

        idWT51=[];
        idWT60=[];
        idWT61=[];
        idWT82=[];
        idWT83=[];
        idWT147=[];
        idWT148=[];
        idWT160=[];
        idWT161=[];
        idWT162=[];
%         idWT159=[];

disp(' ')
disp('WT')
for i=1:length(EvolSlowBulbWT)
    disp([num2str(i),'  ',EvolSlowBulbWT{i,1}])
    clear num
    num=str2num(EvolSlowBulbWT{i,13}(6:8));
    switch num
        case 51
            idWT51=[idWT51,i];
        case 60
            idWT60=[idWT60,i];
        case 61
            idWT61=[idWT61,i];
        case 82
            idWT82=[idWT82,i];
        case 83
            idWT83=[idWT83,i];
        case 147
            idWT147=[idWT147,i];
        case 148
            idWT148=[idWT148,i];
        case 160
            idWT160=[idWT160,i];
        case 161
            idWT161=[idWT161,i];
        case 162
            idWT162=[idWT162,i];
%        case 159
%            idWT159=[idWT159,i];

    end
    
end


        idKO47=[];
        idKO52=[];
        idKO54=[];
        idKO65=[];
        idKO66=[];
        idKO146=[];
        idKO149=[];
        idKO158=[];
%         idKO159=[];
        idKO164=[];
        
disp(' ')
disp('KO')
for i=1:length(EvolSlowBulbKO)
    disp([num2str(i),'  ',EvolSlowBulbKO{i,1}])
        clear num
    num=str2num(EvolSlowBulbKO{i,13}(6:8));
    switch num


        case 47
            idKO47=[idKO47,i];
        case 52
            idKO52=[idKO52,i];
        case 54
            idKO54=[idKO54,i];
        case 65
            idKO65=[idKO65,i];
        case 66
            idKO66=[idKO66,i];
        case 146
            idKO146=[idKO146,i];
        case 149
            idKO149=[idKO149,i];
        case 158
            idKO158=[idKO158,i];
%         case 159
%             idKO159=[idKO159,i];
        case 164
            idKO164=[idKO164,i];


    end
end

% 1  /media/DataMOBsRAID/ProjetAstro/Mouse047/20121108/BULB-Mouse-47-08112012
% 2  /media/DataMOBsRAID/ProjetAstro/Mouse052/20121113/BULB-Mouse-52-13112012
% 3  /media/DataMOBsRAID/ProjetAstro/Mouse052/20121114/BULB-Mouse-52-14112012
% 4  /media/DataMOBsRAID/ProjetAstro/Mouse054/20130305/BULB-Mouse-54-05032013
% 5  /media/DataMOBsRAID/ProjetAstro/Mouse054/20130306/BULB-Mouse-54-06032013
% 6  /media/DataMOBsRAID/ProjetAstro/Mouse054/20130308/BULB-Mouse-54-08032013
% 7  /media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse065/20130513/BULB-Mouse-65-13052013
% 8  /media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse065/20130515/BULB-Mouse-65-15052013
% 9  /media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse066/20130513/BULB-Mouse-66-13052013
% 10  /media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse066/20130515/BULB-Mouse-66-15052013
% 11  /media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse146/20140804/BULB-Mouse-146-04082014
% 12  /media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse146/20140828/BULB-Mouse-146-28082014
% 13  /media/DataMOBsRAID/ProjetAstro/Mouse149/20140804/BULB-Mouse-149-04082014
% 14  /media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse149/20140828/BULB-Mouse-149-28082014
% 15  /media/DataMOBsRAID/ProjetAstro/Mouse158/20141209/BULB-Mouse-158-09122014
% 16  /media/DataMOBsRAID/ProjetAstro/Mouse158/20141211/BULB-Mouse-158-11122014
% 17  /media/DataMOBsRAID/ProjetAstro/Mouse158/20141217/BULB-Mouse-158-17122014
% 18  /media/DataMOBsRAID/ProjetAstro/Mouse159/20141215/BULB-Mouse-159-15122014
% 19  /media/DataMOBsRAID/ProjetAstro/Mouse159/20141216/BULB-Mouse-159-16122014
% 20  /media/DataMOBsRAID/ProjetAstro/Mouse159/20141218/BULB-Mouse-159-18122014
% 21  /media/DataMOBsRAID/ProjetAstro/Mouse164/20141219/BULB-Mouse-164-19122014
% 22  /media/DataMOBsRAID/ProjetAstro/Mouse164/20141222/BULB-Mouse-164-22122014
% 
% 1  /media/DataMOBs/ProjetDPCPX/Mouse051/20130313/BULB-Mouse-51-13032013
% 2  /media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse060/20130422/BULB-Mouse-60-22042013
% 3  /media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse060/20130415/BULB-Mouse-60-15042013
% 4  /media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse060/20130416/BULB-Mouse-60-16042013
% 5  /media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse061/20130422/BULB-Mouse-61-22042013
% 6  /media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse061/20130415/BULB-Mouse-61-15042013
% 7  /media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse061/20130416/BULB-Mouse-61-16042013
% 8  /media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse082/20130729/BULB-Mouse-82-29072013
% 9  /media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse082/20130730/BULB-Mouse-82-30072013
% 10  /media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse083/20130723/BULB-Mouse-83-23072013
% 11  /media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse083/20130729/BULB-Mouse-83-29072013
% 12  /media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse083/20130730/BULB-Mouse-83-30072013
% 13  /media/DataMOBsRAID/ProjetAstro/Mouse148/20140828/BULB-Mouse-148-28082014
% 14  /media/DataMOBsRAID/ProjetAstro/Mouse160/20141219/BULB-Mouse-160-19122014
% 15  /media/DataMOBsRAID/ProjetAstro/Mouse160/20141222/BULB-Mouse-160-22122014
% 16  /media/DataMOBsRAID/ProjetAstro/Mouse160/20141223/BULB-Mouse-160-23122014
% 17  /media/DataMOBsRAID/ProjetAstro/Mouse161/20141209/BULB-Mouse-161-09122014
% 18  /media/DataMOBsRAID/ProjetAstro/Mouse161/20141211/BULB-Mouse-161-11122014
% 19  /media/DataMOBsRAID/ProjetAstro/Mouse161/20141217/BULB-Mouse-161-17122014
% 20  /media/DataMOBsRAID/ProjetAstro/Mouse162/20141215/BULB-Mouse-162-15122014
% 21  /media/DataMOBsRAID/ProjetAstro/Mouse162/20141216/BULB-Mouse-162-16122014
% 22  /media/DataMOBsRAID/ProjetAstro/Mouse162/20141218/BULB-Mouse-162-18122014

% idWT51=[1];
% idWT60=[2 3 4];
% idWT61=[5 6 7];
% idWT82=[8 9];
% idWT83=[10 11 12];
% idWT147=[13];
% idWT148=[14];
% idWT160=[15 16 17];
% idWT161=[18 19 20];
% idWT162=[21 22 23];
% 
% idKO47=[1];
% idKO52=[2 3];
% idKO54=[4 5 6];
% idKO65=[7 8];
% idKO66=[9 10];
% idKO146=[11 12];
% idKO149=[13 14];
% idKO158=[15 16 17];
% idKO159=[18 19 20];
% idKO164=[21 22];

%------------------------------------------------------------------------------------

% mMSWSWT=([MeanWithoutSingleRow(MSWSWT(idWT51,:))',MeanWithoutSingleRow(MSWSWT(idWT60,:))', MeanWithoutSingleRow(MSWSWT(idWT61,:))', MeanWithoutSingleRow(MSWSWT(idWT82,:))', MeanWithoutSingleRow(MSWSWT(idWT83,:))', MeanWithoutSingleRow(MSWSWT(idWT147,:))', MeanWithoutSingleRow(MSWSWT(idWT148,:))', MeanWithoutSingleRow(MSWSWT(idWT160,:))', MeanWithoutSingleRow(MSWSWT(idWT161,:))',MeanWithoutSingleRow(MSWSWT(idWT162,:))'])';
% mMWakeWT=([MeanWithoutSingleRow(MWakeWT(idWT51,:))',MeanWithoutSingleRow(MWakeWT(idWT60,:))', MeanWithoutSingleRow(MWakeWT(idWT61,:))', MeanWithoutSingleRow(MWakeWT(idWT82,:))', MeanWithoutSingleRow(MWakeWT(idWT83,:))', MeanWithoutSingleRow(MWakeWT(idWT147,:))', MeanWithoutSingleRow(MWakeWT(idWT148,:))', MeanWithoutSingleRow(MWakeWT(idWT160,:))', MeanWithoutSingleRow(MWakeWT(idWT161,:))',MeanWithoutSingleRow(MWakeWT(idWT162,:))'])';
% 
% mMSWSKO=([MeanWithoutSingleRow(MSWSKO(idKO47,:))', MeanWithoutSingleRow(MSWSKO(idKO52,:))', MeanWithoutSingleRow(MSWSKO(idKO54,:))', MeanWithoutSingleRow(MSWSKO(idKO65,:))', MeanWithoutSingleRow(MSWSKO(idKO66,:))',MeanWithoutSingleRow(MSWSKO(idKO146,:))',MeanWithoutSingleRow(MSWSKO(idKO149,:))',MeanWithoutSingleRow(MSWSKO(idKO158,:))',MeanWithoutSingleRow(MSWSKO(idKO159,:))',MeanWithoutSingleRow(MSWSKO(idKO164,:))'])';
% mMWakeKO=([MeanWithoutSingleRow(MWakeKO(idKO47,:))', MeanWithoutSingleRow(MWakeKO(idKO52,:))', MeanWithoutSingleRow(MWakeKO(idKO54,:))', MeanWithoutSingleRow(MWakeKO(idKO65,:))', MeanWithoutSingleRow(MWakeKO(idKO66,:))',MeanWithoutSingleRow(MWakeKO(idKO146,:))',MeanWithoutSingleRow(MWakeKO(idKO149,:))',MeanWithoutSingleRow(MWakeKO(idKO158,:))',MeanWithoutSingleRow(MWakeKO(idKO159,:))',MeanWithoutSingleRow(MWakeKO(idKO164,:))'])';
% 

mMSWSWT=([MeanWithoutSingleRow(MSWSWT(idWT51,:))',MeanWithoutSingleRow(MSWSWT(idWT60,:))', MeanWithoutSingleRow(MSWSWT(idWT61,:))', MeanWithoutSingleRow(MSWSWT(idWT82,:))', MeanWithoutSingleRow(MSWSWT(idWT83,:))', MeanWithoutSingleRow(MSWSWT(idWT147,:))', MeanWithoutSingleRow(MSWSWT(idWT148,:))', MeanWithoutSingleRow(MSWSWT(idWT160,:))', MeanWithoutSingleRow(MSWSWT(idWT161,:))',MeanWithoutSingleRow(MSWSWT(idWT162,:))'])';
mMWakeWT=([MeanWithoutSingleRow(MWakeWT(idWT51,:))',MeanWithoutSingleRow(MWakeWT(idWT60,:))', MeanWithoutSingleRow(MWakeWT(idWT61,:))', MeanWithoutSingleRow(MWakeWT(idWT82,:))', MeanWithoutSingleRow(MWakeWT(idWT83,:))', MeanWithoutSingleRow(MWakeWT(idWT147,:))', MeanWithoutSingleRow(MWakeWT(idWT148,:))', MeanWithoutSingleRow(MWakeWT(idWT160,:))', MeanWithoutSingleRow(MWakeWT(idWT161,:))',MeanWithoutSingleRow(MWakeWT(idWT162,:))'])';

mMSWSKO=([MeanWithoutSingleRow(MSWSKO(idKO47,:))', MeanWithoutSingleRow(MSWSKO(idKO52,:))', MeanWithoutSingleRow(MSWSKO(idKO54,:))', MeanWithoutSingleRow(MSWSKO(idKO65,:))', MeanWithoutSingleRow(MSWSKO(idKO66,:))',MeanWithoutSingleRow(MSWSKO(idKO146,:))',MeanWithoutSingleRow(MSWSKO(idKO149,:))',MeanWithoutSingleRow(MSWSKO(idKO158,:))',MeanWithoutSingleRow(MSWSKO(idKO164,:))'])';
mMWakeKO=([MeanWithoutSingleRow(MWakeKO(idKO47,:))', MeanWithoutSingleRow(MWakeKO(idKO52,:))', MeanWithoutSingleRow(MWakeKO(idKO54,:))', MeanWithoutSingleRow(MWakeKO(idKO65,:))', MeanWithoutSingleRow(MWakeKO(idKO66,:))',MeanWithoutSingleRow(MWakeKO(idKO146,:))',MeanWithoutSingleRow(MWakeKO(idKO149,:))',MeanWithoutSingleRow(MWakeKO(idKO158,:))',MeanWithoutSingleRow(MWakeKO(idKO164,:))'])';


%------------------------------------------------------------------------------------

% figure('color',[1 1 1]), 
% subplot(2,1,1), hold on
% plot(nanmean(mMSWSWT),'k')
% plot(nanmean(mMSWSKO),'r')
% ylabel('SWS')
% %xlim([0 4E4])
% 
% subplot(2,1,2), hold on
% plot(nanmean(mMWakeWT),'k')
% plot(nanmean(mMWakeKO),'r')
% ylabel('Wake')
% %xlim([0 4E4])

% figure('color',[1 1 1]),
% subplot(2,2,1),imagesc(mMSWSWT),caxis([0 9E5])
% subplot(2,2,2), imagesc(mMSWSKO),caxis([0 9E5])
% subplot(2,2,3), imagesc(mMWakeWT),caxis([0 9E5])
% subplot(2,2,4), imagesc(mMWakeKO),caxis([0 9E5])


%------------------------------------------------------------------------------------


pas=100;

figure('color',[1 1 1]), 
subplot(2,1,1), hold on
plot(smooth(nanmean(mMSWSWT(:,1:pas:end)),smo),'k','linewidth',2)
plot(smooth(nanmean(mMSWSWT(:,1:pas:end))+nanstd(mMSWSWT(:,1:pas:end))/sqrt(a-1),smo),'k','linewidth',1)
plot(smooth(nanmean(mMSWSWT(:,1:pas:end))-nanstd(mMSWSWT(:,1:pas:end))/sqrt(a-1),smo),'k','linewidth',1)
plot(smooth(nanmean(mMSWSKO(:,1:pas:end)),smo),'r','linewidth',2)
plot(smooth(nanmean(mMSWSKO(:,1:pas:end))+nanstd(mMSWSKO(:,1:pas:end))/sqrt(b-1),smo),'r','linewidth',1)
plot(smooth(nanmean(mMSWSKO(:,1:pas:end))-nanstd(mMSWSKO(:,1:pas:end))/sqrt(b-1),smo),'r','linewidth',1)
ylabel('SWS')
xlim([0 4E4/pas])

subplot(2,1,2), hold on
plot(smooth(nanmean(mMWakeWT(:,1:pas:end)),smo),'k','linewidth',2)
plot(smooth(nanmean(mMWakeWT(:,1:pas:end))+nanstd(mMWakeWT(:,1:pas:end))/sqrt(a-1),smo),'k','linewidth',1)
plot(smooth(nanmean(mMWakeWT(:,1:pas:end))-nanstd(mMWakeWT(:,1:pas:end))/sqrt(a-1),smo),'k','linewidth',1)
plot(smooth(nanmean(mMWakeKO(:,1:pas:end)),smo),'r','linewidth',2)
plot(smooth(nanmean(mMWakeKO(:,1:pas:end))+nanstd(mMWakeKO(:,1:pas:end))/sqrt(b-1),smo),'r','linewidth',1)
plot(smooth(nanmean(mMWakeKO(:,1:pas:end))-nanstd(mMWakeKO(:,1:pas:end))/sqrt(b-1),smo),'r','linewidth',1)
ylabel('Wake')
xlim([0 4E4/pas])


%------------------------------------------------------------------------------------

limitRec=0;
lim=5.5E4; %4.5E4;

figure('color',[1 1 1]), 
k=1;
for i=2:2:10
    
    fac2=i;
    
    if limitRec
        MtSWSwt=(mMSWSWT(:,1:floor(lim)));
        MtSWSko=(mMSWSKO(:,1:floor(lim)));
    else
        MtSWSwt=mMSWSWT;
        MtSWSko=mMSWSKO;
    end
    
    mSWS1wt=nanmean(MtSWSwt(:,1:floor(size(MtSWSwt,2)/fac2)),2);
    mSWS2wt=nanmean(MtSWSwt(:,floor(size(MtSWSwt,2)/fac2):end),2);

    mSWS1ko=nanmean(MtSWSko(:,1:floor(size(MtSWSko,2)/fac2)),2);
    mSWS2ko=nanmean(MtSWSko(:,floor(size(MtSWSko,2)/fac2):end),2);

    [h,p]=ttest2(mSWS1wt,mSWS1ko);
    subplot(2,5,k), PlotErrorBar5(mSWS1wt,mSWS2wt,0,mSWS1ko,mSWS2ko,0), title([num2str(i),', ',num2str(floor(size(MtSWSwt,2)/fac2)/pas),', p=',num2str(p)])
    k=k+1;
    
end

subplot(2,5,6:10), hold on
try
    [h,p]=ttest2(MtSWSwt(:,1:pas:end),MtSWSko(:,1:pas:end));
plot(p*1E6,'color',[0.7 0.7 0.7])
end
plot(smooth(nanmean(MtSWSwt(:,1:pas:end)),smo),'k','linewidth',2)
plot(smooth(nanmean(MtSWSwt(:,1:pas:end))+nanstd(MtSWSwt(:,1:pas:end))/sqrt(a-1),smo),'k','linewidth',1)
plot(smooth(nanmean(MtSWSwt(:,1:pas:end))-nanstd(MtSWSwt(:,1:pas:end))/sqrt(a-1),smo),'k','linewidth',1)
plot(smooth(nanmean(MtSWSko(:,1:pas:end)),smo),'r','linewidth',2)
plot(smooth(nanmean(MtSWSko(:,1:pas:end))+nanstd(MtSWSko(:,1:pas:end))/sqrt(b-1),smo),'r','linewidth',1)
plot(smooth(nanmean(MtSWSko(:,1:pas:end))-nanstd(MtSWSko(:,1:pas:end))/sqrt(b-1),smo),'r','linewidth',1)
ylabel('SWS')
if limitRec
xlim([0 lim/pas])
end

try
plot(find((p<0.05)),p(p<0.05)*1E6,'go','markerfacecolor','g')
end



%------------------------------------------------------------------------------------



figure('color',[1 1 1]), 
k=1;
for i=2:2:10
    
    fac2=i;
    if limitRec
    MaSWSwt=(MSWSWT(:,1:floor(lim)));
    MaSWSko=(MSWSKO(:,1:floor(lim)));
    else
      MaSWSwt=MSWSWT; 
      MaSWSko=MSWSKO;  
    end
    
    SWS1wt=nanmean(MaSWSwt(:,1:floor(size(MaSWSwt,2)/fac2)),2);
    SWS2wt=nanmean(MaSWSwt(:,floor(size(MaSWSwt,2)/fac2):end),2);

    
    SWS1ko=nanmean(MaSWSko(:,1:floor(size(MaSWSko,2)/fac2)),2);
    SWS2ko=nanmean(MaSWSko(:,floor(size(MaSWSko,2)/fac2):end),2);

    [h,p]=ttest2(SWS1wt,SWS1ko);
    subplot(1,5,k), PlotErrorBar5(SWS1wt,SWS2wt,0,SWS1ko,SWS2ko,0), title([num2str(i),', ',num2str(floor(size(MaSWSwt,2)/fac2)/pas),', p=',num2str(p)])
    k=k+1;
    
end



%------------------------------------------------------------------------------------


% 
% pas2=200;
% 
% 
% figure('color',[1 1 1]), 
% subplot(2,2,1), hold on
% plot((mMSWSWT(:,1:pas2:end)'),'k','linewidth',1)
% subplot(2,2,2), hold on
% plot((mMSWSKO(:,1:pas2:end)'),'r','linewidth',1)
% subplot(2,2,3), hold on
% plot((mMWakeWT(:,1:pas2:end)'),'k','linewidth',1)
% subplot(2,2,4), hold on
% plot((mMWakeKO(:,1:pas2:end)'),'r','linewidth',1)


%------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------

for i=1:length(EvolSlowBulbWT)
    ttWT(i,1)=EvolSlowBulbWT{i,11};
    ttWT(i,2)=EvolSlowBulbWT{i,12};
end



for i=1:length(EvolSlowBulbKO)
    ttKO(i,1)=EvolSlowBulbKO{i,11};
    ttKO(i,2)=EvolSlowBulbKO{i,12};
end
%SlowBulbKO
%SlowBulbWT
% 
% figure('color',[1 1 1]),
% subplot(2,2,1),imagesc(MSWSWT),caxis([0 9E5]), axis xy
% subplot(2,2,2), hold on
% plot(ttWT(:,1),1:length(EvolSlowBulbWT),'ko-','markerfacecolor','k','linewidth',2), ylim([0 23])
% plot(ttWT(:,2),1:length(EvolSlowBulbWT),'ro-','markerfacecolor','r','linewidth',2), ylim([0 23])
% subplot(2,2,3), imagesc(MWakeWT),caxis([0 9E5]), axis xy
% subplot(2,2,4),hold on
% plot(ttWT(:,1),1:length(EvolSlowBulbWT),'ko-','markerfacecolor','k','linewidth',2), ylim([0 23])
% plot(ttWT(:,2),1:length(EvolSlowBulbWT),'ro-','markerfacecolor','r','linewidth',2), ylim([0 23])
% subplot(2,2,1),hold on, 
% plot(rescale(ttWT(:,1),0,7E4),1:length(EvolSlowBulbWT),'wo-','markerfacecolor','w','linewidth',2), ylim([0 23])
% subplot(2,2,3),hold on, 
% plot(rescale(ttWT(:,1),0,7E4),1:length(EvolSlowBulbWT),'wo-','markerfacecolor','w','linewidth',2), ylim([0 23])
%  
% figure('color',[1 1 1]),
% subplot(2,2,1),imagesc(MSWSKO),caxis([0 9E5]), axis xy
% subplot(2,2,2),plot(ttKO(:,1),1:length(EvolSlowBulbKO),'ko-','markerfacecolor','k','linewidth',2), ylim([0 23])
% subplot(2,2,3), imagesc(MWakeKO),caxis([0 9E5]), axis xy
% subplot(2,2,4),plot(ttKO(:,1),1:length(EvolSlowBulbKO),'ko-','markerfacecolor','k','linewidth',2), ylim([0 23])
% subplot(2,2,1),hold on, plot(rescale(ttKO(:,1),0,7E4),1:length(EvolSlowBulbKO),'wo-','markerfacecolor','w','linewidth',2), ylim([0 23])
% subplot(2,2,3),hold on, plot(rescale(ttKO(:,1),0,7E4),1:length(EvolSlowBulbKO),'wo-','markerfacecolor','w','linewidth',2), ylim([0 23])
% 


% SlowBulbWT(a,1)=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
% SlowBulbWT(a,2)=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));
% SlowBulbWT(a,3)=sum(End(Wake,'s')-Start(Wake,'s'));  
% SlowBulbWT(a,4)=st;  
% SlowBulbWT(a,5)=str;  
% SlowBulbWT(a,6)=TimeDebRec(1,1)+TimeDebRec(1,2)/60;


%------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------

nT1=size(SlowBulbWT,2);
nT2=size(SlowBulbKO,2);

SlowBulbWT(:,nT1+1)=SlowBulbWT(:,1)./(SlowBulbWT(:,1)+SlowBulbWT(:,2))*100;
SlowBulbKO(:,nT2+1)=SlowBulbKO(:,1)./(SlowBulbKO(:,1)+SlowBulbKO(:,2))*100;

SlowBulbWT(:,nT1+2)=SlowBulbWT(:,4)/3600+SlowBulbWT(:,6);
SlowBulbKO(:,nT2+2)=SlowBulbKO(:,4)/3600+SlowBulbKO(:,6);

SlowBulbWT(:,nT1+3)=(SWS1wt)'-(SWS2wt)';
SlowBulbKO(:,nT2+3)=(SWS1ko)'-(SWS2ko)';

SlowBulbWT(:,nT1+4)=(SWS1wt)';
SlowBulbWT(:,nT1+5)=(SWS2wt)';

SlowBulbKO(:,nT2+4)=(SWS1ko)';
SlowBulbKO(:,nT2+5)=(SWS2ko)';


ti{1}='REM';
ti{2}='SWS';
ti{3}='Wake';
ti{4}='deb SWS';
ti{5}='deb REM';
ti{6}='Hour deb';
ti{7}='Hour SWS end';
ti{8}='Ratio REM SWS (%)';
ti{9}='Hour SWS';
ti{10}='Evol Slow';
ti{11}='Slow  DEB';
ti{12}='Slow FIN';

N=1:12;
%N=[1,2,3,7,8,9,10,11,12];

if 0
    for i=1:length(N)
        figure('color',[1 1 1]), 
        set(gcf,'position',[117         633        3407         335])
        nn=1;
        for j=1:length(N)
            if i~=j
            subplot(1,length(N),nn), hold on
            plot(SlowBulbWT(:,N(j)),SlowBulbWT(:,N(i)), 'ko')
            plot(SlowBulbKO(:,N(j)),SlowBulbKO(:,N(i)), 'ro')
            xlabel(ti{N(j)})
            ylabel(ti{N(i)})
            nn=nn+1;
            end
        end
    end
end

limRatioREMSS=40;
idOKwt=find(SlowBulbWT(:,8)<limRatioREMSS);
idOKko=find(SlowBulbKO(:,8)<limRatioREMSS);


for i=1:length(N)
     figure('color',[1 1 1]), 
    set(gcf,'position',[117         633        3407         335])
    nn=1;
    for j=1:length(N)
        if i~=j
        subplot(1,length(N),nn), hold on
        plot(SlowBulbWT(idOKwt,N(j)),SlowBulbWT(idOKwt,N(i)), 'ko','markerfacecolor','k')
        plot(SlowBulbKO(idOKko,N(j)),SlowBulbKO(idOKko,N(i)), 'ro','markerfacecolor','r')
        xlabel(ti{N(j)})
        ylabel(ti{N(i)})
        
        [r1,p1]=corrcoef(SlowBulbWT(idOKwt,N(j)), SlowBulbWT(idOKwt,N(i)));
        [r2,p2]=corrcoef(SlowBulbKO(idOKko,N(j)), SlowBulbKO(idOKko,N(i)));
        
        title(['WT=',num2str(floor(r1(2,1)*10)/10),', ',num2str(floor(p1(2,1)*100)/100),'; KO=',num2str(floor(r2(2,1)*10)/10),', ',num2str(floor(p2(2,1)*100)/100),])
         nn=nn+1;
        end
    end
end


%------------------------------------------------------------------------------------


figure('color',[1 1 1]),
i=9; j=11;
subplot(1,3,1),hold on,
plot(SlowBulbWT(idOKwt,N(i)), SlowBulbWT(idOKwt,N(j)),'ko','markerfacecolor','k')
plot(SlowBulbKO(idOKko,N(i)), SlowBulbKO(idOKko,N(j)),'ro','markerfacecolor','r')
xlabel(ti{N(i)})
ylabel(ti{N(j)})
yl=ylim;

i=9; j=12;
subplot(1,3,2),hold on,
plot(SlowBulbWT(idOKwt,N(i)), SlowBulbWT(idOKwt,N(j)),'ko','markerfacecolor','k')
plot(SlowBulbKO(idOKko,N(i)), SlowBulbKO(idOKko,N(j)),'ro','markerfacecolor','r')
xlabel(ti{N(i)})
ylabel(ti{N(j)})
ylim(yl)

i=6; j=12;
subplot(1,3,3),hold on,
plot(SlowBulbWT(idOKwt,N(i)), SlowBulbWT(idOKwt,N(j)),'ko','markerfacecolor','k')
plot(SlowBulbKO(idOKko,N(i)), SlowBulbKO(idOKko,N(j)),'ro','markerfacecolor','r')
xlabel(ti{N(i)})
ylabel(ti{N(j)})
ylim(yl)



i=9; j=11;i2=7; j2=12;
figure('color',[1 1 1]),
subplot(1,2,1),hold on,
plot(SlowBulbWT(idOKwt,N(i)), SlowBulbWT(idOKwt,N(j)),'ko','markerfacecolor','k')
plot(SlowBulbWT(idOKwt,N(i2)), SlowBulbWT(idOKwt,N(j2)),'bo','markerfacecolor','b')
line([SlowBulbWT(idOKwt,N(i)) SlowBulbWT(idOKwt,N(i2))]',[SlowBulbWT(idOKwt,N(j)) SlowBulbWT(idOKwt,N(j2))]','color','k')
xlabel(ti{N(i)})
ylabel('Slow DEB/FIN, WT')
ylim([0 3.5E6])
xlim([10 20])

subplot(1,2,2),hold on,
plot(SlowBulbKO(idOKko,N(i)), SlowBulbKO(idOKko,N(j)),'ko','markerfacecolor','k')
plot(SlowBulbKO(idOKko,N(i2)), SlowBulbKO(idOKko,N(j2)),'bo','markerfacecolor','b')
line([SlowBulbKO(idOKko,N(i)) SlowBulbKO(idOKko,N(i2))]',[SlowBulbKO(idOKko,N(j)) SlowBulbKO(idOKko,N(j2))]','color','k')
xlabel(ti{N(i)})
ylabel('Slow DEB/FIN, KO')
ylim([0 3.5E6])
xlim([10 20])

%

%------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------


idBADwt=find(SlowBulbWT(:,8)>limRatioREMSS);
idBADko=find(SlowBulbKO(:,8)>limRatioREMSS);
EvolSlowBulbWT{idBADwt,1}
EvolSlowBulbKO{idBADko,1}




figure('color',[1 1 1])
subplot(1,3,1), PlotErrorBar2(SlowBulbWT(idOKwt,N(j)),SlowBulbKO(idOKko,N(j)),0),ylim([0 3E6])
subplot(1,3,2), PlotErrorBar2(SlowBulbWT(idOKwt,N(j2)),SlowBulbKO(idOKko,N(j2)),0),ylim([0 3E6])
subplot(1,3,3), PlotErrorBar2(SlowBulbWT(idOKwt,N(j))-SlowBulbWT(idOKwt,N(j2)),SlowBulbKO(idOKko,N(j))-SlowBulbKO(idOKko,N(j2)),0)







figure('color',[1 1 1])
 for i=1:18
subplot(2,9,i), PlotErrorBar2(SloOwt(idOKwt,i),SloOko(idOKko,i),0), ylim([0 3E6])
if i<4
    ylim([0 100])
end
if i>9&i<13
ylim([0 100])
end
    
 end

% 
% 
% ka=0;ka=9;
% 
% ii=4+ka;jj=7+ka;kk=1+ka;
% figure('color',[1 1 1])
% subplot(1,2,2), plot(SloOko(idOKko,ii)-SloOko(idOKko,jj),SloOko(idOKko,kk),'ro', 'markerfacecolor','r')
% [r1,p1]=corrcoef(SloOko(idOKko,ii)-SloOko(idOKko,jj), SloOko(idOKko,kk));
%  title(['KO, REM, ',num2str(floor(r1(2,1)*10)/10),', ',num2str(floor(p1(2,1)*100)/100),])
%  subplot(1,2,1),plot(SloOwt(idOKwt,ii)-SloOwt(idOKwt,jj),SloOwt(idOKwt,kk),'ko', 'markerfacecolor','k')
% [r2,p2]=corrcoef(SloOwt(idOKwt,ii)-SloOwt(idOKwt,jj), SloOwt(idOKwt,kk));
%  title(['WT, REM, ',num2str(floor(r2(2,1)*10)/10),', ',num2str(floor(p2(2,1)*100)/100),])       
%         
% ii=5+ka;jj=8+ka;kk=2+ka;
% figure('color',[1 1 1])
% subplot(1,2,2), plot(SloOko(idOKko,ii)-SloOko(idOKko,jj),SloOko(idOKko,kk),'ro', 'markerfacecolor','r')
% [r1,p1]=corrcoef(SloOko(idOKko,ii)-SloOko(idOKko,jj), SloOko(idOKko,kk));
%  title(['KO, SWS, ',num2str(floor(r1(2,1)*10)/10),', ',num2str(floor(p1(2,1)*100)/100),])
%  subplot(1,2,1),plot(SloOwt(idOKwt,ii)-SloOwt(idOKwt,jj),SloOwt(idOKwt,kk),'ko', 'markerfacecolor','k')
% [r2,p2]=corrcoef(SloOwt(idOKwt,ii)-SloOwt(idOKwt,jj), SloOwt(idOKwt,kk));
%  title(['WT, SWS, ',num2str(floor(r2(2,1)*10)/10),', ',num2str(floor(p2(2,1)*100)/100),])
%         
% ii=6+ka;jj=9+ka;kk=3+ka;
% figure('color',[1 1 1])
% subplot(1,2,2), plot(SloOko(idOKko,ii)-SloOko(idOKko,jj),SloOko(idOKko,kk),'ro', 'markerfacecolor','r')
% [r1,p1]=corrcoef(SloOko(idOKko,ii)-SloOko(idOKko,jj), SloOko(idOKko,kk));
%  title(['KO, Wake, ',num2str(floor(r1(2,1)*10)/10),', ',num2str(floor(p1(2,1)*100)/100),])
%  subplot(1,2,1),plot(SloOwt(idOKwt,ii)-SloOwt(idOKwt,jj),SloOwt(idOKwt,kk),'ko', 'markerfacecolor','k')
% [r2,p2]=corrcoef(SloOwt(idOKwt,ii)-SloOwt(idOKwt,jj), SloOwt(idOKwt,kk));
%  title(['WT, Wake, ',num2str(floor(r2(2,1)*10)/10),', ',num2str(floor(p2(2,1)*100)/100),])
%         
%  
%  
%  
% ka=0;ka=9;
% 
% ii=4+ka;jj=7+ka;kk=1+ka;
% figure('color',[1 1 1])
% subplot(1,3,1), hold on
% plot(SloOko(idOKko,ii)-SloOko(idOKko,jj),SloOko(idOKko,kk),'ro', 'markerfacecolor','r')
% [r1,p1]=corrcoef(SloOko(idOKko,ii)-SloOko(idOKko,jj), SloOko(idOKko,kk));
%  title(['KO, REM, ',num2str(floor(r1(2,1)*10)/10),', ',num2str(floor(p1(2,1)*100)/100),])
%  plot(SloOwt(idOKwt,ii)-SloOwt(idOKwt,jj),SloOwt(idOKwt,kk),'ko', 'markerfacecolor','k')
% [r2,p2]=corrcoef(SloOwt(idOKwt,ii)-SloOwt(idOKwt,jj), SloOwt(idOKwt,kk));
%  title(['WT, REM, ',num2str(floor(r2(2,1)*10)/10),', ',num2str(floor(p2(2,1)*100)/100),])       
%         
% ii=5+ka;jj=8+ka;kk=2+ka;
% 
% subplot(1,3,2), hold on,
% plot(SloOko(idOKko,ii)-SloOko(idOKko,jj),SloOko(idOKko,kk),'ro', 'markerfacecolor','r')
% [r1,p1]=corrcoef(SloOko(idOKko,ii)-SloOko(idOKko,jj), SloOko(idOKko,kk));
%  title(['KO, SWS, ',num2str(floor(r1(2,1)*10)/10),', ',num2str(floor(p1(2,1)*100)/100),])
% plot(SloOwt(idOKwt,ii)-SloOwt(idOKwt,jj),SloOwt(idOKwt,kk),'ko', 'markerfacecolor','k')
% [r2,p2]=corrcoef(SloOwt(idOKwt,ii)-SloOwt(idOKwt,jj), SloOwt(idOKwt,kk));
%  title(['WT, SWS, ',num2str(floor(r2(2,1)*10)/10),', ',num2str(floor(p2(2,1)*100)/100),])
%         
% ii=6+ka;jj=9+ka;kk=3+ka;
% 
% subplot(1,3,3),hold on,
% plot(SloOko(idOKko,ii)-SloOko(idOKko,jj),SloOko(idOKko,kk),'ro', 'markerfacecolor','r')
% [r1,p1]=corrcoef(SloOko(idOKko,ii)-SloOko(idOKko,jj), SloOko(idOKko,kk));
%  title(['KO, Wake, ',num2str(floor(r1(2,1)*10)/10),', ',num2str(floor(p1(2,1)*100)/100),])
% plot(SloOwt(idOKwt,ii)-SloOwt(idOKwt,jj),SloOwt(idOKwt,kk),'ko', 'markerfacecolor','k')
% [r2,p2]=corrcoef(SloOwt(idOKwt,ii)-SloOwt(idOKwt,jj), SloOwt(idOKwt,kk));
%  title(['WT, Wake, ',num2str(floor(r2(2,1)*10)/10),', ',num2str(floor(p2(2,1)*100)/100),])
%         
%  
%  
%  
%  
%  
 


for kk=1:12
figure('color',[1 1 1])
ii=11;
plot(SloOwt(idOKwt,ii),SlowBulbWT(idOKwt,kk),'ko', 'markerfacecolor','k')
hold on, plot(SloOko(idOKko,ii),SlowBulbKO(idOKko,kk),'ro', 'markerfacecolor','r')
title(['SWS, ',ti{kk}])
xlabel('Ratio High versus Slow (%)')
ylabel(ti{kk})
end





%         idWT51=[];
%         idWT60=[];
%         idWT61=[];
%         idWT82=[];
%         idWT83=[];
%         idWT147=[];
%         idWT148=[];
%         idWT160=[];
%         idWT161=[];
%         idWT162=[];
%         idWT159=[];

    si1=size(SlowBulbWT,2);
    si2=size(SlowBulbKO,2);
    
for i=1:length(EvolSlowBulbWT)
    if nanmean(EvolSlowBulbWT{i,10})<0.5
    SlowBulbWT(i,si1+1)=nanmean(EvolSlowBulbWT{i,10})*100;
    else
       SlowBulbWT(i,si1+1)=nanmean(EvolSlowBulbWT{i,10}); 
    end
    
end

for i=1:length(EvolSlowBulbKO)
    if nanmean(EvolSlowBulbKO{i,10})<0.5
   SlowBulbKO(i,si2+1)=nanmean(EvolSlowBulbKO{i,10})*100;
    else
    SlowBulbKO(i,si2+1)=nanmean(EvolSlowBulbKO{i,10});    
    end
end



ti{13}='Mov wake';

ii=11;
for kk=1:13
figure('color',[1 1 1]), 
subplot(1,2,1),hold on
    idch=idWT51; plot(SloOwt(idch,ii),SlowBulbWT(idch,kk),'ko', 'markerfacecolor','k')
    idch=idWT60; plot(SloOwt(idch,ii),SlowBulbWT(idch,kk),'ro', 'markerfacecolor','r')
    idch=idWT61; plot(SloOwt(idch,ii),SlowBulbWT(idch,kk),'go', 'markerfacecolor','g')    
    idch=idWT82; plot(SloOwt(idch,ii),SlowBulbWT(idch,kk),'bo', 'markerfacecolor','b')
    idch=idWT83; plot(SloOwt(idch,ii),SlowBulbWT(idch,kk),'yo', 'markerfacecolor','y')    
    idch=idWT147; plot(SloOwt(idch,ii),SlowBulbWT(idch,kk),'mo', 'markerfacecolor','m')
    idch=idWT148; plot(SloOwt(idch,ii),SlowBulbWT(idch,kk),'co', 'markerfacecolor','c')
    idch=idWT159; plot(SloOwt(idch,ii),SlowBulbWT(idch,kk),'ko', 'markerfacecolor','w')
    idch=idWT160; plot(SloOwt(idch,ii),SlowBulbWT(idch,kk),'ro', 'markerfacecolor','w')
    idch=idWT161; plot(SloOwt(idch,ii),SlowBulbWT(idch,kk),'bo', 'markerfacecolor','w')
    idch=idWT162; plot(SloOwt(idch,ii),SlowBulbWT(idch,kk),'go', 'markerfacecolor','w')  
    title(['WT SWS, ',ti{kk}])
    xlabel('Ratio High versus Slow (%)')
    xlim([0 100])
    yl1=ylim;
ylabel(ti{kk})
subplot(1,2,2),hold on
    idch=idKO47; plot(SloOko(idch,ii),SlowBulbKO(idch,kk),'ko', 'markerfacecolor','k')
    idch=idKO52; plot(SloOko(idch,ii),SlowBulbKO(idch,kk),'ro', 'markerfacecolor','r')    
    idch=idKO54; plot(SloOko(idch,ii),SlowBulbKO(idch,kk),'go', 'markerfacecolor','g')   
    idch=idKO65; plot(SloOko(idch,ii),SlowBulbKO(idch,kk),'bo', 'markerfacecolor','b')   
    idch=idKO66; plot(SloOko(idch,ii),SlowBulbKO(idch,kk),'yo', 'markerfacecolor','y')   
    idch=idKO146; plot(SloOko(idch,ii),SlowBulbKO(idch,kk),'mo', 'markerfacecolor','m')   
    idch=idKO149; plot(SloOko(idch,ii),SlowBulbKO(idch,kk),'co', 'markerfacecolor','c')   
    idch=idKO158; plot(SloOko(idch,ii),SlowBulbKO(idch,kk),'ko', 'markerfacecolor','w')   
    idch=idKO164; plot(SloOko(idch,ii),SlowBulbKO(idch,kk),'ro', 'markerfacecolor','w')   
    xlim([0 100])
    yl2=ylim;
    title(['KO SWS, ',ti{kk}])
xlabel('Ratio High versus Slow (%)')
ylabel(ti{kk})

subplot(1,2,1),ylim([min(yl1(1),yl2(1)) max(yl1(2),yl2(2))])
subplot(1,2,2),ylim([min(yl1(1),yl2(1)) max(yl1(2),yl2(2))])
end







i=9; j=11;i2=7; j2=12;
figure('color',[1 1 1]),
subplot(1,2,1),hold on,
    idch=idWT51; plot(SlowBulbWT(idch,N(i)), SlowBulbWT(idch,N(j)),'ko', 'markerfacecolor','k')
    plot(SlowBulbWT(idch,N(i2)), SlowBulbWT(idch,N(j2)),'ko', 'markerfacecolor','k')
    line([SlowBulbWT(idch,N(i)) SlowBulbWT(idch,N(i2))]',[SlowBulbWT(idch,N(j)) SlowBulbWT(idch,N(j2))]','color','k')
    idch=idWT60; plot(SlowBulbWT(idch,N(i)), SlowBulbWT(idch,N(j)),'ro', 'markerfacecolor','r')
    plot(SlowBulbWT(idch,N(i2)), SlowBulbWT(idch,N(j2)),'ro', 'markerfacecolor','r')
    line([SlowBulbWT(idch,N(i)) SlowBulbWT(idch,N(i2))]',[SlowBulbWT(idch,N(j)) SlowBulbWT(idch,N(j2))]','color','k')   
    idch=idWT61; plot(SlowBulbWT(idch,N(i)), SlowBulbWT(idch,N(j)),'bo', 'markerfacecolor','b')
    plot(SlowBulbWT(idch,N(i2)), SlowBulbWT(idch,N(j2)),'bo', 'markerfacecolor','b')
    line([SlowBulbWT(idch,N(i)) SlowBulbWT(idch,N(i2))]',[SlowBulbWT(idch,N(j)) SlowBulbWT(idch,N(j2))]','color','k') 
    idch=idWT82; plot(SlowBulbWT(idch,N(i)), SlowBulbWT(idch,N(j)),'go', 'markerfacecolor','g')
    plot(SlowBulbWT(idch,N(i2)), SlowBulbWT(idch,N(j2)),'go', 'markerfacecolor','g')
    line([SlowBulbWT(idch,N(i)) SlowBulbWT(idch,N(i2))]',[SlowBulbWT(idch,N(j)) SlowBulbWT(idch,N(j2))]','color','k')  
    idch=idWT83; plot(SlowBulbWT(idch,N(i)), SlowBulbWT(idch,N(j)),'mo', 'markerfacecolor','m')
    plot(SlowBulbWT(idch,N(i2)), SlowBulbWT(idch,N(j2)),'mo', 'markerfacecolor','m')
    line([SlowBulbWT(idch,N(i)) SlowBulbWT(idch,N(i2))]',[SlowBulbWT(idch,N(j)) SlowBulbWT(idch,N(j2))]','color','k')  
    idch=idWT147;plot(SlowBulbWT(idch,N(i)), SlowBulbWT(idch,N(j)),'ko', 'markerfacecolor','y')
    plot(SlowBulbWT(idch,N(i2)), SlowBulbWT(idch,N(j2)),'ko', 'markerfacecolor','y')
    line([SlowBulbWT(idch,N(i)) SlowBulbWT(idch,N(i2))]',[SlowBulbWT(idch,N(j)) SlowBulbWT(idch,N(j2))]','color','k')   
    idch=idWT148; plot(SlowBulbWT(idch,N(i)), SlowBulbWT(idch,N(j)),'co', 'markerfacecolor','c')
    plot(SlowBulbWT(idch,N(i2)), SlowBulbWT(idch,N(j2)),'co', 'markerfacecolor','c')
    line([SlowBulbWT(idch,N(i)) SlowBulbWT(idch,N(i2))]',[SlowBulbWT(idch,N(j)) SlowBulbWT(idch,N(j2))]','color','k')   
    idch=idWT159; plot(SlowBulbWT(idch,N(i)), SlowBulbWT(idch,N(j)),'ko', 'markerfacecolor','w')
    plot(SlowBulbWT(idch,N(i2)), SlowBulbWT(idch,N(j2)),'ko', 'markerfacecolor','w')
    line([SlowBulbWT(idch,N(i)) SlowBulbWT(idch,N(i2))]',[SlowBulbWT(idch,N(j)) SlowBulbWT(idch,N(j2))]','color','k') 
    idch=idWT160; plot(SlowBulbWT(idch,N(i)), SlowBulbWT(idch,N(j)),'ro', 'markerfacecolor','w')
    plot(SlowBulbWT(idch,N(i2)), SlowBulbWT(idch,N(j2)),'ro', 'markerfacecolor','w')
    line([SlowBulbWT(idch,N(i)) SlowBulbWT(idch,N(i2))]',[SlowBulbWT(idch,N(j)) SlowBulbWT(idch,N(j2))]','color','k')
    idch=idWT161; plot(SlowBulbWT(idch,N(i)), SlowBulbWT(idch,N(j)),'co', 'markerfacecolor','w')
    plot(SlowBulbWT(idch,N(i2)), SlowBulbWT(idch,N(j2)),'co', 'markerfacecolor','w')
    line([SlowBulbWT(idch,N(i)) SlowBulbWT(idch,N(i2))]',[SlowBulbWT(idch,N(j)) SlowBulbWT(idch,N(j2))]','color','k')
        idch=idWT162; plot(SlowBulbWT(idch,N(i)), SlowBulbWT(idch,N(j)),'go', 'markerfacecolor','w')
    plot(SlowBulbWT(idch,N(i2)), SlowBulbWT(idch,N(j2)),'go', 'markerfacecolor','w')
    line([SlowBulbWT(idch,N(i)) SlowBulbWT(idch,N(i2))]',[SlowBulbWT(idch,N(j)) SlowBulbWT(idch,N(j2))]','color','k')
    
xlabel(ti{N(i)})
ylabel('Slow DEB/FIN, WT')
ylim([0 3.5E6])
xlim([10 20])

subplot(1,2,2),hold on,
 idch=idKO47; plot(SlowBulbKO(idch,N(i)), SlowBulbKO(idch,N(j)),'ko','markerfacecolor','k')
plot(SlowBulbKO(idch,N(i2)), SlowBulbKO(idch,N(j2)),'ko','markerfacecolor','k')
line([SlowBulbKO(idch,N(i)) SlowBulbKO(idch,N(i2))]',[SlowBulbKO(idch,N(j)) SlowBulbKO(idch,N(j2))]','color','k')

    idch=idKO52; plot(SlowBulbKO(idch,N(i)), SlowBulbKO(idch,N(j)),'ro','markerfacecolor','r')
plot(SlowBulbKO(idch,N(i2)), SlowBulbKO(idch,N(j2)),'ro','markerfacecolor','r')
line([SlowBulbKO(idch,N(i)) SlowBulbKO(idch,N(i2))]',[SlowBulbKO(idch,N(j)) SlowBulbKO(idch,N(j2))]','color','k')
    idch=idKO54; plot(SlowBulbKO(idch,N(i)), SlowBulbKO(idch,N(j)),'bo','markerfacecolor','b')
plot(SlowBulbKO(idch,N(i2)), SlowBulbKO(idch,N(j2)),'bo','markerfacecolor','b')
line([SlowBulbKO(idch,N(i)) SlowBulbKO(idch,N(i2))]',[SlowBulbKO(idch,N(j)) SlowBulbKO(idch,N(j2))]','color','k')
    idch=idKO65; plot(SlowBulbKO(idch,N(i)), SlowBulbKO(idch,N(j)),'go','markerfacecolor','g')
plot(SlowBulbKO(idch,N(i2)), SlowBulbKO(idch,N(j2)),'go','markerfacecolor','g')
line([SlowBulbKO(idch,N(i)) SlowBulbKO(idch,N(i2))]',[SlowBulbKO(idch,N(j)) SlowBulbKO(idch,N(j2))]','color','k') 
    idch=idKO66;plot(SlowBulbKO(idch,N(i)), SlowBulbKO(idch,N(j)),'mo','markerfacecolor','m')
plot(SlowBulbKO(idch,N(i2)), SlowBulbKO(idch,N(j2)),'mo','markerfacecolor','m')
line([SlowBulbKO(idch,N(i)) SlowBulbKO(idch,N(i2))]',[SlowBulbKO(idch,N(j)) SlowBulbKO(idch,N(j2))]','color','k')
    idch=idKO146; plot(SlowBulbKO(idch,N(i)), SlowBulbKO(idch,N(j)),'ko','markerfacecolor','y')
plot(SlowBulbKO(idch,N(i2)), SlowBulbKO(idch,N(j2)),'ko','markerfacecolor','y')
line([SlowBulbKO(idch,N(i)) SlowBulbKO(idch,N(i2))]',[SlowBulbKO(idch,N(j)) SlowBulbKO(idch,N(j2))]','color','k') 
    idch=idKO149; plot(SlowBulbKO(idch,N(i)), SlowBulbKO(idch,N(j)),'co','markerfacecolor','c')
plot(SlowBulbKO(idch,N(i2)), SlowBulbKO(idch,N(j2)),'co','markerfacecolor','c')
line([SlowBulbKO(idch,N(i)) SlowBulbKO(idch,N(i2))]',[SlowBulbKO(idch,N(j)) SlowBulbKO(idch,N(j2))]','color','k')
    idch=idKO158; plot(SlowBulbKO(idch,N(i)), SlowBulbKO(idch,N(j)),'ko','markerfacecolor','w')
plot(SlowBulbKO(idch,N(i2)), SlowBulbKO(idch,N(j2)),'ko','markerfacecolor','w')
line([SlowBulbKO(idch,N(i)) SlowBulbKO(idch,N(i2))]',[SlowBulbKO(idch,N(j)) SlowBulbKO(idch,N(j2))]','color','k')
    idch=idKO164;plot(SlowBulbKO(idch,N(i)), SlowBulbKO(idch,N(j)),'ro','markerfacecolor','w')
plot(SlowBulbKO(idch,N(i2)), SlowBulbKO(idch,N(j2)),'ro','markerfacecolor','w')
line([SlowBulbKO(idch,N(i)) SlowBulbKO(idch,N(i2))]',[SlowBulbKO(idch,N(j)) SlowBulbKO(idch,N(j2))]','color','k')
    
xlabel(ti{N(i)})
ylabel('Slow DEB/FIN, KO')
ylim([0 3.5E6])
xlim([10 20])








%         idKO47=[];
%         idKO52=[];
%         idKO54=[];
%         idKO65=[];
%         idKO66=[];
%         idKO146=[];
%         idKO149=[];
%         idKO158=[];
%         idKO164=[];   





















if 0

    figure('color',[1 1 1])
    ii=4;jj=7;kk=1;
    plot(SloOwt(idOKwt,ii)-SloOwt(idOKwt,jj),SloOwt(idOKwt,kk),'ko', 'markerfacecolor','k')
    hold on, plot(SloOko(idOKko,ii)-SloOko(idOKko,jj),SloOko(idOKko,kk),'ro', 'markerfacecolor','r')
    title('REM')

    figure('color',[1 1 1])
    ii=5;jj=8;kk=2;
    plot(SloOwt(idOKwt,ii)-SloOwt(idOKwt,jj),SloOwt(idOKwt,kk),'ko', 'markerfacecolor','k')
    hold on, plot(SloOko(idOKko,ii)-SloOko(:,jj),SloOko(idOKko,kk),'ro', 'markerfacecolor','r')
    title('SWS')

    figure('color',[1 1 1])
    ii=6;jj=9;kk=3;
    plot(SloOwt(idOKwt,ii)-SloOwt(idOKwt,jj),SloOwt(idOKwt,kk),'ko', 'markerfacecolor','k')
    hold on, plot(SloOko(idOKko,ii)-SloOko(idOKko,jj),SloOko(idOKko,kk),'ro', 'markerfacecolor','r')
    title('Wake')


    % ti{1}='REM';
    % ti{2}='SWS';
    % ti{3}='Wake';
    % ti{4}='deb SWS';
    % ti{5}='deb REM';
    % ti{6}='Hour deb';
    % ti{7}='Hour SWS end';
    % ti{8}='Ratio REM SWS (%)';
    % ti{9}='Hour SWS';
    % ti{10}='Evol Slow';
    % ti{11}='Slow  DEB';
    % ti{12}='Slow FIN';

    for kk=1:12
    figure('color',[1 1 1])
    ii=5;jj=8;
    plot(SloOwt(idOKwt,ii)-SloOwt(idOKwt,jj),SlowBulbWT(idOKwt,kk),'ko', 'markerfacecolor','k')
    hold on, plot(SloOko(idOKko,ii)-SloOko(idOKko,jj),SlowBulbKO(idOKko,kk),'ro', 'markerfacecolor','r')
    title(['SWS, ',ti{kk}])
    xlabel('Increase in High versus Low Slow oscillation')
    ylabel(ti{kk})
    end


    for kk=1:12
    figure('color',[1 1 1])
    ii=2;
    plot(SloOwt(idOKwt,ii),SlowBulbWT(idOKwt,kk),'ko', 'markerfacecolor','k')
    hold on, plot(SloOko(idOKko,ii),SlowBulbKO(idOKko,kk),'ro', 'markerfacecolor','r')
    title(['SWS, ',ti{kk}])
    xlabel('Ratio High versus Slow (%)')
    ylabel(ti{kk})
    end





    for kk=1:12
    figure('color',[1 1 1])
    ii=6;jj=9;
    plot(SloOwt(idOKwt,ii)-SloOwt(idOKwt,jj),SlowBulbWT(idOKwt,kk),'ko', 'markerfacecolor','k')
    hold on, plot(SloOko(idOKko,ii)-SloOko(idOKko,jj),SlowBulbKO(idOKko,kk),'ro', 'markerfacecolor','r')
    title(['Wake, ',ti{kk}])
    xlabel('Increase in High versus Low Slow oscillation')
    ylabel(ti{kk})
    end



end
