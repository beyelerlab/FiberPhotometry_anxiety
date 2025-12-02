function drawOccupancyMap(params,OccupancyMapFrame,xMax,yMax)

suffix = 'occupancyMap';

figureSubFolder = [params.figureFolder filesep suffix];
if ~exist(figureSubFolder,'dir'),mkdir(figureSubFolder);end

figName = [figureSubFolder filesep params.dataFileTag '-' suffix '.jpeg'];

if ~exist(figName,'file') || params.forceRedrawing
    f=figure('name',params.dataFileTag,'Position',[20 20 800 800]);
    hold on
    axis equal
    axis off
    xMax=xMax/params.MapScale_cmPerBin;yMax=yMax/params.MapScale_cmPerBin;
    xlim([0 xMax])
    ylim([0 yMax])
    set(gca,'Ydir','reverse')
    colormap([0.9 0.9 0.9; jet(2056)]);

    OccupancyMapSec = OccupancyMapFrame/params.behaviorCameraFrameRate_Hz;

    if params.OccupancyMap_sigmaGaussFilt
        ii=find(OccupancyMapSec==0);
        OccupancyMapSec(ii)=nan;
        ii = isnan(OccupancyMapSec);
        OccupancyMapSec(ii)=0;
        gaussFilt_OccupancyMapSec = imgaussfilt(OccupancyMapSec,params.OccupancyMap_sigmaGaussFilt);
        gaussFilt_OccupancyMapSec(ii)=nan;
    end

    im=imagesc(gaussFilt_OccupancyMapSec);
    
    bg=getBackGroundQuick(params);
    sMax = max(size(bg));
    colorbar();
    print(f,figName,'-djpeg');
    close(f);
end
end


