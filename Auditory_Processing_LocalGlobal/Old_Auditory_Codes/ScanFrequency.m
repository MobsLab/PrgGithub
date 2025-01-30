% MMNAnalysis7

plo=0;

%% Importation of recording data (LFP-Spike-Tracking-Event)
load behavResources
load LFPData
try  
load SpikeData
end

%% Import of the differents Stimulations Files
%
newData2 = importdata('ScanFrequency.txt');
File1=newData2; clear newData2;
File1(1)=[];

File1(1,2)=1;
File1(101,2)=2;
File1(201,2)=3;


%%         Preparation of the differents MegaBlock matrices (fixed)
% Choose the first stimulations of the protocol (if scan frequency, of severals frequency protocols in the same day)
% Shift > Default value =0
% Protocol number 1 => start = 1
% Protocol number 2 => start = 9217
% Protocol number 3 => start = 18433
Shift=0;
start=Shift+1; 


%% Indexation of the stimulations (st) and determination of the InterBlock interval (default value=3500)
st=Range(stim);
Freq=(length(st))/100;
disp(['nombre de stimulations :   ', num2str(length(st))])
disp(['nombre de frequences testées :   ', num2str(Freq)])


%%     Repartition of the tone in the differents Tone
% -------------------------- Protocole 1 --------------------------
for a=start:length(File1)+start-1;
    if File1((a+1)-start,2)==1
        startScanFreq1=a;
        EndScanFreq1=startScanFreq1+99;
        ToneFreq1(1:100,1)=st(startScanFreq1:EndScanFreq1,1);
        
        startScanFreq4=a+300;
        EndScanFreq4=startScanFreq4+99;
        ToneFreq4(1:100,1)=st(startScanFreq4:EndScanFreq4,1);
        
        startScanFreq7=a+600;
        EndScanFreq7=startScanFreq7+99;
        ToneFreq7(1:100,1)=st(startScanFreq7:EndScanFreq7,1);
        
        startScanFreq10=a+900;
        EndScanFreq10=startScanFreq10+99;
        ToneFreq10(1:100,1)=st(startScanFreq10:EndScanFreq10,1);
        
        startScanFreq13=a+1200;
        EndScanFreq13=startScanFreq13+99;
        ToneFreq13(1:100,1)=st(startScanFreq13:EndScanFreq13,1);
        
        startScanFreq16=a+1500;
        EndScanFreq16=startScanFreq16+99;
        ToneFreq16(1:100,1)=st(startScanFreq16:EndScanFreq16,1);
    end
    
    
    if File1((a+1)-start,2)==2
        startScanFreq2=a;
        EndScanFreq2=startScanFreq2+99;
        ToneFreq2(1:100,1)=st(startScanFreq2:EndScanFreq2,1);
        
        startScanFreq5=a+300;
        EndScanFreq5=startScanFreq5+99;
        ToneFreq5(1:100,1)=st(startScanFreq5:EndScanFreq5,1);
        
        startScanFreq8=a+600;
        EndScanFreq8=startScanFreq8+99;
        ToneFreq8(1:100,1)=st(startScanFreq8:EndScanFreq8,1);
        
        startScanFreq11=a+900;
        EndScanFreq11=startScanFreq11+99;
        ToneFreq11(1:100,1)=st(startScanFreq11:EndScanFreq11,1);
        
        startScanFreq14=a+1200;
        EndScanFreq14=startScanFreq14+99;
        ToneFreq14(1:100,1)=st(startScanFreq14:EndScanFreq14,1);
        
        startScanFreq17=a+1500;
        EndScanFreq17=startScanFreq17+99;
        ToneFreq17(1:100,1)=st(startScanFreq17:EndScanFreq17,1);
    end
    
    if File1((a+1)-start,2)==3
        startScanFreq3=a;
        EndScanFreq3=startScanFreq3+99;
        ToneFreq3(1:100,1)=st(startScanFreq3:EndScanFreq3,1);
        
        startScanFreq6=a+300;
        EndScanFreq6=startScanFreq6+99;
        ToneFreq6(1:100,1)=st(startScanFreq6:EndScanFreq6,1);
        
        startScanFreq9=a+600;
        EndScanFreq9=startScanFreq9+99;
        ToneFreq9(1:100,1)=st(startScanFreq9:EndScanFreq9,1);
        
        startScanFreq12=a+900;
        EndScanFreq12=startScanFreq12+99;
        ToneFreq12(1:100,1)=st(startScanFreq12:EndScanFreq12,1);
        
        startScanFreq15=a+1200;
        EndScanFreq15=startScanFreq15+99;
        ToneFreq15(1:100,1)=st(startScanFreq15:EndScanFreq15,1);
        
        startScanFreq18=a+1500;
        EndScanFreq18=startScanFreq18+99;
        ToneFreq18(1:100,1)=st(startScanFreq18:EndScanFreq18,1);
    end

    
end

%%       Visualisation of the differents Tone

figure, plot(Range(stim,'s'),ones(length(Range(stim)),1),'ko')
hold on, plot(ToneFreq1/1E4,ones(length(ToneFreq1)),'ro','markerfacecolor','r');
hold on, plot(ToneFreq2/1E4,ones(length(ToneFreq2)),'go','markerfacecolor','g');
hold on, plot(ToneFreq3/1E4,ones(length(ToneFreq3),2),'bo','markerfacecolor','b');
hold on, plot(ToneFreq4/1E4,ones(length(ToneFreq4),2),'co','markerfacecolor','c');
hold on, plot(ToneFreq5/1E4,ones(length(ToneFreq5)),'yo','markerfacecolor','y');
hold on, plot(ToneFreq6/1E4,ones(length(ToneFreq6)),'mo','markerfacecolor','m');
hold on, plot(ToneFreq7/1E4,ones(length(ToneFreq7),2),'ko');
hold on, plot(ToneFreq8/1E4,ones(length(ToneFreq8),2),'ko','markerfacecolor','k');
hold on, plot(ToneFreq9/1E4,ones(length(ToneFreq9)),'ro','markerfacecolor','r');
hold on, plot(ToneFreq10/1E4,ones(length(ToneFreq10)),'go','markerfacecolor','g');
hold on, plot(ToneFreq11/1E4,ones(length(ToneFreq11),2),'bo','markerfacecolor','b');
hold on, plot(ToneFreq12/1E4,ones(length(ToneFreq12),2),'co','markerfacecolor','c');
hold on, plot(ToneFreq13/1E4,ones(length(ToneFreq13)),'yo','markerfacecolor','y');
hold on, plot(ToneFreq14/1E4,ones(length(ToneFreq14),2),'mo','markerfacecolor','m');
hold on, plot(ToneFreq15/1E4,ones(length(ToneFreq15),2),'ko');
hold on, plot(ToneFreq16/1E4,ones(length(ToneFreq16)),'ko','markerfacecolor','k');
hold on, plot(ToneFreq17/1E4,ones(length(ToneFreq17),2),'ro','markerfacecolor','r');
hold on, plot(ToneFreq18/1E4,ones(length(ToneFreq18),2),'go','markerfacecolor','g');


%%       Generation des ERPs pour chaque frequence

if plo==0;
    for i=1:length(LFP);
    figure, [fh, rasterAx, histAx, matVal{i,1}] = ImagePETH(LFP{i}, ts(sort(ToneFreq1)), -1000, +11000,'BinSize',50);title(['FrequencyTest1 : 4000Hz   - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matVal{i,2}] = ImagePETH(LFP{i}, ts(sort(ToneFreq2)), -1000, +11000,'BinSize',50);title(['FrequencyTest2 : 6000Hz  - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matVal{i,3}] = ImagePETH(LFP{i}, ts(sort(ToneFreq3)), -1000, +11000,'BinSize',50);title(['FrequencyTest3 : 8000Hz  - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matVal{i,4}] = ImagePETH(LFP{i}, ts(sort(ToneFreq4)), -1000, +11000,'BinSize',50);title(['FrequencyTest4 : 10 000Hz  - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matVal{i,5}] = ImagePETH(LFP{i}, ts(sort(ToneFreq5)), -1000, +11000,'BinSize',50);title(['FrequencyTest5 : 12 000Hz  - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matVal{i,6}] = ImagePETH(LFP{i}, ts(sort(ToneFreq6)), -1000, +11000,'BinSize',50);title(['FrequencyTest6 : 14 000Hz  - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matVal{i,7}] = ImagePETH(LFP{i}, ts(sort(ToneFreq7)), -1000, +11000,'BinSize',50);title(['FrequencyTest7 : 16 000Hz   - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matVal{i,8}] = ImagePETH(LFP{i}, ts(sort(ToneFreq8)), -1000, +11000,'BinSize',50);title(['FrequencyTest8 : 18 000Hz  - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matVal{i,9}] = ImagePETH(LFP{i}, ts(sort(ToneFreq9)), -1000, +11000,'BinSize',50);title(['FrequencyTest9 : 20 000Hz - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matVal{i,10}] = ImagePETH(LFP{i}, ts(sort(ToneFreq10)), -1000, +11000,'BinSize',50);title(['FrequencyTest10 : 22 000Hz  - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matVal{i,11}] = ImagePETH(LFP{i}, ts(sort(ToneFreq11)), -1000, +11000,'BinSize',50);title(['FrequencyTest11 : 24 000Hz  - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matVal{i,12}] = ImagePETH(LFP{i}, ts(sort(ToneFreq12)), -1000, +11000,'BinSize',50);title(['FrequencyTest12 : 26 000Hz  - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matVal{i,13}] = ImagePETH(LFP{i}, ts(sort(ToneFreq13)), -1000, +11000,'BinSize',50);title(['FrequencyTest13 : 28 000Hz   - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matVal{i,14}] = ImagePETH(LFP{i}, ts(sort(ToneFreq14)), -1000, +11000,'BinSize',50);title(['FrequencyTest14 : 30 000Hz  - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matVal{i,15}] = ImagePETH(LFP{i}, ts(sort(ToneFreq15)), -1000, +11000,'BinSize',50);title(['FrequencyTest15 : 32 000Hz  - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matVal{i,16}] = ImagePETH(LFP{i}, ts(sort(ToneFreq16)), -1000, +11000,'BinSize',50);title(['FrequencyTest16 : 34 000Hz  - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matVal{i,17}] = ImagePETH(LFP{i}, ts(sort(ToneFreq17)), -1000, +11000,'BinSize',50);title(['FrequencyTest17 : 36 000Hz  - channel LFP n°',num2str(i)]);close
    figure, [fh, rasterAx, histAx, matVal{i,18}] = ImagePETH(LFP{i}, ts(sort(ToneFreq18)), -1000, +11000,'BinSize',50);title(['FrequencyTest18 : 38 000Hz  - channel LFP n°',num2str(i)]);close  
    end
end

% %%           Generation des SpikeRaster pour chaque frequence
% for a=1:length(S)
%     figure, [fh, rasterAx, histAx, matVal] = RasterPETH(S{a}, ts(st), -8000, +5000,'BinSize',50);title(num2str(a))
% end

%%       Visualisation of the differents MegaBlock, based on MBs index :FileX(-,3)

    %----------------------------------------------------------------------
    % Scan Frequency from 2000Hz to 20.000Hz
    %----------------------------------------------------------------------
    for i=1:length(LFP);
    figure, plot(Range(matVal{i,1},'ms'),mean(Data(matVal{i,1})'),'r','linewidth',2)
    hold on, plot(Range(matVal{i,2},'ms'),mean(Data(matVal{i,2})'),'g','linewidth',2)
    hold on, plot(Range(matVal{i,3},'ms'),mean(Data(matVal{i,3})'),'b','linewidth',2)
    hold on, plot(Range(matVal{i,4},'ms'),mean(Data(matVal{i,4})'),'y','linewidth',2)
    hold on, plot(Range(matVal{i,5},'ms'),mean(Data(matVal{i,5})'),'c','linewidth',2)
    hold on, plot(Range(matVal{i,6},'ms'),mean(Data(matVal{i,6})'),'m','linewidth',2)
    hold on, plot(Range(matVal{i,7},'ms'),mean(Data(matVal{i,7})'),'k','linewidth',2)
    hold on, plot(Range(matVal{i,8},'ms'),mean(Data(matVal{i,8})'),'g+','linewidth',2)
    hold on, plot(Range(matVal{i,9},'ms'),mean(Data(matVal{i,9})'),'r+','linewidth',2)
    hold on, title(['Scan Frequency: from 2kHz>20kHz - channeln°',num2str(i)]) 
    hold on, axis([-50 100 -1500 350])
    hold on, plot(0,-1000:700,'k','linewidth',10)
    end
  
    %----------------------------------------------------------------------
    % Scan Frequency from 20.000Hz to 38.000Hz
    %---------------------------------------------------------------------- 
  for i=1:length(LFP);
    figure, plot(Range(matVal{i,10},'ms'),mean(Data(matVal{i,10})'),'r','linewidth',2)
    hold on, plot(Range(matVal{i,11},'ms'),mean(Data(matVal{i,11})'),'g','linewidth',2)
    hold on, plot(Range(matVal{i,12},'ms'),mean(Data(matVal{i,12})'),'b','linewidth',2)
    hold on, plot(Range(matVal{i,13},'ms'),mean(Data(matVal{i,13})'),'y','linewidth',2)
    hold on, plot(Range(matVal{i,14},'ms'),mean(Data(matVal{i,14})'),'c','linewidth',2)
    hold on, plot(Range(matVal{i,15},'ms'),mean(Data(matVal{i,15})'),'m','linewidth',2)
    hold on, plot(Range(matVal{i,16},'ms'),mean(Data(matVal{i,16})'),'k','linewidth',2)
    hold on, plot(Range(matVal{i,17},'ms'),mean(Data(matVal{i,17})'),'g+','linewidth',2)
    hold on, plot(Range(matVal{i,18},'ms'),mean(Data(matVal{i,18})'),'r+','linewidth',2)
    hold on, title(['Scan Frequency: from 20kHz>38kHz - channeln°',num2str(i)]) 
    hold on, axis([-50 100 -1500 350])
    hold on, plot(0,-1000:700,'k','linewidth',10)
  end













