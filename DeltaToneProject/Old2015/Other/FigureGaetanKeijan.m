%FigureGaetanKeijan


%Dir=PathForExperimentsDeltaSleep('BASAL');


Dir=PathForExperimentsDeltaSleepNew('RdmTone');
        Rt=[];
        Ct=[];
        a=1;
        clear Atj
        clear A
        for man=1:length(Dir.path)
            disp('  ')
            disp(Dir.path{man})
            disp(Dir.name{man})
            disp(' ')
            cd(Dir.path{man})
            clear delay            
            delay=Dir.delay{man};
            BrainStatesFailureDownStatesTones
            close all
            Rt=[Rt;Res];
            Ct=[Ct;C'];
            tps=B;
            try
            Atj=Atj+Aj;
            catch
            Atj=Aj;
            end
            A{a}=Aj;
            a=a+1;
        end
        
      



Dir=PathForExperimentsDeltaSleepNew('DeltaT140');
        
        Rt1=[];
        Ct1=[];
        clear Atj1
        clear A1
        a=1;
        for man=1:length(Dir.path)
            disp('  ')
            disp(Dir.path{man})
            disp(Dir.name{man})
            disp(' ')
            cd(Dir.path{man})
            clear delay
            delay=Dir.delay{man};
            BrainStatesFailureDownStatesTones
            close all
            Rt1=[Rt1;Res];
            Ct1=[Ct1;C'];
            tps=B;
            try
            Atj1=Atj1+Aj;
            catch
            Atj1=Aj;
            end
            A1{a}=Aj;
            a=a+1;
        end
      


Dir=PathForExperimentsDeltaSleepNew('DeltaT200');
        Rt2=[];
        Ct2=[];
        clear Atj2
        clear A2        
        a=1;
        for man=1:length(Dir.path)
            disp('  ')
            disp(Dir.path{man})
            disp(Dir.name{man})
            disp(' ')
            cd(Dir.path{man})
            clear delay            
            delay=Dir.delay{man};
            BrainStatesFailureDownStatesTones
            close all
            Rt2=[Rt2;Res];
            Ct2=[Ct2;C'];
            tps=B;
            try
            Atj2=Atj2+Aj;
            catch
            Atj2=Aj;
            end
            A2{a}=Aj;
            a=a+1;
        end
       
        
        
Dir=PathForExperimentsDeltaSleepNew('DeltaT320');

Rt3=[];
        Ct3=[];
        clear Atj3
        clear A3        
        a=1;
        for man=1:length(Dir.path)
            disp('  ')
            disp(Dir.path{man})
            disp(Dir.name{man})
            disp(' ')
            cd(Dir.path{man})
            clear delay            
            delay=Dir.delay{man};
            BrainStatesFailureDownStatesTones
            close all
            Rt3=[Rt3;Res];
            Ct3=[Ct3;C'];
            tps=B;
            try
            Atj3=Atj3+Aj;
            catch
            Atj3=Aj;
            end
            A3{a}=Aj;
            a=a+1;
        end
      
        
        
Dir=PathForExperimentsDeltaSleepNew('DeltaT480');

Rt4=[];
        Ct4=[];
        a=1;
        clear Atj4
        clear A4        
        for man=1:length(Dir.path)
            disp('  ')
            disp(Dir.path{man})
            disp(Dir.name{man})
            disp(' ')
            cd(Dir.path{man})
            clear delay            
            delay=Dir.delay{man};
            BrainStatesFailureDownStatesTones
            close all
            Rt4=[Rt4;Res];
            Ct4=[Ct4;C'];
            tps=B;
            try
            Atj4=Atj4+Aj;
            catch
            Atj4=Aj;
            end
            A4{a}=Aj;
            a=a+1;
        end
       

% Dir=PathForExperimentsDeltaSleepNew('DeltaT3delays');
% 
% 
% Rt5=[];
%         Ct5=[];
%         clear Atj5
%         clear A5        
%         a=1;
%         for man=1:length(Dir.path)
%             disp('  ')
%             disp(Dir.path{man})
%             disp(Dir.name{man})
%             disp(' ')
%             cd(Dir.path{man})
%             clear delay            
%             delay=Dir.delay{man};
%             BrainStatesFailureDownStatesTones
%             close all
%             Rt5=[Rt5;Res];
%             Ct5=[Ct5;C'];
%             tps=B;
%             try
%             Atj5=Atj5+Aj;
%             catch
%             Atj5=Aj;
%             end
%             A5{a}=Aj;
%             a=a+1;
%         end
   
%--------------------------------------------------------------------------------
%--------------------------------------------------------------------------------
%--------------------------------------------------------------------------------

%close all


         smo=1;
         

figure('color',[1 1 1]), 
subplot(3,1,1:2), imagesc(Bj/1E3,Bj/1E3,SmoothDec(Atj,[0.7 0.7])), axis xy
yl=ylim;xl=xlim;
line([0 0],yl,'color','w')
line(xl,[0 0],'color','w')
subplot(3,1,3), plot(tps/1E3,Ct,'k'), axis xy
yl=ylim;
line([0 0],yl,'color','r')
subplot(3,1,1:2),title('Start Down, Tones, End Down')
 fa=(1000)/2000;
 fa=fa/0.5;
 text(-0.48*fa,0.45*fa,'2->1->3','colo','w')
 text(0.32*fa,0.45*fa,'1->2->3','colo','w')
 text(-0.48*fa,-0.45*fa,'3->2->1','colo','w')
 text(0.32*fa,-0.45*fa,'3->1->2','colo','w')
figure('color',[1 1 1])
for i=1:length(A)
    subplot(1,length(A),i), imagesc(Bj/1E3,Bj/1E3,SmoothDec(A{i},[0.7 0.7])), axis xy
    yl=ylim;xl=xlim;
    line([0 0],yl,'color','w')
    line(xl,[0 0],'color','w')
    title('Start Down, Tones, End Down')
    fa=(1000)/2000;
    fa=fa/0.5;
    text(-0.48*fa,0.45*fa,'2->1->3','colo','w')
    text(0.32*fa,0.45*fa,'1->2->3','colo','w')
    text(-0.48*fa,-0.45*fa,'3->2->1','colo','w')
    text(0.32*fa,-0.45*fa,'3->1->2','colo','w')   
end
        



figure('color',[1 1 1]), 
subplot(3,1,1:2), imagesc(Bj/1E3,Bj/1E3,SmoothDec(Atj1,[0.7 0.7])), axis xy
yl=ylim;xl=xlim;
line([0 0],yl,'color','w')
line(xl,[0 0],'color','w')
subplot(3,1,3), plot(tps/1E3,Ct1,'k'), axis xy
yl=ylim;
line([0 0],yl,'color','r')
subplot(3,1,1:2),title('Start Down, Tones, End Down')
 fa=(1000)/2000;
 fa=fa/0.5;
 text(-0.48*fa,0.45*fa,'2->1->3','colo','w')
 text(0.32*fa,0.45*fa,'1->2->3','colo','w')
 text(-0.48*fa,-0.45*fa,'3->2->1','colo','w')
 text(0.32*fa,-0.45*fa,'3->1->2','colo','w')
figure('color',[1 1 1])
for i=1:length(A1)
    subplot(1,length(A1),i), imagesc(Bj/1E3,Bj/1E3,SmoothDec(A1{i},[0.7 0.7])), axis xy
    yl=ylim;xl=xlim;
    line([0 0],yl,'color','w')
    line(xl,[0 0],'color','w')
    title('Start Down, Tones, End Down')
    fa=(1000)/2000;
    fa=fa/0.5;
    text(-0.48*fa,0.45*fa,'2->1->3','colo','w')
    text(0.32*fa,0.45*fa,'1->2->3','colo','w')
    text(-0.48*fa,-0.45*fa,'3->2->1','colo','w')
    text(0.32*fa,-0.45*fa,'3->1->2','colo','w')   
end






figure('color',[1 1 1]), 
subplot(3,1,1:2), imagesc(Bj/1E3,Bj/1E3,SmoothDec(Atj2,[0.7 0.7])), axis xy
yl=ylim;xl=xlim;
line([0 0],yl,'color','w')
line(xl,[0 0],'color','w')
subplot(3,1,3), plot(tps/1E3,Ct2,'k'), axis xy
yl=ylim;
line([0 0],yl,'color','r')
subplot(3,1,1:2),title('Start Down, Tones, End Down')
 fa=(1000)/2000;
 fa=fa/0.5;
 text(-0.48*fa,0.45*fa,'2->1->3','colo','w')
 text(0.32*fa,0.45*fa,'1->2->3','colo','w')
 text(-0.48*fa,-0.45*fa,'3->2->1','colo','w')
 text(0.32*fa,-0.45*fa,'3->1->2','colo','w')
figure('color',[1 1 1])
for i=1:length(A2)
    subplot(1,length(A2),i), imagesc(Bj/1E3,Bj/1E3,SmoothDec(A2{i},[0.7 0.7])), axis xy
    yl=ylim;xl=xlim;
    line([0 0],yl,'color','w')
    line(xl,[0 0],'color','w')
    title('Start Down, Tones, End Down')
    fa=(1000)/2000;
    fa=fa/0.5;
    text(-0.48*fa,0.45*fa,'2->1->3','colo','w')
    text(0.32*fa,0.45*fa,'1->2->3','colo','w')
    text(-0.48*fa,-0.45*fa,'3->2->1','colo','w')
    text(0.32*fa,-0.45*fa,'3->1->2','colo','w')   
end








figure('color',[1 1 1]), 
subplot(3,1,1:2), imagesc(Bj/1E3,Bj/1E3,SmoothDec(Atj3,[0.7 0.7])), axis xy
yl=ylim;xl=xlim;
line([0 0],yl,'color','w')
line(xl,[0 0],'color','w')
subplot(3,1,3), plot(tps/1E3,Ct3,'k'), axis xy
yl=ylim;
line([0 0],yl,'color','r')
subplot(3,1,1:2),title('Start Down, Tones, End Down')
 fa=(1000)/2000;
 fa=fa/0.5;
 text(-0.48*fa,0.45*fa,'2->1->3','colo','w')
 text(0.32*fa,0.45*fa,'1->2->3','colo','w')
 text(-0.48*fa,-0.45*fa,'3->2->1','colo','w')
 text(0.32*fa,-0.45*fa,'3->1->2','colo','w')
figure('color',[1 1 1])
for i=1:length(A3)
    subplot(1,length(A3),i), imagesc(Bj/1E3,Bj/1E3,SmoothDec(A3{i},[0.7 0.7])), axis xy
    yl=ylim;xl=xlim;
    line([0 0],yl,'color','w')
    line(xl,[0 0],'color','w')
    title('Start Down, Tones, End Down')
    fa=(1000)/2000;
    fa=fa/0.5;
    text(-0.48*fa,0.45*fa,'2->1->3','colo','w')
    text(0.32*fa,0.45*fa,'1->2->3','colo','w')
    text(-0.48*fa,-0.45*fa,'3->2->1','colo','w')
    text(0.32*fa,-0.45*fa,'3->1->2','colo','w')   
end







figure('color',[1 1 1]), 
subplot(3,1,1:2), imagesc(Bj/1E3,Bj/1E3,SmoothDec(Atj4,[0.7 0.7])), axis xy
yl=ylim;xl=xlim;
line([0 0],yl,'color','w')
line(xl,[0 0],'color','w')
subplot(3,1,3), plot(tps/1E3,Ct4,'k'), axis xy
yl=ylim;
line([0 0],yl,'color','r')
subplot(3,1,1:2),title('Start Down, Tones, End Down')
 fa=(1000)/2000;
 fa=fa/0.5;
 text(-0.48*fa,0.45*fa,'2->1->3','colo','w')
 text(0.32*fa,0.45*fa,'1->2->3','colo','w')
 text(-0.48*fa,-0.45*fa,'3->2->1','colo','w')
 text(0.32*fa,-0.45*fa,'3->1->2','colo','w')
figure('color',[1 1 1])
for i=1:length(A4)
    subplot(1,length(A4),i), imagesc(Bj/1E3,Bj/1E3,SmoothDec(A4{i},[0.7 0.7])), axis xy
    yl=ylim;xl=xlim;
    line([0 0],yl,'color','w')
    line(xl,[0 0],'color','w')
    title('Start Down, Tones, End Down')
    fa=(1000)/2000;
    fa=fa/0.5;
    text(-0.48*fa,0.45*fa,'2->1->3','colo','w')
    text(0.32*fa,0.45*fa,'1->2->3','colo','w')
    text(-0.48*fa,-0.45*fa,'3->2->1','colo','w')
    text(0.32*fa,-0.45*fa,'3->1->2','colo','w')   
end







% figure('color',[1 1 1]),
% subplot(3,1,1:2), imagesc(Bj/1E3,Bj/1E3,SmoothDec(Atj5,[0.7 0.7])), axis xy
% yl=ylim;xl=xlim;
% line([0 0],yl,'color','w')
% line(xl,[0 0],'color','w')
% subplot(3,1,3), plot(tps/1E3,Ct5,'k'), axis xy
% yl=ylim;
% line([0 0],yl,'color','r')
% subplot(3,1,1:2),title('Start Down, Tones, End Down')
% fa=(1000)/2000;
% fa=fa/0.5;
% text(-0.48*fa,0.45*fa,'2->1->3','colo','w')
% text(0.32*fa,0.45*fa,'1->2->3','colo','w')
% text(-0.48*fa,-0.45*fa,'3->2->1','colo','w')
% text(0.32*fa,-0.45*fa,'3->1->2','colo','w')
% figure('color',[1 1 1])
% for i=1:length(A5)
%     subplot(1,length(A5),i), imagesc(Bj/1E3,Bj/1E3,SmoothDec(A5{i},[0.7 0.7])), axis xy
%     yl=ylim;xl=xlim;
%     line([0 0],yl,'color','w')
%     line(xl,[0 0],'color','w')
%     title('Start Down, Tones, End Down')
%     fa=(1000)/2000;
%     fa=fa/0.5;
%     text(-0.48*fa,0.45*fa,'2->1->3','colo','w')
%     text(0.32*fa,0.45*fa,'1->2->3','colo','w')
%     text(-0.48*fa,-0.45*fa,'3->2->1','colo','w')
%     text(0.32*fa,-0.45*fa,'3->1->2','colo','w')
% end







figure('color',[1 1 1])
plot(tps/1E3,Ct,'k')
yl=ylim; line([0 0],yl,'color','b')
%saveFigure(15,'figure1','/home/vador')
ylabel('Delta Waves')
xlabel('Time (s)')


figure('color',[1 1 1])
plot(tps/1E3,Ct1,'k')
hold on, plot(tps/1E3,Ct2,'r')
yl=ylim; line([0 0],yl,'color','b')
hold on, plot(tps/1E3,Ct3,'m')

%saveFigure(15,'figure1','/home/vador')
ylabel('Delta Waves')
xlabel('Time (s)')


%         
%   
%   
%         figure('color',[1 1 1]), 
%         subplot(3,1,1:2), imagesc(Bj,Bj,SmoothDec(Atj1,[smo smo])), axis xy
%         yl=ylim;xl=xlim;
%         line([0 0],yl,'color','w')
%         line(xl,[0 0],'color','w')
%         subplot(3,1,3), plot(tps/1E3,Ct1,'k'), axis xy
%         yl=ylim;
%         line([0 0],yl,'color','r')
% 
% 
%         
%         
%        smo=1;
%         figure('color',[1 1 1]), 
%         subplot(3,1,1:2), imagesc(Bj,Bj,SmoothDec(Atj2,[smo smo])), axis xy
%         yl=ylim;xl=xlim;
%         line([0 0],yl,'color','w')
%         line(xl,[0 0],'color','w')
%         subplot(3,1,3), plot(tps/1E3,Ct2,'k'), axis xy
%         yl=ylim;
%         line([0 0],yl,'color','r')
% 
%         
%         
%       smo=1;
%         figure('color',[1 1 1]), 
%         subplot(3,1,1:2), imagesc(Bj,Bj,SmoothDec(Atj3,[smo smo])), axis xy
%         yl=ylim;xl=xlim;
%         line([0 0],yl,'color','w')
%         line(xl,[0 0],'color','w')
%         subplot(3,1,3), plot(tps/1E3,Ct3,'k'), axis xy
%         yl=ylim;
%         line([0 0],yl,'color','r')
%     
%         
%         
%         smo=1;
%         figure('color',[1 1 1]), 
%         subplot(3,1,1:2), imagesc(Bj,Bj,SmoothDec(Atj4,[smo smo])), axis xy
%         yl=ylim;xl=xlim;
%         line([0 0],yl,'color','w')
%         line(xl,[0 0],'color','w')
%         subplot(3,1,3), plot(tps/1E3,Ct4,'k'), axis xy
%         yl=ylim;
%         line([0 0],yl,'color','r')
%  
%         
%         
%  smo=1;
%         figure('color',[1 1 1]), 
%         subplot(3,1,1:2), imagesc(Bj,Bj,SmoothDec(Atj5,[smo smo])), axis xy
%         yl=ylim;xl=xlim;
%         line([0 0],yl,'color','w')
%         line(xl,[0 0],'color','w')
%         subplot(3,1,3), plot(tps/1E3,Ct5,'k'), axis xy
%         yl=ylim;
%         line([0 0],yl,'color','r')
% 
% 
% 
