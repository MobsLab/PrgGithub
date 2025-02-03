
%ControlEffectStimOnFiringRate

load behavResources
load LFPData
load SpikeData
load StimMFB

bu=Range(Restrict(burst,SleepEpoch));
BurstEpoch=intervalSet(bu-300,bu+2000);
epoch2=SleepEpoch-BurstEpoch;
ParamRip=[3 5];
%ParamRip=[4 7];
Ripples=[];
for i=1:length(Start(epoch2))
try
FilRip=FilterLFP(Restrict(LFP{4},subset(epoch2,i)),[130 250],96);
filtered=[Range(FilRip,'s') Data(FilRip)];
rgFil=Range(FilRip,'s');
[ripples,stdev,noise] = FindRipples(filtered,'thresholds',ParamRip,'durations',[30 30 100]);
if length(ripples)>1
Ripples=[Ripples;ripples];
end
end
end


figure('color',[1 1 1]), [fh,sq,sweeps] =RasterPETH(S{35},ts(bu),-3000,3000);

figure('color',[1 1 1]), [fh,sq,sweeps] =RasterPETH(S{35},ts(bu),-3000,3000);
figure('color',[1 1 1]), [fh,sq,sweeps] =RasterPETH(S{1},ts(bu),-3000,3000);


figure('color',[1 1 1]), [fh,sq,sweeps] =RasterPETH(PoolNeurons(S,1:38),ts(bu),-3000,3000);

figure('color',[1 1 1]), [fh,sq,sweeps] =RasterPETH(PoolNeurons(S,[[1:34],[36:38]]),ts(bu),-3000,3000);
[C,B]=CrossCorr(Range(PoolNeurons(S,[[1:34],[36:38]])),Range(Restrict(S{35},SleepEpoch)),1,600);
figure('color',[1 1 1]), hold on
plot(Range(sq), Data(sq)/length(sweeps)/600)
plot(B*10,C,'r')
% 
% figure('color',[1 1 1]), hold on
% plot(Range(sq), rescale(Data(sq)/length(sweeps)/38,0,1))
% plot(B*10,rescale(C,0,1),'r')


figure('color',[1 1 1]), [fh,sq,sweeps] =RasterPETH(S{35},ts(Ripples(:,2)*1E4),-3000,3000);
figure('color',[1 1 1]), [fh,sq,sweeps] =RasterPETH(S{1},ts(Ripples(:,2)*1E4),-3000,3000);
figure('color',[1 1 1]), [fh,sq,sweeps] =RasterPETH(PoolNeurons(S,1:38),ts(Ripples(:,2)*1E4),-3000,3000);

for i=1:size(Ripples,1)
   idx=find(bu>(Ripples(i,2)-0.3)*1E4&bu<(Ripples(i,2)+0.3)*1E4);
   if length(idx)>1
       BUtemp=bu(idx);      
       BU(i)=BUtemp(1);
   else
       BU(i)=(Ripples(i,2)+0.3)*1E4;
   end
end
   
figure('color',[1 1 1]), [fh,sq,sweeps] =RasterPETH(S{35},ts(Ripples(:,2)*1E4),-3000,3000,'Markers',{ts(sort(BU))},'MarkerTypes',{'r+','r'});
figure ('color',[1 1 1]), [fh, rasterAx, histAx, matVal] = ImagePETH(LFP{4}, ts(Ripples(:,2)*1E4), -3000, +3000,'BinSize',50);


for i=1:size(bu,1)
   idx=find(Ripples(:,2)*1E4>bu(i)-0.3*1E4&Ripples(:,2)*1E4<bu(i)+0.3*1E4);
   if length(idx)>1
       RItemp=Ripples(idx,2);      
       RI(i)=RItemp(1);
   else
       RI(i)=bu(i)+0.3*1E4;
   end
end

figure('color',[1 1 1]), [fh,sq,sweeps] =RasterPETH(S{35},ts(bu),-3000,3000,'Markers',{ts(sort(RI))},'MarkerTypes',{'r+','r'});
figure ('color',[1 1 1]), [fh, rasterAx, histAx, matVal] = ImagePETH(LFP{4}, ts(bu), -3000, +6000,'BinSize',50);






figure('color',[1 1 1]), RasterPETH(S{35},ts(bu),-3000,3000);
figure('color',[1 1 1]), RasterPETH(S{35},ts(Ripples(:,2)*1E4),-3000,3000);

figure('color',[1 1 1]), RasterPETH(tsd(bu,bu),ts(Ripples(:,2)*1E4),-3000,3000);
figure('color',[1 1 1]), RasterPETH(tsd(Ripples(:,2)*1E4,Ripples(:,2)*1E4),ts(bu),-3000,3000);



figure('color',[1 1 1]), RasterPETH(tsd(bu,bu),Restrict(S{35},SleepEpoch),-2000,2000);
figure('color',[1 1 1]), RasterPETH(tsd(Ripples(:,2)*1E4,Ripples(:,2)*1E4),Restrict(S{35},SleepEpoch),-2000,2000);






listneurones=[2:24];

Qs = MakeQfromS(tsdArray({PoolNeurons(S,listneurones)}),10);
ratek=Qs;
rate = Data(ratek);
ratek = tsd(Range(ratek),rate(:,1));
figure, [fh, rasterAx, histAx, matVal] = ImagePETH(ratek, ts(bu), -2000, +2000,'BinSize',50);close
figure, [fh, rasterAx, histAx, matVal2] = ImagePETH(ratek, ts(s35), -2000, +2000,'BinSize',50);close
test=Data(matVal);
test2=Data(matVal2);
[h,p]=ttest2(test',test2');

load Waveforms
wfo=PlotWaveforms(W,35,SleepEpoch);
LargeSpk=squeeze(wfo(:,3,:));
[BE,id]=sort(LargeSpk(:,14));
figure('color',[1 1 1]), imagesc(LargeSpk(id,:)), caxis([-2500 2500])

nb=200;

figure('color',[1 1 1]), plot(mean(LargeSpk(id(1:nb),:)),'k')
hold on, plot(mean(LargeSpk(id(end-nb:end),:)),'r')

figure, [fh, rasterAx, histAx, matVal3] = ImagePETH(ratek, ts(sort(s35(id(1:nb)))), -2000, +2000,'BinSize',50);close
figure, [fh, rasterAx, histAx, matVal4] = ImagePETH(ratek, ts(sort(s35(id(end-nb:end)))), -2000, +2000,'BinSize',50);close
test3=Data(matVal3);
test4=Data(matVal4);
[h,p2]=ttest2(test3',test4');

[h,p3]=ttest2(test',test3');
[h,p4]=ttest2(test',test4');

figure('color',[1 1 1]), 
subplot(4,1,1), plot(rg,mean(test'),'k')
hold on, plot(rg,mean(test2'),'r')
plot(rg(find(p<0.01)),0.12*ones(length(find(p<0.01)),1),'bo','markerfacecolor','b')
line([0 0],[0 0.12],'color','b')

subplot(4,1,2), plot(rg,mean(test3'),'k')
hold on, plot(rg,mean(test4'),'r')
plot(rg(find(p2<0.01)),0.12*ones(length(find(p2<0.01)),1),'bo','markerfacecolor','b')
line([0 0],[0 0.12],'color','b')

subplot(4,1,3), plot(rg,mean(test'),'k')
hold on, plot(rg,mean(test3'),'r')
plot(rg(find(p3<0.01)),0.12*ones(length(find(p3<0.01)),1),'bo','markerfacecolor','b')
line([0 0],[0 0.12],'color','b')

subplot(4,1,4), plot(rg,mean(test'),'k')
hold on, plot(rg,mean(test4'),'r')
plot(rg(find(p4<0.01)),0.12*ones(length(find(p4<0.01)),1),'bo','markerfacecolor','b')
line([0 0],[0 0.12],'color','b')



if 0
    
        for i=1:length(S)
        Qs = MakeQfromS(S,50);
        %ratek = Restrict(Qs,intervalSet(st(1)-30000,to(end)+3000));
        ratek=Qs;
        rate = Data(ratek);
        ratek = tsd(Range(ratek),rate(:,i));

        figure, [fh, rasterAx, histAx, matVal] = ImagePETH(ratek, ts(Ripples(:,2)*1E4), -2000, +2000,'BinSize',50); title(cellnames{i}), close
        test=Data(matVal);
        figure, plot(Ripples(:,4),sum(test(30:51,:)),'k.'), title(cellnames{i})
        end



        Qs = MakeQfromS(tsdArray({PoolNeurons(S,1:37)}),50);
        %ratek = Restrict(Qs,intervalSet(st(1)-30000,to(end)+3000));
        ratek=Qs;
        rate = Data(ratek);
        ratek = tsd(Range(ratek),rate);


        figure, [fh, rasterAx, histAx, matVal] = ImagePETH(ratek, ts(Ripples(:,2)*1E4), -2000, +2000,'BinSize',50);
        test=Data(matVal);
        figure, plot(Ripples(:,4),sum(test(35:45,:)),'k.')


end
