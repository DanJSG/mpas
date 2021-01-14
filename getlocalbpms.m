function[bpms] = getlocalbpms(audio, Fs, approxBpm, timeSigNumerator)
       
    [nSegments, nSamplesInSegment] = segmentaudio(approxBpm, length(audio), Fs, timeSigNumerator, 2);
    
    bpms = zeros(length(nSegments), 1);
    for n=1:nSegments

        startSample = ((n - 1) * nSamplesInSegment) + 1;

        if n == nSegments
            endSample = length(audio);
        else
            endSample = startSample + nSamplesInSegment;
        end
        
        audioSegment = audio(startSample:endSample);
        
        segmentFlux = getspectralflux(audioSegment, Fs, 512, 0, 2048);
        segmentBpms = autocorrelationbpm(segmentFlux, 10);
        segmentBpm = pickbpm(segmentBpms);

        bpms(n, 1) = segmentBpm;

    end
       
end