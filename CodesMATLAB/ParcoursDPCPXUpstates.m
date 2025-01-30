%% -----------------------------------------------------------------------
%ParcoursDPCPXUpstates
%-------------------------------------------------------------------------

filename='/Users/karimbenchenane/Documents/Data/DataEnCours/Lisa/NewPaper/DataNewPaper/DataPharmaco/DPCPX';

pourc=0; % 1 : en pourcentage

eval(['cd(''',filename,''')'])
try 

    load ResultsAout2011
    R;
    
catch
    
    
%% -----------------------------------------------------------------------
%Effet DCPCX Ctrl --------------------------------------------------------
%-------------------------------------------------------------------------

eval(['cd(''',filename,''')'])
cd Ctrl


UpCtrlPre=[];
UpCtrlPost=[];
UpdoKOPre=[];
UpdoKOPost=[];

DownCtrlPre=[];
DownCtrlPost=[];
DowndoKOPre=[];
DowndoKOPost=[];


ResCtrlPre=[];
ResCtrlPost=[];
ResdoKOPre=[];
ResdoKOPost=[];


listdir=dir;

for i=1:length(listdir)

        eval(['cd(''',filename,''')'])
        cd Ctrl
        
        if listdir(i).isdir==1&listdir(i).name(1)~='.'

            
                    try                       
                    eval(['cd(''',listdir(i).name,'/DataSpont'')'])               
                    cd post
                    
                    load UpDown
                   
                    [Mup,Sup,Eup]=MeanDifNan(FinUp-DebutUp);
                    [Mdo,Sdo,Edo]=MeanDifNan(DebutUp(2:end)-FinUp(1:end-1));
                    UpCtrlPost=[UpCtrlPost;[Mup Sup]];
                    DownCtrlPost=[DownCtrlPost;[Mdo Sdo]]; 
                    
                    try
                    lif=dir;
                    lle=length(lif);
                    for k=1:lle
                        try    
                        eval(['load  ',lif(k).name,'  Res'])
                        Res;
                        end
                    end
                   
                    
                    Res1=Res;
                    catch
                         load DataMCLFP
                    load Spikes
                    Res1=PatchCellProperties(Y-X(1),tps,spikes2,DebutUp,FinUp,1);
                    end
                    
                    close all
                    
                    end
                    
                    try
                    eval(['cd(''',filename,''')'])
                    cd Ctrl
                    eval(['cd(''',listdir(i).name,'/DataSpont'')'])
                    cd pre
                    
                    load UpDown
                    
                    [Mup,Sup,Eup]=MeanDifNan(FinUp-DebutUp);
                    [Mdo,Sdo,Edo]=MeanDifNan(DebutUp(2:end)-FinUp(1:end-1));
                    
                    UpCtrlPre=[UpCtrlPre;[Mup Sup]];
                    DownCtrlPre=[DownCtrlPre;[Mdo Sdo]];  
                    
                    try
                    lif=dir;
                    lle=length(lif);
                    for k=1:lle
                        try    
                        eval(['load  ',lif(k).name,'  Res'])
                        Res2=Res;
                        end
                    end
                    catch
                        
                    load DataMCLFP
                    load Spikes
                    
                    
                    Res2=PatchCellProperties(Y-X(1),tps,spikes2,DebutUp,FinUp,1);
                    end
                   
                    close all
                                    
                    end
                    
                    try
                        Res1;
                        Res2;
                    ResCtrlPost=[ResCtrlPost;Res1];
                    ResCtrlPre=[ResCtrlPre;Res2];
                    
                    end
%                     try
%                     eval(['cd(''',filename,''')'])
%                     cd Ctrl                    
%                     eval(['cd(''',listdir(i).name,'/DataSpont'')'])
%                     cd transition
%                     
                     clear Res1
                    clear Res2
%                     
%                     
%                     end
                    
                    

        end
end
        
 
%% -----------------------------------------------------------------------
%Effet DCPCX doKO --------------------------------------------------------
%-------------------------------------------------------------------------
 

eval(['cd(''',filename,''')'])
cd doKO
        
 
listdir=dir;

for i=1:length(listdir)

        eval(['cd(''',filename,''')'])
        cd doKO
        
        if listdir(i).isdir==1&listdir(i).name(1)~='.'

                    try
                    eval(['cd(''',filename,''')'])
                    cd doKO                        
                    eval(['cd(''',listdir(i).name,'/DataSpont'')'])
                    cd post
                    
                    load UpDown
                    [Mup,Sup,Eup]=MeanDifNan(FinUp-DebutUp);
                    [Mdo,Sdo,Edo]=MeanDifNan(DebutUp(2:end)-FinUp(1:end-1));
                    
                    UpdoKOPost=[UpdoKOPost;[Mup Sup]];
                    DowndoKOPost=[DowndoKOPost;[Mdo Sdo]];   
                    
                    try
                    lif=dir;
                    lle=length(lif);
                    for k=1:lle
                        try    
                        eval(['load  ',lif(k).name,'  Res'])
                        Res1=Res;
                        end
                    end
                    catch
                        
                    load DataMCLFP
                    load Spikes
                    Res1=PatchCellProperties(Y-X(1),tps,spikes2,DebutUp,FinUp,1);
%                     ResdoKOPost=[ResdoKOPost;Res1];
                    end
                    
                    close all
                                  
                    end
                    
                    try
                    eval(['cd(''',filename,''')'])
                    cd doKO                  
                    eval(['cd(''',listdir(i).name,'/DataSpont'')'])
                    cd pre
                    
                    load UpDown
                    [Mup,Sup,Eup]=MeanDifNan(FinUp-DebutUp);
                    [Mdo,Sdo,Edo]=MeanDifNan(DebutUp(2:end)-FinUp(1:end-1));
                    
                    UpdoKOPre=[UpdoKOPre;[Mup Sup]];                   
                    DowndoKOPre=[DowndoKOPre;[Mdo Sdo]];  
                    try
                    lif=dir;
                    lle=length(lif);
                    for k=1:lle
                        try    
                        eval(['load  ',lif(k).name,'  Res'])
                        Res2=Res;
                        end
                    end
                    catch
                    load DataMCLFP
                    load Spikes
                    Res2=PatchCellProperties(Y-X(1),tps,spikes2,DebutUp,FinUp,1);
%                     ResdoKOPre=[ResdoKOPre;Res2];
                    end
                    close all
                    end
                    
                    
                    try
                        Res1;
                        Res2;
                    ResdoKOPost=[ResdoKOPost;Res1];
                    ResdoKOPre=[ResdoKOPre;Res2];
                    
                    end
                    
                    
                    clear Res1
                    clear Res2
                    
%                     try
%                     eval(['cd(''',filename,''')'])
%                     cd doKO                   
%                     eval(['cd(''',listdir(i).name,'/DataSpont'')'])
%                     cd transition
%                     
%                     end



        end
end
        
 

end

%% -----------------------------------------------------------------------
%Bilan Effets ------------------------------------------------------------
%-------------------------------------------------------------------------


l=0;
l=l+1;labels{l}='nbspk/temps';
l=l+1;labels{l}='maxAuto';
l=l+1;labels{l}='Skew';
l=l+1;labels{l}='Kurto';
l=l+1;labels{l}='Indice';
l=l+1;labels{l}='PBimod';
l=l+1;labels{l}='PUnimod';
l=l+1;labels{l}='P test unimod';
l=l+1;labels{l}='P test bimod';
l=l+1;labels{l}='Delai';
l=l+1;labels{l}='nbspkUp/DureeUpTotal';
l=l+1;labels{l}='(nbspk-nbspkUp)/DureeDownTotal';
l=l+1;labels{l}='nbupStates/temps';
l=l+1;labels{l}='DureeUp';
l=l+1;labels{l}='DureeDown';
l=l+1;labels{l}='amplUp';
l=l+1;labels{l}='DureeUpTotal';
l=l+1;labels{l}='DureeDownTotal';
l=l+1;labels{l}='percS';
l=l+1;labels{l}='percE';
l=l+1;labels{l}='percSm';
l=l+1;labels{l}='percEm';
l=l+1;labels{l}='MembPot';
l=l+1;labels{l}='PotUp';
l=l+1;labels{l}='PotDown';
l=l+1;labels{l}='AmpSpk';
l=l+1;labels{l}='AhpSpk';
l=l+1;labels{l}='FreqSO';
l=l+1;labels{l}='mSpect';
 
%----------------------------------------------
%Remove cell 3
%----------------------------------------------

% listCtrl=[1,2];
% listdoKO=[1,3,4];
% 
% %listCtrl=[1:size(ResCtrlPre,1)];
% %listdoKO=[1:size(ResCtrlPost,1)];
% 
% 
% ResCtrlPre=ResCtrlPre(listCtrl,:);
% ResCtrlPost=ResCtrlPost(listCtrl,:);
% ResdoKOPre=ResdoKOPre(listdoKO,:);
% ResdoKOPost=ResdoKOPost(listdoKO,:);
% 
% 
% UpCtrlPost=UpCtrlPost(listCtrl,:);
% UpCtrlPre=UpCtrlPre(listCtrl,:);
% 
% DownCtrlPre=DownCtrlPre(listCtrl,:);
% DownCtrlPost=DownCtrlPost(listCtrl,:);
% 
% 
% UpdoKOPost=UpdoKOPost(listdoKO,:);
% UpdoKOPre=UpdoKOPre(listdoKO,:);
% 
% DowndoKOPre=DowndoKOPre(listdoKO,:);
% DowndoKOPost=DowndoKOPost(listdoKO,:);



%----------------------------------------------




try

UCPo=floor([mean(UpCtrlPost(:,1)) std(UpCtrlPost(:,1))]*1000);
UCPe=floor([mean(UpCtrlPre(:,1)) std(UpCtrlPre(:,1))]*1000);
UKPo=floor([mean(UpdoKOPost(:,1)) std(UpdoKOPost(:,1))]*1000);
UKPe=floor([mean(UpdoKOPre(:,1)) std(UpdoKOPre(:,1))]*1000);


disp(' ')
disp(' ')
disp(' ')
disp(' ')

DCPo=floor([nanmean(DownCtrlPost(:,1)) nanstd(DownCtrlPost(:,1))]*1000);
DCPe=floor([nanmean(DownCtrlPre(:,1)) nanstd(DownCtrlPre(:,1))]*1000);
DKPo=floor([nanmean(DowndoKOPost(:,1)) nanstd(DowndoKOPost(:,1))]*1000);
DKPe=floor([nanmean(DowndoKOPre(:,1)) nanstd(DowndoKOPre(:,1))]*1000);


[h,p1]=ttest(UpCtrlPost(:,1),UpCtrlPre(:,1));
[h,p2]=ttest(UpdoKOPost(:,1),UpdoKOPre(:,1));

[h,p3]=ttest(DownCtrlPost(:,1),DownCtrlPre(:,1));
[h,p4]=ttest(DowndoKOPost(:,1),DowndoKOPre(:,1));
 
[h,p5]=ttest2(DownCtrlPost(:,1),DowndoKOPost(:,1)); 
[h,p6]=ttest2(DownCtrlPre(:,1),DowndoKOPre(:,1));

Pfinal=floor([p1,p2,p3,p4,p5,p6]'*100)/100


end

 %% -----------------------------------------------------------------------

for i=1:size(ResCtrlPre,2) 
ResCtrlPre2(:,i)=ResCtrlPre(:,i)/mean(ResCtrlPre(:,i))*100;
ResCtrlPost2(:,i)=ResCtrlPost(:,i)/mean(ResCtrlPre(:,i))*100;
end

for i=1:size(ResdoKOPre,2) 
ResdoKOPre2(:,i)=ResdoKOPre(:,i)/mean(ResdoKOPre(:,i))*100;
ResdoKOPost2(:,i)=ResdoKOPost(:,i)/mean(ResdoKOPre(:,i))*100;
end

R=[ResCtrlPre;ResCtrlPost;ResdoKOPre;ResdoKOPost];
R2=[ResCtrlPre2;ResCtrlPost2;ResdoKOPre2;ResdoKOPost2];

%listCtrl=[1:size(ResCtrlPre,1)];
%listdoKO=[1:size(ResCtrlPost,1)];


% for i=1:size(R,2)
% R(:,i)=R(:,i)/mean(R(:,i));
% end
 

 %% -----------------------------------------------------------------------
        



for n=1:size(R,2)

    
    if pourc
    A=ResCtrlPre2(:,n);
    B=ResCtrlPost2(:,n);
    C=ResdoKOPre2(:,n);
    D=ResdoKOPost2(:,n);
    else
    
    A=ResCtrlPre(:,n);
    B=ResCtrlPost(:,n);
    C=ResdoKOPre(:,n);
    D=ResdoKOPost(:,n);
    
    end
    
    [mA,sA,eA]=MeanDifNan(A);
    [mB,sB,eB]=MeanDifNan(B);
    [mC,sC,eC]=MeanDifNan(C);
    [mD,sD,eD]=MeanDifNan(D);
    try
        
    [h,p1(n)]=ttest(A,B);
    [h,p2(n)]=ttest(C,D);
    [h,p3(n)]=ttest2(A,C);
    [h,p4(n)]=ttest2(B,D);
    end
    
    
    p1=floor(p1*1000)/1000;
    p2=floor(p2*1000)/1000;
    p3=floor(p3*1000)/1000;    
    p4=floor(p4*1000)/1000;
    
   absci{1}='Ctrl';
   absci{2}='Ctrl DPCPXU';
   absci{3}='doKO';
   absci{4}='doKO DPCPXU';
    
    figure('color',[1 1 1]), hold on,
    bar([mA,mB,mC,mD],'k'),
    errorbar([mA,mB,mC,mD],[eA,eB,eC,eD],'k+'), 
    set(gca,'xtick',[1:length(absci)])
    set(gca,'xticklabel',absci)
                    
    try
        title([labels{n},';   pCtrl=',num2str(p1(n)),',  pdoKO=',num2str(p2(n)), ',  pPre=',num2str(p3(n)),',  pPost=',num2str(p4(n))])
    catch
        title(labels{n})
    end
    

 
    clear A B C D
    
end

% n=0;
% n=n+1;figure('color',[1 1 1]),
% subplot(2,2,1), hist(ResCtrlPre(:,n),50),  title(labels{n})
% subplot(2,2,2), hist(ResCtrlPost(:,n),50), title(labels{n})
% subplot(2,2,3), hist(ResdoKOPre(:,n),50), title(labels{n})
% subplot(2,2,4), hist(ResdoKOPost(:,n),50), title(labels{n})





