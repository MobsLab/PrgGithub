clear basolateral_ix basal_ix lateral_ix si_ix

basolateral = (regexp( AnatomyData, 'bl'));
basal = (regexp(AnatomyData, '^b$'));
lateral = (regexp( AnatomyData, '^l$'));
si = (regexp(AnatomyData, 'si'));


for i = 1:length(basal)
  basolateral_ix(i) = ~isempty(basolateral{i});
  basal_ix(i) = ~isempty(basal{i});
  lateral_ix(i) = ~isempty(lateral{i});
  si_ix(i) = ~isempty(si{i});
end

  basolateral_ix = basolateral_ix(:);
  basal_ix = basal_ix(:);
  lateral_ix = lateral_ix(:);
  si_ix = si_ix(:);
  
  