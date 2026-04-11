function [x_rotated,y_rotated] = rotateXY(x,y,a,xCenter,yCenter)

% rotateXY(x,y,-rotAngle,xC,yC)
v = [x';y'];% create a matrix of these points, which will be useful in future calculations
center = repmat([xCenter; yCenter], 1, length(x));% create a matrix which will be used later in calculations
theta = deg2rad(a);
R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
% do the rotation...
s = v - center;     % shift points in the plane so that the center of rotation is at the origin
so = R*s;           % apply the rotation about the origin
vo = so + center;   % shift again so the origin goes back to the desired center of rotation
% this can be done in one line as:
% vo = R*(v - center) + center
% pick out the vectors of rotated x- and y-data
x_rotated = vo(1,:)';
y_rotated = vo(2,:)';
end