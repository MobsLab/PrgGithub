function [percent1,percent2]=Q_percents(data1,data2,Xctr,Yctr,loc);

        [t_end d1 N1]=size(data1);
        [t_end d1 N2]=size(data2);
        percent1=zeros(N1,1);
        percent2=zeros(N2,1);
        %For standard location, loc=4
        if loc==4
          control=repmat([Xctr,Yctr],t_end,1);
          %for data 1
          for i=1:N1
            f=data1(:,:,i)>control;
            percent1(i)=(sum(f(:,1).*f(:,2))/t_end)*100;
          end
          %for data 2
          for i=1:N2
            f=data2(:,:,i)>control;
            percent2(i)=(sum(f(:,1).*f(:,2))/t_end)*100;
          end
        end
        %For other Locations
        control_x=repmat(Xctr,t_end,1);
        control_y=repmat(Yctr,t_end,1);
        if loc==1
          for i=1:N1
            xdata_g1=data1(:,1,i);
            ydata_g1=data1(:,2,i);
            f=(xdata_g1<control_x).*(ydata_g1<control_y);
            percent1(i)=(sum(f)/t_end)*100;
          end
          for i=1:N2
            xdata_g2=data2(:,1,i);
            ydata_g2=data2(:,2,i);
            f=(xdata_g2<control_x).*(ydata_g2<control_y);
            percent2(i)=(sum(f)/t_end)*100;
          end
        end
        % new location
        if loc==2
          
          for i=1:N1
            xdata_g1=data1(:,1,i);
            ydata_g1=data1(:,2,i);
            f=(xdata_g1>control_x).*(ydata_g1<control_y);
            percent1(i)=(sum(f)/t_end)*100;
          end
          for i=1:N2
            xdata_g2=data2(:,1,i);
            ydata_g2=data2(:,2,i);
            f=(xdata_g2>control_x).*(ydata_g2<control_y);
            percent2(i)=(sum(f)/t_end)*100;
          end        
        end
        % location 3
        if loc==3
          for i=1:N1
            xdata_g1=data1(:,1,i);
            ydata_g1=data1(:,2,i);
            f=(xdata_g1<control_x).*(ydata_g1>control_y);
            percent1(i)=(sum(f)/t_end)*100;
          end
          for i=1:N2
          xdata_g2=data2(:,1,i);
          ydata_g2=data2(:,2,i);
          f=(xdata_g2<control_x).*(ydata_g2>control_y);
          percent2(i)=(sum(f)/t_end)*100;
        end
        end
        