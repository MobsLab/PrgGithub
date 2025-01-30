% AnalysesERPRipplesDelta
% 21.09.2017 KJ
% 
% 
% Data to analyse tone effect on signals:
%   - show MUA raster synchronized on ripples
%   - show PFC averaged LFP synchronized on ripples (may depth)
% 
% See AnalysesERPDownDeltaTone
%   
% 
% 

clear

Dir = PathForExperimentsDeltaSleepSpikes('Basal');

% Dir2 = PathForExperimentsDeltaKJHD('Basal');
% Dir = IntersectPathForExperiment(Dir,Dir2);

%params
t_before = -4E4; %in 1E-4s
t_after = 4E4; %in 1E-4s
binsize_mua=10;
effect_period_down = 1200; %120ms
substage_ind = 1:5;


%
%for p=1:length(Dir.path)

    p = 2;
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    ripples_erp.path=Dir.path;
    ripples_erp.manipe=Dir.manipe;
    ripples_erp.name=Dir.name;
%     ripples_erp.condition=Dir.condition;
        
    %% Load

    %Substages
    clear op noise
    load NREMepochsML.mat op noise
    if ~isempty(op)
        disp('Loading epochs from NREMepochsML.m')
    else
        clear op NamesOp Dpfc Epoch noise
        load NREMepochsML_old.mat op noise
        disp('Loading epochs from NREMepochsML.m')
    end
    [Substages,NamesSubstages]=DefineSubStages(op,noise);
    
    %PFC
    load ChannelsToAnalyse/PFCx_deep
    eval(['load LFPData/LFP',num2str(channel)])
    LFPdeep=LFP;
    clear LFP channel
    try
        load ChannelsToAnalyse/PFCx_sup
    catch
        load ChannelsToAnalyse/PFCx_deltasup
    end
    eval(['load LFPData/LFP',num2str(channel)])
    LFPsup=LFP;
    clear LFP channel
    load ChannelsToAnalyse/PFCx_1
    eval(['load LFPData/LFP',num2str(channel)])
    PFC1=LFP;
    clear LFP channel
    load ChannelsToAnalyse/PFCx_2
    eval(['load LFPData/LFP',num2str(channel)])
    PFC2=LFP;
    clear LFP channel
    load ChannelsToAnalyse/PFCx_3
    eval(['load LFPData/LFP',num2str(channel)])
    PFC3=LFP;
    clear LFP channel
    %HPC
    try
    load ChannelsToAnalyse/dHPC_rip
    if isempty(channel); error; end
    catch
        load ChannelsToAnalyse/dHPC_deep
    end
    eval(['load LFPData/LFP',num2str(channel)])
    HPCrip=LFP;
    clear LFP channel
    %Bulb
    load ChannelsToAnalyse/Bulb_sup
    eval(['load LFPData/LFP',num2str(channel)])
    Bulb_sup=LFP;
    clear LFP channel
    load ChannelsToAnalyse/Bulb_deep
    eval(['load LFPData/LFP',num2str(channel)])
    Bulb_deep=LFP;
    clear LFP channel
    %PaCx
    load ChannelsToAnalyse/PaCx_deep
    eval(['load LFPData/LFP',num2str(channel)])
    PaCx_deep=LFP;
    clear LFP channel
    load ChannelsToAnalyse/PaCx_sup
    eval(['load LFPData/LFP',num2str(channel)])
    PaCx_sup=LFP;
    clear LFP channel
    
    %MUA
    load SpikeData
    eval('load SpikesToAnalyse/PFCx_Neurons')
    NumNeurons=number;
    clear number
    T=PoolNeurons(S,NumNeurons);
    ST{1}=T;
    try
        ST=tsdArray(ST);
    end
    Q = MakeQfromS(ST,binsize_mua*10); %binsize*10 to be in E-4s
    nb_neuron = length(NumNeurons);
        
    %Down states
    try
        load newDownState Down
    catch
        try
            load DownSpk Down
        catch
            Down = intervalSet([],[]);
        end
    end
    tdowns = ts((Start(Down)+End(Down))/2);
    start_down = Start(Down);
    end_down = End(Down);
    
    %Ripples
    load newRipHPC Ripples_tmp
    
    start_ripples = Ripples_tmp(:,1)*1E4;
    center_ripples = Ripples_tmp(:,2)*1E4;
    end_ripples = Ripples_tmp(:,3)*1E4;
    RipplesEvent = ts(start_ripples);
    
    nb_ripples = length(start_ripples);
    ripples_intv_down = intervalSet(start_ripples, start_ripples + effect_period_down);  % Ripples and its window where a effect_period_down is most probable
    
    
    %% DELAY        
    %down
    delay_down_ripples = nan(nb_ripples, 1);
    for i=1:nb_ripples
        try
            idx_down_before = find(end_down < start_ripples(i), 1,'last');
            delay_down_ripples(i) = start_ripples(i) - end_down(idx_down_before);    
        end
    end
    
    %% INDUCED a Down ?
    if ~isempty(start_down)
        induce_down = zeros(nb_ripples, 1);
        [~,interval,~] = InIntervals(start_down, [Start(ripples_intv_down) End(ripples_intv_down)]);
        down_ripples_success = unique(interval);
        induce_down(down_ripples_success(2:end)) = 1;  %do not consider the first nul element
    else
        induce_down = [];
    end
    
    %% SUBSTAGE
    substage_ripples = nan(1,length(start_ripples));
    for sub=substage_ind
        substage_ripples(ismember(start_ripples, Range(Restrict(RipplesEvent, Substages{sub})))) = sub;
    end
    
    
    %% Raster and save
    ripples_erp.pfc.deep = RasterMatrixKJ(LFPdeep, RipplesEvent, t_before, t_after);
    ripples_erp.pfc.sup = RasterMatrixKJ(LFPsup, RipplesEvent, t_before, t_after);
    ripples_erp.pfc.d1 = RasterMatrixKJ(PFC1, RipplesEvent, t_before, t_after);
    ripples_erp.pfc.d2 = RasterMatrixKJ(PFC2, RipplesEvent, t_before, t_after);
    ripples_erp.pfc.d3 = RasterMatrixKJ(PFC3, RipplesEvent, t_before, t_after);
    
    ripples_erp.hpc.rip = RasterMatrixKJ(HPCrip, RipplesEvent, t_before, t_after);
    ripples_erp.bulb.deep = RasterMatrixKJ(Bulb_deep, RipplesEvent, t_before, t_after);
    ripples_erp.bulb.sup = RasterMatrixKJ(Bulb_sup, RipplesEvent, t_before, t_after);
    ripples_erp.pacx.deep = RasterMatrixKJ(PaCx_deep, RipplesEvent, t_before, t_after);
    ripples_erp.pacx.sup = RasterMatrixKJ(PaCx_sup, RipplesEvent, t_before, t_after);
    
    ripples_erp.mua.raster = RasterMatrixKJ(Q, RipplesEvent, t_before, t_after);
    ripples_erp.down_delay = delay_down_ripples;
    ripples_erp.induced = induce_down;

    ripples_erp.substage_ripples = substage_ripples;
    ripples_erp.nrem_ripples = ismember(substage_ripples,1:3);
    

% end
% 
% 
% %% save
% cd([FolderProjetDelta 'Data/'])
% save AnalysesERPRipplesDelta -v7.3 ripples_erp substage_ind effect_period
    



%% Data to plot
no=1; yes=2;
x_lim = [-1 1];
y_lim = [-1500 2000];

%data
mua_cond = Data(ripples_erp.mua.raster);
mua_x = Range(ripples_erp.mua.raster);

pfcdeep_cond = Data(ripples_erp.pfc.deep);
pfcsup_cond = Data(ripples_erp.pfc.sup);
hpc_cond = Data(ripples_erp.hpc.rip);
bulbdeep_cond = Data(ripples_erp.bulb.deep);
bulbsup_cond = Data(ripples_erp.bulb.sup);
pacxdeep_cond = Data(ripples_erp.pacx.deep);
pacxsup_cond = Data(ripples_erp.pacx.sup);

pfcdeep_x = Range(ripples_erp.pfc.deep);
pfcsup_x = Range(ripples_erp.pfc.sup);
hpc_x = Range(ripples_erp.hpc.rip);
bulbdeep_x = Range(ripples_erp.bulb.deep);
bulbsup_x = Range(ripples_erp.bulb.sup);
pacxdeep_x = Range(ripples_erp.pacx.deep);
pacxsup_x = Range(ripples_erp.pacx.sup);

%induced and substage
for sub=substage_ind
    for indu=[no yes]
        idx_ripples{indu,sub} = (ripples_erp.induced==indu-1) .* (ripples_erp.substage_ripples==sub)';
    end
end
%NREM = 6
for indu=[no yes]
    idx_ripples{indu,6} = (ripples_erp.induced==indu-1) .* (ismember(ripples_erp.substage_ripples,3))';
end

for sub=[substage_ind 6] %6 is NREM
    for indu=[no yes]
        pfcdeep_met{indu,sub} = pfcdeep_cond(:,idx_ripples{indu,sub}==1);
        pfcdeep_met{indu,sub} = tsd(pfcdeep_x,mean(pfcdeep_met{indu,sub},2));
        pfcsup_met{indu,sub} = pfcsup_cond(:,idx_ripples{indu,sub}==1);
        pfcsup_met{indu,sub} = tsd(pfcsup_x,mean(pfcsup_met{indu,sub},2));

        hpc_met{indu,sub} = hpc_cond(:,idx_ripples{indu,sub}==1);
        hpc_met{indu,sub} = tsd(hpc_x,mean(hpc_met{indu,sub},2));

        bulbdeep_met{indu,sub} = bulbdeep_cond(:,idx_ripples{indu,sub}==1);
        bulbdeep_met{indu,sub} = tsd(bulbdeep_x,mean(bulbdeep_met{indu,sub},2));
        bulbsup_met{indu,sub} = bulbsup_cond(:,idx_ripples{indu,sub}==1);
        bulbsup_met{indu,sub} = tsd(bulbsup_x,mean(bulbsup_met{indu,sub},2));

        pacxdeep_met{indu,sub} = pacxdeep_cond(:,idx_ripples{indu,sub}==1);
        pacxdeep_met{indu,sub} = tsd(pacxdeep_x,mean(pacxdeep_met{indu,sub},2));
        pacxsup_met{indu,sub} = pacxsup_cond(:,idx_ripples{indu,sub}==1);
        pacxsup_met{indu,sub} = tsd(pacxsup_x,mean(pacxsup_met{indu,sub},2));

    end
end

sub=6;
% for the line spliting success and failed tones
border = sum(idx_ripples{indu,sub}==1); %number of triggered and success tones, in NREM

% matrix with the raster (gather failed and success together)
failed_mat = mua_cond(:,idx_ripples{no,sub}==1);
failed_mat = failed_mat(:,randperm(size(failed_mat,2)));
success_mat = mua_cond(:,idx_ripples{yes,sub}==1);
success_mat = success_mat(:,randperm(size(success_mat,2)));
raster_mat = [success_mat' ; failed_mat'];


%% Plot 1

figure, hold on
%LFP average - not inducing
s1=subplot(13,1,1:3); hold on
plot(Range(pfcdeep_met{no,sub})/1E4 , Data(pfcdeep_met{no,sub}) , 'Linewidth',2,'color','b');
plot(Range(pfcsup_met{no,sub})/1E4 , Data(pfcsup_met{no,sub}) , 'Linewidth',2,'color','r');
plot(Range(hpc_met{no,sub})/1E4 , Data(hpc_met{no,sub}) , 'Linewidth',2,'color','k');
plot(Range(bulbdeep_met{no,sub})/1E4 , Data(bulbdeep_met{no,sub}) , 'Linewidth',2,'color',[1 0.41 0.7]);
plot(Range(pacxdeep_met{no,sub})/1E4 , Data(pacxdeep_met{no,sub}) , 'Linewidth',2,'color',[0.75 0.75 0.75]);

h_leg = legend('PFCx deep', 'PFCx sup', 'HPC', 'Bulb deep', 'PaCx deep'); set(h_leg,'FontSize',15);
line([0 0], ylim,'color',[0.7 0.7 0.7]), hold on
set(gca, 'YTick',[-1000 0 1000],'Xticklabel',{[]},'XLim',x_lim, 'YLim',y_lim,'FontName','Times','fontsize',12);
title('Ripples not inducing Down states');

%MUA raster
s2=subplot(13,1,4:10); hold on
imagesc(mua_x/1E4, 1:size(raster_mat,1), raster_mat), hold on
axis xy, ylabel('# tone'), hold on
line([0 0], ylim,'Linewidth',2,'color','k'), hold on
line(xlim, [border border],'color','k'), hold on
set(gca,'YLim', [0 size(raster_mat,1)], 'Yticklabel',{[]},'Xticklabel',{[]}, 'XLim',x_lim,'FontName','Times','fontsize',12);
hb = colorbar('location','eastoutside'); hold on

%LFP average - inducing
s3=subplot(13,1,11:13); hold on
plot(Range(pfcdeep_met{yes,sub})/1E4 , Data(pfcdeep_met{yes,sub}) , 'Linewidth',2,'color','b');
plot(Range(pfcsup_met{yes,sub})/1E4 , Data(pfcsup_met{yes,sub}) , 'Linewidth',2,'color','r');
plot(Range(hpc_met{yes,sub})/1E4 , Data(hpc_met{yes,sub}) , 'Linewidth',2,'color','k');
plot(Range(bulbdeep_met{yes,sub})/1E4 , Data(bulbdeep_met{yes,sub}) , 'Linewidth',2,'color',[1 0.41 0.7]);
plot(Range(pacxdeep_met{yes,sub})/1E4 , Data(pacxdeep_met{yes,sub}) , 'Linewidth',2,'color',[0.75 0.75 0.75]);

%h_leg = legend('PFCx deep', 'PFCx sup', 'HPC', 'Bulb deep', 'PaCx deep'); set(h_leg,'FontSize',15); xlabel('time (sec)'),
line([0 0], ylim,'color',[0.7 0.7 0.7]), hold on
set(gca, 'YTick',[-1000 0 1000],'XLim',x_lim, 'YLim',y_lim,'FontName','Times','fontsize',12);
title('Ripples inducing Down states');

%align subplots
s1Pos = get(s1,'position');
s2Pos = get(s2,'position');
s2Pos(3) = s1Pos(3);
set(s2,'position',s2Pos);


%% Plot 2

figure, hold on
%LFP average - not inducing
s1=subplot(3,1,1); hold on
plot(Range(pfcdeep_met{no,sub})/1E4 , Data(pfcdeep_met{no,sub}) , 'Linewidth',2,'color','b');
plot(Range(pfcsup_met{no,sub})/1E4 , Data(pfcsup_met{no,sub}) , 'Linewidth',2,'color','r');
plot(Range(hpc_met{no,sub})/1E4 , Data(hpc_met{no,sub}) , 'Linewidth',2,'color','k');
plot(Range(bulbdeep_met{no,sub})/1E4 , Data(bulbdeep_met{no,sub}) , 'Linewidth',2,'color',[1 0.41 0.7]);
plot(Range(pacxdeep_met{no,sub})/1E4 , Data(pacxdeep_met{no,sub}) , 'Linewidth',2,'color',[0.75 0.75 0.75]);

h_leg = legend('PFCx deep', 'PFCx sup', 'HPC', 'Bulb deep', 'PaCx deep'); set(h_leg,'FontSize',15);
line([0 0], ylim,'color',[0.7 0.7 0.7]), hold on
set(gca, 'YTick',[-1000 0 1000],'Xticklabel',{[]},'XLim',x_lim, 'YLim',y_lim,'FontName','Times','fontsize',12);
title('Ripples not inducing Down states');

%MUA raster
s2=subplot(3,1,2); hold on
plot(Range(pfcdeep_met{no,sub})/1E4 , Data(pfcdeep_met{yes,sub}) - Data(pfcdeep_met{no,sub}) , 'Linewidth',2,'color','b');
plot(Range(pfcsup_met{no,sub})/1E4 , Data(pfcsup_met{yes,sub}) - Data(pfcsup_met{no,sub}) , 'Linewidth',2,'color','r');
plot(Range(hpc_met{no,sub})/1E4 , Data(hpc_met{yes,sub}) - Data(hpc_met{no,sub}) , 'Linewidth',2,'color','k');
plot(Range(bulbdeep_met{no,sub})/1E4 , Data(bulbdeep_met{yes,sub}) - Data(bulbdeep_met{no,sub}) , 'Linewidth',2,'color',[1 0.41 0.7]);
plot(Range(pacxdeep_met{no,sub})/1E4 , Data(pacxdeep_met{yes,sub}) - Data(pacxdeep_met{no,sub}) , 'Linewidth',2,'color',[0.75 0.75 0.75]);

%h_leg = legend('PFCx deep', 'PFCx sup', 'HPC', 'Bulb deep', 'PaCx deep'); set(h_leg,'FontSize',15); xlabel('time (sec)'),
line([0 0], ylim,'color',[0.7 0.7 0.7]), hold on
set(gca, 'YTick',[-1000 0 1000],'XLim',x_lim, 'YLim',y_lim,'FontName','Times','fontsize',12);
title('Substraction: Inducing - Not inducing');

%LFP average - inducing
s3=subplot(3,1,3); hold on
plot(Range(pfcdeep_met{yes,sub})/1E4 , Data(pfcdeep_met{yes,sub}) , 'Linewidth',2,'color','b');
plot(Range(pfcsup_met{yes,sub})/1E4 , Data(pfcsup_met{yes,sub}) , 'Linewidth',2,'color','r');
plot(Range(hpc_met{yes,sub})/1E4 , Data(hpc_met{yes,sub}) , 'Linewidth',2,'color','k');
plot(Range(bulbdeep_met{yes,sub})/1E4 , Data(bulbdeep_met{yes,sub}) , 'Linewidth',2,'color',[1 0.41 0.7]);
plot(Range(pacxdeep_met{yes,sub})/1E4 , Data(pacxdeep_met{yes,sub}) , 'Linewidth',2,'color',[0.75 0.75 0.75]);

%h_leg = legend('PFCx deep', 'PFCx sup', 'HPC', 'Bulb deep', 'PaCx deep'); set(h_leg,'FontSize',15); xlabel('time (sec)'),
line([0 0], ylim,'color',[0.7 0.7 0.7]), hold on
set(gca, 'YTick',[-1000 0 1000],'XLim',x_lim, 'YLim',y_lim,'FontName','Times','fontsize',12);
title('Ripples inducing Down states');







