function [ResTones,Res,r1z,p1z,r2z,p2z,TT2,TT4]=ParcoursQuantifTonesDeltaCorticesRipples(Generate,exp,ton,savfig)

try
    savfig;
catch
savfig=0;
end

try
    Generate;
catch
Generate=0;
end

try
    exp;
catch
%exp='RdmTone';
exp='DeltaTone';
%exp='BASAL';
%exp='DeltaT140';
% exp='DeltaT320';
% exp='DeltaT480';
end

try
    ton;
catch
ton=2;
end

 cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback  
  
 
 
if Generate
    
        Dir=PathForExperimentsDeltaSleepNew(exp);

        a=1;
        for i=1:length(Dir.path)
%            try
                disp(' ')
                disp('****************************************************************')
            eval(['cd(Dir.path{',num2str(i),'}'')'])
            disp(pwd)
            if exp(1)=='B'
            [Res(a,:),ResTones(a,:),doRip(a,:),doNoRip(a,:),dpfcRip(a,:),dpfcNoRip(a,:),dpacRip(a,:),dpacNoRip(a,:),dmocRip(a,:),dmocNoRip(a,:),M1{a},T1{a},M2{a},T2{a},M3{a},T3{a},M4{a},T4{a},M5{a},T5{a}]=QuantifTonesDeltaCorticesRipples(ton,0);
            
            else
            [Res(a,:),ResTones(a,:),doRip(a,:),doNoRip(a,:),dpfcRip(a,:),dpfcNoRip(a,:),dpacRip(a,:),dpacNoRip(a,:),dmocRip(a,:),dmocNoRip(a,:),M1{a},T1{a},M2{a},T2{a},M3{a},T3{a},M4{a},T4{a},M5{a},T5{a}]=QuantifTonesDeltaCorticesRipples(ton,Dir.delay{i});

            end
            
            MiceName{a}=Dir.name{i};
            PathOK{a}=Dir.path{i};

             a=a+1;
%            end
        end
        clear savfig
       cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback  
   eval(['save ParcoursQuantifTonesDeltaCorticesRipples',exp,'Tone',num2str(ton)])
   
else

  cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback  
   eval(['load ParcoursQuantifTonesDeltaCorticesRipples',exp,'Tone',num2str(ton)])  

end



   
   figure('color',[1 1 1]), 
   subplot(4,2,1), PlotErrorBarN(doRip,0);title('Nb Down Rip'), subplot(4,2,2),PlotErrorBarN(doNoRip,0);title('Nb Down no Rip')
   subplot(4,2,3), PlotErrorBarN(dpfcRip,0);title('Nb Delta Pfc Rip'), subplot(4,2,4),PlotErrorBarN(dpfcNoRip,0);title('Nb Delta Pfc  no Rip')
   subplot(4,2,5), PlotErrorBarN(dpacRip,0);title('Nb Delta Pac Rip'), subplot(4,2,6),PlotErrorBarN(dpacNoRip,0);title('Nb Delta Pac  no Rip')
   subplot(4,2,7), PlotErrorBarN(dmocRip,0);title('Nb Delta Moc Rip'), subplot(4,2,8),PlotErrorBarN(dmocNoRip,0);title('Nb Delta Moc  no Rip')

k=0;
k=k+1; ti{k}='SPW-Rs';
k=k+1; ti{k}='Down';
k=k+1; ti{k}='Delta Pfc';
k=k+1; ti{k}='Delta Pac';
k=k+1; ti{k}='Delta Moc';
k=k+1; ti{k}='SWS';
k=k+1; ti{k}='REM';
k=k+1; ti{k}='Wake'; 
k=k+1; ti{k}='SPW with tones'; 
k=k+1; ti{k}='SPW without tones'; 
k=k+1; ti{k}='Down with tones'; 
k=k+1; ti{k}='Down without tones'; 
k=k+1; ti{k}='Delta Pfc with tones'; 
k=k+1; ti{k}='Delta Pfc without tones'; 
k=k+1; ti{k}='Delta Pac with tones'; 
k=k+1; ti{k}='Delta Pac without tones'; 
k=k+1; ti{k}='Delta Moc with tones'; 
k=k+1; ti{k}='Delta Moc without tones'; 
   a=1;
   figure('color',[1 1 1])
   for i=1:5:90
   subplot(3,6,a), PlotErrorBarN(Res(:,i:i+4),0);try, title(ti{a}), end
   a=a+1;
   end
   
   a=1;
   figure('color',[1 1 1])
   for i=1:5:90
   subplot(3,6,a), PlotErrorBarN(Res(:,i:i+4)./Res(:,26:30),0);try, title(ti{a}), end
   a=a+1;
   end
   
   
   

try
   PlotErrorBarN(ResTones(:,[6,12,21,27,36,42,51,57,66,72]));ylabel('Percentage of Delta/Down evoked by sounds')

   
for i=1:length(T3)
nbTones(i,1)=size(T2{i},1);
nbTones(i,2)=size(T4{i},1);
end
   
figure('color',[1 1 1])
subplot(2,2,1), PlotErrorBar2(Res(:,52)./nbTones(:,1),Res(:,54)./nbTones(:,2),0); 
subplot(2,2,2), PlotErrorBar2(Res(:,62)./nbTones(:,1),Res(:,64)./nbTones(:,2),0); 
subplot(2,2,3), PlotErrorBar2(Res(:,72)./nbTones(:,1),Res(:,74)./nbTones(:,2),0); 
subplot(2,2,4), PlotErrorBar2(Res(:,82)./nbTones(:,1),Res(:,84)./nbTones(:,2),0); 
   
end  


% keyboard

if exp(1)=='D'|exp(1)=='R'
    
tps=M2{2}(:,1);


    TT2=[];
    TT4=[];
    delay2=[];
    delay4=[];
    for i=1:length(T2)
        if mean(mean(T2{i}))>0.018&mean(mean(T2{i}))<0.2
        TT2=[TT2;T2{i}];
        delay2=[delay2;Dir.delay{i}*ones(size(T2{i},1),1)];
        end
        if mean(mean(T2{i}))>0.018&mean(mean(T2{i}))<0.2
        TT4=[TT4;T4{i}];
        delay4=[delay4;Dir.delay{i}*ones(size(T4{i},1),1)];
        end

    end
    
    idxAft=find(tps>0.08&tps<0.14);
    idxBef=find(tps>-0.05&tps<0);
    
    [BE,id2]=sort(mean(TT2(:,idxAft),2));
    [BE,id4]=sort(mean(TT4(:,idxAft),2));
    TT2d=TT2(id2,:);
    TT4d=TT4(id4,:);
    
    
    figure('color',[1 1 1]), 
    subplot(3,2,1), imagesc(tps,1:size(TT2,1),zscore(TT2')'), axis xy, caxis([-1.5 4]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line([0 0],yl, 'color','k'), title([exp,' Epoch 2'])
    subplot(3,2,3), imagesc(tps,1:size(TT2,1),zscore(TT2d')'), axis xy, caxis([-1.5 4]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line([0 0],yl, 'color','k')
    subplot(3,2,5), plot(tps,mean(zscore(TT2d')'),'k','linewidth',2), xlim([tps(1) tps(end)]) 

    subplot(3,2,2), imagesc(tps,1:size(TT4,1),zscore(TT4')'), axis xy, caxis([-1.5 4]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line([0 0],yl, 'color','k'), title([exp,' Epoch 4'])
    subplot(3,2,4), imagesc(tps,1:size(TT4,1),zscore(TT4d')'), axis xy,   caxis([-1.5 4]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line([0 0],yl, 'color','k')  , title([exp,' Epoch 4'])
    subplot(3,2,6), plot(tps,mean(zscore(TT4d')'),'k','linewidth',2), xlim([tps(1) tps(end)]) % plot(tps,rescale(M4{2}(:,2),200,1000),'k'), xlim([])
set(gcf,'position',[321         104        1369         913])

smo=[0.7 1];
  figure('color',[1 1 1]), 
    subplot(3,2,1), imagesc(tps,1:size(TT2,1),SmoothDec(zscore(TT2')',smo)), axis xy, caxis([-1.5 4]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line([0 0],yl, 'color','k'), title([exp,' Epoch 2'])
    subplot(3,2,3), imagesc(tps,1:size(TT2,1),SmoothDec(zscore(TT2d')',smo)), axis xy, caxis([-1.5 4]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line([0 0],yl, 'color','k')
    subplot(3,2,5), plot(tps,mean(zscore(TT2d')'),'k','linewidth',2), xlim([tps(1) tps(end)]) 

    subplot(3,2,2), imagesc(tps,1:size(TT4,1),SmoothDec(zscore(TT4')',smo)), axis xy, caxis([-1.5 4]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line([0 0],yl, 'color','k'), title([exp,' Epoch 4'])
    subplot(3,2,4), imagesc(tps,1:size(TT4,1),SmoothDec(zscore(TT4d')',smo)), axis xy,   caxis([-1.5 4]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line([0 0],yl, 'color','k') 
    subplot(3,2,6), plot(tps,mean(zscore(TT4d')'),'k','linewidth',2), xlim([tps(1) tps(end)]) % plot(tps,rescale(M4{2}(:,2),200,1000),'k'), xlim([])
set(gcf,'position',[321         104        1369         913])



[r1,p1]=corrcoef(zscore(TT2d));
[r2,p2]=corrcoef(zscore(TT4d));
[r1z,p1z]=corrcoef(zscore(TT2d')');
[r2z,p2z]=corrcoef(zscore(TT4d')');
 figure('color',[1 1 1]),
 subplot(2,2,1), imagesc(tps,tps,r1), caxis([-0.1 0.2]),xlim([-0.7 0.7]), ylim([-0.7 0.7]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line(xl,[0 0], 'color','k'), colorbar
 subplot(2,2,2), imagesc(tps,tps,r2), caxis([-0.1 0.2]),xlim([-0.7 0.7]), ylim([-0.7 0.7]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line(xl,[0 0], 'color','k'), colorbar
 subplot(2,2,3), imagesc(tps,tps,r1z), caxis([-0.1 0.1]),xlim([-0.7 0.7]), ylim([-0.7 0.7]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line(xl,[0 0], 'color','k'), colorbar
 subplot(2,2,4), imagesc(tps,tps,r2z), caxis([-0.1 0.1]),xlim([-0.7 0.7]), ylim([-0.7 0.7]), xl=xlim; yl=ylim; line([0 0],yl, 'color','k'), line(xl,[0 0], 'color','k'), colorbar

set(gcf,'position',[351         326        1070         696])
 
  if exp(1)=='D'
    
   figure('color',[1 1 1])
    subplot(4,2,1), PlotErrorBar2(mean(TT2(find(delay2==0.14),idxBef),2),mean(TT2(find(delay2==0.14),idxAft),2),0,0), [p,h]=ranksum(mean(TT2(find(delay2==0.14),idxBef),2),mean(TT2(find(delay2==0.14),idxAft),2)); MeanEffect=(mean(mean(TT2(find(delay2==0.14),idxBef),2)-mean(TT2(find(delay2==0.14),idxAft),2))./mean(mean(TT2(find(delay2==0.14),idxBef),2)))*100; title([num2str(MeanEffect),'%, ',num2str(p)])
    subplot(4,2,2), PlotErrorBar2(mean(TT4(find(delay4==0.14),idxBef),2),mean(TT4(find(delay4==0.14),idxAft),2),0,0), [p,h]=ranksum(mean(TT4(find(delay4==0.14),idxBef),2),mean(TT4(find(delay4==0.14),idxAft),2)); MeanEffect=(mean(mean(TT4(find(delay4==0.14),idxBef),2)-mean(TT4(find(delay4==0.14),idxAft),2))./mean(mean(TT4(find(delay4==0.14),idxBef),2)))*100; title([num2str(MeanEffect),'%, ',num2str(p)])
    subplot(4,2,3), PlotErrorBar2(mean(TT2(find(delay2==0.2),idxBef),2),mean(TT2(find(delay2==0.2),idxAft),2),0,0), [p,h]=ranksum(mean(TT2(find(delay2==0.2),idxBef),2),mean(TT2(find(delay2==0.2),idxAft),2));     MeanEffect=(mean(mean(TT2(find(delay2==0.2),idxBef),2)-mean(TT2(find(delay2==0.2),idxAft),2))./mean(mean(TT2(find(delay2==0.2),idxBef),2)))*100; title([num2str(MeanEffect),'%, ',num2str(p)])
    subplot(4,2,4), PlotErrorBar2(mean(TT4(find(delay4==0.2),idxBef),2),mean(TT4(find(delay4==0.2),idxAft),2),0,0), [p,h]=ranksum(mean(TT4(find(delay4==0.2),idxBef),2),mean(TT4(find(delay4==0.2),idxAft),2));     MeanEffect=(mean(mean(TT4(find(delay4==0.2),idxBef),2)-mean(TT4(find(delay4==0.2),idxAft),2))./mean(mean(TT4(find(delay4==0.2),idxBef),2)))*100; title([num2str(MeanEffect),'%, ',num2str(p)])
    subplot(4,2,5), PlotErrorBar2(mean(TT2(find(delay2==0.32),idxBef),2),mean(TT2(find(delay2==0.32),idxAft),2),0,0), [p,h]=ranksum(mean(TT2(find(delay2==0.32),idxBef),2),mean(TT2(find(delay2==0.32),idxAft),2)); MeanEffect=(mean(mean(TT2(find(delay2==0.32),idxBef),2)-mean(TT2(find(delay2==0.32),idxAft),2))./mean(mean(TT2(find(delay2==0.32),idxBef),2)))*100; title([num2str(MeanEffect),'%, ',num2str(p)])
    subplot(4,2,6), PlotErrorBar2(mean(TT4(find(delay4==0.32),idxBef),2),mean(TT4(find(delay4==0.32),idxAft),2),0,0), [p,h]=ranksum(mean(TT4(find(delay4==0.32),idxBef),2),mean(TT4(find(delay4==0.32),idxAft),2)); MeanEffect=(mean(mean(TT4(find(delay4==0.32),idxBef),2)-mean(TT4(find(delay4==0.32),idxAft),2))./mean(mean(TT4(find(delay4==0.32),idxBef),2)))*100; title([num2str(MeanEffect),'%, ',num2str(p)])
    subplot(4,2,7), PlotErrorBar2(mean(TT2(find(delay2==0.48),idxBef),2),mean(TT2(find(delay2==0.48),idxAft),2),0,0), [p,h]=ranksum(mean(TT2(find(delay2==0.48),idxBef),2),mean(TT2(find(delay2==0.48),idxAft),2)); MeanEffect=(mean(mean(TT2(find(delay2==0.48),idxBef),2)-mean(TT2(find(delay2==0.48),idxAft),2))./mean(mean(TT2(find(delay2==0.48),idxBef),2)))*100; title([num2str(MeanEffect),'%, ',num2str(p)])
    subplot(4,2,8), PlotErrorBar2(mean(TT4(find(delay4==0.48),idxBef),2),mean(TT4(find(delay4==0.48),idxAft),2),0,0), [p,h]=ranksum(mean(TT4(find(delay4==0.48),idxBef),2),mean(TT4(find(delay4==0.48),idxAft),2)); MeanEffect=(mean(mean(TT4(find(delay4==0.48),idxBef),2)-mean(TT4(find(delay4==0.48),idxAft),2))./mean(mean(TT4(find(delay4==0.48),idxBef),2)))*100; title([num2str(MeanEffect),'%, ',num2str(p)])
  
 else
  figure('color',[1 1 1])
    subplot(1,2,1), PlotErrorBar2(mean(TT2(:,idxBef),2),mean(TT2(:,idxAft),2),0,0), [p,h]=ranksum(mean(TT2(:,idxBef),2),mean(TT2(:,idxAft),2)); MeanEffect=(mean(mean(TT2(:,idxBef),2)-mean(TT2(:,idxAft),2))./mean(mean(TT2(:,idxBef),2))*100); title([num2str(MeanEffect),'%, ',num2str(p)])
    subplot(1,2,2), PlotErrorBar2(mean(TT4(:,idxBef),2),mean(TT4(:,idxAft),2),0,0), [p,h]=ranksum(mean(TT4(:,idxBef),2),mean(TT4(:,idxAft),2)); MeanEffect=(mean(mean(TT4(:,idxBef),2)-mean(TT4(:,idxAft),2))./mean(mean(TT4(:,idxBef),2))*100); title([num2str(MeanEffect),'%, ',num2str(p)])
      
    
  end

else
    

r1=[];
p1=[];
r2=[];
p2=[];
r1z=[];
p1z=[];
r2z=[];
p2z=[];
TT2=[];
TT4=[];
end

%  keyboard
% savin=1;
try
    savfig;
if savfig
   clear num
   num=gcf;
   for i=1:num
%    try
       figure(i)
   set(i,'position',[73           2        1664        1080])
   eval(['saveFigure(',num2str(i),',''FigureParcoursQuantifTonesDeltaCorticesRipples',exp,'Tone',num2str(ton),'fig',num2str(i),''',''/media/DataMOBsRAID/ProjetBreathDeltaFeedback'')'])
   eval(['saveFigure(',num2str(i),',''FigureParcoursQuantifTonesDeltaCorticesRipples',exp,'Tone',num2str(ton),'fig',num2str(i),''',''/media/DISK_1/Dropbox/MOBS_workingON/PhD_Manuscrip_GdL/Figures Projet DeltaFeedback/FigFRomK'')'])
   %    end
   end
end
end




% clear
% 
% 
% exp='DeltaTone';
% Generate=1;
% 
%  cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback  
%   
% if Generate
%     
%         Dir=PathForExperimentsDeltaSleepNew(exp);
% 
%         a=1;
%         for i=1:length(Dir.path)
%             try
%                 disp(' ')
%                 disp('****************************************************************')
%             eval(['cd(Dir.path{',num2str(i),'}'')'])
%             disp(pwd)
%             [Tones, idxOK,idBad,del,del2,del3,C(a,:),B,Aj,Bj,Cj,M{a},T{a}]=ToneDeltaKB(0,2,Dir.delay{a},PeriodToAnalyse);close all
%             
%             b=1;
%             for j=0.01:0.01:3
%                 val1(a,b)=length(find(del/1E4<j));
%                 val2(a,b)=floor(10*length(find(del/1E4<j))/length(del)*100)/10;
%             b=b+1;
%             end
%             
%                         
%             MiceName{a}=Dir.name{a};
%             PathOK{a}=Dir.path{a};
% 
%             a=a+1;
%             end
%         end
%         
%         
% end
%             
%           cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback  
%    save DataParcoursToneDeltaKBDeltaToneEpoch2
% 
