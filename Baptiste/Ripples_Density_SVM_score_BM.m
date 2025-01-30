
load('Data_Physio_Freezing_Saline_all_Cond_2sFullBins')
load('SVM_Sal_MouseByMouse_CondPost.mat', 'classifier_controltrain_ByPar')
Session_type={'Cond'};

clear Data_mouse
for mouse=1:length(Mouse)
    for ep=1:length(Start(Epoch1.Cond{mouse,3}))
        try
            clear FzEp D D2 score
            FzEp = subset(Epoch1.Cond{mouse,3},ep);
            for par=[1:5 7:8]
                D(par) = nanmean(Data(Restrict(OutPutData.Cond.(Params{par}).tsd{mouse,1} , FzEp)));
            end
            D = D([1:5 7:8]);
            for parToUse=1:7
                try
                    D2 = D(~isnan(D));
                    [~,score] = predict(classifier_controltrain_ByPar{parToUse},D2);
                end
            end
            score;
        catch
            score=NaN;
        end
        Data_mouse{mouse}(ep,1) = nanmean(Data(Restrict(OutPutData.Cond.ripples_density.tsd{mouse,1} , FzEp)));
        Data_mouse{mouse}(ep,2) = score(1);
    end
    mouse
end

mouse=30;
plot(Data_mouse{mouse}(:,2) , Data_mouse{mouse}(:,1),'.k')



clear MAP R P
figure
for sess=1:length(Session_type)
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        try
            if size(Data_mouse{mouse},1)>40
                MAP.(Session_type{sess})(mouse,:,:) = hist2d([Data_mouse{mouse}(:,2)' -4 4 -4 4] , [Data_mouse{mouse}(:,1)' 0 0 1.5 1.5] ,100,100);
                MAP.(Session_type{sess})(mouse,:,:) = MAP.(Session_type{sess})(mouse,:,:)./nansum(nansum(MAP.(Session_type{sess})(mouse,:,:)));
                %
                %                 MAP.(Session_type{sess})(mouse,:,:) = hist2d([scores2_test_ByMouse{mouse}(:,1)' -1.4 1.4 -1.4 1.4] , [RipDensity{mouse}+(rand(1,length(RipDensity{mouse}))*.2)-.1 -.1 -.1 1.5 1.5] ,100,100);
%                 MAP.(Session_type{sess})(mouse,:,:) = MAP.(Session_type{sess})(mouse,:,:)./nansum(nansum(MAP.(Session_type{sess})(mouse,:,:)));
%                 
%                 [R.(Session_type{sess})(mouse),P.(Session_type{sess})(mouse),a.(Session_type{sess})(mouse),b.(Session_type{sess})(mouse)]=...
%                     PlotCorrelations_BM(scores2_test_ByMouse{mouse}(:,1) , DATA.(Session_type{sess}).(Mouse_names{mouse})(6,:));
            else
                MAP.(Session_type{sess})(mouse,:,:) = NaN(100,100);
            end
        end
    end
%     R.(Session_type{sess})(R.(Session_type{sess})==0)=NaN;
%     P.(Session_type{sess})(P.(Session_type{sess})==0)=NaN;
end
% R.Cond(4)=NaN;
close

A = squeeze(nanmean(MAP.Cond));
A(58,11)=0;
imagesc(linspace(-4,4,100) , linspace(0,1.5,100) , SmoothDec(zscore(A)',2)), axis xy, colormap jet
caxis([-.25 .5])
xlim([-2.5 3]), ylim([0 1.2])
xlabel('SVM score (a.u.)'), ylabel('SWR occurence (#/s)')
axis square

