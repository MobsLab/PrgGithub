figure
ha = tight_subplot(5,10);
for mouse = 1:size(VarE.MnShockSpec,1)
    axes(ha(mouse))
    plot(Spectro{3},VarE.MnShockSpec(mouse,:))
    hold on
    plot(Spectro{3},VarE.MnSafeSpec(mouse,:))
    xlim([0 10])
    title([num2str(VarE.MouseID(mouse)) VarE.DrugType{mouse}])
end


MouseToUse_DZP = [11205,11204,11189,11184,11147];
MouseToUse_Sal = [1205,1204,1189,1184,1147];
figure
for m = 1:length(MouseToUse_DZP)
    subplot(5,2,(m-1)*2+1)
    id = find(VarE.MouseID==MouseToUse_DZP(m));
    plot(Spectro{3},VarE.MnShockSpec(id,:),'r')
    hold on
    plot(Spectro{3},VarE.MnSafeSpec(id,:),'b')
    title(num2str(MouseToUse_DZP(m)))
    xlim([0 10])
    
    
    subplot(5,2,(m-1)*2+2)
    id = find(VarE.MouseID==MouseToUse_Sal(m));
    plot(Spectro{3},VarE.MnShockSpec(id,:),'r')
    hold on
    plot(Spectro{3},VarE.MnSafeSpec(id,:),'b')
    title(num2str(MouseToUse_Sal(m)))
    xlim([0 10])
end

figure
for m = 1:length(MouseToUse_DZP)
    subplot(5,2,(m-1)*2+1)
    id = find(VarCond.MouseID==MouseToUse_DZP(m));
    plot(Spectro{3},VarCond.MnShockSpec(id,:),'r')
    hold on
    plot(Spectro{3},VarCond.MnSafeSpec(id,:),'b')
    title(num2str(MouseToUse_DZP(m)))
    xlim([0 10])
    AllDZP_Sk(m,:) = VarCond.MnShockSpec(id,:)./nansum(VarCond.MnShockSpec(id,10:end));
    AllDZP_Sf(m,:) = VarCond.MnSafeSpec(id,:)./nansum(VarCond.MnSafeSpec(id,10:end));

    subplot(5,2,(m-1)*2+2)
    id = find(VarCond.MouseID==MouseToUse_Sal(m));
    plot(Spectro{3},VarCond.MnShockSpec(id,:),'r')
    hold on
    plot(Spectro{3},VarCond.MnSafeSpec(id,:),'b')
    title(num2str(MouseToUse_Sal(m)))
    xlim([0 10])
       AllSal_Sk(m,:) = VarCond.MnShockSpec(id,:)./nansum(VarCond.MnShockSpec(id,10:end));
    AllSal_Sf(m,:) = VarCond.MnSafeSpec(id,:)./nansum(VarCond.MnSafeSpec(id,10:end));
end

figure
subplot(121)
plot(Spectro{3},nanmean(AllDZP_Sk),'r')
hold on
plot(Spectro{3},nanmean(AllDZP_Sf),'b')
xlim([0 10])
title('DZP')

subplot(122)
plot(Spectro{3},nanmean(AllSal_Sk),'r')
hold on
plot(Spectro{3},nanmean(AllSal_Sf),'b')
xlim([0 10])
title('SAL')


figure
plot(Spectro{3},AllSal_Sk','r')
hold on
plot(Spectro{3},AllSal_Sf','b')


%%
figure
for m = 1:length(MouseToUse_DZP)
    subplot(5,2,(m-1)*2+1)
    id = find(VarE.MouseID==MouseToUse_DZP(m));
    plot(Spectro{3},VarE.MnShockSpec(id,:),'r')
    hold on
    plot(Spectro{3},VarE.MnSafeSpec(id,:),'b')
    title(num2str(MouseToUse_DZP(m)))
    xlim([0 10])
    AllDZP_Sk(m,:) = VarE.MnShockSpec(id,:)./nansum(VarE.MnShockSpec(id,10:end));
    AllDZP_Sf(m,:) = VarE.MnSafeSpec(id,:)./nansum(VarE.MnSafeSpec(id,10:end));
    
    subplot(5,2,(m-1)*2+2)
    id = find(VarE.MouseID==MouseToUse_Sal(m));
    plot(Spectro{3},VarE.MnShockSpec(id,:),'r')
    hold on
    plot(Spectro{3},VarE.MnSafeSpec(id,:),'b')
    title(num2str(MouseToUse_Sal(m)))
    xlim([0 10])
    AllSal_Sk(m,:) = VarE.MnShockSpec(id,:)./nansum(VarE.MnShockSpec(id,10:end));
    AllSal_Sf(m,:) = VarE.MnSafeSpec(id,:)./nansum(VarE.MnSafeSpec(id,10:end));
end

figure
subplot(121)
plot(Spectro{3},nanmean(AllDZP_Sk),'r')
hold on
plot(Spectro{3},nanmean(AllDZP_Sf),'b')
xlim([0 10])
title('DZP')

subplot(122)
plot(Spectro{3},nanmean(AllSal_Sk),'r')
hold on
plot(Spectro{3},nanmean(AllSal_Sf),'b')
xlim([0 10])
title('SAL')
