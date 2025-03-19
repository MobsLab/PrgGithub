% 23.10.2017


 DirPath={
% '/media/DataMOBs57/Fear-March2017/Mouse-498/20170309-EXT-24-laser13/FEAR-Mouse-498-09032017';
% '/media/DataMOBs57/Fear-March2017/Mouse-498/20170310-EXT-48-laser13/FEAR-Mouse-498-10032017';
% '/media/DataMOBs57/Fear-March2017/Mouse-499/20170309-EXT-24-laser13/FEAR-Mouse-499-09032017';
% '/media/DataMOBs57/Fear-March2017/Mouse-499/20170310-EXT-48-laser13/FEAR-Mouse-499-10032017';

% 
% '/media/DataMOBs57/FEAR-March2/Mouse-504/20170316-EXT-24-laser13/FEAR-Mouse-504-16032017';
% '/media/DataMOBs57/FEAR-March2/Mouse-505/20170316-EXT-24-laser13/FEAR-Mouse-505-16032017';
% '/media/DataMOBs57/FEAR-March2/Mouse-506/20170316-EXT-24-laser13/FEAR-Mouse-506-16032017';
% 
% '/media/DataMOBs57/FEAR-March2/Mouse-504/20170317-EXT-48-laser13/FEAR-Mouse-504-17032017';
% '/media/DataMOBs57/FEAR-March2/Mouse-505/20170317-EXT-48-laser13/FEAR-Mouse-505-17032017';
% '/media/DataMOBs57/FEAR-March2/Mouse-506/20170317-EXT-48-laser13/FEAR-Mouse-506-17032017';

'/media/DataMOBs57/Fear-March2017/Mouse-496/20170310-EXT-48-laser13/FEAR-Mouse-496-10032017';
'/media/DataMOBs57/Fear-March2017/Mouse-497/20170310-EXT-48/FEAR-Mouse-497-10032017';

};

% for man=1:length(DirPath)
%     DirPath{man}
%     ind_mark=strfind(DirPath{man},'/');
%     cd(DirPath{man})
%  
%     
%     
% temp=load('LFPData/LFP32.mat');
% LaserLFP=temp.LFP;
%     
% 
% StimLaserOFF=thresholdIntervals(LaserLFP,-500,'Direction','Above');
% StimLaserOFF=dropShortIntervals(StimLaserOFF,0.5*1E4);
% soff= Start(StimLaserOFF);
% eoff= End(StimLaserOFF);
% TotEpoch=intervalSet(0, eoff(end));
% StimLaserON=TotEpoch-StimLaserOFF;
% save behavResources StimLaserON StimLaserOFF -Append
% 
% 
% clear soff eoff StimLaserON TotEpoch

% end


for man=1:length(DirPath)
    DirPath{man}
    ind_mark=strfind(DirPath{man},'/');
    cd(DirPath{man})
    res=pwd;
%     if~isempty(strfind(Dir.path{man},'DataMobs31')) || ~isempty(strfind(Dir.path{man},'DATAMobs55')) 
    behav_folder=[res '-wideband'];
    list_behav=dir([res '-wideband']);
    for i=1:length(list_behav)
        if (length(list_behav(i).name)>3 && strcmp(list_behav(i).name(end-3:end),'.mat') && strcmp(list_behav(i).name(1:4),'FEAR'))
            temp=load([behav_folder,'/',list_behav(i).name]);
            TTL=temp.TTL;
            PosMat=temp.PosMat;
        end
    end
    
    save behavResources TTL PosMat -Append

    clear TTL PosMat
end