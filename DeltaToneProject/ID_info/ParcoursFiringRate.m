% ParcoursFiringRate
% 13.12.2016 KJ
%
% Generate, plot and save figure for all records in the path
%
% Info
%   see
%


Dir1=PathForExperimentsDeltaSleepSpikes('Basal');
Dir2=PathForExperimentsDeltaSleepSpikes('RdmTone');
Dir3=PathForExperimentsDeltaSleepSpikes('DeltaToneAll');
Dir = MergePathForExperiment(Dir1,Dir2);
Dir = MergePathForExperiment(Dir,Dir3);
clear Dir1 Dir2 Dir3


for p=1:length(Dir.path)
    try
        disp(' ')
        disp('****************************************************************')
        eval(['cd(Dir.path{',num2str(p),'}'')'])
        disp(pwd)
        clearvars -except Dir p

        %% MUA and spikes
        binsize = 1000;
        load SpikeData
        try
            eval('load SpikesToAnalyse/PFCx_Neurons')
        catch
            try
                eval('load SpikesToAnalyse/PFCx_MUA')
            catch
                number=[];
            end
        end
        NumNeurons=number;
        clear number
        T=PoolNeurons(S,NumNeurons);
        clear ST
        ST{1}=T;
        try
            ST=tsdArray(ST);
        end
        Q=MakeQfromS(ST,binsize*10);
        y = full(Data(Q));
        x = Range(Q)/3600E4;
        
        figure, hold on
        plot(x,y);
        title(['Firing rate - '  Dir.manipe{p} ' - ' Dir.path{p}]);
        
        %% save fig
        %title
        filename_fig = ['Firing Rate_' Dir.name{p}  '_' Dir.date{p}];
        filename_png = [filename_fig  '.png'];
        %save figure
        cd([FolderFigureDelta 'IDfigures/FiringRate/'])
        saveas(gcf,filename_png,'png')
        close all
    catch 
        disp('problem with this record')
    end
end