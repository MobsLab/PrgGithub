function FileInfo=DefinePath(manipname, datalocation, datatype)

% manipname can be 'ManipFeb15Bulbectomie' or 'ManipDec14Bulbectomie'
% datalocation can be 'server', 'DataMOBs14' for Feb15 or 'manip' for Dec14
% datatype can be 'fear' or 'explo'

if strcmp(manipname, 'ManipFeb15Bulbectomie')
    if strcmp(datalocation, 'server')     
        FolderPath='/media/DataMOBsRAID/Projet Aversion/ManipFeb15Bulbectomie';
        mark='/';
        if strcmp(datatype, 'fear')     
            for m=222:229
                FileInfo{1,m}=[FolderPath '/M' ,num2str(m),'/20150203/FEAR-Mouse-' num2str(m), '-03022015-HABenvC/'];
                %FileInfo{1,m}=[FolderPath '/M' ,num2str(m),'/20150203/FEAR-Mouse-' num2str(m), '-03022015-HABenvB/'];
                %FileInfo{1,m}=[FolderPath '/M' ,num2str(m),'/20150203/FEAR-Mouse-' num2str(m), '-04022015-HABenvA/'];
                FileInfo{2,m}=[FolderPath '/M' ,num2str(m),'/20150204/FEAR-Mouse-' num2str(m), '-04022015-COND/'];
                FileInfo{3,m}=[FolderPath '/M' ,num2str(m),'/20150205/FEAR-Mouse-' num2str(m), '-05022015-EXTenvC/'];
                FileInfo{4,m}=[FolderPath '/M' ,num2str(m),'/20150206/FEAR-Mouse-' num2str(m), '-06022015-EXTenvB/'];   
            end
            for m=232:240
                FileInfo{1,m}=[FolderPath '/M' ,num2str(m),'/20150210/FEAR-Mouse-' num2str(m), '-10022015-HABenvC/'];
    %             FileInfo{1,m}=[FolderPath '/M' ,num2str(m),'/20150210/FEAR-Mouse-' num2str(m), '-10022015-HABenvB/'];
    %             FileInfo{1,m}=[FolderPath '/M' ,num2str(m),'/20150211/FEAR-Mouse-' num2str(m), '-11022015-HABenvA/'];
                FileInfo{2,m}=[FolderPath '/M' ,num2str(m),'/20150211/FEAR-Mouse-' num2str(m), '-11022015-COND/'];
                FileInfo{3,m}=[FolderPath '/M' ,num2str(m),'/20150212/FEAR-Mouse-' num2str(m), '-12022015-EXTenvC/'];
                FileInfo{4,m}=[FolderPath '/M' ,num2str(m),'/20150213/FEAR-Mouse-' num2str(m), '-13022015-EXTenvB/'];
            end
        elseif strcmp(datatype, 'explo')
            for m=222:229
                FileInfo{1,m}=[FolderPath '/M' ,num2str(m),'/20150202/FEAR-Mouse-' num2str(m), '-02022015-EXPLOpre/'];
                FileInfo{2,m}=[FolderPath '/M' ,num2str(m),'/20150206/FEAR-Mouse-' num2str(m), '-06022015-EXPLOpost'];
                FileInfo{3,m}=[FolderPath '/M' ,num2str(m),'/20150212/FEAR-Mouse-' num2str(m), '-12022015-EXPLO+6j/'];
                FileInfo{4,m}=[FolderPath '/M' ,num2str(m),'/20150302/FEAR-Mouse-' num2str(m), '-02032015-EXPLO+3wk/'];   
            end
            for m=232:240
                FileInfo{1,m}=[FolderPath '/M' ,num2str(m),'/20150209/FEAR-Mouse-' num2str(m), '-09022015-EXPLOpre/'];
                FileInfo{2,m}=[FolderPath '/M' ,num2str(m),'/20150213/FEAR-Mouse-' num2str(m), '-13022015-EXPLOpost/'];
                FileInfo{3,m}=[FolderPath '/M' ,num2str(m),'/20150219/FEAR-Mouse-' num2str(m), '-19022015-EXPLO+6j/'];
                FileInfo{4,m}=[FolderPath '/M' ,num2str(m),'/20150309/FEAR-Mouse-' num2str(m), '-09032015-EXPLO+3wk/'];        
            end
        end
    elseif strcmp(datalocation, 'DataMOBs14')    
        %FolderPath='F:\ProjetAversion\ManipFeb15Bulbectomie';
        FolderPath='/media/DataMOBs14/ProjetAversion/ManipFeb15Bulbectomie';
        mark='\';
        if strcmp(datatype, 'fear')  
            for m=222:229
                FileInfo{1,m}=[FolderPath '/M' ,num2str(m),'/20150203/FEAR-Mouse-' num2str(m), '-03022015-HABenvC/'];
                %FileInfo{1,m}=[FolderPath '/M' ,num2str(m),'/20150203/FEAR-Mouse-' num2str(m), '-03022015-HABenvB/'];
                %FileInfo{1,m}=[FolderPath '/M' ,num2str(m),'/20150203/FEAR-Mouse-' num2str(m), '-03022015-HABenvA/'];
                FileInfo{2,m}=[FolderPath '/M' ,num2str(m),'/20150204/FEAR-Mouse-' num2str(m), '-04022015-COND/'];
                FileInfo{3,m}=[FolderPath '/M' ,num2str(m),'/20150205/FEAR-Mouse-' num2str(m), '-05022015-EXTenvC/'];
                FileInfo{4,m}=[FolderPath '/M' ,num2str(m),'/20150206/FEAR-Mouse-' num2str(m), '-06022015-EXTenvB/'];   
            end
            for m=232:240
                FileInfo{1,m}=[FolderPath '/M' ,num2str(m),'/20150210/FEAR-Mouse-' num2str(m), '-10022015-HABenvC/'];
    %             FileInfo{1,m}=[FolderPath '/M' ,num2str(m),'/20150210/FEAR-Mouse-' num2str(m), '-10022015-HABenvB/'];
    %             FileInfo{1,m}=[FolderPath '/M' ,num2str(m),'/20150211/FEAR-Mouse-' num2str(m), '-11022015-HABenvA/'];
                FileInfo{2,m}=[FolderPath '/M' ,num2str(m),'/20150211/FEAR-Mouse-' num2str(m), '-11022015-COND/'];
                FileInfo{3,m}=[FolderPath '/M' ,num2str(m),'/20150212/FEAR-Mouse-' num2str(m), '-12022015-EXTenvC/'];
                FileInfo{4,m}=[FolderPath '/M' ,num2str(m),'/20150213/FEAR-Mouse-' num2str(m), '-13022015-EXTenvB/'];        
            end
        elseif strcmp(datatype, 'explo')
            for m=222:229
                FileInfo{1,m}=[FolderPath '/M' ,num2str(m),'/20150202/FEAR-Mouse-' num2str(m), '-02022015-EXPLOpre/'];
                FileInfo{2,m}=[FolderPath '/M' ,num2str(m),'/20150206/FEAR-Mouse-' num2str(m), '-06022015-EXPLOpost'];
                FileInfo{3,m}=[FolderPath '/M' ,num2str(m),'/20150212/FEAR-Mouse-' num2str(m), '-12022015-EXPLO+6j/'];
                FileInfo{4,m}=[FolderPath '/M' ,num2str(m),'/20150302/FEAR-Mouse-' num2str(m), '-02032015-EXPLO+3wk/'];   
            end
            for m=232:240
                FileInfo{1,m}=[FolderPath '/M' ,num2str(m),'/20150209/FEAR-Mouse-' num2str(m), '-09022015-EXPLOpre/'];
                FileInfo{2,m}=[FolderPath '/M' ,num2str(m),'/20150213/FEAR-Mouse-' num2str(m), '-13022015-EXPLOpost/'];
                FileInfo{3,m}=[FolderPath '/M' ,num2str(m),'/20150219/FEAR-Mouse-' num2str(m), '-19022015-EXPLO+6j/'];
                FileInfo{4,m}=[FolderPath '/M' ,num2str(m),'/20150309/FEAR-Mouse-' num2str(m), '-09032015-EXPLO+3wk/'];        
            end
        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif strcmp(manipname, 'ManipDec14Bulbectomie')
    if strcmp(datalocation, 'server')     
        FolderPath='/media/DataMOBsRAID/Projet Aversion/ManipDec14Bulbectomie';
        mark='/';
        for m=207:213
            FileInfo{1,m}=[FolderPath '/M' ,num2str(m),'/20141209/FEAR-Mouse-' num2str(m), '-09122014-HABpleth/'];
            %FileInfo{1,m}=[FolderPath '/M' ,num2str(m),'/20141209/FEAR-Mouse-' num2str(m), '-09122014-HABenvB/'];
            %FileInfo{1,m}=[FolderPath '/M' ,num2str(m),'/20141210/FEAR-Mouse-' num2str(m), '-10122014-HABenvA/'];
            FileInfo{2,m}=[FolderPath '/M' ,num2str(m),'/20141210/FEAR-Mouse-' num2str(m), '-10122014-COND/'];
            FileInfo{3,m}=[FolderPath '/M' ,num2str(m),'/20141211/FEAR-Mouse-' num2str(m), '-11122014-EXTpleth/'];
            FileInfo{4,m}=[FolderPath '/M' ,num2str(m),'/20141212/FEAR-Mouse-' num2str(m), '-12122014-EXTenvB/'];   
        end
        for m=214:220
            FileInfo{1,m}=[FolderPath '/M' num2str(m) '/20141216/FEAR-Mouse-' num2str(m) '-16122014-HABpleth/'];
            %FileInfo{1,m}=[FolderPath '/M' num2str(m) '/20141216/FEAR-Mouse-' num2str(m) '-16122014-HABenvB/'];
            %FileInfo{1,m}=[FolderPath '/M' num2str(m) '/20141217/FEAR-Mouse-' num2str(m) '-17122014-HABenvA/'];
            FileInfo{2,m}=[FolderPath '/M' num2str(m) '/20141217/FEAR-Mouse-' num2str(m) '-17122014-COND/'];
            FileInfo{3,m}=[FolderPath '/M' num2str(m) '/20141218/FEAR-Mouse-' num2str(m) '-18122014-EXTpleth/'];
            FileInfo{4,m}=[FolderPath '/M' num2str(m) '/20141219/FEAR-Mouse-' num2str(m) '-19122014-EXTenvB/'];   
        end
    elseif strcmp(datalocation, 'manip')    
        FolderPath='C:\Users\Cl�mence\Desktop\chgtordinateur\Fear\DATA-ACQUISITION\ManipBulbectomie';
        mark='\';
            for m=207:213
            %FileInfo{1,m}=[FolderPath '/M' ,num2str(m),'/FEAR-Mouse-' num2str(m), '-09122014-HABenvB/'];
            FileInfo{1,m}=[FolderPath '/M' ,num2str(m),'/FEAR-Mouse-' num2str(m), '-10122014-HABenvA/'];
            FileInfo{2,m}=[FolderPath '/M' ,num2str(m),'/FEAR-Mouse-' num2str(m), '-10122014-COND/'];
            FileInfo{3,m}=[FolderPath '/M' ,num2str(m),'/FEAR-Mouse-' num2str(m), '-11122014-EXTpleth/'];
            FileInfo{4,m}=[FolderPath '/M' ,num2str(m),'/FEAR-Mouse-' num2str(m), '-12122014-EXTenvB/'];   
        end
        for m=214:220
            %FileInfo{1,m}=[FolderPath '/M' num2str(m) '/FEAR-Mouse-' num2str(m) '-16122014-HABenvB/'];
            FileInfo{1,m}=[FolderPath '/M' num2str(m) '/FEAR-Mouse-' num2str(m) '-17122014-HABenvA/'];
            FileInfo{2,m}=[FolderPath '/M' num2str(m) '/FEAR-Mouse-' num2str(m) '-17122014-COND/'];
            FileInfo{3,m}=[FolderPath '/M' num2str(m) '/FEAR-Mouse-' num2str(m) '-18122014-EXTpleth/'];
            FileInfo{4,m}=[FolderPath '/M' num2str(m) '/FEAR-Mouse-' num2str(m) '-19122014-EXTenvB/'];   
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% change '/' into '/'
if strcmp(datalocation, 'server')   
    for m=222:229
        for k=1:size(FileInfo,1)
            FileInfo{k,m}(strfind(FileInfo{k,m}, '\'))='/';
        end
    end
    for m=232:240
        for k=1:size(FileInfo,1)
            FileInfo{k,m}(strfind(FileInfo{k,m}, '\'))='/';
        end
    end
elseif strcmp(datalocation, 'DataMOBs14')   
    for m=222:229
        for k=1:size(FileInfo,1)
            FileInfo{k,m}(strfind(FileInfo{k,m}, '\'))='/';
        end
    end
    for m=232:240
        for k=1:size(FileInfo,1)
            FileInfo{k,m}(strfind(FileInfo{k,m}, '\'))='/';
        end
    end
end
