% Granger_ToolKB_SlidingWindow
% 27.05.2015  
% tested parameters : 
% - size of the window : 10 sec ok (tested : 3, 10 sec)
% - filtering the data: subsampling Fs= btw 80 and 120 ok 
% cd /media/DataMOBsRAID/ProjetAstro/Mouse246/20150323/BULB-Mouse-245-246-23032015

ch=[2 14 5 4 7 6];
cd /media/DataMOBsRAID/ProjetAstro-DataPlethysmo/Mouse149/20140805

deb=600;

clear GT  % Matrice Granger total  / Gti : cell array, même données
clear Peri % Matrice Periode (SWS REM Wake) total 
clear Ct % Matrice Causal flow total


a=1;
for i=1:100
    deb=deb+10;
    [GC2,causf,Peri,nameCh]=Granger_ToolKB(deb,ch);
    Gti{a}=GC2;
    a=a+1;
    try
    GT=[GT+GC2];
    Ct=[Ct;causf.flow]; 
    Pt=[Pt;Peri]; 
    catch
    GT=[GC2];
    Ct=causf.flow;
    Pt=Peri;
    end
end



figure(20),
% proportion of SWS REM Wake
subplot(1,3,1), PlotErrorBarN(Pt,0);
set(gca,'XTick',[1:3]);
set(gca,'XTickLabel',{'SWS','Wake', 'REM'});
xlim([0 4])
% mean Causal flow 
subplot(1,3,2), PlotErrorBarN(Ct,0);
set(gca,'XTick',[1:length(nameCh)]);
set(gca,'XTickLabel',nameCh);
xlim([0 length(nameCh)+2])
% Granger (summed)
subplot(1,3,3), imagesc(GT);
set(gca,'XTick',[1:length(nameCh)]);
set(gca,'XTickLabel',nameCh);
set(gca,'YTick',[1:length(nameCh)]);
set(gca,'YTickLabel',nameCh);



