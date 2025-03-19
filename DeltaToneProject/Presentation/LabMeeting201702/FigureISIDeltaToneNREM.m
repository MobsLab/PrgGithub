% FigureISIDeltaToneNREM
% 17.02.2017 KJ
%
% plot the quantification of ISI, for delta waves, in NREM
%
%
% see 
%   AnalysesISIDeltaToneSubstage AnalysesISIDeltaToneSubstagePlot QuantifISIDeltaToneSubstageNew FigureISITrig490
%  


%% PAIRED - per mouse

figure, hold on
%NREM - RdmTone
subplot(2,2,1), hold on
AnalysesISIDeltaToneSubstagePlot(6, 2, 'newfig',0,'isi_idx',1:3,'show_sig','none','paired',1); 
%NREM - 0ms
subplot(2,2,2), hold on
AnalysesISIDeltaToneSubstagePlot(6, 3, 'newfig',0,'isi_idx',1:3,'show_sig','none','paired',1);
%NREM - 320ms
subplot(2,2,3), hold on
AnalysesISIDeltaToneSubstagePlot(6, 5, 'newfig',0,'isi_idx',1:3,'show_sig','none','paired',1);
%NREM - 490ms
subplot(2,2,4), hold on
AnalysesISIDeltaToneSubstagePlot(6, 6, 'newfig',0,'isi_idx',1:3,'show_sig','none','paired',1);


%% NOT PAIRED - per nights

figure, hold on
%NREM - RdmTone
subplot(2,2,1), hold on
AnalysesISIDeltaToneSubstagePlot(6, 2, 'newfig',0,'isi_idx',1:3,'show_sig','none','paired',0); 
%NREM - 0ms
subplot(2,2,2), hold on
AnalysesISIDeltaToneSubstagePlot(6, 3, 'newfig',0,'isi_idx',1:3,'show_sig','none','paired',0);
%NREM - 320ms
subplot(2,2,3), hold on
AnalysesISIDeltaToneSubstagePlot(6, 5, 'newfig',0,'isi_idx',1:3,'show_sig','none','paired',0);
%NREM - 490ms
subplot(2,2,4), hold on
AnalysesISIDeltaToneSubstagePlot(6, 6, 'newfig',0,'isi_idx',1:3,'show_sig','none','paired',0);


%% PAIRED - per mouse - ORDER BY RANK

figure, hold on
%NREM - RdmTone
subplot(2,2,1), hold on
AnalysesISIDeltaToneSubstagePlot(6, 2, 'orderby', 'isi','isi_idx',1:3,'newfig',0,'show_sig','sig','paired',1); 
%NREM - 0ms
subplot(2,2,2), hold on
AnalysesISIDeltaToneSubstagePlot(6, 3, 'orderby', 'isi','isi_idx',1:3,'newfig',0','show_sig','sig','paired',1);
%NREM - 320ms
subplot(2,2,3), hold on
AnalysesISIDeltaToneSubstagePlot(6, 5, 'orderby', 'isi','isi_idx',1:3,'newfig',0','show_sig','sig','paired',1);
%NREM - 490ms
subplot(2,2,4), hold on
AnalysesISIDeltaToneSubstagePlot(6, 6, 'orderby', 'isi','isi_idx',1:3,'newfig',0','show_sig','sig','paired',1);


%% NOT PAIRED - per nights - ORDER BY RANK

figure, hold on
%NREM - RdmTone
subplot(2,2,1), hold on
AnalysesISIDeltaToneSubstagePlot(6, 2, 'orderby', 'isi','isi_idx',1:3,'newfig',0','show_sig','sig','paired',0);
set(gca,'XLim',[0 4000]);
%NREM - 0ms
subplot(2,2,2), hold on
AnalysesISIDeltaToneSubstagePlot(6, 3, 'orderby', 'isi','isi_idx',1:3,'newfig',0','show_sig','sig','paired',0);
set(gca,'XLim',[0 4000]);
%NREM - 320ms
subplot(2,2,3), hold on
AnalysesISIDeltaToneSubstagePlot(6, 5, 'orderby', 'isi','isi_idx',1:3,'newfig',0','show_sig','sig','paired',0);
set(gca,'XLim',[0 4000]);
%NREM - 490ms
subplot(2,2,4), hold on
AnalysesISIDeltaToneSubstagePlot(6, 6, 'orderby', 'isi','isi_idx',1:3,'newfig',0','show_sig','sig','paired',0);
set(gca,'XLim',[0 4000]);



%% N+2 - N+1 ...

figure, hold on
%NREM - RdmTone
subplot(2,1,1), hold on
AnalysesISIDeltaToneSubstagePlot(6, 6, 'orderby', 'tones','isi_idx',[1 4 5],'newfig',0','show_sig','none','paired',0);
set(gca,'XLim',[0 2000]);

subplot(2,1,2), hold on
AnalysesISIDeltaToneSubstagePlot(6, 6, 'orderby', 'isi','isi_idx',[1 4 5],'newfig',0','show_sig','sig','paired',0);
set(gca,'XLim',[0 2000]);




