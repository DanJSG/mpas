[audio, Fs] = audioread("audio\102strict.wav");

audio = monoconvert(audio);

% Store the number of samples in the file
nAudioSamples = length(audio);

% Normalise the amplitude of the signal
audio = normalize(audio, 'range', [-1, 1]);

flux = spectralflux(audio, Fs, 512, 0, 2048);

% nFft = 2048;
% startBin = ceil(100 / ((Fs / 2) / (nFft / 2)));
% endBin = ceil(10e3 / ((Fs / 2) / (nFft / 2)));
% 
% stft = spectrogram(audio, hamming(1024), 0, nFft);
% stft = abs(stft);
% 
% nBins = length(stft(1, :));
% nFreqs = length(stft);
% 
% spectralFlux = zeros(nBins, 1);
% prevSpectrum = stft(:, 1);
% for n=2:nBins
%     
%     currentSpectrum = stft(:, n);
%     
%     currentFlux = 0;
%     for m=startBin:endBin
%         currentFlux = currentFlux + (sqrt(abs(currentSpectrum(m))) - sqrt(abs(prevSpectrum(m))));
%     end
%     
%     spectralFlux(n - 1) = currentFlux;
%     prevSpectrum = currentSpectrum;
%     
% end

plot(flux);

flux(flux < 0) = 0;

doubleStretchedFlux = stretchAudio(flux, 2, 'Window', hann(256, 'periodic'));
quadStretchedFlux = stretchAudio(flux, 4, 'Window', hann(256, 'periodic'));

[globalAutoCorrelation, globalLags] = xcorr(flux);
[globalAutoCorrelation2, globalLags2] = xcorr(doubleStretchedFlux);
[globalAutoCorrelation3, globalLags3] = xcorr(quadStretchedFlux);

globalAutoCorrelation = globalAutoCorrelation( (length(globalAutoCorrelation) / 2) - (length(globalAutoCorrelation3) / 2):((length(globalAutoCorrelation) / 2) + (length(globalAutoCorrelation3) / 2)) - 1 );
globalAutoCorrelation2 = globalAutoCorrelation2( (length(globalAutoCorrelation2) / 2) - (length(globalAutoCorrelation3) / 2):((length(globalAutoCorrelation2) / 2) + (length(globalAutoCorrelation3) / 2)) - 1);

enhancedHarmonics = globalAutoCorrelation + globalAutoCorrelation2 + globalAutoCorrelation3;

enhancedHarmonics(globalLags3 < 60 | globalLags3 > 300) = 0;

[autoCorrelationPeaks, autoCorrelationPeakLocs] = findpeaks(enhancedHarmonics, 'SortStr', 'descend', 'NPeaks', 2,  'MinPeakDistance', 10);

autoCorrelationPeakLocs = sort(autoCorrelationPeakLocs);

% approxBpm = lags(autoCorrelationPeaklocations(1));

possibleLocalBpms = zeros(length(autoCorrelationPeakLocs), 1);
for n=1:length(autoCorrelationPeakLocs)
    possibleLocalBpms(n) = globalLags(autoCorrelationPeakLocs(n));
end

possibleLocalBpms = sort(possibleLocalBpms, 'descend');

% disp(possibleBpms);

timeTotal = length(audio) / Fs;
% possibleLocalBpms = (60 * possibleLocalBpms) / timeTotal;

differences = zeros(length(possibleLocalBpms) - 1, 1);
for n=1:length(possibleLocalBpms) - 1
    differences(n) = possibleLocalBpms(n) - possibleLocalBpms(n + 1);
end

approxBpm = mean(differences);

while approxBpm < 60
    disp(approxBpm);
    approxBpm = approxBpm * 2;
end

averageIoi = 60 / approxBpm;

timeSigNumerator = 4;

nApproxCrotchets = (length(audio) / Fs) / averageIoi;
nSamplesBetweenCrotchets = floor((averageIoi * Fs) * (length(flux) / length(audio)));
nSamplesInBar = timeSigNumerator * nSamplesBetweenCrotchets;
nSamplesInSegment = nSamplesInBar * 2;
nSegments = ceil(length(flux) / nSamplesInSegment);


halfBpm = approxBpm / 2;
halfBpmLowBound = (halfBpm) - (halfBpm * 0.15);
halfBpmHighBound = (halfBpm) + (halfBpm * 0.15);

localBpms = zeros(nSegments, 1);
for n=1:nSegments
    
    startSample = ((n - 1) * nSamplesInSegment) + 1;
    
    if n == nSegments
        endSample = length(flux);
    else
        endSample = startSample + nSamplesInSegment;
    end
    
%     disp(startSample + ":" + endSample);
    
    [localAutoCorrelation, localLags] = xcorr(flux(startSample:endSample));
    localAutoCorrelation(localLags < 50 | localLags > 300) = 0;

    [localAutoCorrelationPeaks, localAutoCorrelationPeakLocs] = findpeaks(localAutoCorrelation, 'SortStr', 'descend', 'NPeaks', 2);
    
    possibleLocalBpms = zeros(length(localAutoCorrelationPeakLocs), 1);
    for m=1:length(localAutoCorrelationPeakLocs)
        possibleLocalBpms(m) = localLags(localAutoCorrelationPeakLocs(m));
    end
    
    possibleLocalBpms = sort(possibleLocalBpms, 'descend');
    
    differences = zeros(length(possibleLocalBpms), 1);
    for m=1:length(differences) - 1
       differences(m) = possibleLocalBpms(m) - possibleLocalBpms(m + 1);
    end
    
    possibleLocalBpm = mean(differences);
    
    while possibleLocalBpm < 50 & possibleLocalBpm > 0
        possibleLocalBpm = possibleLocalBpm * 2;
    end
    
    if possibleLocalBpm > halfBpmLowBound && possibleLocalBpm < halfBpmHighBound
       possibleLocalBpm = possibleLocalBpm * 2; 
    end
    
    disp(possibleLocalBpm);
    
%     [maxPeak, maxLoc] = min(localAutoCorrelationPeakLocs);
    
%     localAutoCorrelationPeaks = localAutoCorrelationPeaks(maxLoc);
%     localAutoCorrelationPeakLocs = localAutoCorrelationPeakLocs(maxLoc);
    
%     disp(mean(localAutoCorrelationPeaks));
    
%     [localAutoCorrelationPeaks, localAutoCorrelationPeakLocs] = findpeaks(localAutoCorrelation, 'NPeaks', 1, 'MinPeakHeight', 0.9 * mean(localAutoCorrelationPeaks));
    
%     plot(localLags, localAutoCorrelation);
%     hold on;
%     plot(localLags(localAutoCorrelationPeakLocs), localAutoCorrelationPeaks, 'x');
%     hold off;
%     drawnow; 
%     pause;
    
%     localBpm = localLags(localAutoCorrelationPeakLocs);
%     disp(localBpm);
    
%     localBpms(n) = localBpm;
    
%     figure(1);
%     plot(localLags, localAutoCorrelation);
%     drawnow;
%     pause;
end

% plot(localBpms);

% impulseSignal = zeros((8 * samplesBetweenImpulses) - 1, 1);
% nCrossCorrelationSamples = length(impulseSignal);
% nSegments = ceil(length(spectralFlux) / nCrossCorrelationSamples);
% nSegmentImpulses = 8;
% lastSegStart = nSegments * nCrossCorrelationSamples;
% currentImpulseLocation = 1;
% impulseCount = 0;
% 
% while impulseCount < nSegmentImpulses && currentImpulseLocation < length(impulseSignal)
%     impulseSignal(currentImpulseLocation) = 1;
%     currentImpulseLocation = currentImpulseLocation + samplesBetweenImpulses;
%     impulseCount = impulseCount + 1;
% end
% 
% figure(1);
% plot(impulseSignal);
% plot(impulseSignal);

% downbeatLocations = zeros(nSegmentImpulses * nSegments, 1);
% for k=1:nSegments
%     
%     startSample = ((k - 1) * nCrossCorrelationSamples) + 1;
%     
% %     disp(startSample);
%     
%     if k * nCrossCorrelationSamples > length(spectralFlux)
%         endSample = length(spectralFlux);
%     else
%         endSample = k * nCrossCorrelationSamples;
%     end
%     
%     [crossCorrelations, crossCorrelationLocs] = xcorr(spectralFlux(startSample:endSample), impulseSignal);
% 
%     crossCorrelations(crossCorrelationLocs < 0) = 0;
%     [crossCorrelationPeaks, crossCorrelationPeakLocs] = ...
%         findpeaks(crossCorrelations, ...
%         'MinPeakDistance', 20, 'SortStr', 'descend', 'NPeaks', nSegmentImpulses);
% 
%     % crossCorrelationPeaks = sort(crossCorrelationPeaks);
%     % crossCorrelationPeakLocs = sort(crossCorrelationPeakLocs);
% 
%     segmentDownbeatLocations = zeros(length(crossCorrelationPeakLocs), 1);
%     for n=1:length(crossCorrelationPeakLocs)
%         segmentDownbeatLocations(n) = crossCorrelationLocs(crossCorrelationPeakLocs(n));
%     end
%     
%     segmentDownbeatLocations(segmentDownbeatLocations > endSample) = 0;
%     
%     segmentDownbeatLocations = segmentDownbeatLocations + startSample - 1;
%     segmentDownbeatLocations = sort(segmentDownbeatLocations);
%     
%     differences = zeros(length(segmentDownbeatLocations) - 1, 1);
%     for n=1:length(segmentDownbeatLocations) - 1
%         differences(n) = segmentDownbeatLocations(n + 1) - segmentDownbeatLocations(n);
%     end
%     
%     currentDownbeatIndex = (k - 1) * nSegments + 1;
% %     test = currentDownbeatIndex + nSegmentImpulses;
% %     disp(currentDownbeatIndex + " to " + test);
%     
%     downbeatLocations(currentDownbeatIndex:currentDownbeatIndex + nSegmentImpulses - 1) = segmentDownbeatLocations;
%     
% 
%     
%     differences = differences / Fs .* (length(audio) / length(spectralFlux));
%     
%     disp(60 / mean(differences));
%     
% %     figure(6);
% %     plot(spectralFlux);
% %     hold on;
% %     for m=1:length(segmentDownbeatLocations)
% %         xline(segmentDownbeatLocations(m), 'LineWidth', 2, 'Color', 'red');
% %     end
% %     hold off;
% %     
% %     drawnow; 
% %     pause;
%     
% end






% for n=1:length(downbeatLocations) - 1
%    disp(downbeatLocations(n + 1) - downbeatLocations(n)); 
% end

% figure(2)
% plot(spectralFlux);
% hold on;
% for n=1:length(downbeatLocations)
%     xline(downbeatLocations(n));
% end
% hold off;
% 
% delta = floor((50e-3 * Fs) * (length(spectralFlux) / length(audio)));
% downbeatSamples = (downbeatLocations) * (length(audio) / length(spectralFlux));
% 
% figure(3);
% plot(audio);
% hold on;
% for n=1:length(downbeatSamples)
%     xline(downbeatSamples(n), 'LineWidth', 2, 'Color', 'red');
% end
% hold off;
% 
% figure(4);
% plot(crossCorrelationLocs, crossCorrelations);
% hold on;
% plot(crossCorrelationLocs(crossCorrelationPeakLocs), crossCorrelationPeaks, 'x');
% hold off;


% actualTimeIndex = linspace(0, length(audio) / Fs, length(audio));
% impulseTimeIndex = linspace(0, length(audio) / Fs, length(spectralFlux));


% audioLength = nAudioSamples / Fs;
% audioTimeAxis = linspace(1, audioLength, nAudioSamples);
% spectralFluxTimeAxis = linspace(1, audioLength, length(spectralFlux));
% plot(spectralFluxTimeAxis, normalize(spectralFlux, 'range', [0, 3]));
% hold on;
% plot(audioTimeAxis, audio);
% hold off;
