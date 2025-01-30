function [FileInfo, FolderPath]=DefinePath(manipname, datalocation, datatype)

% INPUTS
% manipname can be 'ManipFeb15Bulbectomie' or 'ManipDec14Bulbectomie'
% datalocation can be 'server', 'DataMOBs14' for Feb15 or 'manip' for Dec14
% (24/02/16 datalocation can also be 'server_windows' to adapt the path to server using windows)
% datatype can be 'fear' or 'explo'

% OUTPUT
% FileInfo : matrix of paths (in line : the steps of the exp, in column : the mice names)
% FolderPath : path containing the folder  of the experiment

% e.g. marie: [FileInfo, FolderPath]=DefinePath('FearMLavr2015,'Marie','fear')

if strcmp(datalocation, 'server')  
    FolderPath='/media/DataMOBsRAID/ProjetAversion/';
elseif strcmp(datalocation, 'server_windows') 
    FolderPath='\\NASDELUXE2\DataMOBsRAID\ProjetAversion/';
elseif strcmp(datalocation, 'DataMOBs14')    
    FolderPath='/media/DataMOBs14/ProjetAversion/';    
elseif strcmp(datalocation, 'manip')    
    FolderPath='C:\Users\Cl�mence\Desktop\chgtordinateur\Fear\DATA-ACQUISITION\';
elseif strcmp(datalocation,'Marie')
    FolderPath='/media/DataMOBsRAID/ProjetAstro';
elseif strcmp(datalocation,'DataMobs31')
    FolderPath='/media/DataMOBs31.....';
end
        
if strcmp(manipname, 'ManipFeb15Bulbectomie')

        if strcmp(datatype, 'fear')     
            for m=222:229
                FileInfo{1,m}=[FolderPath manipname '/M' ,num2str(m),'/20150203/FEAR-Mouse-' num2str(m), '-03022015-HABenvC/'];
                %FileInfo{1,m}=[FolderPath manipname '/M' ,num2str(m),'/20150203/FEAR-Mouse-' num2str(m), '-03022015-HABenvB/'];
                %FileInfo{1,m}=[FolderPath manipname '/M' ,num2str(m),'/20150203/FEAR-Mouse-' num2str(m), '-04022015-HABenvA/'];
                FileInfo{2,m}=[FolderPath manipname '/M' ,num2str(m),'/20150204/FEAR-Mouse-' num2str(m), '-04022015-COND/'];
                FileInfo{3,m}=[FolderPath manipname '/M' ,num2str(m),'/20150205/FEAR-Mouse-' num2str(m), '-05022015-EXTenvC/'];
                FileInfo{4,m}=[FolderPath manipname '/M' ,num2str(m),'/20150206/FEAR-Mouse-' num2str(m), '-06022015-EXTenvB/'];   
            end
            for m=230:240
                FileInfo{1,m}=[FolderPath manipname '/M' ,num2str(m),'/20150210/FEAR-Mouse-' num2str(m), '-10022015-HABenvC/'];
    %             FileInfo{1,m}=[FolderPath manipname '/M' ,num2str(m),'/20150210/FEAR-Mouse-' num2str(m), '-10022015-HABenvB/'];
    %             FileInfo{1,m}=[FolderPath manipname '/M' ,num2str(m),'/20150211/FEAR-Mouse-' num2str(m), '-11022015-HABenvA/'];
                FileInfo{2,m}=[FolderPath manipname '/M' ,num2str(m),'/20150211/FEAR-Mouse-' num2str(m), '-11022015-COND/'];
                FileInfo{3,m}=[FolderPath manipname '/M' ,num2str(m),'/20150212/FEAR-Mouse-' num2str(m), '-12022015-EXTenvC/'];
                FileInfo{4,m}=[FolderPath manipname '/M' ,num2str(m),'/20150213/FEAR-Mouse-' num2str(m), '-13022015-EXTenvB/'];
            end
        elseif strcmp(datatype, 'explo')
            for m=222:229
                FileInfo{1,m}=[FolderPath manipname '/M' ,num2str(m),'/20150202/FEAR-Mouse-' num2str(m), '-02022015-EXPLOpre/'];
                FileInfo{2,m}=[FolderPath manipname '/M' ,num2str(m),'/20150206/FEAR-Mouse-' num2str(m), '-06022015-EXPLOpost'];
                FileInfo{3,m}=[FolderPath manipname '/M' ,num2str(m),'/20150212/FEAR-Mouse-' num2str(m), '-12022015-EXPLO+6j/'];
                FileInfo{4,m}=[FolderPath manipname '/M' ,num2str(m),'/20150302/FEAR-Mouse-' num2str(m), '-02032015-EXPLO+3wk/'];   
            end
            for m=230:240
                FileInfo{1,m}=[FolderPath manipname '/M' ,num2str(m),'/20150209/FEAR-Mouse-' num2str(m), '-09022015-EXPLOpre/'];
                FileInfo{2,m}=[FolderPath manipname '/M' ,num2str(m),'/20150213/FEAR-Mouse-' num2str(m), '-13022015-EXPLOpost/'];
                FileInfo{3,m}=[FolderPath manipname '/M' ,num2str(m),'/20150219/FEAR-Mouse-' num2str(m), '-19022015-EXPLO+6j/'];
                FileInfo{4,m}=[FolderPath manipname '/M' ,num2str(m),'/20150309/FEAR-Mouse-' num2str(m), '-09032015-EXPLO+3wk/'];        
            end
        end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif strcmp(manipname, 'ManipDec14Bulbectomie')

    if strcmp(datatype, 'fear')     
        
        for m=207:213
            %FileInfo{1,m}=[FolderPath manipname '/M' ,num2str(m),'/20141209/FEAR-Mouse-' num2str(m), '-09122014-HABpleth/'];
            %FileInfo{1,m}=[FolderPath manipname '/M' ,num2str(m),'/20141209/FEAR-Mouse-' num2str(m), '-09122014-HABenvB/'];
            FileInfo{1,m}=[FolderPath manipname '/M' ,num2str(m),'/20141210/FEAR-Mouse-' num2str(m), '-10122014-HABenvA/'];
            FileInfo{2,m}=[FolderPath manipname '/M' ,num2str(m),'/20141210/FEAR-Mouse-' num2str(m), '-10122014-COND/'];
            FileInfo{3,m}=[FolderPath manipname '/M' ,num2str(m),'/20141211/FEAR-Mouse-' num2str(m), '-11122014-EXTpleth/'];
            FileInfo{4,m}=[FolderPath manipname '/M' ,num2str(m),'/20141212/FEAR-Mouse-' num2str(m), '-12122014-EXTenvB/'];   
        end
        for m=214:220
            %FileInfo{1,m}=[FolderPath manipname '/M' num2str(m) '/20141216/FEAR-Mouse-' num2str(m) '-16122014-HABpleth/'];
            %FileInfo{1,m}=[FolderPath manipname '/M' num2str(m) '/20141216/FEAR-Mouse-' num2str(m) '-16122014-HABenvB/'];
            FileInfo{1,m}=[FolderPath manipname '/M' num2str(m) '/20141217/FEAR-Mouse-' num2str(m) '-17122014-HABenvA/'];
            FileInfo{2,m}=[FolderPath manipname '/M' num2str(m) '/20141217/FEAR-Mouse-' num2str(m) '-17122014-COND/'];
            FileInfo{3,m}=[FolderPath manipname '/M' num2str(m) '/20141218/FEAR-Mouse-' num2str(m) '-18122014-EXTpleth/'];
            FileInfo{4,m}=[FolderPath manipname '/M' num2str(m) '/20141219/FEAR-Mouse-' num2str(m) '-19122014-EXTenvB/'];   
        end
        
    elseif strcmp(datatype, 'explo')
        
        for m=207:213
            FileInfo{1,m}=[FolderPath manipname '/M' num2str(m) '\20141208\FEAR-Mouse-' num2str(m) '-08122014-EXPLOpre'];
            FileInfo{2,m}=[FolderPath manipname '/M' num2str(m) '\20141212\FEAR-Mouse-' num2str(m) '-12122014-EXPLOpost'];
            FileInfo{3,m}=[FolderPath manipname '/M' num2str(m) '\20141218\FEAR-Mouse-' num2str(m) '-18122014-EXPLO+6j'];
            FileInfo{4,m}=[FolderPath manipname '/M' num2str(m) '\20150105\FEAR-Mouse-' num2str(m) '-05012015-EXPLO+3wk'];   
        end
        for m=214:220
            FileInfo{1,m}=[FolderPath manipname '/M' num2str(m) '\20141215\FEAR-Mouse-' num2str(m) '-15122014-EXPLOpre'];
            FileInfo{2,m}=[FolderPath manipname '/M' num2str(m) '\20141219\FEAR-Mouse-' num2str(m) '-19122014-EXPLOpost'];
            FileInfo{3,m}=[FolderPath manipname '/M' num2str(m) '\20141225\FEAR-Mouse-' num2str(m) '-25122014-EXPLO+6j'];
            FileInfo{4,m}=[FolderPath manipname '/M' num2str(m) '\20150112\FEAR-Mouse-' num2str(m) '-12012015-EXPLO+3wk'];   
        end
    end
    
elseif strcmp(manipname, 'FearMLavr2015') && strcmp(datatype, 'fear')
    %mouse 245-246 hemiOBX-hemiOcclusion
    for m=245:246;
        FileInfo{1,m}='';
        FileInfo{2,m}=[FolderPath  '/Mouse' num2str(m) '/20150410/FEAR/FEAR-Mouse-' num2str(m) '-10042015-01-COND'];
        FileInfo{3,m}=[FolderPath  '/Mouse' num2str(m) '/20150410/FEAR/FEAR-Mouse-' num2str(m) '-10042015-01-EXT'];
        FileInfo{4,m}=[FolderPath  '/Mouse' num2str(m) '/20150414/FEAR-Mouse-' num2str(m) '-14042015-01-EXT'];
    end
    
elseif strcmp(manipname, 'ManipNov15Bulbectomie')|strcmp(manipname, 'ManipNov15Bulbectomie_notexch')
    if strcmp(datatype, 'fear')    
        for m=269:290
            FileInfo{1,m}=[FolderPath manipname '/M' num2str(m) '/20151125/FEAR-Mouse-' num2str(m) '-25112015-01-HABgrille/'];
            FileInfo{2,m}=[FolderPath manipname '/M' num2str(m) '/20151125/FEAR-Mouse-' num2str(m) '-25112015-01-COND/'];
            FileInfo{3,m}=[FolderPath manipname '/M' num2str(m) '/20151126/FEAR-Mouse-' num2str(m) '-26112015-01-EXT24-envC/'];
            FileInfo{4,m}=[FolderPath manipname '/M' num2str(m) '/20151127/FEAR-Mouse-' num2str(m) '-27112015-01-EXT48-envB/'];  
        end
    elseif strcmp(datatype, 'explo')
        for m=269:290
            FileInfo{1,m}=[FolderPath manipname '/M' num2str(m) '/20151123/FEAR-Mouse-' num2str(m) '-23112015-01-EXPLOpre/'];
            FileInfo{2,m}=[FolderPath manipname '/M' num2str(m) '/20151127/FEAR-Mouse-' num2str(m) '-27112015-01-ExploPOST/'];
            FileInfo{3,m}=[FolderPath manipname '/M' num2str(m) '/20151203/FEAR-Mouse-' num2str(m) '-03122015-01-EXPLO+6d/'];
            FileInfo{4,m}=[FolderPath manipname '/M' num2str(m) '/20151210/FEAR-Mouse-' num2str(m) '-10122015-01-EXPLO+2wk/'];
            FileInfo{5,m}=[FolderPath manipname '/M' num2str(m) '/20151221/FEAR-Mouse-' num2str(m) '-21122015-01-EXPLO+3wk/'];

        end
    end
elseif strcmp(manipname, 'ManipDec15BulbectomiePlethysmo') 
    for m=269:290
        FileInfo{1,m}=[FolderPath manipname '/M' num2str(m) '/20151215/FEAR-Mouse-' num2str(m) '-15122015-01-HABpleth'];
        FileInfo{2,m}=[FolderPath manipname '/M' num2str(m) '/20151216/FEAR-Mouse-' num2str(m) '-16122015-01-COND'];
        FileInfo{3,m}=[FolderPath manipname '/M' num2str(m) '/20151217/FEAR-Mouse-' num2str(m) '-17122015-01-EXTpleth'];
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% change '/' into '/'
if strcmp(datalocation, 'server')   
    if strcmp(manipname, 'ManipFeb15Bulbectomie')
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
    elseif strcmp(manipname, 'ManipDec14Bulbectomie')
        for m=207:213
            for k=1:size(FileInfo,1)
                FileInfo{k,m}(strfind(FileInfo{k,m}, '\'))='/';
            end
        end
        for m=214:220
            for k=1:size(FileInfo,1)
                FileInfo{k,m}(strfind(FileInfo{k,m}, '\'))='/';
            end
        end
    elseif strcmp(manipname, 'ManipNov15Bulbectomie')|strcmp(manipname, 'ManipDec15BulbectomiePlethysmo')|strcmp(manipname, 'ManipNov15Bulbectomie_notexch')
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
