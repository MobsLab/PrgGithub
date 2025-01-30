%%GeneratejPETHRipplesDown
% 14.09.2018 KJ
%
%
%   
%
% see
%   
%


clear

Dir = PathForExperimentsSleepRipplesSpikes('all');
Dir = CheckPathForExperiment_KJ(Dir);


for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p
    
    
    %params
    binsize_cc = 10;
    nbins_cc = 100;


    load('SpikeData.mat')
    load('SpikesToAnalyse/PFCx_Neurons.mat')
    NumNeurons = number;
    S=S(NumNeurons);

    load('Ripples.mat', 'Ripples')
    tRipples = ts(Ripples(:,2)*10);

    load('DownState.mat','down_PFCx')
    
    
    %% title
    title_fig = [Dir.name{p}  ' - ' Dir.date{p}];
    filename_fig = ['jPETH_ripDown_' Dir.name{p}  '_' Dir.date{p}];
    filename_png1 = [filename_fig  '.png'];
    filename_png1 = fullfile(FolderFigureDelta,'Mid-Thesis2','jPETH',filename_png1);
    filename_png2 = [filename_fig  '2.png'];
    filename_png2 = fullfile(FolderFigureDelta,'Mid-Thesis2','jPETH',filename_png2);
    
    
    %% jPETh
    [A,B,C]=mjPETH2(Range(PoolNeurons(S,1:length(S))),Range(tRipples),Start(down_PFCx),10,100,title_fig, filename_png1, filename_png2);

    
    

end



