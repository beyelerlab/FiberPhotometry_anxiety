function bg=getBackGroundQuick(params)

suffix = 'bg';

figureSubFolder = [params.figureFolder filesep suffix];
if ~exist(figureSubFolder,'dir'),mkdir(figureSubFolder);end

figName = [figureSubFolder filesep params.dataFileTag '-' suffix '.jpeg'];

if ~exist(figName)
    videoPath = [params.dataRoot filesep params.dataFileTag '.' params.videoExtension];
    videoInfo=getVideoInfo(params);
    v = VideoReader(videoPath);
    for i=1:10
        bg = readFrame(v);
    end
    

    bg = readFrame(v);

    
    bg = rgb2gray(bg);
    imwrite(bg,figName,'jpg');
else
    bg = imread(figName);
end
end