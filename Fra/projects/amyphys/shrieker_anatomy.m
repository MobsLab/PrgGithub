fid = fopen('shrieker_cells.txt', 'r');
load anatomyTable

d = dictArray;

ct = 1;

while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end	
    [a, ct] = sscanf(tline, '%s\t%s\n');
    anatomyTable{a(1:end-1)} = a(end);
end
