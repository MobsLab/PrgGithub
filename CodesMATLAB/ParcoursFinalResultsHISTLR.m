% ParcoursFinalResultsHISTLR

% PROBLEM en fin de programme avec:
% save FinalResult1 St Serra Serrb Rt cellnames Mois (à faire manuellement)
%-----------------------------------------------------------------
Rt=[];
% St=[];
% Serra=[];
% Serrb=[];

a=1;
j=1;
NamesTot={};
NamesOK={};
Mois={};
Success={};

%-----------------------------------------------------------------
cd H:\Electrophy_astros_final

listdir=dir;

for mois=1:length(listdir)


	cd H:\Electrophy_astros_final  %nécessaire mais POURQUOI??

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
    NamesTot{a}=nom;
    Mois{a}=listdir(mois).name;
    

        try

            load VmDistrib
            Res=[h,h2,probaH,probaH2];
            Rt=[Rt;[j,Res]];
            NamesOK{j}=nom;
            Success{a}='yes';
            j=j+1;
            
        catch

            Success{a}='no';
            disp 'HistFailed'

        end

try

    load Spectre
    St=[St;S'];             %S':transposée de S pour avoir une ligne par cellule
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

save FinalResultHIST Rt NamesTot NamesOK Mois Success %ATTENTION: ne fonctionne pas tout le temps: à faire manuellement dans MATMAB
