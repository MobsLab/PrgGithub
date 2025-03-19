%%PhaseLFPEffectToneShamPlot
% 30.07.2019 KJ
%
%   
%   
%
% see
%   ParcoursShamEffectPhaseLFP ParcoursTonesEffectPhaseLFP ScriptTonesEffectPhaseLFP
%




% load
clear
load(fullfile(FolderDeltaDataKJ,'ParcoursShamEffectPhaseLFP.mat'))
load(fullfile(FolderDeltaDataKJ,'ParcoursTonesEffectPhaseLFP.mat'))

%params
hstep = 10;
max_edge = 500;
edges_delay = 0:hstep:max_edge;
edges_phase = 0:20:360;
thresh_delay = 4E4; %4sec - maximum delay between a delta and the next tone, for the raster
perc = 0:5:100;

%load
animals = unique(tones_res.name);


%% for each animals
for m=1:length(animals)
    
    %Random tones
    delay_before   = [];
    delay_after    = [];
    phase_deep     = [];
    delta_induced  = [];
    
    for p=1:length(tones_res.path)
        if strcmpi(tones_res.name{p},animals{m})
            delay_before   = [delay_before ; tones_res.up.delay_before{p}/10]; %in ms
            delay_after    = [delay_after ; tones_res.up.delay_after{p}/10]; %in ms
            phase_deep     = [phase_deep ; tones_res.up.lfpphase.deep{p}];
            delta_induced  = [delta_induced ; tones_res.induce_delta{p}];
        end
    end
    
    %histo phase deep
    phase_deep = mod(phase_deep*180/pi,360);
    [tones.mouse.deep.y{m}, tones.mouse.deep.x{m}] = histcounts(phase_deep, edges_phase, 'Normalization','probability');
    tones.mouse.deep.x{m} = tones.mouse.deep.x{m}(1:end-1) + diff(tones.mouse.deep.x{m})/2;    
    
    for i=1:length(edges_phase)-1
        idx = phase_deep>=edges_phase(i) & phase_deep<edges_phase(i+1);
        %success
        phase_induced(i) = sum(delta_induced(idx));
        phase_number(i)  = sum(idx);
        %delay before and after
        phase_delaybefore(i) = mean(delay_before(idx));
        phase_delayafter(i)  = mean(delay_after(idx));
    end
    tones.mouse.induced.y{m} = phase_induced ./ phase_number;
    tones.mouse.before.y{m}  = phase_delaybefore;
    tones.mouse.after.y{m}   = phase_delayafter;
    
    tones.mouse.induced.x{m} = tones.mouse.deep.x{m};
    tones.mouse.before.x{m}  = tones.mouse.deep.x{m};
    tones.mouse.after.x{m}   = tones.mouse.deep.x{m};
    
    %Sham
    delay_before   = [];
    delay_after    = [];
    delta_induced  = [];
    phase_deep     = [];
    
    for p=1:length(sham_res.path)
        if strcmpi(sham_res.name{p},animals{m})
            delay_before   = [delay_before ; sham_res.up.delay_before{p}/10];
            delay_after    = [delay_after ; sham_res.up.delay_after{p}/10];
            phase_deep     = [phase_deep ; sham_res.up.lfpphase.deep{p}];
            delta_induced  = [delta_induced ; sham_res.induce_delta{p}];
        end
    end
    
    %histo phase deep
    phase_deep = mod(phase_deep*180/pi,360);
    [sham.mouse.deep.y{m}, sham.mouse.deep.x{m}] = histcounts(phase_deep, edges_phase, 'Normalization','probability');
    sham.mouse.deep.x{m} = sham.mouse.deep.x{m}(1:end-1) + diff(sham.mouse.deep.x{m})/2;
    
    for i=1:length(edges_phase)-1
        idx = phase_deep>=edges_phase(i) & phase_deep<edges_phase(i+1);
        %success
        phase_induced(i) = sum(delta_induced(idx));
        phase_number(i)  = sum(idx);
        %delay before and after
        phase_delaybefore(i) = mean(delay_before(idx));
        phase_delayafter(i)  = mean(delay_after(idx));
    end
    sham.mouse.induced.y{m} = phase_induced ./ phase_number;
    sham.mouse.before.y{m}  = phase_delaybefore;
    sham.mouse.after.y{m}   = phase_delayafter;
    
    sham.mouse.induced.x{m} = sham.mouse.deep.x{m};
    sham.mouse.before.x{m}  = sham.mouse.deep.x{m};
    sham.mouse.after.x{m}   = sham.mouse.deep.x{m};
    
end


%% concatenate histograms
tones.delay_before  = []; sham.delay_before  = [];
tones.delay_after   = []; sham.delay_after  = [];
tones.phase_deep    = []; sham.phase_deep  = [];
tones.delta_induced = []; sham.delta_induced  = [];

for m=1:length(animals)
    
    tones.delay_before  = [tones.delay_before ; tones.mouse.before.y{m}]; 
    tones.delay_after   = [tones.delay_after ; tones.mouse.after.y{m}]; 
    tones.phase_deep    = [tones.phase_deep ; tones.mouse.deep.y{m}]; 
    tones.delta_induced = [tones.delta_induced ; tones.mouse.induced.y{m}]; 

    sham.delay_before  = [sham.delay_before ; sham.mouse.before.y{m}]; 
    sham.delay_after   = [sham.delay_after ; sham.mouse.after.y{m}]; 
    sham.phase_deep    = [sham.phase_deep ; sham.mouse.deep.y{m}];
    sham.delta_induced = [sham.delta_induced ; sham.mouse.induced.y{m}];
    
end


x_delaybefore  = tones.mouse.before.x{m};
x_delayafter   = tones.mouse.after.x{m};
x_phasedeep    = tones.mouse.deep.x{m};
x_deltainduced = x_phasedeep;



%% Plot
figure, hold on

%delay before
subplot(2,2,1), hold on
[~,h(1)]=PlotErrorLineN_KJ([tones.delay_before tones.delay_before],'x_data',[x_delaybefore x_delaybefore+360],'newfig',0,'linecolor','k','ShowSigstar','none','errorbars',1,'linespec','-.');
[~,h(2)]=PlotErrorLineN_KJ([sham.delay_before sham.delay_before],'x_data',[x_delaybefore x_delaybefore+360],'newfig',0,'linecolor',[0.75 0.75 0.75],'ShowSigstar','none','errorbars',1,'linespec','-.');
ylabel('time from previous delta (ms)'), xlabel('phases')

%delay after
subplot(2,2,2), hold on
[~,h(1)]=PlotErrorLineN_KJ([tones.delay_after tones.delay_after],'x_data',[x_delayafter x_delayafter+360],'newfig',0,'linecolor','k','ShowSigstar','none','errorbars',1,'linespec','-.');
[~,h(2)]=PlotErrorLineN_KJ([sham.delay_after sham.delay_after],'x_data',[x_delayafter x_delayafter+360],'newfig',0,'linecolor',[0.75 0.75 0.75],'ShowSigstar','none','errorbars',1,'linespec','-.');
ylabel('time from next delta (ms)'), xlabel('phases')

%histo of occurence
subplot(2,2,3), hold on
[~,h(1)]=PlotErrorLineN_KJ([tones.phase_deep tones.phase_deep] ,'x_data',[x_phasedeep x_phasedeep+360],'newfig',0,'linecolor','k','ShowSigstar','none','errorbars',1,'linespec','-.');
[~,h(2)]=PlotErrorLineN_KJ([sham.phase_deep sham.phase_deep],'x_data',[x_phasedeep x_phasedeep+360],'newfig',0,'linecolor',[0.75 0.75 0.75],'ShowSigstar','none','errorbars',1,'linespec','-.');
ylabel('probability'), xlabel('tones phases')

%success
subplot(2,2,4), hold on
[~,h(1)]=PlotErrorLineN_KJ([tones.delta_induced tones.delta_induced],'x_data',[x_deltainduced x_deltainduced+360],'newfig',0,'linecolor','k','ShowSigstar','none','errorbars',1,'linespec','-.');
[~,h(2)]=PlotErrorLineN_KJ([sham.delta_induced sham.delta_induced],'x_data',[x_deltainduced x_deltainduced+360],'newfig',0,'linecolor',[0.75 0.75 0.75],'ShowSigstar','none','errorbars',1,'linespec','-.');
ylabel('% success'), xlabel('tones phases')



