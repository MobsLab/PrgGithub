% PercModNeuronsInFctOfEpoch
% 01.02.2016

LFPregionlist={'Bulb_deep','PFCx_deep','dHPC_rip'};
EpochNameList={'Freez';'NoFreez'};%;'TotEp';'NoFreez'
strongperonly=0;
FreqRange =[2 6];
lim2 =[0.5 1];
lim3 =[8 10];
BandFq=[num2str(FreqRange(1)), '-' ,num2str(FreqRange(2))];


if strongperonly==0
    suffix='AllPer';
elseif strongperonly==1
    suffix=['StrO-' BandFq];
end

%%%%%%%%%%%%%%%%%%% DEFINITION AUTOMATIC DES PATHS
Dir=PathForExperimentFEAR( 'Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'Group',{'CTRL'});
Dir=RestrictPathForExperiment(Dir,'nMice',[ 244 241 258 259 299]);% removed : 254 MoCx  / 253 only 1 neurone/ 242 no freeze /243 no freeze
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');

% prendre seulement les 1eres manip de chaque souris
% si il existe 2 EXT-24h, on prend la 2e (+ de freezing)

%ind2remove=[];
ind2keep=[];
L=length(Dir.path);
indmouse=strfind(Dir.path{1},'Mouse');
Mouselabel{L}=Dir.path{L}(indmouse(1)+5:indmouse(1)+7);
for man=1:(length(Dir.path)-1)
    indmouse=strfind(Dir.path{L-man},'Mouse');
    Mouselabel{L-man}=Dir.path{L-man}(indmouse(1)+5:indmouse(1)+7);
    if strcmp(Mouselabel{L-man},Mouselabel{L-(man-1)})
        ind2keep=[ind2keep,0];
        %ind2remove(man)=0;
    else
        ind2keep=[ind2keep,1];
    end
end

ind2keep=fliplr(ind2keep);
Dir.path=Dir.path(logical(ind2keep));
Dir.name=Dir.name(logical(ind2keep));
Dir.group=Dir.group(logical(ind2keep));
Dir.manipe=Dir.manipe(logical(ind2keep));
Dir.Session=Dir.Session(logical(ind2keep));
Dir.Treatment=Dir.Treatment(logical(ind2keep));


BandFqList={'2-6', '6-12'};
percfigbymouse=figure('Position', [  1928 264  411   688]);
for bf=1:2
    BandFq=BandFqList{bf};

PercMat{bf}=nan(length(EpochNameList),length(LFPregionlist), length(Dir.path));
NbMat{bf}=nan(length(EpochNameList),length(LFPregionlist), length(Dir.path));
PercPlotErrN=nan(length(Dir.path),length(EpochNameList)*length(LFPregionlist));

for man=1:length(Dir.path)

    cd(Dir.path{man})
    disp(Dir.path{man})

    %load(['SpkModul_Bulb_' EpochName '_' suffix '/Modul_' BandFq '_' suffix '.mat'])   
    PercTable{man,bf}=nan(length(EpochNameList),length(LFPregionlist));
    a=1;
    for e=1:length(EpochNameList)
        for r=1:length(LFPregionlist)
            LFPregion=LFPregionlist{r};
            EpochName=EpochNameList{e};
            load(['SpkModul_' LFPregion  '_' EpochName '_' suffix '/Modul_' BandFq '_' suffix '.mat'])  

            
            modulatedNeuronsOnly=nan(size(modulatedNeurons));
            for neu=1:length(modulatedNeurons)
                if isempty(find(numMUA==modulatedNeurons(neu)))% ce n'est pas un MUA
                    modulatedNeuronsOnly(neu)=modulatedNeurons(neu);
                else
                end
            end
            modulatedNeuronsOnly(isnan(modulatedNeuronsOnly))=[];
            PercTable{man,bf}(e,r)=length(modulatedNeuronsOnly)/(length(numNeurons) -length(numMUA))*100;
            PercMat{bf}(e,r,man)=length(modulatedNeuronsOnly)/(length(numNeurons)-length(numMUA))*100;
            PercPlotErrN(man,a)=length(modulatedNeuronsOnly)/(length(numNeurons)-length(numMUA))*100;
            NbMat{bf}(e,r,man)=length(modulatedNeuronsOnly);
            NbPlotErrN(man,a)=length(modulatedNeuronsOnly); 
            
            a=a+1;
        end
    end
    

end
% Perc of Modulated neurones bor each structure, Freezz/NoFreeze
PercTableByMouse{bf}=PercPlotErrN;
NbTableByMouse{bf}=NbPlotErrN;
subplot(2,1,bf)
%PlotErrorBarN(PercPlotErrN,0); ylabel(['% modulated neurons'])% 0=not a new plot
PlotErrorBarN(NbPlotErrN,0); ylabel(['Nb modulated neurons'])% 0=not a new plot
set(gca,'XTick',[1:6])
set(gca,'XTickLabel',{'Bulb F','Bulb NoF','PFCx F','PFCx NoF','dHPC F','dHPC NoF'});

set(gca,'XTickLabel',{'F','NoF','F','NoF','F','NoF'});
xlabel('Bulb           PFCx           HPC')

title([BandFq 'Hz'])
end
cd /media/DataMOBsRAID/ProjetAversion/DATA-Fear/SpkModulAllPer
save PercModNeuronsInFctOfEpochByMouse.mat PercTableByMouse PercTable PercMat NbMat PercPlotErrN NbPlotErrN BandFqList Dir 
saveas(percfigbymouse,'PercModNeuronsInFctOfEpochByMouse.fig')
saveFigure(percfigbymouse,'PercModNeuronsInFctOfEpochByMouse',pwd)

% Correlation for each mouse between structures
colori={[0 0 0];[0.5 0.5 0.5]};
positioni={[219   438   660   536];[889   439   660   536]};
for e=1:length(EpochNameList)
    
    figure('Position', positioni{e})
    for r=1:length(LFPregionlist)
        for rr=1:length(LFPregionlist)
            if~(r==rr)
                subplot(3,3,3*(rr-1)+r)
                H1=squeeze(NbMat{1,1}(e,r,:));
                F1=squeeze(NbMat{1,1}(e,rr,:));
                plot(H1,F1,'.', 'Color',colori{e})
                xlabel(LFPregionlist{r})
                ylabel(LFPregionlist{rr})
                xlim([0 6]), ylim([0 6]), 
                line([0 6],[0 6],'LineStyle',':','Color',[0.8 0.8 0.8])%[0.9 0.9 0.9]

                [r1,p1]=corrcoef(H1,F1);
                title([ 'p ' sprintf('%.2f',(p1(1,2)))]);
                pf1= polyfit(F1,H1,1);
                line([min(F1),max(F1)],pf1(2)+[min(F1),max(F1)]*pf1(1),'Color',colori{e},'Linewidth',1)
                clear r1 p1 H1 F1

            end
            if r==2&&rr==1
            title(EpochNameList{e})
            end

        end
    end

    saveas(gcf,['NbMod_CorrBtwStt_' EpochNameList{e} '.fig'])
    saveFigure(gcf,['NbMod_CorrBtwStt_' EpochNameList{e}],'/media/DataMOBsRAID/ProjetAversion/DATA-Fear/SpkModulAllPer')
       
end

