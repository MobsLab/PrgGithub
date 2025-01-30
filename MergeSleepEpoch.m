function [StateEp,TotalEpoch,StateEpochC,REMEpoch2]=MergeSleepEpoch(chEpoch,op)


%SleepStages -1: noise; 1 SWS; 2 opEpoch; 3 REM; 4 Wake

try
    op;
catch
    op=0;
end

limInf=3;
limSup=20;

load StateEpochSB SWSEpoch Wake REMEpoch TotalNoiseEpoch

try
    chEpoch;
    SWSEpoch=and(SWSEpoch,chEpoch);
    Wake=and(Wake,chEpoch);
    REMEpoch=and(REMEpoch,chEpoch);
    TotalNoiseEpoch=and(TotalNoiseEpoch,chEpoch);
end


try
        REMEpoch2=mergeCloseIntervals(REMEpoch,10E4);
        REMEpoch2=dropShortIntervals(REMEpoch,5E4);
        SWSEpoch2=SWSEpoch-REMEpoch2;
        TotalNoiseEpoch2=TotalNoiseEpoch-REMEpoch2;
        Wake2=Wake-REMEpoch2;


        res=pwd;
        tempchBulb=load([res,'/ChannelsToAnalyse/dHPC_deep.mat'],'channel');
        chBulb=tempchBulb.channel;
        eval(['load(''',res,'','/LFPData/LFP',num2str(chBulb),'.mat'');'])

        en=End(REMEpoch2,'s');
        st=Start(REMEpoch2,'s');
        clear limEn
        clear limSt
        for i=1:length(en)
            try
                TempEpoch=intervalSet((en(i)-5)*1E4, (en(i)+5)*1E4);
                Fil=FilterLFP(Restrict(LFP,TempEpoch),[5 10],1024);
                hil=hilbert(Data(Fil));
                Hil=tsd(Range(Fil),abs(hil));
                tpstemp=Range(Hil);
                [Perc,Vmax,EC50,T,V,tdeb,tfin,f,x,p,k,perc1,perc2]=fitsigmoid(Range(Hil),Data(Hil),0);
                limEn(i)=(tpstemp(1)+mean([perc1,perc2])*(tpstemp(end)-tpstemp(1))/100)/1E4;
                if isnan(limEn(i))
                 limEn(i)=en(i);
                  elseif limEn(i)-en(i)>4E4
                  limEn(i)=en(i);  
                end
            catch
                limEn(i)=en(i);       
            end

        end

        for i=1:length(st)
            try
                TempEpoch=intervalSet((st(i)-5)*1E4, (st(i)+5)*1E4);
                Fil=FilterLFP(Restrict(LFP,TempEpoch),[5 10],1024);
                hil=hilbert(Data(Fil));
                Hil=tsd(Range(Fil),abs(hil));
                tpstemp=Range(Hil);
                [Perc,Vmax,EC50,T,V,tdeb,tfin,f,x,p,k,perc1,perc2]=fitsigmoid(Range(Hil),Data(Hil),0);
                limSt(i)=(tpstemp(1)+mean([perc1,perc2])*(tpstemp(end)-tpstemp(1))/100)/1E4;
                if isnan(limSt(i))
                 limSt(i)=st(i); 
                elseif limSt(i)-st(i)>4E4
                  limSt(i)=st(i);   
                end
            catch
                limSt(i)=st(i);      
            end

        end
        id=find(limSt<limEn); length(limSt)-length(id)
        REMEpoch3=intervalSet(limSt(id)*1E4,limEn(id)*1E4);
end


SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch);

try
TotalEpoch=or(or(SWSEpoch,Wake),or(REMEpoch,TotalNoiseEpoch));
catch
    rg=Range(SleepStages);
    TotalNoiseEpoch=intervalSet(rg(1),rg(end))-SWSEpoch-Wake-REMEpoch;
    TotalEpoch=or(or(SWSEpoch,Wake),or(REMEpoch,TotalNoiseEpoch));
end




stTE=Start(TotalEpoch);
enTE=End(TotalEpoch);
EpochN=intervalSet(enTE(1:end-1),stTE(2:end));
TotalEpoch=or(TotalEpoch,EpochN);

for i=1:length(Start(TotalEpoch))
    temp=Data(Restrict(SleepStages,subset(TotalEpoch,i)));
    if length(temp)==0; 
         StateEp(i,1)=-1;
         StateEp(i,2)=End(subset(TotalEpoch,i),'s')-Start(subset(TotalEpoch,i),'s');
    else
        StateEp(i,1)=temp(floor(length(temp/2)));
        StateEp(i,2)=End(subset(TotalEpoch,i),'s')-Start(subset(TotalEpoch,i),'s');
     end
end

   
    
for i=1:size(StateEp,1)     
      if StateEp(i,1)==-1
          if StateEp(i-1,1)==4&StateEp(i+1,1)==4&StateEp(i-1,1)<30
          StateEp(i,1)=5;              
          end     
      end

      if StateEp(i,1)==3
          if StateEp(i-1,1)==1&StateEp(i+1,1)==4&StateEp(i-1,1)<5
          StateEp(i,1)=4;              
          end  
      end         
end

id=find(diff(StateEp(:,1))==0);
stTE=Start(TotalEpoch);
enTE=End(TotalEpoch);
stTE(id+1)=[];
enTE(id)=[];
TotalEpoch=intervalSet(stTE,enTE);
    
clear StateEp
 for i=1:length(Start(TotalEpoch))
    temp=Data(Restrict(SleepStages,subset(TotalEpoch,i)));
    if length(temp)==0; 
         StateEp(i,1)=-1;
         StateEp(i,2)=End(subset(TotalEpoch,i),'s')-Start(subset(TotalEpoch,i),'s');
    else
        StateEp(i,1)=temp(floor(length(temp/2)));
        StateEp(i,2)=End(subset(TotalEpoch,i),'s')-Start(subset(TotalEpoch,i),'s');
     end
end
   
    
    
 

  StateEpochC{1}=subset(TotalEpoch,find(StateEp(:,1)==4)); 
  StateEpochC{2}=subset(TotalEpoch,find(StateEp(:,1)==1));
  StateEpochC{3}=subset(TotalEpoch,find(StateEp(:,1)==3));  %REM
  StateEpochC{4}=subset(TotalEpoch,find(StateEp(:,1)==-1));
  
  

  
  %--------------------------------------------------------------------
  
  
  
  
  
  figure('color',[1 1 1]), 
subplot(2,2,1), hist(End(StateEpochC{2},'s')-Start(StateEpochC{2},'s'),[0:0.5:25]), title('SWS'),xlim([0 20])
subplot(2,2,2), hist(End(StateEpochC{3},'s')-Start(StateEpochC{3},'s'),[0:0.5:25]), title('REM'),xlim([0 20])
subplot(2,2,3), hist(End(StateEpochC{1},'s')-Start(StateEpochC{1},'s'),[0:0.5:25]), title('Wake'),xlim([0 20])
subplot(2,2,4), hist(End(StateEpochC{4},'s')-Start(StateEpochC{4},'s'),[0:0.5:25]), title('Noise'),xlim([0 20])

figure('color',[1 1 1]), 
subplot(2,2,1), hist(End(SWSEpoch,'s')-Start(SWSEpoch,'s'),[0:0.5:25]), title('SWS initial'),xlim([0 20])
subplot(2,2,2), hist(End(REMEpoch,'s')-Start(REMEpoch,'s'),[0:0.5:25]), title('REM initial'),xlim([0 20])
subplot(2,2,3), hist(End(Wake,'s')-Start(Wake,'s'),[0:0.5:25]), title('Wake initial'),xlim([0 20])
subplot(2,2,4), hist(End(TotalNoiseEpoch,'s')-Start(TotalNoiseEpoch,'s'),[0:0.5:25]), title('Noise initial'),xlim([0 20])



idI=find(StateEp(:,2)<limInf);
idIxN=find(StateEp(idI,1)==-1);
idIxS=find(StateEp(idI,1)==1);
idIxR=find(StateEp(idI,1)==3);
idIxW=find(StateEp(idI,1)==4);



figure('color',[1 1 1]), 
subplot(5,2,1), 
hist(StateEp(idI,1),-1:5)
set(gca,'xtick',[-1:4])
set(gca,'xticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
xlim([-2 6])
title(['Short Epochs <',num2str(limInf),'s'])

subplot(5,2,3), 
hist(StateEp(idI(idIxN)-1,1),-1:5)
set(gca,'xtick',[-1:4])
set(gca,'xticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
xlim([-2 6])
ylabel('Noise')

subplot(5,2,4), 
try
hist(StateEp(idI(idIxN)+1,1),-1:5)
catch
  hist(StateEp(idI(idIxN(1:end-1))+1,1),-1:5)  
end
set(gca,'xtick',[-1:4])
set(gca,'xticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
xlim([-2 6])


subplot(5,2,5), 
hist(StateEp(idI(idIxS)-1,1),-1:5)
set(gca,'xtick',[-1:4])
set(gca,'xticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
xlim([-2 6])
ylabel('SWS')

subplot(5,2,6), 
hist(StateEp(idI(idIxS)+1,1),-1:5)
set(gca,'xtick',[-1:4])
set(gca,'xticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
xlim([-2 6])

subplot(5,2,7), 
hist(StateEp(idI(idIxR)-1,1),-1:5)
set(gca,'xtick',[-1:4])
set(gca,'xticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
xlim([-2 6])
ylabel('REM')

subplot(5,2,8), 
hist(StateEp(idI(idIxR)+1,1),-1:5)
set(gca,'xtick',[-1:4])
set(gca,'xticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
xlim([-2 6])

subplot(5,2,9), 
hist(StateEp(idI(idIxW)-1,1),-1:5)
set(gca,'xtick',[-1:4])
set(gca,'xticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
xlim([-2 6])
ylabel('Wake')

subplot(5,2,10), 
hist(StateEp(idI(idIxW)+1,1),-1:5)
set(gca,'xtick',[-1:4])
set(gca,'xticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
xlim([-2 6])





id=find(StateEp(:,2)>20);
idxN=find(StateEp(id,1)==-1);
idxS=find(StateEp(id,1)==1);
idxR=find(StateEp(id,1)==3);
idxW=find(StateEp(id,1)==4);






figure('color',[1 1 1]), 
subplot(5,2,1), 
hist(StateEp(id,1),-1:5)
set(gca,'xtick',[-1:4])
set(gca,'xticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
xlim([-2 5])
title(['Long Epochs >',num2str(limSup),'s'])

subplot(5,2,3), 
hist(StateEp(id(idxN)-1,1),-1:5)
set(gca,'xtick',[-1:4])
set(gca,'xticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
xlim([-2 5])
ylabel('Noise')

subplot(5,2,4), 
hist(StateEp(id(idxN)+1,1),-1:5)
set(gca,'xtick',[-1:4])
set(gca,'xticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
xlim([-2 5])


subplot(5,2,5), 
hist(StateEp(id(idxS)-1,1),-1:5)
set(gca,'xtick',[-1:4])
set(gca,'xticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
xlim([-2 5])
ylabel('SWS')

subplot(5,2,6), 
hist(StateEp(id(idxS)+1,1),-1:5)
set(gca,'xtick',[-1:4])
set(gca,'xticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
xlim([-2 5])

subplot(5,2,7), 
hist(StateEp(id(idxR)-1,1),-1:5)
set(gca,'xtick',[-1:4])
set(gca,'xticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
xlim([-2 5])
ylabel('REM')

subplot(5,2,8), 
hist(StateEp(id(idxR)+1,1),-1:5)
set(gca,'xtick',[-1:4])
set(gca,'xticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
xlim([-2 5])

subplot(5,2,9), 
try
hist(StateEp(id(idxW)-1,1),-1:5)
catch
hist(StateEp(id(idxW(2:end))-1,1),-1:5)    
end

set(gca,'xtick',[-1:4])
set(gca,'xticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
xlim([-2 5])
ylabel('Wake')

subplot(5,2,10), 
hist(StateEp(id(idxW)+1,1),-1:5)
set(gca,'xtick',[-1:4])
set(gca,'xticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
xlim([-2 5])


% 
% idI=find(StateEp(:,2)<limInf);
% idIxN=find(StateEp(idI,1)==-1);
% idIxS=find(StateEp(idI,1)==1);
% idIxR=find(StateEp(idI,1)==3);
% idIxW=find(StateEp(idI,1)==4);
% 
% 





% 
% 
% res=pwd;
% load LFPData/InfoLFP
% 
% for i=1:30
%     
%     try
%         
%         eval(['load(''',res,'','/SpectrumDataH/Spectrum',num2str(i),'.mat'');'])
% Stsd=tsd(t*1E4,Sp);
% figure('color', [1 1 1]),
% a=1;
% 
% for Sta=[-1 1 3 4]
%     try
% id=find(StateEp(:,2)<5);
% idxR=find(StateEp(id,1)==Sta);
% id2=find(StateEp(:,2)>15);
% idxR2=find(StateEp(id2,1)==Sta);
% subplot(2,2,1), ylabel(InfoLFP.structure(i))
% subplot(2,2,a), hold on
% plot(f,mean(Data(Restrict(Stsd,subset(TotalEpoch,id(idxR))))),'r','linewidth',2)
% hold on, plot(f,mean(Data(Restrict(Stsd,subset(TotalEpoch,id2(idxR2))))),'k','linewidth',2)
% ylim([0 5E4])
% switch Sta
%     case -1
%     title('Noise')
%     case 1
%      title('SWS') 
%     case 3
%      title('REM') 
%     case 4
%      title('Wake')      
% end
% 
% a=a+1;
%     end
% end
% 
% 
%     end
% end
% 
% 



