[audio, Fs] = audioread("audio\pro_satie_intro.wav");
nChannels = length(audio(1, :));

% If the file has more than 1 channel, convert to mono
if nChannels > 1
   audio(:, 1) =  0.5 * (audio(:, 1) + audio(:, 2));
   audio = audio(:, 1);
end

% Store the number of samples in the file
nAudioSamples = length(audio);

% Normalise the amplitude of the signal
audio = normalize(audio, 'range', [-1, 1]);

nFft = 2048;
startBin = ceil(100 / ((Fs / 2) / (nFft / 2)));
endBin = ceil(10e3 / ((Fs / 2) / (nFft / 2)));

stft = spectrogram(audio, 512, 0, nFft);
stft = abs(stft);

nBins = length(stft(1, :));
nFreqs = length(stft);

spectralFlux = zeros(nBins, 1);
prevSpectrum = stft(:, 1);
for n=2:nBins
    
    currentSpectrum = stft(:, n);
    
    currentFlux = 0;
    for m=startBin:endBin
        currentFlux = currentFlux + (sqrt(abs(currentSpectrum(m))) - sqrt(abs(prevSpectrum(m))));
    end
    
    spectralFlux(n - 1) = currentFlux;
    prevSpectrum = currentSpectrum;
    
end

spectralFlux(spectralFlux < 0) = 0;

[autoCorrelation, lags] = xcorr(spectralFlux);
autoCorrelation(lags < 60 | lags > 300) = 0;

% figure(1);
% plot(lags, autoCorrelation);

[autoCorrelationPeaks, autoCorrelationPeakLocs] = findpeaks(autoCorrelation, 'SortStr', 'descend', 'NPeaks', 3,  'MinPeakDistance', 20);
autoCorrelationPeakLocs = sort(autoCorrelationPeakLocs);

% approxBpm = lags(autoCorrelationPeaklocations(1));

possibleBpms = zeros(length(autoCorrelationPeakLocs), 1);
for n=1:length(autoCorrelationPeakLocs)
    possibleBpms(n) = lags(autoCorrelationPeakLocs(n));
end

possibleBpms = sort(possibleBpms, 'descend');

differences = zeros(length(possibleBpms) - 1, 1);
for n=1:length(possibleBpms) - 1
    differences(n) = possibleBpms(n) - possibleBpms(n + 1);
end

approxBpm = mean(differences);

if approxBpm < 60
   approxBpm = approxBpm * 2;
end

averageIoi = 60 / approxBpm;

nApproxCrotchets = (length(audio) / Fs) / averageIoi;

impulseSignal = zeros(length(spectralFlux), 1);
samplesBetweenImpulses = floor((averageIoi * Fs) * (length(spectralFlux) / length(audio)));
currentImpulseLocation = 1;

timeSigNumerator = 4;

while currentImpulseLocation < length(impulseSignal)
    impulseSignal(currentImpulseLocation) = 1;
    currentImpulseLocation = currentImpulseLocation + samplesBetweenImpulses;
end

plot(impulseSignal);

[crossCorrelations, crossCorrelationLocs] = xcorr(spectralFlux, impulseSignal);


crossCorrelations(crossCorrelationLocs < 0) = 0;
[crossCorrelationPeaks, crossCorrelationPeakLocs] = findpeaks(crossCorrelations, 'SortStr', 'descend','MinPeakDistance', 20, 'Threshold', 150);

% crossCorrelationPeaks = sort(crossCorrelationPeaks);
% crossCorrelationPeakLocs = sort(crossCorrelationPeakLocs);

downbeatLocations = zeros(length(crossCorrelationPeakLocs), 1);
for n=1:length(crossCorrelationPeakLocs)
    downbeatLocations(n) = crossCorrelationLocs(crossCorrelationPeakLocs(n));
end

for n=1:length(downbeatLocations) - 1
   disp(downbeatLocations(n + 1) - downbeatLocations(n)); 
end

delta = floor((50e-3 * Fs) * (length(spectralFlux) / length(audio)));
downbeatSamples = (downbeatLocations) * (length(audio) / length(spectralFlux));

plot(audio);
hold on;
for n=1:length(downbeatSamples)
    xline(downbeatSamples(n), 'LineWidth', 2, 'Color', 'red');
end
hold off;

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
