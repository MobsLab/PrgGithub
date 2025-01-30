% CodeBulbML

%% INITIALISATION

% ---- INPUTS ----
% ----------------
DownSampleFreq=200; 
supposednameLFPA={'LFPbulb' 'LFPCx' 'EEGCx' 'LFPpfc' 'EEGpfc' 'LFPThAu'};

% ----------------
% parameters for spectrogram
params.Fs=1250;
params.trialave=0;
params.err=[1 0.0500];
params.pad=2;
params.fpass=[0 30];
%params.tapers=[1 2];
movingwin=[3 0.2];
params.tapers=[3 5];

% ---------------- 

warning off
Nultsd=tsd([],[]);

res=pwd;
if exist([res,'/AnalyBulb.mat'],'file')==2
   load([res,'/AnalyBulb.mat'],'Manipe')
   Manipe;
elseif exist([res,'/AnalyBulb.mat'],'file')~=2
   Manipe=input('   Give name of manipe (e.g. ''DPCPX'' ''VEHDPCPX'' ''CP'' ''Basal'') : ');
   save([res,'/AnalyBulb.mat'],'-v7.3','supposednameLFPA','Manipe');
end 
    

%% ------------------------------------------------------------------------
% --------------------------- LFPA ----------------------------------------
% -------------------------------------------------------------------------

disp(' ')
disp('... LFPA')

try 
    load([res,'/AnalyBulb.mat'],'LFPA')
    LFPA; error
    createLFPA=input('LFPA exists. Do you want to create a new one (y/n)? ','s');
catch
    LFPA=tsdArray;
    createLFPA='y';
end


if  createLFPA=='y'
    
    try
        load([res,'/AnalyBulb.mat'],'ChannelBulb');ChannelBulb; error
    catch
        disp('Enter the channel for Bulb LFP (number in neuroscope)');
        %disp('Default for KO-47 =17, WT-51 =15, KO-52 =17, KO-54 =10');
        ChannelBulb=input('channel : ');
        save([res,'/AnalyBulb.mat'],'-v7.3','ChannelBulb','-append');
    end
    
   
    for i=1:length(supposednameLFPA)
            LFPA{i}=Nultsd;
    end
        
    clear info LFP
    % ---------------
    % ---- BULBE ----
     load('listLFP.mat');
    load('LFPBulb.mat');
    LFPA{1}=LFP{find(listLFP.channels{strcmp(listLFP.name,'Bulb')}==ChannelBulb)};
    nameLFPA{1}=['LFP Bulb ',num2str(ChannelBulb)];
    
    % /////////////////////////////////////////////////////////////////
    %                add info if not existing
    try
        info.channels;
        info.name;
        info.depth;
    catch
        load('listLFP.mat');
        for ll=1:length(listLFP.name)
            info.depth=listLFP.depth{ll};
            info.channels=listLFP.channels{ll};
            info.name=listLFP.name{ll};
            save(['LFP',listLFP.name{ll}],'info','-append')
        end
    end
    % /////////////////////////////////////////////////////////////////
    
        
        
    
    % ----------------
    % ---- CORTEX ----
    clear LFP
    try
        % -- PaCx --
        load('LFPPaCx.mat');
        temp=find(info.depth>0);
        LFPA{2}=LFP{temp(1)};
        nameLFPA(2)={'LFP PaCx'};
        temp=find(info.depth<=0);
        LFPA{3}=LFP{temp(1)};
        nameLFPA(3)={'EEG PaCx'};
    catch
        clear LFP
        % -- AuCx --
        disp('      Failed to find EEG/EcoG and LFP for PaCx, trying AuCx')
        load('LFPAuCx.mat');
        temp=find(info.depth>0);
        try
            LFPA{2}=LFP{temp(1)};
            nameLFPA(2)={'LFP AuCx'};
        catch
            disp('      no LFP for AuCx, staying with PaCx')
        end
        temp=find(info.depth<=0);
        try
            LFPA{3}=LFP{temp(1)};
            nameLFPA(3)={'EEG AuCx'};
        catch
            disp('      no EEG for AuCx, staying with PaCx')
        end
        
    end
        
        
    
    
    % ---------------
    % ---- PFC ----
    clear LFP
    try
        load('LFPPFCx.mat');
        temp=find(info.depth>0);
        LFPA{4}=LFP{temp(1)};
        nameLFPA{4}='LFP PFCx';
    catch
        disp('      No LFP PFCx')
    end
    try
        temp=find(info.depth<=0);
        LFPA{5}=LFP{temp(1)};
        nameLFPA{5}='EEG PFCx';
    catch
        disp('      No EEG/EcoG PFCx')
    end
    
    
    % ---------------
    % ---- ThAu ----
    clear LFP
    try
        load('LFPAuTh.mat');
        LFPA{6}=LFP{1};
        nameLFPA{6}='LFP AuTh';
    catch
        disp('      No LFP AuTh')
    end    
    
    % ---------------
    for i=1:size(nameLFPA)
        try  nameLFPA{i}(1); catch, nameLFPA{i}='';end
    end
    
    save([res,'/AnalyBulb.mat'],'-v7.3','LFPA','nameLFPA','-append')
     
end
disp('Done.')



%% ------------------------------------------------------------------------
% ----------------------------- SPECTROGRAM -------------------------------
%--------------------------------------------------------------------------

disp(' ')
disp('... Spectrogram')

clear  Sp t f
try
    load([res,'/AnalyBulb.mat'],'Sp','t','f') 
    Sp;t;f;
catch
    Sp={};t={};f={};
    
    if params.Fs~=DownSampleFreq
        disp('   Down-sampled mtspecgramc ');
        paramsDown=params;
        paramsDown.Fs=DownSampleFreq; 
        save([res,'/AnalyBulb.mat'],'-v7.3','paramsDown','movingwin','-append')
    else
        save([res,'/AnalyBulb.mat'],'-v7.3','params','movingwin','-append')
    end
    for  i=1:size(LFPA,2)
        if isempty(Data(LFPA{i}))
            Spi=[];ti=[];fi=[];
        else
            if params.Fs~=DownSampleFreq
                LFPAtemp=resample(Data(LFPA{i}),DownSampleFreq,params.Fs);
                [Spi,ti,fi]=mtspecgramc(LFPAtemp,movingwin,paramsDown);
            else
                [Spi,ti,fi]=mtspecgramc(Data(LFPA{i}),movingwin,params);
            end
        end
        Sp{i}=Spi;t{i}=ti;f{i}=fi;
    end
    
    save([res,'/AnalyBulb.mat'],'-v7.3', 'Sp','t','f','-append') 
    
end
disp('Done.')



%% termination

cd(res);

% ---------------------------------------
% ------ verification of LFPA -----------
% ---------------------------------------
figure('color',[1 1 1]);
color={'k','b','r','m','c','g'};
legendF={};
for i=1:length(LFPA)
    try hold on, plot(f{i},mean(10*log10(Sp{i})),color{i}); legendF=[legendF,nameLFPA{i}];end
end
title('CodeBulbML2 : VERIFICATION OF LFPA');legend(legendF);



