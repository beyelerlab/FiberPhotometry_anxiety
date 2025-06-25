function experiment = processCaSignal(experiment)

pData = experiment.pData;
p = experiment.p;

%% PROCESS CALCIUM SIGNAL

CaSignal = analyzeRawCaSignal(experiment);
pData = CaSignal;
nSamples=size(pData.mainSig,1);
pData.transients2continuous =nan(nSamples,1);
pData.transients2continuous([pData.transients.loc])=1;

forceRedrawing=p.forceRedrawing;

% experiment.pData=pData;e
experiment.pData=pData;