%GETLOCALBPMS Function to get the local BPMs throug segments in an audio
%             clip.
% Uses the global BPM to split into segments of approximately 2 bars and
% then calculate the BPM for each of these sections.
% Input arguments:
%   audio - the input audio signal
%   Fs - the sampling frequency of the piece
%   approxBpm - the approximate BPM of the audio
%   timeSigNumerator - the number of beats in a bar
function[bpms] = getlocalbpms(audio, Fs, approxBpm, timeSigNumerator)
    
    % Calculate the number of segments in the audio clip and the number of
    % samples in each segment
    [nSegments, nSamplesInSegment] = segmentaudio(approxBpm, length(audio), Fs, timeSigNumerator, 2);
    
    % Initialise variable for storing the BPMs
    bpms = zeros(length(nSegments), 1);
    
    % Loop over each segment
    for n=1:nSegments
        
        % Calculate the start sample for the segment
        startSample = ((n - 1) * nSamplesInSegment) + 1;

        % If it is the last segment, set the last sample to the end of the
        % audio, otherwise set it to the start sample plus the length of
        % the segment
        if n == nSegments
            endSample = length(audio);
        else
            endSample = startSample + nSamplesInSegment;
        end
        
        % Extract the segment of audio
        audioSegment = audio(startSample:endSample);
        
        % Calculate the spectral flux for the segment
        segmentFlux = getspectralflux(audioSegment, Fs, 512, 0, 2048);
        
        % Calculate the 10 most likely BPMs for the segment
        segmentBpms = autocorrelationbpm(segmentFlux, 10);
        
        % Choose the most likely BPM from the 10 BPMs extracted 
        segmentBpm = pickbpm(segmentBpms);
        
        % Save the BPM for the segment
        bpms(n, 1) = segmentBpm;

    end
       
end