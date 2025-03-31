function SubPlotUniformize(figname,rows,cols,direction,xok,yok)
% this function homogenizes rows or columns for x/y axis
if direction==1 % cols
    for i=1:cols
        for k=1:rows
            a1=subplot(cols,rows,i+(k-1)*cols);
            if  sum(get(gca,'Xlim')==[0 1])==2 & sum(get(gca,'YLim')==[0 1])==2
                xl(k,:)=[NaN,NaN];
                yl(k,:)=[NaN,NaN];
                delete(a1)
            else
                xl(k,:)=get(gca,'Xlim');
                yl(k,:)=get(gca,'Ylim');
            end
        end
        xlfin=[min(xl(:,1)),max(xl(:,2))];
        ylfin=[min(yl(:,1)),max(yl(:,2))];
        for k=1:rows
            subplot(cols,rows,i+(k-1)*cols)
            a1=subplot(cols,rows,i+(k-1)*cols);
            if  sum(get(gca,'Xlim')==[0 1])==2 & sum(get(gca,'YLim')==[0 1])==2
                delete(a1)
            else
                
                if xok,set(gca,'Xlim',xlfin), end
                if yok,set(gca,'Ylim',ylfin), end
            end
        end
    end
    
end

%% do for direction==2

end