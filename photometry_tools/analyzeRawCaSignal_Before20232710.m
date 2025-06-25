function Ca=analyzeRawCaSignal_Before20232710(experiment)

%% INITIALIZATION
removeFirstMinute=0;
params = experiment.p;
pData = experiment.pData;
sig = pData.sig;ref = pData.ref;
frameRate_Hz = params.HamamatsuFrameRate_Hz;
slidingWindowSize = params.deltaFF_slidingWindowWidth;



nSamples = size(sig,1);

xLookMin=pData.T(1);
xLooxMax=pData.T(end);
% xLookMin=100;xLooxMax=200;
if xLookMin>0
    iMin = int64(find(pData.T>=xLookMin,1,'first'));iMax = int64(find(pData.T<=xLooxMax,1,'last'));
end
% iMin=1;
% iMax=nSamples;

%% PROCESS BULK SIGNAL
Ca = processBulkSignal(sig,ref,frameRate_Hz,slidingWindowSize,removeFirstMinute);

Ca.nSamples0 = pData.nSamples;
Ca.t0 = pData.t0;
Ca.num0 = pData.num0;

Ca.mainSig = Ca.slidingdiffSig_fit;


lowPassTh_Hz= 0.2;
highPassTh_Hz= 6;
Ca.BandPass = filterWithNaN(Ca.mainSig,lowPassTh_Hz,highPassTh_Hz,frameRate_Hz,'bandpass');

% Ca.BandPass = filterWithNaN(Ca.mainSig,highPassTh_Hz,[],frameRate_Hz,'low');
%% Define Two MADs threshold
Ca.madBP = mad(Ca.BandPass,1);
Ca.medBP=nanmedian(Ca.BandPass);
Ca.thresholdBP = Ca.medBP+(2*Ca.madBP);

d = diff(Ca.BandPass>Ca.thresholdBP);


% f = figure();
% subplot(2,1,1)
% hold on
% plot(Ca.T,Ca.mainSig-10,'color',[0.7 0.7 0.7]);
% plot(Ca.T,Ca.BandPass ,'color','m');
% plot([Ca.T(1) Ca.T(end)],[Ca.thresholdBP Ca.thresholdBP],'k')

d = diff(Ca.BandPass>Ca.thresholdBP);
% plot(Ca.T(2:end),d+5,'b')
iOn = find(d==1);nOn = size(iOn,1);
iOff = find(d==-1);nOff = size(iOff,1);
% if iOff(1)<iOn(1),iOff(1) = [];end
% if iOn(end)>iOff(end),iOff(end) = [];end

if iOff(1)<iOn(1),iOff(1) = [];end
if iOn(end)>iOff(end),iOn(end) = [];end


nOn = size(iOn,1);

nTr = nOn;

 for iTr=1:nTr
     Tr(iTr).indices = iOn(iTr):iOff(iTr);
     idx=Tr(iTr).indices;    
     Tr(iTr).values = Ca.BandPass(idx);
    Tr(iTr).duration_idx = size(idx,2);
    [Tr(iTr).vMax,Tr(iTr).iMax] = max(Ca.BandPass(idx));     
    Tr(iTr).iMax = Tr(iTr).iMax + idx(1) - 1;
    Tr(iTr).ts=Ca.T(Tr(iTr).iMax);    
 end
 
 iMax = [Tr(:).iMax];
%  plot(Ca.T(iMax),Ca.BandPass(iMax),'*k');
 
 
 Tr2Remove = [];
 for iTr = 1:nTr-1
     iMax = Tr(iTr).iMax;
     dist2Zero = find(Ca.BandPass(iMax:end)<0,1,'first');
     dist2Next = Tr(iTr+1).iMax - iMax;
     if dist2Next<dist2Zero
         if Tr(iTr).vMax>Tr(iTr+1).vMax
              Tr2Remove = [Tr2Remove (iTr+1)];
         else
              Tr2Remove = [Tr2Remove iTr];
         end
     end
 end
 Tr(Tr2Remove)=[];
 nTr = size(Tr,2);
 
 iMax = [Tr(:).iMax];
%  plot(Ca.T(iMax),Ca.BandPass(iMax),'*b');
 
 Tr2Remove = [];
 for iTr = 1:nTr-1
     iMax = Tr(iTr).iMax;
     dist2Next = Tr(iTr+1).iMax - iMax;
     if dist2Next<10
              Tr2Remove = [Tr2Remove (iTr+1)];       
     end    
 end
 Tr(Tr2Remove)=[]; 

 iMax = [Tr(:).iMax];
%  plot(Ca.T(iMax),Ca.BandPass(iMax),'*g');



 Ca.transients = Tr;

end
 

%% Subfunctions for Bulk Signal Processing
function Ca = processBulkSignal(sig,ref,frameRate_Hz,slidingWindowSize,removeFirstMinute)
Ca=[];
%% If this has not been taken care off earlier, this has to be done to remove autobleaching period that corrupt analysis
if(removeFirstMinute), sig(1:20*60)=[];ref(1:20*60)=[];end
%% Processing Bulk Signal
Ca.nFrames = size(ref,1);
Ca.T = 1: Ca.nFrames;
Ca.T = Ca.T./ frameRate_Hz;
Ca.raw.sig = sig;
Ca.raw.ref = ref;
Ca.DFF.sig=deltaFF(sig);
Ca.DFF.ref =deltaFF(ref);


slidingDFF.sig=getSlidingDFF(sig,slidingWindowSize);
slidingDFF.ref=getSlidingDFF(ref,slidingWindowSize);
Ca.slidingDFF.sig = slidingDFF.sig;
Ca.slidingDFF.ref = slidingDFF.ref;
Ca.movmean.sig = movmean(sig,slidingWindowSize,'omitnan');
Ca.movmean.ref = movmean(ref,slidingWindowSize,'omitnan');

Ca.DFF.ref_fit = controlFit (Ca.DFF.sig,Ca.DFF.ref);
Ca.slidingDFF.ref_fit = controlFit (Ca.slidingDFF.sig,Ca.slidingDFF.ref);

Ca.diffSig = (Ca.DFF.sig - Ca.DFF.ref)*100;
Ca.diffSig_fit = (Ca.DFF.sig - Ca.DFF.ref_fit)*100;
Ca.slidingdiffSig_fit = (Ca.slidingDFF.sig - Ca.slidingDFF.ref_fit)*100;

Ca.divSig = (Ca.DFF.sig ./ Ca.DFF.ref)*100;
Ca.divSig_fit = (Ca.DFF.sig ./ Ca.DFF.ref_fit)*100;
Ca.slidingdivSig_fit = (Ca.slidingDFF.sig ./ Ca.slidingDFF.ref_fit)*100;

Ca.mainSig = Ca.slidingdiffSig_fit;
end

function fittedRef = controlFit (sig, ref)
iNanSig = isnan(sig);iNanRef = isnan(ref);
iNan = iNanSig | iNanRef;
noNanSig = sig;noNanRef = ref;
noNanSig(iNan)=[];noNanRef(iNan)=[];
reg = polyfit(noNanRef, noNanSig, 1);
a = reg(1);
b = reg(2);
fittedRef = a.*ref + b;
end
function v2=deltaFF(v)
% meanSig=mean(sig);sig = sig - meanSig;sig = sig./meanSig;
m=nanmean(v);
v2 = v - m;
v2 = v2./abs(m);
end
function v3=getSlidingDFF(v,slidingWindowSize)
movmean_v = movmean(v,slidingWindowSize,'omitnan');
% meanSig=mean(sig);sig = sig - meanSig;sig = sig./meanSig;
v2 = v - movmean_v;
v3 = v2./abs(movmean_v);
end

function s=norm01(s)
s = s-min(s);
s = s ./ max(s);
end

function filtered_Sig_withNaN = butterWorthFilterWithNaN(Sig,lowPassTh_Hz,highPassTh_Hz,frameRate_Hz,filterType)
%% Remove NaN for filtering
sig_without_NaN=Sig;iNaN=isnan(Sig);sig_without_NaN(iNaN)=[];
%% Filtering
switch filterType
    case 'low'
        fc = lowPassTh_Hz;
    case 'high'
        fc = highPassTh_Hz;
    case 'bandpass'
        fc = [lowPassTh_Hz highPassTh_Hz];
end
fs = frameRate_Hz;
[b,c] = butter(4,fc/(fs/2), filterType);
filtered_Sig_without_NaN = filtfilt(b, c, sig_without_NaN);
%% Reintroduce NaNs values into the filtered vector
j=1;
nSamples = max(size(Sig));
filtered_Sig_withNaN = nan(nSamples,1);
for i=1:nSamples
    if iNaN(i)
        filtered_Sig_withNaN(i)=nan;
    else
        filtered_Sig_withNaN(i)=filtered_Sig_without_NaN(j);
        j=j+1;
    end
    
end

end
function filtered_Sig_withNaN = matlabFilterWithNaN(Sig,lowPassTh_Hz,highPassTh_Hz,frameRate_Hz,filterType)
%% Remove NaN for filtering
sig_without_NaN=Sig;iNaN=isnan(Sig);sig_without_NaN(iNaN)=[];
%% Filtering
switch filterType
    case 'low'
        filtered_Sig_without_NaN = lowpass(sig_without_NaN,lowPassTh_Hz,frameRate_Hz);
    case 'high'
        filtered_Sig_without_NaN = highpass(sig_without_NaN,highPassTh_Hz,frameRate_Hz);
    case 'bandpass'
        filtered_Sig_without_NaN = bandpass(sig_without_NaN,[lowPassTh_Hz highPassTh_Hz],frameRate_Hz);
end
%% Reintroduce NaNs values into the filtered vector
j=1;
nSamples = max(size(Sig));
filtered_Sig_withNaN = nan(nSamples,1);
for i=1:nSamples
    if iNaN(i)
        filtered_Sig_withNaN(i)=nan;
    else
        filtered_Sig_withNaN(i)=filtered_Sig_without_NaN(j);
        j=j+1;
    end
    
end

end
function  filtered_Sig_withNaN = filterWithNaN(Sig,lowPassTh_Hz,highPassTh_Hz,frameRate_Hz,filterType)
filtered_Sig_withNaN = butterWorthFilterWithNaN(Sig,lowPassTh_Hz,highPassTh_Hz,frameRate_Hz,filterType);
% filtered_Sig_withNaN = matlabFilterWithNaN(Sig,lowPassTh_Hz,highPassTh_Hz,frameRate_Hz,filterType);
end

function drawTransientsOnTop(T,Sig,Tr,TrColor,iMin,iMax,selectionCriterion,textCriterion,colorCriterion)

nTr=size(Tr,2);
nCrit = size(selectionCriterion,2);

 maxSig = max(Sig(iMin:iMax));
 minSig = min(Sig(iMin:iMax));
 ampSig = maxSig - minSig;
 tickSize = ampSig/20;
 tickUp = maxSig;
 tickDown = tickUp - tickSize;
 txtPos = tickUp + (tickSize*5);

for iTr=1:nTr
    i1Tr = Tr(iTr).start ;
    i2Tr = Tr(iTr).start+Tr(iTr).duration_idx;
    if (i1Tr>= iMin) &&  (i2Tr<= iMax)
        color_=TrColor;
        t = T(Tr(iTr).iMax);
        for iCrit = 1:nCrit
            if selectionCriterion(iTr,iCrit)
                color_=colorCriterion(iCrit,:);
            end
        end
        plot(T(i1Tr:i2Tr),Sig(i1Tr:i2Tr),'color',color_);
        plot([t t],[tickUp tickDown],'color',color_);
    end
end



end

function Tr = extractTransientsAboveThreshold(sig,threshold,T)

thSig = sig>threshold;
Tr=[];iTr=0;preVal=0;
nSamples = max(size(sig));
nSamples=int64(nSamples);
for i=1:nSamples-1
    if thSig(i)
        if ~preVal
            iTr=iTr+1;Tr(iTr).start=i;Tr(iTr).indices=[];
        end
        Tr(iTr).indices=[Tr(iTr).indices i];
    end
    preVal=thSig(i);
end

nTr=size(Tr,2);

for iTr=1:nTr
    idx=Tr(iTr).indices;    
    Tr(iTr).duration_idx = size(idx,2);
    [Tr(iTr).vMax,Tr(iTr).iMax] = max(sig(idx));
    Tr(iTr).ts=T(Tr(iTr).iMax);
    Tr(iTr).values = sig(idx);
    Tr(iTr).iMax = Tr(iTr).iMax + idx(1) - 1;
end


end

function shortTransients = findShortTransients(Tr,durationThreshold_idx)
nTr=size(Tr,2);
shortTransients=nan(nTr,1);
for iTr=1:nTr
    %% Duration of the transient is too short
    if Tr(iTr).duration_idx<durationThreshold_idx %too short
        shortTransients(iTr) = 1;
    else
        shortTransients(iTr) = 0;
    end
end
end

function lowTransients = findLowTransients(Tr,ampThreshold)
nTr=size(Tr,2);
lowTransients=nan(nTr,1);
for iTr=1:nTr
    %% Duration of the transient is too short
    if Tr(iTr).vMax<ampThreshold %too low
        lowTransients(iTr) = 1;
    else
        lowTransients(iTr) = 0;
    end
end
end

function tooCloseTransients = findTooCloseTransients(Tr,minGapThreshold_sec)
nTr=size(Tr,2);
tooCloseTransients=nan(nTr,1);
tooCloseTransients(1)=0;
dt = diff([Tr(:).ts]);

for iTr=2:nTr
    %% Duration of the transient is too short
  if dt(iTr-1)>=minGapThreshold_sec %too close
        tooCloseTransients(iTr) = 0;
    else
        tooCloseTransients(iTr) = 1;
    end
end
end



