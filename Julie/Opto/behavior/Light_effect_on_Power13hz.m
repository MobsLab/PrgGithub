% Light_effect_on_Power13hz.m.m
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
rawPlo=1;
rawPlo_indiv=0;
sav=1;
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

    Dir.path=[Dir_gfp.path, Dir_chr2.path];
    Dir.manipe=[Dir_gfp.manipe, Dir_chr2.manipe];
    Dir.Session=[Dir_gfp.Session, Dir_chr2.Session];
    Dir.group=[Dir_gfp.group, Dir_chr2.group];
    Dir.Treatment=[Dir_gfp.Treatment, Dir_chr2.Treatment];
    Dir.name=[Dir_gfp.name, Dir_chr2.name];
    
    % to remove 497 bof)
    % mice_included=[498 499 504 505 506 537 610 611]; manipname='LaserChR2-fear-MarJulOct17-gfp';
%     mice_included=[496 497 540 542 543 612 613 614]; manipname='LaserChR2-fear-MarJulOct17-chr2';
%     Dir = RestrictPathForExperiment(Dir,'nMice',mice_included);
    Dir = RestrictPathForExperiment(Dir,'Group','GADchr2'); % [496 497 540 542 543 612 613 614]
    gfpmice=[1:length(Dir_gfp.name)]; 
%     chr2mice=[length(Dir_gfp.name)+1:length(Dir_gfp.name)+length(Dir_chr2.name)];
%     if stepN==3
%         % remove 496 car laser dès le 2e CS+ (assez drastique cette correction...)
%         Dir = RestrictPathForExperiment(Dir,'nMice',[497 540 542 543 612 613 614]);
%         chr2mice(end)=[];
%     end
end

%% INITIALIZE
cd(['/media/DataMOBsRAIDN/ProjetAversion/OptoFear/' manip_name]); res=pwd;
% structlist={'Bulb_deep_right'};%
% structlist={'Bulb_deep_left'};%
% structlist={'Bulb_ventral_right'};%
% structlist={'PFCx_deep_right','PFCx_deep_left'};%
structlist={'Bulb_ecoG_right','Bulb_deep_right','Bulb_ventral_right','PiCx_right','Bulb_ecoG_left','Bulb_deep_left','Bulb_ventral_left','PiCx_left'};%,'Amyg'%,'PiCx' Bulb_left'PFCx_right'
% structlist={'Bulb_deep_left','PFCx_deep_left','PFCx_deep_right','Bulb_deep_right','dHPC_deep','PiCx_right'};%



% try load([StepName{stepN} '_' period '_' optionfullper '_acc'], 'bilan','gfpmice','chr2mice','StepName', 'Dir', 'freezeTh','period','bilanMovAccSmotsd','optionfullper')
%     
% catch
    
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

    % options for periods used for percent of freezing
    period='fullperiod'; optionfullper='close2sound';
    % period='fullperiod'; optionfullper='fullblocks';
    % period='soundonly'; optionfullper='';
for i=1:length(structlist)
    if rawPlo
        rawfig=figure('Position',[ 1922           2        1225         972]);
        rawfignorm=figure('Position',[ 1922           2        1225         972]);
        rawfignorm220=figure('Position',[ 1922           2        1225         972]);
    end
    BasalPower13=nan(length(Dir.path),1);
    BasalPower220=nan(length(Dir.path),1);
    for man=1:length(Dir.path)

        ind_mouse=strfind(Dir.path{man},'Mouse-');
        if ~isempty(ind_mouse), m=str2num(Dir.path{man}(ind_mouse+6:ind_mouse+8)); else, ind_mouse=strfind(Dir.path{man},'Mouse'); m=str2num(Dir.path{man}(ind_mouse+5:ind_mouse+7)); end
        cd(Dir.path{man})
        
        %% load spectrum
        if findstr(structlist{i},'dHPC')
            try tempt=load([Dir.path{man},'/ChannelsToAnalyse/dHPC_deep.mat']); if ~isempty(tempt.channel);temp=tempt;end;end   
            try tempt=load([Dir.path{man},'/ChannelsToAnalyse/dHPC_rip.mat']); if ~isempty(tempt.channel);temp=tempt;end;end 
        else
            temp=load([Dir.path{man},'/ChannelsToAnalyse/',structlist{i},'.mat']);
        end

        % load or compute spectrum
        if ~isnan(temp.channel)
            try
                load([Dir.path{man},'/SpectrumDataL/Spectrum' num2str(temp.channel),'.mat'],'Sp', 't', 'f') % t en secondes
                disp(['SpectrumDataL/Spectrum' num2str(temp.channel),'... loaded'])
            catch
                if ~exist([Dir.path{man},'/SpectrumDataL'],'dir'), mkdir([Dir.path{man},'/SpectrumDataL']);end
                eval(['temp2=load(''',Dir.path{man},'/LFPData/LFP',num2str(temp.channel),'.mat'');'])
                disp(['Computing SpectrumDataL/Spectrum' num2str(temp.channel),'... '])
                [Sp,t,f]=mtspecgramc(Data(temp2.LFP),movingwin,params);
                eval(['save(''',Dir.path{man},'/SpectrumDataL/Spectrum',num2str(temp.channel),'.mat'',','''Sp'',','''t'',','''f'',','''params'',','''movingwin'');'])
            end

            %% plot spectrum, and CS+/ CS-/laser information
            Stsd=tsd(t*1E4,Sp);
            S13tsd=tsd(t*1E4,nanmean(Sp(:,(f>12.5)&(f<13.5)),2));
            S4tsd=tsd(t*1E4,nanmean(Sp(:,(f>3.5)&(f<4.5)),2));
            S220tsd=tsd(t*1E4,nanmean(Sp(:,(f>2)),2));
            tps=Range(Stsd); %tps est en 10-4sec
            TotEpoch=intervalSet(tps(1),tps(end));
            %figure, imagesc(t,f,10*log10(Sp')), axis xy
            % load or compute StimLaserON
            try
                load behavResources StimLaserON StimLaserOFF
                StimLaserON; StimLaserOFF;
            catch
                temp=load('LFPData/LFP32.mat');
                LaserLFP=temp.LFP;
                % for debug : 
                %figure,hold on, plot(Range(LaserLFP)*1E-4, Data(LaserLFP))
                RangeLFPlaser=Range(LaserLFP);
    %             figure, hist(Data(LaserLFP),[-600 :100 :600])
                [n,xout]=hist(Data(LaserLFP),[-600 :100 :600]); % large bin to have all values of each state(On/Off) in only one bin
                [nsorted,IX]=sort(n,'descend');
                thresh=(xout(IX(1))+xout(IX(2)))/2;
                if xout(IX(1)) >xout(IX(2))
                    StimLaserON=thresholdIntervals(LaserLFP,thresh,'Direction','Below');
                else
                    StimLaserON=thresholdIntervals(LaserLFP,thresh,'Direction','Above');
                end
                    StimLaserON=mergeCloseIntervals(StimLaserON,0.5*1E4);
                TotEpoch=intervalSet(0, RangeLFPlaser(end));
                StimLaserOFF=TotEpoch-StimLaserON;
    %             hold on, plot(Start(StimLaserON)*1E-4,14,'*b')
    %             hold on, plot(End(StimLaserON)*1E-4,14,'*r')
                save behavResources StimLaserON StimLaserOFF -Append
                clear RangeLFPlaser
            end


            try 
                load behavResources MovAccSmotsd FreezeAccEpoch 
                MovAccSmotsd;FreezeAccEpoch; 
            catch
                keyboard
            end
            %TotEpoch=intervalSet(0,min(MovAccSmotsd_range(end),1420*1E4)); clear MovAccSmotsd_range
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
    %         if isempty(strfind(Dir.path{man},'COND')) && ~strcmp('Fear-CTRL', manip_name)
    %             load behavResources TTL
    %             sss=TTL(TTL(:,2)==6,1);
    %             sI=intervalSet(sss(1:end-1)*1E4,sss(2:end)*1E4);
    %             sI=dropLongIntervals(sI,1*1E4);
    %             LaserON_beh=mergeCloseIntervals(sI,0.5*1E4);
    %         end

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
          
            BasalPower13(man)=nanmean(Data(Restrict(S13tsd,and(TotEpoch-FreezeAccEpoch,intervalSet(0,60*1E4)))));
            BasalPower220(man)=nanmean(Data(Restrict(S220tsd,and(TotEpoch-FreezeAccEpoch,intervalSet(0,60*1E4)))));

            %% Plot raw individual data
            if rawPlo

                figure(rawfig); % cla
                subplot(length(Dir.path),1,man), hold on
                BasalPower13(man)=nanmean(Data(Restrict(S13tsd,and(TotEpoch-FreezeAccEpoch,intervalSet(0,60*1E4)))));
                plot(Range(S13tsd),nanmean(Data(S13tsd),2));%plot(Range(restrict(S13tsd,StimLaserON)));
                XL=xlim;
                plot(XL,[BasalPower13(man) BasalPower13(man)])
                
    %             plot(Range(S4tsd),nanmean(Data(S4tsd),2));%plot(Range(restrict(S13tsd,StimLaserON)));
    %             plot(Range(MovAccSmotsd(1:25:end),'s'),Data(MovAccSmotsd(1:25:end)),'k')
                ylabel(num2str(m))
                if man==1, title([ StepName{stepN} ' '  structlist{i} ]),end
                
                figure(rawfignorm); % cla
                subplot(length(Dir.path),1,man), hold on
                plot(Range(S13tsd),nanmean(Data(S13tsd),2)/BasalPower13(man));
                ylabel(num2str(m))
                if man==1, title([ StepName{stepN} ' '  structlist{i} ]),end
                
                figure(rawfignorm220); % cla
                subplot(length(Dir.path),1,man), hold on
                plot(Range(S13tsd),nanmean(Data(S13tsd),2)/BasalPower220(man));
                ylabel(num2str(m))
                if man==1, title([ StepName{stepN} ' '  structlist{i} ]),end
            end


            %% Compute power
    %         bilanMovAccSmotsd{man}=MovAccSmotsd(1:25:end);
    %         Ep=FreezeAccEpoch;
                try
    %                 bilan{stepN}(man,:)=[nanmean(Data(Restrict(S13tsd,NosoundPer))),...
    %                     nanmean(Data(Restrict(S13tsd,CsminPer))),...
    %                     nanmean(Data(Restrict(S13tsd,CspluPer0))),...
    %                     nanmean(Data(Restrict(S13tsd,CspluPer1))),...
    %                     nanmean(Data(Restrict(S13tsd,CspluPer2))),...
    %                     nanmean(Data(Restrict(S13tsd,CspluPer3)))];
                    bilan{stepN}(man,:)=[nanmean(Data(Restrict(S13tsd,and(NosoundPer,StimLaserON)))),...
                        nanmean(Data(Restrict(S13tsd,and(CsminPer,StimLaserON)))),...
                        nanmean(Data(Restrict(S13tsd,and(CspluPer0,StimLaserON)))),...
                        nanmean(Data(Restrict(S13tsd,and(CspluPer1,StimLaserON)))),...
                        nanmean(Data(Restrict(S13tsd,and(CspluPer2,StimLaserON)))),...
                        nanmean(Data(Restrict(S13tsd,and(CspluPer3,StimLaserON))))];
                    

                catch
                    bilan{stepN}(mousenb,:)=NaN(1,4);
                    disp(['no  value for M' num2str(m) ' ' StepName{stepN} ])
                end

            save OB_power_14_4_Hz S13tsd S4tsd


            clear S13tsd S4tsd
        else
            disp(['no channel defined for ' Dir.name{man}])
            bilan{stepN}(man,:)=[nan nan nan nan nan nan ];
        end
    end
% end % end of try/catch
 

cd(res)
res=pwd;
if sav & rawPlo
saveas(rawfig,[StepName{stepN} '_raw_power' structlist{i} '.fig'])
saveas(rawfig,[StepName{stepN} '_raw_power' structlist{i} '.eps'])
saveas(rawfig,[StepName{stepN} '_raw_power' structlist{i} '.png'])

saveas(rawfignorm,[StepName{stepN} '_raw_power' structlist{i} '_norm13.png'])
saveas(rawfignorm220,[StepName{stepN} '_raw_power' structlist{i} '_norm220.png'])
% saveFigure(rawfig,[StepName{stepN} '_raw_power' structlist{i} ],res)
end
if sav
    cd(res)
    save([StepName{stepN} '_power_' structlist{i}], 'bilan','gfpmice','chr2mice','StepName', 'Dir','period','BasalPower13','BasalPower220')
end
clear bilan
close(rawfig); close(rawfignorm);close(rawfignorm220);
end

