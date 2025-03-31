function [common_time, d1_common d2_common] = PrepareTsds(tsd1,tsd2)
%PREPARETSDS Summary of this function goes here
%   Detailed explanation goes here
data1 = Data(tsd1); % Extract data from tsd1
data2 = Data(tsd2); % Extract data from tsd2

t1 = Range(tsd1); % Extract timestamps (if 'Range' method exists)
d1 = Data(tsd1);  % Extract data

t2 = Range(tsd2);
d2 = Data(tsd2);

common_time = intersect(t1, t2); % Find common timestamps
common_time = Range(Restrict(tsd2, tsd1));
t_all = {t1, t2};
d_all = {d1, d2};

% Interpolate data to match common timestamps
for i = 1:length(t_all)
    t = t_all{i};
    d = d_all{i};
    if ~(size(t,1)==size(unique(t),1))
        [~,ind,~] = unique(t);
        t = t(ind);
        d = d(ind);
    end
    t_all{i} = t;
    d_all{i} = d;
end

t1 = t_all{1};
d1 = d_all{1};
t2 = t_all{2};
d2 = d_all{2};
d1_common = interp1(t1, d1, common_time, 'linear');
d2_common = interp1(t2, d2, common_time, 'linear');

valid_idx = ~isnan(d1_common) & ~isnan(d2_common); % Keep only valid values
d1_common = d1_common(valid_idx);
d2_common = d2_common(valid_idx);
end

