

MiceNum = [692 693 718 756 758 763];

clear nn xx yy
for i = 1:length(MiceNum)
    [nn(i,:,:),xx(i,:,:),yy(i,:,:)]=AnlaysisDensityFearOdor(['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/FearOdorPoject/FearOdor_Cat/SLEEP-Mouse-',num2str(MiceNum(i)),'-13072018-Sleep_00']);
    nn(i,:,:) = SmoothDec(squeeze(nn(i,:,:)),1);
    nn(i,:,:) = nn(i,:,:)/sum(sum(nn(i,:,:)));
end

for i = 1:length(MiceNum)
    [nnl(i,:,:),xxl(i,:,:),yyl(i,:,:)]=AnlaysisDensityFearOdor(['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/FearOdorPoject/FearOdor_Cat/SLEEP-Mouse-',num2str(MiceNum(i)),'-13072018-Sleep_01']);
        nnl(i,:,:) = SmoothDec(squeeze(nnl(i,:,:)),1);
            nnl(i,:,:) = nnl(i,:,:)/sum(sum(nnl(i,:,:)));

end

for i = 1:length(MiceNum)
    [nnh(i,:,:),xxh(i,:,:),yyh(i,:,:)]=AnlaysisDensityFearOdor(['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/FearOdorPoject/FearOdor_Cat/SLEEP-Mouse-',num2str(MiceNum(i)),'-13072018-Sleep_02']);
        nnh(i,:,:) = SmoothDec(squeeze(nnh(i,:,:)),1);
    nnh(i,:,:) = nnh(i,:,:)/sum(sum(nnh(i,:,:)));

end

figure
subplot(131)
imagesc(xx(i,:), yy(i,:),squeeze(mean(nn(:,:,:))))
title('control condition')
subplot(132)
imagesc(xxl(i,:), yyl(i,:),squeeze(mean(nnl(:,:,:))))
title('litter')
subplot(133)
imagesc(xxh(i,:), yyh(i,:),squeeze(mean(nnh(:,:,:))))
title('hairs')
suptitle('Mice position densiy map')

figure
subplot(311)
plot(squeeze(mean(nn,2))','k'), hold on
hold on
plot(mean(squeeze(mean(nn,2)))','r','linewidth',2), hold on
ylim([0 1.8*1E-3])
ylabel('Proportion of time')
title('control condition ')
patch([0 5 5 0],[0 0 0.001 0.001],1)
subplot(312)
plot(squeeze(mean(nnl,2))','k')
hold on
plot(mean(squeeze(mean(nnl,2)))','r','linewidth',2), hold on
ylim([0 1.8*1E-3])
ylabel('Proportion of time')
title('litter ')
patch([0 5 5 0],[0 0 0.001 0.001],1)
subplot(313)
plot(squeeze(mean(nnh,2))','k')
hold on
plot(mean(squeeze(mean(nnh,2)))','r','linewidth',2), hold on
ylim([0 1.8*1E-3])
ylabel('Proportion of time')
xlabel('Mice position')
title('hairs ')
patch([0 5 5 0],[0 0 0.001 0.001],1)
