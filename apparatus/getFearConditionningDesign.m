function appDesign=getFearConditionningDesign(apparatus)

x0=0;y0=0;

w = apparatus.width_cm;
h =  apparatus.height_cm;


x(1)=x0-w;
y(1)=y0-h;

x(2)=x0+w;
y(2)=y(1);

x(3)=x(2);
y(3)=y0+h;

x(4)=x(1);
y(4)=y(3);

appDesign.x = x;
appDesign.y = y;