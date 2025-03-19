

function Cost_tot2 = cost2(x)

global TotalArray

OB_frequencies_data = TotalArray(:,1);
positions = TotalArray(:,2);
times_manip = TotalArray(:,3);
times_since_last_shock = TotalArray(:,4);
time_freezing = TotalArray(:,5);


    for t=1:length(times_manip)
        time = times_manip(t);
        time2(t) = times_manip(t);
        Learning = 1./(1+exp(-0.01*(time - 3000)));
        Learning2(t) = 1./(1+exp(-0.01*(time - 3000)));
        OBFreq_Shock(t) = (1-Learning) * ((x(1) - x(2)) *exp((-time_freezing(t) -times_since_last_shock(t))/x(3)) + x(2));
        OBFreq_Pos(t) = Learning * ((x(4) - x(5)) *positions(t) + x(5));
        OBFreq_Tot(t) = OBFreq_Shock(t) + OBFreq_Pos(t);
        Cost_MC (t) = (OB_frequencies_data(t) - OBFreq_Tot(t))^2;
        Cost_tot2 = nansum(Cost_MC);
    end
end