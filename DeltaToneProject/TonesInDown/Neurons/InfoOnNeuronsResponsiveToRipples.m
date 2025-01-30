%%InfoOnNeuronsResponsiveToRipples
% 20.09.2018 KJ
%
%
%   
%
% see
%   ParcoursRipplesNeuronCrossCorr ClassifyNeuronsResponseToRipples 
%   InfoOnNeuronsResponsiveToRipplesPlot


clear
load(fullfile(FolderDeltaDataKJ,'ParcoursRipplesNeuronCrossCorr.mat'))
night_tones = 1;


for p=1:length(rippeth_res.path)
    if strcmpi(rippeth_res.manipe{p}, 'rdmtone') || night_tones==0
        disp(' ')
        disp('****************************************************************')
        eval(['cd(rippeth_res.path{',num2str(p),'}'')'])
        disp(pwd)

        clearvars -except rippeth_res p infos_res

        infos_res.path{p}   = rippeth_res.path{p};
        infos_res.manipe{p} = rippeth_res.manipe{p};
        infos_res.name{p}   = rippeth_res.name{p};
        infos_res.date{p}   = rippeth_res.date{p};

        %% Infos
        load('InfoNeuronsPFCx.mat', 'InfoNeurons')

        infos_res.firingrate{p} = InfoNeurons.firingrate;
        infos_res.substages{p} = InfoNeurons.substages;
        infos_res.layer{p} = InfoNeurons.layer;
        infos_res.soloist{p} = InfoNeurons.soloist;
        infos_res.putative{p} = InfoNeurons.putative;
        infos_res.fr_substage{p} = InfoNeurons.fr_substage;


        %% neuron class
        rip_data = rippeth_res.MatRipples{p};
        t_corr = rippeth_res.t_corr{p};
        Zpeth_rip = zscore(rip_data,[],2);
        [~,idmax] = max(Zpeth_rip,[],2);
        neuronPeaks = t_corr(idmax); 
        
        infos_res.neuronClass{p} = nan(length(neuronPeaks),1);
        infos_res.neuronClass{p}(neuronPeaks<=-130) = 1;
        infos_res.neuronClass{p}(neuronPeaks>-130 & neuronPeaks<=0) = 2;
        infos_res.neuronClass{p}(neuronPeaks>-0 & neuronPeaks<=70) = 3;
        infos_res.neuronClass{p}(neuronPeaks>70) = 4;
        

    end
end

%saving data
cd(FolderDeltaDataKJ)
save InfoOnNeuronsResponsiveToRipples.mat infos_res


