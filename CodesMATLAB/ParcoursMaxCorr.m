% ParcoursMaxCorr


cellnames={};
MaxAbsCorr=[];
MaxCorrp=[];
MaxCorrp2=[];
MaxCorrn=[];
MaxCorrn2=[];
MaxAbsCorrSignif={};
MaxCorrpSignif={};
MaxCorrpSignif2={};
MaxCorrnSignif={};
MaxCorrnSignif2={};
a=1;

cd H:\Data_Astros_Field

listdir=dir;

for i=1:length(listdir)


	cd H:\Data_Astros_Field

	if listdir(i).isdir==1&listdir(i).name(1)~='.'


	eval (['cd ',listdir(i).name])
    
%     cd (listdir(i).name)

			nom=listdir(i).name;
			le=length(listdir(i).name);
% -------------------------------------------------------------------------
cellnames{a}=nom;
disp(nom)

try
load CrossCorr



                %le max absolu
                [CrMax,id]=max(abs(C));
                lagCrMax=lags(id);
                MaxAbsCorr=[MaxAbsCorr;[CrMax lagCrMax]]; 
                    if CrMax<CRm(id)||CrMax>CRM(id);
                       MaxAbsCorrSignif{a}='yes';
                    else
                       MaxAbsCorrSignif{a}='no';
                    end
                 	disp('MaxAbsCorr ok')
                
                %le max avec un délais positif, corrélations positives:
                Crp=C(lags>0);
                lagsp=lags(lags>0);
                [CrMaxp,id]=max(Crp);
                lagCrMaxp=lagsp(id);
                MaxCorrp=[MaxCorrp;[CrMaxp lagCrMaxp]];
                    if CrMaxp<CRm(id)||CrMaxp>CRM(id);
                       MaxCorrpSignif{a}='yes';
                    else
                       MaxCorrpSignif{a}='no';
                    end
                    
                %le max avec un délais positif,corrélations pos or neg:
                Crp=C(lags>0);
                lagsp=lags(lags>0);
                [CrMaxp2,id2]=max(abs(Crp));
                lagCrMaxp2=lagsp(id);
                MaxCorrp2=[MaxCorrp2;[CrMaxp2 lagCrMaxp2]];
                    if CrMaxp2<CRm(id)||CrMaxp2>CRM(id);
                       MaxCorrpSignif2{a}='yes';
                    else
                       MaxCorrpSignif2{a}='no';
                    end
                 	
                 	disp('MaxCorrP ok')
                
                %le max avec un délais négatif, corrélation positive:
                Crn=C(lags<0);
                lagsn=lags(lags<0);
                [CrMaxn,id]=max(Crn);
                lagCrMaxn=lagsn(id);
                MaxCorrn=[MaxCorrn;[CrMaxn lagCrMaxn]];
                    if CrMaxn<CRm(id)||CrMaxn>CRM(id);
                       MaxCorrnSignif{a}='yes';
                    else
                       MaxCorrnSignif{a}='no';
                    end
                    
                %le max avec un délais négatif, corrélations pos or neg:
                Crn=C(lags<0);
                lagsn=lags(lags<0);
                [CrMaxn2,id2]=max(abs(Crn));
                lagCrMaxn2=lagsn(id2);
                MaxCorrn2=[MaxCorrn2;[CrMaxn2 lagCrMaxn2]];
                    if CrMaxn2<CRm(id)||CrMaxn2>CRM(id);
                       MaxCorrnSignif2{a}='yes';
                    else
                       MaxCorrnSignif2{a}='no';
                    end
                    
                 	disp('MaxCorrN ok')
catch
        MaxAbsCorr=[MaxAbsCorr;[]];
        MaxCorrp=[MaxCorrp;[]];
        MaxCorrp2=[MaxCorrp2;[]];
        MaxCorrn=[MaxCorrn;[]];
        MaxCorrn2=[MaxCorrn2;[]];
        MaxAbsCorrSignif{a}={};
        MaxCorrpSignif{a}={};
        MaxCorrpSignif2{a}={};
        MaxCorrnSignif{a}={};
        MaxCorrnSignif2{a}={};
    
end       
                    
            a=a+1;        
    end
end

cd H:\Data_Astros_Field

save ResultsMaxCorr cellnames MaxAbsCorr MaxCorrp MaxCorrn MaxAbsCorrSignif MaxCorrp2 MaxCorrn2 MaxCorrpSignif MaxCorrnSignif MaxCorrpSignif2 MaxCorrnSignif2
% -------------------------------------------------------------------------
% -----------------------------------------------------------------------
% SaveInTxt_Astro_Field
% -----------------------------------------------------------------------


% MaxAbsCorr

fid = fopen('MaxAbsCorr','w');

for i=1:length(MaxAbsCorr)
    
    fprintf(fid,'%s\r\n',num2str(MaxAbsCorr(i,1)));

end

fclose(fid);
% -----------------------------------------------------------------------
% MaxAbsCorrLag

fid = fopen('MaxAbsCorrLag','w');

for i=1:length(MaxAbsCorr)
    
    fprintf(fid,'%s\r\n',num2str(MaxAbsCorr(i,2)));

end

fclose(fid);

% -------------------------------------------------------------------------
% -------------------------------------------------------------------------

% MaxCorrn (corr positive)

fid = fopen('MaxCorrn','w');

for i=1:length(MaxCorrn)
    
    fprintf(fid,'%s\r\n',num2str(MaxCorrn(i,1)));

end

fclose(fid);

% ----------------------------------------------------------------------
% MaxCorrnLag

fid = fopen('MaxCorrnLag','w');

for i=1:length(MaxCorrn)
    
    fprintf(fid,'%s\r\n',num2str(MaxCorrn(i,2)));

end

fclose(fid);

% -----------------------------------------------------------------------
% MaxCorrn2 (correlation positive ou negative)

fid = fopen('MaxCorrn2','w');

for i=1:length(MaxCorrn2)
    
    fprintf(fid,'%s\r\n',num2str(MaxCorrn2(i,1)));

end

fclose(fid);

% ----------------------------------------------------------------------
% MaxCorrnLag2

fid = fopen('MaxCorrnLag2','w');

for i=1:length(MaxCorrn2)
    
    fprintf(fid,'%s\r\n',num2str(MaxCorrn2(i,2)));

end

fclose(fid);



% -----------------------------------------------------------------------
% -----------------------------------------------------------------------
% MaxCorrp (correlation positive)

fid = fopen('MaxCorrp','w');

for i=1:length(MaxCorrp)
    
    fprintf(fid,'%s\r\n',num2str(MaxCorrp(i,1)));

end

fclose(fid);

% -----------------------------------------------------------------------
% MaxCorrpLag

fid = fopen('MaxCorrpLag','w');

for i=1:length(MaxCorrp)
    
    fprintf(fid,'%s\r\n',num2str(MaxCorrp(i,2)));

end

fclose(fid);

% -----------------------------------------------------------------------
% MaxCorrp2 (correlation positive ou negative)

fid = fopen('MaxCorrp2','w');

for i=1:length(MaxCorrp2)
    
    fprintf(fid,'%s\r\n',num2str(MaxCorrp2(i,1)));

end

fclose(fid);

% -----------------------------------------------------------------------
% MaxCorrpLag2

fid = fopen('MaxCorrpLag2','w');

for i=1:length(MaxCorrp2)
    
    fprintf(fid,'%s\r\n',num2str(MaxCorrp2(i,2)));

end

fclose(fid);


% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% MaxAbsCorrSignif

fid = fopen('MaxAbsCorrSignif','w');

for i=1:length(MaxAbsCorrSignif)
    
    fprintf(fid,'%s\r\n',num2str(MaxAbsCorrSignif{i}));

end

fclose(fid);

% -------------------------------------------------------------------------
% MaxCorrnSignif

fid = fopen('MaxCorrnSignif','w');

for i=1:length(MaxCorrnSignif)
    
    fprintf(fid,'%s\r\n',num2str(MaxCorrnSignif{i}));

end

fclose(fid);

% -------------------------------------------------------------------------
% MaxCorrnSignif2

fid = fopen('MaxCorrnSignif2','w');

for i=1:length(MaxCorrnSignif2)
    
    fprintf(fid,'%s\r\n',num2str(MaxCorrnSignif2{i}));

end

fclose(fid);
% -------------------------------------------------------------------------
% MaxCorrpSignif

fid = fopen('MaxCorrpSignif','w');

for i=1:length(MaxCorrpSignif)
    
    fprintf(fid,'%s\r\n',num2str(MaxCorrpSignif{i}));

end

fclose(fid);

% -------------------------------------------------------------------------
% MaxCorrpSignif2

fid = fopen('MaxCorrpSignif2','w');

for i=1:length(MaxCorrpSignif2)
    
    fprintf(fid,'%s\r\n',num2str(MaxCorrpSignif2{i}));

end

fclose(fid);

% -------------------------------------------------------------------------

