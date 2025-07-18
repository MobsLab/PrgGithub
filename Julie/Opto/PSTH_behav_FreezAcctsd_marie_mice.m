%PSTH_behav_FreezAcctsd_marie_mice.m
% 10.01.2016

% from PSTH_behav_MovAcctsd2_juil_oct.m
% from PSTH_behav_MovAcctsd2_dec16_2

% 04.01.2017 from PSTH_behav_MovAcctsd2
% deals with data from manip fear opto dec 16 : 465 466 467 468 

% similar to PSTH_behav_Movtsd, but plot 
% - either all CS +, averaged_2_by_2
% - or the first 4 CS +, no averaged

% OUTPUTS
% a figure for each mouse of PSTH (averaged CS-, first CS+, last CS+) ->  BulbectomiePSTHdata.mat
% a matrix for all mice of PSTH (averaged CS-, first CS+, last CS+) color coded)
% the average of these matrices by group (sham/ bulb)
% the compartison of Pre/Post sound period by group 

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%  OPTIONS   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%% for all CS +, averaged_2_by_2
% CSoption = 'AllCS avg2by2';
% disp ('CSoption = AllCS avg2by2')

% %% for first 4 CS +, no averaged
CSoption = '4firstCS not averaged';
disp ('CSoption = 4firstCS not averaged')

PreSound=[65:80]; % 15sec before sound
   Sound=[81:95]; % 15sec  
%Sound=[81:110]; % 30sec  
PostSound=[111:125];

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%  INPUTS  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

experiment= 'Fear-electrophy';
manipname='LaserChR2-fear-CTRL_mice';


cd(['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/' manipname '/']);
res=pwd;
Dir=PathForExperimentFEAR('Fear-electrophy');
Dir = RestrictPathForExperiment(Dir,'Group','CTRL');
%Dir = RestrictPathForExperiment(Dir,'nMice',[394 395 402 403 450 451]);% marie_mice
%Dir = RestrictPathForExperiment(Dir,'nMice',[363 367 458 459]); juil_oct
%Dir = RestrictPathForExperiment(Dir,'nMice',[465 466 467 468]); dec_16

Dir = RestrictPathForExperiment(Dir,'Session','EXT');
StepName={'EXT-24';'EXT-48'};
%StepName={'EXT-24';'EXT-48';'EXT-72'};
% Dir = RestrictPathForExperiment(Dir,'Session',{'HAB-envC';'HAB-envB';'EXT-24'});
% StepName={'HAB-envC';'HAB-envB';'EXT-24'};

[nameMice, IXnameMice]=unique(Dir.name);
% re-order Dir with Mice order (required for next loop)
[Dir.name, nameMice_indices]=sort(Dir.name);
Dir.path=Dir.path(nameMice_indices);
Dir.manipe=Dir.manipe(nameMice_indices);
Dir.Session=Dir.Session(nameMice_indices);
Dir.group=Dir.group(nameMice_indices);% same info, but just in case
Dir.Treatment=Dir.Treatment(nameMice_indices);% same info, but just in case
 
lim=160; % nb bins
bi=1000; % bin size
smo=1;
plo=1;
sav=1;

FolderPath=(['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/' manipname '/']);

ColorPSTH={ [0.7 0.7 1],[1 0 0],[0 0 1],[1 0.7 0.7]};% [1 0.5 0]

% group CS+=bip
CSplu_bip_GpNb=[253 467 468 403 450 451];
CSplu_bip_Gp={};
for k=1:length(CSplu_bip_GpNb)
    CSplu_bip_Gp{k}=num2str(CSplu_bip_GpNb(k));
end
CSplu_bip_Gp=CSplu_bip_Gp';

% group CS+=WN
CSplu_WN_GpNb=[254 363 367 458 459 402 465 466 ];
CSplu_WN_Gp={};
for k=1:length(CSplu_WN_GpNb)
    CSplu_WN_Gp{k}=num2str(CSplu_WN_GpNb(k));
end
CSplu_WN_Gp=CSplu_WN_Gp';

Mx={'C','P','E'};

SndDur=Sound(end)-Sound(1)+1;
PreInt=intervalSet(-15*1E4,0*1E4);
SoundInt=intervalSet(0*1E4,SndDur*1E4);
PostInt=intervalSet(1*1E4,45*1E4);

    
%% GET DATA TO PLOT
try
    load(['FreezAcctsdPSTH_ChR2/PSTH_behav_' manipname '_' num2str(SndDur) 's']);
    disp(['Loading existing data from PSTH_behav_' manipname '.mat']);
    [B,IX] = sort(Dir.group);
    Dir.path=Dir.path(IX);
    Dir.name=Dir.name(IX);
    Dir.manipe=Dir.manipe(IX);
    Dir.group=B;
    Dir.Session=Dir.Session(IX);
    [nameMice, IXnameMice]=unique(Dir.name);

catch

    % Matrix of data; mice in lines
    for k=0:7
        eval(['C' num2str(k) '=[];']);% EXT24
        eval(['P' num2str(k) '=[];']);% EXT-48
        eval(['E' num2str(k) '=[];']);% EXT-72
    end
    C={};P={};E={};
    a=1; %counter for MouseListC
    b=1; %counter for MouseListC_NoMovAcctsd
    a1=1;a2=1;a3=1;%counter for StepName1 StepName2 StepName3
    MouseNbList{:,1}=[]; MouseNbList{:,2}=[]; MouseNbList{:,3}=[];
    i=1;
    Mousename='MXXX';
    for man=1:length(Dir.path) 
        MouseNb=str2num(Dir.name{man}(end-2:end));
        Mousename=['M' Dir.name{man}(end-2:end)];
        disp(Mousename)
        MovAcctsd_ok=1;
        Dir.path{man}
        cd ([Dir.path{man}])
        if ~isempty(strfind(Dir.path{man},'Mouse363/20160714-HAB-envC-laser4')) ||~isempty(strfind(Dir.path{man},'Mouse-363/20160714-HAB-envC-laser4'))
            % use Movtsd because pb intan -> accelero data not available for a long period
            load ('behavResources.mat', 'Movtsd','TTL')
            MovAcctsd=tsd(Range(Movtsd)-4*1E4,Data(Movtsd)*1E7);
            disp('for Mouse363/20160714-HAB-envC-laser4 use of Movtsd because large noise on MovAcctsd')
            load ('behavResources.mat')
            temp=load ('behavResources.mat', 'FreezeEpoch');
            FreezeAccEpoch=temp.FreezeEpoch;
            MouseListC{a}=Mousename;a=a+1;
        else
            try
            temp=load ('behavResources.mat', 'MovAcctsd','FreezeAccEpoch');
            MovAcctsd=temp.MovAcctsd;
            FreezeAccEpoch=temp.FreezeAccEpoch;
            MouseListC{a}=Mousename;a=a+1;
            catch
                MovAcctsd_ok=0;
                MouseListC_NoMovAcctsd{b}=Mousename;b=b+1;
            end
        end
        if MovAcctsd_ok
            try
                temp=load ('behavResources.mat', 'csm','csp');
                csp=temp.csp;
                csm=temp.csm;
            catch
                temp=load ('behavResources.mat', 'TTL');
                TTL=temp.TTL;
                DiffTimes=diff(TTL(:,1));
                ind=DiffTimes>2;
                times=TTL(:,1);
                event=TTL(:,2);
                CStimes=times([1; find(ind)+1]);  %temps du premier TTL de chaque s�rie de son
                CSevent=event([1; find(ind)+1]);  %valeur du premier TTL de chaque s�rie de son (CS+ ou CS-)

                %d�finir CS+ et CS- selon les groupes
                m=Mousename(2:4);
               if sum(strcmp(num2str(m),CSplu_bip_Gp))==1
                    CSpluCode=4; %bip
                    CSminCode=3; %White Noise
               elseif sum(strcmp(num2str(m),CSplu_WN_Gp))==1
                    CSpluCode=3;
                    CSminCode=4;
               end
                csp=CStimes(CSevent==CSpluCode);
                csm=CStimes(CSevent==CSminCode);
                save behavResources csp csm CStimes CSevent CSminCode CSpluCode -Append
            end

            if isempty(strfind(Dir.path{man}, 'HABgrille')) % EXT-24

                if strcmp(CSoption, 'AllCS avg2by2')
                    try
                        for k=0:1 % CS- [1 3] et [2 4]
                            Epoch1=union(shift(PreInt,csm(k+1)*1E4),shift(PreInt,csm(k+3)*1E4));
                            Epoch2=union(shift(SoundInt,csm(k+1)*1E4),shift(SoundInt,csm(k+3)*1E4));
                            Epoch3=union(shift(PostInt,csm(k+1)*1E4),shift(PostInt,csm(k+3)*1E4));    
                            eval(['f' num2str(k) '=[length(Data(Restrict(MovAcctsd,and(FreezeAccEpoch,Epoch1))))/length(Data(Restrict(MovAcctsd,Epoch1))),'...
                                                   'length(Data(Restrict(MovAcctsd,and(FreezeAccEpoch,Epoch2))))/length(Data(Restrict(MovAcctsd,Epoch2))),'...
                                                   'length(Data(Restrict(MovAcctsd,and(FreezeAccEpoch,Epoch3))))/length(Data(Restrict(MovAcctsd,Epoch3)))];']);
                        end
                        for k=0:1 % CS+ [1 3] et [2 4]
                            Epoch1=union(shift(PreInt,csp(k+1)*1E4),shift(PreInt,csp(k+3)*1E4));
                            Epoch2=union(shift(SoundInt,csp(k+1)*1E4),shift(SoundInt,csp(k+3)*1E4));
                            Epoch3=union(shift(PostInt,csp(k+1)*1E4),shift(PostInt,csp(k+3)*1E4));    
                            eval(['f' num2str(k+2) '=[length(Data(Restrict(MovAcctsd,and(FreezeAccEpoch,Epoch1))))/length(Data(Restrict(MovAcctsd,Epoch1))),'...
                                                   'length(Data(Restrict(MovAcctsd,and(FreezeAccEpoch,Epoch2))))/length(Data(Restrict(MovAcctsd,Epoch2))),'...
                                                   'length(Data(Restrict(MovAcctsd,and(FreezeAccEpoch,Epoch3))))/length(Data(Restrict(MovAcctsd,Epoch3)))];']);
                        end
                        for k=0:1 % CS+ [5 7] et [6 8]
                            Epoch1=union(shift(PreInt,csp(k+5)*1E4),shift(PreInt,csp(k+7)*1E4));
                            Epoch2=union(shift(SoundInt,csp(k+5)*1E4),shift(SoundInt,csp(k+7)*1E4));
                            Epoch3=union(shift(PostInt,csp(k+5)*1E4),shift(PostInt,csp(k+7)*1E4));    
                            eval(['f' num2str(k+4) '=[length(Data(Restrict(MovAcctsd,and(FreezeAccEpoch,Epoch1))))/length(Data(Restrict(MovAcctsd,Epoch1))),'...
                                                   'length(Data(Restrict(MovAcctsd,and(FreezeAccEpoch,Epoch2))))/length(Data(Restrict(MovAcctsd,Epoch2))),'...
                                                   'length(Data(Restrict(MovAcctsd,and(FreezeAccEpoch,Epoch3))))/length(Data(Restrict(MovAcctsd,Epoch3)))];']);
                        end
                        for k=0:1 % CS+ [9 11] et [10 12]
                            Epoch1=union(shift(PreInt,csp(k+9)*1E4),shift(PreInt,csp(k+11)*1E4));
                            Epoch2=union(shift(SoundInt,csp(k+9)*1E4),shift(SoundInt,csp(k+11)*1E4));
                            Epoch3=union(shift(PostInt,csp(k+9)*1E4),shift(PostInt,csp(k+11)*1E4));    
                            eval(['f' num2str(k+6) '=[length(Data(Restrict(MovAcctsd,and(FreezeAccEpoch,Epoch1))))/length(Data(Restrict(MovAcctsd,Epoch1))),'...
                                                   'length(Data(Restrict(MovAcctsd,and(FreezeAccEpoch,Epoch2))))/length(Data(Restrict(MovAcctsd,Epoch2))),'...
                                                   'length(Data(Restrict(MovAcctsd,and(FreezeAccEpoch,Epoch3))))/length(Data(Restrict(MovAcctsd,Epoch3)))];']);
                        end

                    catch
                        if strcmp(Dir.path{man},'/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse459/20161019-EXT-24h-laser10') % experiment interrupted by error

                        else
                            keyboard
                        end
                    end   

                elseif strcmp(CSoption, '4firstCS not averaged')
                    try
                        for k=0:3
                        eval(['f' num2str(k) '=[length(Data(Restrict(MovAcctsd,and(FreezeAccEpoch,shift(PreInt,csm(' num2str(k) '+1)*1E4)))))/length(Data(Restrict(MovAcctsd,shift(PreInt,csm(' num2str(k) '+1)*1E4)))),'...
                            'length(Data(Restrict(MovAcctsd,and(FreezeAccEpoch,shift(SoundInt,csm(' num2str(k) '+1)*1E4)))))/length(Data(Restrict(MovAcctsd,shift(SoundInt,csm(' num2str(k) '+1)*1E4)))),'...
                            'length(Data(Restrict(MovAcctsd,and(FreezeAccEpoch,shift(PostInt,csm(' num2str(k) '+1)*1E4)))))/length(Data(Restrict(MovAcctsd,shift(PostInt,csm(' num2str(k) '+1)*1E4))))];']);
                        end
                        for k=0:3
                        eval(['f' num2str(k+4) '=[length(Data(Restrict(MovAcctsd,and(FreezeAccEpoch,shift(PreInt,csp(' num2str(k) '+1)*1E4)))))/length(Data(Restrict(MovAcctsd,shift(PreInt,csp(' num2str(k) '+1)*1E4)))),'...
                            'length(Data(Restrict(MovAcctsd,and(FreezeAccEpoch,shift(SoundInt,csp(' num2str(k) '+1)*1E4)))))/length(Data(Restrict(MovAcctsd,shift(SoundInt,csp(' num2str(k) '+1)*1E4)))),'...
                            'length(Data(Restrict(MovAcctsd,and(FreezeAccEpoch,shift(PostInt,csp(' num2str(k) '+1)*1E4)))))/length(Data(Restrict(MovAcctsd,shift(PostInt,csp(' num2str(k) '+1)*1E4))))];']);
                        end

                    catch
                        if strcmp(Dir.path{man},'/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse459/20161019-EXT-24h-laser10')
                            f6=nan(1,3);
                            f7=nan(1,3);
                        end
                    end
                end

            end

            if ~isempty(strfind(Dir.path{man}, StepName{1})) % EXT-24
                disp(StepName{1})
                 for k=0:7
                     eval(['C' num2str(k) '=[C' num2str(k) ';f' num2str(k) '];']);
                 end
                 MouseList{a1,1}=Mousename;a1=a1+1;
                 MouseNbList{:,1}=[MouseNbList{:,1};MouseNb];

            elseif ~isempty(strfind(Dir.path{man}, StepName{2})) % EXT-48
                disp(StepName{2})
                for k=0:7
                    eval(['P' num2str(k) '=[P' num2str(k) ';f' num2str(k) '];']);
                end
                MouseList{a2,2}=Mousename;a2=a2+1;
                MouseNbList{:,2}=[MouseNbList{:,2};MouseNb];

            elseif ~isempty(strfind(Dir.path{man}, StepName{3})) % EXT-72
                disp(StepName{3})
                for k=0:7
                    eval(['E' num2str(k) '=[E' num2str(k) ';f' num2str(k) '];']);                
                end
                MouseList{a3,3}=Mousename;a3=a3+1;
                MouseNbList{:,3}=[MouseNbList{:,3};MouseNb];

            end

            if man<length(Dir.path)
                if strcmp(Dir.name{man+1}(end-2:end),Dir.name{man}(end-2:end))% same mouse, following recording
                else
                    i=i+1;
                end
            end
        
        end % end of MovAcctsd_ok
    end        
            cd(res)
            disp(['Saving data in local path' ]);
            if ~isdir([ res '/FreezAcctsdPSTH_ChR2'])
                mkdir([ res '/FreezAcctsdPSTH_ChR2']);
            end
            try
                save ([res '/FreezAcctsdPSTH_ChR2/PSTH_behav_' manipname '_' num2str(SndDur) 's'],'C','P','E', 'C0','C1','C2', 'C3','C4','C5','C6','C7','P0','P1','P2','P3','P3','P4','P5','P6','P7','E0','E1','E2','E3','C3','E4','E5','E6','E7',...
                'csm','csp','CStimes','CSevent','times','event','MouseListC','TTL','StepName','ColorPSTH', 'CSoption','MouseListC_NoMovAcctsd','MouseList','MouseNbList')
            catch
                try
                    save ([res '/FreezAcctsdPSTH_ChR2/PSTH_behav_' manipname '_' num2str(SndDur) 's'],'C','P','E', 'C0','C1','C2', 'C3','C4','C5','C6','C7','P0','P1','P2','P3','P3','P4','P5','P6','P7','E0','E1','E2','E3','C3','E4','E5','E6','E7',...
                    'csm','csp','MouseListC','StepName','ColorPSTH', 'CSoption','MouseListC_NoMovAcctsd','MouseList','MouseNbList')
                catch
                    keyboard
                end
            end



end % end of catch
% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% PSTH : comparison PRE/ DURING/POST sound %%%%%%%%%%%%%%%%%%%%%%%%%%

%load PSTHdata
%load FreezAcctsdPSTH_ChR2/PSTH_behav_LaserChR2-fear StepName CSoption
try
    %load FreezAcctsdPSTH_ChR2/PSTH_behav_LaserChR2-fear 
    load([res '/FreezAcctsdPSTH_ChR2/PSTH_behav_' manipname  '_' num2str(SndDur) 's' ])
catch
    load PSTH_behav_LaserChR2-fear 
end
% PreSound=[65:80]; % 15sec before sound
% Sound=[81:95]; % 15sec  
% %Sound=[81:110]; % 30sec  
% PostSound=[111:125];


QuantifFig=figure('Color',  [1 1 1], 'Position',[ 8  91  1819 887]);
n=4; p=3; a=1;
Mx={'C','P','E'};
if strcmp(CSoption,'4firstCS not averaged')
    ylabels={'first CS- pair';'second CS- pair';'first CS+ pair';'second CS+ pair'};
elseif strcmp(CSoption,'AllCS avg2by2')
    ylabels={'CS- pairs';' CS+ pairs 1:4';'CS+ pairs 5:8';'CS+ pairs 8:12'};
end

for m=1:length(StepName)
    for k=0:2:6
        sub{a}=subplot(n,p,3*(k/2)+m);
        
        hold on
        
        eval(['PlotErrorbarN([' Mx{m} num2str(k) ' ' Mx{m} num2str(k+1) '],0,2);']);
        
        eval(['p_off=signrank(' Mx{m} num2str(k) '(:,1),' Mx{m} num2str(k) '(:,2));']);
        eval(['p_on=signrank(' Mx{m} num2str(k+1) '(:,1),' Mx{m} num2str(k+1) '(:,2));']);
        
        eval(['p_snd=signrank(' Mx{m} num2str(k) '(:,2),' Mx{m} num2str(k+1) '(:,2));']);
        eval(['p_post=signrank(' Mx{m} num2str(k) '(:,3),' Mx{m} num2str(k+1) '(:,3));']);

        ylim([0 1]);
        YL=ylim;
        text(1.5,0.7*YL(2),sprintf('%.2f',(p_off)),'Color','r'), line([1 2],[0.6*YL(2) 0.6*YL(2)],'Color','r');
        text(4.5,0.7*YL(2),sprintf('%.2f',(p_on)),'Color','r'), line([4 5],[0.6*YL(2) 0.6*YL(2)],'Color','r');
        text(3.5,1*YL(2),sprintf('%.2f',(p_snd)),'Color','b'), line([2 5],[0.92*YL(2) 0.92*YL(2)],'Color','b');
        text(4.5,0.87*YL(2),sprintf('%.2f',(p_post)),'Color','b'), line([3 6],[0.8*YL(2) 0.8*YL(2)],'Color','b');

        set(gca,'XTick',[1:6],'XTickLabel',{'Pre','Snd','Post','Pre','Snd','Post'});
        a=a+1;
        if k==0
            title(StepName{m})
        end
        if k==6
            xlabel(['n = ' num2str(size((MouseNbList{:,m}),1)) ' exp'])
        end
        ylabel(ylabels{k/2+1});
    end
end

subplot(sub{1})
text(-0.3,1.3,'FreezAcc','units','normalized')
text(-0.3,1.4,CSoption,'units','normalized')
text(-0.3,1.1,['snd ' num2str(SndDur) ' sec'],'units','normalized')

set(gcf,'PaperPosition',[ 0  0 27 18])
res=pwd;
saveas(gcf,['FreezAccPrePost_Sound' num2str(SndDur) 'sec_' StepName{1}(1:3) '_' CSoption(1:5) '.fig'])
saveas(gcf,['FreezAccPrePost_Sound' num2str(SndDur) 'sec_' StepName{1}(1:3) '_' CSoption(1:5)  '.png'])
saveFigure(QuantifFig,['FreezAccPrePost_Sound' num2str(SndDur)  's_' StepName{1}(1:3) '_' CSoption(1:5) ],res)   

% save subplot 
save([res '/FreezAcctsdPSTH_ChR2/PSTH_behav_' manipname '_' num2str(SndDur) 's'],'sub','-Append');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
