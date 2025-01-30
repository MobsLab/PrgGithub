%CodeBulbMLDisplay

%% -- INITIALISATION --
disp('---------------------------------------------------------------------')
res=pwd;
warning off
PasEpoch=1800; % in second = 30min
freqVideo=30;
scrsz = get(0,'ScreenSize');
color2={'k','r','b','m','g'};

params.Fs=1250;
params.trialave=0;
params.err=[1 0.0500];
params.pad=2;
params.fpass=[0 30];
%params.tapers=[1 2];
movingwin=[3 0.2];
params.tapers=[3 5];

% ------------------------------------------------------
% ----------------------- Inputs -----------------------
% ------------------------------------------------------

%  --------------- MICE ---------------  
KOmouse={'Mouse-47' 'Mouse-52'};
WTmouse={'Mouse-51'};

%  --------------- MANIPE ---------------  
%Manipe={'Dpcpx'};
%Manipe={'Vehicul'};
%Manipe={'Basal'};
Manipe={'Vehicul' 'Dpcpx' 'Basal'};

%  --------------- Epochs --------------- 
%nameEpoch={'REM'};
%nameEpoch={'SWS'};
%nameEpoch={'Wake'};
nameEpoch={'REM' 'SWS' 'Wake'};

%  --------------- Spectro --------------- 
CompDownSampleSpectro=1;
DownSampleFreq=200; % 200 Hz
supposednameLFPA={'LFPbulb' 'LFPCx' 'EEGCx' 'LFPpfc' 'EEGpfc'};
LFPAchannel=3;
if LFPAchannel~=1, CompDownSampleSpectro=1;end

%  --------------- Plot and save figure --------------- 
plotDelta=0;
plotSpindles=0;
plotFreqSpectrWTvsKO=1;
plotWakeStates=0;
plotFreqSpectrPOSTinjection=0;
plotSpectro=0;
plotLFPbrut=0;

SaveFig=1;
nameFolderSave='Figure_Analyse20130114';


% --------------- Initiate Figures ---------------------
if length(Manipe)>1
    plotFreqSpectrAutoComp=1;
    figure('color',[1 1 1],'Position',[2 scrsz(4) scrsz(3) scrsz(4)]), hold on, FF=gcf;
    for i=1:length(KOmouse)+length(WTmouse), for nn=1:length(nameEpoch), namelegendFF{i,nn}={};end;end    
else
    plotFreqSpectrAutoComp=0;
end

if plotFreqSpectrWTvsKO, 
    figure('color',[1 1 1],'Position',[2 scrsz(4) scrsz(3) scrsz(4)]), FG=gcf;
    if plotWakeStates, figure('color',[1 1 1],'Position',[2 scrsz(4) scrsz(3) scrsz(4)]),hold on, FI=gcf;end
end


%% -- ANALYSE for each Manipe--

try
    load('SpectroDown.mat','allSpDown','alltDown','allfDown')
    Old=load('SpectroDown.mat','KOmouse','WTmouse','Manipe');
	disp(['SpectroDown.mat exists on manipe ',Old.Manipe{:}])
    disp(['                       on mice ',Old.WTmouse{:},' ',Old.KOmouse{:}])
    disp(['Now, analysis is on manipe ',Manipe{:}])
    disp(['                 on mice ',WTmouse{:},' ',KOmouse{:}])
    okSpect=input('Do you want to continue with the old Spectro data (y/n) ? ','s');
    if okSpect=='n', disp('Erasing previous SpectroDown.mat');error; end
catch
    allSpDown={};alltDown={};allfDown={};
    save('SpectroDown.mat','-v7.3','KOmouse','WTmouse','Manipe','DownSampleFreq','params','movingwin')
end

for man=1:length(Manipe)    
    
    % ---------------------------------------------------------------------
    % --------------- Load LFPA, Dir, define iWT iKO ----------------------
    % ---------------------------------------------------------------------
    
    disp(' ')
    disp(['* * * * *  Manipe ',Manipe{man},'  * * * * *'])
    
    clear LFPA nameLFPA Dir Mm
    try
        disp('LoadLFA...')
        load([res,'/AnalyBulb',Manipe{man},'.mat'],'LFPA','nameLFPA','Dir','Mm')
        
    catch
        error(['No ,',[res,'/AnalyBulb',Manipe{man},'.mat'],'. CodeBulbML needs to be played.'])
    end
    
        
    %  Name LFPs and tracking
    %  -----------------------
    
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
    % -------------------------- SPECTRO ----------------------------------
    % ---------------------------------------------------------------------

    if plotSpectro, for j=1:2, figure('color',[1 1 1],'Position',[2 scrsz(4) scrsz(3) 2*scrsz(4)]), hold on, FH{man,j}=gcf;end;end
    if plotFreqSpectrPOSTinjection,figure('color',[1 1 1],'Position',[2 scrsz(4) scrsz(3) 2*scrsz(4)]); FJ{man}=gcf; end 

    if CompDownSampleSpectro
        SpDown={};tDown={};fDown={};
        try
            SpDown=allSpDown{man,LFPAchannel};
            SpDown{1};
        catch

            for  i=1:size(LFPA,1)
                try
                    SpDown{i};
                catch
                    try
                    disp(['   Down-sampled mtspecgramc ',Dir.path{i}(end-16:end)]);
                    LFPAtemp=resample(Data(LFPA{i,LFPAchannel}),DownSampleFreq,params.Fs);
                    paramsDown=params;
                    paramsDown.Fs=DownSampleFreq;
                    [Spi,ti,fi]=mtspecgramc(LFPAtemp,movingwin,paramsDown);
                    SpDown{i}=Spi;tDown{i}=ti;fDown{i}=fi;
                    catch
                        disp(['           No ',supposednameLFPA{LFPAchannel},'for ',Dir.path{i}(end-16:end)])
                    end
                end
            end

            allSpDown{man,LFPAchannel}=SpDown;
            alltDown{man,LFPAchannel}=tDown;
            allfDown{man,LFPAchannel}=fDown;
            disp(['Saving Sp t and f of manipe ',Manipe{man},' in SpectroDown.mat'])
            save([res,'/SpectroDown.mat'],'-v7.3','allSpDown','alltDown','allfDown','-append')
        end
        
    end
    
    load([res,'/AnalyBulb',Manipe{man},'.mat'],'Sp','t','f')
    for nn=1:length(nameEpoch)
        
        % ----------------------------------
        % -- Compute Spectro & Load Epoch --
        % ----------------------------------
        disp(' ')
        disp(['         ** ',nameEpoch{nn},' **'])
        disp(['Computing spectro ',supposednameLFPA{LFPAchannel},'...']);
        
        clear EpochsPRE EpochsPOST InjectionTime DispSp Dispt DispMm DispSpWake DisptWake DispMmWake DispSpPost DisptPost DispMmPost
        try
            load([res,'/AnalyBulb',Manipe{man},nameEpoch{nn},'.mat'])
            EpochsPRE;
            EpochsPOST;
            InjectionTime;
            Epochs={EpochsPRE EpochsPOST};
            InjePrePost={'PRE' 'POST'};
            if strcmp(nameEpoch{nn},'Wake')
                EpochsPREWake;
                EpochsPOSTWake;
                Epochs={EpochsPRE EpochsPOST EpochsPREWake(:,1) EpochsPREWake(:,2) EpochsPREWake(:,3) EpochsPOSTWake(:,1) EpochsPOSTWake(:,2) EpochsPOSTWake(:,3)};
                InjePrePost={'PRE' 'POST' 'PRE Theta' 'PRE Movement' 'PRE Steal' 'POST Theta' 'POST Movement' 'POST Steal'};
            end
        catch
            error(['No ',[res,'/AnalyBulb',Manipe{man},nameEpoch{nn},'.mat'],'.'])
        end
        
        
        DispSp=tsdArray; Dispt=tsdArray; Dispf=tsdArray; DispMm=tsdArray; DispSpPost=tsdArray; DisptPost=tsdArray; DispMmPost=tsdArray;
        if strcmp(nameEpoch{nn},'Wake'), DispSpWake=tsdArray; DisptWake=tsdArray; DispMmWake=tsdArray; end
        
             
        for i=[iWT,iKO]    
            disp(['     ',Dir.group{i},Dir.path{i}(end-11:end-9),'  PRE ',num2str(floor(sum(stop(EpochsPRE{i},'s')-start(EpochsPRE{i},'s')))),'s   POST ',num2str(floor(sum(stop(EpochsPOST{i},'s')-start(EpochsPOST{i},'s')))),'s'])
            
            TempSp=Sp{i};Tempt=t{i};Dispf{i}=f{i};
            if CompDownSampleSpectro, TempSp=SpDown{i};Tempt=tDown{i}; Dispf{i}=fDown{i}; end
            
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
 
                    if j<=2
                        DispSp{i,j}= TempDispSp;
                        Dispt{i,j}=TempDispt;
                        DispMm{i,j}=tsd([1:length(Data(Restrict(Mm{i},Epochs{j}{i})))]/freqVideo*1E4,Data(Restrict(Mm{i},Epochs{j}{i})));

                    else
                        
                        DispSpWake{i,j-2}=TempDispSp;
                        DisptWake{i,j-2}=TempDispt;
                        DispMmWake{i,j-2}=tsd([1:length(Data(Restrict(Mm{i},Epochs{j}{i})))]/freqVideo*1E4,Data(Restrict(Mm{i},Epochs{j}{i})));
                    end
                    
                    % ---------- SUBSETS ------------
                    if j==2 && isempty(InjectionTime{i})==0 && plotFreqSpectrPOSTinjection
                         
                        Rpost=Range(Restrict(LFPA{i,LFPAchannel},Epochs{j}{i}),'s');
                        %disp(['     ',num2str(floor((max(Rpost)-InjectionTime{i})/PasEpoch)),' x 30min Subepochs Post injection']);
                        
                        for k=1:floor((max(Rpost)-InjectionTime{i})/PasEpoch)
                            TempEpoch=intervalSet((min(Rpost)+(k-1)*PasEpoch)*1E4,(min(Rpost)+k*PasEpoch)*1E4);
                            sta=start(and(TempEpoch,Epochs{j}{i}),'s');
                            stp=stop(and(TempEpoch,Epochs{j}{i}),'s');
                            
                            TempDispSp=[];TempDispt=[];
                            for ss=1:length(sta)
                                I=find(Tempt>sta(ss) & Tempt<stp(ss));
                                TempDispSp=[TempDispSp;TempSp(I,:)];
                                if isempty(TempDispt), tmax=0; else tmax=max(TempDispt); end
                                TempDispt=[TempDispt,tmax+[1:length(I)]*movingwin(2)];
                            end

                            DispSpPost{i,k}=TempDispSp;
                            DisptPost{i,k}=TempDispt;
                            try DispMmPost{i,k}=tsd([1:length(Data(Restrict(Mm{i},and(TempEpoch,Epochs{j}{i}))))]/freqVideo*1E4,Data(Restrict(Mm{i},TempEpoch)));  end
                        end
                    end
                    
                catch
                    disp(['Problem with Spectrogram ',InjePrePost{j}]);
                end
            end
            
        end

        
        
        % ----------------------------------
        % -------- ImagePETH Delta ---------
        % ----------------------------------
        color={'g' 'k' 'b' 'r' 'm'};
        typoplus=[2 1 1 1 1];
        
        if plotDelta
            disp('Display ImagePETH Delta...')
            try
                matDppre; matDppost;
                
                for i=[iWT,iKO]
                    
                    figure('color',[1 1 1])
                    
                    for j=1:2
                        
                        ileg=[];
                        subplot(2,1,j), title(['DELTA (n=',num2str(length(Range(Restrict(Dp{i},Epochs{j}{i})))),') - ',Dir.path{i}(end-16:end-9),' - ',Dir.group{i},' ',InjePrePost{j},', ',nameEpoch{nn}])
                        for k=1:5
                            if j==1, try hold on, plot(Range(matDppre{i,k},'ms'),mean(Data(matDppre{i,k})'),color{k},'linewidth',typoplus(k));ileg=[ileg,k];end;end
                            if j==2, try hold on, plot(Range(matDppost{i,k},'ms'),mean(Data(matDppost{i,k})'),color{k},'linewidth',typoplus(k));ileg=[ileg,k];end;end
                        end
                        ylim([-4000 5000]),
                    end
                    legend(nameLFPA(i,ileg))
                    
                end
                
            catch
                disp('Problem with display of ImagePETH Delta');
            end
            
        end
        
        
        
        % ----------------------------------
        % ------- ImagePETH Spindles -------
        % ----------------------------------
        
        if plotSpindles
            disp('Display ImagePETH Spindles...')
            try
                matSppre; matSppost;
                for i=[iWT,iKO]
                    
                    figure('color',[1 1 1]),
                    
                    for j=1:2
                        ileg=[];
                        
                        subplot(2,1,j), title(['SPINDLES (n=',num2str(length(Range(Restrict(Spn{i},Epochs{j}{i})))),') -  ',Dir.path{i}(end-16:end-9),' - ',Dir.group{i},' ',InjePrePost{j},', ',nameEpoch{nn}])
                        for k=1:5
                            if j==1, try hold on, plot(Range(matSppre{i,k},'ms'),mean(Data(matSppre{i,k})'),color{k},'linewidth',typoplus(k));ileg=[ileg,k];end;end;
                            if j==2, try hold on, plot(Range(matSppost{i,k},'ms'),mean(Data(matSppost{i,k})'),color{k},'linewidth',typoplus(k));ileg=[ileg,k];end;end
                        end
                        ylim([-4000 5000]),xlim([-500 500]),
                    end
                    legend(nameLFPA(i,ileg))
                    
                end
                
            catch
                disp('Problem with display of ImagePETH Spindles');
            end
        end
        
        
        
        % ----------------------------------
        % ---------- SPECTROGRAM -----------
        % ----------------------------------
        
        color={'k','r','m','b','r','m','b','r','m','b'};
        typoplus=[2 2 2 ;1 1 1 ];
        typoplusline={'-' '-' '-' ;'--' '--' '--'};
        
        try
            Sp;t;f;Mm;
        catch
            error('Missing parameters for spectrogram')
        end
        
        
        % --- COMPARE Mouse WT versus doKO ---
        % ------------------------------------       
        if plotFreqSpectrWTvsKO
            disp('Display COMPARE Mouse WT versus doKO...')
            namelegendFG={};
            
            for i=[iWT,iKO]
                if isempty(InjectionTime{i})
                    LegInj{i}={'No '};
                    try close(figure(FH{man,2}));end
                else LegInj{i}={'PRE ' 'POST '};
                end
                
                for j=1:length(LegInj{i})
                    try
                        figure(FG), subplot(length(Manipe),length(nameEpoch),(man-1)*length(nameEpoch)+nn), hold on,
                        plot(Dispf{i},mean(10*log10(DispSp{i,j})),[color2{i},typoplusline{j,i}],'linewidth',typoplus(j,i)),caxis([27.3 80.4]),ylim([35 70])
                        namelegendFG=[namelegendFG,[Dir.group{i},Dir.path{i}(end-11:end-9),' ',LegInj{i}{j}]];

                        if plotFreqSpectrAutoComp
                            figure(FF), subplot(length([iWT,iKO]),length(nameEpoch),(i-1)*length(nameEpoch)+nn), hold on, 
                            plot(Dispf{i},mean(10*log10(DispSp{i,j})),[color2{man},typoplusline{j,i}],'linewidth',typoplus(j,i)),caxis([27.3 80.4]),ylim([35 70])
                            tempnamelegend=[namelegendFF{i,nn},['Manipe ',Manipe{man},' ',LegInj{i}{j}]];
                            namelegendFF{i,nn}=tempnamelegend;
                            if CompDownSampleSpectro, title([Dir.group{i},' ',Dir.path{i}(end-16:end-9),', ',nameEpoch{nn},' -',supposednameLFPA{LFPAchannel}])
                            else title([Dir.group{i},' ',Dir.path{i}(end-16:end-9),', ',nameEpoch{nn}]);end
                        end
                    catch
                        disp(['Pb display freqSpectro dKO vs WT, ',Dir.group{i},Dir.path{i}(end-11:end-9),', ',LegInj{i}{j},' inj']);
                    end
                end
            end
            
            figure(FG), if CompDownSampleSpectro, title(['WT vs KO, ',Manipe{man},', ',LegInj{i}{:},'injection, ',nameEpoch{nn},' -',supposednameLFPA{LFPAchannel}]);
            else title(['WT vs KO, ',Manipe{man},', ',LegInj{i}{:},'injection, ',nameEpoch{nn}]);end
           
            if plotWakeStates
            % ------- Wake subepochs ------------
            if strcmp(nameEpoch{nn},'Wake')
                Wakelegend={'Theta' 'Movement' 'Steal'};
                namelegendFI={};
                
                figure(FI)
                for k=1:2
                    
                    for j=1:3
                        subplot(length(Manipe),3,3*(man-1)+j), hold on,
                        
                        for i=[iWT,iKO]
                            try
                                plot(Dispf{i},mean(10*log10(DispSpWake{i,(k-1)*3+j})),[color{i},typoplusline{k,i}],'linewidth',typoplus(k,i)),caxis([27.3 80.4]),ylim([35 70])
                                if k==1 && j==1;namelegendFI=[namelegendFI,[Dir.group{i},Dir.path{i}(end-11:end-9),' ',LegInj{i}{k}]];end
                            end
                        end
                        if CompDownSampleSpectro, title(['WT vs KO, ',Manipe{man},' injection, Wake ',Wakelegend{j},' -',supposednameLFPA{LFPAchannel}]);
                        else title(['WT vs KO, ',Manipe{man},' injection, Wake ',Wakelegend{j},' -',supposednameLFPA{LFPAchannel}]);end
                    end
                end
                legend(namelegendFI)
            end
            end
        end
        
        
        % ---- subEpoch post INJECTION ----
        % ---------------------------------
        
        if plotFreqSpectrPOSTinjection
            textlegend={'PRE','30min POST','1h POST','1h30 POST','2h POST','2h30 POST','3h POST','3h30 POST'};
            typoplusline={'-' '-' '--' '--' '--' ':' ':' ':'};
            typoplus=[2 2 1 1 1 1 1 1 1 ];
            color={'k','r','m','b','r','m','b','r'};
            disp('Display subEpoch Post injection...')
            % subset after injection
            try
                DispSpPost;DisptPost;DispMmPost;
                closefigureFJman=0;
                for i=[iWT,iKO]
                    if isempty(InjectionTime{i})==0
                        %disp(['Display subEpoch Post injection ',Dir.group{i},Dir.path{i}(end-11:end-9),'...']) 
                        try
                            figure(FJ{man}), subplot(length([iWT,iKO]),length(nameEpoch),length(nameEpoch)*(i-1)+nn), hold on,
                            plot(Dispf{i},mean(10*log10(DispSp{i,1})),[color{1},typoplusline{1}],'linewidth',typoplus(1)),caxis([27.3 80.4]),ylim([35 70])
                            ileg=1;
                            for j=1:size(DispSpPost,2)
                                if isempty(DispSpPost{i,j})==0
                                    plot(Dispf{i},mean(10*log10(DispSpPost{i,j})),[color{j+1},typoplusline{j+1}],'linewidth',typoplus(j+1)),caxis([27.3 80.4]);ileg=[ileg,j+1];
                                end
                            end
                            
                            if CompDownSampleSpectro, title([Dir.group{i},Dir.path{i}(end-11:end-9),', ',Manipe{man},' injection',', ',nameEpoch{nn},' -',supposednameLFPA{LFPAchannel}])
                            else title([Dir.group{i},Dir.path{i}(end-11:end-9),', ',Manipe{man},' injection',', ',nameEpoch{nn},' -',supposednameLFPA{LFPAchannel}]);end
                            legend(textlegend(ileg))
                        catch
                            disp(['Pb display subsetEpoch after injection of ',Dir.path{i}(end-16:end-9)]);
                        end
                    else
                        closefigureFJman=closefigureFJman+1; 
                    end
                    if closefigureFJman==length([iWT,iKO]), close(figure(FJ{man}));end
                end
            catch
                disp('Problem with subsetEpoch after injection, no parameters')
            end;
        end

        
        
        % ------------ SPECTRO ------------
        % ---------------------------------
        if plotSpectro
            
            xMax={[] []};
            for i=1:size(Dispt,1)
                for j=1:size(Dispt,2)
                    xMax{j}=[xMax{j}, max(Dispt{i,j})];
                end
            end
            
            for i=[iWT,iKO]
                if isempty(InjectionTime{i})==0, LegInj{i}={'PRE ' 'POST '}; else LegInj{i}={'No'}; end
                try
                    for j=1:length(LegInj{i})
                        
                        figure(FH{man,j}), subplot(length([iWT,iKO]),length(nameEpoch),(i-1)*length(nameEpoch)+nn)
                        imagesc(Dispt{i,j},Dispf{i},10*log10(DispSp{i,j}')), axis xy, caxis([20 70]),
                        hold on, plot(Range(DispMm{i,j},'s'),10+Data(DispMm{i,j}),'k'), xlim([0 max(xMax{j})])
                        if CompDownSampleSpectro, title([Dir.group{i},Dir.path{i}(end-11:end-9),', ',Manipe{man},' ',LegInj{i}{j},'injection, ',nameEpoch{nn},' -',supposednameLFPA{LFPAchannel}])
                        else title([Dir.group{i},Dir.path{i}(end-11:end-9),', ',Manipe{man},' ',LegInj{i}{j},'injection, ',nameEpoch{nn},' -',supposednameLFPA{LFPAchannel}]);end
                    end
                catch
                    disp(['Problem with display of Spectrogram of ', Dir.path{i}(end-16:end-9),', ',nameEpoch{nn}]);
                end
                
            end
        end
        
    end
    if plotFreqSpectrWTvsKO, figure(FG), legend(namelegendFG);end
end


% add legend on figure
if plotFreqSpectrAutoComp, figure(FF), legend(namelegendFF{i,nn});end



%% Save Figures

if SaveFig
    
    if plotFreqSpectrAutoComp,
        saveFigure(FF,['FreqSpectr-AutoComp-Manipe',Manipe{:},'-',supposednameLFPA{LFPAchannel}],[res,'/',nameFolderSave]);
    end
    if plotFreqSpectrWTvsKO,
       saveFigure(FG,['FreqSpectr-WTvsKO-Manipe',Manipe{:},'-',supposednameLFPA{LFPAchannel}],[res,'/',nameFolderSave]);
       if plotWakeStates, saveFigure(FI,['FreqSpectr-WakeSubEpochs-WTvsKO-Manipe',Manipe{:},'-',supposednameLFPA{LFPAchannel}],[res,'/',nameFolderSave]);end
    end
    for man=1:length(Manipe)
        if plotSpectro
            for j=1:2, try saveFigure(FH{man,j},['Spectro-WTetKO-Manipe',Manipe{man},InjePrePost{j},'-',supposednameLFPA{LFPAchannel}],[res,'/',nameFolderSave]);end;end
        end   
        if plotFreqSpectrPOSTinjection
           try saveFigure(FJ{man},['FreqSpectr-POSTinjection-Manipe',Manipe{man},'-',supposednameLFPA{LFPAchannel}],[res,'/',nameFolderSave]);end
        end
    end
end

%% termniation
cd(res)

%% plot LFP + Event


color={'g' 'k' 'b' 'r' 'm'};

if plotLFPbrut
    
    i=2;
    pasDisplay=1; %temps en seconde
    
    % PRE delta
    figure('color',[1 1 1]),
    RDpre=[Range(Dppre{i},'s');Range(Dtpre{i},'s')];
    
    for k=1:length(RDpre)
        I=intervalSet((RDpre(k)-pasDisplay)*1E4,(RDpre(k)+pasDisplay)*1E4);
        for j=1:size(LFPA,2)
            
            try plot(Range(Restrict(LFPA{i,j},I),'s'),Data(Restrict(LFPA{i,j},I))+(j-1)*2000,color{j},'linewidth',1); end
            hold on, line([RDpre(k) RDpre(k)],[0 1E4],'color','r','linewidth',1);
        end
        xlim([RDpre(k)-pasDisplay,RDpre(k)+pasDisplay])
        title(['Delta - PRE injection, ',num2str(k),'/',num2str(length(RDpre))])
        hold off,
        ok=input('Enter to continue');
    end
    % POST delta
    figure('color',[1 1 1]),
    RDpost=[Range(Dppost{i},'s');Range(Dtpost{i},'s')];
    
    for k=1:length(RDpost)
        I=intervalSet((RDpost(k)-pasDisplay)*1E4,(RDpost(k)+pasDisplay)*1E4);
        for j=1:size(LFPA,2)
            
            try plot(Range(Restrict(LFPA{i,j},I),'s'),Data(Restrict(LFPA{i,j},I))+(j-1)*2000,color{j},'linewidth',1); end
            hold on, line([RDpost(k) RDpost(k)],[0 1E4],'color','r','linewidth',1);
        end
        xlim([RDpost(k)-pasDisplay,RDpost(k)+pasDisplay])
        title(['Delta - POST injection, ',num2str(k),'/',num2str(length(RDpost))])
        hold off,
        ok=input('Enter to continue');
    end
    
    
    pasDisplay=0.5; %temps en seconde
    % PRE Spindles
    figure('color',[1 1 1]),
    RSpre=Range(Sppre{i},'s');
    
    for k=1:length(RSpre)
        I=intervalSet((RSpre(k)-pasDisplay)*1E4,(RSpre(k)+pasDisplay)*1E4);
        for j=1:size(LFPA,2)
            
            try plot(Range(Restrict(LFPA{i,j},I),'s'),Data(Restrict(LFPA{i,j},I))+(j-1)*2000,color{j},'linewidth',1); end
            hold on, line([RSpre(k) RSpre(k)],[0 1E4],'color','r','linewidth',1);
        end
        xlim([RSpre(k)-pasDisplay,RSpre(k)+pasDisplay])
        title(['Spindles - PRE injection, ',num2str(k),'/',num2str(length(RSpre))])
        hold off,
        ok=input('Press left (4) to go back, right (6) to go forward. ');
    end
    % POST Spindles
    figure('color',[1 1 1]),
    RSpre=Range(Sppost{i},'s');
    
    for k=1:length(RSpost)
        I=intervalSet((RSpost(k)-pasDisplay)*1E4,(RSpost(k)+pasDisplay)*1E4);
        for j=1:size(LFPA,2)
            
            try plot(Range(Restrict(LFPA{i,j},I),'s'),Data(Restrict(LFPA{i,j},I))+(j-1)*2000,color{j},'linewidth',1); end
            hold on, line([RSpost(k) RSpost(k)],[0 1E4],'color','r','linewidth',1);
        end
        xlim([RSpost(k)-pasDisplay,RSpost(k)+pasDisplay])
        title(['Spindles - PRE injection, ',num2str(k),'/',num2str(length(RSpost))])
        hold off,
        ok=input('Press arrow to continue : left (4) to go back, right (6) to go forward. ');
    end
    
end
        
        
             
        % ----------------------------------
        % -- Compute Spectro & Load Epoch --
        % ----------------------------------   

        %     % -- Epoch PRE --
        %     Lpre=floor(sum(Stop(EpochsPRE{i},'s')-Start(EpochsPRE{i},'s')));
        %     disp(['     PreEpoch: ',num2str(Lpre),'s']);
        %     DispSp{i,1}=Restrict(Sp{i},EpochsPRE{i});
        %     Dispt{i,1}=Restrict(Sp{i},EpochsPRE{i});
        %     Dispf{i,1}=Restrict(Sp{i},EpochsPRE{i});
        %     Mm{i,1}=tsd((1:length(Data(Restrict(Mov{i},EpochsPRE{i}))))/freqVideo*1E4,Data(Restrict(Mov{i},EpochsPRE{i})));
        %
        %     if isempty(start(EpochsPOST{i}))==0
        %         % ----------------
        %         % -- Epoch POST --
        %
        %         sbs=length(Start(EpochsPOST{i}));
        %         Lpost=floor(sum(Stop(EpochsPOST{i},'s')-Start(EpochsPOST{i},'s')));
        %         disp(['     PostEpoch: ',num2str(Lpost),'s']);
        %         [Spi,ti,fi]=mtspecgramc(Data(Restrict(LFPA{i,1},EpochsPOST{i})),movingwin,params);
        %         Sp{i,2}=Spi;t{i,2}=ti;f{i,2}=fi;
        %         Mm{i,2}=tsd((1:length(Data(Restrict(Mov{i},EpochsPOST{i}))))/freqVideo*1E4,Data(Restrict(Mov{i},EpochsPOST{i})));
        %         % ---------- SUBSETS ------------
        %         Rpost=Range(Restrict(LFPA{i,1},EpochsPOST{i}),'s');
        %         for j=1:floor((max(Rpost)-InjectionTime{i})/PasEpoch)
        %             TempEpoch=intervalSet((min(Rpost)+(j-1)*PasEpoch)*1E4,(min(Rpost)+j*PasEpoch)*1E4);
        %             [Spi,ti,fi]=mtspecgramc(Data(Restrict(LFPA{i,1},and(TempEpoch,EpochsPOST{i}))),movingwin,params);
        %             Sp{i,j+2}=Spi;t{i,j+2}=ti;f{i,j+2}=fi;
        %             Mm{i,j+2}=tsd((1:length(Data(Restrict(Mov{i},and(TempEpoch,EpochsPOST{i})))))/freqVideo*1E4,Data(Restrict(Mov{i},and(TempEpoch,EpochsPOST{i}))));
        %         end
        %     end
        %
        %     if strcmp(nameEpoch{nn},'Wake')
        %         nameWakeEpoch={'Theta' 'move' 'steal'};
        %
        %         % -- Epoch PRE --
        %         for j=1:3
        %             disp(['         Pre-',nameWakeEpoch{j},'Epoch: ',num2str(floor(sum(Stop(EpochsPREWake{i,j},'s')-Start(EpochsPREWake{i,j},'s')))),'s']);
        %             [Spi,ti,fi]=mtspecgramc(Data(Restrict(LFPA{i,1},EpochsPREWake{i,j})),movingwin,params);
        %             SpWake{i,j}=Spi;tWake{i,j}=ti;fWake{i,j}=fi;
        %             MmWake{i,j}=tsd((1:length(Data(Restrict(Mov{i},EpochsPREWake{i,j}))))/freqVideo*1E4,Data(Restrict(Mov{i},EpochsPREWake{i,j})));
        %         end
        %
        %         % -- Epoch POST --
        %         for j=1:3
        %             if isempty(start(EpochsPOSTWake{i,j}))==0
        %                 disp(['         Post-',nameWakeEpoch{j},'Epoch: ',num2str(floor(sum(Stop(EpochsPOSTWake{i,j},'s')-Start(EpochsPOSTWake{i,j},'s')))),'s']);
        %                 [Spi,ti,fi]=mtspecgramc(Data(Restrict(LFPA{i,1},EpochsPOSTWake{i,j})),movingwin,params);
        %                 SpWake{i,3+j}=Spi;tWake{i,3+j}=ti;fWake{i,3+j}=fi;
        %                 MmWake{i,3+j}=tsd((1:length(Data(Restrict(Mov{i},EpochsPOSTWake{i,j}))))/freqVideo*1E4,Data(Restrict(Mov{i},EpochsPOSTWake{i,j})));
        %             end
        %         end
        %
        %     end


