function lm = prune_model(model, type, limit)

% This function prunes a sparse time-frequency bump model
%
% model = ButIf bump model
% type = different types of pruning
%          'ab': removes abnormal bumps (abnormally small amplitude, width or height)
%          'th': remove bumps with an energy threshold
%          'lm': remove all bumps after the N first modeled (modeling order)
%          'or': keep the A first bumps in timely order 
% limit: is not used if type ='ab', must be a real positive value for
% type='lm' and an integer value form type='th' or 'or'
%
% Copyright (C) 2008 Lab. ABSP, Riken (Japan) Francois-B. Vialatte et al.
% Please cite related papers when publishing results obtained with this
% toolbox

if nargin < 2
   disp(['prune_model needs a bump model as first input parameter, and a type as second parameter']);
   return;
end;
if isa(type,'char')
    if (strcmp(type,'ab'))
        lm=prune_clean(model);
        return;
    else
        if nargin < 3
           disp(['prune_model needs limit parameter if type=''ab'' is not used']);
           return;
        end;
        if (strcmp(type,'lm'))
            lm=prune_limit(model,limit);
            return;
        else
            if (strcmp(type,'th'))
                option = 3;
                lm=prune_threshold(model,limit);
                return;
            else
                if (strcmp(type,'or'))
                    option = 4
                    lm=prune_order(model,limit);
                    return;
                else
                    disp(['unknown option: ',options,' - ending program prune_model.m']);
                    return;
                end;
            end;
        end;        
    end;
else
    disp(['unknown option: ',num2str(options),' - ending program prune_model.m']);
    return;
end;
    