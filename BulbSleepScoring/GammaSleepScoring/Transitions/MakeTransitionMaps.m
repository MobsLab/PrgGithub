function Val=MakeTransitionMaps(Var,smooth_Theta,MatX,MatY,SWSEpoch,REMEpoch,lim,suffix)

%% This function takes a 2D map of sleep/wake state and creates a map of transition praobabilities from one state to the next

%% Inputs 
% Variable to map (can be gamma power or EMG)
% MatX and MatY, rnage of values for calculation
% lim : time to next transition to use for classification

%% Outputs
% Val{1}--> time to next tranisiont
% Val{2}--> time to previous transition
% Val{3-end} probability of tranisitionning to a different state after a
% certain number of seconds as specified by 'lim'
%

TotEpoch=intervalSet(0,max(Range(Var)));
Wake=TotEpoch-SWSEpoch-REMEpoch;
Wake=mergeCloseIntervals(Wake,3*1e4);

t=Range(Var);
%subsample data for quicker computation
t=t(1:10:end);

VarSubSample=(Restrict(Var,ts(t)));
ThetaSubSample=(Restrict(smooth_Theta,ts(t)));
vardata=log(Data(VarSubSample))-nanmean(log(Data(Restrict(Var,SWSEpoch))));
thetadata=log(Data(ThetaSubSample))-nanmean(log(Data(Restrict(smooth_Theta,SWSEpoch))));
varorig=Data(VarSubSample);    thetorig=Data(ThetaSubSample);

%% Look at time to next transition
ListTransitions=sort(unique([0;Start(SWSEpoch);Stop(SWSEpoch);Start(REMEpoch);Stop(REMEpoch);Start(Wake);Stop(Wake);max(t)]));
DisttoTrans1=[];DisttoTrans2=[];
% DisttoTrans1 --> time to next transition
% DisttoTrans2 --> time from previous tranisiont 

for l=1:length(ListTransitions)-1
    DisttoTrans1=[DisttoTrans1;abs(t(find(t>ListTransitions(l) & t<ListTransitions(l+1)))-ListTransitions(l+1))];
    DisttoTrans2=[DisttoTrans2;abs(t(find(t>ListTransitions(l) & t<ListTransitions(l+1)))-ListTransitions(l))];
end

Val=cell(1,length(lim));
for xx=1:length(MatX)-1
    
    for yy=1:length(MatY)-1
        datpoints=find(vardata<MatX(xx+1) & vardata>MatX(xx) & thetadata<MatY(yy+1) & thetadata>MatY(yy));
        datpoints(datpoints>size(DisttoTrans1,1))=[];
        if isempty(datpoints)
            for p=1:10
                Val{p}(xx,yy)=NaN;
            end
        else
            
            Val{1}(xx,yy)=nanmean(DisttoTrans1(datpoints));
            Val{2}(xx,yy)=nanmean(DisttoTrans2(datpoints));
            for j=1:length(lim)
                Val{2+j}(xx,yy)=nansum(DisttoTrans1(datpoints)>lim(j)*1e4)/length(datpoints);
            end
            
        end
    end
end

save(strcat('MapsTransitionProba',suffix,'.mat'),'Val')

end

