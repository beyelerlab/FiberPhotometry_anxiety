function epmDesign=getEpmDesign(apparatus)

x0=0;y0=0; %EPM Center

d1 = apparatus.OA_cm/2; % 40
d2 =  apparatus.CA_cm/2;  %37.5
d3 =  apparatus.W_cm;   %5
d4 = d3/2;

x(1)=x0-d1;x(12)=x(1);
y(1)=y0-d4;y(2)=y(1);y(5)=y(1);y(6)=y(1);
x(2)=x0-d4;x(3)=x(2);x(10)=x(2);x(11)=x(2);
y(3)=y0-d2;y(4)=y(3);
x(4)=x(3)+d3;x(5)=x(4);x(8)=x(4);x(9)=x(4);
x(6)=x0+d1;x(7)=x(6);
y(7)=y(6)+d3;y(8)=y(7);y(11)=y(7);y(12)=y(7);
y(9)=y0+d2;y(10)=y(9);

epmDesign.x = x;
epmDesign.y = y;