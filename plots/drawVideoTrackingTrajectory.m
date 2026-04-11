function drawVideoTrackingTrajectory(params,x,y)

suffix = 'trace';

figureSubFolder = [params.figureFolder filesep suffix];
if ~exist(figureSubFolder,'dir'),mkdir(figureSubFolder);end

% figName = [figureSubFolder filesep params.dataFileTag '-' suffix '.eps'];
figName = [figureSubFolder filesep params.dataFileTag '-' suffix '.jpeg'];

if ~exist(figName,'file') || params.forceRedrawing
%     bg=getBackGroundQuick(params);
    f=figure('name',params.dataFileTag,'Position',[20 20 800 800]);
    hold on
%     colormap(gray(1024));
%     imagesc(bg);
    plot(x,y,'color',[1 0 0])
    axis off
    axis equal
    set(gca,'Ydir','reverse')
%     sMax = max(size(bg));
%     xlim([0 sMax]);ylim([0 sMax]);
    % print(f,figName,'-deps');
    print(f,figName,'-djpeg');
    close(f);
end
end