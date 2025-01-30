function A = AmyhphysDoubles(A)

parent_dir(A)
doubles = List2Cell([parent_dir(A) filesep 'doubles.txt']);
 
A = getResource(A, 'AmygdalaCellList');


A = registerResource(A, 'IsDouble', 'numeric', ...
           {'AmygdalaCellList', 1}, 'isDouble', ...
           ['whether this is tp be considered a double of other recordings']);
           
isDouble = zeros(size(cellnames));

for i = 1:length(cellnames);
    if ismember(cellnames{i}, doubles)
        isDouble(i) = 1;
    end
end


A = saveAllResources(A);

           