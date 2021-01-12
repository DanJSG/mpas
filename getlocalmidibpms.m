function[bpms] = getlocalmidibpms(onsets, approxBpm, timeSigNumerator)

    crotchetLength = 60 / approxBpm;
    barLength = crotchetLength * timeSigNumerator;
    segmentLength = barLength * 2;

    lastOnset = onsets(end);
    nSegments = ceil(lastOnset / segmentLength);
    
    disp("BPMs segments: " + nSegments);
    disp("Segment length: " + segmentLength);
    disp("Last onset: " + lastOnset);
    disp("Length: " + nSegments * segmentLength);
    
    bpms = zeros(nSegments, 1);
    for n=1:nSegments

        segmentStart = (n - 1) * segmentLength;
        segmentEnd = segmentStart + segmentLength;

        segmentOnsets = onsets(onsets < segmentEnd & onsets > segmentStart);
        nSegmentOnsets = length(segmentOnsets);

        differences = zeros(nSegmentOnsets - 1, 1);

        for m=1:nSegmentOnsets - 1
           differences(m) = segmentOnsets(m + 1) - segmentOnsets(m);
        end

        ibi = sum(differences) / length(differences);

        bpms(n) = 60 / ibi;

        if any(isnan(bpms)) && n > 1
            bpms(n) = bpms(n - 1);
        elseif any(isnan(bpms))
            bpms(n) = bpm;
        end

    end

end