% BilanManipeFor2




tr11=min(tr,length(Res1{1}));
tr12=min(tr,length(Res1{2}));
tr13=min(tr,length(Res1{3}));
tr14=min(tr,length(Res1{4}));

tr21=min(tr,length(Res2{1}));
tr22=min(tr,length(Res2{2}));
tr23=min(tr,length(Res2{3}));
tr24=min(tr,length(Res2{4}));

if LimiTrials
for a=1:2
    for b=1:4

        eval(['Res',num2str(a),'{',num2str(b),'}=Res',num2str(a),'{',num2str(b),'}(1:tr',num2str(a),num2str(b),');'])
        
        
    end
end
end



if 0
if renorm
    Nor=Res1{1};
    Res1{1}=Res1{1}/mean(Nor);
    Res1{2}=Res1{2}/mean(Nor);
    Nor=Res1{3};
    Res1{3}=Res1{3}/mean(Nor);
    Res1{4}=Res1{4}/mean(Nor);
    
        Nor=Res2{1};
    Res2{1}=Res2{1}/mean(Nor);
    Res2{2}=Res2{2}/mean(Nor);
    Nor=Res2{3};
    Res2{3}=Res2{3}/mean(Nor);
    Res2{4}=Res2{4}/mean(Nor);
    
end
    
    
end


if renorm
    
    Bs=[Res1{1}/mean(Res1{1});Res2{1}/mean(Res2{1})];
    As=[Res1{2}/mean(Res1{1});Res2{2}/mean(Res2{1})];

    Bl=[Res1{3}/mean(Res1{3});Res2{3}/mean(Res2{3})];
    Al=[Res1{4}/mean(Res1{3});Res2{4}/mean(Res2{3})];
    
    BsM=[mean(Res1{1});mean(Res2{1})];
    AsM=[mean(Res1{2});mean(Res2{2})];

    BlM=[mean(Res1{3});mean(Res2{3})];
    AlM=[mean(Res1{4});mean(Res2{4})];
    

    if renormAll

            Bsi=[Res1{1}(1:tr11)/mean(Res1{1}(1:tr11));Res2{1}(1:tr21)/mean(Res2{1}(1:tr21))];
            Asi=[Res1{2}(1:tr12)/mean(Res1{1}(1:tr11));Res2{2}(1:tr22)/mean(Res2{1}(1:tr21))];

            Bli=[Res1{3}(1:tr13)/mean(Res1{3}(1:tr13));Res2{3}(1:tr23)/mean(Res2{3}(1:tr23))];
            Ali=[Res1{4}(1:tr14)/mean(Res1{3}(1:tr13));Res2{4}(1:tr24)/mean(Res2{3}(1:tr23))];


            BsiM=[mean(Res1{1}(1:tr11));mean(Res2{1}(1:tr21))]/mean([mean(Res1{1}(1:tr11));mean(Res2{1}(1:tr21))]);
            AsiM=[mean(Res1{2}(1:tr12));mean(Res2{2}(1:tr22))]/mean([mean(Res1{1}(1:tr11));mean(Res2{1}(1:tr21))]);

            BliM=[mean(Res1{3}(1:tr13));mean(Res2{3}(1:tr23))]/mean([mean(Res1{3}(1:tr13));mean(Res2{3}(1:tr23))]);
            AliM=[mean(Res1{4}(1:tr14));mean(Res2{4}(1:tr24))]/mean([mean(Res1{3}(1:tr13));mean(Res2{3}(1:tr23))]);

            
            else

            Bsi=[Res1{1}/mean(Res1{1});Res2{1}/mean(Res2{1})];
            Asi=[Res1{2}(1:tr)/mean(Res1{1});Res2{2}(1:tr)/mean(Res2{1})];

            Bli=[Res1{3}/mean(Res1{3});Res2{3}/mean(Res2{3})];
            Ali=[Res1{4}(1:tr)/mean(Res1{3});Res2{4}(1:tr)/mean(Res2{3})];   
            
            
            BsiM=[mean(Res1{1});mean(Res2{1})]/mean([mean(Res1{1});mean(Res2{1})]);
            AsiM=[mean(Res1{2}(1:tr12));mean(Res2{2}(1:tr))]/mean([mean(Res1{1});mean(Res2{1})]);

            BliM=[mean(Res1{3});mean(Res2{3})]/mean([mean(Res1{3});mean(Res2{3})]);
            AliM=[mean(Res1{4}(1:tr14));mean(Res2{4}(1:tr24))]/mean([mean(Res1{3});mean(Res2{3})]);
                    

    end


else
    
    
    


        Bs=[Res1{1};Res2{1}];
        As=[Res1{2};Res2{2}];

        Bl=[Res1{3};Res2{3}];
        Al=[Res1{4};Res2{4}];

        BsM=[mean(Res1{1});mean(Res2{1})];
        AsM=[mean(Res1{2});mean(Res2{2})];

        BlM=[mean(Res1{3});mean(Res2{3})];
        AlM=[mean(Res1{4});mean(Res2{4})];




        if renormAll
                    Bsi=[Res1{1};Res2{1}];
                    Asi=[Res1{2}(1:tr12);Res2{2}(1:tr22)];

                    Bli=[Res1{3};Res2{3}];
                    Ali=[Res1{4}(1:tr14);Res2{4}(1:tr24)]; 

                    BsiM=[mean(Res1{1});mean(Res2{1})];
                    AsiM=[mean(Res1{2}(1:tr12));mean(Res2{2}(1:tr22))];

                    BliM=[mean(Res1{3});mean(Res2{3})];
                    AliM=[mean(Res1{4}(1:tr14));mean(Res2{4}(1:tr24))];

        else
                         


                    Bsi=[Res1{1}(1:tr11);Res2{1}(1:tr21)];
                    Asi=[Res1{2}(1:tr12);Res2{2}(1:tr22)];

                    Bli=[Res1{3}(1:tr13);Res2{3}(1:tr13)];
                    Ali=[Res1{4}(1:tr14);Res2{4}(1:tr14)];   

                    BsiM=[mean(Res1{1}(1:tr11));mean(Res2{1}(1:tr21))];
                    AsiM=[mean(Res1{2}(1:tr12));mean(Res2{2}(1:tr22))];

                    BliM=[mean(Res1{3}(1:tr13));mean(Res2{3}(1:tr23))];
                    AliM=[mean(Res1{4}(1:tr14));mean(Res2{4}(1:tr24))];
                    
                    
         end

end


%Renormalisation



if 1
if renorm
    Nor=Res1{1};
    Res1{1}=Res1{1}/mean(Nor);
    Res1{2}=Res1{2}/mean(Nor);
    Nor=Res1{3};
    Res1{3}=Res1{3}/mean(Nor);
    Res1{4}=Res1{4}/mean(Nor);
    
        Nor=Res2{1};
    Res2{1}=Res2{1}/mean(Nor);
    Res2{2}=Res2{2}/mean(Nor);
    Nor=Res2{3};
    Res2{3}=Res2{3}/mean(Nor);
    Res2{4}=Res2{4}/mean(Nor);
    
end
    
    
end

if 1

figure('color',[1 1 1]), 
subplot(2,2,1), hold on
plot([1:length(Res1{1})], Res1{1},'k','linewidth',2)
plot([1:length(Res1{2})], Res1{2},'r','linewidth',2)
title('Mouse 26, 09/01/2012')
ylabel('Percentage of time spent in the small Place Field')

subplot(2,2,2), hold on
plot([1:length(Res2{1})], Res2{1},'k','linewidth',2)
plot([1:length(Res2{2})], Res2{2},'r','linewidth',2)
title('Mouse 29, 07/01/2012')

% subplot(2,2,3), hold on
% plot([1:length(Res3{1})], Res3{1},'k','linewidth',2)
% plot([1:length(Res3{2})], Res3{2},'r','linewidth',2)
% title('Mouse 29, 08/01/2012 am')
% ylabel('Percentage of time spent in the small Place Field')
% 
% subplot(2,2,4), hold on
% plot([1:length(Res4{1})], Res4{1},'k','linewidth',2)
% plot([1:length(Res4{2})], Res4{2},'r','linewidth',2)
% title('Mouse 29, 08/01/2012 pm')

end


figure('color',[1 1 1]), 
subplot(2,2,1), hold on
plot([1:length(Res1{3})], Res1{3},'k','linewidth',2)
plot([1:length(Res1{4})], Res1{4},'r','linewidth',2)
title('Mouse 26, 09/01/2012')
ylabel('Percentage of time spent in the large Place Field')

subplot(2,2,2), hold on
plot([1:length(Res2{3})], Res2{3},'k','linewidth',2)
plot([1:length(Res2{4})], Res2{4},'r','linewidth',2)
title('Mouse 29, 07/01/2012')

% subplot(2,2,3), hold on
% plot([1:length(Res3{3})], Res3{3},'k','linewidth',2)
% plot([1:length(Res3{4})], Res3{4},'r','linewidth',2)
% title('Mouse 29, 08/01/2012 am')
% ylabel('Percentage of time spent in the large Place Field')
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
ylabel('Percentage of time spent in the Place Field')
set(gca,'xtick',[1 2])
set(gca,'xticklabel',{'before','after'})

[h,pl]=ttest2(Bl,Al);
%figure('color',[1 1 1]), 
PlotErrorBar2(Bl,Al)
title(['Large Area around place field, p=',num2str(floor(pl*1000)/1000)])
ylabel('Percentage of time spent in the Place Field')
set(gca,'xtick',[1 2])
set(gca,'xticklabel',{'before','after'})

if DoSuite


[h,psi]=ttest2(Bsi,Asi);
%figure('color',[1 1 1]), 
PlotErrorBar2(Bsi,Asi)
title(['Small Area around place field, ',num2str(tr),' first trials, p=',num2str(floor(psi*1000)/1000)])
ylabel('Percentage of time spent in the Place Field')
set(gca,'xtick',[1 2])
set(gca,'xticklabel',{'before','after'})

[h,pli]=ttest2(Bli,Ali);
%figure('color',[1 1 1]), 
PlotErrorBar2(Bli,Ali)
title(['Large Area around place field, ',num2str(tr),' first trials, p=',num2str(floor(pli*1000)/1000)])
ylabel('Percentage of time spent in the Place Field')
set(gca,'xtick',[1 2])
set(gca,'xticklabel',{'before','after'})

%Mean
%Bs=[Res1{3};Res2{1};Res3{1};Res4{1}];




[h,psM]=ttest2(BsM,AsM);
%figure('color',[1 1 1]), 
PlotErrorBar2(BsM,AsM)
title(['Mean effect (n=4), Small Area around place field, p=',num2str(floor(psM*1000)/1000)])
ylabel('Percentage of time spent in the Place Field')
set(gca,'xtick',[1 2])
set(gca,'xticklabel',{'before','after'})

[h,plM]=ttest2(BlM,AlM);
%figure('color',[1 1 1]), 
PlotErrorBar2(BlM,AlM)
title(['Mean effect (n=4), Large Area around place field, p=',num2str(floor(plM*1000)/1000)])
ylabel('Percentage of time spent in the Place Field')
set(gca,'xtick',[1 2])
set(gca,'xticklabel',{'before','after'})

[h,psiM]=ttest2(BsiM,AsiM);
%figure('color',[1 1 1]), 
PlotErrorBar2(BsiM,AsiM)
title(['Mean effect (n=4), Small Area around place field, ',num2str(tr),' first trials, p=',num2str(floor(psiM*1000)/1000)])
ylabel('Percentage of time spent in the Place Field')
set(gca,'xtick',[1 2])
set(gca,'xticklabel',{'before','after'})

[h,pliM]=ttest2(BliM,AliM);
%figure('color',[1 1 1]), 
PlotErrorBar2(BliM,AliM)
title(['Mean effect (n=4), Large Area around place field, ',num2str(tr),' first trials, p=',num2str(floor(pliM*1000)/1000)])
ylabel('Percentage of time spent in the Place Field')
set(gca,'xtick',[1 2])
set(gca,'xticklabel',{'before','after'})


end

