%  ParcoursCompLFPLR
% -------------------------------------------------------------------------

binCrossT=[];
binCrossT2=[];
binCohrT=[];
binCohrT2=[];
cellnames={};
NomSuccess={};
successCross={};
successCohr={};
RlagZero=[];
% MaxAbsCorr=[];
% MaxCorrp=[];
% MaxCorrp2=[];
% MaxCorrn=[];
% MaxCorrn2=[];
% MaxAbsCorrSignif={};
% MaxCorrpSignif={};
% MaxCorrpSignif2={};
% MaxCorrnSignif={};
% MaxCorrnSignif2={};

a=1;

try 
    freq;
    catch
    freq=10000;
end


try
    cd H:\Data_Astros_Field
%     catch
%     cd /Users/karimbenchenane/Documents/Data/Lisa/Data_Astros_Field
end

listdir=dir;

for i=1:length(listdir)

    try
        cd H:\Data_Astros_Field
%         catch
%         cd /Users/karimbenchenane/Documents/Data/Lisa/Data_Astros_Field
    end
    
    
	if listdir(i).isdir==1&listdir(i).name(1)~='.'

            %  	disp('ok step 1')

                eval (['cd ',listdir(i).name])
%                 pwd
            %     cd (listdir(i).name)

                        nom=listdir(i).name;
                        le=length(listdir(i).name);
% -------------------------------------------------------------------------
                        NomSuccess{a}=nom;
                        disp(nom)   
        
                    try
                        % Analyse du croscorrelogramme:
                        [Cr,Cp,P,lags,CRm,CRM,r,p]=CorrAstroFieldforLoopLR;
                            close all
                            disp('Corr ok')
                        [binCross,lCross]=PoolData(Cr,lags,[-200:10:200]);
                            disp('PoolData Corr ok')
                        [binCross2,lCross2]=PoolData(Cp,lags,[-200:10:200]);
                            disp('PoolData Corr ok')

                        binCrossT=[binCrossT;binCross];
                        binCrossT2=[binCrossT2;binCross2];
                        RlagZero=[RlagZero;[r p]];
                            disp('Data added ok')

                        successCross{a}='yes';
% ------------------------------------------------------------------------
% VOIR: ParcoursMaxCorr
% ------------------------------------------------------------------------
                
%                 %le max absolu
%                 [CrMax,id]=max(abs(Cr));
%                 lagCrMax=lags(id);
%                 MaxAbsCorr=[MaxAbsCorr;[CrMax lagCrMax]]; 
%                     if CrMax<CRm(id)||CrMax>CRM(id);
%                        MaxAbsCorrSignif{a}='yes';
%                     else
%                        MaxAbsCorrSignif{a}='no';
%                     end
%                  	disp('MaxAbsCorr ok')
%                 
%                 %le max avec un d�lais positif, corr�lations positives:
%                 Crp=Cr(lags>0);
%                 lagsp=lags(lags>0);
%                 [CrMaxp,id]=max(Crp);
%                 lagCrMaxp=lagsp(id);
%                 MaxCorrp=[MaxCorrp;[CrMaxp lagCrMaxp]];
%                     if CrMaxp<CRm(id)||CrMaxp>CRM(id);
%                        MaxCorrpSignif{a}='yes';
%                     else
%                        MaxCorrpSignif{a}='no';
%                     end
%                     
%                 %le max avec un d�lais positif,corr�lations pos or neg:
%                 Crp=Cr(lags>0);
%                 lagsp=lags(lags>0);
%                 [CrMaxp2,id2]=max(abs(Crp));
%                 lagCrMaxp2=lagsp(id);
%                 MaxCorrp2=[MaxCorrp2;[CrMaxp2 lagCrMaxp2]];
%                     if CrMaxp2<CRm(id)||CrMaxp2>CRM(id);
%                        MaxCorrpSignif2{a}='yes';
%                     else
%                        MaxCorrpSignif2{a}='no';
%                     end
%                  	
%                  	disp('MaxCorrP ok')
%                 
%                 %le max avec un d�lais n�gatif, corr�lation positive:
%                 Crn=Cr(lags<0);
%                 lagsn=lags(lags<0);
%                 [CrMaxn,id]=max(Crn);
%                 lagCrMaxn=lagsn(id);
%                 MaxCorrn=[MaxCorrn;[CrMaxn lagCrMaxn]];
%                     if CrMaxn<CRm(id)||CrMaxn>CRM(id);
%                        MaxCorrnSignif{a}='yes';
%                     else
%                        MaxCorrnSignif{a}='no';
%                     end
%                     
%                 %le max avec un d�lais n�gatif, corr�lations pos or neg:
%                 Crn=Cr(lags<0);
%                 lagsn=lags(lags<0);
%                 [CrMaxn2,id2]=max(abs(Crn));
%                 lagCrMaxn2=lagsn(id2);
%                 MaxCorrn2=[MaxCorrn2;[CrMaxn2 lagCrMaxn2]];
%                     if CrMaxn2<CRm(id)||CrMaxn2>CRM(id);
%                        MaxCorrnSignif2{a}='yes';
%                     else
%                        MaxCorrnSignif2{a}='no';
%                     end
%                     
%                  	disp('MaxCorrN ok')
         
        catch
%             
            binCross=[];        %comment ajouter un vecteur vide?
            binCross2=[];
            binCrossT=[binCrossT;binCross];
            binCrossT2=[binCrossT2;binCross2];
            RlagZero=[RlagZero;[0 0]];
            successCross{a}='no';
%             CrMaxp=0;
%             lagCrMaxp=0;
%             CrMaxn=0;
%             lagCrMaxn=0;
%             CrMax=0;
%             lagCrMax=0;
%             MaxAbsCorr=[MaxAbsCorr;[CrMax lagCrMax]];
%             MaxCorrp=[MaxCorrp;[CrMaxp lagCrMaxp]];
%             MaxCorrn=[MaxCorrn;[CrMaxn lagCrMaxn]];
            
            
        end   
%  ------------------------------------------------------------------------
% PROBLEME � ce niveau pour le calcul de binCohrT et binCohrT2!!!
% ------------------------------------------------------------------------
    try
            % Analyse de la coherence:
            [C,CP,f,p,phi]=CoherencyAstroFieldforLoopLR;
                close all
             	disp('Coherency ok')

            [binCohr,lCohr]=PoolData(C,f,[0:0.005:0.1]);
            binCohrT=[binCohrT;binCohr];
             	disp('PoolData Coherency ok')

            [binCohr2,lCohr2]=PoolData(CP,f,[0:0.005:0.1]);
            binCohrT2=[binCohrT2;binCohr2];
             	disp('PoolData Coherency2 ok')
                successCohr{a}='yes';
    catch
       binCohr=[];          % je voudrais pouvoir ajouter une ligne vide...
       binCohr2=[];
       binCohrT=[binCohrT;binCohr];
       binCohrT2=[binCohrT2;binCohr2];
       successCohr{a}='no';
    end

    a=a+1;
  
%   cd .

    end
end




try
	cd H:\Data_Astros_Field
    catch
        cd /Users/karimbenchenane/Documents/Data/Lisa/Data_Astros_Field
end
    
% % save ResultsCompLFP cellnames binCrossT binCrossT2 binCohrT binCohrT2 MaxAbsCorr MaxCorrp MaxCorrn MaxCorrp2 MaxCorrn2 lCross lCross2 lCohr lCohr2 MaxAbsCorrSignif MaxCorrpSignif MaxCorrnSignif MaxCorrpSignif2 MaxCorrnSignif2
save ResultsCompLFP cellnames binCrossT binCrossT2 binCohrT binCohrT2 lCross lCross2 lCohr lCohr2 successCross successCohr RlagZero
% save ResultsCompLFPbis lCross lCross2 lCohr lCohr2

% -------------------------------------------------------------------------
% successCross
fid = fopen('successCross','w');

for i=1:length(successCross)
    
    fprintf(fid,'%s\r\n',num2str(successCross{i}));

end

fclose(fid);
% -------------------------------------------------------------------------
% successCohr
fid = fopen('successCohr','w');

for i=1:length(successCohr)
    
    fprintf(fid,'%s\r\n',num2str(successCohr{i}));

end

fclose(fid);
% -----------------------------------------------------------------------

% RlagZero:

fid = fopen('RlagZero','w');

for i=1:length(RlagZero)
    
    fprintf(fid,'%s\r\n',num2str(RlagZero(i,1)));

end

fclose(fid);
% -----------------------------------------------------------------------
% PlagZero

fid = fopen('PlagZero','w');

for i=1:length(RlagZero)
    
    fprintf(fid,'%s\r\n',num2str(RlagZero(i,2)));

end

fclose(fid);

% -------------------------------------------------------------------------
% -------------------------------------------------------------------------

% ------------------------------------------------------------------------
% FIGURES FINALES
% ------------------------------------------------------------------------
try
	cd H:\Data_Astros_Field
    catch
        cd /Users/karimbenchenane/Documents/Data/Lisa/Data_Astros_Field
    end

figure, imagesc(lCross,[1:size(binCrossT,1)],binCrossT)
figure,plot(lCross,mean(binCrossT))
% savefigure(1,'CrossCorrTotColor','H:\Data_Astros_Field')
% savefigure(2,'CrossCorrTotMean','H:\Data_Astros_Field')

    set(1,'paperPositionMode','auto')

    eval(['print -f',num2str(1),' -dpng ','CrossCorrTotColor','.png'])

    eval(['print -f',num2str(1),' -painters',' -depsc2 ','CrossCorrTotColor','.eps'])


    set(2,'paperPositionMode','auto')

    eval(['print -f',num2str(2),' -dpng ','CrossCorrTotMean','.png'])

    eval(['print -f',num2str(2),' -painters',' -depsc2 ','CrossCorrTotMean','.eps'])


close all



figure, imagesc(lCross2,[1:size(binCrossT2,1)],binCrossT2)
figure,plot(lCross2,mean(binCrossT2))
% savefigure (1,'CrossCorrTotColor2','H:\Data_Astros_Field')
% savefigure (2,'CrossCorrTotMean2','H:\Data_Astros_Field')
    
    set(1,'paperPositionMode','auto')

    eval(['print -f',num2str(1),' -dpng ','CrossCorrTotColor2','.png'])

    eval(['print -f',num2str(1),' -painters',' -depsc2 ','CrossCorrTotColor2','.eps'])


    set(2,'paperPositionMode','auto')

    eval(['print -f',num2str(2),' -dpng ','CrossCorrTotMean2','.png'])

    eval(['print -f',num2str(2),' -painters',' -depsc2 ','CrossCorrTotMean2','.eps'])


close all

% -------------------------------------------------------------------------
% Coherence
% PROBLEME de taille de vecteurs (diff�rente)       A RESOUDRE

figure, imagesc(lCohr,[1:size(binCohrT,1)],binCohrT)
figure,plot(lCohr,mean(binCohrT))
% savefigure (1,'CoherencyTotColor','H:\Data_Astros_Field')
% savefigure (2,'CoherencyTotMean','H:\Data_Astros_Field')

    set(1,'paperPositionMode','auto')

    eval(['print -f',num2str(1),' -dpng ','CoherencyTotColor','.png'])

    eval(['print -f',num2str(1),' -painters',' -depsc2 ','CoherencyTotColor','.eps'])


    set(2,'paperPositionMode','auto')

    eval(['print -f',num2str(2),' -dpng ','CoherencyTotMean','.png'])

    eval(['print -f',num2str(2),' -painters',' -depsc2 ','CoherencyTotMean','.eps'])

% close all



figure, imagesc(lCohr2,[1:size(binCohrT2,1)],binCohrT2)
figure,plot(lCohr2,mean(binCohrT2))
% savefigure (1,'CoherencyTotColor2','H:\Data_Astros_Field')
% savefigure (2,'CoherencyTotMean2','H:\Data_Astros_Field')

    set(1,'paperPositionMode','auto')

    eval(['print -f',num2str(1),' -dpng ','CoherencyTotColor2','.png'])

    eval(['print -f',num2str(1),' -painters',' -depsc2 ','CoherencyTotColor2','.eps'])


    set(2,'paperPositionMode','auto')

    eval(['print -f',num2str(2),' -dpng ','CoherencyTotMean2','.png'])

    eval(['print -f',num2str(2),' -painters',' -depsc2 ','CoherencyTotMean2','.eps'])

% close all


% end
