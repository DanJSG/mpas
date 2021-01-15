%GETLOCALVELOCITIES Calculate the average velocities over segments of a
%                   MIDI matrix.
% Calculates the mean velocities from the MIDI matrix over sections of the
% audio determined by the BPM and number of beats in each bar.
% Input arguments:
%   midiMatrix - the MIDI toolbox MIDI matrix of the MIDI clip
%   onsets - list of MIDI note onset points in seconds
%   bpm - the BPM of the MIDI clip
%   timeSigNumber - the number of beats in each bar
function[velocities] = getlocalvelocities(midiMatrix, onsets, bpm, timeSigNumerator)
    
    % Determine the length of a crotchet based on the BPM in seconds
    crotchetLength = 60 / bpm;
    
    % Determine the length of a bar in seconds
    barLength = crotchetLength * timeSigNumerator;
    
    % Determine the length of a segment
    segmentLength = barLength * 2;

    % Extract the onsets and velocities from the MIDI matrix
    velocityOnsets = zeros(length(midiMatrix), 2);
    velocityOnsets(:, 1) = midiMatrix(:, 1);
    velocityOnsets(:, 2) = midiMatrix(:, 5);
    velocityOnsets(:, 1) = (velocityOnsets(:, 1) - 1) .* crotchetLength;
    
    % Calculate the last onset position
    lastOnset = onsets(end);
    
    % Caluclate the total number of segments
    nSegments = ceil(lastOnset / segmentLength);
    
    % Initialise a variable for storing the velocities
    velocities = zeros(nSegments, 1);
    
    % Loop over each segment of the audio 
    for n=1:nSegments
        
        % Determine the start and end points for the segment
        segmentStart = (n - 1) * segmentLength;
        segmentEnd = segmentStart + segmentLength;
        
        % Extract the velocities and onsets that fall within the audio
        % segment time range
        segmentVelocityOnsets = velocityOnsets(velocityOnsets(:, 1) >= segmentStart & velocityOnsets(:, 1) < segmentEnd, :);

        % Calculate the mean velocity in the segment
        meanVelocity = mean(segmentVelocityOnsets(:, 2));
        
        % Store the mean velocity
        velocities(n) = meanVelocity;

    end
    
    % Crop any NaN values from the array
    velocities = velocities(all(~isnan(velocities), 2), :);
    
end