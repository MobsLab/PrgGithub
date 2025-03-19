function plot_RipStimPosPL(epoch,tRipples,StimEpoch,LinearPredTsdtot,LinearTrueTsd,BadEpoch,GoodEpoch)
    % Plotting the decoded position at each point of predicted loss
    % Blue : Good     ;      Green : Bad
    figure, 
    subplot(3,1,1), hold on, 
    plot(Range(Restrict(LinearTrueTsd, epoch),'s'), Data(Restrict(LinearTrueTsd, epoch)),'r','linewidth',2, 'DisplayName', 'True Position')
%     plot(Range(Restrict(LinearPredTsdtot, epoch),'s'), Data(Restrict(LinearPredTsdtot, epoch)),'k.','markersize',5)
    plot(Range(Restrict(LinearPredTsdtot, BadEpoch),'s'), Data(Restrict(LinearPredTsdtot, BadEpoch)),'g.','markersize',15, 'DisplayName', 'Predictions with bad PL')
    plot(Range(Restrict(LinearPredTsdtot, GoodEpoch),'s'), Data(Restrict(LinearPredTsdtot, GoodEpoch)),'b.','markersize',15, 'DisplayName', 'Predictions with good PL')
    subplot(3,1,1), xlabel('Time(s)')
    subplot(3,1,1), ylabel('Linearized Position')
    subplot(3,1,1), legend('Location','best');
    
    % Adding the ripples : high certainty along with a ripple is good sign of a
    % reactivation
%     line([Range(tRipples,'s') Range(tRipples,'s')],ylim/2,'color','b')

    % Only good
    subplot(3,1,2), hold on, 
    plot(Range(Restrict(LinearTrueTsd, epoch),'s'), Data(Restrict(LinearTrueTsd, epoch)),'r','linewidth',2)
%     plot(Range(Restrict(LinearPredTsdtot, epoch),'s'), Data(Restrict(LinearPredTsdtot, epoch)),'k.','markersize',5)
    %plot(Range(Restrict(LinearPredTsd, BadEpoch),'s'), Data(Restrict(LinearPredTsd, BadEpoch)),'g.','markersize',15)
    plot(Range(Restrict(LinearPredTsdtot, GoodEpoch),'s'), Data(Restrict(LinearPredTsdtot, GoodEpoch)),'b.','markersize',15)
%     line([Range(tRipples,'s') Range(tRipples,'s')],ylim/2,'color','b')

    % Only bad
%     subplot(3,1,3), hold on, 
%     plot(Range(Restrict(LinearTrueTsd, epoch),'s'), Data(Restrict(LinearTrueTsd, epoch)),'r','linewidth',2)
%     plot(Range(Restrict(LinearPredTsdtot, epoch),'s'), Data(Restrict(LinearPredTsdtot, epoch)),'k.','markersize',5)
%     plot(Range(Restrict(LinearPredTsdtot, BadEpoch),'s'), Data(Restrict(LinearPredTsdtot, BadEpoch)),'g.','markersize',15)
%     %plot(Range(Restrict(LinearPredTsd, GoodEpoch),'s'), Data(Restrict(LinearPredTsd, GoodEpoch)),'b.','markersize',15)
%     line([Range(tRipples,'s') Range(tRipples,'s')],ylim/2,'color','b')
end