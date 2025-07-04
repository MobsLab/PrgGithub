
%AnalysisICSSMouse2903022012


cd /media/HardBackUp/DataSauvegarde/Mouse029/20120203/ICSS-Mouse-29-03022012


%%%%%cd /media/Elements/Data/ICSS-Mouse-26-10112011
%cd /media/HardBackUp/DataSauvegarde/Mouse026/20111110/ICSS-Mouse-26-10112011


load behavResources
load SpikeData

try
    load Celltypes                   
end

        if 0
            % close all

            

                    

                    for kki=2:length(S)
                        try
                        PlaceCellTrig=kki;
                        namePlaceCellTrig=cellnames{kki};
                        endSleep=tpsfin{4}*1E4;
                        staSleep=tpsdeb{4}*1E4;
                        EpochPlaceCellTrig=intervalSet(staSleep,endSleep);
                        %save PlaceCellTrig PlaceCellTrig EpochPlaceCellTrig namePlaceCellTrig
                        MFBburst=0;
                        num=1;
                        %load PlaceCellTrig PlaceCellTrig EpochPlaceCellTrig namePlaceCellTrig
                        namePlaceCellTrig
                        choicTh=5;ControlStimMFBRipplesSleep
                        close all
                        end

                    end
            end

        

  
i=1;        
for k=1:length(S)
 try
eval(['load ResAnalysisSPWRStimCtrl',num2str(k)])    

% R(i,1)=NbStimREM; 
% R(i,2)=NbStimSWS;  
% R(i,3)=FreqStimTheta;  
% R(i,4)=FreqStimSWS; 
% R(i,5)=PercStimRiplpes; 
% R(i,6)=NbSpikeRipples; 
% R(i,7)=NombreRipples; 
% R(i,8)=NombreSpikes; 
% R(i,9)=DurationPeriod; 
% R(i,10)=NbRipplesWithSpikes; 
% R(i,11)=OccurenceBefore; 
% R(i,12)=FreqBefore;
% R(i,13)=PlaceCellTrig;
% 

R(1,i)=NbStimREM; 
R(2,i)=NbStimSWS;  
R(3,i)=FreqStimTheta;  
R(4,i)=FreqStimSWS; 
R(5,i)=PercStimRiplpes; 
R(6,i)=NbSpikeRipples; 
R(7,i)=NombreRipples; 
R(8,i)=NombreSpikes; 
R(9,i)=DurationPeriod; 
R(10,i)=NbRipplesWithSpikes; 
R(11,i)=OccurenceBefore; 
R(12,i)=FreqBefore;
R(13,i)=k;

i=i+1;
 end
end       
        
      

Ti2{1}='NbStimREM' ;
Ti2{2}='NbStimSWS' ;
Ti2{3}='FreqStimTheta' ;  
Ti2{4}='FreqStimSWS' ;
Ti2{5}='PercStimRiplpes' ;
Ti2{6}='NbSpikeRipples' ;
Ti2{7}='NombreRipples' ;
Ti2{8}='NombreSpikes' ;
Ti2{9}='DurationPeriod' ;
Ti2{10}='NbRipplesWithSpikes' ;  
Ti2{11}='OccurenceBefore' ;
Ti2{12}='FreqBefore' ;  
Ti2{13}='PlaceCellTrig' ;  

if 0
for a=[5:12]
    for b=a+1:12
        figure('color',[1 1 1]), hold on
 plot(R(a,:),R(b,:),'ko','markerfacecolor','k')
 try
 plot(R(a,35-1),R(b,35-1),'ro','markerfacecolor','r')
 plot(R(a,25-1),R(b,25-1),'ko','markerfacecolor','w')
  %plot(R(1,a),R(1,b),'ko','markerfacecolor','w')
 end
 try
     plot(R(a,find(Celltypes==0)-1),R(b,find(Celltypes==0)-1),'ko','markerfacecolor','c')
 end
 title([num2str(a), ' ',Ti2{a},' vs. ',num2str(b),' ',Ti2{b}]), xlabel(Ti2{a}), ylabel(Ti2{b})
    end
end

end

%%

 figure('color',[1 1 1]), hold on, t=1;
for a=[5:12]
    for b=a+1:12
        if b~=9&a~=9&b~=7&a~=7
             subplot(4,4,t), hold on
             plot(log10(R(a,:)),log10(R(b,:)),'ko','markerfacecolor','k')
             try
                 plot(log10(R(a,35-1)),log10(R(b,35-1)),'ro','markerfacecolor','r')
                plot(log10(R(a,25-1)),log10(R(b,25-1)),'ko','markerfacecolor','w')
         %     plot(R(a,1),R(b,1),'ko','markerfacecolor','w')
             end
             try
                plot(log10(R(a,find(Celltypes==0)-1)),log10(R(b,find(Celltypes==0)-1)),'ko','markerfacecolor','c')
            end
            % title([num2str(a), ' ',Ti2{a},' vs. ',num2str(b),' ',Ti2{b}]), 
             xlabel(Ti2{a}), ylabel(Ti2{b})
             t=t+1;
        end
    end
end

try
subplot(4,4,16), hold on
plot(log10(R(10,:)./R(7,:)),log10(R(12,:)),'ko','markerfacecolor','k')

try
    plot(log10(R(10,35-1)./R(7,35-1)),log10(R(12,35-1)),'ro','markerfacecolor','r')
plot(log10(R(10,25-1)./R(7,25-1)),log10(R(12,25-1)),'ko','markerfacecolor','w')
end
try
plot(log10(R(10,find(Celltypes==0)-1)./R(7,find(Celltypes==0)-1)),log10(R(12,find(Celltypes==0)-1)),'ko','markerfacecolor','c')
end
 xlabel(Ti2{12}), ylabel('% Ripples with Stim')
end



%%




% 
%  figure('color',[1 1 1]), hold on, t=1;
% for a=[5:12]
%     for b=a+1:12
%         if b~=9&a~=9&b~=7&a~=7
%              subplot(4,4,t), hold on
%              plot((R(:,a)),(R(:,b)),'ko','markerfacecolor','k')
%              plot((R(35-1,a)),(R(35-1,b)),'ro','markerfacecolor','r')
%              plot((R(25-1,a)),(R(25-1,b)),'ko','markerfacecolor','w')
%          %     plot(R(1,a),R(1,b),'ko','markerfacecolor','w')
%          try
%              plot((R(find(Celltypes==0)-1,a)),(R(find(Celltypes==0)-1,b)),'ko','markerfacecolor','c')
%          end
%             % title([num2str(a), ' ',Ti2{a},' vs. ',num2str(b),' ',Ti2{b}]), 
%              xlabel(Ti2{a}), ylabel(Ti2{b})
%              t=t+1;
%         end
%     end
% end
% 





%         
% a=10; b=12; c=7; 
% 
% hold on, 
% plot(R(:,10)./R(:,7),R(:,12),'ko','markerfacecolor','k'), 
% plot(R(35,a)./R(35,c),R(35,b),'ro','markerfacecolor','r')
% title([Ti2{a},' vs. ',Ti2{b}]), xlabel(Ti2{a}), ylabel(Ti2{b})
%  
        