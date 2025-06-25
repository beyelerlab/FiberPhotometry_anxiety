function raster=get_raster(synch_event,timeserie,boundaries)
nTrials=length(synch_event);
raster={};
bInf=boundaries(1);bSup=boundaries(2);
for i = 1 : nTrials
    tmp = timeserie-synch_event(i);
    ii=find(tmp<bInf);tmp(ii)=[];
    ii=find(tmp>bSup);tmp(ii)=[];    
    raster{i}=tmp;
end