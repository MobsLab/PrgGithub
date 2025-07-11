function PlotScanLFP(Specgram1,Specgram2,Specgram3,Specgram4,t,f,listGoodLFP)


try 
    listGoodLFP;
catch
    
    listGoodLFP=[1:4*length(Specgram1)];

end


for i=1:4*length(Specgram1)
comment{i}='no signal';
end

for i=listGoodLFP
comment{i}=' ';
end


figure('Color',[1 1 1]), 

    

if comment{1}(1)~='n', 
    subplot(4,8,1), imagesc(t,f,10*log10(Specgram1{1}')), axis xy, title(['tetrode 1 orange ',comment{1}])
end

if comment{5}(1)~='n', 
    subplot(4,8,9), imagesc(t,f,10*log10(Specgram1{2}')), axis xy, title(['tetrode 2 blue ',comment{5}])
end
 
if comment{9}(1)~='n', 
    subplot(4,8,17),imagesc(t,f,10*log10(Specgram1{3}')), axis xy, title(['tetrode 3 red ',comment{9}])
end

if comment{13}(1)~='n', 
    subplot(4,8,25), imagesc(t,f,10*log10(Specgram1{4}')), axis xy, title(['tetrode 4 black ',comment{13}])
end




subplot(4,8,[2,10,18,26]),hold on
if comment{1}(1)~='n'
plot(f,mean(Specgram1{1})/max(mean(Specgram1{1})),'color',[1,0.7 0],'linewidth',2)
end
if comment{5}(1)~='n'
hold on, plot(f,mean(Specgram1{2})/max(mean(Specgram1{2})),'b','linewidth',2)
end
if comment{9}(1)~='n'
hold on, plot(f,mean(Specgram1{3})/max(mean(Specgram1{3})),'r','linewidth',2)
end
if comment{13}(1)~='n'
hold on, plot(f,mean(Specgram1{4})/max(mean(Specgram1{4})),'k','linewidth',2), title('orange 1, blue 2, red 3, black 4')
end




   

if comment{2}(1)~='n', 
    subplot(4,8,3), imagesc(t,f,10*log10(Specgram2{1}')), axis xy, title(['tetrode 1 orange',comment{2}])
end

if comment{6}(1)~='n', 
    subplot(4,8,11), imagesc(t,f,10*log10(Specgram2{2}')), axis xy, title(['tetrode 2 blue',comment{6}])
end


if comment{10}(1)~='n', 
    subplot(4,8,19), imagesc(t,f,10*log10(Specgram2{3}')), axis xy, title(['tetrode 3 red',comment{10}])
end


if comment{14}(1)~='n', 
    subplot(4,8,27), imagesc(t,f,10*log10(Specgram2{4}')), axis xy, title(['tetrode 4 black',comment{14}])
end



subplot(4,8,[4,12,20,28]),hold on
if comment{2}(1)~='n'
plot(f,mean(Specgram2{1})/max(mean(Specgram2{1})),'color',[1,0.7 0],'linewidth',2)
end
if comment{6}(1)~='n'
hold on, plot(f,mean(Specgram2{2})/max(mean(Specgram2{2})),'b','linewidth',2)
end
if comment{10}(1)~='n'
hold on, plot(f,mean(Specgram2{3})/max(mean(Specgram2{3})),'r','linewidth',2)
end
if comment{14}(1)~='n'
hold on, plot(f,mean(Specgram2{4})/max(mean(Specgram2{4})),'k','linewidth',2), title('orange 1, blue 2, red 3, black 4')
end




   
if comment{3}(1)~='n', 
    subplot(4,8,5), imagesc(t,f,10*log10(Specgram3{1}')), axis xy, title(['tetrode 1 orange',comment{3}])
end
 
if comment{7}(1)~='n', 
    subplot(4,8,13),imagesc(t,f,10*log10(Specgram3{2}')), axis xy, title(['tetrode 2 blue',comment{7}])
end
 
if comment{11}(1)~='n', 
    subplot(4,8,21),imagesc(t,f,10*log10(Specgram3{3}')), axis xy, title(['tetrode 3 red',comment{11}])
end

if comment{15}(1)~='n', 
    subplot(4,8,29), imagesc(t,f,10*log10(Specgram3{4}')), axis xy, title(['tetrode 4 black',comment{15}])
end


subplot(4,8,[6,14,22,30]),hold on
if comment{3}(1)~='n'
plot(f,mean(Specgram3{1})/max(mean(Specgram3{1})),'color',[1,0.7 0],'linewidth',2)
end
if comment{7}(1)~='n'
hold on, plot(f,mean(Specgram3{2})/max(mean(Specgram3{2})),'b','linewidth',2)
end
if comment{11}(1)~='n'
hold on, plot(f,mean(Specgram3{3})/max(mean(Specgram3{3})),'r','linewidth',2)
end
if comment{15}(1)~='n'
hold on, plot(f,mean(Specgram3{4})/max(mean(Specgram3{4})),'k','linewidth',2), title('orange 1, blue 2, red 3, black 4')
end




   

if comment{4}(1)~='n', 
    subplot(4,8,7), imagesc(t,f,10*log10(Specgram4{1}')), axis xy, title(['tetrode 1 orange',comment{4}])
end

if comment{8}(1)~='n', 
    subplot(4,8,15), imagesc(t,f,10*log10(Specgram4{2}')), axis xy, title(['tetrode 2 blue',comment{8}]), 
end

if comment{12}(1)~='n', 
    subplot(4,8,23), imagesc(t,f,10*log10(Specgram4{3}')), axis xy, title(['tetrode 3 red',comment{12}]), 
end

if comment{16}(1)~='n', 
    subplot(4,8,31), imagesc(t,f,10*log10(Specgram4{4}')), axis xy, title(['tetrode 4 black',comment{16}]), 
end

subplot(4,8,[8,16,24,32]),hold on
if comment{4}(1)~='n'
plot(f,mean(Specgram4{1})/max(mean(Specgram4{1})),'color',[1,0.7 0],'linewidth',2)
end
if comment{8}(1)~='n'
hold on, plot(f,mean(Specgram4{2})/max(mean(Specgram4{2})),'b','linewidth',2)
end
if comment{12}(1)~='n'
hold on, plot(f,mean(Specgram4{3})/max(mean(Specgram4{3})),'r','linewidth',2)
end
if comment{16}(1)~='n'
hold on, plot(f,mean(Specgram4{4})/max(mean(Specgram4{4})),'k','linewidth',2), title('orange 1, blue 2, red 3, black 4')
end


