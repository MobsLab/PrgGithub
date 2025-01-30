
%BilanManipesSleep2FirstExp


tr=5; 
renorm=1;
renormAll=0;
DoSuite=1;
sav=1;


cd /media/DISK_2/Data2/ICSS-Sleep/Mouse026/20120109/ICSS-Mouse-26-09012011
load AnalyseResourcesICSS Res
% if renorm
%     Nor=Res{1};
%     Res{1}=Res{1}/mean(Nor);
%     Res{2}=Res{2}/mean(Nor);
%     Nor=Res{3};
%     Res{3}=Res{3}/mean(Nor);
%     Res{4}=Res{4}/mean(Nor);
% end
Res1=Res;

try
fcd /media/DISK_1/Data1/creationData/20120207/ICSS-Mouse-29-07022012
catch
    cd /media/DISK_2/Data2/ICSS-Sleep/Mouse029/20120207
end
load AnalyseResourcesICSS Res
% if renorm
%     Nor=Res{1};
%     Res{1}=Res{1}/mean(Nor);
%     Res{2}=Res{2}/mean(Nor);
%     Nor=Res{3};
%     Res{3}=Res{3}/mean(Nor);
%     Res{4}=Res{4}/mean(Nor);
% end
Res2=Res;
% 
% try

cd /media/DISK_2/Data2/ICSS-Sleep/Mouse035/15052012/ICSS-Mouse-35-15052012
load AnalyseResourcesICSS Res
if renorm
    Nor=Res{1};
    Res{1}=Res{1}/mean(Nor);
    Res{2}=Res{2}/mean(Nor);
    Nor=Res{3};
    Res{3}=Res{3}/mean(Nor);
    Res{4}=Res{4}/mean(Nor);
end
Res3=Res;


% fcd /media/DISK_1/Data1/creationData/20120208/20120208am/ICSS-Mouse-29-08022012
% catch
% cd /media/DISK_2/Data2/ICSS-Sleep/Mouse029/20120208am/
% end
% 
% 
% load AnalyseResourcesICSS Res
% % if renorm
% %     Nor=Res{1};
% %     Res{1}=Res{1}/mean(Nor);
% %     Res{2}=Res{2}/mean(Nor);
% %     Nor=Res{3};
% %     Res{3}=Res{3}/mean(Nor);
% %     Res{4}=Res{4}/mean(Nor);
% % end
% Res3=Res;
% 
% try
% fcd /media/DISK_1/Data1/creationData/20120208/20120208pm/ICSS-Mouse-29-08022012
% catch
% cd /media/DISK_2/Data2/ICSS-Sleep/Mouse029/20120208pm/
% end
% 
% load AnalyseResourcesICSS Res
% 
% % if renorm
% % Res{1}=Res{1}/mean(Res{1});
% % Res{2}=Res{2}/mean(Res{1});
% % Res{3}=Res{3}/mean(Res{3});
% % Res{4}=Res{4}/mean(Res{3});
% % end
% Res4=Res;


%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------

tr11=min(tr,length(Res1{1}));
tr12=min(tr,length(Res1{2}));
tr13=min(tr,length(Res1{3}));
tr14=min(tr,length(Res1{4}));

tr21=min(tr,length(Res2{1}));
tr22=min(tr,length(Res2{2}));
tr23=min(tr,length(Res2{3}));
tr24=min(tr,length(Res2{4}));

tr31=min(tr,length(Res3{1}));
tr32=min(tr,length(Res3{2}));
tr33=min(tr,length(Res3{3}));
tr34=min(tr,length(Res3{4}));


if renorm
    
    Bs=[Res1{1}/mean(Res1{1});Res2{1}/mean(Res2{1});Res3{1}/mean(Res3{1})];
    As=[Res1{2}/mean(Res1{1});Res2{2}/mean(Res2{1});Res3{2}/mean(Res3{1})];

    Bl=[Res1{3}/mean(Res1{3});Res2{3}/mean(Res2{3});Res3{3}/mean(Res3{3})];
    Al=[Res1{4}/mean(Res1{3});Res2{4}/mean(Res2{3});Res3{4}/mean(Res3{3})];
    
    BsM=[mean(Res1{1});mean(Res2{1});mean(Res3{1})];
    AsM=[mean(Res1{2});mean(Res2{2});mean(Res3{2})];

    BlM=[mean(Res1{3});mean(Res2{3});mean(Res3{3})];
    AlM=[mean(Res1{4});mean(Res2{4});mean(Res3{4})];
    



    if renormAll

            Bsi=[Res1{1}(1:tr11)/mean(Res1{1}(1:tr11));Res2{1}(1:tr21)/mean(Res2{1}(1:tr21));Res3{1}(1:tr31)/mean(Res3{1}(1:tr31))];
            Asi=[Res1{2}(1:tr21)/mean(Res1{1}(1:tr11));Res2{2}(1:tr22)/mean(Res2{1}(1:tr21));Res3{2}(1:tr32)/mean(Res3{1}(1:tr31))];

            Bli=[Res1{3}(1:tr13)/mean(Res1{3}(1:tr13));Res2{3}(1:tr23)/mean(Res2{3}(1:tr23));Res3{3}(1:tr33)/mean(Res3{3}(1:tr33))];
            Ali=[Res1{4}(1:tr14)/mean(Res1{3}(1:tr13));Res2{4}(1:tr24)/mean(Res2{3}(1:tr23));Res3{4}(1:tr34)/mean(Res3{3}(1:tr33))];


            BsiM=[mean(Res1{1}(1:tr11));mean(Res2{1}(1:tr21));mean(Res3{1}(1:tr31))]/mean([mean(Res1{1}(1:tr11));mean(Res2{1}(1:tr21));mean(Res3{1}(1:tr31))]);
            AsiM=[mean(Res1{2}(1:tr12));mean(Res2{2}(1:tr22));mean(Res3{2}(1:tr32))]/mean([mean(Res1{1}(1:tr11));mean(Res2{1}(1:tr21));mean(Res3{1}(1:tr31))]);

            BliM=[mean(Res1{3}(1:tr13));mean(Res2{3}(1:tr23));mean(Res3{3}(1:tr33))]/mean([mean(Res1{3}(1:tr13));mean(Res2{3}(1:tr23));mean(Res3{3}(1:tr33))]);
            AliM=[mean(Res1{4}(1:tr14));mean(Res2{4}(1:tr24));mean(Res3{4}(1:tr34))]/mean([mean(Res1{3}(1:tr13));mean(Res2{3}(1:tr23));mean(Res3{3}(1:tr33))]);

            
   else

            Bsi=[Res1{1}/mean(Res1{1});Res2{1}/mean(Res2{1});Res3{1}/mean(Res3{1})];
            Asi=[Res1{2}(1:tr21)/mean(Res1{1});Res2{2}(1:tr22)/mean(Res2{1});Res3{2}(1:tr32)/mean(Res3{1})];

            Bli=[Res1{3}/mean(Res1{3});Res2{3}/mean(Res2{3});Res3{3}/mean(Res3{3})];
            Ali=[Res1{4}(1:tr14)/mean(Res1{3});Res2{4}(1:tr24)/mean(Res2{3});Res3{4}(1:tr34)/mean(Res3{3})];   
            
            
            BsiM=[mean(Res1{1});mean(Res2{1});mean(Res3{1})]/mean([mean(Res1{1});mean(Res2{1});mean(Res3{1})]);
            AsiM=[mean(Res1{2}(1:tr12));mean(Res2{2}(1:tr22));mean(Res3{2}(1:tr32))]/mean([mean(Res1{1});mean(Res2{1});mean(Res3{1})]);

            BliM=[mean(Res1{3});mean(Res2{3});mean(Res3{3})]/mean([mean(Res1{3});mean(Res2{3});mean(Res3{3})]);
            AliM=[mean(Res1{4}(1:tr14));mean(Res2{4}(1:tr24));mean(Res3{4}(1:tr34))]/mean([mean(Res1{3});mean(Res2{3});mean(Res3{3})]);
                    

    end


else
    
    
    


        Bs=[Res1{1};Res2{1};Res3{1}];
        As=[Res1{2};Res2{2};Res3{2}];

        Bl=[Res1{3};Res2{3};Res3{3}];
        Al=[Res1{4};Res2{4};Res3{4}];

        BsM=[mean(Res1{1});mean(Res2{1});mean(Res3{1})];
        AsM=[mean(Res1{2});mean(Res2{2});mean(Res3{2})];

        BlM=[mean(Res1{3});mean(Res2{3});mean(Res3{3})];
        AlM=[mean(Res1{4});mean(Res2{4});mean(Res3{4})];




        if renormAll  
            
                    Bsi=[Res1{1}(1:tr11);Res2{1}(1:tr21);Res3{1}(1:tr31)];
                    Asi=[Res1{2}(1:tr12);Res2{2}(1:tr22);Res3{2}(1:tr32)];

                    Bli=[Res1{3}(1:tr13);Res2{3}(1:tr23);Res3{3}(1:tr33)];
                    Ali=[Res1{4}(1:tr14);Res2{4}(1:tr24);Res3{4}(1:tr34)];   

                    BsiM=[mean(Res1{1}(1:tr11));mean(Res2{1}(1:tr21));mean(Res3{1}(1:tr31))];
                    AsiM=[mean(Res1{2}(1:tr12));mean(Res2{2}(1:tr22));mean(Res3{2}(1:tr32))];

                    BliM=[mean(Res1{3}(1:tr13));mean(Res2{3}(1:tr23));mean(Res3{3}(1:tr33))];
                    AliM=[mean(Res1{4}(1:tr14));mean(Res2{4}(1:tr24));mean(Res3{4}(1:tr34))];
                    
 

        else

                     Bsi=[Res1{1};Res2{1};Res3{1}];
                    Asi=[Res1{2}(1:tr21);Res2{2}(1:tr22);Res3{2}(1:tr32)];

                    Bli=[Res1{3};Res2{3};Res3{3}];
                    Ali=[Res1{4}(1:tr14);Res2{4}(1:tr24);Res3{4}(1:tr34)]; 

                    BsiM=[mean(Res1{1});mean(Res2{1});mean(Res3{1})];
                    AsiM=[mean(Res1{2}(1:tr12));mean(Res2{2}(1:tr22));mean(Res3{2}(1:tr32))];

                    BliM=[mean(Res1{3});mean(Res2{3});mean(Res3{3})];
                    AliM=[mean(Res1{4}(1:tr14));mean(Res2{4}(1:tr24));mean(Res3{4}(1:tr34))];
                  
         end

end



%Renormalisation




if 1

figure('color',[1 1 1]), 
subplot(2,2,1), hold on
plot([1:length(Res1{1})], Res1{1},'ko-','linewidth',2)
plot([1:length(Res1{2})], Res1{2},'ro-','linewidth',2)
title('Mouse 26, 09/01/2012')
if renorm==0
ylabel('Percentage of time spent in the small Place Field')
else
    ylabel('Time spent in the small Place Field (vs control)')
end

subplot(2,2,2), hold on
plot([1:length(Res2{1})], Res2{1},'ko-','linewidth',2)
plot([1:length(Res2{2})], Res2{2},'ro-','linewidth',2)
title('Mouse 29, 07/01/2012')

subplot(2,2,3), hold on
plot([1:length(Res3{1})], Res3{1},'ko-','linewidth',2)
plot([1:length(Res3{2})], Res3{2},'ro-','linewidth',2)
title('Mouse 35, 15/05/2012')
 if renorm==0
ylabel('Percentage of time spent in the small Place Field')
else
    ylabel('Normalized time spent in the small Place Field (vs control)')

end
% 
% subplot(2,2,4), hold on
% plot([1:length(Res4{1})], Res4{1},'k','linewidth',2)
% plot([1:length(Res4{2})], Res4{2},'r','linewidth',2)
% title('Mouse 29, 08/01/2012 pm')

end


figure('color',[1 1 1]), 
subplot(2,2,1), hold on
plot([1:length(Res1{3})], Res1{3},'ko-','linewidth',2)
plot([1:length(Res1{4})], Res1{4},'ro-','linewidth',2)
title('Mouse 26, 09/01/2012')
 if renorm==0
ylabel('Percentage of time spent in the large Place Field')
else
    ylabel('Normalized time spent in the large Place Field (vs control)')
end
subplot(2,2,2), hold on
plot([1:length(Res2{3})], Res2{3},'ko-','linewidth',2)
plot([1:length(Res2{4})], Res2{4},'ro-','linewidth',2)
title('Mouse 29, 07/01/2012')


subplot(2,2,3), hold on
plot([1:length(Res3{3})], Res3{3},'ko-','linewidth',2)
plot([1:length(Res3{4})], Res3{4},'ro-','linewidth',2)
title('Mouse 35, 15/05/2012')
 if renorm==0
ylabel('Percentage of time spent in the large Place Field')
else
    ylabel('Normalized time spent in the large Place Field (vs control)')
end
% 
% subplot(2,2,4), hold on
% plot([1:length(Res4{3})], Res4{3},'k','linewidth',2)
% plot([1:length(Res4{4})], Res4{4},'r','linewidth',2)
% title('Mouse 29, 08/01/2012 pm')


% del=1;
% figure('color',[1 1 1]), hold on
% 
% plot([1:length(Res2{3})], Res2{3},'ko-','linewidth',2)
% a=length(Res2{3})+del;
% 
% plot([a+1:a+length(Res2{4})], Res2{4},'ro-','linewidth',2)
% a=a+length(Res2{3})+del;
% 
% plot([a+1:a+length(Res3{3})], Res3{3},'ko-','linewidth',2)
% a=a+length(Res3{3})+del;
% 
% plot([a+1:a+length(Res3{4})], Res3{4},'ro-','linewidth',2)
% a=a+length(Res3{4})+del;
% 
% plot([a+1:a+length(Res4{3})], Res4{3},'ko-','linewidth',2)
% a=a+length(Res4{3})+del;
% 
% plot([a+1:a+length(Res4{4})], Res4{4},'ro-','linewidth',2)
% a=a+length(Res4{4})+del;
% 
% title('Experiences Mouse 29:  07/01, 08/01 am and 08/01 pm')
% ylabel('Percentage of time spent in the Place Field')




[h,ps]=ttest2(Bs,As);
%figure('color',[1 1 1]), 
PlotErrorBar2(Bs,As)
title(['Small Area around place field, p=',num2str(floor(ps*1000)/1000)])
 if renorm==0
ylabel('Percentage of time spent in the large Place Field')
else
    ylabel('Normalized time spent in the large Place Field (vs control)')
end
set(gca,'xtick',[1 2])
set(gca,'xticklabel',{'before','after'})

[h,pl]=ttest2(Bl,Al);
%figure('color',[1 1 1]), 
PlotErrorBar2(Bl,Al)
title(['Large Area around place field, p=',num2str(floor(pl*1000)/1000)])
 if renorm==0
ylabel('Percentage of time spent in the large Place Field')
else
    ylabel('Normalized time spent in the large Place Field (vs control)')
end
set(gca,'xtick',[1 2])
set(gca,'xticklabel',{'before','after'})

if DoSuite


[h,psi]=ttest2(Bsi,Asi);
%figure('color',[1 1 1]), 
PlotErrorBar2(Bsi,Asi)
title(['Small Area around place field, ',num2str(tr),' first trials, p=',num2str(floor(psi*1000)/1000)])
 if renorm==0
ylabel('Percentage of time spent in the small Place Field')
else
    ylabel('Normalized time spent in the small Place Field (vs control)')
end
set(gca,'xtick',[1 2])
set(gca,'xticklabel',{'before','after'})

[h,pli]=ttest2(Bli,Ali);
%figure('color',[1 1 1]), 
PlotErrorBar2(Bli,Ali)
title(['Large Area around place field, ',num2str(tr),' first trials, p=',num2str(floor(pli*1000)/1000)])
 if renorm==0
ylabel('Percentage of time spent in the large Place Field')
else
    ylabel('Normalized time spent in the large Place Field (vs control)')
end
set(gca,'xtick',[1 2])
set(gca,'xticklabel',{'before','after'})

%Mean
%Bs=[Res1{3};Res2{1};Res3{1};Res4{1}];




[h,psM]=ttest2(BsM,AsM);
%figure('color',[1 1 1]), 
PlotErrorBar2(BsM,AsM)
title(['Mean effect (n=3), Small Area around place field, p=',num2str(floor(psM*1000)/1000)])
 if renorm==0
ylabel('Percentage of time spent in the small Place Field')
else
     ylabel('Normalized time spent in the small Place Field (vs control)')
end
set(gca,'xtick',[1 2])
set(gca,'xticklabel',{'before','after'})

[h,plM]=ttest2(BlM,AlM);
%figure('color',[1 1 1]), 
PlotErrorBar2(BlM,AlM)
title(['Mean effect (n=3), Large Area around place field, p=',num2str(floor(plM*1000)/1000)])
 if renorm==0
ylabel('Percentage of time spent in the large Place Field')
else
    ylabel('Normalized time spent in the large Place Field (vs control)')
end
set(gca,'xtick',[1 2])
set(gca,'xticklabel',{'before','after'})

[h,psiM]=ttest2(BsiM,AsiM);
%figure('color',[1 1 1]), 
PlotErrorBar2(BsiM,AsiM)
title(['Mean effect (n=3), Small Area around place field, ',num2str(tr),' first trials, p=',num2str(floor(psiM*1000)/1000)])
 if renorm==0
ylabel('Percentage of time spent in the small Place Field')
else
    ylabel('Normalized time spent in the small Place Field (vs control)')
end
set(gca,'xtick',[1 2])
set(gca,'xticklabel',{'before','after'})

[h,pliM]=ttest2(BliM,AliM);
%figure('color',[1 1 1]), 
PlotErrorBar2(BliM,AliM)
title(['Mean effect (n=3), Large Area around place field, ',num2str(tr),' first trials, p=',num2str(floor(pliM*1000)/1000)])
 if renorm==0
ylabel('Percentage of time spent in the large Place Field')
else
  ylabel('Normalized time spent in the large Place Field (vs control)')
end
set(gca,'xtick',[1 2])
set(gca,'xticklabel',{'before','after'})


end


if sav
    
cd /media/DISK_1/Dropbox/Kteam/ProjetSommeil/Figures/BilaManipesSleepMarch2012/figuresposterED3C

for i=1:20
    try
eval(['saveFigure(',num2str(i),',''FigureBilanSleep2FirstExpNew',num2str(i),''',''/media/DISK_1/Dropbox/Kteam/ProjetSommeil/Figures/BilaManipesSleepMarch2012/figuresposterED3C'')'])
    end
end



end
