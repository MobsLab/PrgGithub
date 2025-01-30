% RunSpectroLaserAccFreezing
% 21.11.016


DirPath={
% '/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse363/20160717-EXT-24h-laser10';
% '/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse363/20160718-EXT-48h-laser10';
% '/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse363/20160719-EXT-72h-laser4';
%     
% '/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse367/20160717-EXT-24h-laser10';
% '/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse367/20160718-EXT-48h-laser10';
% '/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse367/20160719-EXT-72h-laser4';
%     
% % '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161016-HABenvC-laser-4';
% % '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161017-HABenvB-laser-10';
% % '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161018-HABgrille';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161019-EXT-24h-laser-10';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161020-EXT-48h-laser-10';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161021-EXT-72h-laser-4';
% 
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse459/20161017-HABenvC-laser-4';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse459/20161018-HABenvB-laser10';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse459/20161018-HABgrille';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse459/20161019-EXT-24h-laser-10';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse459/20161020-EXT-48h-laser-10';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse459/20161021-EXT-72h-laser-4';
% 
% 
% '/media/DataMOBs57/Fear_July2017/Mouse-540/20170727-EXT24-laser13/FEAR-Mouse-540-27072017';
% '/media/DataMOBs57/Fear_July2017/Mouse-540/20170728-EXT48-laser13/FEAR-Mouse-540-28072017';
% '/media/DataMOBs57/Fear_July2017/Mouse-542/20170727-EXT24-laser13/FEAR-Mouse-542-27072017';
% '/media/DataMOBs57/Fear_July2017/Mouse-542/20170728-EXT48-laser13/FEAR-Mouse-542-28072017';
% '/media/DataMOBs57/Fear_July2017/Mouse-543/20170727-EXT24-laser13/FEAR-Mouse-543-27072017';
% '/media/DataMOBs57/Fear_July2017/Mouse-543/20170728-EXT48-laser13/FEAR-Mouse-543-28072017';
% '/media/DataMOBs57/Fear_July2017/Mouse-537/20170727-EXT24-laser13/FEAR-Mouse-537-27072017';
% '/media/DataMOBs57/Fear_July2017/Mouse-537/20170728-EXT48-laser13/FEAR-Mouse-537-28072017';

% '/media/DataMOBs57/Fear-Oct2017/Mouse-610/20171006-EXT-48/FEAR-Mouse-610-06102017';
% 
% '/media/DataMOBs57/Fear-Oct2017/Mouse-611/20171005-EXT-24/FEAR-Mouse-611-05102017';
% '/media/DataMOBs57/Fear-Oct2017/Mouse-611/20171006-EXT-48/FEAR-Mouse-611-06102017';
% 
% '/media/DataMOBs57/Fear-Oct2017/Mouse-612/20171005-EXT-24/FEAR-Mouse-612-05102017';
% '/media/DataMOBs57/Fear-Oct2017/Mouse-612/20171006-EXT-48/FEAR-Mouse-612-06102017';
% 
% '/media/DataMOBs57/Fear-Oct2017/Mouse-613/20171005-EXT-24/FEAR-Mouse-613-05102017';
% '/media/DataMOBs57/Fear-Oct2017/Mouse-613/20171006-EXT-48/FEAR-Mouse-613-06102017';
% 
% '/media/DataMOBs57/Fear-Oct2017/Mouse-614/20171005-EXT-24/FEAR-Mouse-614-05102017';
% '/media/DataMOBs57/Fear-Oct2017/Mouse-614/20171006-EXT-48/FEAR-Mouse-614-06102017';


% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse504/20170316-EXT-24-laser13';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse504/20170317-EXT-48-laser13';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse505/20170316-EXT-24-laser13';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse505/20170317-EXT-48-laser13';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse506/20170316-EXT-24-laser13';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse506/20170317-EXT-48-laser13';
% 
% 
% 
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse498/20170309-EXT-24-laser13';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse498/20170310-EXT-48-laser13';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse499/20170309-EXT-24-laser13';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse499/20170310-EXT-48-laser13';

% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse496/20170309-EXT-24-laser13/FEAR-Mouse-496-09032017';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse497/20170309-EXT-24-laser13/FEAR-Mouse-497-09032017';
'/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse496/20170310-EXT-48-laser13/FEAR-Mouse-496-10032017';
'/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse497/20170310-EXT-48-laser13';

% '/media/DataMOBs57/Fear-March2017/Mouse-499/20170309-EXT-24-laser13/FEAR-Mouse-499-09032017';
% '/media/DataMOBs57/Fear-March2017/Mouse-499/20170310-EXT-48-laser13/FEAR-Mouse-499-10032017';

};

% 
% Dir=PathForExperimentFEAR('Fear-electrophy-opto');
% Dir = RestrictPathForExperiment(Dir,'Group',{'GADgfp','GADchr2'}); % [498 499 504 505 506 537 610 611]
% DirPath2=Dir.path;

% for man=length(DirPath)+1:length(DirPath)
 %     DirPath2(man)
%     cd(DirPath2{man})
for man=1:length(DirPath)
DirPath{man}
cd(DirPath{man})

    SpectroLaserAccFreezing
    close

end