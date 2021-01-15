%GETRMSDYNAMICS Function to calculate the RMS value of the amplitude of a
%               signal over time.
% Calculates the RMS amplitude over the length of the signal, calculating
% it for segments determined by the given interval time.
% Input arguments:
%   audio - the audio signal
%   Fs - the sampling frequency
%   interval - the interval over which to calculate the RMS in seconds
function[rmsDynamics] = getrmsdynamics(audio, Fs, interval)
    
    % Determine the frame length in samples based on the interval and
    % sampling frequency
    frameLength = floor(interval * Fs);
    
    % Calculate the number of frames in the audio file
    nFrames = floor(length(audio) / frameLength) - 1;

    % Initialise variable for the RMS values
    rmsDynamics = zeros(nFrames, 1);
    
    % Loop over each frame
    for n=1:nFrames
        
        % Calculate the start and finish samples
        startSample = ((n - 1) * frameLength) + 1;
        endSample = startSample + frameLength;
        
        % Extract the audio frame being analysed
        frame = audio(startSample:endSample);
        
        % Calculate the RMS value for the current frame of audio
        rmsDynamics(n) = rms(frame);

    end

end