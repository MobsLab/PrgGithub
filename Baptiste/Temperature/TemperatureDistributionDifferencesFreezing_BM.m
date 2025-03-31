
%% Look if differences

MTempData=MTempData2;

for mouse=1:length(Mouse)
    MTempDataFz.(Mouse_names{mouse})=Restrict(MTempData.(Mouse_names{mouse}),FzEpoch.(Mouse_names{mouse}));
end

for mouse=1:length(Mouse)
    MTempData.(Mouse_names{mouse})=Data(MTempData.(Mouse_names{mouse}))-FearMeanMTemp(mouse,3);
    MTempDataFz.(Mouse_names{mouse})=Data(MTempDataFz.(Mouse_names{mouse}))-FearMeanMTemp(mouse,3);
end

for mouse=1:length(Mouse)
    divide.(Mouse_names{mouse})=round(length(MTempData.(Mouse_names{mouse}))/100)
    for n=1:99
        MTempDataDivided.(Mouse_names{mouse})(n)=nanmean(MTempData.(Mouse_names{mouse})(1+(n-1)*divide.(Mouse_names{mouse}):n*divide.(Mouse_names{mouse})))
    end
end

for mouse=1:length(Mouse)
    subplot(2,5,mouse)
    histfit(MTempDataDivided.(Mouse_names{mouse}),20)
    a=vline(FearMeanMTemp(mouse,2),'-k'); a.LineWidth=2;
end










