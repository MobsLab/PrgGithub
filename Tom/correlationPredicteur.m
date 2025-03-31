function ListCorr = correlationPredicteur(ListMicePred)
% ListMicePred : List( Table(predicteurs souris 1), Table(predicteurs souris 2) ...) 
    ListCorr = cell(1,length(ListMicePred));
    for i = 1:length(ListMicePred)
        ListCorr(i) = corrcoef(table2array(ListMicePred(i)));
        figure;
        imagesc(ListCorr(i))
        xlabel(ListMicePred.Properties.VariableNames)
        ylabel(ListMicePred.Properties.VariableNames)
    end
    
        
end

