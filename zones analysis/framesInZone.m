function [zoneTime,outTime]=framesInZone(inZone,nZones)            
ii=find(inZone==0);
if ~isempty(ii)
    outTime=size(ii,1);inZone(ii)=[];
else
    outTime=0;
end
 
zoneTime=zeros(nZones,1);
id = unique(inZone);
n=size(id,1);
for k=1:n
    i=id(k);
    j=find(inZone==i);
    zoneTime(i)=size(j,1);
end
