function ModulationPFCneuronsByLFPAllMice(LFPregion,EpochName,FreqRange,lim2,lim3,varargin)

% 27.01.2015
% regarde la modulation des neurones PFC par le LFP du Bulbe, toutes les
% souris poolées

% INPUTS
% - LFPregion  ='Bulb_deep';%'dHPC_rip';%'PFCx_deep' 
% - EpochName ='NoFreez';'Freez';'TotEp';
% - strongperonly =1 ou 0;
% - FreqRange =[2 6];
% - lim2 =[0.5 1];
% - lim3 =[8 10];

% code liés
% - ModulationPFCneuronsByLFPAllMice.m qui lui même appelle
% - ModulationPFCneuronsByLFP.m

%default values
strongperonly =0;
for i = 1:2:length(varargin),
    
	switch(lower(varargin{i})),
		case 'strongperonly',
			strongperonly = varargin{i+1};
        case 'dir',
			Dir = varargin{i+1};
	end
end

MUA='only neurons';

if strongperonly==0
    suffix='AllPer';
elseif strongperonly==1
    suffix=['StrO-' num2str(FreqRange(1)), '-' ,num2str(FreqRange(2))];
end


%%%%%%%%%%%%%%%%%%% DEFINITION LOCALE DES PATHS
if ~isstruct(Dir)
    Dir=PathForExperimentFEAR( 'Fear-electrophy');
    Dir=RestrictPathForExperiment(Dir,'Group',{'CTRL'});
    Dir=RestrictPathForExperiment(Dir,'nMice',[243 244 241 258 259 299]);
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

end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

BandFq=[num2str(FreqRange(1)), '-' ,num2str(FreqRange(2))];
% for plotting/media/DataMOBS23/M248/20150327/FEAR-Mouse-248-27032015-EXPLOpost_150327_165700
KappaMax=0.25;
LogPMax=-10;

SpkModul=figure('Position', [ 2256  190 1500    775]);%[918 600 1002  405]

% define 1 marker per mouse
Markeri={'o','square','diamond','v','^','>','pentagram','hexagram','*','<','<','<','<','<','<'};


indmouse=strfind(Dir.path{1},'Mouse');
Mouselabel{1}=Dir.path{1}(indmouse(1)+5:indmouse(1)+7);
MouseMarker{1}='o';

a=2;
for man=2:length(Dir.path)
    indmouse=strfind(Dir.path{man},'Mouse');
    Mouselabel{man}=Dir.path{man}(indmouse(1)+5:indmouse(1)+7);
    if strcmp(Mouselabel{man},Mouselabel{man-1})
        MouseMarker{man}= MouseMarker{man-1};

    else
        MouseMarker{man}=Markeri{a};

        a=a+1;
    end
end

colori=jet(length(unique(Mouselabel)));%-0.1;colori(colori<0)=0;
MouseColor(1,:)=colori(1,:);
a=2;
for man=2:length(Dir.path)
    if strcmp(Mouselabel{man},Mouselabel{man-1})
        MouseColor(man,:)= MouseColor(man-1,:);
    else
        MouseColor(man,:)= colori(a,:);
        a=a+1;
    end
end

NbModulatedNeurons=NaN(length(Dir.path),2);
KappaAll_allmice=[];
meanPh_allmice=[];
pvalAll_allmice=[];
ModulatedNeurons_bool=[];
Duration_allmice=NaN(length(Dir.path),1);


    for man=1:length(Dir.path)
    
        cd(Dir.path{man})
        disp(Dir.path{man})

        FolderName=['SpkModul_Bulb_' EpochName '_' suffix ];
%         try 
%             load([FolderName '/Modul_' BandFq '_' suffix '.mat'])
%        catch
             [numNeurons,numMUA,pvalAll,KappaAll,phAll,meanPh,pthres,Kth,Duration,PercTimeval,Crit,SpkNbThr,Spectrum,f]=ModulationPFCneuronsByLFP(FreqRange,lim2,lim3,LFPregion, 'strongperonly',strongperonly,'Epoch', EpochName);
        %end

        figure(SpkModul)
        % kappa/ log(p)
        subplot(2,3,1), hold on
        modulatedNeurons=numNeurons((pvalAll<pthres) & (KappaAll>Kth));
        pvalAll_log10=log10(pvalAll);
        pvalAll_log10(pvalAll_log10<(LogPMax))=LogPMax;
        KappaAll(KappaAll>KappaMax)=KappaMax;
        scatter(pvalAll_log10, KappaAll,'Marker',MouseMarker{man},'MarkerFaceColor','b','MarkerEdgeColor','k')
        hold on, scatter(pvalAll_log10((pvalAll<pthres) & (KappaAll>Kth)), KappaAll((pvalAll<pthres) & (KappaAll>Kth)),'Marker',MouseMarker{man}, 'MarkerFaceColor','r','MarkerEdgeColor','k')
        scatter(pvalAll_log10(numMUA), KappaAll(numMUA),'Marker', '+','MarkerEdgeColor',[0.8 0.8 0.8])

        legend({'no modulation', ['p < ' num2str(pthres) ' & K > ' num2str(Kth) ], 'MUA'}, 'Location', 'NorthWest')
        title([ LFPregion ' ' BandFq ' ' suffix]), xlabel('log 10 (p)'), ylabel ('kappa')

        % Kappa/phase diagram, pval color-coded
        subplot(2,3,2), hold on
        A=round(abs(log10(pvalAll)));
        cols=flipud(autumn(11));
        for nn=numNeurons
            if ~isnan(KappaAll(nn))

                if pvalAll(nn)>pthres
                    scatter(meanPh(nn), KappaAll(nn),'Marker',MouseMarker{man},'MarkerFaceColor','b','MarkerEdgeColor','k'),hold on
                else
                    scatter(meanPh(nn), KappaAll(nn),'Marker',MouseMarker{man},'MarkerFaceColor',cols(round(abs(pvalAll_log10(nn)))+1, :),'MarkerEdgeColor','k'),hold on
                end
                if ismember(nn, numMUA)
                    scatter(meanPh(nn), KappaAll(nn),'Marker', '+','MarkerEdgeColor',[0.8 0.8 0.8])
                end
            end
        end
        title('p : yellow = 0.05 red =  1E - 10'), xlabel('phase (rad)'), ylabel ('kappa')
        
        % spectrum of the considered epoch
        subplot(2,3,6), hold on
        plot(f,Spectrum,'Color', MouseColor(man,:), 'LineWidth',2) %Spectrum+(man-1)*(1/length(Dir.path))*1E5
        xlim([0 20])

        % proportion of modulated neurones
        ModulatedNeurons_bool=[ModulatedNeurons_bool; ((pvalAll<pthres) & (KappaAll>Kth))'];
        % caution MUA included
        if strcmp(MUA,'MUAincluded')
        elseif strcmp(MUA,'only neurons')
            pvalAll(numMUA)=[];
            KappaAll(numMUA)=[];
            ModulatedNeurons_bool(numMUA)=0;
        end


        NbModulatedNeurons(man,1)=length(pvalAll((pvalAll<pthres) & (KappaAll>Kth)));% nb modulés
        NbModulatedNeurons(man,2)=length(pvalAll)-NbModulatedNeurons(man,1);% nb non-modulés
        NbModulatedNeurons(man,3)=length(pvalAll);% nb neurones total
        
        pvalAll_allmice=[pvalAll_allmice;pvalAll'];
        KappaAll_allmice=[KappaAll_allmice;KappaAll'];
        meanPh_allmice=[meanPh_allmice;meanPh'];
        Duration_allmice(man)=Duration;
    end

    subplot(2,3,1), ylim([0 KappaMax])
    XL=xlim;
    if XL(1)<LogPMax
        xlim([LogPMax 0])
    end
    subplot(2,3,2),ylim([0 KappaMax]),xlim([-3.14 3.14])


    % Proportion of modulated neurons
    subplot(4,3,3), hold on
    %subplot(2,3,3), hold on
    hb=bar(NbModulatedNeurons(:,[1 2]));
    set(hb(1),'FaceColor','r')
    set(hb(2),'FaceColor',[0 0 0.7])

    legend('mod','non-mod')
    if strcmp(MUA,'MUAincluded')
        ylabel('nb of neurons (MUA included)')
    elseif strcmp(MUA,'only neurons')
        ylabel('nb of neurons (neurons only)')
    end
    set(gca, 'XTick',[1: length(Dir.path)])
    set(gca,'XTicklabel',(Mouselabel))
    ylim([0 18])

    % Distribution of Kappa values
    subplot(2,3,4), hold on
    hist(KappaAll_allmice,20)
    xlim([0 KappaMax]), ylim([0 20])
    Y=ylim;
    plot([Kth Kth],[Y(1) Y(2)], ':r')

    Kmean=nanmean(KappaAll_allmice);
    PercModulatedNeurons=sum(NbModulatedNeurons(:,1))/sum(NbModulatedNeurons(:,3))*100;
    ylabel('Kappa Distrib ')
    hold on, title(['Kmean = ', sprintf('%.2f',Kmean),' - %modulated = ',sprintf('%.0f',PercModulatedNeurons),'%'])

    % Distribution of Phase values
    subplot(2,3,5), hold on
    [n_mod,xout_mod]=hist(meanPh_allmice(logical(ModulatedNeurons_bool)),[-3.2:0.32:3.2]);
    plot(xout_mod,n_mod,'Color','r', 'LineWidth',2)
    [n,xout]=hist(meanPh_allmice,[-3.2:0.32:3.2]);
    plot(xout,n,'Color',[0 0 0.7], 'LineWidth',2)
    
    ylabel('phase Distrib '), xlabel('phase (rad)')
    ylim([0 20]), xlim([-3.14 3.14])
    legend(['mod (' num2str(sum(NbModulatedNeurons(:,1))) ')'],['non-mod (' num2str(sum(NbModulatedNeurons(:,2))) ')'])


    % Duration of epoch
    subplot(4,3,6), hold on
    %subplot(2,3,6), hold on
    hDur=bar(Duration_allmice*1E-4);
    set(hDur,'FaceColor',[0.7 0.7 0.7])
    set(gca, 'XTick',[1: length(Dir.path)])
    set(gca,'XTicklabel',(Mouselabel))
    ylabel('Epoch Duration (sec)')
    title(EpochName)
    
    % spectrum of the considered epoch
    subplot(2,3,6), hold on
    legend(Mouselabel)
    YL=ylim;
    plot([FreqRange(1) FreqRange(1)],[YL(1) YL(2)])
    plot([FreqRange(2) FreqRange(2)],[YL(1) YL(2)])
    
    % plot parameters of the analysis
    subplot(2,3,1)
    text(-0.5,1.15, [LFPregion  '  ' EpochName],'units','normalized')
    text(-0.5,1.05, [BandFq ' Hz'],'units','normalized')
    if strongperonly==1
        text(-0.5,0.95 ,['Strong Osc Per Only Crit' num2str(Crit)],'units','normalized')

    elseif strongperonly==0
        text(-0.5,0.95, 'All Epochs included','units','normalized')

    end
    text(-0.5,0.85, ['minSpkNb ' sprintf('%.0f',SpkNbThr) ],'units','normalized')
    text(-0.5,0.75, MUA,'units','normalized')
    
    cd('/media/DataMOBsRAID/ProjetAversion/DATA-Fear')
    file2save=(['SpkModul_' BandFq  '_' LFPregion(1:4) '_' EpochName '_' suffix]);
    eval(['save ' file2save ' LFPregion EpochName FreqRange lim2 lim3 strongperonly Crit Duration_allmice pvalAll_allmice KappaAll_allmice meanPh_allmice KappaMax LogPMax SpkNbThr pthres MUA ModulatedNeurons_bool Dir Mouselabel NbModulatedNeurons'])




saveFigure(SpkModul,(['SpkModul_' BandFq  '_' LFPregion(1:4) '_' EpochName '_' suffix ]),pwd)
saveas(SpkModul,(['SpkModul_' BandFq  '_' LFPregion(1:4) '_' EpochName '_' suffix  '.fig']))
