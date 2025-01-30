%%GetSignalsNightFromSelectData
% 10.03.2018 KJ
%
% After using 'SelectData('selectionmode','lasso')':
%  - get 
%
% function idx_point = SelectSignalsNightFromLasso(xs,ys)
%
%   see 
%       Clustering_Curves_KJ SelectData
%


function idx_point = SelectSignalsNightFromLasso(xs,ys,X)

    for i=1:length(xs)
        if ~isempty(xs{i})
            k=i;
        end
    end

    %init
    X = X(:,1:2);
    xs = xs{k};
    ys = ys{k};
    
    xys = [xs ys];
    
    idx_point = find(ismember(X,xys,'rows'));
    
end



% %manual clustering
% new_clusterX = nan(length(clusterX),1);
% k=1;
% 
% [pind,xs,ys] = SelectData('selectionmode','lasso');
% idx_point = SelectSignalsNightFromLasso(xs,ys,X); new_clusterX(idx_point)=k; k=k+1;