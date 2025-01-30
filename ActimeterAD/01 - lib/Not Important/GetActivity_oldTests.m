%% Test #2 : look at the stability of the signal
% Compute the derivative of the signal
ggroup = conv(group, [1, 0, -1]);

% Count the number of variations
ss_m = mean(ggroup);
ss_sd = sqrt(var(ggroup));

flag_up = ggroup > ( ss_m + 0.9*ss_sd );
flag_down = ggroup < ( ss_m - 0.9*ss_sd );
changes = flag_up == flag_down;

nbOfChanges = sum(xor(changes(1:end-1), changes(2:end)));

if nbOfChanges >= 15
    state_2 = IS_AWAKE;
end