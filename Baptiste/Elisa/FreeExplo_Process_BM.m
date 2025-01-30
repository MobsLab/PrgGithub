

FreeExplo_Path_BM

for mouse=1:8
    for sess=1:5
        
        cd(PathExplo.SD{mouse}{sess})
                
        clear Behav Params Results TTLInfo AlignedXtsd AlignedYtsd ZoneEpochAligned
        clear Vtsd Xtsd Ytsd Imdifftsd FreezeEpoch FreezeAccEpoch MovAcctsd
        load('behavResources.mat')
        load('behavResources_SB.mat')
%         
%         if and(mouse==4,sess==1)
%             disp(cd)
%             [AlignedXtsd,AlignedYtsd,ZoneEpochAligned,XYOutput] = MorphMazeToSingleShape_EmbReact_SB(Ytsd,Xtsd,Zone{1},ref,Ratio_IMAonREAL);
%         else
%             disp(cd)
%             [AlignedXtsd,AlignedYtsd,ZoneEpochAligned,XYOutput] = MorphMazeToSingleShape_EmbReact_SB(Ytsd,Xtsd,Zone{1},ref,Ratio_IMAonREAL,XYOutput);
%         end
%         
%         Behav.AlignedXtsd = AlignedXtsd;
%         Behav.AlignedYtsd = AlignedYtsd;
        Behav.Vtsd = Vtsd;
%         Behav.ZoneEpochAligned = ZoneEpochAligned;
%         Params.XYOutput = XYOutput;
%         
%         keyboard
        save('behavResources_SB.mat','Behav','Params')
        clear Behav Params
    end
end


