
%%
GetEmbReactMiceFolderList_BM
edit Drugs_Groups_UMaze_BM.m

Session_type={'TestPre'};

for sess=1:length(Session_type) 
    [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type{sess}),'accelero','linearposition','heartrate','respi_freq_BM');
end

M=zeros(length(Mouse),1)
X=linspace(1,length(Mouse),length(Mouse))
for m=1:length(Mouse)
     M(m,1)=mean(Data(OutPutData.TestPre.linearposition.tsd{m, 1}))
end

plot(X,M,'r:+')

chi2gof(M)

for mouse=1:83
    h=histogram(runmean(Data(OutPutData.TestPre.linearposition.tsd{mouse, 1}),30) , 100);
    g(mouse,:)=h.Values;
end

plot(nanmean(g))
plot(g(2,:))


plot(Data(OutPutData.TestPre.linearposition.tsd{2,1}))










plot(runmean(Data(OutPutData.TestPre.linearposition.tsd{1, 1}),30))
plot(Data(OutPutData.TestPre.linearposition.tsd{1, 1}))

A = Data(OutPutData.TestPre.linearposition.tsd{1,1});
indicemax=length(A);
B = zeros(indicemax,1);
x = 0.1;
for i=1:indicemax
    if A(i,1) < x
        B(i,1) = 1;
    end
    if A(i,1) > 1-x
        B(i,1) = 1;
    end
end
a= sum(B)/indicemax      % Taux d'occupation des coins 





for mouse=1:83
    u(mouse)=sum(g(mouse,:)<10 | and(g(mouse,:)>31,g(mouse,:)<38) | and(g(mouse,:)>63,g(mouse,:)<70) | g(mouse,:)>90)/100;
end 
    
plot(u)
ylabel('anxiety index')
hold on 
plot(sum(g(:,1:50),2)./sum(g(:,1:100),2),'g')

% en bleu taux d'anxiété (taux d'occupation des coins par les souris)
% en vert taux d'assymétrie (si sup a 0.5 la souris est plus souvent a
% droite et inversement)
























