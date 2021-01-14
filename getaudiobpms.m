function[bpm, localBpms] = getaudiobpms(audio, Fs, timeSigNumerator)
    
    flux = getspectralflux(audio, Fs, 512, 0, 2048);
    flux(flux < 0) = 0;

    possibleBpms = autocorrelationbpm(flux, 10);

    approxBpm = pickbpm(possibleBpms);

    localBpms = getlocalbpms(audio, Fs, approxBpm, timeSigNumerator);
       
    bpm = mean(localBpms);
    
    [nSegments, ~] = segmentaudio(bpm, length(audio), Fs, timeSigNumerator, 2);
    
%     disp("In getaudiobpms: " + nSegments);
    disp("nSegments in getaudiobpms: " + nSegments);
    disp("Approx BPM: " + approxBpm);
    disp("In getaudiobpms: " + length(localBpms));
    
    divisor = floor(length(localBpms) / nSegments);
    
    if divisor < 2
        localBpms = movmean(localBpms, 2);
        disp("Returning early in getaudiobpms: " + length(localBpms));
        return;
    end
    
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
    
    
    disp("Returning at end in getaudiobpms: " + length(localBpms));
    localBpms = newLocalBpms;
    
end