function inZone=position2zone(xQ,yQ,zones)

nZones=size(zones,2);
inZone=zeros(size(xQ,1),nZones);
     figure()
     hold on
     plot(xQ,yQ,'marker','.', 'Color',[0.9 0.9 0.9])
for iZone=1:nZones    
    x =zones(iZone).xV;
    y =zones(iZone).yV;
    plot(x,y,'k')
    inZone(:,iZone) = inpolygon(xQ,yQ,x, y);
    idx = find(inZone(:,iZone) == 1);
    plot(xQ(idx),yQ(idx),'+')
    inZone(:,iZone) =  inZone(:,iZone).*iZone;
end
inZone=nansum(inZone,2);
end

