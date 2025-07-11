% RipplesDownBimodalNight
% 14.03.2018 KJ
% 
% 
% Data to analyse tone effect on signals:
%   - show MUA raster synchronized on ripples
%   - show PFC averaged LFP synchronized on ripples (many depth)
% 
% See AnalysesERPDownDeltaTone AnalysesERPRipplesDelta
%       RipplesDownBimodalPlot
%   
% 


clear

Dir=PathForExperimentsBasalSleepSpike;
p=1;

%params
t_before = -4E4; %in 1E-4s
t_after = 4E4; %in 1E-4s
binsize=10;
effect_period_down = 1500; %150ms

disp(' ')
disp('****************************************************************')
eval(['cd(Dir.path{',num2str(p),'}'')'])
disp(pwd)

ripple_res.path{p}   = Dir.path{p};
ripple_res.manipe{p} = Dir.manipe{p};
ripple_res.name{p}   = Dir.name{p};
ripple_res.date{p}   = Dir.date{p};


%% load
load(fullfile(FolderProjetDelta,'Data','DeltaSingleChannelAnalysisCrossCorr.mat'))

load('DownState.mat', 'down_PFCx')
start_down = Start(down_PFCx);
center_down = (End(down_PFCx) + Start(down_PFCx))/2;
down_durations = End(down_PFCx) - Start(down_PFCx);


load('Ripples.mat', 'Ripples')
ripples_tmp = Ripples(:,2) * 10;
ripples_intv_down = intervalSet(ripples_tmp, ripples_tmp + effect_period_down);
nb_ripples = length(ripples_tmp);

%spikes
load('SpikesToAnalyse/PFCx_Neurons')
NumNeurons=number;
load('SpikeData','S')
if isa(S,'tsdArray')
    MUA = MakeQfromS(S(NumNeurons), binsize*10);
else
    MUA = MakeQfromS(tsdArray(S(NumNeurons)),binsize*10);
end
MUA = tsd(Range(MUA), sum(full(Data(MUA)),2));

%LFP
%channels deep and sup
[~,idx1] = sort(singcor_res.peak_value{p});
idch_sup = idx1(1);
idch_deep = idx1(end);
nb_channels = length(singcor_res.channels{p});


load('ChannelsToAnalyse/PFCx_deep.mat')
load(['LFPData/LFP' num2str(singcor_res.channels{p}(idch_deep))])
PFCdeep = LFP;
clear LFP

load('ChannelsToAnalyse/PFCx_sup.mat')
load(['LFPData/LFP' num2str(singcor_res.channels{p}(idch_sup))])
PFCsup = LFP;
clear LFP

load('ChannelsToAnalyse/PaCx_deep.mat')
load(['LFPData/LFP' num2str(channel)])
PaCxdeep = LFP;
clear LFP
load('ChannelsToAnalyse/PaCx_sup.mat')
load(['LFPData/LFP' num2str(channel)])
PaCxsup = LFP;
clear LFP

load('ChannelsToAnalyse/MoCx_deep.mat')
load(['LFPData/LFP' num2str(channel)])
MoCxdeep = LFP;
clear LFP
load('ChannelsToAnalyse/MoCx_sup.mat')
load(['LFPData/LFP' num2str(channel)])
MOCxsup = LFP;
clear LFP


%% INDUCED a Down ?
induce_down = zeros(nb_ripples, 1);
[~,interval,~] = InIntervals(start_down, [Start(ripples_intv_down) End(ripples_intv_down)]);
down_ripples_success = unique(interval);
down_ripples_success(down_ripples_success==0)=[];
induce_down(down_ripples_success) = 1;  %do not consider the first nul element


%% Raster MUA
ripple_res.raster_mua{p} = RasterMatrixKJ(MUA, ts(ripples_tmp), t_before, t_after);
ripple_res.induce_down{p} = induce_down;

%% Raster LFP
ripple_res.raster_deep{p} = RasterMatrixKJ(PFCdeep, ts(ripples_tmp), t_before, t_after);
ripple_res.raster_sup{p} = RasterMatrixKJ(PFCsup, ts(ripples_tmp), t_before, t_after);

ripple_res.pacx_deep{p} = RasterMatrixKJ(PaCxdeep, ts(ripples_tmp), t_before, t_after);
ripple_res.pacx_sup{p} = RasterMatrixKJ(PaCxsup, ts(ripples_tmp), t_before, t_after);

ripple_res.mocx_deep{p} = RasterMatrixKJ(MoCxdeep, ts(ripples_tmp), t_before, t_after);
ripple_res.mocx_sup{p} = RasterMatrixKJ(MOCxsup, ts(ripples_tmp), t_before, t_after);

ripple_res.down.pacx_deep{p} = RasterMatrixKJ(PaCxdeep, ts(start_down), t_before, t_after);
ripple_res.down.pacx_sup{p} = RasterMatrixKJ(PaCxsup, ts(start_down), t_before, t_after);

ripple_res.down.mocx_deep{p} = RasterMatrixKJ(MoCxdeep, ts(start_down), t_before, t_after);
ripple_res.down.mocx_sup{p} = RasterMatrixKJ(MOCxsup, ts(start_down), t_before, t_after);



%% Sort

idx_notinduced = find(ripple_res.induce_down{p}==0);

raster_deep = Data(ripple_res.raster_deep{p});
x_deep = Range(ripple_res.raster_deep{p});

raster_sup = Data(ripple_res.raster_sup{p});
x_sup = Range(ripple_res.raster_sup{p});

raster_mua = Data(ripple_res.raster_mua{p});
x_mua = Range(ripple_res.raster_mua{p});

raster_padeep = Data(ripple_res.pacx_deep{p});
x_padeep = Range(ripple_res.pacx_deep{p});

raster_pasup = Data(ripple_res.pacx_sup{p});
x_pasup = Range(ripple_res.pacx_sup{p});

raster_modeep = Data(ripple_res.mocx_deep{p});
x_modeep = Range(ripple_res.mocx_deep{p});

raster_mosup = Data(ripple_res.mocx_sup{p});
x_mosup = Range(ripple_res.mocx_sup{p});


%raster on down
MatPaDownDeep = Data(ripple_res.down.pacx_deep{p})';
MatPaDownSup = Data(ripple_res.down.pacx_sup{p})';
x_down = Range(ripple_res.down.pacx_deep{p});

%raster on down
MatMoDownDeep = Data(ripple_res.down.mocx_deep{p})';
MatMoDownSup = Data(ripple_res.down.mocx_sup{p})';
x_down = Range(ripple_res.down.mocx_deep{p});


%% Sort

direction='ascend';

%sort ripples by the response of PFC deep
[~, id_deep] = sort(mean(raster_deep(x_deep>0 & x_deep<effect_period_down,induce_down==0),1),direction);
%sort ripples by the response of PFC sup
[~, id_sup] = sort(mean(raster_sup(x_sup>0 & x_sup<effect_period_down,induce_down==0),1),direction);
%sort ripples by the response of MUA
[~, id_mua] = sort(mean(raster_mua(x_mua>0 & x_mua<effect_period_down,induce_down==0),1),direction);

%sort ripples by the response of PaCx deep
[~, id_padeep] = sort(mean(raster_padeep(x_padeep>0 & x_padeep<effect_period_down,induce_down==0),1),direction);
%sort ripples by the response of PaCx sup
[~, id_pasup] = sort(mean(raster_pasup(x_pasup>0 & x_pasup<effect_period_down,induce_down==0),1),direction);

%sort ripples by the response of MoCx deep
[~, id_modeep] = sort(mean(raster_modeep(x_modeep>0 & x_modeep<effect_period_down,induce_down==0),1),direction);
%sort ripples by the response of MoCx sup
[~, id_mosup] = sort(mean(raster_mosup(x_mosup>0 & x_mosup<effect_period_down,induce_down==0),1),direction);



%% ordering

nb_sample=100; %for average
idx1 = id_sup;


%mua
mat1 = raster_mua(:,induce_down==0);
mat2 = raster_mua(:,induce_down==1);
MatMUA = [mat2' ; mat1(:,idx1)'];
%deep
mat1 = raster_deep(:,induce_down==0);
mat2 = raster_deep(:,induce_down==1);
MatDeep = [mat2' ; mat1(:,idx1)'];
%sup
mat1 = raster_sup(:,induce_down==0);
mat2 = raster_sup(:,induce_down==1);
MatSup = [mat2' ; mat1(:,idx1)'];


%PaCx deep
mat1 = raster_padeep(:,induce_down==0);
mat2 = raster_padeep(:,induce_down==1);
MatPaDeep = [mat2' ; mat1(:,id_pasup)'];
%PaCx sup
mat1 = raster_pasup(:,induce_down==0);
mat2 = raster_pasup(:,induce_down==1);
MatPaSup = [mat2' ; mat1(:,id_pasup)'];

%MoCx deep
mat1 = raster_modeep(:,induce_down==0);
mat2 = raster_modeep(:,induce_down==1);
MatMoDeep = [mat2' ; mat1(:,id_mosup)'];
%MoCx sup
mat1 = raster_mosup(:,induce_down==0);
mat2 = raster_mosup(:,induce_down==1);
MatMoSup = [mat2' ; mat1(:,id_mosup)'];



%% PLOT

x_lim = [-0.4 0.4];
y_lim = [-1000 2000];
ylim_mua = [0 10];
fontsize = 9;

figure, hold on

%MUA raster
subplot(3,3,1); hold on
imagesc(x_mua/1E4, 1:size(MatMUA,2), MatMUA), hold on
axis xy, ylabel('# ripples'), hold on
line([0 0], ylim,'Linewidth',2,'color','k'), hold on
line(xlim, get(gca,'xlim'),'color','k'), hold on
set(gca,'YLim', [0 size(MatMUA,2)], 'Yticklabel',{[]},'Xticklabel',{[]}, 'XLim',x_lim,'FontName','Times','fontsize',fontsize);
hb = colorbar('location','eastoutside'); hold on

%PFC average - not inducing
subplot(3,3,2); hold on

h(1) = plot(x_deep/1E4 , mean(MatDeep(end-nb_sample:end,:),1) , 'Linewidth',2,'color','r');
h(2) = plot(x_sup/1E4 , mean(MatSup(end-nb_sample:end,:),1) , 'Linewidth',2,'color','b');
yyaxis right
h(3) = plot(x_mua/1E4 , mean(MatMUA(end-nb_sample:end,:),1) , 'Linewidth',2,'color','k');
ylim(ylim_mua)

yyaxis left
line([0 0], ylim,'color',[0.7 0.7 0.7]), hold on
h_leg = legend(h,'PFCx deep', 'PFCx sup', 'MUA'); set(h_leg,'FontSize',fontsize);
set(gca, 'YTick',[-1000 0 1000],'Xticklabel',{[]},'XLim',x_lim, 'YLim',y_lim,'FontName','Times','fontsize',fontsize);
title('Ripples not inducing Down states');


%PFC average - inducing
subplot(3,3,3); hold on

h(1) = plot(x_deep/1E4 , mean(MatDeep(1:sum(induce_down==1),:),1) , 'Linewidth',2,'color','r');
h(2) = plot(x_sup/1E4 , mean(MatSup(1:sum(induce_down==1),:),1) , 'Linewidth',2,'color','b');
yyaxis right
h(3) = plot(x_mua/1E4 , mean(MatMUA(1:sum(induce_down==1),:),1) , 'Linewidth',2,'color','k');
ylim(ylim_mua)

yyaxis left
line([0 0], ylim,'color',[0.7 0.7 0.7]), hold on
h_leg = legend(h,'PFCx deep', 'PFCx sup', 'MUA'); set(h_leg,'FontSize',fontsize);
set(gca, 'YTick',[-1000 0 1000],'Xticklabel',{[]},'XLim',x_lim, 'YLim',y_lim,'FontName','Times','fontsize',fontsize);
title('Ripples inducing Down states');


%MoCx average -on down states
subplot(3,3,4); hold on

h(1) = plot(x_down/1E4 , mean(MatMoDownDeep,1) , 'Linewidth',2,'color','r');
h(2) = plot(x_down/1E4 , mean(MatMoDownSup,1) , 'Linewidth',2,'color','b');
line([0 0], ylim,'color',[0.7 0.7 0.7]), hold on
set(gca, 'YTick',[-1000 0 1000],'Xticklabel',{[]},'XLim',x_lim, 'FontName','Times','fontsize',fontsize);
title('MoCx on down states')

%MoCx average - not inducing
subplot(3,3,5); hold on

h(1) = plot(x_modeep/1E4 , mean(MatMoDeep(end-nb_sample:end,:),1) , 'Linewidth',2,'color','r');
h(2) = plot(x_mosup/1E4 , mean(MatMoSup(end-nb_sample:end,:),1) , 'Linewidth',2,'color','b');
yyaxis right
h(3) = plot(x_mua/1E4 , mean(MatMUA(end-nb_sample:end,:),1) , 'Linewidth',2,'color','k');
ylim(ylim_mua)

yyaxis left
line([0 0], ylim,'color',[0.7 0.7 0.7]), hold on
set(gca, 'YTick',[-1000 0 1000],'Xticklabel',{[]},'XLim',x_lim, 'FontName','Times','fontsize',fontsize);
title('MoCx')


%MoCx average - inducing
subplot(3,3,6); hold on

h(1) = plot(x_modeep/1E4 , mean(MatMoDeep(1:sum(induce_down==1),:),1) , 'Linewidth',2,'color','r');
h(2) = plot(x_mosup/1E4 , mean(MatMoSup(1:sum(induce_down==1),:),1) , 'Linewidth',2,'color','b');
yyaxis right
h(3) = plot(x_mua/1E4 , mean(MatMUA(1:sum(induce_down==1),:),1) , 'Linewidth',2,'color','k');
ylim(ylim_mua)

yyaxis left
line([0 0], ylim,'color',[0.7 0.7 0.7]), hold on
set(gca, 'YTick',[-1000 0 1000],'Xticklabel',{[]},'XLim',x_lim, 'FontName','Times','fontsize',fontsize);
title('MoCx')



%PACx average -on down states
subplot(3,3,7); hold on

h(1) = plot(x_down/1E4 , mean(MatPaDownDeep,1) , 'Linewidth',2,'color','r');
h(2) = plot(x_down/1E4 , mean(MatPaDownSup,1) , 'Linewidth',2,'color','b');
line([0 0], ylim,'color',[0.7 0.7 0.7]), hold on
set(gca, 'YTick',[-1000 0 1000],'Xticklabel',{[]},'XLim',x_lim, 'FontName','Times','fontsize',fontsize);
title('PaCx on down states')


%PACx average - not inducing
subplot(3,3,8); hold on

h(1) = plot(x_padeep/1E4 , mean(MatPaDeep(end-nb_sample:end,:),1) , 'Linewidth',2,'color','r');
h(2) = plot(x_pasup/1E4 , mean(MatPaSup(end-nb_sample:end,:),1) , 'Linewidth',2,'color','b');
yyaxis right
h(3) = plot(x_mua/1E4 , mean(MatMUA(end-nb_sample:end,:),1) , 'Linewidth',2,'color','k');
ylim(ylim_mua)

yyaxis left
line([0 0], ylim,'color',[0.7 0.7 0.7]), hold on
set(gca, 'YTick',[-1000 0 1000],'Xticklabel',{[]},'XLim',x_lim, 'FontName','Times','fontsize',fontsize);
title('PaCx')


%PACx average - inducing
subplot(3,3,9); hold on

h(1) = plot(x_padeep/1E4 , mean(MatPaDeep(1:sum(induce_down==1),:),1) , 'Linewidth',2,'color','r');
h(2) = plot(x_pasup/1E4 , mean(MatPaSup(1:sum(induce_down==1),:),1) , 'Linewidth',2,'color','b');
yyaxis right
h(3) = plot(x_mua/1E4 , mean(MatMUA(1:sum(induce_down==1),:),1) , 'Linewidth',2,'color','k');
ylim(ylim_mua)

yyaxis left
line([0 0], ylim,'color',[0.7 0.7 0.7]), hold on
set(gca, 'YTick',[-1000 0 1000],'Xticklabel',{[]},'XLim',x_lim, 'FontName','Times','fontsize',fontsize);
title('PaCx')









