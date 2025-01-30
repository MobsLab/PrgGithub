function AO = saveGlobalResource(A, id, varName, dimensions, datasets, ...
				outfile, description, value, idx)
% A = saveGlobalResource(A, id, varName, dimensions, datasets, ...
%			outfile, description, value, idx) 
% saves a global resource (i.e. one defined on multiple datasets) in a
% resourcefile
% 
% This is useful when elaborating exisiting resources, to save the
% outcomes
% INPUTS:
% A: an analysis context object
% id: the resource id
% varName: the variable name in the workspace for the resource 
% dimensions: a dimensions cell array (see Resource)
% datasets: which datasets this is defined on 
% outfile: a resourcefile where to save the resource, if existing the new
% resource will be appended 
% description: brief textual description of the resource
% value: value to assume for the resource (NOTE that in this version it
% will be not be checked against claimed dimensions

% copyright (c) 2004 Francesco P. Battaglia
% This software is released under the GNU GPL
% www.gnu.org/copyleft/gpl.html


% determine type of the data to save

if isa(value, 'numeric')
  type = 'numeric';
elseif iscell(value)
  type = 'cell';
elseif isa(value, 'tsdArray')
  type = 'tsdArray';
elseif isa(value, 'dictArray')
  type = 'dictArray';
end


  



% build the new resource object
R.id = id;
R.varName = varName;
R.dimensions = dimensions;

R.description = description 
R.requires = {};

pb.datasets{1} = datasets;
pb.op = {'resourcefile'};
pb.args = { outfile };

R.providedBy = pb;
R.createdBy = callingFunction;

R = Resource(R);



% now save the actual object


eval([id ' = value;']);
eval([id '_idx = idx;']);
outfile_name = [A.parent_dir filesep outfile];
if(exist(outfile_name) == 2)
  save(outfile_name, id, [id '_idx'], '-append')
else
  save(outfile_name, id, [id '_idx'])
end


%register the resource in database  



A.resources{id} = R;
resources = A.resources;
save(A.resourceFile, 'resources');


AO = A;