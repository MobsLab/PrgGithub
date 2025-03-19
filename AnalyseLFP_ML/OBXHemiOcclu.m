% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%  MANUAL INPUTS  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Mice to include
Mice=[241 242 245 246];
ExpeType='Fear';% Fear or Sleep

% structures from ChannelsToAnalyse to include
structlist={'Bulb_deep','PFCx_deep','dHPC','Amyg'};%
getChans={'ChannelsToAnalyse','ChannelsToAnalyse-hemiOBX'};

% parameters to calculate freezing periods
th_immob=1.5; % default 1
thtps_immob=2; % minimum 2 sec of immobility

% parameters for spectrogram calculation
spectrType='Low'; % default: Low;  High

% don't change those parameters
params.Fs=1250;
if strcmp(spectrType,'High');
    params.tapers=[1,2];
    movingwin=[0.1 0.005];
    params.fpass=[20 200];
    XL=[20 200];
elseif strcmp(spectrType,'Low');
    params.tapers=[3 5];
    movingwin=[3 0.2];
    params.fpass=[0 50];
    XL=[0 20];
end

%plot figures
PloAllSpectFreez=1;
PloMeanSpec=0;
colori={'r','m','b','c','r','m','b','c'};


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%  GET EXPERIMENTS  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(ExpeType,'Sleep') % test on 245 246
    clear Dir
    a=0;
    for mi=1:length(Mice)
        a=a+1;
        Dir.path{a}=['/media/DataMOBsRAID/ProjetAstro/Mouse',num2str(Mice(mi)),'/20150326/BULB-Mouse-245-246-26032015'];
        Dir.manipe{a}='SleepBasal';Dir.name{a}=['Mouse',num2str(Mice(mi))];Dir.group{a}='hemiOBX';
        a=a+1; 
        Dir.path{a}=['/media/DataMOBsRAID/ProjetAstro/Mouse',num2str(Mice(mi)),'/20150327/BULB-Mouse-245-246-27032015'];
        Dir.manipe{a}='SleepBasal';Dir.name{a}=['Mouse',num2str(Mice(mi))]; Dir.group{a}='hemiOBX';
        a=a+1;
        Dir.path{a}=['/media/DataMOBsRAID/ProjetAstro/Mouse',num2str(Mice(mi)),'/20150409/BULB-Mouse-245-246-09042015'];
        Dir.manipe{a}='SleepOcclu';Dir.name{a}=['Mouse',num2str(Mice(mi))];Dir.group{a}='hemiOBX';
        a=a+1;
        Dir.path{a}=['/media/DataMOBsRAID/ProjetAstro/Mouse',num2str(Mice(mi)),'/20150410/SLEEP/BULB-Mouse-245-246-10042015'];
        Dir.manipe{a}='SleepOcclu';Dir.name{a}=['Mouse',num2str(Mice(mi))];Dir.group{a}='hemiOBX';
    end
    
elseif strcmp(ExpeType,'Fear')
    Dir=PathForExperimentFEAR('Fear-electrophy'); % takes only chosen mice from it
    
    index1=[];
    for i=1:length(Dir.path)
        if ismember(str2double(Dir.name{i}(6:8)),Mice)
            index1=[index1 i];
        end
    end
    
    Dir.path=Dir.path(index1);
    Dir.manipe=Dir.manipe(index1);
    Dir.name=Dir.name(index1);
    Dir.group=Dir.group(index1);
end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%  GET SPECTRA  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if PloAllSpectFreez
    for g=1:length(getChans), for i=1:length(structlist)
            Allfig(g,i)=figure('Color', [1 1 1], 'Position', [800 300 900 600]);
    end; end
end

if PloMeanSpec, for mi=1:length(Mice), Mfig(mi)=figure('Color', [1 1 1], 'Position', [800 300 900 600]);end;end
for man=1:length(Dir.path)
    
    disp(' '),disp(' '), disp(Dir.path{man})
    
    % ---------------------------------------------------------------------
    % ------------------------ LOAD EPOCHS --------------------------------
    % StateEpoch
    disp('Loading StateEpoch.mat ...')
    temp2=load([Dir.path{man},'/StateEpoch.mat']);
    try
        NoiseEp=or(temp2.NoiseEpoch,temp2.GndNoiseEpoch);
        NoiseEp=or(NoiseEp,temp2.WeirdNoiseEpoch);
    catch
        disp('Problem : noise epoch not defined')
        NoiseEp=intervalSet([],[]);
    end
    SWSEpoch=temp2.SWSEpoch - NoiseEp;
    MovEpoch=temp2.MovEpoch - NoiseEp;
    REMEpoch=temp2.REMEpoch - NoiseEp;
    
    % FreezeEpoch
    disp('Loading FreezeEpoch from /behavResources.mat ...')
    clear temp2
    eval(['temp2=load(''',Dir.path{man},'/behavResources.mat'',''FreezeEpoch'',''Movtsd'');']);
    try
        Movtsd=temp2.Movtsd; %, attention valable seulement pour file comportment car fichier sleep= doubletracking=pixratio pas appliqué
        FreezeEpoch=thresholdIntervals(Movtsd,th_immob,'Direction','Below');
        FreezeEpoch=mergeCloseIntervals(FreezeEpoch,0.3*1E4);
        FreezeEpoch=dropShortIntervals(FreezeEpoch,thtps_immob*1E4);
        FreezeEpoch=FreezeEpoch - NoiseEp;
    catch
        FreezeEpoch=intervalSet([],[]);
    end
    clear SOepoch Epoch
    
    % ---------------------------------------------------------------------
    % ---------------------------------------------------------------------
    
    hRfig=figure('Color', [1 1 1], 'Position', [800 300 900 600]);

    for g=1:length(getChans)
        
        for i=1:length(structlist)
            
            disp(['    ',getChans{g},'/',structlist{i}])
            clear Sp t Stsd
            try
                if strcmp(structlist{i},'dHPC')
                    try tempt=load([Dir.path{man},'/',getChans{g},'/dHPC_sup.mat']);if ~isempty(tempt.channel);temp=tempt;end;end
                    try tempt=load([Dir.path{man},'/',getChans{g},'/dHPC_deep.mat']);if ~isempty(tempt.channel);temp=tempt;end;end
                    try tempt=load([Dir.path{man},'/',getChans{g},'/dHPC_rip.mat']);if ~isempty(tempt.channel);temp=tempt;end;end
                else
                    temp=load([Dir.path{man},'/',getChans{g},'/',structlist{i},'.mat']);
                end
                %disp(num2str(temp.channel))
                if isempty(temp.channel) || isnan(temp.channel),error;end
                
                
                try
                    load([Dir.path{man},'/SpectrumData',spectrType(1),'/Spectrum' num2str(temp.channel),'.mat'],'Sp', 't', 'f') % t en secondes
                    disp(['SpectrumData',spectrType(1),'/Spectrum' num2str(temp.channel),'... loaded'])
                catch
                    if ~exist([Dir.path{man},'/SpectrumData',spectrType(1),''],'dir'), mkdir([Dir.path{man},'/SpectrumData',spectrType(1)]);end
                    eval(['temp2=load(''',Dir.path{man},'/LFPData/LFP',num2str(temp.channel),'.mat'');'])
                    disp(['Computing SpectrumData',spectrType(1),'/Spectrum' num2str(temp.channel),'... '])
                    [Sp,t,f]=mtspecgramc(Data(temp2.LFP),movingwin,params);
                    eval(['save(''',Dir.path{man},'/SpectrumData',spectrType(1),'/Spectrum',num2str(temp.channel),'.mat'',','''Sp'',','''t'',','''f'');'])
                end
                Stsd=tsd(t*1E4,Sp);
                
                % HighBOoscillation
                if g==1 && i==1
                    if strcmp(spectrType,'High'); 
                       try
                           tempBO=load([Dir.path{man},'/SpectrumDataL/Spectrum' num2str(temp.channel),'.mat'],'Sp', 't', 'f');
                            [Epoch,val,val2]=FindSlowOscBulb(tempBO.Sp,tempBO.t,tempBO.f,SWSEpoch,0);SOepoch=Epoch{9};
                       end
                    else
                        try [Epoch,val,val2]=FindSlowOscBulb(Sp,t,f,SWSEpoch,0);SOepoch=Epoch{9};end
                    end
                    if ~exist('SOepoch','var'),SOepoch=intervalSet([],[]);end
                    disp(['<><><><> SWS = ',num2str(floor(tot_length(SWSEpoch,'s'))),...
                        's <><><><> SOB = ',num2str(floor(tot_length(SOepoch,'s'))),'s <><><><>']);
                end
                
            catch
                disp(['No or empty /',getChans{g},'/',structlist{i},'... skip'])
            end
            
            if PloAllSpectFreez && exist('Stsd','var')
                % spetrum restricted on FreezeEpoch
                [tEpoch, SpEpoch]=SpectroEpochML(Sp,t,f,FreezeEpoch,0);
                figure(Allfig(g,i)), subplot(ceil(sqrt(length(Dir.path))),ceil(sqrt(length(Dir.path))),man)
                imagesc(tEpoch,f,10*log10(SpEpoch')), axis xy, caxis([15 65])
                title([Dir.group{man},' ',Dir.path{man}(end-30:end)]), ylabel('Frequency (Hz)'); xlabel('Time (s)')
                ylim(XL); if man==1, text(0,22.5,[getChans{g},'/',structlist{i}]);end;  xlim([0 200])
                hold on, line([0 200],[5 5],'Color',[0.5 0.5 0.5])
            end
            if PloMeanSpec && exist('Stsd','var')
                figure(Mfig(find(Mice==str2double(Dir.name{man}(6:8))))),
                subplot(4,length(structlist),length(structlist)*(g-1)+i),
                hold on, plot(f,mean(Data(Restrict(Stsd,SWSEpoch))),'Color',colori{man},'Linewidth',2);xlim(XL)
                hold on, plot(f,mean(Data(Restrict(Stsd,SOepoch))),'Color',colori{man},'LineStyle','--','Linewidth',2); xlim(XL)
                if g==1,  title(structlist{i});end
                subplot(4,length(structlist),length(structlist)*(g+1)+i), 
                hold on, plot(f,10*mean(log10(Data(Restrict(Stsd,SWSEpoch)))),'Color',colori{man},'Linewidth',2); xlim(XL);ylim([25 60])
                hold on, plot(f,10*mean(log10(Data(Restrict(Stsd,SOepoch)))),'Color',colori{man},'LineStyle','--','Linewidth',2); xlim(XL);ylim([25 60])
                if i==1, legend({'SWS','SOB','SWS','SOB','SWS-Occ','SOB-Occ','SWS-Occ','SOB-Occ'});end
            end
            
        end
    end
    
end


% save figures
if PloAllSpectFreez
    for g=1:length(getChans),
        for i=1:length(structlist),
            saveFigure(Allfig(g,i),['BilanFreezing_',structlist{i},'_',getChans{g}],pwd);
        end
    end
end



