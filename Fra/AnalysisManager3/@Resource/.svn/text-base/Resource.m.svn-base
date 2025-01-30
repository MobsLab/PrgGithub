function R = Resource(S)
% R = Resource(S) constructor for the resource class   
% S is a structure that contains the same fields as R
% Fields are
% id: name of the variable, it could be different from varname as there
% may be different "versions" of the variable
% 
% varName: equals the name of the variable it will be referred by in scripts
% 
% type: numeric
%       cell array
%       tsdArray
%       dictArray
% 
% dimensions:
%       can be specified as number, or as dimensions related to other resource
%       {'cells', 1}, or it can be an empty array, to signal that this is
%       a "primary" dimension, and no check are to be performed on it.
% 
% 
% requires:
% 	list fo resources that should be in the workspace, before
% 	running function 
% 
% providedBy:
%       who provides this resource; can be:
%       'mfile: foo.mat' for resources contained in a m-file local to the dataset
%       'resourcefile: resource.mat' for resources contained in a
%       resource file local to the  dataset 
%       'run: function(varargin); runs the function locally to the
%       dataset '
%       'list': ascii file local to the dataset, use the List2Cell
%       function 
%       
%       providedby is a structure with fields
%       dataset: can be list of names of datasets the rule applies to,
%       or '*' if it applies to all. 
%       'op', the type of operation to make
%       'args': the arguments to either option       
%       that is, op can be one of 'resourcefile, run, list, mfile',
% 
% 
% description: 
%       brief description of the resource 

% copyright (c) 2004 Francesco P. Battaglia
% This software is released under the GNU GPL
% www.gnu.org/copyleft/gpl.html

  
  
% check all arguments
  
  if nargin == 0
    R.id = [];
    R.varName = [];
    R.type = [];
    R.dimensions = [];
    R.requires = [];
    R.providedBy = [];
    R.description = [];
    R.createTime = '';
    R.modifyTime = '';
    R.createdBy = '';
    R = class(R, 'Resource');
    return
  end
  
  
  if ~ischar(S.id)
    error('field id must be string');
  end
  
  if ~ischar(S.varName)
    error('field varname must be string');
  end
  
  switch S.type
   case { 'numeric', 'cell', 'tsdArray', 'dictArray'}
    ;
   otherwise
    error('illegal value for field type');
  end
  
  if ~iscell(S.dimensions)
    error('field dimensions must be a cell array');
    % in the future make check more stringent
  end
  
  if ~iscell(S.requires)
    error('field requires must be a cell array');
  end
  
  
  
  
  
  if ~checkProvidedBy(S.providedBy)
    error('illegal value for field provided by');
  end
  
  
  if ~ischar(S.description)
    error('field description must be string');
  end
  
  
  % copy all fields and create object
  
  R.id = S.id;
  R.varName = S.varName;
  R.type = S.type;
  R.dimensions = S.dimensions;
  R.requires = S.requires;
  R.providedBy = S.providedBy;
  R.description = S.description;
  R.createTime = datestr(now);
  R.modifyTime = datestr(now);
  R.createdBy = S.createdBy;
  
  R = class(R, 'Resource');
  
  
  
  
  