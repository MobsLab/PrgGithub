%  PrgParcoursPowerSpectrumAstros

% PROBLEM en fin de programme avec:
% save FinalResult1 St Serra Serrb Rt cellnames Mois (à faire manuellement)
%-----------------------------------------------------------------
% % R2t=[];
% S2t=[];
% Serr2at=[];
% Serr2bt=[];
% 
% a=1;
% cellnames2={};
% Mois2={};

%-----------------------------------------------------------------
cd H:\Electrophy_astros_final_test_codeLR


listdir=dir;

for mois=1:length(listdir)

%     cd H:\Electrophy_astros_final
	cd H:\Data_electrophy_astros_test_codeLR %nécessaire mais POURQUOI??

	if listdir(mois).isdir==1&listdir(mois).name(1)~='.'    %doit être un dossier et sa 1ère lettre différente d un point


	cd (listdir(mois).name) %dans le dossier du mois

	listsousdir=dir;    %liste des éléments dans le dossier mois

		for i=1:length(listsousdir)

            
                if listsousdir(i).isdir==1&listsousdir(i).name(1)~='.'  %doit être un dossier et sa 1ère lettre différente d un point

                
                    nom=listsousdir(i).name;
                    le=length(listsousdir(i).name);
                    eval(['cd ',nom])   %dans le dossier de la cellule

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
[C,Cp,P,lags]=CorrAstroFieldLR;    
% cellnames2{a}=nom;
    
% try
%     [yf,f,spe,f2,S2,Serr2,Serr2a,Serr2b,S3,t3,f3,C,lag,lags]=PowerSpectrumLR;
% try
% 
%     load Analysis
%     Res=[VmMoy,STD,Error,Skew];
%     Mois2{a}=listdir(mois).name;
% Mois2{a}=mois;
%     %[Res,S,f,Serr]=AstrosAnalysisLR;
%     
%     Rt=[Rt;[a,Res]];
%     
% end


%     load Spectre2
    S2t=[S2t;S2'];             %S':transposée de S pour avoir une ligne par cellule
    Serr2at=[Serr2at;Serr2(1,:)];
    Serr2bt=[Serr2bt;Serr2(2,:)];
%     Rt=[Rt;[a,Res]];
    
   

end

a=a+1;
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

			
				cd ..

            end




		end

	end




end


% figure, imagesc(10*log10(f2),[1:size(S2t,1)],10*log10(S2t))
% xlim([0 0.5])

% saveFigure(1,'FinalResult2','H:\Electrophy_astros_final')
cd .

save FinalResult2 S2t Serr2at Serr2bt cellnames2 Mois2   %ATTENTION: ne fonctionne pas tout le temps: à faire manuellement dans MATMAB
