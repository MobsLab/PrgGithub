function [test,test2,test3,test4,test5,test6,test7,test8,test9,rg]=EffectStimOnFiringRate(S,W,burst,SleepEpoch,PlaceCellTrig,listneurones,nchannelSpk,Celltypes);

% 
% cd /media/HardBackUp/DataSauvegarde/Mouse029/20120203/ICSS-Mouse-29-03022012
% 
% load SpikeData
% load behavResources
% load Waveforms
% load StimMFB

%PlaceCellTrig=35; 


sPl=Range(Restrict(S{PlaceCellTrig},SleepEpoch));



st=Range(Restrict(S{PlaceCellTrig},SleepEpoch),'s');
buSpk = burstinfo(st,0.02);
burstSpk=tsd(buSpk.t_start*1E4,buSpk.i_start);
idburstSpk=buSpk.i_start;


wfo=PlotWaveforms(W,PlaceCellTrig,SleepEpoch);close
LargeSpk=squeeze(wfo(:,nchannelSpk,:));
[BE,id]=sort(LargeSpk(:,14));
try
nb=200;
sPl2=sort(sPl(id(nb:end-nb)));
end

%listneurones=[2:24];
bu=Range(Restrict(burst,SleepEpoch));

Qs = MakeQfromS(tsdArray({PoolNeurons(S,listneurones)}),10);
ratek=Qs;
rate = Data(ratek);
ratek = tsd(Range(ratek),rate(:,1));
figure('color',[1 1 1]), [fh, rasterAx, histAx, matVal] = ImagePETH(ratek, ts(bu), -2000, +2000,'BinSize',50);title('Stim'),close
figure('color',[1 1 1]), [fh, rasterAx, histAx, matVal2] = ImagePETH(ratek, ts(sPl), -2000, +2000,'BinSize',50);title('Spikes'),close

figure('color',[1 1 1]), [fh, rasterAx, histAx, matVal3] = ImagePETH(ratek, ts(sPl2), -2000, +2000,'BinSize',50);title('Spikes corrected'),close
try
figure('color',[1 1 1]), [fh, rasterAx, histAx, matVal4] = ImagePETH(ratek, ts(sPl(idburstSpk)), -2000, +2000,'BinSize',50);title('Spikes burst'),close
end

idx=ismember([1:length(sPl)],idburstSpk);
nonburstSpk=find(idx==0);

figure('color',[1 1 1]), [fh, rasterAx, histAx, matVal5] = ImagePETH(ratek, ts(sPl(nonburstSpk)), -2000, +2000,'BinSize',50);title('Spikes non burst'),close

test=Data(matVal)/length(listneurones);
test2=Data(matVal2)/length(listneurones);
test3=Data(matVal3)/length(listneurones);
try
test4=Data(matVal4)/length(listneurones);
end
test5=Data(matVal5)/length(listneurones);
rg=Range(matVal);

CompareTestMatrix(test,test2,rg),title('Stim vs spikes')

CompareTestMatrix(test,test3,rg),title('Stim vs spikes corrected')
try
CompareTestMatrix(test,test4,rg),title('Stim vs spikes burst')
end
CompareTestMatrix(test,test5,rg),title('Stim vs spikes non burst')

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


try
    
        %-----------------------------
        %-Interneurons)---------------
        %-----------------------------

        interneurons=find(Celltypes==0);
        id=ismember(listneurones,interneurons);

        Qs = MakeQfromS(tsdArray({PoolNeurons(S,listneurones(find(id==1)))}),10);
        ratek=Qs;
        rate = Data(ratek);
        ratek = tsd(Range(ratek),rate(:,1));

        figure('color',[1 1 1]), [fh, rasterAx, histAx, matVal6] = ImagePETH(ratek, ts(bu), -2000, +2000,'BinSize',50);title('Interneurons vs Stim'),close
        figure('color',[1 1 1]), [fh, rasterAx, histAx, matVal7] = ImagePETH(ratek, ts(sPl), -2000, +2000,'BinSize',50);title('Interneurons vs spikes');close


        test6=Data(matVal6)/length(listneurones(find(id==1)));
        test7=Data(matVal7)/length(listneurones(find(id==1)));

        CompareTestMatrix(test,test6,rg),title('Stim vs Stim (interneurons)')
        CompareTestMatrix(test,test7,rg),title('Stim vs spikes (interneurons)')
        CompareTestMatrix(test6,test7,rg),title('Stim (interneuons) vs spikes (interneurons)')

        %-----------------------------
        %-Pyramidal-------------------
        %-----------------------------



        Pyramidal=find(Celltypes==1);
        id=ismember(listneurones,Pyramidal);

        Qs = MakeQfromS(tsdArray({PoolNeurons(S,listneurones(find(id==1)))}),10);
        ratek=Qs;
        rate = Data(ratek);
        ratek = tsd(Range(ratek),rate(:,1));

        figure('color',[1 1 1]), [fh, rasterAx, histAx, matVal8] = ImagePETH(ratek, ts(bu), -2000, +2000,'BinSize',50);title('Pyramidal vs Stim'),close
        figure('color',[1 1 1]), [fh, rasterAx, histAx, matVal9] = ImagePETH(ratek, ts(sPl), -2000, +2000,'BinSize',50);title('Pyramidal vs Spikes'),close

        test8=Data(matVal8)/length(listneurones(find(id==1)));
        test9=Data(matVal9)/length(listneurones(find(id==1)));


        CompareTestMatrix(test,test8,rg),title('Stim vs Stim (pyramidal)')
        CompareTestMatrix(test,test9,rg),title('Stim vs spikes (pyramidal)')
        CompareTestMatrix(test8,test9,rg),title('Stim (pyramidal) vs spikes (pyramidal)')

        CompareTestMatrix(test6,test8,rg),title('Stim (interneurons) vs Stim (pyramidal)')
        CompareTestMatrix(test7,test9,rg),title('Spikes (interneurons) vs spikes (pyramidal)')

%--------------------------------------------------------------------------

end



function CompareTestMatrix(testA,testB,rg,zsc)


try
    zsc;
catch
    zsc=0;
end


if zsc==1

    [h,p]=ttest2(testA',testB');

    psig=0.05;

    figure('color',[1 1 1]), hold on,
    plot(rg,mean(testA'),'k','linewidth',1)
    plot(rg,mean(testB'),'r','linewidth',1)
    yl=ylim;
    plot(rg(find(p<psig)),yl(2)*ones(length(find(p<psig)),1),'ko','markerfacecolor','k')
    line([0 0],[0 yl(2)],'color',[0.7 0.7 0.7])
    plot(rg,mean(testA'),'k','linewidth',1)
     plot(rg,mean(testB'),'r','linewidth',1)
    plot(rg(find(p<psig)),yl(2)*ones(length(find(p<psig)),1),'ko','markerfacecolor','k')



else

        figure('color',[1 1 1]), hold on,
    plot(rg,zscore(mean(testA')),'k','linewidth',1)
    plot(rg,zscore(mean(testB')),'r','linewidth',1)

        yl=ylim;

    line([0 0],[yl(1) yl(2)],'color',[0.7 0.7 0.7])
    plot(rg,zscore(mean(testA')),'k','linewidth',1)
    plot(rg,zscore(mean(testB')),'r','linewidth',1)

    
end

