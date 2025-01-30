% 
% 19.07.2016
WorkingPath='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Spectro_ChR2';

DirPath={'/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse363/20160717-EXT-24h-laser10';
   '/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse363/20160718-EXT-48h-laser10';
    '/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse363/20160719-EXT-72h-laser4';

%     '/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse367/20160717-EXT-24h-laser10';
%     '/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse367/20160718-EXT-48h-laser10';
%     '/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse367/20160719-EXT-72h-laser4';
};

% DirPath={
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
    % figurename=[DirPath{man}(ind_mark(end)+1:end) '-Bulb'];
    saveas(gcf,[ WorkingPath '/' figurename '.fig'])
    saveas(gcf,[ WorkingPath '/' figurename '.png'])
    close

end