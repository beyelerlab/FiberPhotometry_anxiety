function bonsai_output=getVideoTrackingData(params)

% params.dataRoot = 'Z:\Fiber-Photometry\01_DATA\20180809_IC-SweetBitter_G1\20180905_TASTE';
% params.dataFileTag = 'F260';
% bonsaiPath=[params.dataRoot filesep params.dataFileTag '-bonsai.txt'];
% params.outputFolder = 'Z:\Fiber-Photometry\01_DATA\20180926_iC-SweetBitter_AllTogether\SI' ;
% params.figureFolder = [params.outputFolder filesep 'figures'];
% params.videoExtension ='avi';
% params.MouseCoordinatesCentroid = 'Nose';



bonsaiClean=[params.dataRoot filesep params.dataFileTag '-bonsaiClean.mat'];
if ~exist(bonsaiClean,'file') || params.forceGetBodyParts
    plt = params.getVideoTrackingData_plot;
    
    if plt
        f=figure();
    end
    
    
    bonsaiPath=[params.dataRoot filesep params.dataFileTag '-bonsai.txt'];
    if exist(bonsaiPath,'file')
        bonsai_output = getBonsaiData(bonsaiPath);
    else
%         bonsaiPath=[params.dataRoot filesep params.dataFileTag '-bonsai.txt'];
%         if exist(bonsaiPath,'file')
%         end
    end
    nSamples = size(bonsai_output.bodyX,1);
    flipNeeded = 0;
    
    if plt
        vidObj = VideoReader([params.dataRoot filesep params.dataFileTag '.' params.videoExtension]);
    end
    
%     i1=1999;vidObj.CurrentTime=100.00;[x0,y0,maxL0,minL0,theta0,xF0,yF0,xB0,yB0,xL0,yL0,xR0,yR0]=depackBonsaiData(bonsai_output,i1-1,flipNeeded);
    
    i1=1;[x0,y0,maxL0,minL0,theta0,xF0,yF0,xB0,yB0,xL0,yL0,xR0,yR0]=depackBonsaiData(bonsai_output,1,flipNeeded);
    
    
    for i=i1:nSamples
        if plt
            clf(f);
            hold on
            vidFrame = readFrame(vidObj);image(vidFrame);
            xlim([0 size(vidFrame,2)]);ylim([0  size(vidFrame,1)]);
        end
        
        [x,y,maxL,minL,theta,xF,yF,xB,yB,xL,yL,xR,yR]=depackBonsaiData(bonsai_output,i,flipNeeded);
        
        dC=getDistanceBetweenObjects(x0,y0,x,y);
        
        if dC>10
            [centroid_thetaDiff,centroid_rhoDiff] = cart2pol(x-x0,y-y0);
            [F_thetaDiff,F_rhoDiff] = cart2pol(xF-x,yF-y);
            if (abs(F_thetaDiff-centroid_thetaDiff)>(pi/2))
                msg = 'Walking Bckward ?';
                xTmp = xF;xF = xB; xB=xTmp;
                yTmp = yF;yF = yB; yB=yTmp;
                flipNeeded = flipNeeded+pi;
            end
        end
        
        
        dF=getDistanceBetweenObjects(xF0,yF0,xF,yF);
        dB=getDistanceBetweenObjects(xB0,yB0,xB,yB);
        dFB=getDistanceBetweenObjects(xF,yF,xB,yB);
        dFB0=getDistanceBetweenObjects(xF0,yF0,xB0,yB0);
        
        if (dF > dFB0*4/5) && (dB>dFB0*4/5)
            msg = '!!!';
            xTmp = xF;xF = xB; xB=xTmp;
            yTmp = yF;yF = yB; yB=yTmp;
            flipNeeded = flipNeeded+pi;
        else
            msg = '';
        end
        
        if plt
            plot([x xF],[y yF],'m');
            plot([x xB],[y yB],'w');
            
            t=vidObj.CurrentTime;
            %     msg = [msg sprintf('t = %2.2f, fr = %d, dF = %2.2f, dB = %2.2f, dFB = %2.2f',t,i,dF,dB,dFB)];
            msg = [msg sprintf('t = %2.2f, fr = %d, dC=%2.2f, F[%2.2f,%2.2f], B[%2.2f,%2.2f]',t,i,dC,xF,yF,xB,yB)];
%             fprintf('%s\n',msg);
            text(10,1000,msg,'color',[1 1 1])
            plot(x,y,'gx');
            pause(.001)
        end
        
        x0=x;y0=y;
        xF0=xF;yF0=yF;
        xB0=xB;yB0=yB;
        
        bonsai_output.xF(i) = xF;
        bonsai_output.yF(i) = yF;
        bonsai_output.xB(i) = xB;
        bonsai_output.yB(i) = yB;
    end
    
    bonsai_output.xF = bonsai_output.xF';
    bonsai_output.yF = bonsai_output.yF';
    bonsai_output.xB = bonsai_output.xB';
    bonsai_output.yB = bonsai_output.yB';
       
    save(bonsaiClean,'bonsai_output');
else
    load(bonsaiClean);  
end

    switch params.MouseCoordinatesCentroid
        case 'Body'
            bonsai_output.mainX=bonsai_output.bodyX;
            bonsai_output.mainY=bonsai_output.bodyY;
        case 'Nose'
            bonsai_output.mainX=bonsai_output.xF;
            bonsai_output.mainY=bonsai_output.yF;
    end
    bonsai_output = getDistance(bonsai_output);
    bonsai_output.videoInfo = getVideoInfo(params);
    bonsai_output.nSamples0 = size(bonsai_output.mouseX,1);
    bonsai_output.num0 = 1:bonsai_output.nSamples0;
    bonsai_output.num0 = bonsai_output.num0';
    if ~isfield(bonsai_output.videoInfo,'FrameRate')
        bonsai_output.videoInfo=getVideoInfo(params);    
        if ~isfield(bonsai_output.videoInfo,'FrameRate')
            framerate = 30;
        end
    else
        framerate=bonsai_output.videoInfo.FrameRate;
    end
    
    bonsai_output.t0 = (1:bonsai_output.nSamples0) / framerate;
    bonsai_output.t0  = bonsai_output.t0';
end

function [x,y,maxL,minL,theta,xF,yF,xB,yB,xL,yL,xR,yR]=depackBonsaiData(bonsai_output,i,flipNeeded)
x=bonsai_output.bodyX(i);
y=bonsai_output.bodyY(i);
maxL=bonsai_output.mouseMajorAxisLength(i);
minL=bonsai_output.mouseMinorAxisLength(i);
theta=bonsai_output.mouseAngle(i) + flipNeeded;
[xF,yF] = pol2cart(theta,maxL/2);xF=xF+x;yF=yF+y;
[xB,yB] = pol2cart(theta+pi,maxL/2);xB=xB+x;yB=yB+y;
[xL,yL] = pol2cart(theta+pi/2,minL/2);xL=xL+x;yL=yL+y;
[xR,yR] = pol2cart(theta-pi/2,minL/2);xR=xR+x;yR=yR+y;
end

function distance=getDistanceBetweenObjects(x1,y1,x2,y2)
dx = x2-x1;dy = y2-y1;distance = sqrt((dx.*dx)+(dy.*dy));
end
