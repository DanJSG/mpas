function[velocities] = getlocalvelocities(midiMatrix, onsets, bpm, timeSigNumerator)
    
    crotchetLength = 60 / bpm;
    barLength = crotchetLength * timeSigNumerator;
    segmentLength = barLength * 2;

    velocityOnsets = zeros(length(midiMatrix), 2);
    velocityOnsets(:, 1) = midiMatrix(:, 1);
    velocityOnsets(:, 2) = midiMatrix(:, 5);
    velocityOnsets(:, 1) = (velocityOnsets(:, 1) - 1) .* crotchetLength;
    
    lastOnset = onsets(end);
    nSegments = ceil(lastOnset / segmentLength);
    
    velocities = zeros(nSegments, 1);
    for n=1:nSegments

        segmentStart = (n - 1) * segmentLength;
        segmentEnd = segmentStart + segmentLength;

        segmentVelocityOnsets = velocityOnsets(velocityOnsets(:, 1) >= segmentStart & velocityOnsets(:, 1) < segmentEnd, :);

        meanVelocity = mean(segmentVelocityOnsets(:, 2));
        
        velocities(n) = meanVelocity;

    end
    
    velocities = velocities(all(~isnan(velocities), 2), :);
    
%     disp("Extracted velocities: ");
%     disp(velocities);
    
end