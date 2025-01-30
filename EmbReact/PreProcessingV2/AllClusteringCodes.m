%%% 490
% cd /media/DataMOBS56_/ProjectEmbReact/Mouse490/OrderedFiles
% load('AllFolderNames.mat')
% PlaceName='/media/DataMOBS56_/ProjectEmbReact/Mouse490/OrderedFiles';
% for f=4:23
%     FolderName{f}=[PlaceName,FolderName{f}];
%     cd(FolderName{f})
%     FileName=[FolderName{f}(max(strfind(FolderName{f},'ProjectEmbReact_M490')):end) '_SpikeRef.fil'];
%     FileName=strrep(FileName,'/','_');
%     movefile(FileName,...
%         ['/media/DataMOBS56_/ProjectEmbReact/Mouse490/OrderedFiles/SpikeSortingAltogether/ProjectEmbReact_M490-', num2str(f,'%02d'), '.dat'])  
%     
% end

% encours : 
cd /media/DataMOBS56_/ProjectEmbReact/Mouse490/OrderedFiles/SpikeSortingAltogether/
system('ndm_concatenate ProjectEmbReact_M490')
movefile('ProjectEmbReact_M490.dat','ProjectEmbReact_M490.fil')
system('ndm_hipass ProjectEmbReact_M490')
system('ndm_extractspikes ProjectEmbReact_M490')
system('ndm_pca ProjectEmbReact_M490')
system('KlustaKwiknew ProjectEmbReact_M490 1 & KlustaKwiknew ProjectEmbReact_M490 2 & KlustaKwiknew ProjectEmbReact_M490 3')
system('KlustaKwiknew ProjectEmbReact_M490 4 & KlustaKwiknew ProjectEmbReact_M490 5 & KlustaKwiknew ProjectEmbReact_M490 6')



%%% 514
% cd /media/DataMOS69/OrderedFiles/
% load('AllFolderNames.mat')
% PlaceName='/media/DataMOS69/OrderedFiles';
% for f=1:23
%     FolderName{f}=[PlaceName,FolderName{f}];
%     cd(FolderName{f})
%          FileName=[FolderName{f}(max(strfind(FolderName{f},'ProjectEmbReact_M51')):end) '_SpikeRef.fil'];
%      FileName=strrep(FileName,'/','_');
% 
%     movefile(FileName,...
%         ['/media/DataMOS69/OrderedFiles/SpikeSortingAllTogether/ProjectEmbReact_M514-', num2str(f,'%02d'), '.dat'])  
% end

% encours : 
cd /media/DataMOS69/OrderedFiles/SpikeSortingAllTogether/
% system('ndm_concatenate ProjectEmbReact_M514')
% movefile('ProjectEmbReact_M514.dat','ProjectEmbReact_M514.fil')
% system('ndm_hipass ProjectEmbReact_M514')
% system('ndm_extractspikes ProjectEmbReact_M514')
% system('ndm_pca ProjectEmbReact_M514')
% system('KlustaKwiknew ProjectEmbReact_M514 1 & KlustaKwiknew ProjectEmbReact_M514 2 & KlustaKwiknew ProjectEmbReact_M514 3')
system('KlustaKwiknew ProjectEmbReact_M514 4 & KlustaKwiknew ProjectEmbReact_M514 5 & KlustaKwiknew ProjectEmbReact_M514 6')


%% 507
cd /media/DataMOBS65/Mouse507/20170201/SpikeSortAllTogether/
%KlustaKwiknew M507-20170201-SpikesAllTogether 5 & KlustaKwiknew M507-20170201-SpikesAllTogether 6 & KlustaKwiknew M507-20170201-SpikesAllTogether 7
system('KlustaKwiknew M507-20170201-SpikesAllTogether 8 & KlustaKwiknew M507-20170201-SpikesAllTogether 9 & KlustaKwiknew M507-20170201-SpikesAllTogether 10')

%% 508
cd /media/DataMOBS65/Mouse508/20170203/SpikeSortAllTogether/
system('KlustaKwiknew M508-20170203-SpikesAllTogether 5 & KlustaKwiknew M508-20170203-SpikesAllTogether 6 & KlustaKwiknew M508-20170203-SpikesAllTogether 7')
system('KlustaKwiknew M508-20170203-SpikesAllTogether 8 & KlustaKwiknew M508-20170203-SpikesAllTogether 9 & KlustaKwiknew M508-20170203-SpikesAllTogether 10')

%% 509
cd /media/DataMOBS66/Mouse509SpikeSorting/
KlustaKwiknew M510-20170209-SpikesAllTogether 1 & KlustaKwiknew M510-20170209-SpikesAllTogether 2 & KlustaKwiknew M510-20170209-SpikesAllTogether 3
KlustaKwiknew M510-20170209-SpikesAllTogether 4 & KlustaKwiknew M510-20170209-SpikesAllTogether 5 & KlustaKwiknew M510-20170209-SpikesAllTogether 6
KlustaKwiknew M510-20170209-SpikesAllTogether 7 & KlustaKwiknew M510-20170209-SpikesAllTogether 8 & KlustaKwiknew M510-20170209-SpikesAllTogether 9 & KlustaKwiknew M510-20170209-SpikesAllTogether 10

%% 510
cd /media/DataMOBS65/Mouse510/20170209/SpikeSortAllTogether/
KlustaKwiknew M510-20170209-SpikesAllTogether 1 & KlustaKwiknew M510-20170209-SpikesAllTogether 2 & KlustaKwiknew M510-20170209-SpikesAllTogether 3
KlustaKwiknew M510-20170209-SpikesAllTogether 4 & KlustaKwiknew M510-20170209-SpikesAllTogether 5 

% 512
cd /media/DataMOBS66/Mouse512SpikeSorting/
system('ndm_concatenate M512-20170208-SpikesAllTogether')
movefile('M512-20170208-SpikesAllTogether.dat','M512-20170208-SpikesAllTogether.fil')
system('ndm_hipass M512-20170208-SpikesAllTogether')
system('ndm_extractspikes M512-20170208-SpikesAllTogether')
system('ndm_pca M512-20170208-SpikesAllTogether')
system('KlustaKwiknew M512-20170208-SpikesAllTogether 1 & KlustaKwiknew M512-20170208-SpikesAllTogether 2 & KlustaKwiknew M512-20170208-SpikesAllTogether 3')
system('KlustaKwiknew M512-20170208-SpikesAllTogether 4 & KlustaKwiknew M512-20170208-SpikesAllTogether 5')

