% LFPspectrum_allchannels.m

%% --- manual inputs ------
NameDir = 'BASAL';
StructureName = 'Bulb';
NameEpoch = 'SWSEpoch';
NameInjectionEpoch = 'PreEpoch';
HighOrLowSpec = 'L';
depthoption='deep';%'sup'

Domtspectrumc=0; % ne pas utiliser sur subEpochs
CorrectionAmplifier=1;
pval=0.05;
smoFact=2; %default 10


%% initialisation variables
if strcmp(NameDir,'PLETHYSMO')
    res='/media/DataMOBsRAID/ProjetAstro-DataPlethysmo';
else
    res='/media/DataMOBsRAID/ProjetAstro';
end
FolderTosave=[res,'/AnalyseLFPspectrum',HighOrLowSpec,'/',StructureName,'ALL'];
if ~exist(FolderTosave,'dir'), mkdir(FolderTosave);end

Dir=PathForExperimentsML(NameDir);
strains=unique(Dir.group);
MiceNames=unique(Dir.name);
scrsz = get(0,'ScreenSize');

%% does this analazis exist already? 
disp(' ')
ANALYNAME=[FolderTosave,'/StrainsLFPspectr',NameDir,NameEpoch];
try
    load([ANALYNAME,'.mat']);  
    eval(['MatrixSp=MatrixSp',StructureName,';'])
    eval(['MatrixSpGroup=MatrixSpGroup',StructureName,';']);    
    disp([ANALYNAME,'.mat already exists...'])
    ErasePreviousAnalysis=0;
catch
    ErasePreviousAnalysis=1; 
    disp(['Saving analysis in ',ANALYNAME,'.mat'])
end



%% Calculating spectrogram

% ------ parameters spectro ------
if isempty(strfind(NameDir,'PLETHYSMO'))
    params.Fs=1250;
else
    params.Fs=1000;
end
params.trialave=0;
params.err=[1 0.0500]; params.pad=2;

if HighOrLowSpec=='H'
    movingwin=[0.1 0.005];
    params.fpass=[20 200];
    params.tapers=[1,2];
else
    params.fpass=[0.01 20];
    movingwin=[3 0.2];
    params.tapers=[3 5];
    %params.tapers=[1 2];
end

if ErasePreviousAnalysis
    save([ANALYNAME,'.mat'],'NameDir','StructureName','NameEpoch','Dir')
    
    disp('... Loading or calculating Spectrum for all experiments in Dir')
    expe=0;
    for man=1:length(Dir.path)
        nameMan=Dir.path{man}(max(strfind(Dir.path{man},'Mouse')):end);
        disp(' ')
        disp(['           * * * ',nameMan,' * * *'])
        
        % --------------------
        % ------ EPOCHS ------
        clear REMEpoch SWSEpoch MovEpoch ImmobEpoch SniffEpoch BasalBreathEpoch SWS1hEpoch
        clear epoch NoiseEpoch GndNoiseEpoch WeirdNoiseEpoch
        load([Dir.path{man},'/StateEpoch.mat'],'REMEpoch','ThetaEpoch','SWSEpoch','MovEpoch','ImmobEpoch','NoiseEpoch','GndNoiseEpoch','WeirdNoiseEpoch')
        try load([Dir.path{man},'/SWS1hEpoch.mat'],'SWS1hEpoch');end
        
        clear PreEpoch VEHEpoch DPCPXEpoch LPSEpoch CPEpoch
        try
            load([Dir.path{man},'/behavResources.mat'],NameInjectionEpoch)
        catch
            disp(['Warning: No ',NameInjectionEpoch,' defined in behavResources.mat'])
            eval([NameInjectionEpoch,'=',NameEpoch,';'])
        end
        
        if ~exist('WeirdNoiseEpoch','var'); WeirdNoiseEpoch=intervalSet([],[]);disp('No WeirdNoiseEpoch');end
        if ~exist('NoiseEpoch','var'); NoiseEpoch=intervalSet([],[]); disp('No NoiseEpoch');end
        if ~exist('GndNoiseEpoch','var'); GndNoiseEpoch=intervalSet([],[]);disp('No GndNoiseEpoch');end
        
        if ~isempty(strfind(NameEpoch,'Sniff')) || ~isempty(strfind(NameEpoch,'BasalBreath'))
            load([Dir.path{man},'/StateEpoch.mat'],'SniffEpoch','BasalBreathEpoch')
        end
        
        eval(['epoch=and(',NameEpoch,'-NoiseEpoch-GndNoiseEpoch-WeirdNoiseEpoch,',NameInjectionEpoch,');'])
        disp(['Time in and(',NameEpoch,',',NameInjectionEpoch,') = ',num2str(sum(Stop(epoch,'s')-Start(epoch,'s'))),'s'])
        
        
        % get info on channels
        clear InfoLFP
        InfoLFP=listLFP_to_InfoLFP_ML(Dir.path{man});
        ld=load([Dir.path{man},'/ChannelsToAnalyse/',StructureName,'_',depthoption,'.mat'],'channel');
        
        % --------------------
        % ----- spectrum -----
       if sum(strcmp(InfoLFP.structure,StructureName))~=0 && ~isempty(Start(epoch))
            
            chans=InfoLFP.channel(strcmp(InfoLFP.structure,StructureName));
            chans=chans(1:min(length(chans),4));
            chans=[ld.channel,chans];
            
            cd(Dir.path{man});
            disp([Dir.group{man},'-',Dir.name{man}(strfind(Dir.name{man},'Mouse')+6:end)])
            
            % ------------------------------------------------------
            FileToSave=[Dir.path{man},'/SpectrumData',HighOrLowSpec];
            if ~exist(FileToSave,'dir'),
                mkdir(Dir.path{man},['SpectrumData',HighOrLowSpec]);
            else
                disp([FileToSave(strfind(FileToSave,'BULB'):end),' already exists.'])
            end
            
            % ------------------------------------------------------
            % -------------- ComputeSpectrogramML ------------------
            % calculate Sp for all LFP
            for ch=1:length(chans)
                num_channel=chans(ch);
                expe=expe+1;
                
                clear Spi ti fi tEpoch SpEpoch
                clear Sp t f LFP LFP_temp
                
                try
                    TempLoad=load([FileToSave,'/Spectrum',num2str(num_channel)],'Sp','t','f','params','movingwin');
                    Spi=TempLoad.Sp; ti=TempLoad.t; fi=TempLoad.f; params_out=TempLoad.params; movingwin_out=TempLoad.movingwin;
                    disp(['... /Spectrum',num2str(num_channel),' has been loaded'])
                catch
                    disp(['... computing and saving /Spectrum',num2str(num_channel)])
                    load([Dir.path{man},'/LFPData/LFP',num2str(num_channel)],'LFP')
                    LFP_temp=ResampleTSD(LFP,params.Fs);
                    [Sp,t,f]=mtspecgramc(Data(LFP_temp),movingwin,params);
                    Spi=Sp; ti=t; fi=f;
                    save([FileToSave,'/Spectrum',num2str(num_channel)],'-v7.3','Sp','t','f','params','movingwin');
                end
                
                % ------------------------------------------------------
                if sum(sum(isnan(Spi)))==0
                    if CorrectionAmplifier
                        Spi=Dir.CorrecAmpli(man)*Spi;
                    end
                    % ------------------------------------------------------
                    % ------------------ SpectroEpochML --------------------
                    % calculate Spectro restricted to epoch
                    clear tEpoch SpEpoch
                    [tEpoch, SpEpoch]=SpectroEpochML(Spi,ti,fi,epoch);
                    % ------------------------------------------------------
                    MatrixSp(expe,:)=resample(nanmean(SpEpoch,1),200,length(nanmean(SpEpoch,1)));
                    fi=resample(fi,200,length(fi));
                else
                    MatrixSp(expe,:)=nan(1,200);
                end
                
                disp(['fi: [',num2str(min(fi)),'-',num2str(max(fi)),']'])
                cd(res)
                
                MatrixSpGroup(expe,:)=[man,find(strcmp(Dir.group{man},strains)),find(strcmp(Dir.name{man},MiceNames)),num_channel];
                Matrixepoch(expe,:)=sum(Stop(epoch,'s')-Start(epoch,'s'));
                
            end

        else
            disp(['no LFP ',StructureName,', skipping this step'])
       end
    end
    
    if size(MatrixSp,1)< length(Dir.path), MatrixSp(size(MatrixSp,1)+1:length(Dir.path),:)=zeros(length(Dir.path)-size(MatrixSp,1),size(MatrixSp,2));end
    % saving in analyname
    eval(['MatrixSp',StructureName,'=MatrixSp;'])
    eval(['MatrixSpGroup',StructureName,'=MatrixSpGroup;']);
    save([ANALYNAME,'.mat'],'fi',['MatrixSp',StructureName],['MatrixSpGroup',StructureName],'Matrixepoch','-append');

end


%% display individual mean spectro

if strcmp(HighOrLowSpec,'L')
    xlim_val=[0 15];
else
    xlim_val=[20 150];
end

colori={'m','k','r','g','b'};
figure('color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/4 scrsz(4)/2]), 
FSp_Individual=gcf;

Y=[];
for man=1:length(Dir.path)
    try nameMan=Dir.path{man}(strfind(Dir.path{man},'BULB'):strfind(Dir.path{man},'BULB')+21); catch, keyboard;end
    if isempty(nameMan), nameMan=Dir.path{man}(strfind(Dir.path{man},'Mouse'):end);end
    
    subplot(5,ceil(length(Dir.path)/5),man)
    index=find(MatrixSpGroup(:,1)==man);
    leg=[];
    for i=1:length(index)
        try
            if sum(MatrixSp(index(i),:))>0
                if i==1 
                    hold on, plot(fi,MatrixSp(index(i),:),colori{i},'linewidth',2);
                else
                    hold on, plot(fi,MatrixSp(index(i),:),colori{i});
                end
                Y=[Y,ylim];
            end
        catch
            keyboard
        end
        leg=[leg,{num2str(MatrixSpGroup(index(i),4))}];
    end
    legend(leg);
    ylabel([NameEpoch,' ',num2str(floor(Matrixepoch(man))),'s']), title(StructureName);
    xlabel([Dir.group{man},'-',nameMan(strfind(nameMan,'Mouse')+6:end)])

end

for man=1:length(Dir.path)
     subplot(5,ceil(length(Dir.path)/5),man)
     try ylim([0 max(Y)]);end
     try xlim(xlim_val);end
end







