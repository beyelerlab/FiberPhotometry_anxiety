function photometryData = detectAbnormalNegativeValuesInPhotometryRawData(photometryData)

sig = photometryData.sig;
ref = photometryData.ref;
sigNeg = sum(sig<0);
refNeg = sum(ref<0);
if sigNeg
    warning('AbnormalNegativeValuesInPhotometryRawSignalData');    
     sig=sig-min(sig);
end
if refNeg
    warning('AbnormalNegativeValuesInPhotometryRawReferenceData');       
    ref=ref-min(ref);
end

photometryData.sig=sig+0.001;
photometryData.ref=ref+0.001;