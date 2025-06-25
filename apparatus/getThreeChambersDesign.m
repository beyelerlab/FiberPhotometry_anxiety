function oftDesign=getThreeChambersDesign(apparatus)

x0=0;y0=0; %EPM Center

w = apparatus.chamber_width_cm * (3/2);
h =  apparatus.chamber_height_cm / 2;


x(1)=x0-w;
y(1)=y0-h;

x(2)=x0+w;
y(2)=y(1);

x(3)=x(2);
y(3)=y0+h;

x(4)=x(1);
y(4)=y(3);

oftDesign.x = x;
oftDesign.y = y;