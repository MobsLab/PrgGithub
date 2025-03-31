

% SpectrumModulationAnalysis
% inputs:
% option (optional) = 'high' for [20-200Hz], 'low' for [1-20Hz]
% nameStrucutre = see names in listLFP_to_InfoLFP_ML.m
% optionChannelStructure (optional) = 'All' or 'Unique' cf ComputeSpectrogram_newML.m

res=pwd;
load([res,'/LFPData/InfoLFP']);
[params,movingwin,suffix]=SpectrumParametersML('low'); % all spectrum analysis are between 1-20Hz
load SpikeData

% create file for analysis
mkdir('SpikeModulationBulb');
% mkdir('SpikeModulationPFCx');
% mkdir('SpikeModulationMoCx');
% mkdir('SpikeModulationPaCx');
% mkdir('SpikeModulationHPC');

% define Brain structure, StateEpoch, Frequency Spectrum, and Spk structure belonging
structure='OB';
FilEpoch='Freezeepoch';
FilWindow=[2-4];

% disp(' ')
% structure=input('In which structure do you want to analyse filter LFP modulation (i.e.Bulb) ? ');
% disp(' ')
% disp(' ')
% FilEpoch=input('Do you want to restrict analyse to specific epoch (i.e.SWS/REM) ? ');
% disp(' ')
% disp(' ')
% FilWindow=input('In which band do you want to filter LFP (i.e. SWS:[2 4]/REM:[4 10]) ? ');
% disp(' ')
if FilWindow==[4 10]
    BandFq='Theta';
elseif FilWindow==[2 4]
    BandFq='Slow';
end

% Compute Spectrogram for selected structure LFP
load([res,'/ChannelsToLookAt/',structure,'_deep']); 
disp(['loading LFP #',num2str(channel)])
load([res,'/LFPData/LFP',num2str(channel)]);
try
    disp('loading Spectrum informations')
    load([res,'/SpectrumDataL/Spectrum',num2str(channel)]);
    disp(' done ')
catch
    [Sp,t,f]=ComputeSpectrogram_newML(movingwin,params,InfoLFP,structure,'All',suffix);
    saveFigure(1,(['Spectrogram_',num2str(structure)]),res)
    close
    load([res,'/SpectrumDataL/Spectrum',num2str(channel)]);
end

% Find Oscillations Epoch (SWS:[2 4]/REM:[4 10]))
[Epoch,val,val2]=FindSlowOscBulb(Sp,t,f,FreezeEpoch,1);

% if strcmp('SWS', FilEpoch)
%     load StateEpochSB SWSEpoch
%     if strcmp('Bulb', structure)
%         [Epoch,val,val2]=FindSlowOscBulb(Sp,t,f,SWSEpoch,1);
%     elseif ~strcmp('Bulb', structure)
%         if strcmp('Slow', BandFq)
%             [Epoch,val,val2]=FindSlowOscCx(Sp,t,f,SWSEpoch,1);
%         elseif strcmp('Theta', BandFq)
%             [Epoch,val,val2]=FindThetaOscCx(Sp,t,f,SWSEpoch,1);
%         end
%     end
% elseif strcmp('REM', FilEpoch)
%     load StateEpochSB REMEpoch
%     if strcmp('Bulb', structure)
%         [Epoch,val,val2]=FindSlowOscBulb(Sp,t,f,REMEpoch,1);
%     elseif ~strcmp('Bulb', structure)
%         if strcmp('Slow', BandFq)
%             [Epoch,val,val2]=FindSlowOscCx(Sp,t,f,REMEpoch,1);
%         elseif strcmp('Theta', BandFq)
%             [Epoch,val,val2]=FindThetaOscCx(Sp,t,f,REMEpoch,1);
%         end
%     end
% end

disp(' - ')
ChooseEpoch=input('which Epoch criterion do you want for analysis (standard=9) ?  ');
disp(' - ')

% % Go the corresponding file
% if strcmp('Bulb', structure)
%     cd([res,'/SpikeModulationBulb'])
% elseif strcmp('PFCx', structure)
%     cd([res,'/SpikeModulationPFCx'])
% end
% if strcmp('MoCx', structure)
%     cd([res,'/SpikeModulationMoCx'])
% elseif strcmp('PaCx', structure)
%     cd([res,'/SpikeModulationPaCx'])
% end
% if strcmp('dHPC', structure)
%     cd([res,'/SpikeModulationHPC'])
% end
% res=pwd;
% saveFigure(1,(['FindOsc',FilEpoch,'_',BandFq,'_',num2str(structure)]),res)
% close all

% Filter LFP with choosen frequency
Fil=FilterLFP(LFP,FilWindow,2048);
mkdir('FilterLFP');
cd([res,'/FilterLFP'])
save(['FilLFP_',num2str(FilEpoch)], 'Fil', 'FilWindow', 'channel')
cd([res])

% Step 4: looked at spike modulation in choosen frequency
% Spk=input('which neuron do you want to analyse  ? ');
Spk=1:14;
a=1;
for i=Spk(1):Spk(length(Spk))
    [ph,mu, Kappa, pval,B,C]=ModulationTheta(S{i},Fil,Epoch{ChooseEpoch},25,1);
    KappaAll(a)=Kappa;
    pvalAll(a)=pval;
    phAll{a}=ph;
    hold on, legend(['neuron #',num2str(i)],cellnames{i})
    saveFigure(a,(['Modulation_',FilEpoch,'_',BandFq,'_',num2str(structure),'_neuron#',num2str(i)]),res)
    a=a+1;
end
save(['KappaValues_',FilEpoch,'_',BandFq], 'KappaAll', 'pvalAll','phAll')
close all
Kmean=mean(KappaAll);
PercHighKappa=(length(find(KappaAll>0.06))/length(KappaAll))*100;
figure, hist(KappaAll,100)
hold on, title(['Kappa Distribution ',' - Kmean = ',num2str(Kmean),' - PercHigh = ',num2str(PercHighKappa),'%'])
saveFigure(1,(['Kappa_Distribution_',FilEpoch,'_',BandFq,'_',num2str(structure)]),res)

close all

