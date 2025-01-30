
% or Example_Paper_FreezingMaze_BM.m



cd('/media/nas8/mobs/ProjetERC2/Mouse-905/20190404/PAGExp/_Concatenated/')

load('LFPData/LFP4.mat'), LFP_4=LFP;
load('LFPData/LFP10.mat'), LFP_10=LFP;
load('LFPData/LFP6.mat'), LFP_6=LFP;
load('LFPData/LFP7.mat'), LFP_7=LFP;
load('LFPData/LFP17.mat'), LFP_17=LFP;
load('LFPData/LFP31.mat'), LFP_31=LFP;

load('SpikeData.mat')
load('SWR.mat')
R = Range(tRipples);

LFP_4_fil = FilterLFP(LFP_4,[10 200]);
LFP_17_fil = FilterLFP(LFP_17,[120 250]);

% Fz safe
window=[13609 13613];
% window=[14081.7 14085.7];

LFP_4_Dat = Data(Restrict(LFP_4_fil , intervalSet(window(1)*1e4 , window(2)*1e4)));
LFP_10_Dat = Data(Restrict(LFP_10 , intervalSet(window(1)*1e4 , window(2)*1e4)));
LFP_6_Dat = Data(Restrict(LFP_6 , intervalSet(window(1)*1e4 , window(2)*1e4)));
LFP_7_Dat = Data(Restrict(LFP_7 , intervalSet(window(1)*1e4 , window(2)*1e4)));
LFP_17_Dat = Data(Restrict(LFP_17 , intervalSet(window(1)*1e4 , window(2)*1e4)));
LFP_17Fil_Dat = Data(Restrict(LFP_17_fil , intervalSet(window(1)*1e4 , window(2)*1e4)));
% LFP_31_Dat = Data(Restrict(LFP_31 , intervalSet(window(1)*1e4 , window(2)*1e4)));

ind = find(and(R/1e4<window(2),R/1e4>window(1)));
t_rip = (R(ind)/1e4-window(1))*1250;

LFP_10_fil = FilterLFP(LFP_10,[1 15]);
load('InstFreqAndPhase_B.mat')
Phase_on_LFP = Restrict(LocalPhase.PT , LFP_10); 
Data_Phase_on_LFP = Data(Restrict(Phase_on_LFP , intervalSet(window(1)*1e4,window(2)*1e4)));
Data_LFP = Data(Restrict(LFP_10_fil , intervalSet(window(1)*1e4,window(2)*1e4)));
for f=1:50
    A(f) = round(median(find(Data_Phase_on_LFP((f-1)*100+1:100*f)<.7)))+(f-1)*100;
end

figure
subplot(622)
plot(Data_LFP , 'k' , 'LineWidth' , 2), xlim([0 length(Data_LFP)])
hold on
plot(A(~isnan(A)) , Data_LFP(A(~isnan(A))) , '.r' , 'MarkerSize' , 20)
axis off

subplot(6,2,[4 6 8])
plot(LFP_4_Dat*4+3e4, 'k')
hold on
plot(LFP_10_Dat+2e4 , 'k')
plot(LFP_6_Dat*2+1e4 , 'k')
plot(LFP_7_Dat*2 , 'k')
plot(LFP_17_Dat*2-1.5e4 , 'k')
plot(LFP_17Fil_Dat*7-3.5e4 , 'k')
plot(t_rip,-1e4,'*r')
xlim([0 length(LFP_4_Dat)]), %axis off

subplot(6,2,[10 12])
RasterPlot_SB(S,'FigureHandle',1)
xlim([window(1)*1e3 window(2)*1e3])
xlabel('time (s)'), ylabel('HPC neuron no.')
xticks([window(1)*1e3:1e3:window(2)*1e3]), xticklabels({'0','1','2','3','4'}) 
makepretty_BM2


% Fz shock
window=[13988.3 13992.3];

LFP_4_Dat = Data(Restrict(LFP_4_fil , intervalSet(window(1)*1e4 , window(2)*1e4)));
LFP_10_Dat = Data(Restrict(LFP_10 , intervalSet(window(1)*1e4 , window(2)*1e4)));
LFP_6_Dat = Data(Restrict(LFP_6 , intervalSet(window(1)*1e4 , window(2)*1e4)));
LFP_7_Dat = Data(Restrict(LFP_7 , intervalSet(window(1)*1e4 , window(2)*1e4)));
LFP_17_Dat = Data(Restrict(LFP_17 , intervalSet(window(1)*1e4 , window(2)*1e4)));
LFP_17Fil_Dat = Data(Restrict(LFP_17_fil , intervalSet(window(1)*1e4 , window(2)*1e4)));
% LFP_31_Dat = Data(Restrict(LFP_31 , intervalSet(window(1)*1e4 , window(2)*1e4)));

ind = find(and(R/1e4<window(2),R/1e4>window(1)));
t_rip = (R(ind)/1e4-window(1))*1250;

Data_Phase_on_LFP = Data(Restrict(Phase_on_LFP , intervalSet(window(1)*1e4,window(2)*1e4)));
Data_LFP = Data(Restrict(LFP_10_fil , intervalSet(window(1)*1e4,window(2)*1e4)));
for f=1:50
    A(f) = round(median(find(Data_Phase_on_LFP((f-1)*100+1:100*f)<.7)))+(f-1)*100;
end

subplot(621)
plot(Data_LFP+[linspace(4e3,0,2500) zeros(1,2500)]' , 'k' , 'LineWidth' , 2), xlim([0 length(Data_LFP)])
hold on
plot(A(~isnan(A)) , Data_LFP(A(~isnan(A))) , '.r' , 'MarkerSize' , 20)
axis off

subplot(6,2,[3 5 7])
plot(LFP_4_Dat*4+3e4, 'k')
hold on
plot(LFP_10_Dat+[linspace(4e3,0,2500) zeros(1,2500)]'+2e4 , 'k')
plot(LFP_6_Dat*2+1e4+[linspace(8e3,0,2500) zeros(1,2500)]' , 'k')
plot(LFP_7_Dat*2+[linspace(6e3,0,4e3) zeros(1,1e3)]' , 'k')
plot(LFP_17Fil_Dat*7-3.5e4 , 'k')
% plot(LFP_31_Dat-2e4+[linspace(5e3,0,4e3) zeros(1,1e3)]' , 'k')
% plot(1600,-3e4,'*r')
xlim([0 length(LFP_4_Dat)]), ylim([-3e4 4e4]), axis off

subplot(6,2,[9 11])
RasterPlot_SB(S,'FigureHandle',1)
xlim([window(1)*1e3 window(2)*1e3])
xlabel('time (s)'), ylabel('HPC neuron no.')
xticks([window(1)*1e3:1e3:window(2)*1e3]), xticklabels({'0','1','2','3','4'}) 
makepretty_BM2


