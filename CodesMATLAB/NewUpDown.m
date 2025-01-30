function [UpN,DownN,TransitionUpDo,TransitionDoUp,listOK]=NewUpDown(yy,tps,DebutUp,FinUp,ThUpstate)

plo=1;

try
    ThUpstate;
catch
ThUpstate=2; %default value 2
end
DelUpstates=7000;

% tdebS=DebutUp'-0.3;
% tfinS=DebutUp'+0.3;
% tdebE=FinUp'-0.3;
% tfinE=FinUp'+0.3;
for i=1:20
 if DebutUp(1)*1E4-DelUpstates<tps(1)*1E4
     DebutUp=DebutUp(2:end);
  FinUp=FinUp(2:end);
 end
end

for i=1:20 
  if DebutUp(end)*1E4+DelUpstates>tps(end)*1E4
     DebutUp=DebutUp(1:end-1);
     FinUp=FinUp(1:end-1);
 end
end

nBinns=200;
[Cs,Vs,Bs]=mETAverage(DebutUp*1E4,tps*1E4,yy,10,nBinns);
[Ce,Ve,Be]=mETAverage(FinUp*1E4,tps*1E4,yy,10,nBinns);




        figure('Color',[1 1 1]), 
        nn=gcf;
        [fh, rasterAx, histAx, matValS] = ImagePETH(tsd(tps*1E4,(yy)), ts(DebutUp*1E4), -DelUpstates, +DelUpstates,'BinSize',100);
    
   
        figure('Color',[1 1 1]), 
        mm=gcf; 
        [fh, rasterAx, histAx, matValE] = ImagePETH(tsd(tps*1E4,(yy)), ts(FinUp*1E4), -DelUpstates, +DelUpstates,'BinSize',100);
   if plo==1
figure, plot(Range((matValS),'ms'), Data(matValS))
   else
       close
       close
   end
        
m=Data(matValS);
rrg=Range(matValS,'ms');
idp=find(rrg>200&rrg<600);
idn=find(rrg<-100&rrg>-400);
listUp=[];
    
        
 for i=1:length(DebutUp)
     
    % mean(m(idp,i))-mean(m(idn,i))

     if mean(m(idp,i))-mean(m(idn,i))>ThUpstate
         listUp=[listUp;i];
     end
 
 end
 

 
 if length(listUp)==0
     
     disp('short Upstates')
    idp=find(rrg>100&rrg<250);
    idn=find(rrg<-100&rrg>-400);
    listUp=[];


     for i=1:length(DebutUp)

        % mean(m(idp,i))-mean(m(idn,i))

         if mean(m(idp,i))-mean(m(idn,i))>ThUpstate
             listUp=[listUp;i];
         end

     end 
     
 end
 
 
 
 
 
 
 DebutUp=DebutUp(listUp);
 FinUp=FinUp(listUp); 
 

 
         figure('Color',[1 1 1]), 
        nn=gcf;
        [fh, rasterAx, histAx, matValS] = ImagePETH(tsd(tps*1E4,zscore(yy)), ts(DebutUp*1E4), -DelUpstates, +DelUpstates,'BinSize',100);
    
   
        figure('Color',[1 1 1]), 
        mm=gcf; 
        [fh, rasterAx, histAx, matValE] = ImagePETH(tsd(tps*1E4,zscore(yy)), ts(FinUp*1E4), -DelUpstates, +DelUpstates,'BinSize',100);
         if plo==1
        figure, plot(Range((matValS),'ms'), Data(matValS))
        figure, plot(Range((matValE),'ms'), Data(matValE))
         end
sS=0;
sE=0;

% [Ce,Ve,Be]=ETAverage(FinUp,tps,yy,0.01,nBinns);

try
    percS=fitsigmoid(Bs,Cs);
catch
    try
    percS=fitsigmoid(Bs(20:end-20),Cs(20:end-20));
    sS=1;
    catch
    percS=fitsigmoid(Bs(60:end-60),Cs(60:end-60));
    sS=1;
        
    end
    
end

    
try
    
percE=fitsigmoid(Be,Ce);
catch
    try
    percE=fitsigmoid(Be(20:end-20),Ce(20:end-20));
    sE=1;
    catch
        percE=fitsigmoid(Be(60:end-60),Ce(60:end-60));
        sE=2;
    end
    
end


dds=Data(matValS);
tts=Range(matValS,'ms');

dde=Data(matValE);
tte=Range(matValE,'ms');


a=1;
listOK=[];

%keyboard
for i=1:size(dds,2)
try
    
     if sE==1
     [percEm(a),VmaxE(a),EC50E(a),TE(a,:),VE(a,:),tdeb2,tfin2]=fitsigmoid(tte(20:end-20),dde(20:end-20,i));
     elseif sE==2
     [percEm(a),VmaxE(a),EC50E(a),TE(a,:),VE(a,:),tdeb2,tfin2]=fitsigmoid(tte(60:end-60),dde(60:end-60,i));
     
     else
    [percEm(a),VmaxE(a),EC50E(a),TE(a,:),VE(a,:),tdeb2,tfin2]=fitsigmoid(tte,dde(:,i));
     end
    
    if sS==1
    [percSm(a),VmaxS(a),EC50S(a),TS(a,:),VS(a,:),tdeb,tfin]=fitsigmoid(tts(20:end-20),dds(20:end-20,i));
    elseif sS==2
    [percSm(a),VmaxS(a),EC50S(a),TS(a,:),VS(a,:),tdeb,tfin]=fitsigmoid(tts(60:end-60),dds(60:end-60,i));   
    else
    [percSm(a),VmaxS(a),EC50S(a),TS(a,:),VS(a,:),tdeb,tfin]=fitsigmoid(tts,dds(:,i));
        
    end
    
    
    tdebS(a)=DebutUp(i)+tts(1)/1E3+tdeb/1E3;
    tfinS(a)=DebutUp(i)+tts(1)/1E3+tfin/1E3;
    clear tdeb
    clear tfin
    
    tdebE(a)=FinUp(i)+tte(1)/1E3+tfin2/1E3;
    tfinE(a)=FinUp(i)+tte(1)/1E3+tdeb2/1E3;
    clear tdeb2
    clear tfin2  
    
    
    a=a+1;
    listOK=[listOK,i];
% catch
%     percSm(i)=NaN;
end
end





PercEm=nanmean(percEm);
PercSm=nanmean(percSm);


figure(nn)
title(['transition ',num2str(percS),' ms, ',num2str(PercSm),' ms, '])

figure(mm), 
title(['transition ',num2str(percE),' ms, ',num2str(PercEm),' ms, '])

UpN=[tfinS' tdebE'];
%DownN=[tfinE(1:end-1)' tdebS(2:end)'];

DownN=[[tps(1) tdebS(1)]; [tfinE(1:end-1)' tdebS(2:end)']; [tfinS(end) tps(end)]];

TransitionUpDo=[tdebS' tfinS'];
TransitionDoUp=[tdebE' tfinE'];




