function [] = Difference_SleepScoring(DataLocation,all)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes her

h = 0;

allNoise_Stim = {};
groundNoise_Stim = {};
noNoise_Stim = {};

allNoise_Base = {};
groundNoise_Base = {};
noNoise_Base = {};

    for l = 1:2:length(DataLocation)
        
        h = h+1;
        
        %% Creation of the new cell

        ind = strfind(DataLocation{l},'/M');
        Mouse_Nb = DataLocation{l}(ind(1)+1:ind(1)+4);
        night_Stim = DataLocation{l}(ind(1)+6:ind(1)+13);
        night_Baseline = DataLocation{l+1}(ind(1)+6:ind(1)+13);
        
        %% Loading of the files States for each SleepScoring
        cd(DataLocation{l})
        cd ..
        allNoise_Stim{h} = load([Mouse_Nb '_Stim_' night_Stim '_States.mat']);
        cd('Test_SleepScoring/Without_High_Noise')
        groundNoise_Stim{h} = load([Mouse_Nb '_Stim_' night_Stim '_States_groundNoise.mat']);
        cd ..
        cd('Without_all_Noise')
        noNoise_Stim{h} = load([Mouse_Nb '_Stim_' night_Stim '_States_noNoise.mat']);
    
        cd(DataLocation{l+1})
        cd ..
        allNoise_Base{h} = load([Mouse_Nb '_Baseline_' night_Baseline '_States.mat']);
        cd('Test_SleepScoring/Without_High_Noise')
        groundNoise_Base{h} = load([Mouse_Nb '_Baseline_' night_Baseline '_States_groundNoise.mat']);
        cd ..
        cd('Without_all_Noise')
        noNoise_Base{h} = load([Mouse_Nb '_Baseline_' night_Baseline '_States_noNoise.mat']);

        %% Plotting the graphs to compare the SleepScoring

        %tracer Wake, SWS, REM et Noise sur le me graph
        % c = categorical({'Wake','SWS','REM', 'Noise'});

        % figure
        % 
        % subplot(3,2,1)
        % bar(c,allNoise_Stim{1}.States(:,2))
        % title('allNoise Stim' )
        % 
        % subplot(3,2,3)
        % bar(c,groundNoise_Stim{1}.States(:,2))
        % title('groundNoise Stim' )
        % 
        % subplot(3,2,5)
        % bar(c,noNoise_Stim{1}.States(:,2))
        % title('noNoise Stim' )
        % 
        % subplot(3,2,2)
        % bar(c,allNoise_Base{1}.States(:,2))
        % title('allNoise Base' )
        % 
        % subplot(3,2,4)
        % bar(c,groundNoise_Base{1}.States(:,2))
        % title('groundNoise Base' )
        % 
        % subplot(3,2,6)
        % bar(c,noNoise_Base{1}.States(:,2))
        % title('noNoise Base' )

        %tracer Stim et baseline sur le me graph
        
        
 %% total duration of the REM
 
        c = categorical({'Stim','Baseline'});

        figure

        subplot(3,3,1)
        bar(c,[allNoise_Stim{h}.States(1,2) allNoise_Base{h}.States(1,2)])
        title('Wake allNoise' )
        ylim([0 6])

        subplot(3,3,4)
        bar(c,[groundNoise_Stim{h}.States(1,2); groundNoise_Base{h}.States(1,2)])
        title('Wake groundNoise' )
        ylim([0 6])

        subplot(3,3,7)
        bar(c,[noNoise_Stim{h}.States(1,2); noNoise_Base{h}.States(1,2)])
        title('Wake noNoise' )
        ylim([0 6])

        subplot(3,3,2)
        bar(c,[allNoise_Stim{h}.States(2,2); allNoise_Base{h}.States(2,2)])
        title('SWS allNoise' )
        ylim([0 6])

        subplot(3,3,5)
        bar(c,[groundNoise_Stim{h}.States(2,2); groundNoise_Base{h}.States(2,2)])
        title('SWS groundNoise' )
        ylim([0 6])

        subplot(3,3,8)
        bar(c,[noNoise_Stim{h}.States(2,2); noNoise_Base{h}.States(2,2)])
        title('SWS noNoise' )
        ylim([0 6])

        subplot(3,3,3)
        bar(c,[allNoise_Stim{h}.States(3,2); allNoise_Base{h}.States(3,2)])
        title('REM allNoise' )
        %ylim([0 6])

        subplot(3,3,6)
        bar(c,[groundNoise_Stim{h}.States(3,2); groundNoise_Base{h}.States(3,2)])
        title('REM groundNoise' )
        %ylim([0 6])

        subplot(3,3,9)
        bar(c,[noNoise_Stim{h}.States(3,2); noNoise_Base{h}.States(3,2)])
        title('REM noNoise' )
        %ylim([0 6])

        [ax,h1]=suplabel('Total time in the night (h)','y'); 
        [ax,h3]=suplabel([Mouse_Nb ' - Stim' night_Stim ' - Baseline' night_Baseline] ,'t'); 

    end
    
    AllResults_Stim = {{[] [] []},{[] [] []},{[] [] []}};
    AllResults_Base = {{[] [] []},{[] [] []},{[] [] []}};
    
    if all == 'all'
        
        for f = 1:h
            AllResults_Stim{1}{1} = [AllResults_Stim{1}{1}; allNoise_Stim{f}.States(1,2)/sum(allNoise_Stim{f}.States(:,2)) ];
            AllResults_Base{1}{1} = [AllResults_Base{1}{1}; allNoise_Base{f}.States(1,2)/sum(allNoise_Stim{f}.States(:,2)) ];
            AllResults_Stim{1}{2} = [AllResults_Stim{1}{2}; allNoise_Stim{f}.States(2,2)/sum(allNoise_Stim{f}.States(:,2)) ];
            AllResults_Base{1}{2} = [AllResults_Base{1}{2}; allNoise_Base{f}.States(2,2)/sum(allNoise_Stim{f}.States(:,2)) ];
            AllResults_Stim{1}{3} = [AllResults_Stim{1}{3}; allNoise_Stim{f}.States(3,2)/sum(allNoise_Stim{f}.States(:,2)) ];
            AllResults_Base{1}{3} = [AllResults_Base{1}{3}; allNoise_Base{f}.States(3,2)/sum(allNoise_Stim{f}.States(:,2)) ];
            
            AllResults_Stim{2}{1} = [AllResults_Stim{2}{1}; groundNoise_Stim{f}.States(1,2)/sum(allNoise_Stim{f}.States(:,2)) ];
            AllResults_Base{2}{1} = [AllResults_Base{2}{1}; groundNoise_Base{f}.States(1,2)/sum(allNoise_Stim{f}.States(:,2)) ];
            AllResults_Stim{2}{2} = [AllResults_Stim{2}{2}; groundNoise_Stim{f}.States(2,2)/sum(allNoise_Stim{f}.States(:,2)) ];
            AllResults_Base{2}{2} = [AllResults_Base{2}{2}; groundNoise_Base{f}.States(2,2)/sum(allNoise_Stim{f}.States(:,2)) ];
            AllResults_Stim{2}{3} = [AllResults_Stim{2}{3}; groundNoise_Stim{f}.States(3,2)/sum(allNoise_Stim{f}.States(:,2)) ];
            AllResults_Base{2}{3} = [AllResults_Base{2}{3}; groundNoise_Base{f}.States(3,2)/sum(allNoise_Stim{f}.States(:,2)) ];
            
            AllResults_Stim{3}{1} = [AllResults_Stim{3}{1}; noNoise_Stim{f}.States(1,2)/sum(allNoise_Stim{f}.States(:,2)) ];
            AllResults_Base{3}{1} = [AllResults_Base{3}{1}; noNoise_Base{f}.States(1,2)/sum(allNoise_Stim{f}.States(:,2)) ];
            AllResults_Stim{3}{2} = [AllResults_Stim{3}{2}; noNoise_Stim{f}.States(2,2)/sum(allNoise_Stim{f}.States(:,2)) ];
            AllResults_Base{3}{2} = [AllResults_Base{3}{2}; noNoise_Base{f}.States(2,2)/sum(allNoise_Stim{f}.States(:,2)) ];
            AllResults_Stim{3}{3} = [AllResults_Stim{3}{3}; noNoise_Stim{f}.States(3,2)/sum(allNoise_Stim{f}.States(:,2)) ];
            AllResults_Base{3}{3} = [AllResults_Base{3}{3}; noNoise_Base{f}.States(3,2)/sum(allNoise_Stim{f}.States(:,2)) ];
            
        end
        
        PlotErrorBarN_KJ({AllResults_Stim{1}{1}, AllResults_Base{1}{1}});
        title('Wake allNoise')
        xticks([1 2 ])
        xticklabels({'Stimulation','Baseline'})
        ylabel('average time in the nigth (h)')

        PlotErrorBarN_KJ({AllResults_Stim{2}{1}, AllResults_Base{2}{1}});
        title('Wake groundNoise')
        xticks([1 2 ])
        xticklabels({'Stimulation','Baseline'})
        ylabel('average time in the nigth (h)')
     
        PlotErrorBarN_KJ({AllResults_Stim{3}{1}, AllResults_Base{3}{1}});
        title('Wake noNoise')
        xticks([1 2 ])
        xticklabels({'Stimulation','Baseline'})
        ylabel('average time  in the nigth(h)')

        PlotErrorBarN_KJ({AllResults_Stim{1}{2}, AllResults_Base{1}{2}});
        title('SWS allNoise')
        xticks([1 2 ])
        xticklabels({'Stimulation','Baseline'})
        ylabel('average time in the nigth (h)')

        PlotErrorBarN_KJ({AllResults_Stim{2}{2}, AllResults_Base{2}{2}});
        title('SWS groundNoise')
        xticks([1 2 ])
        xticklabels({'Stimulation','Baseline'})
        ylabel('average time in the nigth (h)')
     
        PlotErrorBarN_KJ({AllResults_Stim{3}{2}, AllResults_Base{3}{2}});
        title('SWS noNoise')
        xticks([1 2 ])
        xticklabels({'Stimulation','Baseline'})
        ylabel('average time in the nigth (h)')

        PlotErrorBarN_KJ({AllResults_Stim{1}{3}, AllResults_Base{1}{3}});
        title('REM allNoise')
        xticks([1 2 ])
        xticklabels({'Stimulation','Baseline'})
        ylabel('average time in the nigth (h)')

        PlotErrorBarN_KJ({AllResults_Stim{2}{3}, AllResults_Base{2}{3}});
        title('REM groundNoise')
        xticks([1 2 ])
        xticklabels({'Stimulation','Baseline'})
        ylabel('average time in the nigth (h)')
     
        PlotErrorBarN_KJ({AllResults_Stim{3}{3}, AllResults_Base{3}{3}});
        title('REM noNoise')
        xticks([1 2 ])
        xticklabels({'Stimulation','Baseline'})
        ylabel('average time in the nigth (h)')
        
    end
        
end

