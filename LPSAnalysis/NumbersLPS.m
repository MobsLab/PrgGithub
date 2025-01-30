%NumbersLPS
cols=[0 0 0; 0.4 0.6 1; 0 0 0; 0.4 0.1 0.5;0.6 0.1 0.5; 0.8 0.1 0.5];


for s=1:4
    subplot(6,2,2*s-1)
    hold on
    line([num num], [0 size(Data(Restrict(SpindlesPa{s,1},Epoch)),1)/(size(Data(Restrict(LFP,CleanUpEpoch(And(Epoch,SpindlesPa{s,2})))),1)*8e-4)],'color',cols(num,:),'linewidth',10)
    totinfo{s}(m,num)=size(Data(Restrict(SpindlesPa{s,1},Epoch)),1)/(size(Data(Restrict(LFP,CleanUpEpoch(And(Epoch,SpindlesPa{s,2})))),1)*8e-4);
end
try
    subplot(6,2,9)
    hold on
    line([num num], [0 size(Data(Restrict(DeltaPa{1},Epoch)),1)/(size(Data(Restrict(LFP,CleanUpEpoch(And(Epoch,DeltaPa{2})))),1)*8e-4)],'color',cols(num,:),'linewidth',10)
    totinfo{9}(m,num)=size(Data(Restrict(DeltaPa{1},Epoch)),1)/(size(Data(Restrict(LFP,CleanUpEpoch(And(Epoch,DeltaPa{2})))),1)*8e-4);
catch
    totinfo{9}(m,num)=NaN;
    
end
subplot(6,4,[22:23])
hold on
line([num num], [0 size(Data(Restrict(Ripples{1},Epoch)),1)/(size(Data(Restrict(LFP,Epoch)),1)*8e-4)],'color',cols(num,:),'linewidth',10)
totinfo{11}(m,num)=size(Data(Restrict(Ripples{1},Epoch)),1)/(size(Data(Restrict(LFP,Epoch)),1)*8e-4);

for s=1:4
    subplot(6,2,2*s)
    hold on
    line([num num], [0 size(Data(Restrict(SpindlesPF{s,1},Epoch)),1)/(size(Data(Restrict(LFP,CleanUpEpoch(And(Epoch,SpindlesPF{s,2})))),1)*8e-4)],'color',cols(num,:),'linewidth',10)
    totinfo{s+4}(m,num)=size(Data(Restrict(SpindlesPF{s,1},Epoch)),1)/(size(Data(Restrict(LFP,CleanUpEpoch(And(Epoch,SpindlesPF{s,2})))),1)*8e-4);
end
try
    subplot(6,2,10)
    hold on
    line([num num], [0 size(Data(Restrict(DeltaPF{1},Epoch)),1)/(size(Data(Restrict(LFP,CleanUpEpoch(And(Epoch,DeltaPF{2})))),1)*8e-4)],'color',cols(num,:),'linewidth',10)
    totinfo{10}(m,num)=size(Data(Restrict(DeltaPF{1},Epoch)),1)/(size(Data(Restrict(LFP,CleanUpEpoch(And(Epoch,DeltaPF{2})))),1)*8e-4);
catch
    totinfo{10}(m,num)=NaN;
    
end

if d==4
    for s=1:4
        subplot(6,2,2*s-1)
        xlim([0 7])
        set(gca,'XTick',[1:6],'XTickLabel',{'PreVEH','VEH','PreLPS','LPS','+24','+48'})
        title(strcat('Spindles PaCx - ',num2str(Spf(s,:))))
    end
    subplot(6,2,9)
    xlim([0 7])
    set(gca,'XTick',[1:6],'XTickLabel',{'PreVEH','VEH','PreLPS','LPS','+24','+48'})
    title('Delta Wave PaCx')
    for s=1:4
        subplot(6,2,2*s)
        xlim([0 7])
        set(gca,'XTick',[1:6],'XTickLabel',{'PreVEH','VEH','PreLPS','LPS','+24','+48'})
        title(strcat('Spindles PFCx -',num2str(Spf(s,:))))
    end
    
    subplot(6,4,[22:23])
    xlim([0 7])
    set(gca,'XTick',[1:6],'XTickLabel',{'PreVEH','VEH','PreLPS','LPS','+24','+48'})
    title('Ripples')
    subplot(6,2,10)
    xlim([0 7])
    set(gca,'XTick',[1:6],'XTickLabel',{'PreVEH','VEH','PreLPS','LPS','+24','+48'})
    title('Delta Wave PFCx')
    
    cd('/media/DataMOBs14/LPSAnalysis')
    a=cd;
    %     pause
    saveas(f,strcat('Number_Oscillations',num2str(m),'.fig'))
    try
        saveFigure(f,strcat('Number_Oscillations',num2str(m)),a)
    end
    saveas(f,strcat('Number_Oscillations',num2str(m),'.png'))
    close all
    
    
end

