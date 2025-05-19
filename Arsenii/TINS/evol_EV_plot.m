%well this is yet to be modified

close all;

%{
parameters.IsSaveFig = 0;
parameters.calc = 'PCA';
parameters.nmice = 1168;
%}

%rewrite names
if parameters.calc == 'PCA'
    cond_50 = table2array(readtable(['50_PCA_Mean_over_epochs_param_Mouse' num2str(parameters.nmice) '_templateEpoch_cond.xlsx']));
    cond_75 = table2array(readtable(['75_PCA_Mean_over_epochs_param_Mouse' num2str(parameters.nmice) '_templateEpoch_cond.xlsx']));
    cond_95 = table2array(readtable(['95_PCA_Mean_over_epochs_param_Mouse' num2str(parameters.nmice) '_templateEpoch_cond.xlsx']));
    
    condRip_50 = table2array(readtable(['50_PCA_Mean_over_epochs_param_Mouse' num2str(parameters.nmice) '_templateEpoch_condRip.xlsx']));
    condRip_75 = table2array(readtable(['75_PCA_Mean_over_epochs_param_Mouse' num2str(parameters.nmice) '_templateEpoch_condRip.xlsx']));
    condRip_95 = table2array(readtable(['95_PCA_Mean_over_epochs_param_Mouse' num2str(parameters.nmice) '_templateEpoch_condRip.xlsx']));
    
    postRip_50 = table2array(readtable(['50_PCA_Mean_over_epochs_param_Mouse' num2str(parameters.nmice) '_templateEpoch_postRip.xlsx']));
    postRip_75 = table2array(readtable(['75_PCA_Mean_over_epochs_param_Mouse' num2str(parameters.nmice) '_templateEpoch_postRip.xlsx']));
    postRip_95 = table2array(readtable(['95_PCA_Mean_over_epochs_param_Mouse' num2str(parameters.nmice) '_templateEpoch_postRip.xlsx']));

elseif parameters.calc == 'ICA'
    cond_50 = table2array(readtable(['50_ICA_Mean_over_epochs_param_Mouse' num2str(parameters.nmice) '_templateEpoch_cond.xlsx']));
    cond_75 = table2array(readtable(['75_ICA_Mean_over_epochs_param_Mouse' num2str(parameters.nmice) '_templateEpoch_cond.xlsx']));
    cond_95 = table2array(readtable(['95_ICA_Mean_over_epochs_param_Mouse' num2str(parameters.nmice) '_templateEpoch_cond.xlsx']));
    
    condRip_50 = table2array(readtable(['50_ICA_Mean_over_epochs_param_Mouse' num2str(parameters.nmice) '_templateEpoch_condRip.xlsx']));
    condRip_75 = table2array(readtable(['75_ICA_Mean_over_epochs_param_Mouse' num2str(parameters.nmice) '_templateEpoch_condRip.xlsx']));
    condRip_95 = table2array(readtable(['95_ICA_Mean_over_epochs_param_Mouse' num2str(parameters.nmice) '_templateEpoch_condRip.xlsx']));
    
    postRip_50 = table2array(readtable(['50_ICA_Mean_over_epochs_param_Mouse' num2str(parameters.nmice) '_templateEpoch_postRip.xlsx']));
    postRip_75 = table2array(readtable(['75_ICA_Mean_over_epochs_param_Mouse' num2str(parameters.nmice) '_templateEpoch_postRip.xlsx']));
    postRip_95 = table2array(readtable(['95_ICA_Mean_over_epochs_param_Mouse' num2str(parameters.nmice) '_templateEpoch_postRip.xlsx']));
end

absc = [0.78 1.78 2.78 3.78; 1 2 3 4;1.22 2.22 3.22 4.22];

err_cond = [nanstd(cond_50(:,1))/sqrt(length(cond_50(:,1))) nanstd(cond_50(:,2))/sqrt(length(cond_50(:,2))) nanstd(cond_50(:,3))/sqrt(length(cond_50(:,3))) nanstd(cond_50(:,4))/sqrt(length(cond_50(:,4)));
    nanstd(cond_75(:,1))/sqrt(length(cond_75(:,1))) nanstd(cond_75(:,2))/sqrt(length(cond_75(:,2))) nanstd(cond_75(:,3))/sqrt(length(cond_75(:,3))) nanstd(cond_75(:,4))/sqrt(length(cond_75(:,4)));
    nanstd(cond_95(:,1))/sqrt(length(cond_95(:,1))) nanstd(cond_95(:,2))/sqrt(length(cond_95(:,2))) nanstd(cond_95(:,3))/sqrt(length(cond_95(:,3))) nanstd(cond_95(:,4))/sqrt(length(cond_95(:,4)))];

meanized_cond = [mean(cond_50(:,1)) mean(cond_50(:,2)) mean(cond_50(:,3)) mean(cond_50(:,4)); ...
    mean(cond_75(:,1)) mean(cond_75(:,2)) mean(cond_75(:,3)) mean(cond_75(:,4)); ...
    mean(cond_95(:,1)) mean(cond_95(:,2)) mean(cond_95(:,3)) mean(cond_95(:,4))];


err_condRip = [nanstd(condRip_50(:,1))/sqrt(length(condRip_50(:,1))) nanstd(condRip_50(:,2))/sqrt(length(condRip_50(:,2))) nanstd(condRip_50(:,3))/sqrt(length(condRip_50(:,3))) nanstd(condRip_50(:,4))/sqrt(length(condRip_50(:,4)));
    nanstd(condRip_75(:,1))/sqrt(length(condRip_75(:,1))) nanstd(condRip_75(:,2))/sqrt(length(condRip_75(:,2))) nanstd(condRip_75(:,3))/sqrt(length(condRip_75(:,3))) nanstd(condRip_75(:,4))/sqrt(length(condRip_75(:,4)));
    nanstd(condRip_95(:,1))/sqrt(length(condRip_95(:,1))) nanstd(condRip_95(:,2))/sqrt(length(condRip_95(:,2))) nanstd(condRip_95(:,3))/sqrt(length(condRip_95(:,3))) nanstd(condRip_95(:,4))/sqrt(length(condRip_95(:,4)))];

meanized_condRip = [mean(condRip_50(:,1)) mean(condRip_50(:,2)) mean(condRip_50(:,3)) mean(condRip_50(:,4)); ...
    mean(condRip_75(:,1)) mean(condRip_75(:,2)) mean(condRip_75(:,3)) mean(condRip_75(:,4)); ...
    mean(condRip_95(:,1)) mean(condRip_95(:,2)) mean(condRip_95(:,3)) mean(condRip_95(:,4))];


err_postRip = [nanstd(postRip_50(:,1))/sqrt(length(postRip_50(:,1))) nanstd(postRip_50(:,2))/sqrt(length(postRip_50(:,2))) nanstd(postRip_50(:,3))/sqrt(length(postRip_50(:,3))) nanstd(postRip_50(:,4))/sqrt(length(postRip_50(:,4)));
    nanstd(postRip_75(:,1))/sqrt(length(postRip_75(:,1))) nanstd(postRip_75(:,2))/sqrt(length(postRip_75(:,2))) nanstd(postRip_75(:,3))/sqrt(length(postRip_75(:,3))) nanstd(postRip_75(:,4))/sqrt(length(postRip_75(:,4)));
    nanstd(postRip_95(:,1))/sqrt(length(postRip_95(:,1))) nanstd(postRip_95(:,2))/sqrt(length(postRip_95(:,2))) nanstd(postRip_95(:,3))/sqrt(length(postRip_95(:,3))) nanstd(postRip_95(:,4))/sqrt(length(postRip_95(:,4)))];

meanized_postRip = [mean(postRip_50(:,1)) mean(postRip_50(:,2)) mean(postRip_50(:,3)) mean(postRip_50(:,4)); ...
    mean(postRip_75(:,1)) mean(postRip_75(:,2)) mean(postRip_75(:,3)) mean(postRip_75(:,4)); ...
    mean(postRip_95(:,1)) mean(postRip_95(:,2)) mean(postRip_95(:,3)) mean(postRip_95(:,4))];


figure
h = bar([1,2,3,4],meanized_condRip, 'FaceColor','flat');
set(gca,'Xtick',[1:4],'XtickLabel',{'PreSleep', 'FreeExplo', 'Learning', 'PostSleep'});
set(h, {'DisplayName'}, {'EV50','EV75','EV95'}');
h(3).FaceColor = [.594 0 1];
h(1).FaceColor = [0 .906 1];
h(2).FaceColor = [0 .25 1];
ylabel('PC score');
xlabel("Epoch");
legend()
title(['Comparison of CondRip results between different EV for ' calc num2str(nmice)])

hold on
errorbar(absc,meanized_condRip,zeros(size(absc)),err_condRip,'+','Color','k', 'HandleVisibility','off');
for i=1:size(absc,1)
    for j=1:size(absc,2)
        if i==1
                plot(absc(i,j)+0.04, condRip_50(:,j) ,'o', 'MarkerFaceColor','white','MarkerEdgeColor', 'black', 'HandleVisibility','off');
        elseif i==2
                plot(absc(i,j)+0.04, condRip_75(:,j) ,'o', 'MarkerFaceColor','white','MarkerEdgeColor', 'black', 'HandleVisibility','off');
        elseif i == 3
                 plot(absc(i,j)+0.04, condRip_95(:,j) ,'o', 'MarkerFaceColor','white','MarkerEdgeColor', 'black', 'HandleVisibility','off');
        end
    end
end
hold off

if IsSaveFig == 1
    if calc == "PCA"
        saveas(gcf, ['PCA_Comp_EV_param_' num2str(nmice) '_templateEpoch_condRip.png']);
        saveas(gcf, ['PCA_Comp_EV_param_' num2str(nmice) '_templateEpoch_condRip.svg']);
    elseif calc == "ICA"
        saveas(gcf, ['ICA_Comp_EV_param_' num2str(nmice) '_templateEpoch_condRip.png']);
        saveas(gcf, ['ICA_Comp_EV_param_' num2str(nmice) '_templateEpoch_condRip.svg']);  
    end
end


figure
h = bar([1,2,3,4], meanized_postRip, 'FaceColor','flat');
set(gca,'Xtick',[1:4],'XtickLabel',{'PreSleep', 'FreeExplo', 'Learning', 'PostSleep'});
set(h, {'DisplayName'}, {'EV50','EV75','EV95'}');
h(3).FaceColor = [.594 0 1];
h(1).FaceColor = [0 .906 1];
h(2).FaceColor = [0 .25 1];
ylabel('PC score');
xlabel("Epoch");
legend()
title(['Comparison of postRip results between different EV for ' calc num2str(nmice)])

hold on
errorbar(absc,meanized_postRip,zeros(size(absc)),err_postRip,'+','Color','k', 'HandleVisibility','off');
for i=1:size(absc,1)
    for j=1:size(absc,2)
        if i==1
                plot(absc(i,j)+0.04, postRip_50(:,j) ,'o', 'MarkerFaceColor','white','MarkerEdgeColor', 'black', 'HandleVisibility','off');
        elseif i==2
                plot(absc(i,j)+0.04, postRip_75(:,j) ,'o', 'MarkerFaceColor','white','MarkerEdgeColor', 'black', 'HandleVisibility','off');
        elseif i == 3
                 plot(absc(i,j)+0.04, postRip_95(:,j) ,'o', 'MarkerFaceColor','white','MarkerEdgeColor', 'black', 'HandleVisibility','off');
        end
    end
end
hold off

if IsSaveFig == 1
    if calc == "PCA"
        saveas(gcf, ['PCA_Comp_EV_param_' num2str(nmice) '_templateEpoch_postRip.png']);
        saveas(gcf, ['PCA_Comp_EV_param_' num2str(nmice) '_templateEpoch_postRip.svg']);
    elseif calc == "ICA"
        saveas(gcf, ['ICA_Comp_EV_param_' num2str(nmice) '_templateEpoch_postRip.png']);
        saveas(gcf, ['ICA_Comp_EV_param_' num2str(nmice) '_templateEpoch_postRip.svg']);  
    end
end



figure
h = bar([1,2,3,4], meanized_cond, 'FaceColor','flat');
set(gca,'Xtick',[1:4],'XtickLabel',{'PreSleep', 'FreeExplo', 'Learning', 'PostSleep'});
set(h, {'DisplayName'}, {'EV50','EV75','EV95'}');
h(3).FaceColor = [.594 0 1];
h(1).FaceColor = [0 .906 1];
h(2).FaceColor = [0 .25 1];
ylabel('PC score');
xlabel("Epoch");
legend()
title(['Comparison of Cond results between different EV for ' calc num2str(nmice)])

hold on
errorbar(absc,meanized_cond,zeros(size(absc)),err_cond,'+','Color','k', 'HandleVisibility','off');
for i=1:size(absc,1)
    for j=1:size(absc,2)
        if i==1
                plot(absc(i,j)+0.04, cond_50(:,j) ,'o', 'MarkerFaceColor','white','MarkerEdgeColor', 'black', 'HandleVisibility','off');
        elseif i==2
                plot(absc(i,j)+0.04, cond_75(:,j) ,'o', 'MarkerFaceColor','white','MarkerEdgeColor', 'black', 'HandleVisibility','off');
        elseif i == 3
                 plot(absc(i,j)+0.04, cond_95(:,j) ,'o', 'MarkerFaceColor','white','MarkerEdgeColor', 'black', 'HandleVisibility','off');
        end
    end
end
hold off

if IsSaveFig == 1
    if calc == "PCA"
        saveas(gcf, ['PCA_Comp_EV_param_' num2str(nmice) '_templateEpoch_cond.png']);
        saveas(gcf, ['PCA_Comp_EV_param_' num2str(nmice) '_templateEpoch_cond.svg']);
    elseif calc == "ICA"
        saveas(gcf, ['ICA_Comp_EV_param_' num2str(nmice) '_templateEpoch_cond.png']);
        saveas(gcf, ['ICA_Comp_EV_param_' num2str(nmice) '_templateEpoch_cond.svg']);  
    end
end

na50_75 = size(cond_75(:,1), 1) - size(cond_50(:,1), 1)
na75_95 = size(cond_95(:,1), 1) - size(cond_75(:,1), 1)
na50_95 = size(cond_95(:,1), 1) - size(cond_50(:,1), 1)

[a,h] = signrank([cond_50(:,1) ;NaN(na50_75, 1)], cond_75(:,1))
[b,h] = signrank([cond_75(:,1) ;NaN(na75_95, 1)], cond_95(:,1))
[c,h] = signrank([cond_50(:,1) ; NaN(na50_95, 1)], cond_95(:,1))

a = signrank(cond_50(:,2), cond_75(:,2))
b = signrank(cond_75(:,2), cond_95(:,2))
c = signrank(cond_50(:,2), cond_95(:,2))

a = signrank(cond_50(:,3), cond_75(:,3))
b = signrank(cond_75(:,3), cond_95(:,3))
c = signrank(cond_50(:,3), cond_95(:,3))

a = signrank(cond_50(:,4), cond_75(:,4))
b = signrank(cond_75(:,4), cond_95(:,4))
c = signrank(cond_50(:,4), cond_95(:,4))

disp("condRip")
a = signrank(condRip_50(:,1), condRip_75(:,1))
b = signrank(condRip_75(:,1), condRip_95(:,1))
c = signrank(condRip_50(:,1), condRip_95(:,1))

a = signrank(condRip_50(:,2), condRip_75(:,2))
b = signrank(condRip_75(:,2), condRip_95(:,2))
c = signrank(condRip_50(:,2), condRip_95(:,2))

a = signrank(condRip_50(:,3), condRip_75(:,3))
b = signrank(condRip_75(:,3), condRip_95(:,3))
c = signrank(condRip_50(:,3), condRip_95(:,3))

a = signrank(condRip_50(:,4), condRip_75(:,4))
b = signrank(condRip_75(:,4), condRip_95(:,4))
c = signrank(condRip_50(:,4), condRip_95(:,4))

disp("postRip")
a = signrank(postRip_50(:,1), postRip_75(:,1))
b = signrank(postRip_75(:,1), postRip_95(:,1))
c = signrank(postRip_50(:,1), postRip_95(:,1))

a = signrank(postRip_50(:,2), postRip_75(:,2))
b = signrank(postRip_75(:,2), postRip_95(:,2))
c = signrank(postRip_50(:,2), postRip_95(:,2))

a = signrank(postRip_50(:,3), postRip_75(:,3))
b = signrank(postRip_75(:,3), postRip_95(:,3))
c = signrank(postRip_50(:,3), postRip_95(:,3))

a = signrank(postRip_50(:,4), postRip_75(:,4))
b = signrank(postRip_75(:,4), postRip_95(:,4))
c = signrank(postRip_50(:,4), postRip_95(:,4))

%{
%% STATISTICAL TESTS

thresh_signif=0.05;  % stat param: threshold for statistical significance

    if strcmp(optiontest,'signrank')
        pval=nan(N,N);
        groups = cell(0);
        stats = [];
        for c=1:length(column_test)
            i = column_test{c}(1);
            j = column_test{c}(2);
            if sum(~isnan(A{i}))>2 && sum(~isnan(A{j}))>2
                if paired
                    idx=find(~isnan(A{i}) & ~isnan(A{j}));
                    [p,h]= signrank(A{i}(idx),A{j}(idx));
                else
                    [p,h]=signrank(A{i}(~isnan(A{i})),A{j}(~isnan(A{j})));
                end
                pval(i,j)=p; pval(j,i)=p;
                if h==1 && ShowSig==1
                    groups{length(groups)+1}=[i j];
                    stats = [stats p];
                elseif h==0 && ShowNS==1
                    groups{length(groups)+1}=[i j];
                    stats = [stats p];
                end
           end
        end
        stats(stats>thresh_signif)=nan;
        if ~horizontal
            sigstar_DB(groups,stats,0,'LineWigth',16,'StarSize',24);
        else
            sigstarh(groups,stats)
        end
%}