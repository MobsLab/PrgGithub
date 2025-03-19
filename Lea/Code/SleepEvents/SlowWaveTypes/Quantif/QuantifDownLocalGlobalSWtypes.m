%% QuantifDownLocalGlobalSWtypes
%
% 03/07/2020  LP 
%
% -> Script to quantify index of down state "globality" (global vs local
% down state) associated to different types of SW. Computes the mean proportion
% of tetrodes with a local down state detected during sw associated to
% global down states (during NREM only). 


%% GET DATA :

clear

% --------- Load Data --------- : 

load('LocalDownState.mat') % all_local_PFCx with down states detected on each tetrode separately
load('DownState.mat')
load('SlowWaves2Channels_LP.mat')

all_sw = {slowwave_type3.deep_peaktimes,slowwave_type4.deep_peaktimes,slowwave_type6.deep_peaktimes} ; 
all_sw_names = {'SW3','SW4','SW6'} ; 
all_sw_colors = {[1 0 0.4],[0.6 0.2 0.6],[0 0.6 0.4]} ; 
n_tetrodes = length(all_local_PFCx) ; 



% --------- Extract information on local down states --------- : 

localdown_prop = [] ; 
mean_prop_tetrodes = [] ; % To store mean proportion of tetrodes on which a local down state is detected during global-down associated slow waves. 

for type = 1:length(all_sw)
    sw_ts = all_sw{type} ; 
    
    for tt = 1:n_tetrodes %for each tetrode

        down_tt = all_local_PFCx{tt} ; 
        sw_ts = Restrict(sw_ts,down_PFCx) ; % restrict NREM SW to SW occurring during NREM down states only
        
        sw_inlocaldown{tt} = belong(down_tt,Range(sw_ts)) ; % true for sw occurring during down states on this tetrode, for all tetrodes
        localdown_prop(tt) = sum(sw_inlocaldown{tt})/length(sw_inlocaldown{tt}) *100  ; 
    end
    
    localdown_nb_tetrodes = sum(cell2mat(sw_inlocaldown),2) ; % for each sw (associated to a global down state), number of tetrodes on which a down state is detected
    localdown_prop_tetrodes{type} = localdown_nb_tetrodes / n_tetrodes ; % for each sw (associated to a global down state), PROPORTION of tetrodes on which a down state is detected
    mean_prop_tetrodes(type) = mean(localdown_nb_tetrodes / n_tetrodes) ; % mean proportion of tetrodes with local down states detected as co-occurring with global-down associated sw.
end



%% BARPLOT : 

figure,
hold on,

for type = 1:length(all_sw)
    bar(type,mean_prop_tetrodes(type),'FaceColor',all_sw_colors{type},'FaceAlpha',0.7)  ; 
end

ylim([0 1]) ; 
set(gca,'Xtick',1:3, 'XTickLabel',all_sw_names,'FontSize',12) ; box on ; 
ylabel(['Index of "globality"' newline '(mean prop of tetrodes with a local down state)']) ; 
title(['For SW associated to global down states :']) 



% mean_singlett_prop = [] ; 
%
% for type = 1:length(all_sw)
%     sw_ts = all_sw{type} ; 
%     
%     for tt = 1:n_tetrodes %for each tetrode
% 
%         down_tt = all_local_PFCx{tt} ; 
%         sw_ts = Restrict(sw_ts,down_PFCx) ; % restrict NREM SW to SW occurring during NREM down states only
%         
%         sw_codown_ts = Restrict(sw_ts,down_tt) ; 
%         sw_codown_prop = length(Range(sw_codown_ts))/length(Range(sw_ts)) * 100 ;
%         localdown_prop(tt) = sw_codown_prop  ; 
%          
%     end
%     
%     all_localdown_prop{type} = localdown_prop ; % proportion of 
%     mean_singlett_prop(type) = mean(localdown_prop) ; 
%     
% end
% 

