function [bin,l]=PoolData(C,f,Bins,fig)


h=hist(f,Bins);


if length(find(h<2))>length(Bins)/2

    disp(' ')
    disp('error')
    % keyboard
    disp(' ')
    bin=[];
    l=[];
else

        try
            fig;
        catch
            fig=0;
        end

        smo=length(C)/length(Bins)/4;
        smo=min(smo,20);
%         smo=3;

        for i=1:length(Bins)-1
            l(i)=(Bins(i)+Bins(i+1))/2;
            Cs=smooth(C,smo);
            bin(i)=mean(Cs(f>Bins(i)&f<Bins(i+1)));

        end

        if fig==1
        figure('color',[1 1 1])
        hold on
        plot(f,C)
        plot(f,Cs,'c')
        plot(l,bin,'k','linewidth',2)
        xlim([Bins(1) Bins(end)])
        elseif fig==2
        hold on
        plot(f,C)
        hold on, plot(f,Cs,'c')
        hold on, plot(l,bin,'k','linewidth',2)
        xlim([Bins(1) Bins(end)])
        end


end

