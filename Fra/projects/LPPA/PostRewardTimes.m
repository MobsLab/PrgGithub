function A = PostRewardTimes(A)

doFigures = false
A = getResource(A, 'OffRewardL');
A = getResource(A, 'OffRewardR');
A = getResource(A, 'TrialOutcome');
trialOutcome = trialOutcome{1};

A = registerResource(A, 'PostReward', 'tsdArray', {1, 1}, ...
    'postReward', ...
    ['time when the rat leaves reward site after reward']);

off_reward = ts(sort([Range(off_reward_l{1}); Range(off_reward_r{1})]));

postReward = Restrict(off_reward, trialOutcome, 'align', 'next');

if doFigures
    figure(1)
    clf
    plot(Range(off_reward, 's'), zeros(size(Range(off_reward))), 'k.');
    hold on
    plot(Range(trialOutcome, 's'), zeros(size(Range(trialOutcome))), 'go');
    plot(Range(postReward, 's'), zeros(size(Range(postReward))), 'ro');
    figure(2)
    clf
    hold on
    for i = 1:length(trialOutcome)
        plot([Range(subset(trialOutcome, i), 's'), Range(subset(postReward, i), 's')], [i i]);
        hold on
        plot(Range(subset(trialOutcome, i), 's'), i, 'go');
    end


    keyboard
end
A = saveAllResources(A);


