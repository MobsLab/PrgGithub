% 28.01.2016
% ModPFCneuronsAllsttAllmiceAllEpoch.m

% - appelle les fonctions : 
%       o ModulationPFCneuronsByLFPAllMice.m qui lui même appelle
%       o ModulationPFCneuronsByLFP.m

% autres fonction liées : 
% - PercModNeuronsInFctOfEpoch
% - PercModNeuronsInFctOfEpoch2
% - PercModNeuronsInFctOfEpoch3 - question : Est-ce que les neurones modulés par le bulbe sont aussi modulés par le PFC ?


% données sauvées dans le dossier : /media/DataMOBsRAID/ProjetAversion/DATA-Fear/
% => à deplacer dans differents dossiers selon param utilisés


Dir=PathForExperimentFEAR( 'Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'Group',{'CTRL'});
Dir=RestrictPathForExperiment(Dir,'Session',{'EXT-24h','EXT-48h'});
Dir=RestrictPathForExperiment(Dir,'nMice',[244 241 258 259 299]);% removed : 254 MoCx / 253 only 1 neurone/ 242 no freeze / 243 tres peu freeze

% % prendre seulement les 1eres manip de chaque souris
% % si il existe 2 EXT-24h, on prend la 2e (+ de freezing)
% ind2keep=[];
% L=length(Dir.path);
% indmouse=strfind(Dir.path{1},'Mouse');
% Mouselabel{L}=Dir.path{L}(indmouse(1)+5:indmouse(1)+7);
% for man=1:(length(Dir.path)-1)
%     indmouse=strfind(Dir.path{L-man},'Mouse');
%     Mouselabel{L-man}=Dir.path{L-man}(indmouse(1)+5:indmouse(1)+7);
%     if strcmp(Mouselabel{L-man},Mouselabel{L-(man-1)})
%         ind2keep=[ind2keep,0];
%     else
%         ind2keep=[ind2keep,1];
%     end
% end
% ind2keep=[ind2keep,1];
% ind2keep=fliplr(ind2keep);suffix
% Dir.path=Dir.path(logical(ind2keep));
% Dir.name=Dir.name(logical(ind2keep));
% Dir.group=Dir.group(logical(ind2keep));
% Dir.manipe=Dir.manipe(logical(ind2keep));
% Dir.Session=Dir.Session(logical(ind2keep));
% Dir.Treatment=Dir.Treatment(logical(ind2keep));

 
LFPregionlist={'Bulb_deep','PFCx_deep','dHPC_rip'};
EpochNameList={'Freez';'NoFreez'};%;'TotEp';'NoFreez'
strongperonly=0;
if strongperonly==0
    suffix='AllPer';
elseif strongperonly==1
    suffix=['StrO-' BandFq];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 4Hz  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FreqRange =[2 6];
lim2 =[0.5 1];
lim3 =[8 10];
BandFq=[num2str(FreqRange(1)), '-' ,num2str(FreqRange(2))];

for e=1:length(EpochNameList)
    for r=1:length(LFPregionlist)
        
        LFPregion=LFPregionlist{r};
        EpochName=EpochNameList{e};
        if exist(['SpkModul_' BandFq  '_' LFPregion(1:4) '_' EpochName '_' suffix '.mat'],'file')
            disp(['existing file  SpkModul_' BandFq  '_' LFPregion(1:4) '_' EpochName '_' suffix])
        else
            ModulationPFCneuronsByLFPAllMice(LFPregion,EpochName,FreqRange,lim2,lim3,'strongperonly',strongperonly,'dir',Dir)
        end
        close all
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Theta  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FreqRange =[6 12];
lim2 =[1 5];
lim3 =[12 15];
BandFq=[num2str(FreqRange(1)), '-' ,num2str(FreqRange(2))];

for e=1:length(EpochNameList)
    for r=1:length(LFPregionlist)

        LFPregion=LFPregionlist{r};
        EpochName=EpochNameList{e};
        if exist(['SpkModul_' BandFq  '_' LFPregion(1:4) '_' EpochName '_' suffix],'file')
            disp(['existing file  SpkModul_' BandFq  '_' LFPregion(1:4) '_' EpochName '_' suffix])
        else
            ModulationPFCneuronsByLFPAllMice(LFPregion,EpochName,FreqRange,lim2,lim3,'strongperonly',strongperonly,'dir',Dir)
        end
    
        close all
    end
end


%%%%%%%%%%%%%%%%%% QUANTIF : PercModNeuronsInFctOfEpoch
cd /media/DataMOBsRAID/ProjetAversion/DATA-Fear/
BandFqList={'2-6', '6-12'};
percfig_P_Kap=figure('Position', [2062    110  432  424]);
percfig_P=figure('Position', [2480    110     432    424]);
for bf=1:2
    
    BandFq=BandFqList{bf};

    PercTable_P_Kap=nan(length(EpochNameList),length(LFPregionlist));
    PercTable_P=nan(length(EpochNameList),length(LFPregionlist));
    for e=1:length(EpochNameList)
        for r=1:length(LFPregionlist)

            LFPregion=LFPregionlist{r};
            EpochName=EpochNameList{e};
            load(['SpkModul_' BandFq  '_' LFPregion(1:4) '_' EpochName '_' suffix])

            PercTable_P_Kap(e,r)=sum(NbModulatedNeurons(:,1))/sum(NbModulatedNeurons(:,3))*100; % previously computed (critere Kappa +p)
            PercTable_P_Kap2(e,r)=sum(pvalAll_allmice<0.05 & KappaAll_allmice>0.06)/size(pvalAll_allmice,1)*100; % critere Kappa +p
            PercTable_P(e,r)=sum(pvalAll_allmice<0.05)/size(pvalAll_allmice,1)*100; % critere p only
        end
    end
    
    % critère p + Kappa
    figure(percfig_P_Kap), subplot(2,1,bf)
    bar(PercTable_P_Kap')
    if bf==1,legend(EpochNameList),end
    set(gca,'XTickLabel',LFPregionlist)
    xlabel(''), ylabel(['% modulated neurons  (n = ' num2str(size(pvalAll_allmice,1)) ')' ]), title([BandFq 'Hz'])
    text(-0.12, 1.15, 'P & Kappa', 'units', 'normalized')
    
    % critère p only
    figure(percfig_P), subplot(2,1,bf)
    bar(PercTable_P')
    if bf==1,legend(EpochNameList),end
    set(gca,'XTickLabel',LFPregionlist)
    xlabel(''), ylabel(['% modulated neurons  (n = ' num2str(size(pvalAll_allmice,1)) ')' ]), title([BandFq 'Hz'])
    text(-0.12, 1.15, 'P crit', 'units', 'normalized')
end
save PercModNeuronsInFctOfEpoch PercTable_P_Kap PercTable_P_Kap2 PercTable_P
saveas(percfig_P_Kap,'PercModNeurons_(P_Kap)_InFctOfEpoch.fig')
saveFigure(percfig_P_Kap,'PercModNeurons_(P_Kap)_InFctOfEpoch',pwd)
saveas(percfig_P,'PercModNeurons_(P)_InFctOfEpoch.fig')
saveFigure(percfig_P,'PercModNeurons_(P)_InFctOfEpoch',pwd)

