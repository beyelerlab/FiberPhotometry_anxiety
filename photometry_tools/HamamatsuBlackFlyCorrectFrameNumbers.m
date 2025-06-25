function [photometryData,videoTrackingData]=HamamatsuBlackFlyCorrectFrameNumbers(photometryData,videoTrackingData,params)

%During Summer 2018, recordings with spinView (BlackFly, FLIR) we loose
% the last second of recording to make the two video streams (Hamamatsu
% and BlackFly even in size, I remove the last second from Hamamatsu
% Camera
 
 fields = fieldnames(videoTrackingData,'-full');
 nFields=size(fields,1);
 
 Treatement = zeros(nFields,1);
 nFramesBlackFly = size(videoTrackingData.mainX,1);
 for iField = 1:nFields
     cmdSTR = sprintf('tmpSize=size(videoTrackingData.%s,1);',fields{iField});
     eval(cmdSTR);
     fieldSize{iField}=tmpSize;
     if tmpSize == nFramesBlackFly
         Treatement(iField)=1;
     end
     if tmpSize == nFramesBlackFly-1
         Treatement(iField)=2;
     end
 end

 
photometryData.sig =photometryData.sig(1:end-params.HamamatsuFrameRate_Hz);
photometryData.ref = photometryData.ref(1:end-params.HamamatsuFrameRate_Hz);
photometryData.num0 =photometryData.num0(1:end-params.HamamatsuFrameRate_Hz);
photometryData.t0= photometryData.t0(1:end-params.HamamatsuFrameRate_Hz);

nFramesHamamatsu = size(photometryData.sig,1);

if nFramesBlackFly>nFramesHamamatsu
%     x=x(1:nFramesHamamatsu);
%     y=y(1:nFramesHamamatsu);
%     d=d(1:nFramesHamamatsu);   
 for iField = 1:nFields    
     if Treatement(iField)
         cmdSTR = sprintf('videoTrackingData.%s=videoTrackingData.%s(1:nFramesHamamatsu);',fields{iField},fields{iField});
         eval(cmdSTR);
     end
 end
end

if nFramesBlackFly<nFramesHamamatsu    
%     x=[x; nan(nFramesHamamatsu-nFramesBlackFly,1)];
%     y=[y; nan(nFramesHamamatsu-nFramesBlackFly,1)];
%     d=[d; nan(nFramesHamamatsu-nFramesBlackFly,1)];
    for iField = 1:nFields
        if Treatement(iField)
            cmdSTR = sprintf('videoTrackingData.%s=[videoTrackingData.%s; nan(nFramesHamamatsu-nFramesBlackFly,1)];',fields{iField},fields{iField});
            eval(cmdSTR);
        end
 end   
end

