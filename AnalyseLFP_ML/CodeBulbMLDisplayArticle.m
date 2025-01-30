%CodeBulbMLDisplayArticle

%% -- INITIALISATION --

disp('---------------------------------------------------------------------')
res=pwd;
warning off
scrsz = get(0,'ScreenSize');
color2={'k','r','b','m','g'};


%  -------------- INPUTS ---------------
nameEpoch={'REM' 'SWS' 'Wake'};
SaveFig=1;EraseFig=0;
nameFolderSave='Figure_Analyse20130114';
PoolKO=1;
plotallmean=0;
LFPAchannelChoice=3;
HPC=0;
ThAu=1;
%  -------------------------------------
SpectroInfo=load('SpectroDown.mat','WTmouse','KOmouse','Manipe','supposednameLFPA','movingwin');
WTmouse=SpectroInfo.WTmouse;
KOmouse=SpectroInfo.KOmouse;
Manipe=SpectroInfo.Manipe;
supposednameLFPA=SpectroInfo.supposednameLFPA;
movingwin=SpectroInfo.movingwin;

if HPC
    supposednameLFPA={'LfpHPC'};
    LFPAchannelChoice=1;
    load('HPCSpectroDown.mat','allSpDown','alltDown','allfDown')
elseif ThAu
    supposednameLFPA={'LfpThAu'};
    LFPAchannelChoice=1;
    load('ThAuSpectroDown.mat','allSpDown','alltDown','allfDown')
else
    load('SpectroDown.mat','allSpDown','alltDown','allfDown')
    if max(LFPAchannelChoice)>size(allSpDown,2)
        disp(['Spectro does not exist for ',supposednameLFPA{LFPAchannelChoice}])
        LFPAchannelChoice=1:size(allSpDown,2);
    end
end
for nn=1:length(nameEpoch), poolSp{LFPAchannelChoice,nn}=[];end

% --------- Initiate Figures -----------
for nn=1:length(nameEpoch), for LFPAchannel=LFPAchannelChoice,
        figure('color',[1 1 1],'Position',[2 scrsz(4) scrsz(3) scrsz(4)]), FF{LFPAchannel,nn}=gcf;end;end
namelegendFF={};textFF={};
essais={};
%% --------------------- allSpDown(manipe, channel) ----------------------
%  ------------------------------------------------------------------------

for man=1:length(Manipe)

    % ---------------------------------------------
    % --------- Dir, define iWT iKO ---------------
    % ---------------------------------------------
    
    disp(' ')
    disp(['* * * * *  Manipe ',Manipe{man},'  * * * * *'])
    
    try
        load([res,'/AnalyBulb',Manipe{man},'.mat'],'Dir')
    catch
        error(['No ,',[res,'/AnalyBulb',Manipe{man},'.mat'],'. CodeBulbML needs to be played.'])
    end
    
    disp(' ')
    disp('         ---------------------------')
    
    % - WT mouse -
    iWT=[];
    for i=1:length(WTmouse)
        temp=strfind(Dir.path,WTmouse{i});
        for j=1:length(temp)
            if isempty(temp{j})==0, iWT=[iWT,j];end
        end
    end
    
    % - KO mouse -
    iKO=[];
    for i=1:length(KOmouse)
        temp=strfind(Dir.path,KOmouse{i});
        for j=1:length(temp)
            if isempty(temp{j})==0, iKO=[iKO,j];end
        end
    end
    
    for i=[iWT,iKO], disp(['         ',num2str(i),'- ',Dir.group{i},' ',Dir.path{i}(end-16:end)]); end
    disp('         ---------------------------')
        
    
    % ---------------------------------------------------------------------
    % -------------------- for each nameEpoch -----------------------------
    % ---------------------------------------------------------------------
    
    for nn=1:length(nameEpoch)
        namelegendFF={};
        % ----------------------------------
        % ----------- Load Epoch -----------
        % ----------------------------------
        disp(' ')
        disp(['         ** ',nameEpoch{nn},' **'])
        
        clear EpochsPRE EpochsPOST 
        try
            load([res,'/AnalyBulb',Manipe{man},nameEpoch{nn},'.mat'],'EpochsPRE','EpochsPOST')
            Epochs={EpochsPRE EpochsPOST};
            InjePrePost={'PRE' 'POST'};
        catch
            error(['No ',[res,'/AnalyBulb',Manipe{man},nameEpoch{nn},'.mat'],'.'])
        end
        
        % -----------------------------------------------------------------
        % -------------------- for each LFPAchannel -----------------------
        % -----------------------------------------------------------------
                
        for LFPAchannel=LFPAchannelChoice
            Sp=allSpDown{man,LFPAchannel};t=alltDown{man,LFPAchannel};f=allfDown{man,LFPAchannel};
            
            for i=[iWT,iKO]
                try
                    TempSp=Sp{i};Tempt=t{i};Dispf{i}=f{i};
                    if LFPAchannel==1, disp(['     ',Dir.group{i},Dir.path{i}(end-11:end-9),'  PRE ',num2str(floor(sum(stop(EpochsPRE{i},'s')-start(EpochsPRE{i},'s')))),'s   POST ',num2str(floor(sum(stop(EpochsPOST{i},'s')-start(EpochsPOST{i},'s')))),'s']);end
                
                    for j=1:length(Epochs)
                        
                        try
                            sta=start(Epochs{j}{i},'s');
                            stp=stop(Epochs{j}{i},'s');
                            TempDispSp=[];TempDispt=[];
                            
                            for ss=1:length(sta)
                                I=find(Tempt>=sta(ss) & Tempt<stp(ss));
                                TempDispSp=[TempDispSp;TempSp(I,:)];
                                if isempty(TempDispt), tmax=0; else tmax=max(TempDispt); end
                                TempDispt=[TempDispt,tmax+[1:length(I)]*movingwin(2)];
                            end
                            
                            DispSp{i,j}= TempDispSp;
                            Dispt{i,j}=TempDispt;

                            if j==1
                                clear poolTemp
                                poolTemp=poolSp{LFPAchannel,nn};
                                poolTemp{i,man}=mean(10*log10(DispSp{i,j}));
                                poolSp{LFPAchannel,nn}=poolTemp;
                                
                                try
                                    figure(FF{LFPAchannel,nn}), subplot(length(Manipe),3,3*man),
                                    hold on, plot(Dispf{i},mean(10*log10(DispSp{i,j})),color2{i},'linewidth',2),caxis([27.3 80.4]),ylim([35 70])
                                    try tempnamelegend=[namelegendFF,[Dir.group{i},Dir.path{i}(end-11:end-9)]];
                                    catch, tempnamelegend={[Dir.group{i},Dir.path{i}(end-11:end-9)]};
                                    end
                                    
                                    namelegendFF=tempnamelegend;
                                    legend(namelegendFF);
                                    title([supposednameLFPA{LFPAchannel},', -',nameEpoch{nn},'- dKO vs WT, manipe ',Manipe{man}],'FontWeight','bold')
                                    
                                    if plotallmean
                                        subplot(length(Manipe),3,[1,2,4,5]), hold on, plot(Dispf{i},mean(10*log10(DispSp{i,j})),[color2{i},':']),caxis([27.3 80.4]),ylim([35 70])
                                    end
                                    
                                    try textFF{LFPAchannel,nn}=[textFF{LFPAchannel,nn},{[Manipe{man},', ',[Dir.group{i},Dir.path{i}(end-16:end)],', ',nameEpoch{nn},'=',num2str(floor(sum(stop(EpochsPRE{i},'s')-start(EpochsPRE{i},'s')))),'s']},{' '}];
                                    catch, textFF{LFPAchannel,nn}=[{[Manipe{man},', ',[Dir.group{i},Dir.path{i}(end-16:end)],', ',nameEpoch{nn},'=',num2str(floor(sum(stop(EpochsPRE{i},'s')-start(EpochsPRE{i},'s')))),'s']},{' '}];
                                    end
                                end
                            end
                        catch
                            disp(['Problem with Spectrogram ',InjePrePost{j}]);
                        end
                    end
                catch  
                    disp(['     No spectro for ',Dir.group{i},Dir.path{i}(end-11:end-9)])
                end
            end

        end
    end
end

%% pool manipes
for LFPAchannel=LFPAchannelChoice
    for nn=1:length(nameEpoch)
        
        figure(FF{LFPAchannel,nn}), subplot(length(Manipe),3,[1,2,4,5]), hold on,
        poolTemp=poolSp{LFPAchannel,nn};

        if PoolKO
            MeanPoolSp=[];templegWT=[];
            for i=iWT
                for man=1:length(Manipe), MeanPoolSp=[MeanPoolSp;poolTemp{i,man}];end
                templegWT=[templegWT,' ',[Dir.group{i},Dir.path{i}(end-11:end-9)]];
            end
            plot(Dispf{i},mean(MeanPoolSp),color2{1},'linewidth',2),caxis([27.3 80.4]),ylim([35 70])
            hold on, plot(Dispf{i},mean(MeanPoolSp)+stderror(MeanPoolSp),color2{1}),caxis([27.3 80.4]),ylim([35 70])
            hold on, plot(Dispf{i},mean(MeanPoolSp)-stderror(MeanPoolSp),color2{1}),caxis([27.3 80.4]),ylim([35 70])
            
            MeanPoolSp=[];templegKO=[];
            for i=iKO
                for man=1:length(Manipe), MeanPoolSp=[MeanPoolSp;poolTemp{i,man}];end
                templegKO=[templegKO,' ',[Dir.group{i},Dir.path{i}(end-11:end-9)]];
            end
            plot(Dispf{i},mean(MeanPoolSp),color2{2},'linewidth',2),caxis([27.3 80.4]),ylim([35 70])
            hold on, plot(Dispf{i},mean(MeanPoolSp)+stderror(MeanPoolSp),color2{2}),caxis([27.3 80.4]),ylim([35 70])
            hold on, plot(Dispf{i},mean(MeanPoolSp)-stderror(MeanPoolSp),color2{2}),caxis([27.3 80.4]),ylim([35 70])
            legend([templegWT,{'+SEM'},{'-SEM'},templegKO,{'+SEM'},{'-SEM'}])
        else
            templegend={};
            for i=[iWT,iKO]
                MeanPoolSp=[];
                for man=1:length(Manipe)
                    MeanPoolSp(man,:)=poolTemp{i,man};
                end
                
                try plot(Dispf{i},mean(MeanPoolSp),color2{i},'linewidth',2),caxis([27.3 80.4]),ylim([35 70])
                hold on, plot(Dispf{i},mean(MeanPoolSp)+stdError(MeanPoolSp),color2{i}),caxis([27.3 80.4]),ylim([35 70]);
                hold on, plot(Dispf{i},mean(MeanPoolSp)-stdError(MeanPoolSp),color2{i}),caxis([27.3 80.4]),ylim([35 70]);
                templegend={templegend{:},[Dir.group{i},Dir.path{i}(end-11:end-9)],'+SEM','-SEM'};end
            end
            legend(templegend)
        end
        title(['Mean ',supposednameLFPA{LFPAchannel},' Spectrogramm, -',nameEpoch{nn},'- dKO vs WT'],'FontWeight','bold')
        
        subplot(3,3,7:8), hold on
        ylim([0,10]), xlim([0,10])
        text(1,5,textFF{LFPAchannel,nn})
        axis off
        % ---- Save Figures
        if SaveFig
            if PoolKO, nameFig=['PooledFreqSpectr-',nameEpoch{nn},'-',supposednameLFPA{LFPAchannel},];
            else nameFig=['FreqSpectr-',nameEpoch{nn},'-',supposednameLFPA{LFPAchannel}];
            end
            
            if EraseFig==0
                ok=exist([res,'/',nameFolderSave,'/',nameFig,'.png'],'file');
                while ok==2
                    nameFig=[nameFig,'Bis'];
                    ok=exist([res,'/',nameFolderSave,'/',nameFig,'.png'],'file');
                end
            end
            saveFigure(FF{LFPAchannel,nn},nameFig,[res,'/',nameFolderSave])
        end
    end    
end


%% termniation
cd(res)
