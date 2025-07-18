%ParcoursCxCtrlGFAP


% cd
% /Users/karimbenchenane/Documents/Data/DataEnCours/Lisa/QuantifGFPRevision
cd H:\GFAP_Analysis_Border

% try 
%     clear M3t
%     load BilanLisaLongGFAP
%     M3t;
%     
% catch
    
listdir=dir('CH*');
a=1;

   matH30t={};
   matH2t={};
        
        
for Filenum=1:length(listdir)


% cd
% /Users/karimbenchenane/Documents/Data/DataEnCours/Lisa/QuantifGFPRevision
cd H:\GFAP_Analysis_Border

    cd (listdir(Filenum).name)

    try 
        load DataGFAP
    catch
        
    [Nissl,Cx,ni,cx,Mask,Glo]=LoadConnexin(30);
    M=FindGlo(Glo);
    m=length(M);
    
    save DataGFAP Nissl Cx ni cx Mask Glo M m
    
    end
    
    
    for i=1:m
        
        try

        eval(['load ResultlongGFAP',num2str(i),' R30 R2 matH30 matH2 SfT']) 
        
        catch
            
        [R30,SfT,matH30,R2,matH2]=AnalyseCxFile(Nissl,Cx,ni,cx,Mask,Glo,M,i,35);
        
        eval(['save ResultlongGFAP',num2str(i),' R30 R2 matH30 matH2 SfT']) 
        
        end
        
        close all
        
%         keyboard
        try
            R30t=[R30t;R30(:,2)'];
            R2t=[R2t;R2(:,2)'];
        catch
            R30t=R30(:,2)';
            R2t=R2(:,2)';
        end

        matH30t{a}=matH30;
        matH2t{a}=matH2; 

        na=pwd;
        l=length(na);
        numfig=str2num(na(l-1:l));

        Si(a,1)=a;
        Si(a,2)=numfig;
        Si(a,3)=i;
        Si(a,4)=30;
        Si(a,5)=sum(sum(M{i}));
        a=a+1;
        
    end
    
   cd .. 
    
end


% cd
% /Users/karimbenchenane/Documents/Data/DataEnCours/Lisa/QuantifGFPRevision
cd H:\GFAP_Analysis_Border

save BilanLisaLongGFAP Si R30t R2t matH30t matH2t SfT


% end

clear

% -------------------------------------------------------------------------

load BilanLisaLongGFAP


M3t=zscore(R30t')';
M2t=zscore(R2t')';


[BE,id]=sort(mean(M3t(:,15:16)')-mean(M3t(:,13:14)'));




for i=1:length(matH30t)
    es=SmoothDec(zscore(matH30t{i}),[1,0.1]);
    Res(i,:)=mean(es);
    clear es
end


for i=1:length(matH2t)
    es=SmoothDec(zscore(matH2t{i}),[1,0.1]);
    Res2(i,:)=mean(es);
    clear es
end

N3t=zscore(Res')';
N2t=zscore(Res2')';
[BE,id2]=sort(mean(N3t(:,15:16)')-mean(N3t(:,13:14)'));


% Liste des glom d'int�r�t:
% list=[[1:15],[17:22]];
%list=[[1:10],[12:15],[17:22]];
% list=[1:24];
list=[1:43];

[M,S,E]=MeanDifNan(M3t(id(list),:));
[M2,S2,E2]=MeanDifNan(M2t(id(list),:));

%[M,S,E]=MeanDifNan(M3t);
%[M2,S2,E2]=MeanDifNan(M2);

figure('Color',[1 1 1]),

    subplot(2,2,1), imagesc(M3t(id(list),:)), axis xy, title('GFAP')
    subplot(2,2,3), imagesc(M2t(id(list),:)), axis xy, title('Nissl')
    
%     subplot(2,2,1), imagesc(M3t(id,:)), axis xy, title('GFAP')
%     subplot(2,2,3), imagesc(M2t(id,:)), axis xy, title('Nissl')

    subplot(2,2,2), imagesc(N3t(id(list),:)), axis xy, title('GFAP')
    subplot(2,2,4), imagesc(N2t(id(list),:)), axis xy, title('Nissl')
%     C'est juste? Je voulais avoir vraiment la correspondance entre les 2
%     graphes...
    
%     subplot(2,2,2), imagesc(N3t(id2,:)), axis xy, title('GFAP')
%     subplot(2,2,4), imagesc(N2t(id2,:)), axis xy, title('Nissl')

% 
% 
% 
% figure('Color',[1 1 1]),
% 
%     hold on, plot(M,'k','linewidth',2)
%     hold on, plot(M+E,'k')
%     hold on, plot(M-E,'k')
% 
%     hold on, plot(M2,'b','linewidth',2)
%     hold on, plot(M2-E2,'b')
%     hold on, plot(M2+E2,'b')
% 
%     hold on, line([35 35],[-1.5 2],'Color','k')
% 
% xlim([1 45])





load AllDataMeanPetit

[M3,S3,E3]=MeanDifNan(petitCX30m);
[M4,S4,E4]=MeanDifNan(petitCX43m);
[M5,S5,E5]=MeanDifNan([petitNISSL43m;petitNISSL30m]);


figure('Color',[1 1 1]),

    hold on, plot(M,'k','linewidth',2)
    hold on, plot(M+E,'k')
    hold on, plot(M-E,'k')

    hold on, plot(M2,'b','linewidth',2)
    hold on, plot(M2-E2,'b')
    hold on, plot(M2+E2,'b')

    hold on, plot(M3,'r','linewidth',2)
    hold on, plot(M3-E3,'r')
    hold on, plot(M3+E3,'R')
    
    hold on, plot(M4,'g','linewidth',2)
    hold on, plot(M4-E4,'g')
    hold on, plot(M4+E4,'g')
    
    hold on, plot(M5,'b','linewidth',2)
    hold on, plot(M5-E5,'b')
    hold on, plot(M5+E5,'b')
    
    
    hold on, line([35 35],[-1.5 2],'Color','k')
    hold on, line([1 45],[0 0],'Color','k')    
    xlim([1 45])
    
  
    
    
figure('Color',[1 1 1]),


    hold on, plot(M2,'b','linewidth',2)
    hold on, plot(M2-E2,'b')
    hold on, plot(M2+E2,'b')

    hold on, plot(M3-M(1:45),'r','linewidth',2)
    hold on, plot(M3-M(1:45)-E3,'r')
    hold on, plot(M3-M(1:45)+E3,'R')
    
    hold on, plot(M4-M(1:45),'g','linewidth',2)
    hold on, plot(M4-M(1:45)-E4,'g')
    hold on, plot(M4-M(1:45)+E4,'g')
    
    hold on, plot(M5,'b','linewidth',2)
    hold on, plot(M5-E5,'b')
    hold on, plot(M5+E5,'b')
    
    
    hold on, line([35 35],[-1.5 2],'Color','k')
    hold on, line([1 45],[0 0],'Color','k')
    
    xlim([1 45])    
    
    
    
   [h,p30]=ttest2(M3t(id(list),1:45),petitCX30m);
   [h,p43]=ttest2(M3t(id(list),1:45),petitCX43m);
   
   abs=[1:45];
   
   hold on, plot(abs(find(p30<0.06)),ones(length(find(p30<0.06)),1),'ko','markerFaceColor','r')
   hold on, plot(abs(find(p43<0.06)),0.25+ones(length(find(p43<0.06)),1),'ko','markerFaceColor','g')   
   
%    savefigure(1,'GFAPColorPanels','H:\GFAP_Analysis_Border')
%    savefigure(2,'Mean3Curves','H:\GFAP_Analysis_Border')
%    savefigure(3,'CxNormalized','H:\GFAP_Analysis_Border')
   
%    Warning: Could not find an exact (case-sensitive) match for 'savefigure'.
% F:\mes_documents\My Dropbox\Lisa\LastCodesMatlab\saveFigure.m is a case-insensitive match and will be used
% instead.
% You can improve the performance of your code by using exact
% name matches and we therefore recommend that you update your
% usage accordingly. Alternatively, you can disable this warning using
% warning('off','MATLAB:dispatcher:InexactMatch').
   
   
