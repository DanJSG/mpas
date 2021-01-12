function[nSegments, nSamplesInSegment] = segmentaudio(approxBpm, nAudioSamples, Fs, timeSigNumerator, nBarsInSegment)
    
    averageIoi = 60 / approxBpm;
    nSamplesBetweenCrotchets = floor((averageIoi * Fs));
    nSamplesInBar = timeSigNumerator * nSamplesBetweenCrotchets;
    nSamplesInSegment = nSamplesInBar * nBarsInSegment;
    nSegments = ceil(nAudioSamples / nSamplesInSegment);

end
