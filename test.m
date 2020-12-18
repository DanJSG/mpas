[audio, Fs] = audioread("audio\102strict.wav");

audio = monoconvert(audio);

% Store the number of samples in the file
nAudioSamples = length(audio);

% Normalise the amplitude of the signal
audio = normalize(audio, 'range', [-1, 1]);

flux = spectralflux(audio, Fs, 512, 0, 2048);
flux(flux < 0) = 0;

possibleBpms = autocorrelationbpm(flux, 2);

approxBpm = pickbpm(possibleBpms, 60, 200);

averageIoi = 60 / approxBpm;
timeSigNumerator = 4;
nSamplesBetweenCrotchets = floor((averageIoi * Fs) * (length(flux) / length(audio)));
nSamplesInBar = timeSigNumerator * nSamplesBetweenCrotchets;
nSamplesInSegment = nSamplesInBar * 2;
nSegments = ceil(length(flux) / nSamplesInSegment);

localBpms = zeros(length(nSegments), 1);
for n=1:nSegments
    
    startSample = ((n - 1) * nSamplesInSegment) + 1;
    
    if n == nSegments
        endSample = length(flux);
    else
        endSample = startSample + nSamplesInSegment;
    end
    
    fluxSegment = flux(startSample:endSample);
    if length(fluxSegment) >= 8
        segmentBpms = autocorrelationbpm(fluxSegment, 2);
    end
    
    segmentBpm = pickbpm(segmentBpms, 60, 200);
    
    disp(localBpms);
    
    localBpms(n, 1) = segmentBpm;
    
end


