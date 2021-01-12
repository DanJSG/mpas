function[velocities] = getlocalvelocities(midiMatrix, onsets, bpm, timeSigNumerator)
    
    crotchetLength = 60 / bpm;
    barLength = crotchetLength * timeSigNumerator;
    segmentLength = barLength * 2;

    velocityOnsets = zeros(length(midiMatrix), 2);
    velocityOnsets(:, 1) = midiMatrix(:, 1);
    velocityOnsets(:, 2) = midiMatrix(:, 5);
    velocityOnsets(:, 1) = (velocityOnsets(:, 1) - 1) .* crotchetLength;
    
%     lastOnset = velocityOnsets(end, 1);
    lastOnset = onsets(end);
    nSegments = ceil(lastOnset / segmentLength);
    
    disp("Velocity segments: " + nSegments);
    disp("Segment length: " + segmentLength);
    disp("Last onset: " + lastOnset);
    disp("Length: " + nSegments * segmentLength);
    
    velocities = zeros(nSegments, 1);
    for n=1:nSegments

        segmentStart = (n - 1) * segmentLength;
        segmentEnd = segmentStart + segmentLength;

        segmentVelocityOnsets = velocityOnsets(velocityOnsets(:, 1) >= segmentStart & velocityOnsets(:, 1) < segmentEnd, :);

        meanVelocity = mean(segmentVelocityOnsets(:, 2));

        velocities(n) = meanVelocity;

    end
    
end