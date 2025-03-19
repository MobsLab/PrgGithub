
cd('/media/DataMOBs29/M255/20150826-SLEEP-JAWS/20150826-SLEEP-jaws/FEAR-Mouse-255-26082015');

load behavResources
load Diode
load SpikeData.mat


diode_ON_segt1=And(diode_ON_segt,diode_ON_period1);
ON_per1=Start(diode_ON_segt1);

diode_ON_segt2=And(diode_ON_segt,diode_ON_period2);
ON_per2=Start(diode_ON_segt2);

% cleanMUA=[];
% for i=1:size(S,2)
%     if i~=5 && i~=10
%         cleanMUA=[cleanMUA;Range(S{i})];
%     end
% end
% cleanMUA=sort(cleanMUA);
% figure, [fh,sq,sweeps] = RasterPETH(ts(cleanMUA), ts(ON_per1), -120000,+130000,'BinSize',1000);%'Markers',{ts(en)},'MarkerTypes',{'r*','r'}

for i=1:size(S,2)
    
figure, [fh,sq,sweeps] = RasterPETH(S{i}, ts(ON_per2), -120000,+130000,'BinSize',1000);%'Markers',{ts(en)},'MarkerTypes',{'r*','r'}

title(cellnames{i})
end


figure, ImagePETH(LFP, ts(ON_per1), -2200,+4300,'BinSize',20);
figure, ImagePETH(LFP, ts(ON_per2), -2200,+4300,'BinSize',20);

Fil=FilterLFP(LFP,[2 5],1024);
Pow=tsd(Range(Fil),abs(hilbert(Data(Fil)))); 

figure, ImagePETH(Pow, ts(ON_per1), -2200,+4300,'BinSize',20);
figure, ImagePETH(Pow, ts(ON_per1), -220000,+430000,'BinSize',20);

figure, ImagePETH(Pow, ts(ON_per2), -22000,+43000,'BinSize',20);