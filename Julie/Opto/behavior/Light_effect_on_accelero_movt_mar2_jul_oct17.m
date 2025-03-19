% Light_effect_on_accelero_behav_mar2_jul_oct17.m.m
% 25.10.2017
% - computes the freezing based on accelero
% - plot the raw individual data (accelero)
% - barplot the freezing level

% A FAIRE
% - Try load the data catch compute the data

% from Light_effect_on_Matlab_behav_feb17.m
% from PSTH_behav_FreezAcctsd_XXX.m 07.03.2017

% remq : dans les .mat 24 et 48 ce sont les mêmes table bilan qui sont sauvées
%% OPTION
rawPlo=0;
rawPlo_indiv=0;
sav=0;
sav_indiv=0;
stepN=2;jour=stepN+4;
% manip_name='Fear-CTRL';
manip_name='Fear_Mar2-July-Oct2017';

StepName={'HABlaser';'EXT-24'; 'EXT-48';'COND';};
StepName2={'HABlaser';'EXT-24h'; 'EXT-48h';'COND';};

%% INTPUTS
if strcmp(manip_name,'Fear-CTRL')

    Dir=PathForExperimentFEAR('Fear-electrophy');
    Dir = RestrictPathForExperiment(Dir,'Group','CTRL');
    mice_included=[244 248 253 254  299 395 402 403 450 451]; % EIB32 -> accelero data available : 231 258 259 excluded
    Dir = RestrictPathForExperiment(Dir,'nMice',mice_included);
    
    Dir = RestrictPathForExperiment(Dir,'Session',StepName2{stepN});
    % 241 242 : pas de EXT-24h classique (24h dans plethysmo,24 apres une EXT-6h
    % 243, 394 : n'ont pas appris (criètre = au moins 10% de freezing pendant les 1ers CS+
    % remove the 2nd session of 244 -24h
    ind244=[];
    for man=1:length(Dir.name)
       ind244=[ind244; strcmp(Dir.name{man},'Mouse244')];
    end
    ind244=find(ind244);
    Dir.path(ind244(2))=[];
    Dir.group(ind244(2))=[];
    Dir.name(ind244(2))=[];
    Dir.manipe(ind244(2))=[];
    Dir.Session(ind244(2))=[];
    Dir.Treatment(ind244(2))=[];
% 
%     gfpmice=[1 3:length(Dir.path)]; %permet d enlever le 2e EXT-24 de 244
    gfpmice=[1:length(Dir.path)]; %
    chr2mice=[];
elseif strcmp(manip_name,'Fear_Mar2-July-Oct2017')

    % march july-oct
    gfpmice=[1 2 3 4 5 6 7 8]; 
    chr2mice=[ 9 10 11 12 13 14 15 16];

%     % selection des souris freezing > 50% à 24h
%     gfpmice=[1 2 3 4 5 6 7 ]; 
%     chr2mice=[ 9 10 11 12 13 15];

    cd /media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/
    res=pwd;
    Dir=PathForExperimentFEAR('Fear-electrophy-opto');
   
    Dir = RestrictPathForExperiment(Dir,'Session',StepName{stepN});

    Dir_gfp = RestrictPathForExperiment(Dir,'Group','GADgfp'); % [498 499 504 505 506 537 610 611]
    Dir_chr2 = RestrictPathForExperiment(Dir,'Group','GADchr2'); % [496 497 540 542 543 612 613 614]
    % EXT 24 : exclusion of 612
    Dir_chr2 = RestrictPathForExperiment(Dir_chr2,'nMice',[496 497 540 542 543 613 614]); % 612
    disp('mouse 612 is exluded')
%     % EXT 48 : exclusion of 611 et 505
%     Dir_gfp = RestrictPathForExperiment(Dir_gfp,'nMice',[498 499 504  506 537 610 ]); % 505 611
%     disp('mouse 611 and 505 exluded')
    
    Dir.path=[Dir_gfp.path, Dir_chr2.path];
    Dir.manipe=[Dir_gfp.manipe, Dir_chr2.manipe];
    Dir.Session=[Dir_gfp.Session, Dir_chr2.Session];
    Dir.group=[Dir_gfp.group, Dir_chr2.group];
    Dir.Treatment=[Dir_gfp.Treatment, Dir_chr2.Treatment];
    Dir.name=[Dir_gfp.name, Dir_chr2.name];
    
    % to remove 497 bof)
    % mice_included=[498 499 504 505 506 537 610 611]; manipname='LaserChR2-fear-MarJulOct17-gfp';
    % mice_included=[496 497 540 542 543 612 613 614]; manipname='LaserChR2-fear-MarJulOct17-chr2';
    %Dir = RestrictPathForExperiment(Dir,'nMice',mice_included);
    
    gfpmice=[1:length(Dir_gfp.name)]; 
    chr2mice=[length(Dir_gfp.name)+1:length(Dir_gfp.name)+length(Dir_chr2.name)];
end

for man=1:length(Dir.path)
    Dir.nb{man}=Dir.name{man}([(end-2):end]);
end
colori=jet(max(length(gfpmice),length(chr2mice)));
%% INITIALIZE
cd(['/media/DataMOBsRAIDN/ProjetAversion/OptoFear/' manip_name]); res=pwd;

try 
    aaa
    load([StepName{stepN} '_' period '_' optionfullper '_acc'], 'bilan','gfpmice','chr2mice','StepName', 'Dir', 'freezeTh','period','bilanMovAccSmotsd','optionfullper')
    
catch
    
    % specify WN/bip group for TTL reading
    CSplu_WN_GpNb=[465 466 496 498 502 504 506 537 540 542 543 610 611 612 613 614];
    for k=1:length(CSplu_WN_GpNb),   CSplu_WN_Gp{k}=num2str(CSplu_WN_GpNb(k)); end; CSplu_WN_Gp=CSplu_WN_Gp';
    CSplu_bip_GpNb=[467 468 497 499 503 505];
    for k=1:length(CSplu_bip_GpNb), CSplu_bip_Gp{k}=num2str(CSplu_bip_GpNb(k));end; CSplu_bip_Gp=CSplu_bip_Gp';
    
    % initialize matrices
    if rawPlo
        rawfig=figure('Position',[ 1922           2        1225         972]);
    end
    PercF=nan(8,length(Dir.path));
    PercF_bef=nan(8,length(Dir.path));
    MovQty_During=nan(8,length(Dir.path));
    MovQty_bef=nan(8,length(Dir.path));
    MovMat=nan(16,length(Dir.path),ceil(105/0.3780));% 105=30sec bef+45 during+30 after / 0.3780=periode enre 2 points de MovAccSmotsd


    % CspluPer3=intervalSet(1117*1e4,1400*1e4); % 3rd block of four CS+
    %  period='fullperiod';
    period='fullperiod'; optionfullper='close2sound';
    % period='fullperiod'; optionfullper='fullblocks';
    % period='soundonly'; optionfullper='';

    for man=1:length(Dir.path)

        ind_mouse=strfind(Dir.path{man},'Mouse-');
        if ~isempty(ind_mouse), m=str2num(Dir.path{man}(ind_mouse+6:ind_mouse+8));
        else
            ind_mouse=strfind(Dir.path{man},'Mouse');
            m=str2num(Dir.path{man}(ind_mouse+5:ind_mouse+7));
        end
        cd(Dir.path{man})
        try 
            load behavResources MovAccSmotsd FreezeAccEpoch 
            MovAccSmotsd;FreezeAccEpoch; 
        catch
            keyboard
        end
        MovAccSmotsd_range=Range(MovAccSmotsd);
        TotEpoch=intervalSet(0,min(MovAccSmotsd_range(end),1420*1E4)); clear MovAccSmotsd_range

        %% recuperer les temps des sons 
        try 
            load behavResources csm csp CSplInt CSmiInt 
            csm; csp; CSplInt; CSmiInt;
        catch
             try
                load behavResources csm csp
                 csm; csp; 
                 CSplInt=intervalSet(csp*1e4,(csp+29)*1e4); % intervals for CS+
                 CSmiInt=intervalSet(csm*1e4,(csm+29)*1e4);
                 save behavResources CSplInt CSmiInt -Append
             catch

                 load behavResources TTL
                DiffTimes=diff(TTL(:,1));
                ind=DiffTimes>2;
                times=TTL(:,1);
                event=TTL(:,2);
                CStimes=times([1; find(ind)+1]);  %temps du premier TTL de chaque s�rie de son
                CSevent=event([1; find(ind)+1]);  %valeur du premier TTL de chaque s�rie de son (CS+ ou CS-)
                % %definir CS+ et CS- selon les groupes
                if ~isempty(strfind(Dir.path{man},'EXT'))||~isempty(strfind(Dir.path{man},'COND'))
                    if sum(strcmp(num2str(m),CSplu_bip_Gp))==1
                        CSpluCode=4; %bip -Append
                        CSminCode=3; %White Noise
                    elseif sum(strcmp(num2str(m),CSplu_WN_Gp))==1
                        CSpluCode=3;
                        CSminCode=4;
                    end
                elseif ~isempty(strfind(Dir.path{man},'HAB'))
                    CSpluCode=3;
                    CSminCode=4;
                end

                CSplu=CStimes(CSevent==CSpluCode);
                CSmin=CStimes(CSevent==CSminCode);

                CSplInt=intervalSet(CSplu*1e4,(CSplu+29)*1e4); % intervals for CS+
                CSmiInt=intervalSet(CSmin*1e4,(CSmin+29)*1e4);

                csp=CSplu;
                csm=CSmin;

                save behavResources csm csp CSplInt CSmiInt -Append

            end
        end

        %% get laser stim interval
        if isempty(strfind(Dir.path{man},'COND')) && ~strcmp('Fear-CTRL', manip_name)
            load behavResources TTL
            sss=TTL(TTL(:,2)==6,1);
            sI=intervalSet(sss(1:end-1)*1E4,sss(2:end)*1E4);
            sI=dropLongIntervals(sI,1*1E4);
            LaserON_beh=mergeCloseIntervals(sI,0.5*1E4);
        end

        NosoundNoLaserPer=intervalSet(0,60*1e4);
        NosoundWithLaserPer=intervalSet(60*1e4,120*1e4);
        NosoundPer=intervalSet(0,120*1e4);
        if ~isempty(strfind(Dir.path{man},'EXT'))
            if strcmp(optionfullper,'fullblocks');
                CsminPer=intervalSet(Start(subset(CSmiInt,1)),Start(subset(CSplInt,1))); % the block of four CS-
                CspluPer0=intervalSet(Start(subset(CSplInt,1)),Start(subset(CSplInt,3))); % CS+ no laser
                CspluPer1=intervalSet(Start(subset(CSplInt,3)),Start(subset(CSplInt,5))); % 1st block of four CS+
                CspluPer2=intervalSet(Start(subset(CSplInt,5)),Start(subset(CSplInt,9))); % 2nd block of four CS+
                CspluPer3=intervalSet(Start(subset(CSplInt,9)),1400*1e4); 
            elseif strcmp(optionfullper,'close2sound');
                CsminPer=intervalSet(Start(subset(CSmiInt,1)),Start(subset(CSplInt,1))); % the block of four CS-
                CspluPer0=intervalSet(Start(subset(CSplInt,1)),End(subset(CSplInt,2))+30*1E4); % CS+ no laser
                CspluPer1=intervalSet(Start(subset(CSplInt,3)),End(subset(CSplInt,4))+30*1E4); % 1st block of four CS+
                CspluPer2=intervalSet(Start(subset(CSplInt,5)),End(subset(CSplInt,8))+30*1E4); % 2nd block of four CS+
                try
                    CspluPer3=intervalSet(Start(subset(CSplInt,9)),End(subset(CSplInt,12))+30*1E4);                
                catch
                    disp([num2str(m) 'one CS+ missing - check'])
                    CspluPer3=intervalSet(Start(subset(CSplInt,9)),End(TotEpoch));          
                end
            end
        else

            CsminPer=intervalSet(122*1e4,408*1e4); % the block of four CS-
            CspluPer0=intervalSet(408*1e4,600*1e4); % 
            CspluPer1=intervalSet(600*1e4,789*1e4); % 1st block of four CS+  % intervalSet(408*1e4,789*1e4);
            CspluPer2=intervalSet(789*1e4,1117*1e4); % 2nd block of four CS+
            CspluPer3=intervalSet(1117*1e4,1400*1e4); % 3rd block of four CS+
        end
        %%
        if rawPlo_indiv
            figure('Position',[121         563        3675         369]), hold on
            % plot accelero
            plot(Range(MovAccSmotsd(1:25:end),'s'),Data(MovAccSmotsd(1:25:end)),'k')
             for k=1:length(Start(FreezeAccEpoch))
                plot(Range(Restrict(MovAccSmotsd(1:25:end),subset(FreezeAccEpoch,k)),'s'),Data(Restrict(MovAccSmotsd(1:25:end),subset(FreezeAccEpoch,k))),'r')
             end
            ylabel(num2str(m))
            if man==1, text(0,1.2,StepName{stepN},'units','normalized'); end
            YL=ylim;
            ylim([-0.1*YL(2) YL(2)])
            
            % plot epochs used for Fz quantification
            aa=0.7;pas=0.05;
            YL=ylim;
            line([Start(NosoundPer)*1E-4 End(NosoundPer)*1E-4],[aa*YL(2) aa*YL(2)],'Color',[0.5 0.5 0.5]);aa=aa+pas;
            line([Start(CsminPer)*1E-4 End(CsminPer)*1E-4],[aa*YL(2) aa*YL(2)],'Color',[0.5 0.5 0.5]); aa=aa+pas;
            line([Start(CspluPer0)*1E-4 End(CspluPer0)*1E-4],[aa*YL(2) aa*YL(2)],'Color',[0.5 0.5 0.5]); aa=aa+pas;
            line([Start(CspluPer1)*1E-4 End(CspluPer1)*1E-4],[aa*YL(2) aa*YL(2)],'Color',[0.5 0.5 0.5]); aa=aa+pas;
            line([Start(CspluPer2)*1E-4 End(CspluPer2)*1E-4],[aa*YL(2) aa*YL(2)],'Color',[0.5 0.5 0.5]); aa=aa+pas;
            line([Start(CspluPer3)*1E-4 End(CspluPer3)*1E-4],[aa*YL(2) aa*YL(2)],'Color',[0.5 0.5 0.5]);aa=aa+pas;
            xlim([0 max(Range(MovAccSmotsd))*1E-4])
            
            % plot quantity of movement 
            load behavResources Movtsd FreezeEpoch
            Movtsd_rescaled=tsd(Range(Movtsd),rescale(Data(Movtsd),YL(1),YL(2)));
            plot(Range(Movtsd,'s'),rescale(Data(Movtsd),YL(1),YL(2)),'Color',[0.5 0.5 0.5]);
            for k=1:length(Start(FreezeEpoch))
                plot(Range(Restrict(Movtsd(1:25:end),subset(FreezeEpoch,k)),'s'),Data(Restrict(Movtsd_rescaled(1:25:end),subset(FreezeEpoch,k))),'c','LineWidth',1)
            end

            % plot freezing epochs, CS and laser
            line([Start(TotEpoch) End(TotEpoch)]'*1E-4,(YL(1)-0.02*YL(2))*ones(size(Start(TotEpoch),1),2)','Color','w','LineWidth',2)
            line([Start(FreezeEpoch) End(FreezeEpoch)]'*1E-4,(YL(1)-0.02*YL(2))*ones(size(Start(FreezeEpoch),1),2)','Color','c','LineWidth',2)
            line([Start(FreezeAccEpoch) End(FreezeAccEpoch)]'*1E-4,(YL(1)-0.02*YL(2))*ones(size(Start(FreezeAccEpoch),1),2)','Color','r','LineWidth',2)
            FzAccAndFreez=and(FreezeAccEpoch,FreezeEpoch);
            line([Start(FzAccAndFreez) End(FzAccAndFreez)]'*1E-4,(YL(1)-0.02*YL(2))*ones(size(Start(FzAccAndFreez),1),2)','Color','b','LineWidth',2)
            
            text(0.02,0.95, 'VideoTracking','Color',[0.5 0.5 0.5],'units','normalized')
            text(0.02,0.9, 'FreezeEpoch','Color','c','units','normalized')
            text(0.02,0.85, 'Accelero','Color','k','units','normalized')
            text(0.02,0.8, 'FreezeAccEpoch','Color','r','units','normalized')
            text(0.02,0.75, 'intersection Fz','Color','b','units','normalized')
            
            ylim('auto')
            YL=ylim;
            if jour>2
                line([csm csm+30]',YL(1)-0.02*YL(2)*ones(size(csm,1),2)','Color','g','LineWidth',2)
                line([csp csp+30]',YL(1)-0.02*YL(2)*ones(size(csp,1),2)','Color',[0 0.7 0],'LineWidth',2)
            end
            if isempty(strfind(Dir.path{man},'COND')) && ~strcmp('Fear-CTRL', manip_name)
                line([Start(LaserON_beh)*1E-4 End(LaserON_beh)*1E-4],[YL(1)-0.04*YL(2) YL(1)-0.04*YL(2)],'Color',[0.4 0.7 1],'LineWidth',2)
            end

                if sav_indiv
                    if ~exist([res '/MovAccFig'],'dir'), mkdir([res '/MovAccFig']); end
                    cd([res '/MovAccFig'])
                    saveas (gcf,['Movacctsd_' num2str(m) '.fig'])
                    saveas (gcf,['Movacctsd_' num2str(m) '.png'])
%                     saveFigure (gcf,['Movacctsd_' num2str(m) ],[res '/MovAccFig'])            
                end
        end


        %% Plot raw individual data
        if rawPlo
            try
            figure(rawfig)
            subplot(length(Dir.path),5,(man-1)*5+[1:3])
             plot(Range(MovAccSmotsd(1:25:end),'s'),Data(MovAccSmotsd(1:25:end)),'k')
                hold on
                for k=1:length(Start(FreezeAccEpoch))
                    plot(Range(Restrict(MovAccSmotsd(1:25:end),subset(FreezeAccEpoch,k)),'s'),Data(Restrict(MovAccSmotsd(1:25:end),subset(FreezeAccEpoch,k))),'c')
                end
                YL=ylim;
                if jour>2
                    line([csp csp+30]',0.6*YL(2)*ones(size(csp,1),2)','Color','b','LineWidth',2)
                    line([csm csm+30]',0.6*YL(2)*ones(size(csm,1),2)','Color','g','LineWidth',2)
                end
                if isempty(strfind(Dir.path{man},'COND')) && ~strcmp('Fear-CTRL', manip_name)
                    line([Start(LaserON_beh)*1E-4 End(LaserON_beh)*1E-4],[0.65*YL(2) 0.65*YL(2)],'Color','c','LineWidth',2)
                end
                                                  
                ylabel(num2str(m))
                if man==1, text(0,1.2,StepName{stepN},'units','normalized'); end
                aa=0.7;pas=0.05;
                %             line([Start(NosoundNoLaserPer)*1E-4 End(NosoundNoLaserPer)*1E-4],[aa aa]);aa=aa+1;
    %             line([Start(NosoundWithLaserPer)*1E-4 End(NosoundWithLaserPer)*1E-4],[aa aa]);aa=aa+1;
                
                line([Start(NosoundPer)*1E-4 End(NosoundPer)*1E-4],[aa*YL(2) aa*YL(2)],'Color',[0.5 0.5 0.5]);aa=aa+pas;
                line([Start(CsminPer)*1E-4 End(CsminPer)*1E-4],[aa*YL(2) aa*YL(2)],'Color',[0.5 0.5 0.5]); aa=aa+pas;
                line([Start(CspluPer0)*1E-4 End(CspluPer0)*1E-4],[aa*YL(2) aa*YL(2)],'Color',[0.5 0.5 0.5]); aa=aa+pas;
                line([Start(CspluPer1)*1E-4 End(CspluPer1)*1E-4],[aa*YL(2) aa*YL(2)],'Color',[0.5 0.5 0.5]); aa=aa+pas;
                line([Start(CspluPer2)*1E-4 End(CspluPer2)*1E-4],[aa*YL(2) aa*YL(2)],'Color',[0.5 0.5 0.5]); aa=aa+pas;
                line([Start(CspluPer3)*1E-4 End(CspluPer3)*1E-4],[aa*YL(2) aa*YL(2)],'Color',[0.5 0.5 0.5]);aa=aa+pas;
                xlim([0 max(Range(MovAccSmotsd))*1E-4])
            catch
                keyboard
            end
        end


        %% Compute freezing time
        bilanMovAccSmotsd{man}=MovAccSmotsd(1:25:end);
        Ep=FreezeAccEpoch;
        if strcmp(period,'fullperiod')
            %percentage of freeing during the different periods (four CS- and each block of four CS+)
            try
                bilan{stepN}(man,:)=[nanmean(Data(Restrict(MovAccSmotsd,NosoundNoLaserPer))),...
                    nanmean(Data(Restrict(MovAccSmotsd,NosoundWithLaserPer))),...
                    nanmean(Data(Restrict(MovAccSmotsd,CsminPer))),...
                    nanmean(Data(Restrict(MovAccSmotsd,CspluPer0))),...
                    nanmean(Data(Restrict(MovAccSmotsd,CspluPer1))),...
                    nanmean(Data(Restrict(MovAccSmotsd,CspluPer2))),...
                   nanmean(Data(Restrict(MovAccSmotsd,CspluPer3)))];
                %                 [length(Data(Restrict(MovAccSmotsd,and(Ep,NosoundPer))))/length(Data(Restrict(MovAccSmotsd,NosoundPer))),...
            catch
                bilan{stepN}(mousenb,:)=NaN(1,4);
                disp(['no  value for M' num2str(m) ' ' StepName{stepN} ])
            end
        elseif strcmp(period,'soundonly')
            keyboard
            if 0
                %percentage of freeing during the different the sounds only (be carefull groupinf different for HAB/COND and EXT)
                % spearation 2 paires de CS- => pas tres utile
            %     sounds1=intervalSet(Start(subset(CSmiInt,[1:2])),Start(subset(CSmiInt,[1:2]))+45*1e4) ;
            %     sounds2=intervalSet(Start(subset(CSmiInt,[3:4])),Start(subset(CSmiInt,[3:4]))+45*1e4) ;%=subset(CSmiInt,[3:4]);
                if ~isempty(strfind(Dir.path{man},'EXT'))
                    sounds1=intervalSet(Start(subset(CSmiInt,[1:4])),Start(subset(CSmiInt,[1:4]))+45*1e4) ;
                    sounds3=intervalSet(Start(subset(CSplInt,[1:2])),Start(subset(CSplInt,[1:2]))+45*1e4) ;%=subset(CSplInt,[1:2]);
                    sounds4=intervalSet(Start(subset(CSplInt,[3:4])),Start(subset(CSplInt,[3:4]))+45*1e4) ;%=subset(CSplInt,[3:4]);       
                    sounds5=intervalSet(Start(subset(CSplInt,[5:8])),Start(subset(CSplInt,[5:8]))+45*1e4) ;%=subset(CSplInt,[5:8]);
                    sounds6=intervalSet(Start(subset(CSplInt,[9:12])),Start(subset(CSplInt,[9:12]))+45*1e4) ;%=subset(CSplInt,[9:12]);
                else 
                    sounds1=intervalSet(Start(subset(CSmiInt,[1:2])),Start(subset(CSmiInt,[1:2]))+45*1e4) ;
                    sounds3=intervalSet(Start(subset(CSplInt,[1:2])),Start(subset(CSplInt,[1:2]))+45*1e4) ;
                    sounds4=intervalSet(Start(subset(CSmiInt,[3:4])),Start(subset(CSmiInt,[3:4]))+45*1e4) ;
                    sounds5=intervalSet(Start(subset(CSplInt,[3:4])),Start(subset(CSplInt,[3:4]))+45*1e4) ;
                    sounds6=intervalSet(0,0) ;%=subset(CSplInt,[9:12]);
                end
                try
                    bilan{stepN}(man,:)=[length(Data(Restrict(MovAccSmotsd,and(Ep,NosoundPer))))/length(Data(Restrict(MovAccSmotsd,NosoundPer))),...
                        length(Data(Restrict(MovAccSmotsd,and(Ep,sounds1))))/length(Data(Restrict(MovAccSmotsd,sounds1))),...
                        length(Data(Restrict(MovAccSmotsd,and(Ep,sounds3))))/length(Data(Restrict(MovAccSmotsd,sounds3))),...
                        length(Data(Restrict(MovAccSmotsd,and(Ep,sounds4))))/length(Data(Restrict(MovAccSmotsd,sounds4))),...
                        length(Data(Restrict(MovAccSmotsd,and(Ep,sounds5))))/length(Data(Restrict(MovAccSmotsd,sounds5))),...
                        length(Data(Restrict(MovAccSmotsd,and(Ep,sounds6))))/length(Data(Restrict(MovAccSmotsd,sounds6)))];
                catch
                    bilan{stepN}(mousenb,:)=NaN(1,4);
                    disp(['no  value for M' num2str(m) ' ' StepName{stepN} ])
                end
            end
        end



        clear MovAccSmotsd csm csp CSplInt CSmiInt FreezeAccEpoch
    end
end
if rawPlo
    cd(res)
    try
        temp=load([StepName{stepN} '_' period  '_' optionfullper],'bilan');
        bilan2=temp.bilan;
    catch
        bilan2=bilan;
    end
    for man=1:length(Dir.path)
        figure(rawfig)
        subplot(length(Dir.path),5,(man-1)*5+4)
        bar(bilan{stepN}(man,:)), hold on %hold off
        if man==1,title(period),end
        if ~isempty(strfind(Dir.path{man},'EXT'))
            ylabel([optionfullper])
        end
%         abscis=[4 5 6];
%         line([abscis-0.4;abscis+0.4]',[0 0],'Color','c','LineWidth',2); 
%         abscis=[2];
%         line([abscis-0.4;abscis+0.4]',[0 0],'Color','g','LineWidth',2); 
        
%         subplot(length(Dir.path),5,(man-1)*5+5)
%         bar(bilan2{stepN}(man,:)), hold on
%         abscis=[3];
%         line([abscis-0.4;abscis+0.4]',[0 0],'Color','b','LineWidth',2); 
%         abscis=[4 5 6 ];
%         line([abscis-0.4;abscis+0.4]',[0 0],'Color','c','LineWidth',2); 
%         abscis=[2 ];
%         line([abscis-0.4;abscis+0.4],[0 0],'Color','g','LineWidth',2); 
%         if man==1,title('sound only'),end
set(gca,'XTickLabel',{'o';'-';'+';'+l';'+l';'+l';}), 
%ylim([0 1  ])

    end
end


cd(res)
res=pwd;
if sav & rawPlo
saveas(rawfig,[StepName{stepN} '_' period '_' optionfullper '_raw_acc.fig'])
try
    saveFigure(rawfig,[StepName{stepN} '_' period '_' optionfullper '_raw_acc'],res)
end
end
if sav
    cd(res)
    save([StepName{stepN} '_' period '_' optionfullper '_acc'], 'bilan','gfpmice','chr2mice','StepName', 'Dir','period','bilanMovAccSmotsd','optionfullper')
end

%% Barplot bilan
figure ('Position',[ 287         517       1792         312])
n=4; k=1;colCSplu=1; colCSpluLas=2;
% Chr2 mice
if ~strcmp(manip_name, 'Fear-CTRL');
    subplot(1,n,k), k=k+1; hold on
    % lines present 2X : trick for legend plotting
    for man=1:size(bilan{stepN}(chr2mice,:),1)
            plot(bilan{stepN}(chr2mice(man),:),'Color',colori(man,:),'Marker','o','MarkerSize',3,'MarkerEdgeColor',colori(man,:),'MarkerFaceColor',colori(man,:))
    end
    PlotErrorBarN(bilan{stepN}(chr2mice,:),0,1,'ranksum',colCSplu) % newfig=0; paired=1,columntest=2
    for man=1:size(bilan{stepN}(chr2mice,:),1)
            plot(bilan{stepN}(chr2mice(man),:),'Color',colori(man,:),'Marker','o','MarkerSize',3,'MarkerEdgeColor',colori(man,:),'MarkerFaceColor',colori(man,:))
    end
%     ylim([0 1]), 
    title('ChR2')
    text(-0.2,1.05,[period],'units','normalized')
    if ~isempty(strfind(Dir.path{man},'EXT'))
        ylabel([StepName{stepN} ' ' optionfullper 'Movt acc'])
    end
    [p4_ch, h, stats]=signrank(bilan{stepN}(chr2mice,colCSplu), bilan{stepN}(chr2mice,colCSpluLas));
    xlabel([ 'p ' sprintf('%0.3f',p4_ch) ])
end
legend(Dir.nb{chr2mice},'Location','bestoutside')


% GFP mice
subplot(1,n,k), k=k+1;hold on
for man=1:size(bilan{stepN}(gfpmice,:),1)
        plot(bilan{stepN}(gfpmice(man),:),'Color',colori(man,:),'Marker','o','MarkerSize',3,'MarkerEdgeColor',colori(man,:),'MarkerFaceColor',colori(man,:))
end
PlotErrorBarN(bilan{stepN}(gfpmice,:),0,1,'ranksum',colCSplu)
for man=1:size(bilan{stepN}(gfpmice,:),1)
        plot(bilan{stepN}(gfpmice(man),:),'Color',colori(man,:),'Marker','o','MarkerSize',3,'MarkerEdgeColor',colori(man,:),'MarkerFaceColor',colori(man,:))
end
legend(Dir.nb{gfpmice},'Location','bestoutside')
[p4_gf, h, stats]=signrank(bilan{stepN}(gfpmice,colCSplu), bilan{stepN}(gfpmice,colCSpluLas));
xlabel([ 'p ' sprintf('%0.3f',p4_gf) ])
% ylim([0 1]), 
title('GFP')

% Comparative GFP-ChR2
if ~strcmp(manip_name, 'Fear-CTRL');
    
    subplot(1,n,k), k=k+1;
    %bar([nanmean(bilan{stepN}(chr2mice,:),1); nanmean(bilan{stepN}(gfpmice,:),1)]')
    % ylim([0 1]), legend('ChR2','GFP')
    % [p3_gfp, h, stats]=signrank(bilan{stepN}(gfpmice,colCSplu), bilan{stepN}(gfpmice,colCSpluLas));
    % xlabel([ 'p ' sprintf('%0.3f',p3_gfp) ]);
    % title( StepName{stepN})
    % [p2, h, stats]=ranksum(bilan{stepN}(chr2mice,colCSplu), bilan{stepN}(gfpmice,colCSplu));
    % [p3, h, stats]=ranksum(bilan{stepN}(chr2mice,colCSplu), bilan{stepN}(gfpmice,colCSplu));
    % [p4, h, stats]=ranksum(bilan{stepN}(chr2mice,colCSpluLas), bilan{stepN}(gfpmice,colCSpluLas));
    % xlabel([ 'p3 ' sprintf('%0.3f',p3)  '  p4 ' sprintf('%0.3f',p4) ])


    Table{1,1}=bilan{stepN}(chr2mice,:);
    Table{1,2}=bilan{stepN}(gfpmice,:);
    BarPlotBulbSham_gen(Table,[StepName{stepN} '_acc'],{[0.5 0 0],[0 0 0.5]},'ranksum',1,4,3,'indivdots',0)
    legend(['chr2 -' num2str(length(chr2mice))],['gfp -' num2str(length(gfpmice))])
%     ylim([0 1])
    
     values_for_ANOVA=[bilan{stepN}(chr2mice,[colCSplu colCSpluLas]); bilan{stepN}(gfpmice,[colCSplu colCSpluLas])];
    gpF=[ones(length(chr2mice),2);zeros(length(gfpmice),2)];
    sesF=[ones(length([chr2mice gfpmice]),1) zeros(length([chr2mice gfpmice]),1)];
    [p_an,table_an,stats_an] = anovan(values_for_ANOVA(:),{sesF(:) gpF(:)},'model' ,'interaction', 'display', 'off');
    text(0.05,0.95,[ 'P_s_e_s ' sprintf('%0.3f',p_an(1)) ' P_g_p ' sprintf('%0.3f',p_an(2)) ' P_i_n_t ' sprintf('%0.3f',p_an(3)) ],'FontSize',8,'units','normalized')
    
    if 0
        for sp=1:3
            subplot(1,n,sp), hold on
            abscis=[2 ];
            line([abscis-0.4;abscis+0.4],[0 0],'Color','g','LineWidth',2); 
            abscis=[3];
            line([abscis-0.4;abscis+0.4]',[0 0],'Color','b','LineWidth',2); 
            abscis=[4 5 6 ];
            line([abscis-0.4;abscis+0.4]',[0 0],'Color','c','LineWidth',2); 

        end
    end
    % modulation index % cla
    subplot(1,n,k), k=k+1;
    MI_chr2=(bilan{stepN}(chr2mice,colCSpluLas)-bilan{stepN}(chr2mice,colCSplu))./(bilan{stepN}(chr2mice,colCSpluLas) + bilan{stepN}(chr2mice,colCSplu));
    MI_gfp=(bilan{stepN}(gfpmice,colCSpluLas)-bilan{stepN}(gfpmice,colCSplu))./(bilan{stepN}(gfpmice,colCSpluLas) + bilan{stepN}(gfpmice,colCSplu));
    plotSpread({MI_gfp,MI_chr2},'showMM',1);

    [p_ratio_gfp, h, stats]=ranksum(MI_chr2,MI_gfp);
    title('Mod Index'),set(gca,'XtickLabel',{'gfp','chR2','ctrl'});
    ylim([-1 1])
    xlabel([ 'p ' sprintf('%0.3f',p_ratio_gfp)  ])
    line([0 3],[0 0],'LineStyle','--','Color',[0.5 0.5 0.5])
    ylabel(['(' num2str(colCSpluLas) ' - ' num2str(colCSplu) ') / (' num2str(colCSpluLas) ' + ' num2str(colCSplu) ')'])
    ylim('auto')
    YL=ylim;
    ylim([-max(abs(YL(1)),abs(YL(2))) max(abs(YL(1)),abs(YL(2)))])
    text(0.05,0.95,'+Fz with laser','units','normalized')
    text(0.05,0.05,'+Fz no laser','units','normalized')
    
   
    
end 


if sav
    cd(res)
    saveas (gcf,[StepName{stepN} '_' period '_' optionfullper 'mean_accMovt.fig'])
    saveas (gcf,[StepName{stepN} '_' period '_' optionfullper 'mean_accMovt.png'])
    save([manip_name '_' StepName{stepN} 'mean_accMovt'],'Dir','bilan','gfpmice','chr2mice','StepName','period','optionfullper');% 'Table'
    saveFigure(gcf,[StepName{stepN} '_' period '_' optionfullper 'mean_accMovt'],res)
end



