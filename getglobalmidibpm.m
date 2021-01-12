function[bpm, onsets, nOnsets] = getglobalmidibpm(midiMatrix, recordedBpm, timeSigNumerator)
    
    [onsets, nOnsets] = extractmidionsets(midiMatrix, recordedBpm, timeSigNumerator);

    differences = zeros(nOnsets - 1, 1);

    for n=1:nOnsets - 1
        differences(n) = onsets(n + 1) - onsets(n);
    end

    ibi = sum(differences) / length(differences);
    bpm = 60 / ibi;

end