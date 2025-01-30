% Light_effect_on_Matlab_behav_mar2_jul_oct17.m.m
% 10.03.2017
% crude code to see effect quickly (uses matlab tracking which is sensitive
% to video trcking artifacts)

% Light_effect_on_Matlab_behav_feb17.m
% from PSTH_behav_FreezAcctsd_XXX.m
% 07.03.2017

% aims at showing the behavioral effect of light uses Matlab tracking data (but tracking artefacts due to cables on HAB envC (jour=1)

% remq : dans les .mat 24 et 48 ce sont les mêmes table bilan qui sont
% sauvées
%% OPTION
rawPlo=0;
sav=0;
jour=6;
% manip_name='Fear-CTRL';
manip_name='Fear_Mar2-July-Oct2017';%manip_name='Fear-Oct2017';%manip_name='Fear_July2017';

StepName={'HABlaser';'EXT-24'; 'EXT-48';'COND';};
StepName2={'HABlaser';'EXT-24h'; 'EXT-48h';'COND';};

%% INTPUTS
if strcmp(manip_name,'Fear-CTRL')
    stepN=jour-4;
    Dir=PathForExperimentFEAR('Fear-electrophy');
    Dir = RestrictPathForExperiment(Dir,'Group','CTRL');
    Dir = RestrictPathForExperiment(Dir,'nMice',[231 244 248 253 254 258 259 299 395 402 403 450 451]); 
    
    Dir = RestrictPathForExperiment(Dir,'Session',StepName2{stepN});
    % 241 242 : pas de EXT-24h classique (24h dans plethysmo,24 apres une EXT-6h
    % 243, 394 : n'ont pas appris (criètre = au moins 10% de freezing pendant les 1ers CS+
    
    % remove the 2nd session of 244 -24h
    ind244=[];
    for man=1:length(Dir.name)
       ind244=[ind244; strcmp(Dir.name{man},'Mouse244')];
    end
    ind244=find(ind244);
    if length(ind244)>1
        Dir.path(ind244(2))=[];
        Dir.group(ind244(2))=[];
        Dir.name(ind244(2))=[];
        Dir.manipe(ind244(2))=[];
        Dir.Session(ind244(2))=[];
        Dir.Treatment(ind244(2))=[];
    end
    gfpmice=[1:length(Dir.path)]; %
    chr2mice=[];

    for man=1:length(Dir.path)
        Dir.nb{man}=Dir.name{man}([(end-2):end]);
    end

elseif strcmp(manip_name,'Fear_Mar2-July-Oct2017')
    
    % Dir=PathForExperimentFEAR('Fear-electrophy-opto');
    % Dir = RestrictPathForExperiment(Dir,'nMice',[458 459 465 467 540 542 543]);

    % march july-oct
    gfpmice=[1 2 3 4 5 6 7 8]; 
    chr2mice=[ 9 10 11 12 13 14 15 16];

    % % selection des souris freezing > 50% à 24h
    % gfpmice=[1 2 3 4 5 6 7 ]; 
    % chr2mice=[ 9 10 11 12 13 15];

    if jour==5;
    Dir.path={
        % gfp
        '/media/DataMOBs57/Fear-March2017/behavior/FEAR-Mouse-498-07032017-01-HABlaser';
        '/media/DataMOBs57/Fear-March2017/behavior/FEAR-Mouse-499-07032017-01-HABlaser';

        '/media/DataMOBs57/FEAR-March2/behavior/FEAR-Mouse-504-14032017-01-HABlaser13';
        '/media/DataMOBs57/FEAR-March2/behavior/FEAR-Mouse-505-15032017-01-HABlaser13';
        '/media/DataMOBs57/FEAR-March2/behavior/FEAR-Mouse-506-14032017-01-HABlaser13';

        '/media/DataMOBs57/Fear_July2017/behavior/FEAR-Mouse-537-25072017-01-HABlaser13_envA/';

        '/media/DataMOBs57/Fear-Oct2017/behavior/HAB_laser/FEAR-Mouse-610-03102017-01-HABenvtest';
        '/media/DataMOBs57/Fear-Oct2017/behavior/HAB_laser/FEAR-Mouse-611-03102017-01-HABenvtest';
        % chR2
        '/media/DataMOBs57/Fear-March2017/behavior/FEAR-Mouse-496-07032017-01-HABlaser';
        '/media/DataMOBs57/Fear-March2017/behavior/FEAR-Mouse-497-07032017-01-HABlaser';

        '/media/DataMOBs57/Fear_July2017/behavior/FEAR-Mouse-540-25072017-01-HABlaser13_envA/';
        '/media/DataMOBs57/Fear_July2017/behavior/FEAR-Mouse-542-25072017-01-HABlaser13_envA/';
        '/media/DataMOBs57/Fear_July2017/behavior/FEAR-Mouse-543-25072017-01-HABlaser13_envA/';

        '/media/DataMOBs57/Fear-Oct2017/behavior/HAB_laser/FEAR-Mouse-612-03102017-01-HABenvtest';
        '/media/DataMOBs57/Fear-Oct2017/behavior/HAB_laser/FEAR-Mouse-613-03102017-01-HABenvtest';
        '/media/DataMOBs57/Fear-Oct2017/behavior/HAB_laser/FEAR-Mouse-614-03102017-01-HABenvtest';

        };
    stepN=1;

    elseif jour==6;
    Dir.path={
        % gfp
        '/media/DataMOBs57/Fear-March2017/behavior/FEAR-Mouse-498-09032017-01-EXT-24-envB-laser13';
        '/media/DataMOBs57/Fear-March2017/behavior/FEAR-Mouse-499-09032017-01-EXT-24-envB-laser13'

        '/media/DataMOBs57/FEAR-March2/behavior/FEAR-Mouse-504-16032017-01-EXT-24-laser13';
        '/media/DataMOBs57/FEAR-March2/behavior/FEAR-Mouse-505-16032017-01-EXT-24-laser13';
        '/media/DataMOBs57/FEAR-March2/behavior/FEAR-Mouse-506-16032017-01-EXT-24-laser13';  

        '/media/DataMOBs57/Fear_July2017/behavior/FEAR-Mouse-537-27072017-01-EXT-24/';

        '/media/DataMOBs57/Fear-Oct2017/behavior/EXT-24/FEAR-Mouse-610-05102017-01-EXT-24';
        '/media/DataMOBs57/Fear-Oct2017/behavior/EXT-24/FEAR-Mouse-611-05102017-01-EXT-24';%     %%%%%%%%%%%%%


        % chR2
        '/media/DataMOBs57/Fear-March2017/behavior/FEAR-Mouse-496-09032017-01-EXT-24-envB-laser13';
        '/media/DataMOBs57/Fear-March2017/behavior/FEAR-Mouse-497-09032017-01-EXT-24-envB-laser13';

        '/media/DataMOBs57/Fear_July2017/behavior/FEAR-Mouse-540-27072017-01-EXT-24/';
        '/media/DataMOBs57/Fear_July2017/behavior/FEAR-Mouse-542-27072017-01-EXT-24/';
        '/media/DataMOBs57/Fear_July2017/behavior/FEAR-Mouse-543-27072017-01-EXT-24/';

        '/media/DataMOBs57/Fear-Oct2017/behavior/EXT-24/FEAR-Mouse-612-05102017-01-EXT-24';%     %%%%%%%%%%%%%
        '/media/DataMOBs57/Fear-Oct2017/behavior/EXT-24/FEAR-Mouse-613-05102017-01-EXT-24';
        '/media/DataMOBs57/Fear-Oct2017/behavior/EXT-24/FEAR-Mouse-614-05102017-01-EXT-24';%     %%%%%%%%%%%%%

        };
        stepN=2;
    elseif jour==7;
    Dir.path={

        '/media/DataMOBs57/Fear-March2017/behavior/FEAR-Mouse-498-10032017-01-EXT-48-envC_laser13';
        '/media/DataMOBs57/Fear-March2017/behavior/FEAR-Mouse-499-10032017-01-EXT-48-envC_laser13';
        '/media/DataMOBs57/FEAR-March2/behavior/FEAR-Mouse-504-17032017-01-EXT-48-envC-laser13';
        '/media/DataMOBs57/FEAR-March2/behavior/FEAR-Mouse-505-17032017-01-EXT-48-envC-laser13';
        '/media/DataMOBs57/FEAR-March2/behavior/FEAR-Mouse-506-17032017-01-EXT-48-envC-laser13';

        '/media/DataMOBs57/Fear_July2017/behavior/FEAR-Mouse-537-28072017-01-EXT-48/';

        '/media/DataMOBs57/Fear-Oct2017/behavior/EXT-48/FEAR-Mouse-610-06102017-01-EXT-48_laser13';
        '/media/DataMOBs57/Fear-Oct2017/behavior/EXT-48/FEAR-Mouse-611-06102017-01-EXT-48_laser13';


        '/media/DataMOBs57/Fear-March2017/behavior/FEAR-Mouse-496-10032017-01-EXT-48-envC_laser13';
        '/media/DataMOBs57/Fear-March2017/behavior/FEAR-Mouse-497-10032017-01-EXT-48-envC_laser13';

        '/media/DataMOBs57/Fear_July2017/behavior/FEAR-Mouse-540-28072017-01-EXT-48/';
        '/media/DataMOBs57/Fear_July2017/behavior/FEAR-Mouse-542-28072017-01-EXT-48/';
        '/media/DataMOBs57/Fear_July2017/behavior/FEAR-Mouse-543-28072017-01-EXT-48/';

        '/media/DataMOBs57/Fear-Oct2017/behavior/EXT-48/FEAR-Mouse-612-06102017-01-EXT-48_laser13';
        '/media/DataMOBs57/Fear-Oct2017/behavior/EXT-48/FEAR-Mouse-613-06102017-01-EXT-48_laser13';
        '/media/DataMOBs57/Fear-Oct2017/behavior/EXT-48/FEAR-Mouse-614-06102017-01-EXT-48_laser13';

        };
        stepN=3;
    elseif jour==8;
    Dir.path={ 
        '/media/DataMOBs57/Fear_July2017/behavior/FEAR-Mouse-537-26072017-01-COND/';
        '/media/DataMOBs57/Fear_July2017/behavior/FEAR-Mouse-540-26072017-01-COND/';
        '/media/DataMOBs57/Fear_July2017/behavior/FEAR-Mouse-542-26072017-01-COND/';
        '/media/DataMOBs57/Fear_July2017/behavior/FEAR-Mouse-543-26072017-01-COND/';

        '/media/DataMOBs57/Fear-March2017/behavior/FEAR-Mouse-496-08032017-01-COND'
      };
        stepN=4; 

    elseif jour==9;        % define stepN

    end

    for man=1:length(Dir.path)
        ind_mouse=strfind(Dir.path{man},'Mouse');
        Dir.nb{man}=Dir.path{man}(ind_mouse+6:ind_mouse+8);
    end
end

colori=jet(max(length(gfpmice),length(chr2mice)));
%% INITIALIZE
cd(['/media/DataMOBsRAIDN/ProjetAversion/OptoFear/' manip_name]); res=pwd;
CSplu_WN_GpNb=[465 466 496 498 502 504 506 537 540 542 543 610 611 612 613 614];
for k=1:length(CSplu_WN_GpNb),   CSplu_WN_Gp{k}=num2str(CSplu_WN_GpNb(k)); end
CSplu_WN_Gp=CSplu_WN_Gp';

CSplu_bip_GpNb=[467 468 497 499 503 505];
for k=1:length(CSplu_bip_GpNb), CSplu_bip_Gp{k}=num2str(CSplu_bip_GpNb(k));end
CSplu_bip_Gp=CSplu_bip_Gp';



freezeTh=1.5;
if rawPlo
rawfig=figure('Position',[ 1922           2        1225         972]);
% barfig=figure('Position',[ 345         554        1557         354]);
% barfig_Mov=figure('Position',[ 345         147        1557         354]);
end
PercF=nan(8,length(Dir.path));
PercF_bef=nan(8,length(Dir.path));
MovQty_During=nan(8,length(Dir.path));
MovQty_bef=nan(8,length(Dir.path));
MovMat=nan(16,length(Dir.path),ceil(105/0.3780));% 105=30sec bef+45 during+30 after / 0.3780=periode enre 2 points de Movtsd




% CspluPer3=intervalSet(1117*1e4,1400*1e4); % 3rd block of four CS+
%  period='fullperiod';
period='fullperiod'; optionfullper='close2sound';
% period='fullperiod'; optionfullper='fullblocks';
% period='soundonly'; optionfullper='';

for man=1:length(Dir.path)
    
    ind_mouse=strfind(Dir.path{man},'Mouse-');
    if ~isempty(ind_mouse)
        m=str2num(Dir.path{man}(ind_mouse+6:ind_mouse+8));
    else
        ind_mouse=strfind(Dir.path{man},'Mouse');
        m=str2num(Dir.path{man}(ind_mouse+5:ind_mouse+7));
    end
    cd(Dir.path{man})
    try 
        load behavResources Movtsd FreezeEpoch 
        Movtsd;FreezeEpoch; 
    catch
        load Behavior Movtsd TTL FreezeEpoch 
    end
    
    if strcmp(Dir.path{man}, '/media/DataMOBs57/Fear-March2017/behavior/FEAR-Mouse-496-07032017-01-HABlaser')
        Movtsd=tsd(Range(Movtsd),Data(Movtsd)/300);
    elseif strcmp(Dir.path{man}, '/media/DataMOBs57/Fear-March2017/behavior/FEAR-Mouse-497-10032017-01-EXT-48-envC_laser13')
        Movtsd=tsd(Range(Movtsd),Data(Movtsd)/200);
    elseif strcmp(Dir.path{man}, '/media/DataMOBs57/FEAR-March2/behavior/FEAR-Mouse-504-14032017-01-HABlaser13')
        Movtsd=tsd(Range(Movtsd),Data(Movtsd)/388);
    elseif strcmp(Dir.path{man}, '/media/DataMOBs57/FEAR-March2/behavior/FEAR-Mouse-506-14032017-01-HABlaser13')
        Movtsd=tsd(Range(Movtsd),Data(Movtsd)/454);
    end
    %% recuperer les temps des sons 
    try 
        if exist('behavResources.mat', 'file')==2
            load behavResources csm csp CSplInt CSmiInt
            csm; csp; CSplInt; CSmiInt;
        else
            load Behavior csm csp CSplInt CSmiInt 
             csm; csp; CSplInt; CSmiInt;
        end
        csm; csp; CSplInt;CSmiInt;
    catch
        if exist('behavResources.mat', 'file')==2 
            try
                load behavResources csm csp
                 csm; csp; 
                 CSplInt=intervalSet(csp*1e4,(csp+29)*1e4); % intervals for CS+
                 CSmiInt=intervalSet(csm*1e4,(csm+29)*1e4);
                 save behavResources CSplInt CSmiInt -Append
            catch
                keyboard
            end
        else
            load Behavior TTL
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

            save Behavior csm csp CSplInt CSmiInt -Append
        end
    end

    %% get laser stim interval
    if isempty(strfind(Dir.path{man},'COND')) && ~strcmp('Fear-CTRL', manip_name)
        sss=TTL(TTL(:,2)==6,1);
        sI=intervalSet(sss(1:end-1)*1E4,sss(2:end)*1E4);
        sI=dropLongIntervals(sI,1*1E4);
        LaserON_beh=mergeCloseIntervals(sI,0.5*1E4);
    end

    FreezeEpoch=thresholdIntervals(Movtsd,freezeTh,'Direction','Below');
    FreezeEpoch=mergeCloseIntervals(FreezeEpoch,0.3*1E4);
    FreezeEpoch=dropShortIntervals(FreezeEpoch,2*1E4); 
    
   % define interval of interest
%     try
%         NosoundNoLaserPer;
%         NosoundWithLaserPer;
%         NosoundPer;
%         CsminPer;
%         CspluPer0;CspluPer1;CspluPer2;CspluPer3;
%     catch
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
                CspluPer3=intervalSet(Start(subset(CSplInt,9)),End(subset(CSplInt,12))+30*1E4);                
                
                
            end
        else
            
            CsminPer=intervalSet(122*1e4,408*1e4); % the block of four CS-
            CspluPer0=intervalSet(408*1e4,600*1e4); % 
            CspluPer1=intervalSet(600*1e4,789*1e4); % 1st block of four CS+  % intervalSet(408*1e4,789*1e4);
            CspluPer2=intervalSet(789*1e4,1117*1e4); % 2nd block of four CS+
            CspluPer3=intervalSet(1117*1e4,1400*1e4); % 3rd block of four CS+
        end
        
%     end

    if rawPlo
        figure(rawfig)
        subplot(length(Dir.path),5,(man-1)*5+[1:3])
         plot(Range(Movtsd,'s'),Data(Movtsd),'k')
            hold on
            for k=1:length(Start(FreezeEpoch))
                plot(Range(Restrict(Movtsd,subset(FreezeEpoch,k)),'s'),Data(Restrict(Movtsd,subset(FreezeEpoch,k))),'c')
            end
            YL=ylim;
            if jour>2
                line([csp csp+30]',0.6*YL(2)*ones(size(csp),2)','Color','b','LineWidth',2)
                line([csm csm+30]',0.6*YL(2)*ones(size(csm),2)','Color','g','LineWidth',2)
            end
            if isempty(strfind(Dir.path{man},'COND')) && ~strcmp('Fear-CTRL', manip_name)
                line([Start(LaserON_beh)*1E-4 End(LaserON_beh)*1E-4],[0.65*YL(2) 0.65*YL(2)],'Color','c','LineWidth',2)
            end
            title([  'max ' num2str(max(Data(Movtsd)))])                                                     
            ylabel(num2str(m))
            if man==1, text(0,1.2,StepName{stepN},'units','normalized'); end
            ylim([0 30]),xlim([0 1420])
            aa=0.7;pas=0.05;
            %             line([Start(NosoundNoLaserPer)*1E-4 End(NosoundNoLaserPer)*1E-4],[aa aa]);aa=aa+1;
%             line([Start(NosoundWithLaserPer)*1E-4 End(NosoundWithLaserPer)*1E-4],[aa aa]);aa=aa+1;
            YL=ylim;
            line([Start(NosoundPer)*1E-4 End(NosoundPer)*1E-4],[aa*YL(2) aa*YL(2)]);aa=aa+pas;
            line([Start(CsminPer)*1E-4 End(CsminPer)*1E-4],[aa*YL(2) aa*YL(2)]); aa=aa+pas;
            line([Start(CspluPer0)*1E-4 End(CspluPer0)*1E-4],[aa*YL(2) aa*YL(2)]); aa=aa+pas;
            line([Start(CspluPer1)*1E-4 End(CspluPer1)*1E-4],[aa*YL(2) aa*YL(2)]); aa=aa+pas;
            line([Start(CspluPer2)*1E-4 End(CspluPer2)*1E-4],[aa*YL(2) aa*YL(2)]); aa=aa+pas;
            line([Start(CspluPer3)*1E-4 End(CspluPer3)*1E-4],[aa*YL(2) aa*YL(2)]); aa=aa+pas;
        xlim([0 max(Range(Movtsd))*1E-4])
            
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    bilanMovtsd{man}=Movtsd;
    Ep=FreezeEpoch;
    if strcmp(period,'fullperiod')
        %percentage of freeing during the different periods (four CS- and each block of four CS+)
        try
            bilan{stepN}(man,:)=[length(Data(Restrict(Movtsd,and(Ep,NosoundPer))))/length(Data(Restrict(Movtsd,NosoundPer))),...
                length(Data(Restrict(Movtsd,and(Ep,CsminPer))))/length(Data(Restrict(Movtsd,CsminPer))),...
                length(Data(Restrict(Movtsd,and(Ep,CspluPer0))))/length(Data(Restrict(Movtsd,CspluPer0))),...
                length(Data(Restrict(Movtsd,and(Ep,CspluPer1))))/length(Data(Restrict(Movtsd,CspluPer1))),...
                length(Data(Restrict(Movtsd,and(Ep,CspluPer2))))/length(Data(Restrict(Movtsd,CspluPer2))),...
                length(Data(Restrict(Movtsd,and(Ep,CspluPer3))))/length(Data(Restrict(Movtsd,CspluPer3)))];
        catch
            bilan{stepN}(mousenb,:)=NaN(1,4);
            disp(['no  value for M' num2str(m) ' ' StepName{stepN} ])
        end
    elseif strcmp(period,'soundonly')
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
            bilan{stepN}(man,:)=[length(Data(Restrict(Movtsd,and(Ep,NosoundPer))))/length(Data(Restrict(Movtsd,NosoundPer))),...
                length(Data(Restrict(Movtsd,and(Ep,sounds1))))/length(Data(Restrict(Movtsd,sounds1))),...
                length(Data(Restrict(Movtsd,and(Ep,sounds3))))/length(Data(Restrict(Movtsd,sounds3))),...
                length(Data(Restrict(Movtsd,and(Ep,sounds4))))/length(Data(Restrict(Movtsd,sounds4))),...
                length(Data(Restrict(Movtsd,and(Ep,sounds5))))/length(Data(Restrict(Movtsd,sounds5))),...
                length(Data(Restrict(Movtsd,and(Ep,sounds6))))/length(Data(Restrict(Movtsd,sounds6)))];
        catch
            bilan{stepN}(mousenb,:)=NaN(1,4);
            disp(['no  value for M' num2str(m) ' ' StepName{stepN} ])
        end
    end
                    
    

    clear Movtsd
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
set(gca,'XTickLabel',{'o';'-';'+';'+l';'+l';'+l';}), ylim([0 1  ])

    end
end


cd(res)
res=pwd;
if sav & rawPlo
saveas(rawfig,[StepName{stepN} '_' period '_' optionfullper '_raw.fig'])
saveFigure(rawfig,[StepName{stepN} '_' period '_' optionfullper '_raw'],res)
end
if sav
    cd(res)
    save([StepName{stepN} '_' period '_' optionfullper], 'bilan','gfpmice','chr2mice','StepName', 'Dir', 'freezeTh','period','bilanMovtsd','optionfullper')
end

%% Barplot bilan%% Barplot bilan
figure ('Position',[ 287         517       1792         312])
n=4; k=1;
% Chr2 mice
if ~strcmp(manip_name, 'Fear-CTRL');
    subplot(1,n,k), k=k+1; hold on
    % lines present 2X : trick for legend plotting
    for man=1:size(bilan{stepN}(chr2mice,:),1)
            plot(bilan{stepN}(chr2mice(man),:),'Color',colori(man,:),'Marker','o','MarkerSize',3,'MarkerEdgeColor',colori(man,:),'MarkerFaceColor',colori(man,:))
    end
    PlotErrorBarN(bilan{stepN}(chr2mice,:),0,1,'ranksum',2) % newfig=0; paired=1,columntest=2
    for man=1:size(bilan{stepN}(chr2mice,:),1)
            plot(bilan{stepN}(chr2mice(man),:),'Color',colori(man,:),'Marker','o','MarkerSize',3,'MarkerEdgeColor',colori(man,:),'MarkerFaceColor',colori(man,:))
    end
    ylim([0 1]), title('ChR2')
    text(-0.2,1.05,[period],'units','normalized')
    if ~isempty(strfind(Dir.path{man},'EXT'))
        ylabel([StepName{stepN} ' ' optionfullper ])
    end
    [p4_ch, h, stats]=signrank(bilan{stepN}(chr2mice,3), bilan{stepN}(chr2mice,4));
    xlabel([ 'p ' sprintf('%0.3f',p4_ch) ])
end
legend(Dir.nb{chr2mice},'Location','bestoutside')


% GFP mice
subplot(1,n,k), k=k+1;hold on
for man=1:size(bilan{stepN}(gfpmice,:),1)
        plot(bilan{stepN}(gfpmice(man),:),'Color',colori(man,:),'Marker','o','MarkerSize',3,'MarkerEdgeColor',colori(man,:),'MarkerFaceColor',colori(man,:))
end
PlotErrorBarN(bilan{stepN}(gfpmice,:),0,1,'ranksum',2)
for man=1:size(bilan{stepN}(gfpmice,:),1)
        plot(bilan{stepN}(gfpmice(man),:),'Color',colori(man,:),'Marker','o','MarkerSize',3,'MarkerEdgeColor',colori(man,:),'MarkerFaceColor',colori(man,:))
end
legend(Dir.nb{gfpmice},'Location','bestoutside')
[p4_gf, h, stats]=signrank(bilan{stepN}(gfpmice,3), bilan{stepN}(gfpmice,4));
xlabel([ 'p ' sprintf('%0.3f',p4_gf) ])
ylim([0 1]), title('GFP')

% Comparative GFP-ChR2
if ~strcmp(manip_name, 'Fear-CTRL');
    
    subplot(1,n,k), k=k+1;
    %bar([nanmean(bilan{stepN}(chr2mice,:),1); nanmean(bilan{stepN}(gfpmice,:),1)]')
    % ylim([0 1]), legend('ChR2','GFP')
    % [p3_gfp, h, stats]=signrank(bilan{stepN}(gfpmice,3), bilan{stepN}(gfpmice,4));
    % xlabel([ 'p ' sprintf('%0.3f',p3_gfp) ]);
    % title( StepName{stepN})
    % [p2, h, stats]=ranksum(bilan{stepN}(chr2mice,3), bilan{stepN}(gfpmice,3));
    % [p3, h, stats]=ranksum(bilan{stepN}(chr2mice,3), bilan{stepN}(gfpmice,3));
    % [p4, h, stats]=ranksum(bilan{stepN}(chr2mice,4), bilan{stepN}(gfpmice,4));
    % xlabel([ 'p3 ' sprintf('%0.3f',p3)  '  p4 ' sprintf('%0.3f',p4) ])


    Table{1,1}=bilan{stepN}(chr2mice,:);
    Table{1,2}=bilan{stepN}(gfpmice,:);
    BarPlotBulbSham_gen(Table,[StepName{stepN} '_acc'],{[0.5 0 0],[0 0 0.5]},'ranksum',1,4,3,'indivdots',0)
    legend(['chr2 -' num2str(length(chr2mice))],['gfp -' num2str(length(gfpmice))])
    ylim([0 1])
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
    MI_chr2=(bilan{stepN}(chr2mice,4)-bilan{stepN}(chr2mice,3))./(bilan{stepN}(chr2mice,4) + bilan{stepN}(chr2mice,3));
    MI_gfp=(bilan{stepN}(gfpmice,4)-bilan{stepN}(gfpmice,3))./(bilan{stepN}(gfpmice,4) + bilan{stepN}(gfpmice,3));
    plotSpread({MI_chr2,MI_gfp},'showMM',1);

    [p_ratio_gfp, h, stats]=ranksum(MI_chr2,MI_gfp);
    title('Mod Index'),set(gca,'XtickLabel',{'chR2','gfp','ctrl'});
    ylim([-1 1])
    xlabel([ 'p ' sprintf('%0.3f',p_ratio_gfp)  ])

end 

if sav
cd(res)
save([manip_name],'Dir','bilan','gfpmice','chr2mice','StepName','period','optionfullper');% 'Table'
saveas (gcf,[StepName{stepN} '_' period '_' optionfullper 'mean.fig'])
saveas (gcf,[StepName{stepN} '_' period '_' optionfullper 'mean.png'])
saveFigure(gcf,[StepName{stepN} '_' period '_' optionfullper 'mean'],res)

end

