function trm = cleanfnam(innam)
%  This function strips illegal characters from a string for use
%  as a file name.  There is an array of characters in the function that 
%  additional characters can be added to.
%
%                 trm = cleanfnam(innam)
% 
%   Input:  INNAM = array string of characters
%   Output:  TRM = array string of characters with illegal characters
%   stripped.
%
%    Written by Kevin D. Donohue (kevin.donohue@sigsoln.com ) April 2009

illchar = ['.', ',', '/', '\', ' '];   %  String of illegal characters

trm = innam;  %  Initailize output string to input string
%  Loop through each illegal character and remove from output array
for k = 1:length(illchar)
    gg = findstr(innam,illchar(k));
    %  If characters found, remove them
    if ~isempty(gg)
        trm = innam(1:(gg(1)-1));
        for kgg=2:length(gg)
            trm = [trm, innam((gg(kgg-1)+1):(gg(kgg)-1))];
        end
        trm = [trm, innam((gg(end)+1):end)];
    end
     %  Assign trimmed array to next array to be tested and trimmed of next
     %  character
    innam = trm; 
end