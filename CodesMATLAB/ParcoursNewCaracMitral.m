function [Rt,cellnames,genotype]=ParcoursNewCaracMitral(nomgenotype)
% function ParcoursNewCaracMitral(nomgenotype)

eval(['cd ',nomgenotype])
le=length(nomgenotype);
namefile=nomgenotype(le-4:le);

%creation de la liste des mois contenue dans le dossier: listdir
listdir=dir;
a=1;
Rt=[];

for i=1:length(listdir)
    nom=listdir(i).name;
    le=length(nom);
    if length(nom)>2&nom(le-2:le)=='abf'

%         try

    
    close all

   
    %     [Res,m]=MaudAnalysisMitral(nom,1);
% try
%     [Res,n]=PlotNewAnalysisMitral(nom,1);
% [Res,m]=PlotNewAnalysisMitral(nom,2);
% catch
%     [Res,n]=NewAnalysisMitral(nom);
    

    
% end


%--------------------------------------------------------------------------       

% 
% nomL=nom(1:le-4);
% 
% 
% try 
% 
%     eval(['load DataVM',nomL, ' DebutUp'])
%     clear DebutUp
%     eval(['load DataVMmaud',nomL,' DebutUp'])
%     DebutUp;
%     
%     disp(nomL)
% catch 
%     try
%     Res=NewAnalysisMitral(nom);
%     end
%     
%     Res=MaudAnalysisMitral(nom);
%     
% end

%--------------------------------------------------------------------------       


%     [Res,m]=NewAnalysisMitral(nom);
%         Rt=[Rt;Res];
%         cellnames{a}=nom;
%         genotype{a}=namefile;

%--------------------------------------------------------------------------       

        [Res,n]=LastAnalysisMitral(nom,1);

                Rt=[Rt;Res];
        cellnames{a}=nom;
        genotype{a}=namefile;

        k=pwd;
 
        mkdir('FiguresFinal')

      
        eval(['cd ',nomgenotype,'/FiguresFinal'])
        
        fily=pwd;
        
        eval(['saveFigure(n,''',nom(1:le-3),'FigureFinalNo',num2str(a),''',fily)'])

        a=a+1;

        close all

        eval(['cd ',k])


%--------------------------------------------------------------------------
% 
%         k=pwd;
% 
%         mkdir('FiguresNew')
% %         [Res,n]=PlotNewAnalysisMitral(nom,1);
% 
%         Rt=[Rt;Res];
%         cellnames{a}=nom;
%         genotype{a}=namefile;
%         
%         
%         
% % %         PlotMaudAnalysisMitral(nom);
% 
%         eval(['cd ',nomgenotype,'/FiguresNew'])
%         fily=pwd;
%         eval(['saveFigure(n,''',nom(1:le-3),'FigureNo',num2str(a),''',fily)'])
% %         save DataMitralCtrl Rt cellnames genotype
% %         eval(['saveFigure(m,''',nom(1:le-3),'FigureMaudNo',num2str(a),''',fily)'])
% %         eval(['saveFigure(n,''',nom(1:le-3),'FigureMaudBisNo',num2str(a),''',fily)'])
% %         save DataMitralMaud Rt cellnames genotype
%         a=a+1;
% 
%         close all
% 
%         eval(['cd ',k])
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%         catch
%             disp(nom)
%         end %try 17   

    end

end

