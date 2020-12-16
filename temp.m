% % Read audio file and sample rate
% [audio, Fs] = audioread('pro_satie_intro.wav');
% 
% % Get number of channels of audio file
% nChannels = length(audio(1, :));
% 
% threshold = 35;
% 
% % If the file has more than 1 channel, convert to mono
% if nChannels > 1
%    audio(:, 1) =  0.5 * (audio(:, 1) + audio(:, 2));
%    audio = audio(:, 1);
% end
% 
% % Store the number of samples in the file
% nAudioSamples = length(audio);
% 
% % Normalise the amplitude of the signal
% audio = normalize(audio, 'range', [-1, 1]);
% 
% % Create a window and set the overlap to be half the width of the window
% windowLength = 2048;
% window = hamming(windowLength);
% overlap = windowLength / 2;
% 
% % Zero pad audio to match window length
% paddingLength = (overlap * ceil(nAudioSamples / overlap)) - nAudioSamples;
% audio(end:end + paddingLength) = 0;
% nAudioSamples = length(audio);
% 
% % Initialise variables for onsets and high frequency content function
% onsetRanges = zeros(nAudioSamples / overlap, 2);
% nOnsetRanges = 0;
% currentHfc = 0;
% 
% minTimeBetween = 40e-3;
% minSamplesBetween = floor(minTimeBetween * Fs);
% 
% % Loop over the audio samples
% for n=1:(nAudioSamples / overlap) - 1
%     
%     % Set the previous HFC function value
%     prevHfc = currentHfc;
%     
%     % Get the start and end samples of the frame
%     startSample = overlap * (n - 1) + 1;
%     endSample = startSample + windowLength - 1;
%     
%     % Window the frame of audio using the hamming window
%     frame = audio(startSample:endSample) .* window;
%     
%     % Calculate an FFT with the same number of points as the window and
%     % take the magnitude of this 
%     transformed = abs(fft(frame, windowLength));
%     
%     % Initialise current HFC and Energy function values to 0
%     currentHfc = 0;
%     energyFunction = 0;
%     
%     % Loop over the FFT values and calculate the HFC and Energy function
%     % values
%     for k=2:windowLength / 2
%         energyFunction = energyFunction + (transformed(k) ^ 2);
%         currentHfc = currentHfc + ((transformed(k) ^ 2) * k);
%     end
%     
%     % Calculate the detection function
%     detectionFunction = (currentHfc / prevHfc) * (currentHfc / energyFunction);
%     
%     % If detection function is higher than the threshold then store the
%     % windows sample range
%     if detectionFunction > threshold
%         if (nOnsetRanges > 0 && ...
%                 startSample - minSamplesBetween > onsetRanges(nOnsetRanges)) || ...
%                 nOnsetRanges == 0
%             nOnsetRanges = nOnsetRanges + 1;
%             onsetRanges(nOnsetRanges, 1) = startSample;
%             onsetRanges(nOnsetRanges, 2) = endSample;
%         end
%     end
%     
% end
% 
% % Crop array of onset ranges to remove trailing 0s
% onsetRanges = onsetRanges(1:nOnsetRanges, :);
% 
% % Initialise array for storing actual onsets
% onsetSamples = zeros(nOnsetRanges, 2);
% nOnsets = 0;
% 
% % Loop through the onset ranges and find the max point within each range
% for n=1:nOnsetRanges
%     [peak, index] = max(audio(onsetRanges(n, 1):onsetRanges(n, 2)));
%     onsetSamples(n, 1) = index + onsetRanges(n, 1);
%     onsetSamples(n, 2) = peak;
%     nOnsets = nOnsets + 1;
% end
% 
% plot(audio);
% ylim([-1, 1]);
% hold on;
% % plot(finalOnsetSamples(:, 1), 1, 'x', 'LineWidth', 5);
% plot(onsetSamples(:, 1), onsetSamples(:, 2), '|', 'LineWidth', 1, 'Color', 'red');
% plot(onsetSamples(:, 1), onsetSamples(:, 2), 'x', 'LineWidth', 1, 'Color', 'red');
% hold off;


% onsets = onsetSamples(1:nOnsets) ./ Fs;
% nOnsets = onsetCount;

% [audio, Fs] = audioread();

[audio, Fs] = audioread("pro_satie_intro.wav");
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

[onsets, nOnsets, peaks] = extractaudioonsets(audio, Fs, 40);

% spectralPeaksSignal = spectralpeaks(audio, 1024);
% firstOrderDifferential = gradient(spectralPeaksSignal(:)) ./ gradient(1:length(spectralPeaksSignal));
% firstOrderDifferential = firstOrderDifferential(:, 1);
% 
% gaussianWindow = gausswin(8);
% gaussianFiltered = filter(gaussianWindow, 1, firstOrderDifferential);
% 
% gaussianFiltered(gaussianFiltered < 0) = 0;
% 
% minTimeBetween = 40e-3;
% minSamplesBetween = (minTimeBetween * Fs) / 1024;
% 
% [sePeaks, seLocations] = findpeaks(gaussianFiltered, 'MinPeakHeight', 10, 'MinPeakDistance', minSamplesBetween);
% 
% plot(spectralPeaksSignal);
% hold on;
% plot(gaussianFiltered);
% plot(seLocations, sePeaks, 'x');
% hold off;

plot(audio);
hold on;
plot(onsets * Fs, peaks, 'x');
hold off;


% Initialise array for storing time differences between notes
differences = zeros(nOnsets - 1, 1);

% Calculate differences between onsets
for n=1:nOnsets - 1
    differences(n) = onsets(n + 1) - onsets(n);
end

% Calculate average inter-onset intervals
ibi = sum(differences) / length(differences);

% Calculate the BPM from the inter-onset intervals
bpm = 60 / ibi;

% seLocations = seLocations .* (windowLength / 2);
% seDifferences = zeros(length(sePeaks) - 1, 1);
% for n=1:length(sePeaks) - 1
%     seDifferences(n) = seLocations(n + 1) - seLocations(n);
% end
% 
% seIbi = sum(seDifferences) / length(differences);
% 
% seBpm = 60 / seIbi;


