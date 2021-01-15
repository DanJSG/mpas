%MONOCONVERT Function to convert stereo audio track to mono.
% Sums together the channels of the stereo audio to get a monophonic
% signal.
% Input arguments:
%   audio - the audio file to convert
function[audio] = monoconvert(audio)
    
    % Number of channels in the audio
    nChannels = length(audio(1, :));

    % If the file has more than 1 channel, convert to mono
    if nChannels > 1
        % Sum channels and adjust amplitude to avoid clipping
        audio(:, 1) =  0.5 * (audio(:, 1) + audio(:, 2));
        audio = audio(:, 1);
    end
    
end