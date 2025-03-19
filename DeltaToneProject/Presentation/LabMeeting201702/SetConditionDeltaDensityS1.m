% SetConditionDeltaDensityS1
% 20.02.2017 KJ
%
% justify which nights are selected in the dataset, in function of the
% delta waves density in the first session
%
% see 
%   QuantifNumberDelta NumberDeltaBeginning NumberDeltaBeginning2
%  


%% load
clear
load([FolderProjetDelta 'Data/NumberDeltaPerRecord.mat']) 

session_ind=1;
conditions = unique(deltanumber_res.condition);
hstep=100;
edges = 700:100:4000;

%% data
for p=1:length(deltanumber_res.path)
    all_session_duration(p) = deltanumber_res.session_time{p}(session_ind,2) - deltanumber_res.session_time{p}(session_ind,1);
end
all_session_duration = all_session_duration' /3600E4;
all_deltas_nb = cell2mat(deltanumber_res.session(:,session_ind));
all_deltas_density = all_deltas_nb ./ all_session_duration;


%% hist and fit
figure, hold on
h = histogram(all_deltas_density,edges); hold on
X = h.BinEdges(2:end)' - hstep/2;
Y = h.Values';

%fit params
fo_ = fitoptions('method','NonlinearLeastSquares','Lower',[-Inf -Inf    0]);
ok_ = isfinite(X) & isfinite(Y);
if ~all( ok_ )
    warning( 'GenerateMFile:IgnoringNansAndInfs', 'Ignoring NaNs and Infs in data.' );
end
ft_ = fittype('gauss1');
% Fit this model using new data
[cf_,goodness,output]  = fit(X(ok_),Y(ok_),ft_,fo_);


%% parameters
mu = cf_.b1;
sigma = cf_.c1;
lim_left = mu - 1.7*sigma;
lim_right = mu + 1.7*sigma;

%% plot fit
plot(cf_)
y_lim = get(gca,'YLim');
line([lim_left lim_left], y_lim,'LineStyle','--'), hold on
line([lim_right lim_right], y_lim,'LineStyle','--')
title('Histogram of Delta waves Density in Session 1')
xlabel('Deltas per hour'),ylabel(''),hold on,
set(gca, 'XTick',[500 1000 round(lim_left) 2000 2500 3000 round(lim_right) 4000])


%% print path unselected
for p=1:length(deltanumber_res.path)
    if all_deltas_density(p)<lim_left || all_deltas_density(p)>lim_right
        disp(deltanumber_res.path{p})
    end
end




