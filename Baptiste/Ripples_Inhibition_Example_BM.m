

figure

%% Rip control
load('/media/nas7/ProjetEmbReact/Mouse1531/20231123/ProjectEmbReact_M41531_20231123_UMazeCondExplo_PostDrug/Cond3/LFPData/LFP63.mat')
load('/media/nas7/ProjetEmbReact/Mouse1531/20231123/ProjectEmbReact_M41531_20231123_UMazeCondExplo_PostDrug/Cond3/Cluster/SpikeData.mat')
load('/media/nas7/ProjetEmbReact/Mouse1531/20231123/ProjectEmbReact_M41531_20231123_UMazeCondExplo_PostDrug/Cond3/behavResources.mat', 'StimEpoch2')
Fil_Low = FilterLFP(LFP,[1 250],1024);

Window = [331.85 332.25];
St=Start(StimEpoch2);
i=find(St>Window(1)*1e4,1,'first');
SmallEp = intervalSet(Window(1)*1e4 , Window(2)*1e4);
LFP_to_use = Restrict(Fil_Low,SmallEp);

for i=1:40
    bin = intervalSet(Window(1)*1e4+(i-1)*1e2 , Window(1)*1e4+i*1e2);
    for n=1:length(S)
        Spike_density(i,n) = length(Restrict(S{n} , bin));
    end
end

subplot(321)
A=resample(Data(LFP_to_use) , 30 , 1);
plot(A + [zeros(1,12980) linspace(1e4,3e3,2020)]', 'Color' , [0 0 0]), hold on
vline(7.2e3 , '--r'), plot(1.26e4,4517,'*g')
xlim([0 length(A)-100]), ylim([-5e3 5e3])
axis off

subplot(323)
area(runmean(sum(Spike_density')*100,1) , 'FaceColor' , [.3 .3 .3] , 'LineWidth' , 4)
xticks([0 20 40]), xticklabels({'','',''}), ylim([0 1.2e3]), ylabel('MUA (Hz)')
vline(19.5,'--r')
makepretty_BM2

subplot(325)
RasterPlot_SB(S,'FigureHandle',1)
xlim([Window(1)*1e3 , Window(2)*1e3])
xticks([Window(1)*1e3  nanmean(Window)*1e3  Window(2)*1e3]), xticklabels({'-200','0','+200'})
vline(Window(1)*1e3 + 192, '--r'), xlabel('time (ms)'), ylabel('HPC no')
makepretty_BM
makepretty_BM2


%% Rip inhib
load('/media/nas7/ProjetEmbReact/Mouse1531/20231123/ProjectEmbReact_M41531_20231123_UMazeCondExplo_PostDrug/Cond3/test/LFPData/LFP63.mat')
Fil_Low = FilterLFP(LFP,[1 250],1024);

Window = [18.8 19.2];
SmallEp = intervalSet(Window(1)*1e4 , Window(2)*1e4);
LFP_to_use = Restrict(Fil_Low,SmallEp);
D3 = Data(LFP_to_use);

for i=1:40
    bin = intervalSet(Window(1)*1e4+(i-1)*1e2 , Window(1)*1e4+i*1e2);
    for n=1:length(S)
        Spike_density(i,n) = length(Restrict(S{n} , bin));
    end
end

subplot(322)
D3_corr = D3 + [zeros(1,2924) -linspace(3.28e4,5e3,86) -linspace(5e3,0,110) linspace(3e3,1e4,752) linspace(1e4,8e3,4128)]';
plot(resample(D3_corr , 1 , 16) , '-k'), hold on
ylim([-5e3 5e3])
vline(184 , '--r'), plot(175,3700,'*g')
axis off

subplot(324)
area(runmean(sum(Spike_density')*100,1) , 'FaceColor' , [.3 .3 .3] , 'LineWidth' , 4)
xticks([0 20 40]), xticklabels({'','',''}), ylim([0 1.2e3])
vline(15.3, '--r')
makepretty_BM2

subplot(326)
RasterPlot(S)
xlim([Window(1)*1e3 , Window(2)*1e3])
xticks([Window(1)*1e3  nanmean(Window)*1e3  Window(2)*1e3]), xticklabels({'-200','0','+200'})
vline(Window(1)*1e3 + 153, '--r'), xlabel('time (ms)')
makepretty_BM
makepretty_BM2





%% 0V

load('/media/nas7/ProjetEmbReact/Mouse1531/20231122/ProjectEmbReact_M1531_20231122_CalibrationVHC_0,999V_1ms/LFPData/LFP41.mat')
load('/media/nas7/ProjetEmbReact/Mouse1531/20231122/ProjectEmbReact_M1531_20231122_CalibrationVHC_0,999V_1ms//SpikeData.mat')



figure

Window = [37.8 38.2];
SmallEp = intervalSet(Window(1)*1e4 , Window(2)*1e4);

LFP_to_use = Restrict(LFP,SmallEp);

for i=1:40
    bin = intervalSet(Window(1)*1e4+(i-1)*1e2 , Window(1)*1e4+i*1e2);
    for n=1:length(S)
        Spike_density(i,n) = length(Restrict(S{n} , bin));
    end
end


subplot(311)
A=resample(Data(LFP_to_use) , 30 , 1);
% plot(A , 'Color' , [0 0 0])
plot(A + [zeros(1,8629) linspace(2.3e4,0,15e3-8629)]', 'Color' , [0 0 0])
xlim([0 length(A)]), ylim([-1e4 1e4])
axis off

subplot(312)
area(runmean(sum(Spike_density')*100,1) , 'FaceColor' , [.3 .3 .3] , 'LineWidth' , 4)
xticklabels({''}), ylabel('MUA (Hz)'), ylim([0 2e3])
makepretty_BM2

subplot(313)
RasterPlot_SB(S,'FigureHandle',1)
xlim([Window(1)*1e3 , Window(2)*1e3])
xticks([Window(1)*1e3  nanmean(Window)*1e3  Window(2)*1e3]), xticklabels({'-100','0','+100'})
xlabel('time (ms)'), ylabel('Neuron no.')
makepretty_BM
makepretty_BM2






% No stim
Window = [294.2 294.6];
SmallEp = intervalSet(Window(1)*1e4 , Window(2)*1e4);

Fil_Low = FilterLFP(LFP,[1 250],1024);
LFP_to_use = Restrict(Fil_Low,SmallEp);

for i=1:40
    bin = intervalSet(Window(1)*1e4+(i-1)*1e2 , Window(1)*1e4+i*1e2);
    for n=1:length(S)
        Spike_density(i,n) = length(Restrict(S{n} , bin));
    end
end


subplot(331)
A=resample(Data(LFP_to_use) , 30 , 1);
plot(A , 'Color' , [0 0 0])
xlim([0 length(A)-100]), ylim([-5e3 5e3])
axis off

subplot(334)
area(runmean(sum(Spike_density')*100,1) , 'FaceColor' , [.3 .3 .3] , 'LineWidth' , 4)
xticks([0 20 40]), xticklabels({'','',''}), ylabel('MUA (Hz)'), ylim([0 1.2e3])
makepretty_BM2

subplot(337)
RasterPlot_SB(S,'FigureHandle',1)
xlim([Window(1)*1e3 , Window(2)*1e3])
xticks([Window(1)*1e3  nanmean(Window)*1e3  Window(2)*1e3]), xticklabels({'-100','0','+100'})
xlabel('time (ms)'), ylabel('Neuron no.')
makepretty_BM
makepretty_BM2

%% with enveloppe
% 
% load('/media/nas7/ProjetEmbReact/Mouse1531/20231123/ProjectEmbReact_M41531_20231123_UMazeCondExplo_PostDrug/Cond3/LFPData/LFP63.mat')
% load('/media/nas7/ProjetEmbReact/Mouse1531/20231123/ProjectEmbReact_M41531_20231123_UMazeCondExplo_PostDrug/Cond3/Cluster/SpikeData.mat')
% 
% 
% % No stim
% Window = [224.1 224.5];
% SmallEp = intervalSet(Window(1)*1e4 , Window(2)*1e4);
% 
% Fil_Low = FilterLFP(LFP,[1 250],1024);
% LFP_to_use = Restrict(Fil_Low,SmallEp);
% 
% Fil_Rip = FilterLFP(LFP,[120 250],1024);
% Enveloppe_Rip = tsd(Range(LFP), abs(hilbert(Data(Fil_Rip))) );
% Enveloppe_Rip = Restrict(Enveloppe_Rip,SmallEp);
% 
% figure
% subplot(331)
% A=resample(Data(LFP_to_use) , 30 , 1);
% plot(A , 'Color' , [0 0 0])
% xlim([0 length(A)-100]), ylim([-5e3 5e3])
% makepretty_BM
% axis off
% 
% subplot(334)
% area(runmean(Data(Enveloppe_Rip),20) , 'FaceColor' , [.3 .3 .3] , 'LineWidth' , 4)
% makepretty_BM
% xlim([0 length(Enveloppe_Rip)]), ylim([0 2e3])
% xticks([0 125 250]), xticklabels({'','',''})
% ylabel('eneveloppe 120-250Hz (a.u.)')
% 
% subplot(337)
% RasterPlot(S)
% xlim([Window(1)*1e3 , Window(2)*1e3])
% xticks([Window(1)*1e3  nanmean(Window)*1e3  Window(2)*1e3]), xticklabels({'-100','0','+100'})
% xlabel('time (ms)'), ylabel('Neuron no.')
% makepretty_BM
% 
% 
% 
% % Rip control
% Window = [43.75 44.15];
% SmallEp = intervalSet(Window(1)*1e4 , Window(2)*1e4);
% 
% Fil_Low = FilterLFP(LFP,[1 250],1024);
% LFP_to_use = Restrict(Fil_Low,SmallEp);
% 
% Fil_Rip = FilterLFP(LFP,[120 250],1024);
% Enveloppe_Rip = tsd(Range(LFP), abs(hilbert(Data(Fil_Rip))) );
% Enveloppe_Rip = Restrict(Enveloppe_Rip,SmallEp);
% 
% for i=1:40
%     bin = intervalSet(Window(1)*1e4+(i-1)*1e2 , Window(1)*1e4+i*1e2);
%     for n=1:length(S)
%         Spike_density(i,n) = length(Restrict(S{n} , bin));
%     end
% end
% 
% subplot(332)
% A=resample(Data(LFP_to_use) , 30 , 1);
% plot(A + [zeros(1,10620) linspace(1.5e4,0,1360) zeros(1,3020)]', 'Color' , [0 0 0])
% % plot(A , 'Color' , [0 0 0])
% xlim([0 length(A)-100]), ylim([-5e3 5e3])
% makepretty_BM
% axis off
% 
% subplot(335)
% area(runmean(Data(Enveloppe_Rip),20) , 'FaceColor' , [.3 .3 .3] , 'LineWidth' , 4)
% makepretty_BM
% xlim([0 length(Enveloppe_Rip)]), ylim([0 2e3])
% xticks([0 125 250]), xticklabels({'','',''})
% v=vline(368,'--r'); set(v,'LineWidth',3);
% 
% subplot(338)
% RasterPlot(S)
% xlim([Window(1)*1e3 , Window(2)*1e3])
% makepretty_BM
% xticks([Window(1)*1e3  nanmean(Window)*1e3  Window(2)*1e3]), xticklabels({'-100','0','+100'})
% xlabel('time (ms)')
% 
% 
% % Rip inhib
% Window = [199.15 199.55];
% SmallEp = intervalSet(Window(1)*1e4 , Window(2)*1e4);
% 
% Fil_Low = FilterLFP(LFP,[1 250],1024);
% LFP_to_use = Restrict(Fil_Low,SmallEp);
% 
% Fil_Rip = FilterLFP(LFP,[120 250],1024);
% Enveloppe_Rip = tsd(Range(LFP), abs(hilbert(Data(Fil_Rip))) );
% Enveloppe_Rip = Restrict(Enveloppe_Rip,SmallEp);
% 
% for i=1:40
%     bin = intervalSet(Window(1)*1e4+(i-1)*1e2 , Window(1)*1e4+i*1e2);
%     for n=1:length(S)
%         Spike_density(i,n) = length(Restrict(S{n} , bin));
%     end
% end
% 
% subplot(333)
% A=resample(Data(LFP_to_use) , 30 , 1);
% % plot(A +[ones(3700,1)*(-5e3) ; linspace(1.5e4,0,5288-3700)' ; zeros(15000-5288,1)], 'Color' , [0 0 0])
% plot(A, 'Color' , [0 0 0])
% xlim([0 length(A)-100]), ylim([-5e3 5e3])
% makepretty_BM
% axis off
% 
% subplot(336)
% area(runmean(sum(Spike_density'),1) , 'FaceColor' , [.3 .3 .3] , 'LineWidth' , 4)
% makepretty_BM
% xticks([0 20 40]), xticklabels({'','',''})
% v=vline(14,'--r'); set(v,'LineWidth',3);
% 
% subplot(339)
% RasterPlot(S)
% xlim([Window(1)*1e3 , Window(2)*1e3])
% xticks([Window(1)*1e3  nanmean(Window)*1e3  Window(2)*1e3]), xticklabels({'-100','0','+100'})
% xlabel('time (ms)')
% makepretty_BM
% 
% 
% 
% 
% 
% %%
% St=Start(StimEpoch2);
% for stim=1:length(Start(StimEpoch2))
%     figure
%     Window = [St(stim)/1e4-.2 St(stim)/1e4+.2];
%     SmallEp = intervalSet(Window(1)*1e4 , Window(2)*1e4);
%     Fil_Low = FilterLFP(LFP,[1 250],1024);
%     LFP_to_use = Restrict(Fil_Low,SmallEp);
%     for i=1:40
%         bin = intervalSet(Window(1)*1e4+(i-1)*1e2 , Window(1)*1e4+i*1e2);
%         for n=1:length(S)
%             Spike_density(i,n) = length(Restrict(S{n} , bin));
%         end
%     end
%     subplot(311)
%     A=resample(Data(LFP_to_use) , 30 , 1);
%     % plot(A +[linspace(0,-4e3,5900) linspace(4e3,1.5e3,9100)]', 'Color' , [0 0 0])
%     plot(A, 'Color' , [0 0 0])
%     xlim([0 length(A)-100]), ylim([-5e3 5e3])
%     makepretty_BM
%     axis off
%     subplot(312)
%     area(runmean(sum(Spike_density')*100,1) , 'FaceColor' , [.3 .3 .3] , 'LineWidth' , 4)
%     makepretty_BM
%     xticks([0 20 40]), xticklabels({'','',''}), ylim([0 1.2e3])
%     v=vline(20,'--r'); set(v,'LineWidth',3);
%     subplot(313)
%     RasterPlot(S)
%     xlim([Window(1)*1e3 , Window(2)*1e3])
%     xticks([Window(1)*1e3  nanmean(Window)*1e3  Window(2)*1e3]), xticklabels({'-100','0','+100'})
%     xlabel('time (ms)')
%     makepretty_BM
% end
% 
% 
