function oftDesign=getOftDesign(apparatus)

x0=0;y0=0; %EPM Center

d1 = apparatus.side_cm/2;

x(1)=x0-d1;y(1)=y0-d1;
x(2)=x0+d1;y(2)=y(1);
x(3)=x(2);y(3)=y0+d1;
x(4)=x(1);y(4)=y(3);

oftDesign.x = x;
oftDesign.y = y;