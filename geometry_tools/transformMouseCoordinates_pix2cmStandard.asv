function [vData,p]=transformMouseCoordinates_pix2cmStandard(vData,p)


x=vData.mainX;y=vData.mainY;
xF=vData.xF;yF=vData.yF;
xB=vData.bodyX;yB=vData.bodyY;
xA=vData.corners.x;yA=vData.corners.y;

try
    xL=vData.landmarks.x;yL=vData.landmarks.y;
end

[xACW,yACW]=reorderPointsClockwise(xA,yA);
dist_vector = get_euclidean_distance([xACW xACW(1)],[yACW yACW(1)])

[~, i] = sort(dist_vector, 'descend');
i1 = i(1);
i2 = mod(i1,size(xACW,2))+1;
% Rotation Angle

dX = abs(xACW(i1) - xACW(i2));
dY = abs(yACW(i1) - yACW(i2));



if dX>dY,mode=0;end
if dX<dY,mode=1;end

switch mode
    case 0 % dX>dY
        
        rotAngle = rad2deg(atan(dY/dX));
    case 1 % dX<dY
        beta = rad2deg(atan(dY/dX));
        rotAngle = 90+beta;
end



switch p.apparatus.type
    
    case 'EPM'
        % DetectOpenArmOrientation or superior wall if OFT, NSFT, SI, etc.
        ampX = max(xACW)-min(xACW);
        ampY = max(yACW)-min(yACW);
        
        if ampY>ampX
            p.apparatus.OA_orientation = 'vertical';
            rotAngle = rotAngle -90;
            p.apparatus.ref_pix = ampY;
        else
            p.apparatus.OA_orientation = 'horizontal';
            p.apparatus.ref_pix = ampX;
        end
        
        
    case 'RTPP'
        x1 = vData.landmarks.x(5);
        y1 = vData.landmarks.y(5);
        x2 = vData.landmarks.x(6);
        y2 = vData.landmarks.y(6);
        ampX = abs(x2-x1);
        ampY = abs(y2-y1);
        if ampY>ampX
            p.apparatus.sepWall_orientation = 'vertical';
            p.apparatus.ref_pix = ampY;
        else
            p.apparatus.sepWall_orientation = 'horizontal';
            rotAngle = rotAngle -90;
            p.apparatus.ref_pix = ampX;
        end
        
    case '4SPACES'
        
        x1 = vData.corners.x(1);
        y1 = vData.corners.y(1);
        x2 = vData.corners.x(3);
        y2 = vData.corners.y(3);
        ampX = abs(x2-x1);
        ampY = abs(y2-y1);
        p.apparatus.ref_pix = mean([ampX ampY]);
        
        
        
        
    case 'HOMECAGE-FD'
        x1 = vData.landmarks.x(1);
        y1 = vData.landmarks.y(1);
        x2 = vData.landmarks.x(2);
        y2 = vData.landmarks.y(2);
        ampX = abs(x2-x1);
        ampY = abs(y2-y1);
        p.apparatus.ref_pix = ampX;
        
    case 'Fear'
        x1 = vData.corners.x(1);
        y1 = vData.corners.y(1);
        x2 = vData.corners.x(2);
        y2 = vData.corners.y(2);
        ampX = abs(x2-x1);
        ampY = abs(y2-y1);
        p.apparatus.ref_pix = ampX;
        
    case 'NSFT'
        x1 = vData.corners.x(1);
        y1 = vData.corners.y(1);
        x2 = vData.corners.x(3);
        y2 = vData.corners.y(3);
        ampX = abs(x2-x1);
        ampY = abs(y2-y1);
        p.apparatus.ref_pix = mean([ampX ampY]);
        
        
    case 'OFT'
        x1 = vData.corners.x(1);
        y1 = vData.corners.y(1);
        x2 = vData.corners.x(3);
        y2 = vData.corners.y(3);
        ampX = abs(x2-x1);
        ampY = abs(y2-y1);
        p.apparatus.ref_pix = mean([ampX ampY]);
        
    case 'SI'
        x1 = vData.corners.x(1);
        y1 = vData.corners.y(1);
        x2 = vData.corners.x(3);
        y2 = vData.corners.y(3);
        ampX = abs(x2-x1);
        ampY = abs(y2-y1);
        p.apparatus.ref_pix = mean([ampX ampY]);
        
    case 'ThreeChambers'
        x1 = vData.corners.x(1);
        y1 = vData.corners.y(1);
        x2 = vData.corners.x(3);
        y2 = vData.corners.y(3);
        ampX = abs(x2-x1);
        ampY = abs(y2-y1);
        p.apparatus.ref_pix = mean([ampX/3 ampY/2]);
        
        
end



% figure()
% subplot(3,1,1)
% hold on;
% axis equal
% plot(x,y,'k.');
% 


% Rotation Center
xC=mean(xACW);yC=mean(yACW);

% Rotation Itself
vData.transformParams.rotAngle = rotAngle;
[x,y] = rotateXY(x,y,-rotAngle,xC,yC);
[xF,yF] = rotateXY(xF,yF,-rotAngle,xC,yC);
[xB,yB] = rotateXY(xB,yB,-rotAngle,xC,yC);
try
    [xL,yL] = rotateXY(xL',yL',-rotAngle,xC,yC);
end


% 
% subplot(3,1,2)
% hold on;
% axis equal
% plot(x,y,'k.');




% [xAR,yAR] = rotateXY(xA',yA',-rotAngle,xC,yC);
% [xAB,yAB] = rotateXY(xAR,yAR,rotAngle,xC,yC);

% figure()
% hold on
% axis off
% set(gca,'Ydir','reverse')
% bg=getBackGroundQuick(p);
% colormap(gray(1024));
% imagesc(bg);
% axis equal
% plot(vData.landmarks.x,vData.landmarks.y,'+g');
% plot(xACW,yACW,'og');
% for i=1:4
%     text(xACW(i)+10,yACW(i)+10,sprintf('%d:%2.2f,%2.2f',i,xA(i),yA(i)),'color','y');
% end
% text(10,10,sprintf('dX=%2.2f dY=%2.2f ',dX,dY),'color','c');
% plot(xC,yC,'+r');
% plot(xAR,yAR,'+r');
% for i=1:4
%     text(xAR(i)+10,yAR(i)+10,sprintf('%d:%2.2f,%2.2f',i,xAR(i),yAR(i)),'color','r');
% end
% % plot(xAB,yAB,'+y');

%Translation   % make all data center
x=x-xC;y=y-yC;
xF=xF-xC;yF=yF-yC;
xB=xB-xC;yB=yB-yC;
try
    xL=xL-xC;
    yL=yL-yC;
end
%Scaling




switch p.apparatus.type
    case 'EPM'
        p.apparatus.ref_cm = p.apparatus.OA_cm;
    case 'NSFT'
        p.apparatus.ref_cm = p.apparatus.side_cm;
    case 'HOMECAGE-FD'
        p.apparatus.ref_cm = p.apparatus.side1_cm;
    case 'Fear'
        p.apparatus.ref_cm = p.apparatus.width_cm;
    case 'OFT'
        p.apparatus.ref_cm = p.apparatus.side_cm;
    case 'SI'
        p.apparatus.ref_cm = p.apparatus.side_cm;
    case 'TASTE'
        tmp = p.apparatus.side2_cm; % 9cm
        tmp = 2 * (tmp/sqrt(2));
        p.apparatus.ref_cm = tmp;
    case 'RTPP'
        p.apparatus.ref_cm = p.apparatus.side_cm;
    case 'QUININE-SUCROSE'
        p.apparatus.ref_cm = p.apparatus.side_cm;
    case '4SPACES'
        p.apparatus.ref_cm = p.apparatus.side_cm;
    case 'ThreeChambers'
        p.apparatus.ref_cm = p.apparatus.chamber_width_cm;
        
end

coef_pix2cm = p.apparatus.ref_cm/p.apparatus.ref_pix;

x = x .* coef_pix2cm;y = y .* coef_pix2cm;
xF = xF .* coef_pix2cm;yF = yF .* coef_pix2cm;
xB = xB .* coef_pix2cm;yB = yB .* coef_pix2cm;
try
    xL = xL .* coef_pix2cm;yL = yL .* coef_pix2cm;
end

vData.mainX_cmS = x;
vData.mainY_cmS = y;
vData.bodyX_cmS = xB;
vData.bodyY_cmS = yB;
vData.xF_cmS = xF;
vData.yF_cmS = yF;
try
    vData.landmarks_cmS.x=xL';
    vData.landmarks_cmS.y=yL';
end
p.apparatus.coef_pix2cm=coef_pix2cm;

vData.transformParams.rotAngle = rotAngle;
vData.transformParams.xC = xC;
vData.transformParams.yC = yC;
vData.transformParams.xC = xC;
vData.transformParams.ref_pix = dX;
vData.transformParams.ref_cm = p.apparatus.ref_cm;
vData.transformParams.coef_pix2cm = coef_pix2cm;


% subplot(3,1,3)
% hold on;
% axis equal
% plot(x,y,'k.');
%
% disp('here')


end

