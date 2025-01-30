%  PrgParcours

Rt=[];
St=[];
Serra=[];
Serrb=[];

a=1;
cellnames={};
Mois={};
    
cd H:\Electrophy_astros_final

listdir=dir;

for mois=1:length(listdir)


	cd H:\Electrophy_astros_final

	if listdir(mois).isdir==1&listdir(mois).name(1)~='.'


	cd (listdir(mois).name)

	listsousdir=dir;

		for i=1:length(listsousdir)


            if listsousdir(i).isdir==1&listsousdir(i).name(1)~='.'
                
                nom=listsousdir(i).name;
                le=length(listsousdir(i).name);
                eval(['cd ',nom])

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


try


    [Res,S,f,Serr]=AstrosAnalysisLR;

    cellnames{a}=nom;
    Mois{a}=mois;
    
    St=[St;S'];             %S':transposée de S pour avoir une ligne par cellule
    Serra=[Serra;Serr(1,:)];
    Serrb=[Serrb;Serr(2,:)];
    Rt=[Rt;[a,Res]];
    a=a+1;
    

end

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

			
				cd ..

            end




		end

	end




end


figure, imagesc(10*log10(f),[1:size(St,1)],10*log10(St))
xlim([0 0.5])

saveFigure(1,'FinalResult','H:\Electrophy_astros_final')
save FinalResult1 St Serra Serrb Rt
