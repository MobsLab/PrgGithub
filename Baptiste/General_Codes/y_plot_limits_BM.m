



function [y_low,y_high]=y_plot_limits_BM(Data)

y_low=min(min(Data));
y_high=max(max(Data));
y_wide=y_high-y_low;

y_low=y_low-0.1*y_wide;
y_high=y_high+0.1*y_wide;

end
















