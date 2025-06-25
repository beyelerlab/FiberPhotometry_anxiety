function NormSigMap=normSigMap(SumSigMap,OccupancyMap)
NormSigMap = SumSigMap ./ OccupancyMap;  % Average Signal (deltaFF) Map base don time spent in each pixel
end