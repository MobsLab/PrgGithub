%%MeancurvesDeltaAfterRipplesPlot
% 05.09.2019 KJ
%
% Infos
%   script about real and fake slow waves
%
% see
%    MeanCurvesMUAFakeDeltaDeep OccurenceRipplesFakeDeltaDownSup
%
%


% load
clear
load(fullfile(FolderDeltaDataKJ,'MeancurvesDeltaAfterRipples.mat'))

%init
factorLFP = 0.195;
animals = unique(meanc_res.name);



%% loop
met_y.down.ripples = []; met_y.down.out = [];
met_y.diff.ripples = []; met_y.diff.out = [];
met_y.good.ripples = []; met_y.good.out = [];
met_y.fake.ripples = []; met_y.fake.out = [];

durations.down.ripples = []; durations.down.out = [];
durations.diff.ripples = []; durations.diff.out = [];
durations.good.ripples = []; durations.good.out = [];
durations.fake.ripples = []; durations.fake.out = [];

amplitudes.down.ripples = []; amplitudes.down.out = [];
amplitudes.diff.ripples = []; amplitudes.diff.out = [];
amplitudes.good.ripples = []; amplitudes.good.out = [];
amplitudes.fake.ripples = []; amplitudes.fake.out = [];


for m=1:length(animals)
    
    mouse_y.down.ripples = []; mouse_y.down.out = [];
    mouse_y.diff.ripples = []; mouse_y.diff.out = [];
    mouse_y.good.ripples = []; mouse_y.good.out = [];
    mouse_y.fake.ripples = []; mouse_y.fake.out = [];

    
    dur_mouse.down.ripples = []; dur_mouse.down.out = [];
    dur_mouse.diff.ripples = []; dur_mouse.diff.out = [];
    dur_mouse.good.ripples = []; dur_mouse.good.out = [];
    dur_mouse.fake.ripples = []; dur_mouse.fake.out = [];

    amp_mouse.down.ripples = []; amp_mouse.down.out = [];
    amp_mouse.diff.ripples = []; amp_mouse.diff.out = [];
    amp_mouse.good.ripples = []; amp_mouse.good.out = [];
    amp_mouse.fake.ripples = []; amp_mouse.fake.out = [];
    

    for p=1:length(meanc_res.path)
        if strcmpi(meanc_res.name{p},animals{m})

            %LFP
            mouse_x = meanc_res.met_down.ripples{p}(:,1);
            
            mouse_y.down.ripples = [mouse_y.down.ripples meanc_res.met_down.ripples{p}(:,2)];
            mouse_y.down.out     = [mouse_y.down.out meanc_res.met_down.out{p}(:,2)];
            
            mouse_y.diff.ripples = [mouse_y.diff.ripples meanc_res.met_diff.ripples{p}(:,2)];
            mouse_y.diff.out     = [mouse_y.diff.out meanc_res.met_diff.out{p}(:,2)];
            
            channels_sup = meanc_res.channels{p};
            for ch=1:length(channels_sup)
                mouse_y.good.ripples = [mouse_y.good.ripples meanc_res.met_good.ripples{p,ch}(:,2)];
                mouse_y.good.out     = [mouse_y.good.out meanc_res.met_good.out{p,ch}(:,2)];

                mouse_y.fake.ripples = [mouse_y.fake.ripples meanc_res.met_fake.ripples{p,ch}(:,2)];
                mouse_y.fake.out     = [mouse_y.fake.out meanc_res.met_fake.out{p,ch}(:,2)];
            end
            
            
            %durations
            dur_mouse.down.ripples = [dur_mouse.down.ripples mean(meanc_res.durations.down.ripples{p})];
            dur_mouse.down.out     = [dur_mouse.down.out mean(meanc_res.durations.down.out{p})];
            
            dur_mouse.diff.ripples = [dur_mouse.diff.ripples mean(meanc_res.durations.diff.ripples{p})];
            dur_mouse.diff.out     = [dur_mouse.diff.out mean(meanc_res.durations.diff.out{p})];
            
            channels_sup = meanc_res.channels{p};
            for ch=1:length(channels_sup)
                dur_mouse.good.ripples = [dur_mouse.good.ripples mean(meanc_res.durations.good.ripples{p,ch})];
                dur_mouse.good.out     = [dur_mouse.good.out mean(meanc_res.durations.good.out{p,ch})];

                dur_mouse.fake.ripples = [dur_mouse.fake.ripples mean(meanc_res.durations.fake.ripples{p,ch})];
                dur_mouse.fake.out     = [dur_mouse.fake.out mean(meanc_res.durations.fake.out{p,ch})];
            end
            
            %amplitudes
            amp_mouse.down.ripples = [amp_mouse.down.ripples mean(meanc_res.amplitudes.down.ripples{p})];
            amp_mouse.down.out     = [amp_mouse.down.out mean(meanc_res.amplitudes.down.out{p})];
            
            amp_mouse.diff.ripples = [amp_mouse.diff.ripples mean(meanc_res.amplitudes.diff.ripples{p})];
            amp_mouse.diff.out     = [amp_mouse.diff.out mean(meanc_res.amplitudes.diff.out{p})];
            
            channels_sup = meanc_res.channels{p};
            for ch=1:length(channels_sup)
                amp_mouse.good.ripples = [amp_mouse.good.ripples mean(meanc_res.amplitudes.good.ripples{p,ch})];
                amp_mouse.good.out     = [amp_mouse.good.out mean(meanc_res.amplitudes.good.out{p,ch})];

                amp_mouse.fake.ripples = [amp_mouse.fake.ripples mean(meanc_res.amplitudes.fake.ripples{p,ch})];
                amp_mouse.fake.out     = [amp_mouse.fake.out mean(meanc_res.amplitudes.fake.out{p,ch})];
            end
            
        end
    end
    
    % LFP average per mouse
    met_y.down.ripples = [met_y.down.ripples mean(mouse_y.down.ripples,2)];
    met_y.down.out     = [met_y.down.out mean(mouse_y.down.out,2)];
    
    met_y.diff.ripples = [met_y.diff.ripples mean(mouse_y.diff.ripples,2)];
    met_y.diff.out     = [met_y.diff.out mean(mouse_y.diff.out,2)];
    
    met_y.good.ripples = [met_y.good.ripples mean(mouse_y.good.ripples,2)];
    met_y.good.out     = [met_y.good.out mean(mouse_y.good.out,2)];
    
    met_y.fake.ripples = [met_y.fake.ripples mean(mouse_y.fake.ripples,2)];
    met_y.fake.out     = [met_y.fake.out mean(mouse_y.fake.out,2)];

    met_x = mouse_x;
    
    
    %durations
    durations.down.ripples = [durations.down.ripples ; mean(dur_mouse.down.ripples)]; 
    durations.down.out     = [durations.down.out ; mean(dur_mouse.down.out)];
    
    durations.diff.ripples = [durations.diff.ripples ; mean(dur_mouse.diff.ripples)]; 
    durations.diff.out     = [durations.diff.out ; mean(dur_mouse.diff.out)];
    
    durations.good.ripples = [durations.good.ripples ; mean(dur_mouse.good.ripples)]; 
    durations.good.out     = [durations.good.out ; mean(dur_mouse.good.out)];
    
    durations.fake.ripples = [durations.fake.ripples ; mean(dur_mouse.fake.ripples)]; 
    durations.fake.out     = [durations.fake.out ; mean(dur_mouse.fake.out)];
    
    %amplitudes
    amplitudes.down.ripples = [amplitudes.down.ripples ; mean(amp_mouse.down.ripples)]; 
    amplitudes.down.out     = [amplitudes.down.out ; mean(amp_mouse.down.out)];
    
    amplitudes.diff.ripples = [amplitudes.diff.ripples ; mean(amp_mouse.diff.ripples)]; 
    amplitudes.diff.out     = [amplitudes.diff.out ; mean(amp_mouse.diff.out)];
    
    amplitudes.good.ripples = [amplitudes.good.ripples ; mean(amp_mouse.good.ripples)]; 
    amplitudes.good.out     = [amplitudes.good.out ; mean(amp_mouse.good.out)];
    
    amplitudes.fake.ripples = [amplitudes.fake.ripples ; mean(amp_mouse.fake.ripples)]; 
    amplitudes.fake.out     = [amplitudes.fake.out ; mean(amp_mouse.fake.out)];
    
end

%average
met_all.down.ripples(:,1) = met_x;
met_all.down.ripples(:,2) = mean(met_y.down.ripples, 2)*factorLFP;
met_all.down.ripples(:,3) = std(met_y.down.ripples,0,2)*factorLFP;

met_all.down.out(:,1) = met_x;
met_all.down.out(:,2) = mean(met_y.down.out, 2)*factorLFP;
met_all.down.out(:,3) = std(met_y.down.out,0,2)*factorLFP;

met_all.diff.ripples(:,1) = met_x;
met_all.diff.ripples(:,2) = mean(met_y.diff.ripples, 2)*factorLFP;
met_all.diff.ripples(:,3) = std(met_y.diff.ripples,0,2)*factorLFP;

met_all.diff.out(:,1) = met_x;
met_all.diff.out(:,2) = mean(met_y.diff.out, 2)*factorLFP;
met_all.diff.out(:,3) = std(met_y.diff.out,0,2)*factorLFP;

met_all.good.ripples(:,1) = met_x;
met_all.good.ripples(:,2) = mean(met_y.good.ripples, 2)*factorLFP;
met_all.good.ripples(:,3) = std(met_y.good.ripples,0,2)*factorLFP;

met_all.good.out(:,1) = met_x;
met_all.good.out(:,2) = mean(met_y.good.out, 2)*factorLFP;
met_all.good.out(:,3) = std(met_y.good.out,0,2)*factorLFP;

met_all.fake.ripples(:,1) = met_x;
met_all.fake.ripples(:,2) = mean(met_y.fake.ripples, 2)*factorLFP;
met_all.fake.ripples(:,3) = std(met_y.fake.ripples,0,2)*factorLFP;

met_all.fake.out(:,1) = met_x;
met_all.fake.out(:,2) = mean(met_y.fake.out, 2)*factorLFP;
met_all.fake.out(:,3) = std(met_y.fake.out,0,2)*factorLFP;



%durations & aplitudes TO PLOT
mean_durations  = [durations.down.ripples durations.down.out durations.good.ripples durations.good.out]/10; 
mean_amplitudes = [amplitudes.down.ripples amplitudes.down.out amplitudes.good.ripples amplitudes.good.out]*factorLFP; 



%% PLOT
fontsize = 16;
color_all = [0.7 0.7 0.7];
color_down = 'r';
color_downrip = [1 0.5 0];

color_rip = 'k';
color_out = [0.6 0.6 0.6];

sigtest = 'ranksum';

%fig
figure, hold on


%Down : in and out of ripples
subplot(2,2,1), hold on
%error shadow
% HsRip = shadedErrorBar(met_all.down.ripples(:,1), met_all.down.ripples(:,2), met_all.down.ripples(:,3),{},0.4);
% HsOut = shadedErrorBar(met_all.down.out(:,1), met_all.down.out(:,2), met_all.down.out(:,3),{},0.4);
% HsRip.patch.FaceColor = color_downrip;
% HsOut.patch.FaceColor = color_down;
%mean curves
h(1) = plot(met_all.down.ripples(:,1), met_all.down.ripples(:,2), 'color', color_downrip, 'linewidth',2);
h(2) = plot(met_all.down.out(:,1), met_all.down.out(:,2), 'color', color_down, 'linewidth',2);
%properties
set(gca,'XLim',[-600 600],'Fontsize',fontsize);
line([0 0], ylim,'Linewidth',1,'color',[0.5 0.5 0.5]), hold on
legend(h,'Down after SPW-r', 'Down (no SPW-R)');
xlabel('time from start (ms)'),
ylabel('mean LFP (mV)'), 


%Good Slow wave : in and out of ripples
clear h
subplot(2,2,2), hold on
%error shadow
% HsRip = shadedErrorBar(met_all.good.ripples(:,1), met_all.good.ripples(:,2), met_all.good.ripples(:,3),{},0.4);
% HsOut = shadedErrorBar(met_all.good.out(:,1), met_all.good.out(:,2), met_all.good.out(:,3),{},0.4);
% HsDown = shadedErrorBar(met_all.down.out(:,1), met_all.down.out(:,2), met_all.down.out(:,3),{},0.4);
% HsRip.patch.FaceColor = color_rip;
% HsOut.patch.FaceColor = color_out;
% HsDown.patch.FaceColor = color_down;
%mean curves
h(3) = plot(met_all.down.out(:,1), met_all.down.out(:,2), 'color', color_down, 'linewidth',3);
h(1) = plot(met_all.good.ripples(:,1), met_all.good.ripples(:,2), 'color', color_rip, 'linewidth',2);
h(2) = plot(met_all.good.out(:,1), met_all.good.out(:,2), 'color', color_out, 'linewidth',2);
%properties
set(gca,'XLim',[-600 600],'Fontsize',fontsize);
line([0 0], ylim,'Linewidth',1,'color',[0.5 0.5 0.5]), hold on
legend(h,'SW after SPW-r', 'SW (no SPW-r)','Down (no SPW-R)');
xlabel('time from start (ms)'),
ylabel('mean LFP (mV)'), 


%durations
subplot(2,2,3), hold on
PlotErrorBarN_KJ(mean_durations, 'newfig',0, 'barcolors',{color_downrip, color_down, color_rip, color_out}, 'paired',1, 'optiontest',sigtest, 'showPoints',1,'ShowSigstar','sig');
set(gca,'xtick',1:4,'XtickLabel',{'Down after SPW-r','Down (no SPW-R)','SW after SPW-r', 'SW (no SPW-r)'},'Fontsize',fontsize),
xtickangle(30),
ylabel('Durations (ms)'),

%amplitudes
subplot(2,2,4), hold on
PlotErrorBarN_KJ(mean_amplitudes, 'newfig',0, 'barcolors',{color_downrip, color_down, color_rip, color_out}, 'paired',1, 'optiontest',sigtest, 'showPoints',1,'ShowSigstar','sig');
set(gca,'xtick',1:4,'XtickLabel',{'Down after SPW-r','Down (no SPW-R)','SW after SPW-r', 'SW (no SPW-r)'},'Fontsize',fontsize),
xtickangle(30),
ylabel('LFP Ampltiudes (mV)'),





