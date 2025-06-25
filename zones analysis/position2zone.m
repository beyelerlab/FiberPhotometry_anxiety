function inZone=position2zone(xQ,yQ,zones)

nZones=size(zones,2);
inZone=zeros(size(xQ,1),nZones);
%     figure()
%     hold on
for iZone=1:nZones
%     plot(zones(iZone).xV,zones(iZone).yV,'k')
    inZone(:,iZone) = inpolygon(xQ,yQ,zones(iZone).xV,zones(iZone).yV);
    %     plot(xQ( inZone(:,iZone)),yQ( inZone(:,iZone)),'+')
    inZone(:,iZone) =  inZone(:,iZone).*iZone;
end
inZone=nansum(inZone,2);
end

