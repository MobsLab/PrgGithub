% RunSpectroLaser
% 19.07.2016

%WorkingPath='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Spectro_ChR2';
WorkingPath='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/LaserChR2-fear';
 DirPath={
% '/media/DataMobs31/OPTO_CHR2_DATA/Mouse-363/20160714-HAB-envB-laser10/FEAR-Mouse-363-14072016';
%  '/media/DataMobs31/OPTO_CHR2_DATA/Mouse-363/20160714-HAB-envC-laser4/FEAR-Mouse-363-14072016';
%     a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse363/20160717-EXT-24h-laser10';
% '/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse363/20160718-EXT-48h-laser10';
% '/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse363/20160719-EXT-72h-laser4';
%     
% 
%     

%     
%'/media/DataMobs31/OPTO_CHR2_DATA/Mouse-367/20160704-HAB-envB-laser10/FEAR-Mouse-367-14072016';
% '/media/DataMobs31/OPTO_CHR2_DATA/Mouse-367/20160704-HAB-envC-laser4/FEAR-Mouse-367-14072016';    

% '/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse367/20160717-EXT-24h-laser10';
% '/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse367/20160718-EXT-48h-laser10';
% '/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse367/20160719-EXT-72h-laser4';

%  '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161016-HAB-envC-laser4';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161017-HAB-envB-laser10';
% 
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161019-EXT-24h-laser10';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161020-EXT-48h-laser10';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161021-EXT-72h-laser4';
    
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse459/20161017-HAB-envC-laser4';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse459/20161018-HAB-envB-laser10';
% 
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse459/20161019-EXT-24h-laser10';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse459/20161020-EXT-48h-laser10';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse459/20161021-EXT-72h-laser4';

% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse465/20161218-HABenvC-laser4';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse465/20161219-HABenvB-laser10';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse465/20161220-EXT-24h-envB-laser10';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse465/20161221-EXT-48h-envC-laser10';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse465/20161222-EXT-72h-envC-laser4';
% 
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse466/20161218-HABenvC-laser4';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse466/20161219-HABenvB-laser10';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse466/20161220-EXT-24h-envB-laser10';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse466/20161221-EXT-48h-envC-laser10';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse466/20161222-EXT-72h-envC-laser4';
% 
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse467/20161218-HABenvC-laser4';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse467/20161219-HABenvB-laser10';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse467/20161220-EXT-24h-envB-laser10';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse467/20161221-EXT-48h-envC-laser10';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse467/20161222-EXT-72h-envC-laser4';
% 
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse468/20161218-HABenvC-laser4';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse468/20161219-HABenvB-laser10';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse468/20161220-EXT-24h-envB-laser10';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse468/20161221-EXT-48h-envC-laser10';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse468/20161222-EXT-72h-envC-laser4';
    
% % % '/media/DATAMobs55/Mouse-465/20161218-HAB-envC-laser4/FEAR-Mouse-465-18122016';  
% % % '/media/DATAMobs55/Mouse-465/20161219-HAB-envB-laser10/FEAR-Mouse-465-19122016';  
% % % '/media/DATAMobs55/Mouse-465/20161220-EXT-24h-envB-laser10/FEAR-Mouse-465-20122016';  
% % % '/media/DATAMobs55/Mouse-465/20161221-EXT-48h-envC-laser10/FEAR-Mouse-465-21122016';  
% % % '/media/DATAMobs55/Mouse-465/20161222-EXT-72h-envC-laser4/FEAR-Mouse-465-22122016';  
% % %     
% % % '/media/DATAMobs55/Mouse-466/20161218-HAB-envC-laser4/FEAR-Mouse-466-18122016';  
% % % '/media/DATAMobs55/Mouse-466/20161219-HAB-envB-laser10/FEAR-Mouse-466-19122016';  
% % % '/media/DATAMobs55/Mouse-466/20161220-EXT-24h-envB-laser10/FEAR-Mouse-466-20122016';  
% % % '/media/DATAMobs55/Mouse-466/20161221-EXT-48h-envC-laser10/FEAR-Mouse-466-21122016';  
% % % '/media/DATAMobs55/Mouse-466/20161222-EXT-72h-envC-laser4/FEAR-Mouse-466-22122016';  
% % %     
% % % '/media/DATAMobs55/Mouse-467/20161218-HAB-envC-laser4/FEAR-Mouse-467-18122016';  
% % % '/media/DATAMobs55/Mouse-467/20161219-HAB-envB-laser10/FEAR-Mouse-467-19122016';  
% % % '/media/DATAMobs55/Mouse-467/20161220-EXT-24h-envB-laser10/FEAR-Mouse-467-20122016';  
% % % '/media/DATAMobs55/Mouse-467/20161221-EXT-48h-envC-laser10/FEAR-Mouse-467-21122016';  
% % % '/media/DATAMobs55/Mouse-467/20161222-EXT-72h-envC-laser4/FEAR-Mouse-467-22122016';  
% % %     
% % % '/media/DATAMobs55/Mouse-468/20161218-HAB-envC-laser4/FEAR-Mouse-468-18122016';  
% % % '/media/DATAMobs55/Mouse-468/20161219-HAB-envB-laser10/FEAR-Mouse-468-19122016';  
% % % '/media/DATAMobs55/Mouse-468/20161220-EXT-24h-envB-laser10/FEAR-Mouse-468-20122016';  
% % % '/media/DATAMobs55/Mouse-468/20161221-EXT-48h-envC-laser10/FEAR-Mouse-468-21122016';  
% % % '/media/DATAMobs55/Mouse-468/20161222-EXT-72h-envC-laser4/FEAR-Mouse-468-22122016';  

% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse504/20170316-EXT-24-laser13';
'/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse504/20170317-EXT-48-laser13';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse505/20170316-EXT-24-laser13';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse505/20170317-EXT-48-laser13';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse506/20170316-EXT-24-laser13';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse506/20170317-EXT-48-laser13';
 };

% DirPath=PathForExperimentFEAR('Fear-electrophy-opto','fear',0);
%    
% 
% 
%     
%    '/media/DataMobs31/OPTO_CHR2_DATA/Mouse-363/20160718-EXT-48-laser10/FEAR-Mouse-363-18072016';
%     '/media/DataMobs31/OPTO_CHR2_DATA/Mouse-363/20160719-EXT-72-laser4/FEAR-Mouse-363-19072016';};
% %'/media/DataMobs31/OPTO_CHR2_DATA/Mouse-367/20160717-EXT-24-laser10/FEAR-Mouse-367-17072016';
% %'/media/DataMobs31/OPTO_CHR2_DATA/Mouse-367/20160718-EXT-48-laser10/FEAR-Mouse-367-18072016';
% %'/media/DataMobs31/OPTO_CHR2_DATA/Mouse-367/20160719-EXT-72-laser4/FEAR-Mouse-367-19072016';'/media/DataMobs31/OPTO_CHR2_DATA/Mouse-363/20160717-EXT-24-laser10/FEAR-Mouse-363-17072016';

for man=1:length(DirPath)
    DirPath{man}
    ind_mark=strfind(DirPath{man},'/');
    cd(DirPath{man})
    SpectroLaser
    set(gcf,'PaperPosition', [0.6345175                  6.345175                  30                 20])
    
    figurename=[DirPath{man}(ind_mark(end-1)+1:ind_mark(end)-1) '-' DirPath{man}(ind_mark(end)+1:end)];
%     figurename=[DirPath{man}(ind_mark(end-1)+1:ind_mark(end)-1) '-' DirPath{man}(ind_mark(end)+1:end) '-bulb'];
    % figurename=[DirPath{man}(ind_mark(end)+1:end) '-Bulb'];
    saveas(gcf,[ WorkingPath '/' figurename '.fig'])
    saveas(gcf,[ WorkingPath '/' figurename '.png'])
    close

end