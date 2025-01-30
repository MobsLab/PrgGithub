function textout(fname, carry)
%  This function takes a similar input to Matlab's xlswrite() and outputs 
%  a csv file (as a text file).
%
%     textout(fname, carry)
%
%  where FNAME is the string for the ouput file name (good idea to end it
%  with a "cvs" extension), and CARRY is a cell array with the contents of
%  each cell.
%
%   written by Kevin D. Donohue (kevin.donohue@sigsoln.com) 12/22/2010

fid = fopen(fname,'wt');  %  Create file (will overwrite old if exists)
[r,c] = size(carry);   %  Get size of cell array to output
%  Loop to go write each row, except for last row
for kr=1:r-1
    % Loop to write each element in row for all except last entry
    for kc=1:c-1
        if isstr(carry{kr,kc})
            fprintf(fid,'%s,',carry{kr,kc});
        else
            fprintf(fid,'%s,', num2str(carry{kr,kc}));
        end
    end
    %  Ouput last line with line feed
    kc = c;
    if isstr(carry{kr,kc})
        fprintf(fid,'%s\n',carry{kr,kc});
    else
        fprintf(fid,'%s\n', num2str(carry{kr,kc}));
    end
end
%last row
   kr = r;
   for kc=1:c-1
        if isstr(carry{kr,kc})
            fprintf(fid,'%s,',carry{kr,kc});
        else
            fprintf(fid,'%s,', num2str(carry{kr,kc}));
        end
    end
    %  Ouput last row and column without line feed
    %   or comma/space
    kc = c;
    if isstr(carry{kr,kc})
        fprintf(fid,'%s',carry{kr,kc});
    else
        fprintf(fid,'%s', num2str(carry{kr,kc}));
    end
    fclose(fid);
