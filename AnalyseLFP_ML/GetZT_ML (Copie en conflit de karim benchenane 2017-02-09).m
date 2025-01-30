function NewtsdZT=GetZT_ML(dirpath,forced,sav)

% function NewtsdZT=GetZT(dirpath,forced)

% inputs:
% dirpath (optional) = path to find behavResources.mat (default = pwd)
% forced (optional) = 1 to redo even if NewtsdZT already exists 
%                     in behavResources.mat (default = 0)
% sav (optional) = 0 not to save (default = 1)
disp('GetZT_ML.m')
res=pwd;

%% check inputs
if ~exist('dirpath','var')
    dirpath=res;
end

if ~exist('forced','var')
    forced=0;
end

if ~exist('sav','var')
    sav=1;
end

cd(dirpath)

%% get NewtsdZT if exists
doit=1;
clear NewtsdZT temp
try
    temp=load('behavResources.mat','NewtsdZT','tpsdeb','tpsfin','MovAcctsd');
    NewtsdZT=temp.NewtsdZT;
    % check
    try
        for i=1:length(temp.tpsdeb)
            dur(i)=temp.tpsfin{i}-temp.tpsdeb{i};
        end
        disp('Check for good NewtsdZT definition :')
        disp(sprintf('    Rec Duration given by tpsfin-tpsdeb = %1.1fs',sum(dur)))
        disp(sprintf('    Rec Duration given by MovAcctsd = %1.1fs',max(Range(temp.MovAcctsd,'s'))))
        disp(sprintf('    Rec Duration given by NewtsdZT = %1.1fs',max(Range(temp.NewtsdZT,'s'))))
        if sum(dur)-max(Range(temp.MovAcctsd,'s'))<1
            disp('OK !')
        else
            disp('Problem definition of NewtsdZT !!'); %keyboard
        end
    end
    
    if ~forced
        doit=0;
    end
end

%% get TimeEndRec if exists
clear TimeEndRec tpsdeb tpsfin
load behavResources.mat TimeEndRec tpsdeb tpsfin

if ~exist('TimeEndRec','var')
    disp('Problem !! TimeEndRec not defined !')
    NewtsdZT=tsd([],[]);
    doit=0;
end

%% disp step
if doit
    disp('-> Calculating NewtsdZT and saving in behavResources')
end

%% get one LFP 
if doit
    clear tpsRef
    try
        load LFPData/InfoLFP InfoLFP
        ch=0;
        while ~exist('tpsRef','var') && ch<length(InfoLFP.channel)
            ch=ch+1;
            try
                eval(['load(''LFPData/LFP',num2str(InfoLFP.channel(ch)),'.mat'',''LFP'');']);
                tpsRef=ts(Range(LFP));
            end
        end
    end
    if ~exist('tpsRef','var')
        disp('Problem !! No LFP defined !')
        NewtsdZT=tsd([],[]);
        doit=0;
    end
end

%%  Calculates tsdZT
if doit
    tfinR=TimeEndRec*[3600 60 1]';
    
    % determine time of recording sessions
    for ti=1:length(tpsdeb)
        if tpsdeb{ti}~=tpsfin{ti}
            if ti>1
                tdebR=max(tfinR(ti)-(tpsfin{ti}-tpsdeb{ti}),tfinR(ti-1));
            else
                tdebR=tfinR(ti)-(tpsfin{ti}-tpsdeb{ti});
            end
            
            I=intervalSet(tpsdeb{ti}*1E4+1,tpsfin{ti}*1E4-1);
            
            if ti==1
                NewtsdZT=tsd(Range(Restrict(tpsRef,I)),Range(Restrict(tpsRef,I))+tdebR*1E4);
            else
                NewtsdZT=cat(NewtsdZT,tsd(Range(Restrict(tpsRef,I)),Range(Restrict(tpsRef,I))-tpsdeb{ti}*1E4+tdebR*1E4));
            end
        end
    end
end

%% sort tsdZT
if doit
    A=[Data(NewtsdZT),Range(NewtsdZT)];
    B=sortrows(A,1);
    ind=find(diff(B(:,1))<=0);
    B(ind,:)=[];
    
    if ~issorted(B(:,2))
        B=sort(B);
    end
        
    NewtsdZT=tsd(B(:,2),B(:,1));
end


%% save

if doit && sav
    save behavResources -append NewtsdZT
end

cd(res)
