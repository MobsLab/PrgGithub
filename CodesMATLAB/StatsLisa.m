%Stats Lisa

% 
%     '1 freqSpk'
%     '2 maxAuto'
%     '3 Skew'
%     '4 Kurto'
%     '5 Indice'
%     '6 PBimod'
%     '7 PUnimod'
%     '8 Delai'
%     '9 freqSpkUp'
%     '10 freqSpkDown'
%     '11 freqUp'
%     '12 DureeUp'
%     '13 DureeDown'
%     '14 amplUp'
%     '15 DureeUpTotal'
%     '16 DureeDownTotal'
%     '17 percS'
%     '18 percE'
%     '19 MembPot'
%     '20 PotUp'
%     '21 PotDown'
%     '22 AmpSpk'
%     '23 AhpSpk'
%     '24 FreqSO'
%     '25 cont'
%     '26 genotype'
%     

cd 
% tu mets ton dossier ou sont les fichiers DataAnalyseLisa...

load DataAnalyseLisaFinal60mV.mat

% T1=R(R(:,25)==1,:); texte1=' Manual selection -60mV ';
T1=R(R(:,5)<1,:); texte1=' Indice -60mV ';
% T1=R(R(:,6)>0.05,:); texte1=' Bimodal -60mV ';
% T1=R; texte1=' all ';

% T2=R(R(:,5)<1,:); texte2=' Indice -60mV ';
% T2=R(R(:,25)==1,:); texte2=' Manual selection -60mV ';
% T2=R(R(:,6)>0.05,:); texte2=' Bimodal -60mV ';
% T2=R; texte2=' all -60mV ';


% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------


cd
% tu mets ton dossier ou sont les fichiers DataAnalyseLisa...

load DataAnalyseLisaFinalSpont.mat


% T1=R(R(:,25)==1,:); texte1=' Manual selection Spont ';
% T1=R(R(:,5)<1,:); texte1=' Indice Spont ';
% T1=R(R(:,6)>0.05,:); texte1=' Bimodal Spont ';
% T1=R; texte1=' all Spont ';


% T2=R(R(:,25)==1,:); texte2=' Manual selection Spont ';
T2=R(R(:,5)<1,:); texte2=' Indice Spont ';
% Prend uniquement les cellules avec un indice <1, donc bimodales
% T2=R;  texte2=' all Spont ';


% load DataSpontJuly2010 cellnamesCtrl cellnamesdoKO cellnamesKO30


% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------



% 
% T=T1;
% T=T2;

% T=[[T1,ones(size(T1,1),1)];[T2,2*ones(size(T2,1),1)]];



for q=1:24

    l=1;
    [M1a,S1a,E1a]=MeanDifNan(T1(T1(:,26)==1,q));
    [M2a,S2a,E2a]=MeanDifNan(T1(T1(:,26)==2,q));
    [M3a,S3a,E3a]=MeanDifNan(T1(T1(:,26)==3,q));
    [M4a,S4a,E4a]=MeanDifNan(T1(T1(:,26)==4,q));
%     1,2,3,4 correspondent aux differents génotypes

    [M1b,S1b,E1b]=MeanDifNan(T2(T2(:,26)==1,q));
    [M2b,S2b,E2b]=MeanDifNan(T2(T2(:,26)==2,q));
    [M3b,S3b,E3b]=MeanDifNan(T2(T2(:,26)==3,q));
    [M4b,S4b,E4b]=MeanDifNan(T2(T2(:,26)==4,q));
    
    figure('Color',[1 1 1])
    
    pause(0)
    
    set(q,'Position',[45 66 938 749])
    
    subplot(2,1,1), hold on

    errorbar([[M1a,M1b],[M2a,M2b],[M3a,M3b],[M4a,M4b]],[[E1a,E1b],[E2a,E2b],[E3a,E3b],[E4a,E4b]],'+','color','k')
    bar([[M1a,M1b],[M2a,M2b],[M3a,M3b],[M4a,M4b]],1)

    set(gca,'xtick',[1:8])
    set(gca,'xticklabel',{'Ctrl -60mV','Ctrl Spont','KO30 -60mV','KO30 Spont','KO43 -60mV','KO43 Spont','doKO -60mV','doKO Spont'})
    
    
%     Bar([M1,M2,M3,M4],'k')
%     ErrorBar([M1,M2,M3,M4],[E1,E2,E3,E4],'+','color','k')

    ylabel(labels{q})
    title(labels{q})
%     disp('  ')
%     disp('  ')
%     set(gca,'xtick',[1:4])
%     set(gca,'xticklabel',{'Ctrl','KO30','KO43','doKO'})
    
    subplot(2,1,2)

        text(0.05,1-0.12*l,['Statistics         ',texte1,'      ',texte2]);l=l+1;       
        text(0.05,1-0.12*l,['nb neurons Left:   ctrl: ',num2str(length(find(T1(:,26)==1))),'   KO30: ',num2str(length(find(T1(:,26)==2))),'   KO43: ',num2str(length(find(T1(:,26)==3))),'   doKO: ',num2str(length(find(T1(:,26)==4))),'   /     Right:  ctrl: ',num2str(length(find(T2(:,26)==1))),'   KO30: ',num2str(length(find(T2(:,26)==2))),'   KO43: ',num2str(length(find(T2(:,26)==3))),'   doKO: ',num2str(length(find(T2(:,26)==4)))]);l=l+1;        

        %     labels{q}
%     disp('  ')

%   Tests statistiques Ctrl vs KO30, two tailed puis one tailed
    [h,p]=ttest2(T1(T1(:,26)==1,q),T1(T1(:,26)==2,q));%disp(['ctrl vs 30     p=',num2str(p), ' h=',num2str(h)])
    [h1,p1]=ttest2(T1(T1(:,26)==1,q),T1(T1(:,26)==2,q),0.05,'right');
    [h2,p2]=ttest2(T1(T1(:,26)==1,q),T1(T1(:,26)==2,q),0.05,'left');
    if max([h,h1,h2])==1
    text(0.05,1-0.12*l,['CTRL vs KO30         p=',num2str(min([p,p1,p2])), '           *']);l=l+1;
    else
    text(0.05,1-0.12*l,['CTRL vs KO30         p=',num2str(min([p,p1,p2]))]);l=l+1;    
    end
    
    [h,p]=ttest2(T1(T1(:,26)==1,q),T1(T1(:,26)==3,q));%disp(['ctrl vs 43     p=',num2str(p), ' h=',num2str(h)])
    [h1,p1]=ttest2(T1(T1(:,26)==1,q),T1(T1(:,26)==3,q),0.05,'left');
    [h2,p2]=ttest2(T1(T1(:,26)==1,q),T1(T1(:,26)==3,q),0.05,'right');
    if max([h,h1,h2])==1
    text(0.05,1-0.12*l,['CTRL vs KO43         p=',num2str(min([p,p1,p2])), '          *']);l=l+1;
    else
    text(0.05,1-0.12*l,['CTRL vs KO43         p=',num2str(min([p,p1,p2]))]);l=l+1;
    end
    
    [h,p]=ttest2(T1(T1(:,26)==1,q),T1(T1(:,26)==4,q));%disp(['ctrl vs doKO   p=',num2str(p), ' h=',num2str(h)])
    [h1,p1]=ttest2(T1(T1(:,26)==1,q),T1(T1(:,26)==4,q),0.05,'left');
    [h2,p2]=ttest2(T1(T1(:,26)==1,q),T1(T1(:,26)==4,q),0.05,'right');
    if max([h,h1,h2])==1
        text(0.05,1-0.12*l,['CTRL vs doKO         p=',num2str(min([p,p1,p2])), '          *']);l=l+1;
    else
        text(0.05,1-0.12*l,['CTRL vs doKO         p=',num2str(min([p,p1,p2]))]);l=l+1;
    end
    
    [h,p]=ttest2(T1(T1(:,26)==2,q),T1(T1(:,26)==3,q));%disp(['30 vs 43       p=',num2str(p), ' h=',num2str(h)])
    [h1,p1]=ttest2(T1(T1(:,26)==2,q),T1(T1(:,26)==3,q),0.05,'left');
    [h2,p2]=ttest2(T1(T1(:,26)==2,q),T1(T1(:,26)==3,q),0.05,'right');
    if max([h,h1,h2])==1
    text(0.05,1-0.12*l,['KO30 vs KO43         p=',num2str(min([p,p1,p2])), '         *']);l=l+1;
    else
    text(0.05,1-0.12*l,['KO30 vs KO43         p=',num2str(min([p,p1,p2]))]);l=l+1;
    end
    
    [h,p]=ttest2(T1(T1(:,26)==2,q),T1(T1(:,26)==4,q));%disp(['30 vs doKO     p=',num2str(p), ' h=',num2str(h)])
    [h1,p1]=ttest2(T1(T1(:,26)==2,q),T1(T1(:,26)==4,q),0.05,'left');
    [h2,p2]=ttest2(T1(T1(:,26)==2,q),T1(T1(:,26)==4,q),0.05,'right');
    if max([h,h1,h2])==1
        text(0.05,1-0.12*l,['KO30 vs doKO         p=',num2str(min([p,p1,p2])), '         *']);l=l+1;
    else
        text(0.05,1-0.12*l,['KO30 vs doKO         p=',num2str(min([p,p1,p2]))]);l=l+1;
    end
    
    [h,p]=ttest2(T1(T1(:,26)==3,q),T1(T1(:,26)==4,q));%disp(['43 vs doKO     p=',num2str(p), ' h=',num2str(h)])
    [h1,p1]=ttest2(T1(T1(:,26)==3,q),T1(T1(:,26)==4,q),0.05,'left');
    [h2,p2]=ttest2(T1(T1(:,26)==3,q),T1(T1(:,26)==4,q),0.05,'right');
    if max([h,h1,h2])==1
    text(0.05,1-0.12*l,['KO43 vs doKO         p=',num2str(min([p,p1,p2])), '         *']);l=l+1;
    else
    text(0.05,1-0.12*l,['KO43 vs doKO         p=',num2str(min([p,p1,p2]))]);l=l+1;
    end    





    l=3;

    [h,p]=ttest2(T2(T2(:,26)==1,q),T2(T2(:,26)==2,q));%disp(['ctrl vs 30     p=',num2str(p), ' h=',num2str(h)])
    [h1,p1]=ttest2(T2(T2(:,26)==1,q),T2(T2(:,26)==2,q),0.05,'right');
    [h2,p2]=ttest2(T2(T2(:,26)==1,q),T2(T2(:,26)==2,q),0.05,'left');
    if max([h,h1,h2])==1
    text(0.5,1-0.12*l,['CTRL vs KO30         p=',num2str(min([p,p1,p2])), '           *']);l=l+1;
    else
    text(0.5,1-0.12*l,['CTRL vs KO30         p=',num2str(min([p,p1,p2]))]);l=l+1;    
    end
    
    [h,p]=ttest2(T2(T2(:,26)==1,q),T2(T2(:,26)==3,q));%disp(['ctrl vs 43     p=',num2str(p), ' h=',num2str(h)])
    [h1,p1]=ttest2(T2(T2(:,26)==1,q),T2(T2(:,26)==3,q),0.05,'left');
    [h2,p2]=ttest2(T2(T2(:,26)==1,q),T2(T2(:,26)==3,q),0.05,'right');
    if max([h,h1,h2])==1
    text(0.5,1-0.12*l,['CTRL vs KO43         p=',num2str(min([p,p1,p2])), '          *']);l=l+1;
    else
    text(0.5,1-0.12*l,['CTRL vs KO43         p=',num2str(min([p,p1,p2]))]);l=l+1;
    end
    
    [h,p]=ttest2(T2(T2(:,26)==1,q),T2(T2(:,26)==4,q));%disp(['ctrl vs doKO   p=',num2str(p), ' h=',num2str(h)])
    [h1,p1]=ttest2(T2(T2(:,26)==1,q),T2(T2(:,26)==4,q),0.05,'left');
    [h2,p2]=ttest2(T2(T2(:,26)==1,q),T2(T2(:,26)==4,q),0.05,'right');
    if max([h,h1,h2])==1
        text(0.5,1-0.12*l,['CTRL vs doKO         p=',num2str(min([p,p1,p2])), '          *']);l=l+1;
    else
        text(0.5,1-0.12*l,['CTRL vs doKO         p=',num2str(min([p,p1,p2]))]);l=l+1;
    end
    
    [h,p]=ttest2(T2(T2(:,26)==2,q),T2(T2(:,26)==3,q));%disp(['30 vs 43       p=',num2str(p), ' h=',num2str(h)])
    [h1,p1]=ttest2(T2(T2(:,26)==2,q),T2(T2(:,26)==3,q),0.05,'left');
    [h2,p2]=ttest2(T2(T2(:,26)==2,q),T2(T2(:,26)==3,q),0.05,'right');
    if max([h,h1,h2])==1
    text(0.5,1-0.12*l,['KO30 vs KO43         p=',num2str(min([p,p1,p2])), '         *']);l=l+1;
    else
    text(0.5,1-0.12*l,['KO30 vs KO43         p=',num2str(min([p,p1,p2]))]);l=l+1;
    end
    
    [h,p]=ttest2(T2(T2(:,26)==2,q),T2(T2(:,26)==4,q));%disp(['30 vs doKO     p=',num2str(p), ' h=',num2str(h)])
    [h1,p1]=ttest2(T2(T2(:,26)==2,q),T2(T2(:,26)==4,q),0.05,'left');
    [h2,p2]=ttest2(T2(T2(:,26)==2,q),T2(T2(:,26)==4,q),0.05,'right');
    if max([h,h1,h2])==1
        text(0.5,1-0.12*l,['KO30 vs doKO         p=',num2str(min([p,p1,p2])), '         *']);l=l+1;
    else
        text(0.5,1-0.12*l,['KO30 vs doKO         p=',num2str(min([p,p1,p2]))]);l=l+1;
    end
    
    [h,p]=ttest2(T2(T2(:,26)==3,q),T2(T2(:,26)==4,q));%disp(['43 vs doKO     p=',num2str(p), ' h=',num2str(h)])
    [h1,p1]=ttest2(T2(T2(:,26)==3,q),T2(T2(:,26)==4,q),0.05,'left');
    [h2,p2]=ttest2(T2(T2(:,26)==3,q),T2(T2(:,26)==4,q),0.05,'right');
    if max([h,h1,h2])==1
    text(0.5,1-0.12*l,['KO43 vs doKO         p=',num2str(min([p,p1,p2])), '         *']);l=l+1;
    else
    text(0.5,1-0.12*l,['KO43 vs doKO         p=',num2str(min([p,p1,p2]))]);l=l+1;
    end    
    

end






% ---------------------------------------------------------------------------
% ---------------------------------------------------------------------------
% ---------------------------------------------------------------------------

if 0


[Rtctrl,cellnamesCtrl,genotypeCtrl]=ParcoursNewCaracMitral('/Users/karimbenchenane/Documents/Data/Lisa/electroPhy/Data/DATA_spont/ctrl');
save DataFinalSpontCtrlJuly2010 RtCtrl cellnamesCtrl genotypeCtrl

[RtKO30,cellnamesKO30,genotypeKO30]=ParcoursNewCaracMitral('/Users/karimbenchenane/Documents/Data/Lisa/electroPhy/Data/DATA_spont/KO30');
save DataFinalSpont30July2010 RtKO30 cellnamesKO30 genotypeKO30

[RtKO43,cellnamesKO43,genotypeKO43]=ParcoursNewCaracMitral('/Users/karimbenchenane/Documents/Data/Lisa/electroPhy/Data/DATA_spont/KO43');
save DataFinalSpontKO43July2010 RtKO43 cellnamesKO43 genotypeKO43



[RtdoKO,cellnamesdoKO,genotypedoKO]=ParcoursNewCaracMitral('/Users/karimbenchenane/Documents/Data/Lisa/electroPhy/Data/DATA_spont/doKO');
save DataFinalSpontdoKOJuly2010 RtdoKO cellnamesdoKO genotypedoKO



R=[[Rtctrl,ones(size(Rtctrl,1),1)];[RtKO30,2*ones(size(RtKO30,1),1)];[RtKO43,3*ones(size(RtKO43,1),1)];[RtdoKO,4*ones(size(RtdoKO,1),1)]];





a=1;
for i=1:length(genotypeCtrl)
Genotype{a}=genotypeCtrl{i};
a=a+1;
end
for i=1:length(genotypeKO30)
Genotype{a}=genotypeKO30{i};
a=a+1;
end
for i=1:length(genotypeKO43)
Genotype{a}=genotypeKO43{i};
a=a+1;
end
for i=1:length(genotypedoKO)
Genotype{a}=genotypedoKO{i};
a=a+1;
end
length(Genotype)
length(R)
a=1;
for i=1:length(genotypeCtrl)
Cellnames{a}=cellnamesCtrl{i};
a=a+1;
end
for i=1:length(genotypeKO30)
Cellnames{a}=cellnamesKO30{i};
a=a+1;
end
for i=1:length(genotypeKO43)
Cellnames{a}=cellnamesKO43{i};
a=a+1;
end
for i=1:length(genotypedoKO)
Cellnames{a}=cellnamesdoKO{i};
a=a+1;
end

cd /Users/karimbenchenane/Documents/Data/Lisa/electroPhy/Data/DATA_spont

load DataAnalyseLisaFinal labels
save DataAnalyseLisaFinal R Cellnames Genotype labels



% ---------------------------------------------------------------------------
% ---------------------------------------------------------------------------
% ---------------------------------------------------------------------------



[Rtctrl,cellnamesCtrl,genotypeCtrl]=ParcoursNewCaracMitral('/Users/karimbenchenane/Documents/Data/Lisa/electroPhy/Data/DATA_-60mV/ctrl');
save DataFinal60mVCtrlJuly2010 RtCtrl cellnamesCtrl genotypeCtrl

[RtKO30,cellnamesKO30,genotypeKO30]=ParcoursNewCaracMitral('/Users/karimbenchenane/Documents/Data/Lisa/electroPhy/Data/DATA_-60mV/KO30');
save DataFinal60mV30July2010 RtKO30 cellnamesKO30 genotypeKO30

[RtKO43,cellnamesKO43,genotypeKO43]=ParcoursNewCaracMitral('/Users/karimbenchenane/Documents/Data/Lisa/electroPhy/Data/DATA_-60mV/KO43');
save DataFinal60mVKO43July2010 RtKO43 cellnamesKO43 genotypeKO43

[RtdoKO,cellnamesdoKO,genotypedoKO]=ParcoursNewCaracMitral('/Users/karimbenchenane/Documents/Data/Lisa/electroPhy/Data/DATA_-60mV/doKO');
save DataFinal60mVdoKOJuly2010 RtdoKO cellnamesdoKO genotypedoKO



R=[[Rtctrl,ones(size(Rtctrl,1),1)];[RtKO30,2*ones(size(RtKO30,1),1)];[RtKO43,3*ones(size(RtKO43,1),1)];[RtdoKO,4*ones(size(RtdoKO,1),1)]];





a=1;
for i=1:length(genotypeCtrl)
Genotype{a}=genotypeCtrl{i};
a=a+1;
end
for i=1:length(genotypeKO30)
Genotype{a}=genotypeKO30{i};
a=a+1;
end
for i=1:length(genotypeKO43)
Genotype{a}=genotypeKO43{i};
a=a+1;
end
for i=1:length(genotypedoKO)
Genotype{a}=genotypedoKO{i};
a=a+1;
end
length(Genotype)
length(R)
a=1;
for i=1:length(genotypeCtrl)
Cellnames{a}=cellnamesCtrl{i};
a=a+1;
end
for i=1:length(genotypeKO30)
Cellnames{a}=cellnamesKO30{i};
a=a+1;
end
for i=1:length(genotypeKO43)
Cellnames{a}=cellnamesKO43{i};
a=a+1;
end
for i=1:length(genotypedoKO)
Cellnames{a}=cellnamesdoKO{i};
a=a+1;
end

cd /Users/karimbenchenane/Documents/Data/Lisa/electroPhy/Data/DATA_-60mV

load DataAnalyseLisaFinal labels
save DataAnalyseLisaFinal R Cellnames Genotype labels

end

