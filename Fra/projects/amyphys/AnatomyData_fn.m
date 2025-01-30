function AO = AnatomyData_fn(A)
  
  load([parent_dir(A) filesep 'anatomyTable.mat']);

  A = registerResource(A, 'MonkeySubjectCell', 'numeric', ...
      		       {'AmygdalaCellList', 1}, 'monkeySubjectCell', ...
                    ['which monkey each cell was recorded from']);
  
  A = registerResource(A, 'AnatomyData', 'cell', ...
		       {'AmygdalaCellList', 1}, 'anatomyData', ...
		       ['which nucleus the cell it''s in: ', ...
		    'b: basal, l: lateral, bl:basal/lateral, ', ...
		    'si: substantia innominata']);
  
  A = getResource(A, 'AmygdalaCellList');
  A = getResource(A, 'MonkeySubject');
  anatomyData = {};
  
  monkeySubjectCell = monkeySubject * ones(length(cellnames), 1);
  
  for i = 1:length(cellnames)
    try
      anatomyData{i} = anatomyTable{cellnames{i}};
    catch
      display(['Missing anatomical info for ' cellnames{i}]);
      anatomyData{i} = 'xx';
    end
    
  end
  
  anatomyData = anatomyData(:);
  
  A = saveAllResources(A);
  
  AO = A;
  
  
  