function AO = registerResource(A, resourceName, resourceType, resourceDimensions, resourceVarName, resourceDescription, sMode)
% registerResource(A, resourceName, resourceType, resourceDimensions [,
% resourceVarName, resourceDescription, overwrite]) register resource in
% resource database 
%  
% The resource will be registered as providedBy the outfile being created
% by the analysis object, with no requires dependency
% INPUTS:  
% A: the Analysis context object  
% resourceName: name of the resource to create    
% resourceType: type of the resource, see RESOURCE for more info
% resourceDimensions: a cell array with the cell dimensions, see RESOURCE
% for more info 
% ResourceVarName (optional): the name of the resource variable in the matlab
% workspace
% resourceDescription: string with brief description of the resource 
% OUTPUTS: 
% AO: the output (modified) version of the Analysis context object  
  
% copyright (c) 2004 Francesco P. Battaglia
% This software is released under the GNU GPL
% www.gnu.org/copyleft/gpl.html

  if nargin < 4 | nargin > 7
    error(['Call as registerResource(A, resourceName, resourceType,' ...
	   ' resourceDimensions [, resourceVarName, resourceDescription,' ...
	    ' overwrite])']);
  end
  
  if nargin > 4
    varName = resourceVarName;
  else
    varName = resourceName;
  end
  
  if nargin > 5
    description = resourceDescription;
  else
    description = '';
  end
  
  if nargin > 6
      saveMode = sMode;
  else
      saveMode = 'resourcefile';
  end
  
  
    ow = A.ow;
 
  cf = callingFunction;
  
  if ~has_key(A.resourcesFromFunc, cf)
    A.resourcesFromFunc{cf} = {};
  end

  
  % if already registered just change modifyTime
  if ismember(resourceName, A.resourcesFromFunc{cf})
      A.resources{resourceName} = setModifyTime(A.resources{resourceName});
      AO = A;
    return
  end
  
  
  
  % if nto voerwrite and encoutered for the first time and existent in
  % resource database verify that resource object is compatible with current parameters and load the file in the data structures
  if (~ow) & A.existFile & (~ismember(resourceName, A.resourcesFromFunc{cf})) & has_key(A.resources, resourceName)

      R = A.resources{resourceName};
      if ~ strcmp(resourceType, getType(R))
          error(['type mismatch for existing resource ' resourceName]);
      end
      if ~cellcmp(resourceDimensions, getDimensions(R));
          error(['dimensions mismatch for existing resource ' resourceName]);
      end
      
      % uploading existing data 
      old = load(A.existFile, [resourceName], [resourceName '_idx']);
      eval(['A.saveRes{''' resourceName '''} = old.' resourceName ';']);
      eval(['A.saveResIdx{''' resourceName '''} = old.' resourceName '_idx;']);      
      
  else

      % create resource subject
      S.id = resourceName;
      S.type = resourceType;
      S.varName = varName;
      S.dimensions = resourceDimensions;
      S.requires = {};
      pb.op = { saveMode };
      pb.args = { A.outFile };
      pb.dataset{1} = {};
      S.providedBy = pb;
      S.description = description;
      S.createdBy = callingFunction;
      R = Resource(S);
  end

  % register resource 
  resources = A.resources;
  A.resources{resourceName} = R;
  A.newResources = [A.newResources {resourceName}];
  

  
  if ~ismember(resourceName, A.resourcesFromFunc{cf})
    f = A.resourcesFromFunc{cf};
    f{end+1} = resourceName;
    A.resourcesFromFunc{cf} = f;
  end
  
  A.resources{resourceName} = setModifyTime(A.resources{resourceName});

  AO = A;
  
  
    function eq = cellcmp(A, B)
        
        eq = 1;
        if length(A) ~= length(B) 
            eq = 0;
            return
        end
        
        for i = 1:length(A)
            if isa(A{i}, 'numeric')
                if ~isa(B{i}, 'numeric')
                    eq = 0;
                    return
                end
                if A{i} ~= B{i}
                    eq = 0;
                    return
                end
            end

            if(isa(A{i}, 'char'))
                if ~isa(B{i}, 'char')
                    eq = 0;
                    return 
                end
                if ~strcmp(A{i}, B{i})
                    eq = 0;
                    return
                end
            end
        end
        
        
                
