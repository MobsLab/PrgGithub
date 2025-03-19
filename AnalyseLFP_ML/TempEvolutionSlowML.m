function [SpL,fL,MatEpochs,Slow,USlow,NewtsdZT]=TempEvolutionSlowML(varargin)

% TempEvolutionSlowML.m
%
% [SpL,fL,MatEpochs,AllZT,SpSlow,SpUSlow,NewtsdZT]=TempEvolutionSlowML('Structure',...
% 'PFCx_deep','movingwin',[5 0.2],'params',params,'SOfreq',[1 4]);
%
% inputs:
% 'Directory', dir = folder where to proceed analysis (default =pwd)
% 'Structure', StructureDelta = look in InfoLFP.mat (default = PFCx_deep)
% 'movingwin', movingwinL = see SpectrumParametersML.m
% 'params', paramsL =  see SpectrumParametersML.m
% 'SOfreq',freqSlow = slow oscillations band
% 'uSOfreq',freqUSlow = ultraslow oscillation to clean spectrum

% outputs:
%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%  INITIALIZATION  %%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('TempEvolutionSlowML.m')
res=pwd;
dirpath=res;
StructureDelta='PFCx_deep';
[paramsL,movingwinL]=SpectrumParametersML('low',0);
freqSlow=[2 4];
freqUSlow=[0.5 1.5];

% Check number of parameters
if nargin < 3 | mod(length(varargin),2) ~= 0,
  error('Incorrect number of parameters.');
end

% Parse parameter list
for i = 1:2:length(varargin),
	if ~isa(varargin{i},'char'),
		error(['Parameter ' num2str(i+2) ' is not a property.']);
	end
	switch(lower(varargin{i})),
		case 'directory',
			dirpath = varargin{i+1};
		case 'structure',
			StructureDelta = varargin{i+1};
		case 'epochs',
			EpochsArr = varargin{i+1};
        case 'movingwin',
			movingwinL = varargin{i+1};
        case 'params',
			paramsL = varargin{i+1};
        case 'sofreq',
			freqSlow = varargin{i+1};
        case 'usofreq',
			freqUSlow = varargin{i+1};
		otherwise,
			error(['Unknown property ''' num2str(varargin{i}) '''.']);
	end
end

cd(dirpath)


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%  load epochs  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~exist('EpochsArr','var')
    disp('...Loading epochs')
    clear PreEpoch MovEpoch Wake REMEpoch SWSEpoch GndNoiseEpoch WeirdNoiseEpoch NoiseEpoch TotalNoiseEpoch
    try
        load StateEpoch.mat REMEpoch SWSEpoch MovEpoch NoiseEpoch GndNoiseEpoch WeirdNoiseEpoch
        Wake=MovEpoch;SWSEpoch;
    catch
        load StateEpochSB.mat REMEpoch SWSEpoch Wake NoiseEpoch GndNoiseEpoch WeirdNoiseEpoch
    end
    TotalNoiseEpoch=and(GndNoiseEpoch,NoiseEpoch);
    if exist('WeirdNoiseEpoch','var'), TotalNoiseEpoch=and(TotalNoiseEpoch,WeirdNoiseEpoch);end
    
    load behavResources.mat PreEpoch
    if exist('PreEpoch','var')
        Wake=and(Wake,PreEpoch);
        SWSEpoch=and(SWSEpoch,PreEpoch);
        REMEpoch=and(REMEpoch,PreEpoch);
    end
    EpochsArr{1}=Wake-TotalNoiseEpoch;
    EpochsArr{2}=SWSEpoch-TotalNoiseEpoch;
    EpochsArr{3}=REMEpoch-TotalNoiseEpoch;    
end


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%  compute Low Spec  %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

try
    disp('... Spectrum Low frequency')
    clear channel LFP Sp t f
    
    % get channel
    disp(['        Loading channel from ChannelsToAnalyse/',StructureDelta,'.mat'])
    eval(['load(''',dirpath,'/ChannelsToAnalyse/',StructureDelta,'.mat'',''channel'');'])
    
    try
        % load spectrum if exists
        disp(['        Loading SpectrumDataL/Spectrum',num2str(channel),'.mat'])
        eval(['load(''',dirpath,'/SpectrumDataL/Spectrum',num2str(channel),'.mat'');'])
        Sp; t; f;
    catch
        % load LFP
        disp('        Not found. Creating')
        disp(['        Loading LFPData/LFP',num2str(channel),'.mat'])
        eval(['load(''',dirpath,'/LFPData/LFP',num2str(channel),'.mat'');'])
        
        % compute spectrum
        disp('        Computing mtspectrum')
        [Sp,t,f]=mtspecgramc(Data(LFP),movingwinL,paramsL);
        
        % saving
        disp('        Saving in SpectrumDataL')
        movingwin=movingwinL;
        params=paramsL;
        fileSp=[dirpath,'/SpectrumDataL'];
        if ~exist([fileSp,'dir']), mkdir(fileSp);end
        eval(['save(''',dirpath,'/SpectrumDataL/Spectrum',num2str(channel),'.mat''',...
            ',''-v7.3'',''Sp'',''t'',''f'',''params'',''movingwin'');']);
    end
    fL=f;
    SpL=tsd(t*1E4,Sp);
    
catch
    disp('Problem Spectrum')
    
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%  TimeEndRec  %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

try
    if 1
        NewtsdZT=GetZT_ML(dirpath);
        
    else
        clear TimeDebRec TimeEndRec tpsdeb tpsfin  tdebR dur dosave
        
        load behavResources.mat TimeEndRec tpsdeb tpsfin
        tfinR=TimeEndRec*[3600 60 1]';
        for ti=1:length(tpsdeb)
            dur(ti)=tpsfin{ti}-tpsdeb{ti};
            tdebR(ti)=tfinR(ti)-dur(ti);
            if ti>1 && tdebR(ti)<=tfinR(ti-1)
                %disp([tfinR(ti-1),tdebR(ti)]);
                tdebR(ti)=tfinR(ti-1)+1;
                dosave=1;
            end
        end
        
        if exist('dosave','var')
            disp('TimeDebRec are too early... redefining');
            TimeDebRec=[floor(tdebR/3600) floor(rem(tdebR,3600)/60) rem(rem(tdebR,3600),60)];
            %save behavResources -append TimeDebRec
        end
        %---------------  load ZT or Recalculate and save  -----------
        clear NewtsdZT tpsRef
        try
            load behavResources NewtsdZT
            Range(NewtsdZT);
            
        catch
            disp('-> Calculating tsdZT and saving in behavResources')
            load LFPData/InfoLFP InfoLFP
            eval(['load(''LFPData/LFP',num2str(InfoLFP.channel(1)),'.mat'',''LFP'');']);
            tpsRef=Range(LFP)';
            tim=[]; ZT=[];
            for ttt=1:length(tpsdeb)
                tim_temp=tpsRef(tpsRef>=1E4*tpsdeb{ttt} & tpsRef<1E4*tpsfin{ttt});
                if tpsdeb{ttt}~=tpsfin{ttt}
                    %ZT_temp= interp1([tpsdeb{ttt},tpsfin{ttt}],[tdebR(ttt) tfinR(ttt)],tim_temp);
                    ZT_temp=tim_temp-1E4*tpsdeb{ttt}+1E4*tdebR(ttt);
                    tim=[tim,tim_temp]; ZT=[ZT,ZT_temp];
                    if ~issorted(ZT);
                        disp(['problem, TimeEndRec unsorted. original nb of time = ',num2str(length(ZT))]);
                        while ~issorted(ZT)
                            ind=min(find(diff(ZT)<=0));
                            tim(ind:min(find(ZT>ZT(ind))))=[];
                            ZT(ind:min(find(ZT>ZT(ind))))=[];
                        end;
                        disp(['                              now nb of time = ',num2str(length(ZT))]);
                    end
                end
            end
            
            NewtsdZT=tsd(tim',ZT');
            save behavResources -append NewtsdZT
        end
    end
catch
    disp('Problem computing ZT')
    keyboard
end
cd(res)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%  Final outpus  %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear Slow
% --------  Restrict on freqSlow  ---------
Slow=tsd(t*1E4,mean(Sp(:,find(f>freqSlow(1)&f<freqSlow(2))),2));
USlow=tsd(t*1E4,mean(Sp(:,find(f>freqUSlow(1)&f<freqUSlow(2))),2));

for i=1:length(EpochsArr)
    % save Epochs 
    MatEpochs{i}=EpochsArr{i};
end

    
