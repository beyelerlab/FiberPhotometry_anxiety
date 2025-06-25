
function experiment = extractArmEntries(experiment)
z = experiment.vData.inZone;

if ~isfield(experiment.vData.videoInfo,'FrameRate')
    sfreq = 20;
else
    sfreq = experiment.vData.videoInfo.FrameRate;
end


%When animal detection was bad, we placed the animal in zone 0
% To avoid  conting zone_0 entrances we remove them
% using the prev. pos of the animal

n = size(z);
for i=1:n
    
    if ~z(i)
        if i>1, z(i) = z(i-1);end
    end
end

x = experiment.vData.mainX_cmSP;
y = experiment.vData.mainY_cmSP;

e = diff(z);e = find(e~=0)+1;n = size(e,1);
eOA = [];eCA = [];

traceLength = 80;
% c = colormap(jet(traceLength*2+1));

% f=figure();

for i=1:n   
    
    idx = e(i);
%     clf(f);
%     hold on
%     axis equal
%     xlim([0 80])
%     ylim([0 80])

%     i1 = idx-traceLength;
%     i2 = idx+traceLength;
%     for j=i1:i2
%         j
%         plot(x(j),y(j),'Marker','o','MarkerFacecolor',c(j-i1+1,:),'MarkerEdgecolor','none')
%     end
%     plot(x(idx),y(idx),'r+')
%     text(0,70,sprintf('idx=%d, t=%2.2fs, z=[%d/%d/%d]/[%d/%d]',idx,idx/sfreq,z(idx-1),z(idx),z(idx+1),z(i1),z(i2)));
%     pause
    switch z(idx)        
        case 1
            eOA= [eOA idx];
        case 2
            eCA= [eCA idx];
        case 3
            eOA= [eOA idx];
        case 4
            eCA= [eCA idx];            
    end    
end

experiment.vData.eOA.idx = eOA;
experiment.vData.eCA.idx = eCA;

experiment.vData.eOA.tps = eOA/sfreq;
experiment.vData.eCA.tps = eCA/sfreq;





