function[localMeanRms] = getlocaldynamics(rmsDynamics, nAudioSamples, Fs, globalBpm, timeSigNumerator)
   
    [nSegments, nSamplesInSegment] = segmentaudio(globalBpm, nAudioSamples, Fs, timeSigNumerator, 2);
    
    localMeanRms = zeros(nSegments, 1);
    for n=1:nSegments

        startSample = (n - 1) * nSamplesInSegment + 1;
        endSample = startSample + nSamplesInSegment;

        if endSample > nAudioSamples
            endSample = nAudioSamples;
        end

        startSample = floor(startSample * (length(rmsDynamics) / nAudioSamples));
        endSample = floor(endSample * (length(rmsDynamics) / nAudioSamples));

        if startSample == 0
            startSample = 1;
        end

        localMeanRms(n) = mean(rmsDynamics(startSample:endSample));

    end
    
end