function [pval,stats,groups]=addSigStarML(A,option_test)

% function [pval,stats,groups]=addSigStarML(A,option_test)
% option_test = 'signrank' (default),'ttest' (paired), 'ttest2' (unpaired),
% from PlotErrorBarN_KJ.m

L=size(A,2);

if ~exist('option_test','var')
    option_test='signrank';
end
if sum(strcmp(option_test,{'signrank','ttest','ttest2'}))~=1
    error('incorrect option_test')
end

pval=nan(L); stats = []; groups = cell(0);
for c1=1:L
    for c2=c1+1:L
        try
            idx=find(~isnan(A(:,c1)) & ~isnan(A(:,c2)));
            if strcmp(option_test,'signrank')
                [p,h]= signrank(A(idx,c1),A(idx,c2));
            elseif strcmp(option_test,'ttest')
                [h,p]= ttest(A(idx,c1),A(idx,c2));
            elseif strcmp(option_test,'ttest2')
                [h,p]= ttest2(A(idx,c1),A(idx,c2));
            end
            pval(c1,c2)=p; pval(c2,c1)=p;
            if h==1, groups{length(groups)+1}=[c1 c2]; stats = [stats p];end
        end
    end
end
stats(stats>0.05)=nan;
sigstar(groups,stats)