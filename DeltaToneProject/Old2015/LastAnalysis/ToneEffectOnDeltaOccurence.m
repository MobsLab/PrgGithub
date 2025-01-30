%ToneEffectOnDeltaOccurence

% --------------------------------------------------------------------------------------------------------------------------------------------
% --------------------------------------------------------------------------------------------------------------------------------------------
%                                           COMPARE ALL DELAY 
% --------------------------------------------------------------------------------------------------------------------------------------------
% --------------------------------------------------------------------------------------------------------------------------------------------


close all
exp={'DeltaT140';'DeltaT320';'DeltaT480'};

for delay=1:3
    Dir=PathForExperimentsDeltaSleep2016(exp(delay));
    a=1;
    
    for i=1:length(Dir.path)
        %             try
        disp(' ')
        disp('****************************************************************')
        eval(['cd(Dir.path{',num2str(i),'}'')'])
        disp(pwd)
        
        load newDeltaPFCx
        DeltaTime=tDelta;
        load DeltaSleepEvent
        DeltaDetect=TONEtime1_SWS;
        Tones=TONEtime1_SWS+Dir.delay{i}*1E4;
        
        % Define ToneON (with delta induction) and ToneOFF (without delta induction)
        TonesON=[];
        TonesOFF=[];
        for j=1:length(Tones)
            id=find(DeltaTime>Tones(j));
            try
                if (DeltaTime(id(1))-Tones(j))<0.2E4
                    TonesON=[TonesON,Tones(j)]; % selection of ToneON (with delta induction)
                else
                    TonesOFF=[TonesOFF,Tones(j)];  % selection of ToneOFF (without delta induction)
                end
            end
        end
        
        % Define Delta preceeding ToneON
        DeltaDetectON=TonesON-Dir.delay{i}*1E4;
        DeltaDetectOFF=TonesOFF-Dir.delay{i}*1E4;
        Efficiency(a)=length(DeltaDetectON)/length(DeltaDetectOFF);
        QtDelta(a)=length(tDelta);
        QtDeltaDetectON(a)=length(DeltaDetectON);
        
        % Define Relationship between Tone ON/OFF and Delta occurence
        [C,B]=CrossCorr(DeltaDetect,tDelta,20,200);           D(:,a)=C;
        [C1,B1]=CrossCorr(tDelta,tDelta,20,200); C1(B1==0)=0; D1(:,a)=C1;
        [C2,B2]=CrossCorr(DeltaDetectON,tDelta,20,200);       D2(:,a)=C2;
        [C3,B3]=CrossCorr(DeltaDetectOFF,tDelta,20,200);      D3(:,a)=C3;
        a=a+1;
    end

    smo=1;
    clear ymax ymax1
    ymax=max(ceil(max(D)));
    figure('color',[1 1 1])
    
    hold on, subplot(3,1,1)
    hold on, plot(B/1E3,SmoothDec(mean(D,2),smo),'k','linewidth',2)
    hold on, plot(B/1E3,SmoothDec(D,smo),'k')
    hold on, title(['delay = ',num2str(Dir.delay{i}*1E3),'ms - Tone effect => ',num2str((mean(Efficiency))*100),'%'])
    
    hold on, subplot(3,1,2)
    hold on, plot(B/1E3,SmoothDec(mean(D1,2),smo),'k','linewidth',2)
    hold on, plot(B/1E3,SmoothDec(D1,smo),'k')
    hold on, plot(B/1E3,SmoothDec(mean(D2,2),smo),'r','linewidth',2)
    hold on, plot(B/1E3,SmoothDec(D2,smo),'r')
    hold on, legend(['Delta (n=',num2str(mean(QtDelta)),')'],['DeltaDetectON (n=',num2str(mean(QtDeltaDetectON)),')'])
    hold on, rectangle('Position',[Dir.delay{i},0,0.2,12])
    
    hold on, subplot(3,1,3)
    hold on, plot(B/1E3,SmoothDec(mean(D1,2),smo),'k','linewidth',2)
    hold on, plot(B/1E3,SmoothDec(D1,smo),'k')
    hold on, plot(B/1E3,SmoothDec(mean(D3,2),smo),'b','linewidth',2)
    hold on, plot(B/1E3,SmoothDec(D3,smo),'b')
    hold on, legend(['Delta (n=',num2str(mean(QtDelta)),')'],['DeltaDetectOFF (n=',num2str(length(DeltaDetectOFF)),')'])
    hold on, rectangle('Position',[Dir.delay{i},0,0.2,12])
    clear D D1 D2
    
end







% --------------------------------------------------------------------------------------------------------------------------------------------
% --------------------------------------------------------------------------------------------------------------------------------------------
%                                          TONE > DOWN STATES CROSS CORR
% --------------------------------------------------------------------------------------------------------------------------------------------
% --------------------------------------------------------------------------------------------------------------------------------------------


mouse=244;
close all
exp={'DeltaT140';'DeltaT320';'DeltaT480'};
for Delay=1:4
    
    Dir=PathForExperimentsDeltaSleep2016(exp(Delay));
    Dir=RestrictPathForExperiment(Dir,'nMice',mouse);
    a=1;
    
    for i=1:length(Dir.path)
        %             try
        disp(' ')
        disp('****************************************************************')
        eval(['cd(Dir.path{',num2str(i),'}'')'])
        disp(pwd)
        
        load newDeltaPFCx
        DeltaTime=tDelta;
        load DownSpk
        tDown=start(Down);
        load DeltaSleepEvent
        DeltaDetect=TONEtime1_SWS;
        if Delay==1
            Dir.delay{i}=0.14;
        elseif Delay==2
            Dir.delay{i}=0.2;
        elseif Delay==3
            Dir.delay{i}=0.32;
        elseif Delay==4
            Dir.delay{i}=0.48;
        end
        Tones=TONEtime2_SWS+Dir.delay{i}*1E4;
            
            
        
        % Define ToneON (with delta induction) and ToneOFF (without delta induction)
        TonesON=[];
        TonesOFF=[];
        for j=1:length(Tones)
            id=find(DeltaTime>Tones(j));
            try
                if (DeltaTime(id(1))-Tones(j))<0.2E4
                    TonesON=[TonesON,Tones(j)]; % selection of ToneON (with delta induction)
                else
                    TonesOFF=[TonesOFF,Tones(j)];  % selection of ToneOFF (without delta induction)
                end
            end
        end
        
        % Define Delta preceeding ToneON
        DeltaDetectON=TonesON-Dir.delay{i}*1E4;
        DeltaDetectOFF=TonesOFF-Dir.delay{i}*1E4;
        Efficiency(a)=length(DeltaDetectON)/length(DeltaDetectOFF);
        QtDelta(a)=length(tDelta);
        QtDeltaDetectON(a)=length(DeltaDetectON);
        
        % Define Relationship between Tone ON/OFF and Delta occurence
        [C,B]=CrossCorr(tDown,tDown,20,200);           D(:,a)=C;
        [C1,B1]=CrossCorr(DeltaDetectON,tDown,20,200);  D1(:,a)=C1;
        [C2,B2]=CrossCorr(DeltaDetectOFF,tDown,20,200); D2(:,a)=C2;
        a=a+1;
    end

    smo=1;
    clear ymax
    ymax=ceil(max(mean(D1,2)));
    figure('color',[1 1 1])
    
    hold on, subplot(2,1,1)
    hold on, plot(B/1E3,SmoothDec(mean(D,2),smo),'k','linewidth',2)
    hold on, plot(B/1E3,SmoothDec(mean(D,2)+std(D,0,2),smo),'k')
    hold on, plot(B/1E3,SmoothDec(mean(D,2)-std(D,0,2),smo),'k')
    hold on, plot(B/1E3,SmoothDec(mean(D1,2),smo),'r','linewidth',2)
    hold on, plot(B/1E3,SmoothDec(mean(D1,2)+std(D1,0,2),smo),'r')
    hold on, plot(B/1E3,SmoothDec(mean(D1,2)-std(D1,0,2),smo),'r')
    hold on, legend(['Delta (n=',num2str(mean(QtDelta)),')'],['DeltaDetectON (n=',num2str(mean(QtDeltaDetectON)),')'])
    hold on, axis([-2 2 0 ymax])
    hold on, rectangle('Position',[Dir.delay{i},0,0.2,ymax])
    hold on, title(['delay = ',num2str(Dir.delay{i}*1E3),'ms - Tone effect => ',num2str((mean(Efficiency))*100),'%'])
    
    hold on, subplot(2,1,2)
    hold on, plot(B/1E3,SmoothDec(mean(D,2),smo),'k','linewidth',2)
    hold on, plot(B/1E3,SmoothDec(mean(D,2)+std(D,0,2),smo),'k')
    hold on, plot(B/1E3,SmoothDec(mean(D,2)-std(D,0,2),smo),'k')
    hold on, plot(B/1E3,SmoothDec(mean(D2,2),smo),'b','linewidth',2)
    hold on, plot(B/1E3,SmoothDec(mean(D2,2)+std(D2,0,2),smo),'b')
    hold on, plot(B/1E3,SmoothDec(mean(D2,2)-std(D2,0,2),smo),'b')
    hold on, legend(['Delta (n=',num2str(mean(QtDelta)),')'],['DeltaDetectOFF (n=',num2str(length(DeltaDetectOFF)),')'])
    hold on, axis([-2 2 0 ymax])
    hold on, rectangle('Position',[Dir.delay{i},0,0.2,ymax])
    clear D D1 D2
    
end


% --------------------------------------------------------------------------------------------------------------------------------------------
% --------------------------------------------------------------------------------------------------------------------------------------------
%                                           COMPARE ALL STRUCTURES 
% --------------------------------------------------------------------------------------------------------------------------------------------
% --------------------------------------------------------------------------------------------------------------------------------------------

% close all
% 
% exp={'DeltaT140';'DeltaT200';'DeltaT320';'DeltaT480'};
% 
% for Delay=1:4
%     Dir=PathForExperimentsDeltaSleep2016(exp(Delay));
%     b=1;
%     
%     figure('color',[1 1 1])
%     
%     for Structure=1:3
%         
%         a=1;
% 
%         for i=1:length(Dir.path)
%             disp(' ')
%             disp('****************************************************************')
%             eval(['cd(Dir.path{',num2str(i),'}'')'])
%             disp(pwd)
%             
%             if Structure==1
%                 load newDeltaPFCx
%             elseif Structure==2
%                 load newDeltaPaCx
%             elseif Structure==3
%                 load newDeltaMoCx
%             end
%             load DeltaSleepEvent
%             Tones=TONEtime2_SWS+Dir.delay{i}*1E4;
%             
%             % Define ToneON (with delta induction) and ToneOFF (without delta induction)
%             clear id
%             TonesON=[];
%             TonesOFF=[];
%             for j=1:length(Tones)
%                 id=find(tDelta>Tones(j));
%                 try
%                     if (tDelta(id(1))-Tones(j))<0.2E4
%                         TonesON=[TonesON,Tones(j)]; % selection of ToneON (with delta induction)
%                     else
%                         TonesOFF=[TonesOFF,Tones(j)];  % selection of ToneOFF (without delta induction)
%                     end
%                 end
%             end
%             
%             % Define Delta preceeding ToneON
%             DeltaDetectON=TonesON-Dir.delay{i}*1E4;
%             DeltaDetectOFF=TonesOFF-Dir.delay{i}*1E4;
%             Efficiency(a)=length(DeltaDetectON)/length(DeltaDetectOFF);
%             QtDelta(a)=length(tDelta);
%             QtDeltaDetectON(a)=length(DeltaDetectON);
%             
%             % Define Relationship between Tone ON/OFF and Delta occurence
%             [C,B]=CrossCorr(tDelta,tDelta,20,400);           D(:,a)=C;
%             [C1,B1]=CrossCorr(DeltaDetectON,tDelta,20,400);  D1(:,a)=C1;
%             [C2,B2]=CrossCorr(DeltaDetectOFF,tDelta,20,400); D2(:,a)=C2;
%             a=a+1;
%         end
%         
%         
%         smo=1;
%         ymax=ceil(max(mean(D1,2)));
%         
%         hold on, subplot(2,3,b)
%         hold on, plot(B/1E3,SmoothDec(mean(D,2),smo),'k','linewidth',2)
%         hold on, plot(B/1E3,SmoothDec(mean(D,2)+std(D,0,2),smo),'k')
%         hold on, plot(B/1E3,SmoothDec(mean(D,2)-std(D,0,2),smo),'k')
%         hold on, plot(B/1E3,SmoothDec(mean(D1,2),smo),'r','linewidth',2)
%         hold on, plot(B/1E3,SmoothDec(mean(D1,2)+std(D1,0,2),smo),'r')
%         hold on, plot(B/1E3,SmoothDec(mean(D1,2)-std(D1,0,2),smo),'r')
%         hold on, legend(['Delta (n=',num2str(mean(QtDelta)),')'],['DeltaDetectON (n=',num2str(mean(QtDeltaDetectON)),')'])
%         hold on, axis([-2 2 0 ymax])
%         hold on, rectangle('Position',[Dir.delay{i},0,0.2,ymax])
%         hold on, title(['delay = ',num2str(Dir.delay{i}*1E3),'ms - Tone effect => ',num2str((mean(Efficiency))*100),'%'])
%         
%         hold on, subplot(2,3,b+3)
%         hold on, plot(B/1E3,SmoothDec(mean(D,2),smo),'k','linewidth',2)
%         hold on, plot(B/1E3,SmoothDec(mean(D,2)+std(D,0,2),smo),'k')
%         hold on, plot(B/1E3,SmoothDec(mean(D,2)-std(D,0,2),smo),'k')
%         hold on, plot(B/1E3,SmoothDec(mean(D2,2),smo),'b','linewidth',2)
%         hold on, plot(B/1E3,SmoothDec(mean(D2,2)+std(D2,0,2),smo),'b')
%         hold on, plot(B/1E3,SmoothDec(mean(D2,2)-std(D2,0,2),smo),'b')
%         hold on, legend(['Delta (n=',num2str(mean(QtDelta)),')'],['DeltaDetectOFF (n=',num2str(length(DeltaDetectOFF)),')'])
%         hold on, axis([-2 2 0 ymax])
%         hold on, rectangle('Position',[Dir.delay{i},0,0.2,ymax])
%         b=b+1;
%         clear D D1 D2
%     end
%     
% end


%     figure('color',[1 1 1]), hold on
%     d=diff(tDelta'/1E4);
%     [h,b]=hist(d,[-0.01:0.02:3]);
%     hold on, subplot(3,1,1)
%     hold on, plot(b,h)
%     hold on, axis([0 2.9 0 400])
%     
%     d=diff(dpfcNoTone'/1E4);
%     [h,b]=hist(d,[-0.01:0.02:3]);
%     hold on, subplot(3,1,2)
%     hold on, plot(b,h)
%     hold on, axis([0 2.9 0 400])
%     
%     d=diff(dpfcTone'/1E4);
%     [h,b]=hist(d,[-0.01:0.2:10]);
%     hold on, subplot(3,1,3)
%     hold on, plot(b,h)
%     hold on, axis([0 9 0 400])
%     
    
%     dpfcTone2=[];
%     dpfcNoTone2=[];
%     for j=1:length(dpfcNoTone)
%         id=find(dpfcTone<dpfcNoTone(j));
%         try
%             if (dpfcNoTone(j)-dpfcTone(id(end)))<0.6E4
%                 dpfcTone2=[dpfcTone2,dpfcNoTone(j)];
%             else
%                 dpfcNoTone2=[dpfcNoTone2,dpfcNoTone(j)];
%             end
%         end
%     end
