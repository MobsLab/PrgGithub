function [tpsFirstREM, tpsFirstSWS]= FindFirstREMAfterInjection_MC(SWSEpoch, REMEpoch,Wake)

%% parameters
en_epoch_preInj = 1.4*1E8;
st_epoch_postInj = 1.65*1E8;

durtotal=max([max(End(Wake)),max(End(SWSEpoch))]);

epoch_PostInj = intervalSet(st_epoch_postInj,durtotal);

           

% SmoothThetaNew = Restrict(SmoothTheta,Epoch);
% t = Range(SmoothThetaNew);
% % beginning and end of session
% begin = t(1)/1e4;
% endin = t(end)/1e4;
% 
% begin = t(1);
% endin = t(end);
% 
% Epoch_pre = intervalSet(begin,1.3e8);
% Epoch2 = intervalSet(1.6e7,endin);


[durREMHalf2,durTREMHalf2] = DurationEpoch(and(REMEpoch,epoch_PostInj));
[durSWSHalf2,durTSWSHalf2] = DurationEpoch(and(SWSEpoch,epoch_PostInj));
[durWakeHalf2,durTWakeHalf2] = DurationEpoch(and(Wake,epoch_PostInj));


if isempty(durREMHalf2) ==1
    tpsFirstREM=End(epoch_PostInj)/1E4;
else
    idxREM=find(durREMHalf2/1E4>5);
    if isempty(idxREM)==1
        tpsFirstREM=NaN;
    else
        st=Start(and(REMEpoch,epoch_PostInj));
        tpsFirstREM=st(idxREM(1))/1E4;
    end
end
if isempty(durSWSHalf2) ==1
    tpsFirstSWS=NaN;
else
    idxSWS=find(durSWSHalf2/1E4>30);
    st2=Start(and(SWSEpoch,epoch_PostInj));
    tpsFirstSWS=st2(idxSWS(1))/1E4;
end
end

