function A = AmyhphysDoubles(A)

fname = List2Cell([parent_dir(A) filesep 'doubles.txt']);
doubles = List2Cell(fname);



  
A = getResource(A, 'AmygdalaCellList');


A = registerResource(A, 'IsDouble', 'numeric', ...
           {'AmygdalaCellList', 1}, 'isDouble', ...
           ['whether this is tp be considered a double of other recordings']);
       

           
           
isDouble = zeros(size(cellnames));

for i = 1:length(cellnames);
    if ismember(cellnames{i}, doubles)
        isDouble = 1;
    end
end


A = saveAllResources(A);

           