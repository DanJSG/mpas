%SEGMENTAUDIO Function to return a number of segments and the samples in
%             each segment.
% Calculates the average inter-onset-interval and the uses this to 
% calculate the number of samples between each crotchet. This is then used
% to calculate the number of samples in each bar, and then finally the
% number of bars in each segments determines the total number of segments
% and the number of samples in each segment.
% Input arguments:
%   approxBpm - the approximate BPM to base the inter-onset-interval on
%   nAudioSamples - the total number of samples in the audio
%   Fs - the sampling frequency
%   timeSigNumerator - the number of beats in each bar
%   nBarsInSegment - the number of bars in each segment
function[nSegments, nSamplesInSegment] = segmentaudio(approxBpm, nAudioSamples, Fs, timeSigNumerator, nBarsInSegment)
    
    % Calculate the average inter-onset-interval
    averageIoi = 60 / approxBpm;
    
    % Calculate the number of samples between each crotchet
    nSamplesBetweenCrotchets = floor((averageIoi * Fs));
    
    % Calculate the number of samples in each bar
    nSamplesInBar = timeSigNumerator * nSamplesBetweenCrotchets;
    
    % Calculate the number of samples in each segment
    nSamplesInSegment = nSamplesInBar * nBarsInSegment;
    
    % Calculate the total number of segments
    nSegments = ceil(nAudioSamples / nSamplesInSegment);

end
