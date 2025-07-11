function [REMEpochC,WakeC,SWSEpochC,SleepStagesC,ToTalNoiseEpochC,DurRealign]=RealignREM(Wake,SWSEpoch,REMEpoch,plo)%,SleepStage, Wake, SWSEPoch, TotalNoiseEpoch)

try
    plo;
catch
    plo=0;
end

try
    lim;
catch
    
   lim=3;
end


res=pwd;
try
    tempchBulb=load([res,'/ChannelsToAnalyse/dHPC_rip.mat'],'channel');
catch
    tempchBulb=load([res,'/ChannelsToAnalyse/dHPC_deep.mat'],'channel');
end
chBulb=tempchBulb.channel;
eval(['load(''',res,'','/LFPData/LFP',num2str(chBulb),'.mat'');'])

% load H_Low_Spectrum ch
% eval(['load(''',res,'','/LFPData/LFP',num2str(ch),'.mat'');'])

en=End(REMEpoch,'s');
st=Start(REMEpoch,'s');
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
        elseif limSt(i)-st(i)>lim*1E4
          limSt(i)=st(i);   
        end
    catch
        limSt(i)=st(i);      
    end

end



id=find(limSt>limEn); %id
%length(limSt)-length(id)

limSt(id)=st(id);
limEn(id)=en(id);

DurRealign(1)=sum(abs(limSt-st'))/length(limSt);
DurRealign(2)=sum(abs(limEn-en')/length(limSt));

% REMEpochC=intervalSet(limSt(id)*1E4,limEn(id)*1E4);
REMEpochC=intervalSet(limSt*1E4,limEn*1E4);
if plo==1
    figure('color',[1 1 1]), numfig=gcf;
    subplot(2,1,1)
SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0,[],REMEpochC);
elseif plo==2
    SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0,[],REMEpochC);
end
if plo==0
    SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,1,[],REMEpochC);
    close
end

stg=Data(SleepStages);

%idx=find(abs(diff(stg))>0);

idOldREM=find(stg==3);
for i=1:length(idOldREM)
    if stg(idOldREM(i)-1)~=2
        stg(idOldREM(i))=stg(idOldREM(i)-1);
    end
end

idOldREM=find(stg==3);
for i=length(idOldREM):-1:1
    if stg(idOldREM(i)+1)~=2
        stg(idOldREM(i))=stg(idOldREM(i)+1);
    end
end

stg(stg==2)=3;

SleepStagesC=tsd(Range(SleepStages),stg);

TempEpoch1=thresholdIntervals(SleepStagesC,-1.5,'Direction','Above');
TempEpoch2=thresholdIntervals(SleepStagesC,-0.5,'Direction','Below');
ToTalNoiseEpochC=and(TempEpoch1,TempEpoch2);

TempEpoch1=thresholdIntervals(SleepStagesC,0.5,'Direction','Above');
TempEpoch2=thresholdIntervals(SleepStagesC,1.5,'Direction','Below');
SWSEpochC=and(TempEpoch1,TempEpoch2);

TempEpoch1=thresholdIntervals(SleepStagesC,2.5,'Direction','Above');
TempEpoch2=thresholdIntervals(SleepStagesC,3.5,'Direction','Below');
REMEpochC=and(TempEpoch1,TempEpoch2);

TempEpoch1=thresholdIntervals(SleepStagesC,3.5,'Direction','Above');
TempEpoch2=thresholdIntervals(SleepStagesC,4.5,'Direction','Below');
WakeC=and(TempEpoch1,TempEpoch2);

if plo==1
    figure(numfig)
    subplot(2,1,2)
    PlotSleepStage(WakeC,SWSEpochC,REMEpochC,0);
end
