% SaveInTxt_Astro_Field

% MaxCorrn

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

% -----------------------------------------------------------------------
% -----------------------------------------------------------------------
% MaxCorrp

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
% MaxCorrpSignif

fid = fopen('MaxCorrpSignif','w');

for i=1:length(MaxCorrpSignif)
    
    fprintf(fid,'%s\r\n',num2str(MaxCorrpSignif{i}));

end

fclose(fid);