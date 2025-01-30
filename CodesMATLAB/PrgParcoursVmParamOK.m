%  PrgParcoursVmParamOK



% Ht=[];
% H2t=[];
% probaHt=[];
% probaH2t=[];
% Results=[];


CellnamesOK={};
Success={};
AllNames={};
Mois={};
% NamesResults={};

VmT=[];
STDT=[];
SkewT=[];
NamesV={};
NamesSTD={};


a=1;
k=1;
v=1;
s=1;
% j=1;
    
% cd H:\Electrophy_astros_final
% cd H:\Data_Astros_OUT
cd H:\Data_Astros_IN

listdir=dir;

for mois=1:length(listdir)


% 	cd H:\Electrophy_astros_final
%     cd H:\Data_Astros_OUT
    cd H:\Data_Astros_IN

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
AllNames{a}=nom;

            try

                VmParamSingleLROK;
%                 [h,h2,probaH,probaH2,VmMoy,STD2,Skew2]=VmDistribSingleLROK;

                    try
                            load AnalysisV
                            VmT=[VmT;VmMoy];
                            NamesV{v}=nom;
                            v=v+1;
                    end

                    try
                            load AnalysisVLOC
                            STDT=[STDT;STD2];
                            SkewT=[SkewT;Skew2];
                            NamesSTD{s}=nom;
                            s=s+1;
                    end


                Success{a}='yes';
                CellnamesOK{k}=nom;
                Mois{k}=mois;
                disp 'OK'
                k=k+1;

            catch

                 Success{a}='no';
                 disp 'Failed'

            end
            
% ------------------------------------------

            
            
            
%                 Res=[VmMoy,STD2,Skew2];
%                 Results=[Results;[j,Res]];
%                 NamesResults{j}=nom;
%                 j=j+1;
%             catch
%                 disp 'ResultsFailed'
%             end
    


a=a+1;
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

			
				cd ..

            end




		end

	end




end


% 	cd H:\Electrophy_astros_final
%     cd H:\Data_Astros_OUT
    cd H:\Data_Astros_IN



% save TotalResults Ht H2t probaHt probaH2t CellnamesOK Success AllNames Mois
% save TotalResultsParamOUT CellnamesOK Success AllNames Mois VmT STDT SkewT NamesV NamesSTD
save TotalResultsParamIN CellnamesOK Success AllNames Mois VmT STDT SkewT NamesV NamesSTD
% save TotalResults Ht H2t probaHt probaH2t Results CellnamesOK Success AllNames Mois NamesResults


% ------------------------------------------------------------------------
fid = fopen('NamesSTD.txt','w');
% 
for i=1:length(NamesSTD)
%     
    fprintf(fid,'%s\r\n',NamesSTD{i}); 
% 
end
% 
fclose(fid);

% -------------------------------------------

id = fopen('STDT.txt','w');
for i=1:length(STDT)
    
    fprintf(fid,'%s\r\n',num2str(STDT(i,1)));
end
fclose(fid);

% -------------------------------------------


fid = fopen('NamesV.txt','w');
% 
for i=1:length(NamesV)
%     
    fprintf(fid,'%s\r\n',NamesV{i}); 
% 
end
% 
fclose(fid);

% -------------------------------------------

id = fopen('VmT.txt','w');
for i=1:length(VmT)
    
    fprintf(fid,'%s\r\n',num2str(VmT(i,1)));
end
fclose(fid);


% -------------------------------------------

id = fopen('SkewT.txt','w');
for i=1:length(SkewT)
    
    fprintf(fid,'%s\r\n',num2str(SkewT(i,1)));
end
fclose(fid);

% -------------------------------------------------------------------------




% 
% H2tM=mean(H2t);
% figure, area([-10:0.05:10],smooth(H2tM/sum(H2tM),3))

% figure, imagesc(10*log10(f),[1:size(St,1)],10*log10(St))
% xlim([0 0.5])
% 
% saveFigure(1,'FinalResult','H:\Electrophy_astros_final')
% save FinalResult1 St Serra Serrb Rt
