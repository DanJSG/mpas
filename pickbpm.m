function[bpm] = pickbpm(bpms, minBpm, maxBpm)
    
    if length(bpms) < 2
       bpm = bpms;
       return;
    end
    
    disp("Calculating differences...");
    
    differences = zeros(length(bpms) - 1, 1);
    for n=1:length(bpms) - 1
        differences(n) = bpms(n) - bpms(n + 1);
    end

    bpm = mean(differences);
    
    if bpm == 0
        return;
    end
    
    while bpm < minBpm
        bpm = bpm * 2;
    end
    
    while bpm > maxBpm
        bpm = bpm / 2;
    end

end