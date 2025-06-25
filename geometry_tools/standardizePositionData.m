function experiment = standardizePositionData(experiment)

p=experiment.p;
vData=experiment.vData;

%% standardized Experiments  (transform pix to cm, get epm design)
% standardize EPM position,size and rotation to camera
orderSTR='mark the four corners (extrimities) of the open arms (TopLeft, TopRight, BottomRight, BottomLeft)';
switch p.apparatus.type
    case 'EPM'
        vData.corners=getRectangularZone(p,'openArmsCorners',orderSTR);
        apparatusDesign_cm=getEpmDesign(p.apparatus);
    case 'NSFT'
        vData.corners=getRectangularZone(p,'corners',orderSTR);
        apparatusDesign_cm=getOftDesign(p.apparatus);
    case 'OFT'
        vData.corners=getRectangularZone(p,'corners',orderSTR);
        apparatusDesign_cm=getOftDesign(p.apparatus);
    case 'Fear'
        vData.corners=getRectangularZone(p,'corners',orderSTR);
        apparatusDesign_cm=getFearConditionningDesign(p.apparatus);
    case 'SI'
        vData.landmarksStr={'Arena Top Left','Arena Top Right','Arena Bottom Right','Arena Bottom Left','Object Center','Juvenile Center'};
        vData.landmarks=getLandmarks(p,vData.landmarksStr);
        xCorners = vData.landmarks.x(1:4);
        yCorners = vData.landmarks.y(1:4);
        [xCorners,yCorners]=reorderPointsClockwise(xCorners,yCorners);
        vData.corners.x = xCorners;
        vData.corners.y = yCorners;
        vData.Object.x = vData.landmarks.x(5);
        vData.Object.y = vData.landmarks.y(5);
        vData.Juvenile.x = vData.landmarks.x(6);
        vData.Juvenile.y = vData.landmarks.y(6);
        apparatusDesign_cm=getSocialDesign(p.apparatus);
    case 'TASTE'
        vData.landmarksStr={'Quinine','Sucrose','Nothing','Water'};
        vData.landmarks=getLandmarks(p,vData.landmarksStr);
        xCorners = vData.landmarks.x(1:4);
        yCorners = vData.landmarks.y(1:4);
        vData.corners.x = xCorners;
        vData.corners.y = yCorners;
        vData.Quinine.x = vData.landmarks.x(1);
        vData.Quinine.y = vData.landmarks.y(1);
        vData.Sucrose.x = vData.landmarks.x(2);
        vData.Sucrose.y = vData.landmarks.y(2);
        vData.Nothing.x = vData.landmarks.x(3);
        vData.Nothing.y = vData.landmarks.y(3);
        vData.Water.x = vData.landmarks.x(4);
        vData.Water.y = vData.landmarks.y(4);
        apparatusDesign_cm=getTasteFourPortsDesign(p.apparatus);
    case 'RTPP'
        vData.landmarksStr={'Arena Top Left','Arena Top Right','Arena Bottom Right','Arena Bottom Left','Separation Side1','Separation Side 2'};
        vData.landmarks=getLandmarks(p,vData.landmarksStr);
        xCorners = vData.landmarks.x(1:4);
        yCorners = vData.landmarks.y(1:4);
        [xCorners,yCorners]=reorderPointsClockwise(xCorners,yCorners);
        vData.corners.x = xCorners;
        vData.corners.y = yCorners;
        vData.SeparationSide1.x = vData.landmarks.x(5);
        vData.SeparationSide1.y = vData.landmarks.y(5);
        vData.SeparationSide2.x = vData.landmarks.x(6);
        vData.SeparationSide2.y = vData.landmarks.y(6);
        apparatusDesign_cm=getOftDesign(p.apparatus);
        
    case '4SPACES'
        vData.landmarksStr={'Arena Top Left','Arena Top Right','Arena Bottom Right','Arena Bottom Left'};
        vData.landmarks=getLandmarks_4spaces(p,vData.landmarksStr);
        xCorners = vData.landmarks.x(1:4);
        yCorners = vData.landmarks.y(1:4);
        [xCorners,yCorners]=reorderPointsClockwise(xCorners,yCorners);
        vData.corners.x = xCorners;
        vData.corners.y = yCorners;
%         vData.SeparationSide1.x = vData.landmarks.x(5);
%         vData.SeparationSide1.y = vData.landmarks.y(5);
%         vData.SeparationSide2.x = vData.landmarks.x(6);
%         vData.SeparationSide2.y = vData.landmarks.y(6);
%         vData.SeparationSide1.x = vData.landmarks.x(7);
%         vData.SeparationSide1.y = vData.landmarks.y(7);
%         vData.SeparationSide2.x = vData.landmarks.x(7);
%         vData.SeparationSide2.y = vData.landmarks.y(7);
        apparatusDesign_cm=getOftDesign(p.apparatus);
        
    case 'HOMECAGE-FD'
        vData.landmarksStr={'Cage Top Left','Cage Top Right','Cage Bottom Right','Cage Bottom Left','Food Pellet Center'};
        vData.landmarks=getLandmarks(p,vData.landmarksStr);
        xCorners = vData.landmarks.x(1:4);
        yCorners = vData.landmarks.y(1:4);
        [xCorners,yCorners]=reorderPointsClockwise(xCorners,yCorners);
        vData.corners.x = xCorners;
        vData.corners.y = yCorners;
        vData.Object.x = vData.landmarks.x(5);
        vData.Object.y = vData.landmarks.y(5);
        apparatusDesign_cm=getHomeCageDesign(p.apparatus);      
        
    case 'ThreeChambers'
        vData.landmarksStr={'Z1 Top Left','Z2 Top Left','Z3 Top Left','Z3 Top Right','Z3 Bottom Right','Z1 Bottom Left'};
        vData.landmarks=getLandmarks(p,vData.landmarksStr);
        xCorners = vData.landmarks.x([1,4,5,6]);
        yCorners = vData.landmarks.y([1,4,5,6]);
        [xCorners,yCorners]=reorderPointsClockwise(xCorners,yCorners);
        vData.corners.x = xCorners;
        vData.corners.y = yCorners;
        apparatusDesign_cm=getThreeChambersDesign(p.apparatus);             
        
end


[vData,p]=transformMouseCoordinates_pix2cmStandard(vData,p);

if isfield(p, 'apparatusNormalizationRequested')
    if p.apparatusNormalizationRequested
        switch p.apparatus.type
            case 'EPM'
                mainX=vData.mainX_cmS;
                mainY=vData.mainY_cmS;
                dA.W=p.apparatus.W_cm;
                dA.OA=p.apparatus.OA_cm; dA.OA = (dA.OA-dA.W)/2;
                dA.CA=p.apparatus.CA_cm; dA.CA=  (dA.CA-dA.W)/2;
                dM.W =p.apparatusModelForNormalization.W_cm;
                dM.OA =p.apparatusModelForNormalization.OA_cm; dM.OA = (dM.OA-dM.W)/2;
                dM.CA =p.apparatusModelForNormalization.CA_cm;dM.CA = (dM.CA-dM.W)/2;
                dF.W = dM.W/dA.W;dF.OA = dM.OA/dA.OA;dF.CA = dM.CA/dA.CA;
                dA.W=p.apparatus.W_cm;dA.OA=p.apparatus.OA_cm;dA.CA=p.apparatus.CA_cm;
                dM.W =p.apparatusModelForNormalization.W_cm;dM.OA =p.apparatusModelForNormalization.OA_cm;dM.CA =p.apparatusModelForNormalization.CA_cm;
                
                %fprintf('W:%2.2f=>%2.2f [x%2.2f]\n',dA.W,dM.W,dF.W);fprintf('OA:%2.2f=>%2.2f [x%2.2f]\n',dA.OA,dM.OA,dF.OA);fprintf('CA:%2.2f=>%2.2f [x%2.2f]\n',dA.CA,dM.CA,dF.CA);
                
                %figure()
                %subplot(2,1,1)
                %hold on
                %axis equal
                %text(20,20,sprintf('W=%2.2f O=%2.2f C=%2.2f',dA.W,dA.OA,dA.CA));
                zones=epmDesing2Zones(apparatusDesign_cm);
                %color_ = colormap(lines(5));
                xModel = mainX;yModel = mainY;
                for iZone=1:5
                    [IN]=inpolygon(mainX,mainY,zones(iZone).xV,zones(iZone).yV);
                    %plot(mainX(IN),mainY(IN),'Marker','+','color',color_(iZone,:),'LineStyle','none');
                    %plot(zones(iZone).xV,zones(iZone).yV,'m:')
                end
                
                %subplot(2,1,2)
                %hold on
                %axis equal
                %text(20,20,sprintf('W=%2.2f O=%2.2f C=%2.2f',dM.W,dM.OA,dM.CA));
                %xlim([-100 100]);ylim([-100 100])
                for iZone=1:5
                    [IN]=inpolygon(mainX,mainY,zones(iZone).xV,zones(iZone).yV);
                    switch zones(iZone).positionSTR
                        case 'EAST' % Open Arms are horizontal
                            zones(iZone).yModel = zones(iZone).yV .* dF.W;
                            yModel(IN) = mainY(IN) .* dF.W;
                            zones(iZone).xModel = zones(iZone).xV - dA.OA/2;
                            zones(iZone).xModel = zones(iZone).xModel .* dF.OA;
                            zones(iZone).xModel = zones(iZone).xModel + dM.OA/2;
                            xModel(IN) = mainX(IN) - dA.OA/2;
                            xModel(IN) = xModel(IN) .* dF.OA;
                            xModel(IN) = xModel(IN) + dM.OA/2;
                        case 'WEST' % Open Arms are horizontal
                            zones(iZone).yModel = zones(iZone).yV .* dF.W;
                            yModel(IN) = mainY(IN) .* dF.W;
                            zones(iZone).xModel = zones(iZone).xV + dA.OA/2;
                            zones(iZone).xModel = zones(iZone).xModel .* dF.OA;
                            zones(iZone).xModel = zones(iZone).xModel - dM.OA/2;
                            xModel(IN) = mainX(IN) + dA.OA/2;
                            xModel(IN) = xModel(IN) .* dF.OA;
                            xModel(IN) = xModel(IN) -dM.OA/2;
                        case 'NORTH' % Closed Arms are vertical
                            zones(iZone).xModel = zones(iZone).xV .* dF.W;
                            xModel(IN) = mainX(IN) .* dF.W;
                            zones(iZone).yModel = zones(iZone).yV + dA.CA/2;
                            zones(iZone).yModel = zones(iZone).yModel .* dF.CA;
                            zones(iZone).yModel = zones(iZone).yModel - dM.CA/2;
                            yModel(IN) = mainY(IN) + dA.CA/2;
                            yModel(IN) = yModel(IN).* dF.CA;
                            yModel(IN) = yModel(IN)  - dM.CA/2;
                        case 'SOUTH' %  Closed Arms are vertical
                            zones(iZone).xModel = zones(iZone).xV .* dF.W;
                            xModel(IN) = mainX(IN) .* dF.W;
                            zones(iZone).yModel = zones(iZone).yV - dA.CA/2;
                            zones(iZone).yModel = zones(iZone).yModel .* dF.CA;
                            zones(iZone).yModel = zones(iZone).yModel + dM.CA/2;
                            yModel(IN) = mainY(IN) - dA.CA/2;
                            yModel(IN) = yModel(IN).* dF.CA;
                            yModel(IN) = yModel(IN)  + dM.CA/2;
                        case 'CENTER'
                            zones(iZone).xModel = zones(iZone).xV .* dF.W;
                            zones(iZone).yModel = zones(iZone).yV .* dF.W;
                            xModel(IN) = mainX(IN) .* dF.W;
                            yModel(IN) = mainY(IN) .* dF.W;
                    end
                    %plot(zones(iZone).xModel,zones(iZone).yModel,'m:')
                    %plot(xModel(IN),yModel(IN),'Marker','+','color',color_(iZone,:))
                end
                
                if strcmp(p.apparatus.OA_orientation,'horizontal')
                    vData.mainX = xModel;vData.mainY = yModel;
                end
                apparatusDesign_cm=getEpmDesign(p.apparatusModelForNormalization);
                
        end
    end
end

% From cmStandard to cmStandardPositive, to match positive indices of matlab arrays used in following map constructions

[vData,apparatusDesign_cmSP]=transformCoordinates_cmStandard2cmStandardPositive(vData,apparatusDesign_cm); % cmSP : centimeter STANDARD POSITIVE

p.xMax = ceil(max(apparatusDesign_cmSP.x));
p.yMax = ceil(max(apparatusDesign_cmSP.y));

vData = getDistance_CmSP(vData);
DistanceThreshold = 0.025;
avgWindowFr = 20;
vData = getFreezing(vData, DistanceThreshold, avgWindowFr);


experiment.p = p;
experiment.vData = vData;
experiment.apparatusDesign_cm = apparatusDesign_cm;
experiment.apparatusDesign_cmSP = apparatusDesign_cmSP;


end