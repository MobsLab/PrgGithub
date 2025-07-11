% FigureControlBehaviorICSSsleep

cd /media/HardBackUp/DataSauvegarde/Mouse029/20120208pm
cd /media/HardBackUp/DataSauvegarde/Mouse029/20120208pm
cd /media/HardBackUp/DataSauvegarde/Mouse029/20120203/ICSS-Mouse-29-03022012


% cd /media/HardBackUp/DataSauvegarde/Mouse015/15062011/ICSS-Mouse-15-15062011
% Res1=AnalysisQuantifExploJan2012(2,[16:23],[24:32],'positions','s','immobility','y','speed',15);
% Res2=AnalysisQuantifExploJan2012(1,[1:8],[9:16],'positions','s','immobility','y','speed',15);
% 
% Resa1=AnalysisQuantifExploJan2012(1,[1:8],[9:16],'positions','s','immobility','y','speed',15);close all
% Resa2=AnalysisQuantifExploJan2012(2,[1:8],[9:16],'positions','s','immobility','y','speed',15);close all
% Resb1=AnalysisQuantifExploJan2012(1,[1:8],[17:23],'positions','s','immobility','y','speed',15);close all
% Resb2=AnalysisQuantifExploJan2012(2,[1:8],[17:23],'positions','s','immobility','y','speed',15);close all
% Resc1=AnalysisQuantifExploJan2012(1,[1:8],[25:32],'positions','s','immobility','y','speed',15);close all
% Resc2=AnalysisQuantifExploJan2012(2,[1:8],[25:32],'positions','s','immobility','y','speed',15);close all
% 
% PlotErrorBar4(Resa1{3},Resa1{4},Resb1{4},Resc1{4})
% PlotErrorBar4(Resa2{3},Resa2{4},Resb2{4},Resc2{4})
% % 
% ResCtrl1=AnalysisQuantifExploJan2012(1,[9:16],[17:24],'positions','s','immobility','y','speed',15);
% ResCtrl2=AnalysisQuantifExploJan2012(2,[9:16],[17:24],'positions','s','immobility','y','speed',15);





try
    
    load DataFigureControlBehaviorICSSsleep
    
catch
    

                    load SpikeData

                    load behavResources

                    listQuantif=find(diff(Start(QuantifExploEpoch,'s'))>200);
                    disp(' ')
                    disp(num2str(listQuantif))
                    disp(num2str(length(Start(QuantifExploEpoch,'s'))))
                    disp(' ')
                    namePos'
                    disp(' ')


                    try
                            load PlaceCells
                    end


                    if 0
                        try
                            load PlaceCells

                        catch

                            try
                                load Celltypes
                                
                                a=a+1; [C,B]=CrossCorr(Range(S{a}),Range(S{a}),1,100); C(B==0)=0; figure, plot(B,C)
                                Celltypes(a)=1;
                                
                                listOK=find(Celltypes==1);
                            catch
                                listOK=[1:length(S)];
                            end


                        for i=listOK
                        try
                        PlaceField(Restrict(S{i},Epoch),Restrict(X,Epoch),Restrict(Y,Epoch));title(num2str(i))
                        end
                        end

                        disp('PlaceCells=[')
                        dsfdfb
                        %PlaceCells=[35 32 33 26 29 23 19 17 11 6 2];

                        end
                    end




                    clear Res

                    load SpikeData
                    for i=1:length(S)
                    try
                    % close all, Res{i}=AnalysisQuantifExploJan2012(1,[9:24],[25:32],'Neuron',[i 1 2],'positions','n','immobility','y','speed',20);
                    close all, Res{i}=AnalysisQuantifExploJan2012(1,[1:8],[9:24],'Neuron',[i 1 2],'positions','n','immobility','y','speed',20);
                    catch
                    Res{i}={[],[]};
                    end
                    end



end



close all

if 0
Res1=[];
Res2=[];
a=1;
for i=1:length(S)
try
A=Res{i};
Res1=[Res1; A{1}];
Res2=[Res2; A{2}];
[h,p(a)]=ttest2(A{1},A{2});
a=a+1;
end

end
PlotErrorBar2(Res1,Res2)
ptot=length(find(p<0.05))/length(p)*100


end


clear ppl

Res1pl=[];
Res2pl=[];
a=1;
for i=PlaceCells
try
A=Res{i};
Res1pl=[Res1pl; A{1}];
Res2pl=[Res2pl; A{2}];
[h,ppl(a)]=ttest2(A{1},A{2});
PlotErrorBar2(A{1},A{2}), title([num2str(i),'  ', cellnames{PlaceCells(a)}, ', p=',num2str(ppl(a))])
a=a+1;

end

end

PlotErrorBar2(Res1pl,Res2pl)
[h,pplTot]=ttest2(Res1pl,Res2pl);
title(['Occupation Control Sessions, p=',num2str(pplTot)])
  set(gca,'xtick',[1,2])
    set(gca,'xticklabel',{'Pre','Post'})
    
pPlaceCells=length(find(ppl<0.05))/length(ppl)*100


PlotErrorBar2(Res1pl/mean(Res1pl),Res2pl/mean(Res1pl))
title(['Occupation Control Sessions, p=',num2str(pplTot)])
  set(gca,'xtick',[1,2])
    set(gca,'xticklabel',{'Pre','Post'})



try


load Celltypes Celltypes

clear ppyr

Res1pyr=[];
Res2pyr=[];
a=1;
for i=find(Celltypes==1)'
 try
A=Res{i};
Res1pyr=[Res1pyr; A{1}];
Res2pyr=[Res2pyr; A{2}];
[h,ppyr(a)]=ttest2(A{1},A{2});
a=a+1;
 end
end

PlotErrorBar2(Res1pyr,Res2pyr)

pPyr=length(find(ppyr<0.05)/length(ppyr)*100)


clear pint
Res1int=[];
Res2int=[];
a=1;
for i=find(Celltypes==0)'
try
A=Res{i};
Res1int=[Res1int; A{1}];
Res2int=[Res2int; A{2}];
[h,pint(i)]=ttest2(A{1},A{2});
a=a+1;
end
end

pInt=length(find(pint<0.05)/length(pint)*100)

end


save PlaceCells PlaceCells
save DataFigureControlBehaviorICSSsleep



% 
% PlaceCells=[35 32 33 26 29 23 19 17 11 6 2];
% for i=PlaceCells
% try
% A=Res{i};
% [h,p(i)]=ttest2(A{1},A{2});
% end
% end
% pPlaceCells=length(find(p<0.05)/length(p)*100)
% 
% Res1=[];
% Res2=[];
% for i=PlaceCells
% try
% A=Res{i};
% Res1=[Res1; A{1}];
% Res2=[Res2; A{2}];
% end
% end
% PlotErrorBar2(Res1,Res2)
% Res1=[];
% Res2=[];
% for i=PlaceCells
% try
% A=Res{i};
% Res1=[Res1; A{1}];
% Res2=[Res2; A{2}];
% PlotErrorBar2(Res1,Res2), title([num2str(i),'  ', cellnames{i}])
% end
% end
% PlotErrorBar2(Res1,Res2)
% close all
% Res1=[];
% Res2=[];
% for i=PlaceCells
% try
% A=Res{i};
% Res1=[Res1; A{1}];
% Res2=[Res2; A{2}];
% [h,p]=ttest2(A{1},A{2});
% PlotErrorBar2(Res1,Res2), title([num2str(i),'  ', cellnames{i}, ', p=',num2str(p)])
% end
% end
% PlotErrorBar2(Res1,Res2)
% Res1=[];
% Res2=[];
% for i=PlaceCells
% try
% A=Res{i};
% Res1=[Res1; A{1}];
% Res2=[Res2; A{2}];
% [h,p(i)]=ttest2(A{1},A{2});
% PlotErrorBar2(Res1,Res2), title([num2str(i),'  ', cellnames{i}, ', p=',num2str(p(i))])
% end
% end
% PlotErrorBar2(Res1,Res2)
% pPlaceCells=length(find(p<0.05)/length(p)*100)
% pPlaceCells=length(find(p<0.05))/length(p)*100
% length(find(p<0.05))
% clear p
% Res1=[];
% Res2=[];
% for i=PlaceCells
% try
% A=Res{i};
% Res1=[Res1; A{1}];
% Res2=[Res2; A{2}];
% [h,p(i)]=ttest2(A{1},A{2});
% PlotErrorBar2(Res1,Res2), title([num2str(i),'  ', cellnames{i}, ', p=',num2str(p(i))])
% end
% end
% PlotErrorBar2(Res1,Res2)
% pPlaceCells=length(find(p<0.05))/length(p)*100
% find(p<0.05)
% Res1=[];
% Res2=[];
% a=1;
% for i=PlaceCells
% try
% A=Res{i};
% Res1=[Res1; A{1}];
% Res2=[Res2; A{2}];
% [h,p(a)]=ttest2(A{1},A{2});
% PlotErrorBar2(Res1,Res2), title([num2str(a),'  ', cellnames{a}, ', p=',num2str(p(a))])
% end
% a=a+1;
% end
% PlotErrorBar2(Res1,Res2)
% pPlaceCells=length(find(p<0.05))/length(p)*100
% clear p
% 
% 
% Res1=[];
% Res2=[];
% a=1;
% for i=PlaceCells
% try
% A=Res{i};
% Res1=[Res1; A{1}];
% Res2=[Res2; A{2}];
% [h,p(a)]=ttest2(A{1},A{2});
% PlotErrorBar2(Res1,Res2), title([num2str(a),'  ', cellnames{a}, ', p=',num2str(p(a))])
% end
% a=a+1;
% end
% PlotErrorBar2(Res1,Res2)
% pPlaceCells=length(find(p<0.05))/length(p)*100