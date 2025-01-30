%-------------------------------
% enlever les valeurs aberrantes
%-------------------------------
lim=6000; % less noise on thalamus channels - for cortical lim=6500
for i=1:13
NewAllBBBBx=[Data(LFP_LocalEffect_std(i))'];
NewAllBBBBx(NewAllBBBBx>lim)=nan;
NewAllBBBBx(NewAllBBBBx<-lim)=nan;
figure, imagesc(NewAllBBBBx)
end

%--------------------------------------------
% trier les essais selon les potentiel evoqué
%--------------------------------------------
Tone1=[75+5:100];
Tone2=[150+5:175];
Tone3=[225+5:250];
Tone4=[300+5:325];
Tone5=[375+5:400];

for i=1:13
    a=i+1;
    NewLocalEffect_dvt=Data(LFP_LocalEffect_dvt(i))';
    [idx,idy]=find(abs(NewLocalEffect_dvt)>lim);
    NewLocalEffect_dvt(unique(idx),:)=[];
    
    NewLocalEffect_std=Data(LFP_LocalEffect_std(i))';
    [idx,idy]=find(abs(NewLocalEffect_std)>lim);
    NewLocalEffect_std(unique(idx),:)=[];
    
    [BE,id_dvt1]=sort((mean(NewLocalEffect_dvt(:,Tone1)')));
    [BE,id_dvt2]=sort((mean(NewLocalEffect_dvt(:,Tone2)')));
    
    [BE,id_std1]=sort((mean(NewLocalEffect_std(:,Tone1)')));
    [BE,id_std2]=sort((mean(NewLocalEffect_std(:,Tone2)')));
    %BE,id3]=sort((mean(NewGlobalEffectLdvt_std(:,F2)')-mean(NewGlobalEffectLdvt_std(:,F1)')));
    
    figure, subplot(2,1,1)
    hold on, imagesc(NewLocalEffect_dvt(id1,:)), hold on,  title([num2str(i),'- classed by mean diff. ERPs >Tone 1 ',InfoLFP.structure(a)])
    hold on, axis([0 675 0 length(NewLocalEffect_dvt)])
    hold on, subplot(2,1,2)
    hold on, imagesc(NewLocalEffect_dvt(id2,:)), hold on,  title([num2str(i),'- classed by mean diff. ERPs >Tone 2 ',InfoLFP.structure(a)])
    hold on, axis([0 675 0 length(NewLocalEffect_dvt)])
      
    %-----------------------------------------
    % plotter les differents potentiels evoqué
    %-----------------------------------------
    figure, subplot(2,1,1)
    hold on, plot(mean(NewLocalEffect_dvt(id_dvt1(1:length(NewLocalEffect_dvt)/3),:)),'r','linewidth',2)
    hold on, plot(mean(NewLocalEffect_dvt(id_dvt1((length(NewLocalEffect_dvt)/3)*2:length(NewLocalEffect_dvt)),:)),'m','linewidth',2)
    hold on, plot(mean(NewLocalEffect_std(id_std1(1:length(NewLocalEffect_std)/3),:)),'b','linewidth',2)
    hold on, plot(mean(NewLocalEffect_std(id_std1((length(NewLocalEffect_std)/3)*2:length(NewLocalEffect_std)),:)),'c','linewidth',2)
    hold on, title(['Tone 1  ERPs - ',InfoLFP.structure(a)])
    hold on, plot([Tone1(1) Tone1(1)], [-2000 2000],'r','linewidth',2)
    hold on, plot([Tone2(1) Tone2(1)], [-2000 2000],'k','linewidth',1)
    hold on, plot([Tone3(1) Tone3(1)], [-2000 2000],'k','linewidth',1)
    hold on, plot([Tone4(1) Tone4(1)], [-2000 2000],'k','linewidth',1)
    hold on, plot([Tone5(1) Tone5(1)], [-2000 2000],'k','linewidth',1)
    hold on, subplot(2,1,2)
    hold on, plot(mean(NewLocalEffect_dvt(id_dvt2(1:length(NewLocalEffect_dvt)/3),:)),'r','linewidth',2)
    hold on, plot(mean(NewLocalEffect_dvt(id_dvt2((length(NewLocalEffect_dvt)/3)*2:length(NewLocalEffect_dvt)),:)),'m','linewidth',2)
    hold on, plot(mean(NewLocalEffect_std(id_std2(1:length(NewLocalEffect_std)/3),:)),'b','linewidth',2)
    hold on, plot(mean(NewLocalEffect_std(id_std2((length(NewLocalEffect_std)/3)*2:length(NewLocalEffect_std)),:)),'c','linewidth',2)
    hold on, title(['Tone 5  ERPs - ',InfoLFP.structure(a)])
    hold on, plot([Tone1(1) Tone1(1)], [-2000 2000],'k','linewidth',1)
    hold on, plot([Tone2(1) Tone2(1)], [-2000 2000],'k','linewidth',1)
    hold on, plot([Tone3(1) Tone3(1)], [-2000 2000],'k','linewidth',1)
    hold on, plot([Tone4(1) Tone4(1)], [-2000 2000],'k','linewidth',1)
    hold on, plot([Tone5(1) Tone5(1)], [-2000 2000],'r','linewidth',2)

end


%--------------------------------------------
% trier les essais selon les potentiel evoqué
%--------------------------------------------
F1=[80:100];
Tone1=[75:100];
Tone2=[150:175];
Tone3=[225:250];
Tone4=[300:325];
Tone5=[375:400];

for i=2:14
    %j=i+1;
    NewLstdGstd_A=Data(MLstdGstd_A(i))'; % AAAAA AAAAA
    [idx,idy]=find(abs(NewLstdGstd_A)>lim);
    NewLstdGstd_A(unique(idx),:)=[];
    
    NewLdvtGstd_B=Data(MLdevGstd_B(i))'; % BBBBA BBBBA
    [idx,idy]=find(abs(NewLdvtGstd_B)>lim);
    NewLdvtGstd_B(unique(idx),:)=[];
    
    [BE,id_std2]=sort((mean(NewLstdGstd_A(:,F1)')));
    [BE,id_dvt2]=sort((mean(NewLdvtGstd_B(:,F1)')));
    
    NewOmiFreq_A=Data(OmiFreq_A(i))'; % AAAAA AAAAA
    [idx,idy]=find(abs(NewOmiFreq_A)>lim);
    NewOmiFreq_A(unique(idx),:)=[];
    
    NewOmiRare_A=Data(OmiRare_A(i))'; % BBBBA BBBBA
    [idx,idy]=find(abs(NewOmiRare_A)>lim);
    NewOmiRare_A(unique(idx),:)=[];
    
    [BE,id_OmiFreq]=sort((mean(NewOmiFreq_A(:,F1)')));
    [BE,id_OmiRare]=sort((mean(NewOmiRare_A(:,F1)')));
    
    [hLocal1,pLocal1]=ttest2(RemoveNan(NewLstdGstd_A(id_std2(1:length(NewLstdGstd_A(:,1))/3),:)),RemoveNan(NewLdvtGstd_B(id_dvt2(1:length(NewLdvtGstd_B(:,1))/3),:)));
    [hOmi1  ,pOmi1  ]=ttest2(RemoveNan(NewOmiFreq_A(id_OmiFreq(1:length(NewOmiFreq_A(:,1))/3),:)),RemoveNan(NewOmiRare_A(id_OmiRare(1:length(NewOmiRare_A(:,1))/3),:)));
    [hLocal2,pLocal2]=ttest2(RemoveNan(NewLstdGstd_A(id_std2((length(NewLstdGstd_A(:,1))/3)*2:length(NewLstdGstd_A(:,1))),:)),RemoveNan(NewLdvtGstd_B(id_dvt2((length(NewLdvtGstd_B(:,1))/3)*2:length(NewLdvtGstd_B(:,1))),:)));
    [hOmi2  ,pOmi2  ]=ttest2(RemoveNan(NewOmiFreq_A(id_OmiFreq((length(NewOmiFreq_A(:,1))/3)*2:length(NewOmiFreq_A(:,1))),:)),RemoveNan(NewOmiRare_A(id_OmiRare((length(NewOmiRare_A(:,1))/3)*2:length(NewOmiRare_A(:,1))),:)));
    %-----------------------------------------
    % plotter les differents potentiels evoqué
    %-----------------------------------------
    figure, subplot(8,1,[1 2 3])
    hold on, plot(mean(NewLstdGstd_A(id_std2(1:length(NewLstdGstd_A(:,1))/3),:)),'r','linewidth',2)
    hold on, plot(mean(NewLstdGstd_A(id_std2((length(NewLstdGstd_A(:,1))/3)*2:length(NewLstdGstd_A(:,1))),:)),'m','linewidth',2)
    hold on, plot(mean(NewLdvtGstd_B(id_dvt2(1:length(NewLdvtGstd_B(:,1))/3),:)),'b','linewidth',2)
    hold on, plot(mean(NewLdvtGstd_B(id_dvt2((length(NewLdvtGstd_B(:,1))/3)*2:length(NewLdvtGstd_B(:,1))),:)),'c','linewidth',2)
    hold on, title(['Std(red) VS Dvt(blue) classed by Tone1 ERPs - ',InfoLFP.structure(i)])
    hold on, axis([0 675 -2000 2000])
    for a=75:75:375
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
    end
    hold on, subplot(8,1,4)
    hold on, plot(pLocal1,'r','linewidth',2), 
    hold on, plot(pLocal2,'k','linewidth',2), axis([0 675 0 0.05])
    
    hold on, subplot(8,1,[5 6 7])
    hold on, plot(mean(NewOmiFreq_A(id_OmiFreq(1:length(NewOmiFreq_A(:,1))/3),:)),'r','linewidth',2)
    hold on, plot(mean(NewOmiFreq_A(id_OmiFreq((length(NewOmiFreq_A(:,1))/3)*2:length(NewOmiFreq_A(:,1))),:)),'m','linewidth',2)
    hold on, plot(mean(NewOmiRare_A(id_OmiRare(1:length(NewOmiRare_A(:,1))/3),:)),'b','linewidth',2)
    hold on, plot(mean(NewOmiRare_A(id_OmiRare((length(NewOmiRare_A(:,1))/3)*2:length(NewOmiRare_A(:,1))),:)),'c','linewidth',2)
    hold on, title(['OmiFreq(red) VS OmiRare(blue) classed by Tone1 ERPs - ',InfoLFP.structure(i)])
    hold on, axis([0 675 -2000 2000])
    for a=75:75:375
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
    end
    hold on, subplot(8,1,8)
    hold on, plot(pOmi1,'r','linewidth',2)
    hold on, plot(pOmi2,'k','linewidth',2), axis([0 675 0 0.05])

end


%--------------------------------------------
% trier les essais selon les potentiel evoqué
%--------------------------------------------
Tone1a=[60+300:70+300];

for i=2:13
    a=i+1;
    Tone1=[80:100];
    Tone5=[600:650];
    
    NewOmiFreq_A=Data(OmiFreq_A(i))'; % AAAAA AAAAA
    [idx,idy]=find(abs(NewOmiFreq_A)>lim);
    NewOmiFreq_A(unique(idx),:)=[];
    
   
    [BE,id_OmiFreq1]=sort((mean(NewOmiFreq_A(:,Tone1)')));
    [BE,id_OmiFreq5]=sort((mean(NewOmiFreq_A(:,Tone5)')));
    
    
     figure, subplot(3,1,1)
     hold on, imagesc(NewOmiFreq_A(id_OmiFreq1,:)), hold on,  title([num2str(i),'- classed by mean diff. ERPs >Tone 1 ',InfoLFP.structure(a)])
     hold on, axis([0 675 0 length(NewOmiFreq_A(:,1))])
     hold on, subplot(3,1,2)
     hold on, imagesc(NewOmiFreq_A(id_OmiFreq5,:)), hold on,  title([num2str(i),'- classed by mean diff. ERPs >Tone 2 ',InfoLFP.structure(a)])
     hold on, axis([0 675 0 length(NewOmiFreq_A(:,1))])
      
  
    %-----------------------------------------
    % plotter les differents potentiels evoqué
    %-----------------------------------------
    hold on, subplot(3,1,3) 
    hold on, plot(mean(NewOmiFreq_A(id_OmiFreq1(1:length(NewOmiFreq_A(:,1))/3),:)),'r','linewidth',2)
    hold on, plot(mean(NewOmiFreq_A(id_OmiFreq1((length(NewOmiFreq_A(:,1))/3)*2:length(NewOmiFreq_A(:,1))),:)),'m','linewidth',2)
    hold on, plot(mean(NewOmiFreq_A(id_OmiFreq5(1:length(NewOmiFreq_A(:,1))/3),:)),'b','linewidth',2)
    hold on, plot(mean(NewOmiFreq_A(id_OmiFreq5((length(NewOmiFreq_A(:,1))/3)*2:length(NewOmiFreq_A(:,1))),:)),'c','linewidth',2)
    hold on, title(['Tone 5  ERPs - ',InfoLFP.structure(a)])
    hold on, plot([Tone1(1) Tone1(1)], [-2000 2000],'k','linewidth',1)
    hold on, plot([Tone2(1) Tone2(1)], [-2000 2000],'k','linewidth',1)
    hold on, plot([Tone3(1) Tone3(1)], [-2000 2000],'k','linewidth',1)
    hold on, plot([Tone4(1) Tone4(1)], [-2000 2000],'k','linewidth',1)
    hold on, plot([Tone5(1) Tone5(1)], [-2000 2000],'r','linewidth',2)
end


%--------------------------------------------
% trier les essais selon les potentiel evoqué
%--------------------------------------------
lim=6000;

a=1;
for i=[2 3 7 9 10 12 14]
    
    a=i;
    NewLocalEffect_std=Data(LFP_LocalEffect_std(i))';
    [idx,idy]=find(abs(NewLocalEffect_std)>lim);
    NewLocalEffect_std(unique(idx),:)=[];
    figure, imagesc(NewLocalEffect_std)
    plot_std=rescale(NewLocalEffect_std,-1500,3000);
    hold on, plot(mean(plot_std),'k','linewidth',3)
    hold on, title(' time windows n°1 for analysis')
    [F1]=ginput(2); 
    hold on, title(' time windows n°2 for analysis')
    [F2]=ginput(2);
    F1_std=floor(F1(1)):floor(F1(2));
    F2_std=floor(F2(1)):floor(F2(2));
    close
        
    NewLocalEffect_dvt=Data(LFP_LocalEffect_dvt(i))';
    [idx,idy]=find(abs(NewLocalEffect_dvt)>lim);
    NewLocalEffect_dvt(unique(idx),:)=[];
    figure, imagesc(NewLocalEffect_dvt)
    plot_dvt=rescale(NewLocalEffect_dvt,-500,1000);
    hold on, plot(mean(plot_dvt),'k','linewidth',3)
    hold on, title(' time windows n°1 for analysis')
    [F1]=ginput(2); 
    hold on, title(' time windows n°2 for analysis')
    [F2]=ginput(2);
    F1_dvt=floor(F1(1)):floor(F1(2));
    F2_dvt=floor(F2(1)):floor(F2(2));
    close
        
    [BE,id_std]=sort((mean(NewLocalEffect_std(:,F2_std)')-mean(NewLocalEffect_std(:,F1_std)')));
    [BE,id_dvt]=sort((mean(NewLocalEffect_dvt(:,F2_dvt)')-mean(NewLocalEffect_dvt(:,F1_dvt)')));
    
    figure, subplot(3,1,1)
    hold on, imagesc(NewLocalEffect_std(id_std,:)), hold on,  title(['- classed by mean diff. ERPs > AAAAA ',InfoLFP.structure(a)])
    hold on, axis([0 675 0 length(NewLocalEffect_std)])
    hold on, subplot(3,1,2)
    hold on, imagesc(NewLocalEffect_dvt(id_dvt,:)), hold on,  title(['- classed by mean diff. ERPs > BBBBB ',InfoLFP.structure(a)])
    hold on, axis([0 675 0 length(NewLocalEffect_dvt)])
      
    %-----------------------------------------
    % plotter les differents potentiels evoqué
    %-----------------------------------------
    hold on, subplot(3,1,3)
    hold on, plot(mean(NewLocalEffect_dvt(id_dvt(1:length(id_dvt)/3),:)),'r','linewidth',2)
    hold on, plot(mean(NewLocalEffect_dvt(id_dvt((length(id_dvt)/3)*2:length(id_dvt)),:)),'m','linewidth',2)
    hold on, plot(mean(NewLocalEffect_std(id_std(1:length(id_std)/3),:)),'b','linewidth',2)
    hold on, plot(mean(NewLocalEffect_std(id_std((length(id_std)/3)*2:length(id_std)),:)),'c','linewidth',2)
    hold on, title(['Tone 1  ERPs - ',InfoLFP.structure(a)])
    hold on, axis([0 675 -2000 2000])
    for a=75:75:375
        hold on, plot(a,min(axis):max(axis),'b','linewidth',1);
    end

end

