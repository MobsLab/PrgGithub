function REMEpoch2=ReAlignREMSleepTransition(REMEpoch)


res=pwd;

try
tempchHpc=load([res,'/ChannelsToAnalyse/dHPC_rip.mat'],'channel');
catch
tempchHpc=load([res,'/ChannelsToAnalyse/dHPC_deep.mat'],'channel');
end
chHpc=tempchHpc.channel;
eval(['load(''',res,'','/LFPData/LFP',num2str(chHpc),'.mat'');'])

en=End(REMEpoch,'s');
st=Start(REMEpoch,'s');
clear limEn
clear limSt

for i=1:length(en)
    try
        TempEpoch=intervalSet((en(i)-10)*1E4, (en(i)+10)*1E4);
        Fil=FilterLFP(Restrict(LFP,TempEpoch),[6 9],1024);
        hil=hilbert(Data(Fil));
        Hil=tsd(Range(Fil),abs(hil));
        Hil=FilterLFP(Hil,[0.01 0.5],2048);
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
        TempEpoch=intervalSet((st(i)-10)*1E4, (st(i)+10)*1E4);
        Fil=FilterLFP(Restrict(LFP,TempEpoch),[6 9],1024);
        hil=hilbert(Data(Fil));
        Hil=tsd(Range(Fil),abs(hil));
        Hil=FilterLFP(Hil,[0.01 0.5],2048);
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

id=find(limSt<limEn); 
disp(num2str(length(limSt)-length(id)))
REMEpoch2=intervalSet(limSt(id)*1E4,limEn(id)*1E4);
        
        