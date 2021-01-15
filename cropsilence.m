%CROPSILENCE Function for cropping leading and trailing silence in audio
%            data.
% Loops through and crops silence that is below a certain threshold. Please
% note that this only works with monophonic audio signals.
% Input arguments:
%   audio - the audio to crop
%   threshold - the threshold below which to class as silence
function[croppedAudio] = cropsilence(audio, threshold)
    
    % Set the starting sample to the first sample in the audio
    startPoint = 1;
    % Loop through each sample in the audio
    for n=1:length(audio)
        % Check if the current sample is greater than the threshold
        if audio(n) > threshold
            % If it is greater than the threshold, then set the start point
            % to be two samples earlier (to avoid missing the start of a
            % transient)
            startPoint = n - 2;
            % If the start point is then less than 1, set it to 1
            if startPoint < 1
                startPoint = 1;
            end
            % Break out of the for loop
            break;
        end
    end
    
    % Set the end point to the last sample in the audio
    endPoint = length(audio);
    % Loop through each sample in the audio
    for m=1:length(audio)
        % Use n as an iterator for iterating backwards through the audio
        % file
        n = length(audio) - m;
        % Check if the current sample is greater than the threshold
        if audio(n) > threshold
            % If it is greater than the threshold, then set the end point
            % to be two samples later (to avoid missing the end of any
            % trailing decays)
            endPoint = n + 2;
            % If the end point is greater than the length of the audio, set
            % it to the length of the audio
            if endPoint > length(audio)
                endPoint = length(audio);
            end
            % Break out of the for loop
            break;
        end
    end 
    
    % Crop the audio based on the calculated start and end points
    croppedAudio = audio(startPoint:endPoint);
    
end