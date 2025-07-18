% AdujstColorBarOnLaserSpectra
% 24.11.016


DirPath={
'/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse363/20160717-EXT-24h-laser10';
'/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse363/20160718-EXT-48h-laser10';
'/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse363/20160719-EXT-72h-laser4';
    
'/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse367/20160717-EXT-24h-laser10';
'/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse367/20160718-EXT-48h-laser10';
'/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse367/20160719-EXT-72h-laser4';
% %     
% % '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161016-HABenvC-laser4';
% % '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161017-HABenvB-laser10';
% % '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161018-HABgrille';
 '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161019-EXT-24h-laser10';
'/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161020-EXT-48h-laser10';
'/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161021-EXT-72h-laser4';
% 
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse459/20161017-HABenvC-laser4';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse459/20161018-HABenvB-laser10';
% '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse459/20161018-HABgrille';
'/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse459/20161019-EXT-24h-laser10';
'/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse459/20161020-EXT-48h-laser10';
'/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse459/20161021-EXT-72h-laser4';
};

for man=1:length(DirPath)
    DirPath{man}

    cd(DirPath{man})
    res=pwd;
    uiopen([ res '/SpectroLaserAccFreezing_Laser.fig'],1)
    for i=1:6
        h=subplot(7,6,6*i+1:6*i+6);
        colorbar
        caxis([20 60])
    end
    set(gcf,'PaperPosition', [0.6345175   6.345175    30  20])
    indmark=strfind(DirPath{man},'/');
    
    saveas(gcf,['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Spectra_caxis20-60/' DirPath{man}(indmark(end-1)+1:indmark(end)-1) '-' DirPath{man}(indmark(end)+1:end) '.fig'])
    saveas(gcf,['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Spectra_caxis20-60/' DirPath{man}(indmark(end-1)+1:indmark(end)-1) '-' DirPath{man}(indmark(end)+1:end) '.png'])
    close

end