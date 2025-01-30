
function TimeEndRec = GetTimeOfDataRecordingML(direct,sevFiles_row)

% TimeEndRec = GetTimeOfDataRecordingML(direct,sevFiles_row)

% input:
% direct = directory of row data (optional)
% sevFiles_row = 1 if several files for 1 row file, 0 otherwise (optional, default 0)

%% INITIALIZATION
res=pwd;
if isempty(strfind(res,'/')),mark='\'; else  mark='/';end

if ~exist('sevFiles_row','var')
    sevFiles_row=0;
end

%% TEST IF DATA ALREADY EXISTS
try 
    load('behavResources.mat','TimeEndRec')
    disp(TimeEndRec);
    disp('already define in behavResources.mat')
    do_it=input('Redo it anyway (y/n) ? ','s');
    if do_it=='y', do_it=1; else do_it=0;end
catch
    do_it=1;
end


%% GET INFO
if do_it
    if ~exist('direct','var')
        direct=res;
    end
    disp(' ')
    cd(direct)
    if exist('supply.dat')==2
        listfile = 'supply.dat';
    else
    [listfile,direct]=uigetfile('*.*','Get raw data files like info.rhd','MultiSelect','on');
    end
    cd(res)
end
%% CHECK TIME RECORDING OF FILES
if do_it
    clear TimeEndRec
    a=0;
    list=dir(direct);
    for i=3:length(list)
        if exist('listfile','var') && sum(strcmp(list(i).name,listfile)) 
            a=a+1;
            ld=list(i).date;
            disp(['rec ',num2str(a),': ',ld])
            ind=strfind(ld,':');
            TimeEndRec(a,1:3)=[str2num(ld(ind(1)-2:ind(1)-1)),str2num(ld(ind(1)+1:ind(2)-1)),str2num(ld(ind(2)+1:end))];
            DateRec=ld(1:ind-4);
        end
    end
    
    if a==0
        disp('No files found!   ReRun')
    else
        DiffTimeRec=sum([60*60*diff(TimeEndRec(:,1)),60*diff(TimeEndRec(:,2)),diff(TimeEndRec(:,3))],2);
    end
end
% -------------------------------------------------------------------------
%% ------------------------------------------------------------------------

% Control that it fits with tpsdeb, tpsfin in behavResources.

if a~=0 && do_it
    FileName='behavResources.mat';PathName=[res,mark];
    if ~exist([PathName,FileName],'file')
        disp('Indicate the behavResources.mat in which those rec info must be added to')
        [FileName,PathName] = uigetfile('.mat','Get correspondant behavResources');
    end
    
    if FileName==0
        disp('No corresponding behavResources.mat found');
        disp('Saving TimeRec info in the current directory');
        save TimeRec TimeEndRec DiffTimeRec DateRec
    
    else
        try
            clear tpsdeb tpsfin dur
            load([PathName,FileName],'tpsdeb','tpsfin');
            for i=1:length(tpsdeb)
                dur(i)=tpsfin{i}-tpsdeb{i};
            end
            dur=dur';
            DurRec=[floor(dur/3600),floor((dur-3600*floor(dur/3600))/60),rem((dur-3600*floor(dur/3600)),60)];
            
            try
                B=sum(TimeEndRec*[3600 60 1]',2)-dur;
                TimeDebRec=[floor(B/3600) floor(rem(B,3600)/60) rem(rem(B,3600),60)];
                
                disp('Saving TimeRec info in behavResources.mat');
                save([PathName,FileName],'-append','TimeEndRec','TimeDebRec','DurRec','DiffTimeRec','DateRec');
                disp('Saving TimeRec info in the current directory');
                save([direct,mark,'TimeRec.mat'],'TimeEndRec','TimeDebRec','DurRec','DiffTimeRec','DateRec')
                
            catch
                if sevFiles_row==0, disp('WRONG FOLDER or OPTION several files for 1 row file');keyboard;
                end
            end
        catch
            disp('Failed to load tpsdeb and tpsfin from behavResources.mat')
            disp('Saving only TimeEndRec in behavResources');
            save([direct,mark,'TimeRec.mat'],'TimeEndRec')
            save([PathName,FileName],'-append','TimeEndRec','DateRec')
        end

    end
end


%% In case of several files for 1 row file (post split)
if sevFiles_row
    rowTimeEndRec=TimeEndRec;
    load([PathName,FileName],'tpsdeb','tpsfin','evt');
    for i=1:length(tpsdeb)
        dur(i)=tpsfin{i}-tpsdeb{i};
        disp([num2str(i),'- ',evt{i}])
    end
    TimeEndRec=zeros(length(tpsdeb),3);
    
    
    indexrow=input('Enter num of files corresponding to TimeEndRec row: ');
    while size(rowTimeEndRec,1)~=length(indexrow)
        disp(['You gave ',num2str(length(indexrow)),' files whereas there are ',num2str(size(rowTimeEndRec,1)),' row files'])
        indexrow=input('Enter num of files corresponding to TimeEndRec row: ');
    end
    
    
    for i=1:length(indexrow) 
        TimeEndRec(indexrow(i),:)=rowTimeEndRec(i,:);
    end
    
    B=sum(TimeEndRec*[3600 60 1]',2);
    index=[]; 
    for i=1:length(B), 
        if B(i)==0, index=[index,i];end
    end
    for i=1:length(index)
        B(index(i))=B(index(i)+1)-dur(index(i)+1);
    end
    
    TimeEndRec=[floor(B/3600) floor(rem(B,3600)/60) rem(rem(B,3600),60)];
    B=sum(TimeEndRec*[3600 60 1]',2)-dur;
    TimeDebRec=[floor(B/3600) floor(rem(B,3600)/60) rem(rem(B,3600),60)];

    disp('Saving TimeRec info in the current directory');
    save([direct,mark,'TimeRec.mat'],'TimeEndRec','TimeDebRec','DurRec','DateRec')
    disp('Saving TimeRec info in indicated behavResources');
    save([PathName,FileName],'-append','TimeEndRec','TimeDebRec','DurRec','DateRec');
end







