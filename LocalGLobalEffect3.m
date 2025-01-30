% LocalGlobalEffect3
plo=0;

if plo==0;
    for i=1:length(LFP);
    figure, [fh, rasterAx, histAx, matVal2{i,1}] = ImagePETH(LFP{i}, ts(sort(LocalStdGlobStdA2)), -1000, +11000,'BinSize',50);title(['Block Local Standard - Global Standard   A   - channel LFP n°',num2str(i)]);close 
    figure, [fh, rasterAx, histAx, matVal2{i,2}] = ImagePETH(LFP{i}, ts(sort(LocalStdGlobStdB2)), -1000, +11000,'BinSize',50);title(['Block Local Standard - Global Standard   B   - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matVal2{i,3}] = ImagePETH(LFP{i}, ts(sort(LocalDvtGlobStdA2)), -1000, +11000,'BinSize',50);title(['Block Local Deviant - Global Standard   A   - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matVal2{i,4}] = ImagePETH(LFP{i}, ts(sort(LocalDvtGlobStdB2)), -1000, +11000,'BinSize',50);title(['Block Local Deviant - Global Standard   B   - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matVal2{i,5}] = ImagePETH(LFP{i}, ts(sort(LocalDvtGlobDvtA2)), -1000, +11000,'BinSize',50);title(['Block Local Deviant - Global Deviant   A   - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matVal2{i,6}] = ImagePETH(LFP{i}, ts(sort(LocalDvtGlobDvtB2)), -1000, +11000,'BinSize',50);title(['Block Local Deviant - Global Deviant   B   - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matVal2{i,7}] = ImagePETH(LFP{i}, ts(sort(OmiAAAA2)), -1000, +11000,'BinSize',50);title(['Block Local Deviant - Global Deviant   B   - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matVal2{i,8}] = ImagePETH(LFP{i}, ts(sort(OmissionRareA2)), -1000, +11000,'BinSize',50);title(['Block Local Deviant - Global Deviant   B   - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matVal2{i,9}] = ImagePETH(LFP{i}, ts(sort(OmiBBBB2)), -1000, +11000,'BinSize',50);title(['Block Local Deviant - Global Deviant   B   - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matVal2{i,10}] = ImagePETH(LFP{i}, ts(sort(OmissionRareB)), -1000, +11000,'BinSize',50);title(['Block Local Deviant - Global Deviant   B   - channel LFP n°',num2str(i)]);close
    
    end
end

%% ----------------------------------------------------------------------
A={};B={};T1={};T2={};Time={};C={};
for i=1:length(LFP);
    for k=1:10;
    A{i,k}=mean(Data(matVal{i,k})');
    B{i,k}=mean(Data(matVal2{i,k})');
    T1{i,k}=Range(matVal{i,k});
    T2{i,k}=Range(matVal2{i,k});
   
    for j=1:1499;
    C{i,k}(j)=(A{i,k}(j)+B{i,k}(j))/2;
    end
    
    for j=1:1499;
    Time{i,k}(j)=(T1{i,k}(j)+T2{i,k}(j))/2;
    end
    end
end
%% -------------------------------------------------------------------------
for i=1:length(LFP);
    %----------------------------------------------------------------------
    % Effet Local Deviant A
    %----------------------------------------------------------------------
    figure, plot(Time{i,1},C{i,1},'k','linewidth',2)
    hold on, plot(Time{i,3},C{i,3},'r','linewidth',2)
    hold on, title(['effet LOCAL: FreqAAAAA vs FreqBBBBA - channeln°',num2str(i)]) 
    hold on, axis([-1000 11000 -700 600])
        for a=0:1500:6000
        hold on, plot(a,-700:600,'b','linewidth',10)
        end
    [h,p]=ttest2(Data(C{i,1}',C{i,3}'));
    rg=Range(C{i,1},'ms');
    pr=rescale(p,500, 600);
    hold on, plot(rg(p<0.05),pr(p<0.05),'bx')  
end
for i=1:length(LFP);
    %----------------------------------------------------------------------
    % Effet Local Deviant B
    %---------------------------------------------------------------------- 
    figure, plot(Time{i,2},'ms',C{i,2},'k','linewidth',2)
    hold on, plot(Time{i,4},'ms',C{i,4},'r','linewidth',2)
    hold on, title(['effet LOCAL: FreqAAAAA vs FreqBBBBA - channeln°',num2str(i)]) 
    hold on, axis([-100 1100 -600 600])
        for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'r','linewidth',10);
        end
%     [h,p]=ttest2(Data(C{i,2}',C{i,4}'));
%     rg=Range(C{i,1},'ms');
%     pr=rescale(p,500, 600);
%     hold on, plot(rg(p<0.05),pr(p<0.05),'bx')      
end

%% -------------------------------------------------------------------------

for i=1:length(LFP)
    for k=1:10;
        matValTotal{i,k}={matVal{i,k};  matVal2{i,k}};
    end
end



%% -------------------------------------------------------------------------   
     for i=1:length(LFP);
    %----------------------------------------------------------------------
    % Effet Local Deviant A
    %----------------------------------------------------------------------
    figure, plot(Range(matValTotal{i,1},'ms'),mean(Data(matValTotal{i,1})'),'k','linewidth',2)
    hold on, plot(Range(matValTotal{i,3},'ms'),mean(Data(matValTotal{i,3})'),'r','linewidth',2)
    hold on, plot(Range(matValTotal{i,2},'ms'),mean(Data(matValTotal{i,2})'),'g','linewidth',1)
    hold on, title(['effet LOCAL: FreqAAAAA vs FreqBBBBA      +  freqBBBBB - channeln°',num2str(i)]) 
    hold on, axis([-1000 11000 -700 600])
        for a=0:1500:6000
        hold on, plot(a,-700:600,'b','linewidth',10)
        end
    [h,p]=ttest2(Data(matValTotal{i,1})',Data(matValTotal{i,3})');
    rg=Range(matVal{i,1},'ms');
    pr=rescale(p,500, 600);
    hold on, plot(rg(p<0.05),pr(p<0.05),'bx')     
     end
     
    
%% -------------------------------------------------------------------------    

% matVal1015HzJourMois=matVal;
% save matVal1015HzJourMois matVal1015HzJourMois;
% for i=1:25;
%     figure(i)
%     saveName=(['FigSpike', num2str(i)]);
%     saveas(gcf, saveName, 'jpg');
%     close
% end



% LFP0606=LFP;
% save LFP0606 LFP0606;


P=rand(10,150);
figure, imagesc(P)
P(:,60:80)=P(:,60:80)+1;
figure, imagesc(P)
M=rand(10,150);
M(:,60:80)=M(:,60:80)+1;
figure, imagesc(M)
G=[P; M];
figure, imagesc(G)
G=[P, M];
figure, imagesc(G)
