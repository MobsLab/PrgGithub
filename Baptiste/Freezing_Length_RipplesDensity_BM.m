

% ripples density and episodes duration
clear all
Mouse=Drugs_Groups_UMaze_BM(11);
Session_type={'Cond','Ext'};

for sess=1:length(Session_type)
    [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),...
'ripples','respi_freq_bm');
end

for mouse=1:length(Mouse)
    for ep=1:length(Start(Epoch1.Cond{mouse,3}))
        try
        FzEp = subset(Epoch1.Cond{mouse,3},ep);
        FzLength{mouse}(ep) = sum(DurationEpoch(FzEp))/1e4;
        FzRipDens{mouse}(ep) = length(Restrict(OutPutData.Cond.ripples.ts{mouse,1} , FzEp))/FzLength{mouse}(ep);
        end
    end
    disp({mouse})
end

size_map=100;
figure
for mouse=1:length(Mouse)
    try, [R(mouse),P(mouse)]=PlotCorrelations_BM(FzLength{mouse} , FzRipDens{mouse}); close, end
    clear A B
    A = FzLength{mouse}; A(A==0)=NaN;
    B = FzRipDens{mouse}; B(B==0)=NaN;
    try, [R2(mouse),P2(mouse)]=PlotCorrelations_BM(A , B); close, end
    
    A(A>40)=NaN; B(B>2)=NaN;
    try
        OccupMap(mouse,:,:) = hist2d([A' ;0; 0; 40; 40] , [B';0;2;0;2] , size_map , size_map); 
        OccupMap(mouse,:,:) = OccupMap(mouse,:,:)/sum(sum(OccupMap(mouse,:,:),2),3);
    end
end
R(R==0)=NaN; R2(R2==0)=NaN;

Cols = {[.3, .745, .93],[.85, .325, .098]};
X = [1:2];
Legends = {'Saline','DZP'};
NoLegends = {'',''};


figure
MakeSpreadAndBoxPlot4_SB({R},{[.3 .3 .3]},1,{'R'},'showpoints',1,'paired',0);

figure
MakeSpreadAndBoxPlot4_SB({R2},{[.3 .3 .3]},1,{'all saline'},'showpoints',1,'paired',0);
h=hline(0); set(h,'LineWidth',2); ylim([-1 1])
[h,p]=ttest(R2,zeros(1,length(R2)))
title(['p = ' num2str(p)])
ylabel('R values')




figure
imagesc(linspace(0,40,size_map) , linspace(0,2,size_map) , SmoothDec(squeeze(nanmean(OccupMap)),1)), axis xy
colormap magma
caxis([0 1e-3])
xlabel('fz episode length (s)'), ylabel('rip density (#/s)')

% A=OccupMap; A(A==0)=NaN;
% min(min(min(A)))
% 
% B=OccupMap*1e4; B(B==0)=.5;
% figure
% imagesc(linspace(0,40,size_map) , linspace(0,2,size_map) , SmoothDec(squeeze(nanmean(log10(B))),1)), axis xy
% colormap magma
% caxis([-.3 -.2])





