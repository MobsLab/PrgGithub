% inputs:
% NameDir = see PathForExperimentsML.m
% option (optional) = 'high' for [20-200Hz], 'low' for [1-20Hz]
% nameStrucutre = see names in listLFP_to_InfoLFP_ML.m
% optionChannelStructure (optional) = 'All' or 'Unique' cf ComputeSpectrogram_newML.m
% outputs:
% [Spi,ti,fi,channelToAnalyse] (optional) = only if NameDir is a Unique path
% e.g.  ComputeAllSpectrogramsML('DPCPX','low','Bulb')
res=pwd;
load([res,'/LFPData/InfoLFP']);

% step 1: which Brain Structure for modulation analysis
[params,movingwin,suffix]=SpectrumParametersML('low');
disp(' ')
structure=input('In which structure do you want to analyse filter LFP modulation (i.e.Bulb) ? ');
disp(' ')
[Sp,t,f]=ComputeSpectrogram_newML(movingwin,params,InfoLFP,structure,'All',suffix);

% step 2:
load([res,'/ChannelsToAnalyse/',structure,'_deep']); 
disp('loading Spectrum informations')
load([res,'/SpectrumDataL/Spectrum',num2str(channel)]);
disp(' done ')

% Step 2:
load StateEpochSB SWSEpoch
load StateEpochSB REMEpoch
[Epoch,val,val2]=FindSlowOscBulb(Sp,t,f,REMEpoch);

% Step 3: filter LFP with choosen frequency
load([res,'/LFPData/LFP',num2str(channel)]);
disp(' ')
FilWindow=input('In which band do you want to filter LFP (i.e. [2 4]) ? ');
disp(' ')
Fil=FilterLFP(LFP,FilWindow,2048);
save FilterLFPtoAnalyse/FilLFPPaCx_deepREM Fil FilWindow

% Step 4: looked at spike modulation in choosen frequency
load SpikeData

mkdir('SpikeModulation');
cd([res,'/SpikeModulationREM'])
res=pwd;
Spk=input('which neuron do you want to analyse  ? ');

a=1;
for i=Spk(1):Spk(length(Spk))
    [ph,mu, Kappa, pval,B,C]=ModulationTheta(S{i},Fil,Epoch{9},25,1);
    KappaPaCx(a)=Kappa;
    pvalPaCx(a)=pval;
    hold on, legend(['neuron #',num2str(i)])
    saveFigure(a,(['23022015_Modulation_PaCx_neuron#',num2str(i)]),res)
    a=a+1;
end
save KappaValues KappaPaCx pvalPaCx



