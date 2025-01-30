% CodeBulbML

%% INITIALISATION

PloVerif=1;

res=pwd;
warning off

nameEpoch={'REM' 'SWS' 'Wake'};
%nameEpoch={'Wake'};

supposednameLFPA={'LFPbulb' 'LFPCx' 'EEGCx' 'LFPpfc' 'EEGpfc'};
Manipe='Dpcpx';
%Manipe='Vehicul';
%Manipe='Basal';


Nultsd=tsd([],[]);
%% ------------------------------------------------------------------------
% ---------------------- Directories --------------------------------------
% -------------------------------------------------------------------------


disp('----------------------')
disp(['---- Manipe ',Manipe,' ----'])

try
    load([res,'/AnalyBulb',Manipe,'.mat'])
    Dir.path;
    Dir.group;
catch
    if strcmp(Manipe,'Dpcpx')
        Dir.path{1}='/media/Nouveau nom/ProjetBulbe/Mouse051/20121106/BULB-Mouse-51-06112012';
        Dir.path{2}='/media/Nouveau nom/ProjetBulbe/Mouse047/20121108/DPCPX/BULB-Mouse-47-08112012';
        Dir.path{3}='/media/Nouveau nom/ProjetBulbe/Mouse052/20121114/BULB-Mouse-52-14112012';
    elseif strcmp(Manipe,'Vehicul')
        Dir.path{1}='/media/Nouveau nom/ProjetBulbe/Mouse051/20121109/BULB-Mouse-51-09112012';
        Dir.path{2}='/media/Nouveau nom/ProjetBulbe/Mouse047/20121112/DpcpxCTRL/BULB-Mouse-47-12112012';
        Dir.path{3}='/media/Nouveau nom/ProjetBulbe/Mouse052/20121116/BULB-Mouse-52-16112012';
    elseif strcmp(Manipe,'Basal')
        Dir.path{1}='/media/Nouveau nom/ProjetBulbe/Mouse051/20121017/BULB-Mouse-51-17102012';
        Dir.path{2}='/media/Nouveau nom/ProjetBulbe/Mouse047/20121012/BULB-Mouse-47-12102012';
        Dir.path{3}='/media/Nouveau nom/ProjetBulbe/Mouse052/20121113/BULB-Mouse-52-13112012';
    end
    Dir.group={'WT' 'KO' 'KO'};
    save([res,'/AnalyBulb',Manipe,'.mat'],'-v7.3','Dir')
end





%% ------------------------------------------------------------------------
% --------------------------- LFPA ----------------------------------------
% -------------------------------------------------------------------------
% LFPA corresponds to a tsd array
% in each row: LFPbulb LFPCx EEGCxb LFPpfc EEGpfc


disp(' ')
disp('... LFPA')


try 
    %load([res,'/AnalyBulb',Manipe,'.mat'])
    LFPA;
    createLFPA=input('LFPA exists. Do you want to create a new one (y/n)? ','s');
catch
    LFPA=tsdArray;
    Nultsd=tsd([],[]);
    createLFPA='y';
end


if  createLFPA=='y'
    
    try
        ChannelBulb;
    catch
        ChannelBulb=input('Enter one channel for Bulb LFP (1 to 8) : ');
        %ChannelBulb=4;   
        
        save([res,'/AnalyBulb',Manipe,'.mat'],'ChannelBulb','-append');
    end
    
    for i=1:length(Dir.path)
        
        eval(['cd(''',Dir.path{i},''')']);
        disp(['   ',Dir.path{i}(end-21:end)]);
        for j=1:length(supposednameLFPA)
            LFPA{i,j}=Nultsd;
        end
        
        clear info LFP
        % ---------------
        % ---- BULBE ----

        load('LFPBulb.mat');
        LFPA{i,1}=LFP{ChannelBulb(1)};
        nameLFPA{i,1}=['LFP Bulb ',num2str(ChannelBulb)];
        
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
            LFPA{i,2}=LFP{temp(1)};
            nameLFPA(i,2)={'LFP PaCx'};
            temp=find(info.depth<=0);
            LFPA{i,3}=LFP{temp(1)};
            nameLFPA(i,3)={'EEG PaCx'};
        catch
            clear LFP
            % -- AuCx --
            disp('      Failed to find EEG/EcoG and LFP for PaCx, trying AuCx')
            load('LFPAuCx.mat');
            temp=find(info.depth>0);
            try
                LFPA{i,2}=LFP{temp(1)};
                nameLFPA(i,2)={'LFP AuCx'};
            catch
                disp('      no LFP for AuCx, staying with PaCx')
            end
            temp=find(info.depth<=0);
            try
                LFPA{i,3}=LFP{temp(1)};
                nameLFPA(i,3)={'EEG AuCx'};
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
            LFPA{i,4}=LFP{temp(1)};
            nameLFPA{i,4}='LFP PFCx';
        catch
            disp('      No LFP PFCx')    
        end
        try
            temp=find(info.depth<=0);
            LFPA{i,5}=LFP{temp(1)};
            nameLFPA{i,5}='EEG PFCx';
        catch
            disp('      No EEG/EcoG PFCx')
        end
        
    end
    
    
    
    for i=1:size(nameLFPA,1)
        for j=1:size(nameLFPA,2)
            try 
                nameLFPA{i,j}(1);
            catch
                nameLFPA{i,j}='';
            end
        end
    end
    
    save([res,'/AnalyBulb',Manipe,'.mat'],'LFPA','nameLFPA','-append')
     
end
disp('Done.')





%% ------------------------------------------------------------------------
% ----------------------- Delta Spindles Ripples --------------------------
% -------------------------------------------------------------------------

disp(' ')
disp('... DELTA - SPINDLES - RIPPLES')

try
    %load([res,'/AnalyBulb',Manipe,'.mat'])
    Dt; Dp; Spn; Ri;

catch
    
    Dt=tsdArray; Dp=tsdArray; Spn=tsdArray; Ri=tsdArray;
    
    for i=1:size(LFPA,1)
        
        clear LFPAtemp
        LFPAtemp=LFPA(i,:);
        
        disp(' ')
        disp(['   ',Dir.path{i}(end-21:end)]);

        [Dti,Dpi,Spni,Rii]=IdentifyDeltaSpindlesRipples(LFPAtemp,2,3,8000,0);
        Dt{i}=Dti; Dp{i}=Dpi; Spn{i}=Spni; Ri{i}=Rii;
        
        
    end
    save([res,'/AnalyBulb',Manipe,'.mat'],'Dt','Dp','Spn','Ri','-append')    
    
end


% //////////////////////// VERIF ///////////////////////////////
% LFPA & Delta-Spindles-Ripples
if PloVerif
    disp('Verification LFPA & Delta-Spindles-Ripples')
    color={'g','b','c','r','m'};
    scrsz = get(0,'ScreenSize');
    for i=1:size(LFPA,1)
        
        figure('color',[1 1 1],'Position',[2 scrsz(4) scrsz(3) scrsz(4)/3]), hold on,
        
        tempRange=sort([Range(Dt{i},'s');Range(Dp{i},'s');Range(Spn{i},'s')]);
        ttTemp=0;
        for tt=1:length(tempRange)
            Itemp=intervalSet(max(0,(tempRange(tt)-1)*1E4),(tempRange(tt)+1)*1E4);
            if tempRange(tt)>ttTemp+1
                ttTemp=tempRange(tt);
                
                ileg=[];
                for j=1:size(LFPA,2)
                    try  plot(Range(Restrict(LFPA{i,j},Itemp),'s'),(j-1)*5E3+ Data(Restrict(LFPA{i,j},Itemp)),color{j}); ileg=[ileg,j];hold on; end
                end
                title([Dir.path{i}(end-16:end),' - Delta though (red) and picks (magenta), Spindles (blue)'])
                legend(nameLFPA{i,ileg})
                try line([Range(Restrict(Dt{i},Itemp),'s') Range(Restrict(Dt{i},Itemp),'s')],[-3E4 3E4],'color','r','linewidth',2);end
                try line([Range(Restrict(Dp{i},Itemp),'s') Range(Restrict(Dp{i},Itemp),'s')],[-3E4 3E4],'color','m','linewidth',2);end
                try line([Range(Restrict(Spn{i},Itemp),'s') Range(Restrict(Spn{i},Itemp),'s')],[-3E4 3E4],'color','b','linewidth',2);end
                xlim([tempRange(tt)-1 tempRange(tt)+1]);ylim([-3*1E4 3*1E4])
                pause(1); 
                hold off,
            end
        end
    end
end

% /////////////////////////////////////////////////////////////////
    
disp('Done.')



%% ------------------------------------------------------------------------
% ----------------------------- SPECTROGRAM -------------------------------
%--------------------------------------------------------------------------

disp(' ')
disp('... Spectrogram')


params.Fs=1250;
params.trialave=0;
params.err=[1 0.0500];
params.pad=2;
params.fpass=[0 30];
%params.tapers=[1 2];
movingwin=[3 0.2];
params.tapers=[3 5];


try
    Sp;t;f;
catch
    Sp=tsdArray;t=tsdArray;f=tsdArray;
    
    for  i=1:size(LFPA,1)
        disp(' ')
        disp(['   ',Dir.path{i}(end-16:end)]);
        
        [Spi,ti,fi]=mtspecgramc(Data(LFPA{i,1}),movingwin,params);
        Sp{i}=Spi;t{i}=ti;f{i}=fi;
    end
    
    save([res,'/AnalyBulb',Manipe,'.mat'],'Sp','t','f','-append') 
    
end
disp('Done.')



%% ------------------------------------------------------------------------
% ---------------------------- Tracking -----------------------------------
% -------------------------------------------------------------------------

disp(' ')
disp('... Tracking')
try
    Mm;
catch
    Mm=tsdArray;
    for i=1:length(Dir.path)
        
        eval(['cd(''',Dir.path{i},''')']);
        disp(['   ',Dir.path{i}(end-21:end)]);
        clear Movtsd
        try
            load('behavResources.mat')       
            Mm{i}=Movtsd; 
        catch
            disp(['Problem Tracking ',Dir.path{i}(end-21:end)])
        end
    end
    save([res,'/AnalyBulb',Manipe,'.mat'],'Mm','-append')    
    
end


%% ------------------------------------------------------------------------
% ------------------------------ Epochs -----------------------------------
% -------------------------------------------------------------------------
% Epochs corresponds to an array of IntervalSet
% in each row: StateEpoch PreEpoch PostEpoch

disp(' ')
disp('... EPOCHS')

for nn=1:length(nameEpoch)
    disp(['-- ',nameEpoch{nn},' --']);
    clear InjectionTime EpochsPOST EpochsPRE
    try
        load([res,'/AnalyBulb',Manipe,nameEpoch{nn},'.mat'])
        EpochsPRE;
        EpochsPOST;
        InjectionTime;
        if strcmp(nameEpoch{nn},'Wake')
            EpochsPREWake;
            EpochsPOSTWake;
        end
    catch

        for i=1:length(Dir.path)
            
            eval(['cd(''',Dir.path{i},''')']);
            disp(['   ',Dir.path{i}(end-21:end)]);
            
            clear epoch ThetaEpoch
            load('StateEpoch.mat')
            try
                eval(['epoch=',nameEpoch{nn},'Epoch;']);
                ThetaEpoch;
            catch
                disp(['problem with ',nameEpoch{nn},'Epoch of ',Dir.path{i}(end-21:end)])
            end
            
            
            
            % /////////////////////////////////////////////////////////////////
            %         add PRE/POST injection epochs if not existing
            clear  PreEpoch PostEpoch 
            try
                load('behavResources.mat')
                PreEpoch;
                PostEpoch;

            catch
                StartPre=[];             StopPre=[];
                StartPost=[];            StopPost=[];
                for ll=1:length(namePos)
                    if isempty(strfind(namePos{ll},'POST'))
                        StartPre=[StartPre;tpsdeb{ll}*1E4];
                        StopPre=[StopPre;tpsfin{ll}*1E4];
                        
                    elseif isempty(strfind(namePos{ll},'POST'))==0
                        StartPost=[StartPost;tpsdeb{ll}*1E4];
                        StopPost=[StopPost;tpsfin{ll}*1E4];
                    end
                end
                
                PreEpoch=intervalSet(StartPre,StopPre);
                PostEpoch=intervalSet(StartPost,StopPost);
                save('behavResources','PostEpoch','PreEpoch','-append')
            end
            % /////////////////////////////////////////////////////////////////
            
            
            
            EpochsPRE{i}=and(PreEpoch,epoch);
            EpochsPOST{i}=and(PostEpoch,epoch);
            InjectionTime{i}=min(Start(PostEpoch,'s'));
            
            

            if strcmp(nameEpoch{nn},'Wake')
                % theta Epoch
                EpochsPREWake{i,1}=and(and(PreEpoch,epoch),ThetaEpoch);
                EpochsPOSTWake{i,1}=and(and(PostEpoch,epoch),ThetaEpoch);
                
                MovTh(i)=5;
                Ok='n';
                while Ok~='y'
                    
                    ActiveEpoch=thresholdIntervals(Mm{i},MovTh(i)+1,'Direction','Above');
                    ActiveEpoch=mergeCloseIntervals(ActiveEpoch,5*1E4);
                    ActiveEpoch=dropShortIntervals(ActiveEpoch,3*1E4);
                    
                    StealEpoch=thresholdIntervals(Mm{i},MovTh(i)-1,'Direction','Below');
                    StealEpoch=mergeCloseIntervals(StealEpoch,5*1E4);
                    StealEpoch=dropShortIntervals(StealEpoch,3*1E4);
                    
                    figure('color',[1 1 1]),
                    plot(Range(Mm{i},'s'),Data(Mm{i})); ylim([0 10])
                    hold on, plot(Range(Restrict(Mm{i},and(ActiveEpoch,epoch)),'s'),Data(Restrict(Mm{i},and(ActiveEpoch,epoch))),'g')
                    hold on, plot(Range(Restrict(Mm{i},and(StealEpoch,epoch)),'s'),Data(Restrict(Mm{i},and(StealEpoch,epoch))),'r');
                    title('Movement period (green) and steal period (Red)')
                    
                    Ok=input('--- Are you satisfied with the Movement/steal Epoch of Wake period (y/n) ? ','s');
                    if Ok=='n', MovTh(i)=input('Give a new threshold for movement (default=5) : ');end
                    close
                end
                
                % Movement Epoch
                EpochsPREWake{i,2}=and(and(PreEpoch,epoch),ActiveEpoch);
                EpochsPOSTWake{i,2}=and(and(PostEpoch,epoch),ActiveEpoch);
                
                % Steal Epoch
                EpochsPREWake{i,3}=and(and(PreEpoch,epoch),StealEpoch);
                EpochsPOSTWake{i,3}=and(and(PostEpoch,epoch),StealEpoch);
            end
            
            
        end
        save([res,'/AnalyBulb',Manipe,nameEpoch{nn},'.mat'],'EpochsPRE','EpochsPOST','InjectionTime')
        %save([res,'/AnalyBulb',Manipe,nameEpoch{nn},'.mat'],'EpochsPRE','EpochsPOST','InjectionTime','-append')
        if strcmp(nameEpoch{nn},'Wake'), save([res,'/AnalyBulb',Manipe,nameEpoch{nn},'.mat'],'EpochsPREWake','EpochsPOSTWake','MovTh','-append'), end    
    end
end   
% ///////////////////////// VERIF //////////////////////////////////
% spectro & Tracking & Epochs
if PloVerif
    disp('Verification spectro & Tracking & Epochs...')
    color={'c' 'r' 'm'};
    for i=1:size(LFPA,1)
        figure('color',[1 1 1]), hold on,        
        for nn=1:length(nameEpoch)
            clear InjectionTime EpochsPOST EpochsPRE
            load([res,'/AnalyBulb',Manipe,nameEpoch{nn},'.mat'])
            try
                imagesc(t{i},f{i},10*log10(Sp{i}')), axis xy, caxis([20 70])
                plot(Range(Restrict(Mm{i},EpochsPRE{i}),'s'),15+Data(Restrict(Mm{i},EpochsPRE{i})),'b')
                plot(Range(Restrict(Mm{i},EpochsPOST{i}),'s'),15+Data(Restrict(Mm{i},EpochsPOST{i})),'g')
                
                try line([InjectionTime{i} InjectionTime{i}],[0 10],'color','r','linewidth',3);end
                title([Dir.path{i}(end-16:end-9),' - ',Dir.group{i},' - EpochPRE(blue) - EpochPOST(green) ,',nameEpoch{nn}])
                
                if strcmp(nameEpoch{nn},'Wake')
                    for j=1:3
                        plot(Range(Restrict(Mm{i},EpochsPREWake{i,j}),'s'),15+Data(Restrict(Mm{i},EpochsPREWake{i,j})),color{j})
                        plot(Range(Restrict(Mm{i},EpochsPOSTWake{i,j}),'s'),15+Data(Restrict(Mm{i},EpochsPOSTWake{i,j})),color{j})
                    end
                    title([Dir.path{i}(end-16:end-9),' - ',Dir.group{i},' - Theta(cyan) Movement(red) Steal(magenta), ',nameEpoch{nn}])
                end
            catch
                disp(['problem ',Dir.path{i}(end-16:end-9),', ',nameEpoch{nn}])
            end
        end
        ylim([0 30])
    end
end
% /////////////////////////////////////////////////////////////////

disp('Done.')





%% ------------------------------------------------------------------------
% -------------------------- ImagePETH Delta ------------------------------
% -------------------------------------------------------------------------
disp(' ')
disp('... DELTA')

for nn=1:length(nameEpoch)
    disp(['-- ',nameEpoch{nn},' --']);
    
    clear matDppre matDppost
    try
        load([res,'/AnalyBulb',Manipe,nameEpoch{nn},'.mat'])
        matDppre; matDppost;
        
    catch
        matDppre=tsdArray; matDppost=tsdArray;
        
        for  i=1:size(LFPA,1)
            
            disp(' ')
            disp(['   ',Dir.path{i}(end-16:end)]);
            
            disp(['Length PreEpoch: ',num2str(floor(sum(Stop(EpochsPRE{i},'s')-Start(EpochsPRE{i},'s')))),'s'])
            disp(['Length PostEpoch: ',num2str(floor(sum(Stop(EpochsPOST{i},'s')-Start(EpochsPOST{i},'s')))),'s'])
            
            for j=1:length(supposednameLFPA) % Ctx (2,3); PFC (4,5)
                
                % --- PRE ---
                try
                    figure, [fh, rasterAx, histAx, matVal] = ImagePETH(LFPA{i,j}, Restrict(Dp{i},EpochsPRE{i}), -15000, +15000,'BinSize',500);close
                    matDppre{i,j}=matVal;
                catch
                    disp(['      Problem with ImagePETH Delta of ',supposednameLFPA{j},' PRE']);
                    close
                end
                
                if isempty(start(EpochsPOST{i}))==0
                    
                    % --- POST ---
                    try
                        figure, [fh, rasterAx, histAx, matVal] = ImagePETH(LFPA{i,j}, Restrict(Dp{i},EpochsPOST{i}), -15000, +15000,'BinSize',500);close
                        matDppost{i,j}=matVal;
                    catch
                        disp(['      Problem with ImagePETH Delta of ',supposednameLFPA{j},' POST']);
                        close
                    end
                end
                
            end
        end
        save([res,'/AnalyBulb',Manipe,nameEpoch{nn},'.mat'],'matDppre','matDppost','-append')
    end
end 
disp('Done.')
    
  
    
%% ------------------------------------------------------------------------
% ------------------------ ImagePETH Spindles -----------------------------
% -------------------------------------------------------------------------
disp(' ')
disp('... SPINDLES')

for nn=1:length(nameEpoch)
    disp(['-- ',nameEpoch{nn},' --']);
    
    clear matSppre matSppost
    try
        load([res,'/AnalyBulb',Manipe,nameEpoch{nn},'.mat'])
        matSppre; matSppost;
        
    catch
        matSppre=tsdArray; matSppost=tsdArray;
        
        for  i=1:size(LFPA,1)
            disp(' ')
            disp(['   ',Dir.path{i}(end-16:end)]);
            
            for j=1:length(supposednameLFPA) % Ctx (2,3); PFC (4,5)
                
                % --- PRE ---
                try
                    figure, [fh, rasterAx, histAx, matVal] = ImagePETH(LFPA{i,j}, Restrict(Spn{i},EpochsPRE{i}), -15000, +15000,'BinSize',500);close
                    matSppre{i,j}=matVal;
                catch
                    disp(['      Problem with ImagePETH Spindles of ',supposednameLFPA{j},' PRE']);
                    close
                end
                
                if isempty(start(EpochsPOST{i}))==0
                    % --- POST ---
                    try
                        figure, [fh, rasterAx, histAx, matVal] = ImagePETH(LFPA{i,j}, Restrict(Spn{i},EpochsPOST{i}), -15000, +15000,'BinSize',500);close
                        matSppost{i,j}=matVal;
                    catch
                        disp(['      Problem with ImagePETH Spindles of ',supposednameLFPA{j},' POST']);
                        close
                    end
                end
                
            end
        end
        
        save([res,'/AnalyBulb',Manipe,nameEpoch{nn},'.mat'],'matSppre','matSppost','-append')
    end
end    
disp('Done.')

%% termination

cd(res);

% figure, plot(Range(LFPAtemp{1},'s'),Data(LFPAtemp{1}))
% [Dt,Dp,Sp,Ri]=IdentifyDeltaSpindlesRipples(Restrict(LFPAtemp,EpochsPRE{iWT}),1,[],3*1E4,1);
% figure, [fh, rasterAx, histAx, matVal] = ImagePETH(LFPAtemp{1}, Sp, -25000, +25000,'BinSize',500)
% figure, [fh, rasterAx, histAx, matVal] = ImagePETH(LFPAtemp{4}, Sp, -25000, +25000,'BinSize',500)
% figure, imagesc(Data(matVal)'), axis xy
% test=Data(matVal)';
% C=corrceof(test);
% C=corrcoef(test);
% figure, iamgesc(C)
% figure, imagesc(C)
% C=corrcoef(test');
% figure, imagesc(C)
% size(test)
% figure, imagesc(test)
% C(isnan(C))=0
% C(isnan(C))=0;
% [V,L]=pcacov(C);
% [BE,id]=sort(V(:,1));
% figure, imagesc(test(id,:))
% size(id)
% size(test)
% figure, imagesc(SmoothDec(test(id,:),[1,1])
% figure, imagesc(SmoothDec(test(id,:),[1,1]))
% figure, imagesc(test)
% figure, imagesc(test(id,:))
% figure, plot(mean(test)
% figure, plot(mean(test))
% figure, plot(mean(test'))
% figure, plot(mean(test(id(1:20,:)'))
% figure, plot(mean(test(id(1:20,:)')))
% figure, plot(mean(test(id(1:20,:))'))
% figure, plot(mean(test(id(1:20),:)'))
% figure, plot(mean(test(id(1:20),:)))
% figure, plot(mean(test(id(end-20:end),:)))
% figure, plot(mean(test(id(1:20),:)))
% hold on, plot(mean(test(id(end-20:end),:)),'r')
% hold on, plot(mean(test(id(1:end),:)),'k')
% figure, plot(mean(test(id(1:50),:)))
% hold on, plot(mean(test(id(end-50:end),:)),'r')
% hold on, plot(mean(test(id(1:end),:)),'k')
% close all
% C=corrcoef(test(:,500:1500)');
% figure, imagesc(test)
% C=corrcoef(test(:,2500:3500)');
% [V,L]=pcacov(C);
% [BE,id]=sort(V(:,1));
% figure, plot(L,'-o')
% figure, imagesc(test(id,:))
% [BE,id]=sort(V(:,2));
% figure, imagesc(test(id,:))
% [BE,id]=sort(V(:,3));
% figure, imagesc(test(id,:))
% figure, imagesc(SmoothDec(test(id,:),[1,1]))
% spind=Range(Sp);
% figure, [fh, rasterAx, histAx, matVal] = ImagePETH(LFPAtemp{1}, ts(spind(id(1:20))), -25000, +25000,'BinSize',500)
% figure, [fh, rasterAx, histAx, matVal] = ImagePETH(LFPAtemp{1}, ts(sort(spind(id(1:20)))), -25000, +25000,'BinSize',500)
% figure, [fh, rasterAx, histAx, matVal] = ImagePETH(LFPAtemp{1}, ts(sort(spind(id(end-20:end)))), -25000, +25000,'BinSize',500)

