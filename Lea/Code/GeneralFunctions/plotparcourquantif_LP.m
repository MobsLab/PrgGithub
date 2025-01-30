%% PLOTPARCOURQUANTIF_LP function :
%
% 28/04/2020  LP
%
% Function : to run quantif script on all sessions from a PathForExperiments,
%            and save all plots in a specified directory. 
%
% ----------------- INPUTS ----------------- :
%
%   - pathforexp : variable with already loaded PathForExperiments 
%                   (ex. Dir, after Dir = PathForExperimentsBasalSleepSpike2; ) 
%
%   - quantif : name of the script to run, as a string array 
%                   (ex.: 'QuantifEventsDuration') 
%
%   - pathtosave : name of the path to save the plots, as a string array.
%
%
% -- Optional Parameters -- : none
% (as pairs : 'arg_name', arg_value) 
%
%
% ----------------- OUTPUTS ----------------- :
%
%
% ----------------- Examples ----------------- :
%                   
%                    Dir = PathForExperimentsBasalSleepSpike2 ; 
%                    pathtosave = '/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/DeltaSpectral/Results/EventsDuration' ;
%                    plotparcourquantif_LP(Dir,'QuantifEventsDuration',pathtosave)



function plotparcourquantif_LP(pathforexp,quantif,pathtosave)

    Dir = pathforexp ; 
    
    % For each session from the PathForExperiments : 
    for p=1:length(Dir.path)

        disp(' ')
        disp('****************************************************************')
        disp(['File ' num2str(p) '/' num2str(length(Dir.path)) ])
        eval(['cd(Dir.path{',num2str(p),'}'')'])

        % Run Quantif : 
        eval(quantif) ; 
        sgtitle([Dir.name{p} ' (Session nº' num2str(p) ')'] ) ; % add title to the plot

        % Choose Path and Fileame
        cd(pathtosave)
        saveas(gcf,[quantif num2str(p) '_' Dir.name{p} '.png']) 
    end 
    
end
