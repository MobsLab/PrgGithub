function R=RemoveSpike(D)

A=D(1,:);
B=D(end,:);

a=(A(2)-B(2))/(A(1)-B(1));
b=A(2)-a*A(1);

R(:,1)=D(:,1); 
R(:,2)=a*D(:,1)+b;



