% QuantifRipplesSuccessRate
% 15.03.2018 KJ
% 
% 
% Get the ratio of ripples inducing down
%
%   On mouse 243 (PaCx)
% 
% RipplesDownBimodal1 RipplesDownBimodalPlot
%   
% 
% 

clear

Dir=PathForExperimentsBasalSleepSpike;

for p=1:length(Dir.path)
    

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    if exist('Ripples.mat','file')~=2
        continue
    end
    
    clearvars -except Dir p qrip_res

    qrip_res.path{p}   = Dir.path{p};
    qrip_res.manipe{p} = Dir.manipe{p};
    qrip_res.name{p}   = Dir.name{p};
    qrip_res.date{p}   = Dir.date{p};
    
    %params
    binsize=10;
    effect_period_down = 1500; %150ms


    %% load
    load('DownState.mat', 'down_PFCx')
    start_down = Start(down_PFCx);


    load('Ripples.mat', 'Ripples')
    ripples_tmp = Ripples(:,2) * 10;
    ripples_intv_down = intervalSet(ripples_tmp, ripples_tmp + effect_period_down);
    nb_ripples = length(ripples_tmp);

    
    %% INDUCED a Down ?
    induce_down = zeros(nb_ripples, 1);
    [~,interval,~] = InIntervals(start_down, [Start(ripples_intv_down) End(ripples_intv_down)]);
    down_ripples_success = unique(interval);
    down_ripples_success(down_ripples_success==0)=[];

    qrip_res.nb_ripples(p) = nb_ripples;
    qrip_res.nb_success(p) = length(down_ripples_success);
    qrip_res.ratio(p) = length(down_ripples_success)/nb_ripples;
    
    
end


induce_ratio.mean =  mean(qrip_res.ratio);
induce_ratio.std =  std(qrip_res.ratio);


animals=unique(qrip_res.name);


for m=1:length(animals)
    animals_path = strcmpi(qrip_res.name,animals{m});
    
    mouse_ratio.mean(m) =  mean(qrip_res.ratio(animals_path));
    mouse_ratio.std(m) =  std(qrip_res.ratio(animals_path));
    

end













    