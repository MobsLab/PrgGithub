


Session_type={'TestPre','Cond'};
Group = 22; group = 1;

for sess=1:2
    Mouse=Drugs_Groups_UMaze_BM(Group(group));
    [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = ...
        MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),'heartrate','speed');
end

for sess=1:2
    for mouse=1:length(Mouse)
        
        Moving = thresholdIntervals(OutPutData.(Session_type{sess}).speed.tsd{mouse,1} , 2 , 'Direction' , 'Above');
        HR.(Session_type{sess})(mouse) = nanmean(Data(Restrict(OutPutData.Cond.speed.tsd{mouse,1} , Moving)));
        
    end
end

Cols = {[1 .5 .5],[.5 .5 1]};
X = [1:2.5];
Legends = {'Shock','Safe'};

figure
MakeSpreadAndBoxPlot3_SB({HR.TestPre HR.Cond},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Heart rate (Hz)')
makepretty_BM2



[p, h, stats] = signrank(HR.TestPre , HR.Cond)




