function[bpm, localBpms] = getaudiobpms(audio, Fs, timeSigNumerator)

    flux = getspectralflux(audio, Fs, 512, 0, 2048);
    flux(flux < 0) = 0;

    possibleBpms = autocorrelationbpm(flux, 10);

    approxBpm = pickbpm(possibleBpms);

    localBpms = getlocalbpms(audio, Fs, approxBpm, timeSigNumerator);
       
    bpm = mean(localBpms);
    
    [nSegments, ~] = segmentaudio(bpm, length(audio), Fs, timeSigNumerator, 2);
    
    divisor = floor(length(localBpms) / nSegments);
    
    if divisor < 2
        localBpms = movmean(localBpms, 2);
        return;
    end
    
%     disp(length(localBpms));
%     disp(nSegments);
%     disp(divisor);
    
    localBpms = movmean(localBpms, divisor);

    newLocalBpms = zeros(nSegments, 1);
    for n=1:nSegments

        startSeg = divisor * (n - 1) + 1;
        endSeg = startSeg + divisor - 1;

        if endSeg > length(localBpms)
            endSeg = length(localBpms);
        end

        newLocalBpms(n) = mean(localBpms(startSeg:endSeg));

    end
    
    localBpms = newLocalBpms;
    
end