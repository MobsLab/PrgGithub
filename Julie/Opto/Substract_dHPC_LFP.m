Dir.path={
%     '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161116';
%     '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161117';

   % '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse459/20161123';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse465/20170126';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse465/20170127';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse466/20170130';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse466/20170131';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse467/20170202';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse467/20170203';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse468/20170207';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse468/20170208';
};
%     for man=1:length(Dir.path), 
%        cd (Dir.path{man})
%         res=pwd;
% 
%         try
%             temp=load([Dir.path{man},'/ChannelsToAnalyse/dHPC_rip.mat']);
%         catch
%             temp=load([Dir.path{man},'/ChannelsToAnalyse/dHPC_deep.mat']);
%         end
%         
%         disp(['sub from ' Dir.path{man}]);
%         eval(['temp2=load(''',Dir.path{man},'/LFPData/LFP',num2str(temp.channel),'.mat'');'])
%         LFP1=temp2.LFP;
%         
%         temp=load([Dir.path{man},'/ChannelsToAnalyse/dHPC_2sub.mat']);
%         eval(['temp2=load(''',Dir.path{man},'/LFPData/LFP',num2str(temp.channel),'.mat'');'])
%         LFP2=temp2.LFP;
%         LFP=tsd(Range(LFP1), Data(LFP1)-Data(LFP2));
%         
%         save([res '/LFPData/LFP36.mat'], 'LFP');
%     end
    
for man=1:length(Dir.path), 
       cd (Dir.path{man})
        res=pwd;
        channel=36; save(['/ChannelsToAnalyse/dHPC_local'], 'channel');
        
end