%%% TODO
% Claim the arrays, parameters - which are the arms in Zones, SaveFigure?

res = pwd;

% Folder and name for the resulting figure
dir_out = '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Behavior_UMaze/Mouse714/27022018/3min/';
fig_out = 'occup_by3min_M714_hab_27022018';
tit = 'by 3 min';

T=Range(Ytsd);
% f-min time slices
f=3;
% That many slices
n = floor(T(end)/(60*f*1E4));

% Create time slices
st = 0;
for i=1:1:n
    if i<n
        int{i} = intervalSet(st, i*f*60*1E4);
        Xtsd_slice{i} = Restrict(Xtsd,int{i});
        Ytsd_slice{i} = Restrict(Ytsd,int{i});
        st = i*f*60*1E4;
    elseif i==n
        e = Range(Xtsd);
        int{i} = intervalSet(st, e(end));
        Xtsd_slice{i} = Restrict(Xtsd,int{i});
        Ytsd_slice{i} = Restrict(Ytsd,int{i});
    end
end
  
% Calculate the occupancy for each time slice
for k=1:1:n
    Xtemp{k} = Data(Xtsd_slice{k}); Ytemp{k} = Data(Ytsd_slice{k}); T1{k} = Range(Ytsd_slice{k});
    a=find((~isnan(Xtemp{k}))); b=find((~isnan(Ytemp{k})));
    Xtemp{k}=Xtemp{k}(a); Ytemp{k}=Ytemp{k}(b); T1{k}=T1{k}(b);
    if not(isempty('Zone'))
            for t=1:length(Zone)
                try
                    ZoneIndices{t}=find(diag(Zone{t}(floor(Xtemp{k}*Ratio_IMAonREAL),floor(Ytemp{k}*Ratio_IMAonREAL))));
                    Xtemp2{k}=Xtemp{k}*0;
                    Xtemp2{k}(ZoneIndices{t})=1;
                    ZoneEpoch{t}=thresholdIntervals(tsd(T1{k},Xtemp2{k}),0.5,'Direction','Above');
                    Occup_slice{k}(t)=size(ZoneIndices{t},1)./size(Xtemp{k},1);
                    FreezeTime_slice{k}(t)=length(Data(Restrict(Xtsd_slice{k},and(FreezeEpoch,ZoneEpoch{t}))))./...
                        length(Data((Restrict(Xtsd_slice{k},ZoneEpoch{t}))));
                catch
                    ZoneIndices{t}=[];
                    ZoneEpoch{t}=intervalSet(0,0);
                    Occup_slice{k}(t)=0;
                    FreezeTime_slice{k}(t)=0;
                end
            end
        else
            for t=1:2
                ZoneIndices{t}=[];
                ZoneEpoch{t}=intervalSet(0,0);
                Occup_slice{k}(t)=0;
                FreezeTime_slice{k}(t)=0;
            end
    end
end


% Prepare an array to plot
for j = 1:1:n
    Occup_toplot(j,1:2) = [Occup_slice{j}(1:2)];
%     Occup_toplot(j,1:2) = [Occup_slice{j}(1) Occup_slice{j}(5)];
end

% Plot
pl_oc = bar(Occup_toplot);
pl_oc(1).FaceColor = 'red';
pl_oc(2).FaceColor = 'blue';
ylabel('% time spent');
box off
title(tit);
legend('Arm1', 'Arm2')

% Save the picture
saveas(pl_oc,[dir_out fig_out '.fig']);

cd(dir_out);
print(fig_out,'-dpng','-r0');

% close all

cd(res);