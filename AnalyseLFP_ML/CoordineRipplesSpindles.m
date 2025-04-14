function [Mh,Ml,LengthM,structureName,InfoDepth,freqRipples,paramRipRow,nameMouseDay]=CoordineRipplesSpindles(res,epoch,fac,Dogamma)

% inputs:
% res (optional) = directory, default pwd
% epoch (optional) = epoch to analyze, default union(PreEpoch,VEHEpoch)
% fac (optional) = Dir.CorrecAmpli
% Dogamma (optional) = compute gamma instead of ripples band

% inspired from RipPowerModulationSpi.m



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%% PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

structureName={'PFCx','PaCx'}; % {'PFCx','PaCx','AuCx'}
InfoDepth={'Sup','Deep'};
paramRipRow=400;

if ~exist('Dogamma','var')
    Dogamma=0;
end
if Dogamma
    freqRipples=[90 120];
    nameFilemat='/AnalyCoordineGammaSpindles';
else
    freqRipples=[120 220];
    nameFilemat='/AnalyCoordineRipplesSpindles';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%% INITIATE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~exist('res','var') || (exist('res','var') && isempty(res))
    res=pwd;
end
if ~exist('epoch','var') || (exist('epoch','var') && isempty(epoch))
    eval('tempLoad=load([res,''/behavResources.mat''],''PreEpoch'',''VEHEpoch'');');
    try
        epoch=union(tempLoad.PreEpoch,tempLoad.VEHEpoch);
    catch
        epoch=tempLoad.PreEpoch;
    end
end
if ~exist('fac','var')
    fac=1;
end

disp(' '), disp(res)
scrsz = get(0,'ScreenSize');
if ~isempty(strfind(res,'Plethysmo'))
    nameMouseDay=['Plethysmo',res(max(strfind(res,'Mouse')):end)]; nameMouseDay(strfind(nameMouseDay,'/'))='-';
else
    nameMouseDay=res(max(strfind(res,'BULB'))+5:end);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%% LOAD RIPPLES AND SPINDLES %%%%%%%%%%%%%%%%%%%%%%%%%

try
    eval('tempLoad=load([res,nameFilemat,''.mat'']);')
    Mh=tempLoad.Mh;
    Ml=tempLoad.Ml;
    LengthM=tempLoad.LengthM;
    structureName=tempLoad.structureName;
    InfoDepth=tempLoad.InfoDepth;
    freqRipples=tempLoad.freqRipples;
    paramRipRow=tempLoad.paramRipRow;
    nameMouseDay=tempLoad.nameMouseDay;
    disp(['    ',nameFilemat,'.mat already exists.. reloading'])
    
catch
    try eval('tempLoad=load([res,''/RipplesdHPC.mat''],''dHPCrip'',''chHPC'');')
    catch eval('tempLoad=load([res,''/RipplesdHPC25.mat''],''dHPCrip'',''chHPC'');')
    end
    Rip=tempLoad.dHPCrip;
    chHPC=tempLoad.chHPC;
    disp(['   Loading LFP',num2str(chHPC),'.mat (Hippocampus channel ',num2str(chHPC),')...'])
    eval(['temploadLFP=load([res,''/LFPData/LFP',num2str(chHPC),'.mat''],''LFP'');'])
    LFPhpc=temploadLFP.LFP;
    
    
    % Spi = [time(thirdPass(:,1)) time(peakPosition) time(thirdPass(:,2)) peakNormalizedPower fqcy fqcy2];
    SpiH=tsdArray; SpiL=tsdArray;
    disp('   Loading Spindles...')
    for nn=1:length(structureName)
        for id=1:length(InfoDepth)
            clear tempLoad SpiHigh SpiLow
            try
                eval('tempLoad=load([res,''/Spindles'',structureName{nn},InfoDepth{id},''.mat''],''SpiHigh'',''SpiLow'');')
                SpiH{nn,id}=ts(tempLoad.SpiHigh(:,2)*1E4);
                SpiL{nn,id}=ts(tempLoad.SpiLow(:,2)*1E4);
            end
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% %%%%%%%%%%%%%%%% RipRaw RIPPLES POWER on SPINDLES %%%%%%%%%%%%%%%%%%%%%%
    
    FilRip=FilterLFP(LFPhpc,freqRipples);
    HilRip=hilbert(Data(FilRip)*fac);
    PowerRip=abs(HilRip);
    tsdPower=tsd(Range(LFPhpc),PowerRip);
    
    Mh={};
    Ml={};
    for nn=1:length(structureName)
        for id=1:length(InfoDepth)
            disp(['Analyzing Spindles',structureName{nn},InfoDepth{id}])
            try
                
                Mhtemp=PlotRipRaw(tsdPower,Range(Restrict(SpiH{nn,id},epoch),'s'),paramRipRow); close
                Mltemp=PlotRipRaw(tsdPower,Range(Restrict(SpiL{nn,id},epoch),'s'),paramRipRow); close
                Mh{nn,id}=Mhtemp;
                Ml{nn,id}=Mltemp;
                LengthM{nn,id}=[length(Range(Restrict(SpiH{nn,id},epoch))), length(Range(Restrict(SpiL{nn,id},epoch)))];
                disp('   -> Done!')
            catch
                Mh{nn,id}=[];
                Ml{nn,id}=[];
                LengthM{nn,id}=[0,0];
                disp('   -> problem')
            end
        end
    end
    
    % saving
    disp(['Saving all in ',nameFilemat,'.mat ...'])
    eval('save([res,nameFilemat,''.mat''],''Mh'',''Ml'',''LengthM'',''structureName'',''InfoDepth'',''freqRipples'',''paramRipRow'',''nameMouseDay'')')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% DISPLAY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('color',[1 1 1],'Position',scrsz),

for nn=1:length(structureName)
    for id=1:length(InfoDepth)
        Mhtemp=Mh{nn,id};
        Mltemp=Ml{nn,id};
        
        subplot(length(structureName),length(InfoDepth),(nn-1)*length(InfoDepth)+id)
        line([0 0],[-500,1000],'Color',[0.5 0.5 0.5])
        try hold on, plot(Mhtemp(:,1),Mhtemp(:,2),'b','linewidth',2);end
        try hold on, plot(Mltemp(:,1),Mltemp(:,2)-500,'k','linewidth',2);end
        ylim([-500,1000])
        
        title(nameMouseDay)
        legend([{[structureName{nn},InfoDepth{id},'Spindles']},{['High (n=',num2str(LengthM{nn,id}(1)),')']},{['Low (n=',num2str(LengthM{nn,id}(2)),')']}])
        xlabel('Time (s)')
        ylabel(['Ripples Power (filter [',num2str(freqRipples),']Hz)'])
    end
end


    