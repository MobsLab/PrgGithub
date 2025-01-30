function display(R)
% display(R) deals with displaying resource objs on the command
%  output  
 
  format compact
  
  fprintf(1, 'resource %s:\n\n', R.id);
  fprintf(1, 'variable:\t%s\n', R.varName);
  fprintf(1, 'type:\t\t%s\n', R.type);
  fprintf(1, 'size:\t\t');
  disp(R.dimensions);
  fprintf(1, 'requires:\t\t');
  if isempty(R.requires)
    fprintf(1, '\n');
  else
    disp(R.requires);
  end
  
  fprintf(1, 'providedBy:\n');
  if isempty(R.providedBy)
    fprintf(1, '\n');
  else
    disp(R.providedBy);
  end
  fprintf(1, 'description:\t%s\n', R.description)
  
  