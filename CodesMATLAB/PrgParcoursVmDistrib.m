%  PrgParcoursVmDistrib

% Rt=[];
% St=[];
% Serra=[];
% Serrb=[];

Ht=[];
H2t=[];
probaHt=[];
probaH2t=[];


CellnamesOK={};
Success={};
NamesSuccess={};
Mois={};

a=1;
k=1;
    
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
disp(nom)
NamesSuccess{a}=nom;

try

    [h,h2,probaH,probaH2]=VmDistribSingleLR;
    close all
    
    Ht=[Ht;h];
    H2t=[H2t;h2];
    probaHt=[probaHt;probaH];
    probaH2t=[probaH2t;probaH2];
    
    
%     St=[St;S'];             %S':transposée de S pour avoir une ligne par cellule
%     Serra=[Serra;Serr(1,:)];
%     Serrb=[Serrb;Serr(2,:)];
%     Rt=[Rt;[a,Res]];
    
    
    Success{a}='yes';
    CellnamesOK{k}=nom;
    Mois{k}=mois;
    disp 'OK'
    k=k+1;
    
catch
    
     Success{a}='no';
     disp 'Failed'

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


figure, imagesc(10*log10(f),[1:size(St,1)],10*log10(St))
xlim([0 0.5])

saveFigure(1,'FinalResult','H:\Electrophy_astros_final')
save FinalResult1 St Serra Serrb Rt
