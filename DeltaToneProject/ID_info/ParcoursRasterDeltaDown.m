% ParcoursRasterDeltaDown
% 15.12.2016 KJ
%
% Generate, plot and save figure for all records in the path
%
% Info
%   see
%

clear

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

        %% Load
        binsize = 10;
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
        
        %LFP
        load ChannelsToAnalyse/PFCx_deep
        eval(['load LFPData/LFP',num2str(channel)])
        LFPdeep=LFP;
        clear LFP
        try
            load ChannelsToAnalyse/PFCx_sup
        catch
            load ChannelsToAnalyse/PFCx_deltasup
        end
        eval(['load LFPData/LFP',num2str(channel)])
        LFPsup=LFP;
        clear LFP
        clear channel
        
        %LFPdiff
%         k=1;
%         for i=0.1:0.1:4
%             distance(k)=std(Data(LFPdeep)-i*Data(LFPsup));
%             k=k+1;
%         end
%         Factor=find(distance==min(distance))*0.1;
        LFPdiff=tsd(Range(LFPdeep),Data(LFPdeep) - Data(LFPsup));
        
        %Delta waves
        try
            load DeltaPFCx DeltaOffline
            tdeltas = ts((Start(DeltaOffline)+End(DeltaOffline))/2); 
            delta_duration = End(DeltaOffline) - Start(DeltaOffline);
        catch
            load newDeltaPFCx DeltaEpoch
            tdeltas = ts((Start(DeltaOffline)+End(DeltaOffline))/2); 
            delta_duration = End(DeltaEpoch) - Start(DeltaEpoch);
        end

        
        %% Raster and MET
        if ~isempty(NumNeurons)
            % Raster
            [~, idx_delta] = sort(delta_duration,'descend');
            t_before = -5000; %in 1E-4s
            t_after = 5000; %in 1E-4s
            raster_tsd = RasterMatrixKJ(Q, tdeltas, t_before, t_after,idx_delta);
            raster_matrix = Data(raster_tsd)';
            raster_x = Range(raster_tsd);
        end
        
        % LFP averaged on delta
        binsize_MET = 10;
        nb_bins_MET = 100;
        [Mdeep.y,~,Mdeep.x] = mETAverage(Range(tdeltas), Range(LFPdeep), Data(LFPdeep), binsize_MET, nb_bins_MET);
        [Msup.y,~,Msup.x] = mETAverage(Range(tdeltas), Range(LFPsup), Data(LFPsup), binsize_MET, nb_bins_MET);
        [Mdiff.y,~,Mdiff.x] = mETAverage(Range(tdeltas), Range(LFPdiff), Data(LFPdiff), binsize_MET, nb_bins_MET);
        [Mmua.y,~,Mmua.x] = mETAverage(Range(tdeltas), Range(Q), full(Data(Q)), binsize_MET, nb_bins_MET);
        
        %% PLOT AND SAVE FIG1 (mean)
        figure, hold on
        yyaxis right
        plot(Mmua.x/1E3, Mmua.y, 'k'), hold on
        yyaxis left
        plot(Mdeep.x/1E3, Mdeep.y, 'b'), hold on
        plot(Msup.x/1E3, Msup.y, 'r'), hold on
        plot(Mdiff.x/1E3, Mdiff.y, 'color',[0.2 0.2 0.2],'Linewidth',2,'Linestyle','--'), hold on
        h_leg = legend('PFCx deep', 'PFCx sup', 'PFCx diff'); set(h_leg,'FontSize',20);
        set(gca, 'YTick',[-1000 0 1000 2000], 'XLim',[-0.3,0.4],'FontName','Times','fontsize',12);
        
        % save fig
        title(['DeltaDownMean_' Dir.name{p}  '_' Dir.date{p}]);
        %name_fig
        filename_fig = ['DeltaDownMean_' Dir.name{p}  '_' Dir.date{p}];
        filename_png = [filename_fig  '.png'];
        %save figure
        cd([FolderFigureDelta 'IDfigures/DeltaDownMean/'])
        saveas(gcf,filename_png,'png')
        close
        
        
        %% PLOT AND SAVE FIG2 (raster)
        figure, hold on
        %LFP average
        s1=subplot(10,1,1:3); hold on
        plot(Mdeep.x/1E3, Mdeep.y, 'b'), hold on
        plot(Msup.x/1E3, Msup.y, 'r'), hold on
        plot(Mdiff.x/1E3, Mdiff.y, 'color',[0.2 0.2 0.2],'Linewidth',2,'Linestyle','--'), hold on
        h_leg = legend('PFCx deep', 'PFCx sup', 'PFCx diff'); set(h_leg,'FontSize',20);
        set(gca, 'YTick',[-1000 0 1000 2000],'Xticklabel',{[]},'XLim',[-0.3,0.4],'FontName','Times','fontsize',12);
        %MUA raster
        s2=subplot(10,1,4:10); hold on
        imagesc(raster_x/1E4, 1:size(raster_matrix,1), raster_matrix), hold on
        axis xy, xlabel('time (sec)'), ylabel('# delta'), hold on
        set(gca,'Yticklabel',{[]},'XLim',[-0.3,0.4], 'YLim',[0 size(raster_matrix,1)],'FontName','Times','fontsize',12);
        hb = colorbar('location','eastoutside'); hold on
        %align subplots
        s1Pos = get(s1,'position');
        s2Pos = get(s2,'position');
        s2Pos(3) = [s1Pos(3)];
        set(s2,'position',s2Pos);
        
        % save fig
        title(['DeltaDownRaster_' Dir.name{p}  '_' Dir.date{p}]);
        %name_fig
        filename_fig = ['DeltaDownRaster_' Dir.name{p}  '_' Dir.date{p}];
        filename_png = [filename_fig  '.png'];
        %save figure
        cd([FolderFigureDelta 'IDfigures/DeltaDownRaster/'])
        saveas(gcf,filename_png,'png')
        close
        
        
    catch 
        disp('problem with this record')
    end
end


