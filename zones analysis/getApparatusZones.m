function experiment=getApparatusZones(experiment)
vData = experiment.vData;
p=experiment.p;
switch p.apparatus.type
    case 'EPM'
         vData.zones_cmSP=epmDesing2Zones(experiment.apparatusDesign_cmSP);   

     case 'NSFT'
         vData.zones_cmSP=oftDesing2Zones(experiment.apparatusDesign_cmSP,p.apparatusCenterZoneSize_propOfTotalArea);    
     case 'HOMECAGE-FD'
         
         %drop center opject for zone definition
         experiment_tmp = experiment;
         experiment_tmp.apparatusDesign_cm.x(end)=[]; 
         experiment_tmp.apparatusDesign_cm.y(end)=[]; 
         experiment_tmp.apparatusDesign_cmSP.x(end)=[]; 
         experiment_tmp.apparatusDesign_cmSP.y(end)=[]; 
         
%          From 20190715, we decided to use 50%/50% Area ratio between center and border, so we use the OFT funciton who does the same now.
%          vData.zones_cmSP=nsftDesing2Zones(experiment_tmp.apparatusDesign_cmSP,p.apparatusZoningRatio);               
        vData.zones_cmSP=homeCageDesing2Zones(experiment.apparatusDesign_cmSP,p.apparatusCenterZoneSize_propOfTotalArea);    


    case 'Fear'         
        vData.zones_cmSP=oftDesing2Zones(experiment.apparatusDesign_cmSP,p.apparatusCenterZoneSize_propOfTotalArea);    

     case 'OFT'
         vData.zones_cmSP=oftDesing2Zones(experiment.apparatusDesign_cmSP,p.apparatusCenterZoneSize_propOfTotalArea);    
      case 'RTPP'
         vData.zones_cmSP=rtppDesing2Zones(experiment.apparatusDesign_cmSP,vData);    
         
     case '4SPACES'
         vData.zones_cmSP=fourspacesDesing2Zones(experiment.apparatusDesign_cmSP,vData);    
                 
     case 'SI'
         vData.zones_cmSP=socialDesing2Zones(experiment.apparatusDesign_cmSP,p.socialDistance_cm);       
         
     case 'TASTE'
         switch p.zoningMethod
             case 'port'
                   vData.zones_cmSP=tasteFourPortsDesing2Zones(experiment.apparatusDesign_cmSP,p.tasteDistance_cm);       
             case 'quadrant'
                  vData.zones_cmSP=quandrants2Zones(experiment.apparatusDesign_cmSP);
         end
         
    case 'ThreeChambers'
         vData.zones_cmSP=threeChambersDesing2Zones(experiment.apparatusDesign_cmSP);           
         
         
end
experiment.vData=vData;
end