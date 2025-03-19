function [meanSpi,freqfi,num_channel,paramsmt]=Compute_mtSpectrumc_newML(params,InfoLFP,nameStructure,epoch,option,HighOrLowSpec)
 
%[meanSpi,freqfi,num_channel,params_out]=Compute_mtSpectrumc_newML(movingwin,params,InfoLFP,nameStructure,epoch,option,HighOrLowSpec)

%
% inputs:
% 
% outputs:


%% initialization

if ~exist('params','var') || ~exist('InfoLFP','var')
    error('Not enough input arguments')
end

if ~exist('option','var') || (exist('option','var') && sum(strcmp(option,{'Unique' 'All' 'deep' 'sup'}))<1)
    option='ask';
end
if ~exist('HighOrLowSpec','var')
    HighOrLowSpec='L';
end
res=pwd;

%% choose channels to analyze

if exist('nameStructure','var'),
    ChannelsToCompute=InfoLFP.channel(strcmp(InfoLFP.structure,nameStructure));
else
    ChannelsToCompute=InfoLFP.channel;
end

if ~exist('legendL','var')
    legendL=[];
    [h,indx]=ismember(ChannelsToCompute,InfoLFP.channel);
    for i=indx
        legendL=[legendL,{[InfoLFP.structure{i},' -Ch',num2str(InfoLFP.channel(i)),' (prof',num2str(InfoLFP.depth(i)),')']}];
    end
end



%% determine channel to analyse
if ~isempty(ChannelsToCompute)
    
    if strcmp(option,'Unique')
        try
            load([FileToSave,'/UniqueChannel',nameStructure],'channelToAnalyse'); num_channel;
        catch
            try load([res,'/SpectrumDataH/UniqueChannel',nameStructure],'channelToAnalyse'); end
            try load([res,'/SpectrumDataL/UniqueChannel',nameStructure],'channelToAnalyse'); end
            try num_channel=channelToAnalyse; disp('Using UniqueChannel from previous spectrum analysis'); save([FileToSave,'/UniqueChannel',nameStructure],'channelToAnalyse'); end
        end
    elseif sum(strcmp(option,{'deep' 'sup'}))
        try
            load([res,'/ChannelsToAnalyse/',nameStructure,'_',option],'channel');num_channel=channel;
        catch
            try
                load([res,'/ChannelsToAnlayse/',nameStructure,'_',option],'channel');num_channel=channel;
                rename('ChannelsToAnlayse','ChannelsToAnalyse')
            catch
                disp(['No channel defined in ChannelsToAnalyse/',nameStructure,'_',option])
                %channel=input(['Enter channel ',nameStructure,'_',option,': ']); num_channel=channel;
                disp(['keyboard to enter channel ',nameStructure,'_',option,' and others ']);keyboard
                try
                    save(['ChannelsToAnalyse/',nameStructure,'_',option],'channel','-append');
                catch
                    save(['ChannelsToAnalyse/',nameStructure,'_',option],'channel','-append');
                end
            end
        end
    end
end

%% compute Spectrogramms
if ~isempty(ChannelsToCompute)
    if exist('num_channel','var') && ~isempty(num_channel)
        
        clear Sp f LFP LFP_temp indexsubset
        
            load([res,'/LFPData/LFP',num2str(num_channel)],'LFP')
            LFP_temp=ResampleTSD(LFP,params.Fs);
            paramsmt=params;
            if strcmp(HighOrLowSpec,'H')
                paramsmt.fpass=[20 200];
                paramsmt.tapers=[1,2];
            else
                paramsmt.fpass=[0 20];
                paramsmt.tapers=[1,2]; %new default [1 2]
            end
            
            
            tempLength=sum(Stop(epoch,'s')-Start(epoch,'s'))*params.Fs;
            
            if tempLength>2^20
                
                %  ----------------------------------------------
                % fragment for mtspectrumc
                fragmentOrder=ceil(tempLength/2^20);
                indx=[tempLength/fragmentOrder:tempLength/fragmentOrder:tempLength];
                
                for i=1:length(Start(epoch))
                    LengthSubEpoch(i)=(Stop(subset(epoch,i),'s')-Start(subset(epoch,i),'s'))*params.Fs;
                end
                cumEpoch=cumsum(LengthSubEpoch);
                
                
                sta=Start(epoch);sto=Stop(epoch);
                for i=1:length(indx)-1
                    Indtemp=find(cumEpoch>indx(i));
                    if Indtemp(1)==1
                        newTime(i)=Start(subset(epoch,1))+1E4*indx(i)/params.Fs;
                    else
                        newTime(i)=Start(subset(epoch,Indtemp(1)))+1E4*(indx(i)-cumEpoch(Indtemp(1)-1))/params.Fs;
                    end
                    sto=[sto;newTime(i)];
                    sta=[sta;newTime(i)];
                end
                
                newEpoch=intervalSet(sort(sta),sort(sto));
                
                for i=1:length(indx)-1
                    indxFragment(i)=find(sort(sta)==newTime(i));
                end
                if indxFragment(1)~=1, indxFragment=[1,indxFragment];end
                if indxFragment(end)~=length(sta), indxFragment=[indxFragment,length(sta)];end
                
                
                tempmeanSpi=zeros(1E3,length(indxFragment)-1);
                for i=1:length(indxFragment)-1
                    [meanSpi,freqfi]=mtspectrumc(Data(Restrict(LFP_temp,subset(newEpoch,indxFragment(i):indxFragment(i+1)-1))),paramsmt);
                    meanSpi=resample(meanSpi,1E3,length(meanSpi));
                    tempmeanSpi(:,i)=meanSpi;
                end
                %  ----------------------------------------------
                freqfi=resample(freqfi,1E3,length(freqfi));
                meanSpi=mean(tempmeanSpi,2);
                
            else
                [meanSpi,freqfi]=mtspectrumc(Data(Restrict(LFP_temp,epoch)),paramsmt);
                meanSpi=resample(meanSpi,1E3,length(meanSpi));
                freqfi=resample(freqfi,1E3,length(freqfi));
            end

    else 
        num_channel=[];
        disp(['No ',nameStructure,'_',option,' channel for this day'])
    end

else
    disp(['No Channels recorded in ',nameStructure])
    num_channel=NaN;
end

try
    meanSpi; freqfi; paramsmt; 
catch
    meanSpi=nan; freqfi=nan; paramsmt=nan; 
end
    
