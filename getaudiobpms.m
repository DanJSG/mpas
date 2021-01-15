%GETAUDIOBPMS Function for extracting the global and local BPMs from a clip
%             of audio. 
% Uses the spectral flux autocorrelation method to estimate an approximate
% global tempo. This approximate global tempo is then used to segment the 
% audio into approximately 2 bar sections, which then each have their tempo
% calculated. The global BPM is then taken as the mean of these tempos.
% Input arguments:
%   audio - the audio signal to analyse the BPM of
%   Fs - the sampling frequency of the audio
%   timeSigNumerator - the number of beats in each bar
function[bpm, localBpms] = getaudiobpms(audio, Fs, timeSigNumerator)
    
    % Calculate the spectral flux of the signal and crop all zeros below 0
    flux = getspectralflux(audio, Fs, 512, 0, 2048);
    flux(flux < 0) = 0;

    % Calculate the 10 most likely BPMs using autocorrelation and peak
    % picking
    possibleBpms = autocorrelationbpm(flux, 10);

    % Pick the most likely BPM from these 10 BPMs
    approxBpm = pickbpm(possibleBpms);

    % Calculate the local BPMs over each segment of audio
    localBpms = getlocalbpms(audio, Fs, approxBpm, timeSigNumerator);
       
    % Calculate the mean of the local BPMs
    bpm = mean(localBpms);
    
    % Calculate the segments of audio based on the new mean BPM
    [nSegments, ~] = segmentaudio(bpm, length(audio), Fs, timeSigNumerator, 2);
    
    % Calculate the divisor for matching the previously calculated local
    % BPMs to the new segments
    divisor = floor(length(localBpms) / nSegments);
    
    % If the divisor is less than two then take the moving average across 
    % the local BPMs, by averaging each 2 samples
    if divisor < 2
        localBpms = movmean(localBpms, 2);
        return;
    end
    
    % Calculate the moving average of the local BPMs by whatever the
    % divisor is 
    localBpms = movmean(localBpms, divisor);

    % Initialise a variable for the updated local BPM values
    newLocalBpms = zeros(nSegments, 1);
    
    % Loop through each segment
    for n=1:nSegments
        
        % Determine the start and end segment
        startSeg = divisor * (n - 1) + 1;
        endSeg = startSeg + divisor - 1;

        % If the end position is longer than the length of the local BPMs,
        % then crop it to the length of the array
        if endSeg > length(localBpms)
            endSeg = length(localBpms);
        end

        % Calculate the mean of the segments
        newLocalBpms(n) = mean(localBpms(startSeg:endSeg));

    end
    
    % Output the new local BPM values
    localBpms = newLocalBpms;
    
end