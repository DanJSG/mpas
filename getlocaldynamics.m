%GETLOCALDYNAMICS Function to extract the dynamics over a range of segments
%                 based on the RMS values.
% Takes a set of RMS values of an audio file and calculates the dynamics
% for segments of audio based on the average of these values.
% Input arguments:
%   rmsDynamics - the RMS values of an audio file
%   nAudioSamples - the number of samples in the original audio file
%   Fs - the sampling frequency of the original audio file
%   globalBpm - the BPM of the audio
%   timeSigNumerator - the number of beats in each bar
function[localMeanRms] = getlocaldynamics(rmsDynamics, nAudioSamples, Fs, globalBpm, timeSigNumerator)
    
    % Calculate the segments for the audio
    [nSegments, nSamplesInSegment] = segmentaudio(globalBpm, nAudioSamples, Fs, timeSigNumerator, 2);
    
    % Initialise a variable for storing the mean RMS values
    localMeanRms = zeros(nSegments, 1);
    
    % Loop through each segment
    for n=1:nSegments
        
        % Calculate the start and end samples for the section of audio
        startSample = (n - 1) * nSamplesInSegment + 1;
        endSample = startSample + nSamplesInSegment;
        
        % If the end sample is greater than the length of the audio, then
        % set the end sample to the last sample in the audio
        if endSample > nAudioSamples
            endSample = nAudioSamples;
        end
        
        % Adjust the start and end sample for the length of the RMS signal
        % as opposed to the length of the audio file
        startSample = floor(startSample * (length(rmsDynamics) / nAudioSamples));
        endSample = floor(endSample * (length(rmsDynamics) / nAudioSamples));
        
        % Ensure the start sample is > 0
        if startSample == 0
            startSample = 1;
        end
        
        % Calculate the mean RMS over each segment
        localMeanRms(n) = mean(rmsDynamics(startSample:endSample));

    end
    
end