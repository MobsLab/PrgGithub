%  PrgParcoursFinalResults_LR_180810

% PROBLEM en fin de programme avec:
% save FinalResult1 St Serra Serrb Rt cellnames Mois (� faire manuellement)
%-----------------------------------------------------------------
Rt=[];
St=[];
Serra=[];
Serrb=[];

a=1;
cellnames={};
Mois={};

%-----------------------------------------------------------------
cd H:\Electrophy_astros_final

listdir=dir;

for mois=1:length(listdir)


	cd H:\Electrophy_astros_final  %n�cessaire mais POURQUOI??

	if listdir(mois).isdir==1&listdir(mois).name(1)~='.'    %doit �tre un dossier et sa 1�re lettre diff�rente d un point


	cd (listdir(mois).name) %dans le dossier du mois

	listsousdir=dir;    %liste des �l�ments dans le dossier mois

		for i=1:length(listsousdir)

            
                if listsousdir(i).isdir==1&listsousdir(i).name(1)~='.'  %doit �tre un dossier et sa 1�re lettre diff�rente d un point

                
                    nom=listsousdir(i).name;
                    le=length(listsousdir(i).name);
                    eval(['cd ',nom])   %dans le dossier de la cellule

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
    cellnames{a}=nom;
    

try

    load Analysis
    Res=[VmMoy,STD,Error,Skew];
    Mois{a}=listdir(mois).name;
    %[Res,S,f,Serr]=AstrosAnalysisLR;
    
    Rt=[Rt;[a,Res]];
    
end

try

    load Spectre
    St=[St;S'];             %S':transpos�e de S pour avoir une ligne par cellule
    Serra=[Serra;Serr(1,:)];
    Serrb=[Serrb;Serr(2,:)];
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


% figure, imagesc(10*log10(f),[1:size(St,1)],10*log10(St))
% xlim([0 0.5])

% saveFigure(1,'FinalResult','H:\Electrophy_astros_final')
cd .

save FinalResult1 St Serra Serrb Rt cellnames Mois   %ATTENTION: ne fonctionne pas tout le temps: � faire manuellement dans MATMAB
