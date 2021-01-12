function[bpm] = pickbpm(bpms)
    
    if length(bpms) < 2
       bpm = bpms;
       return;
    end
    
    averageBpm = mean(bpms);
    medianBpm = median(bpms, 1);
    
    doubleLowerBound = (2 * medianBpm) * 0.9;
    doubleUpperBound = (2 * medianBpm) * 1.1;
    
    halfLowerBound = (0.5 * medianBpm) * 0.9;
    halfUpperBound = (0.5 * medianBpm) * 1.1;
    
    if averageBpm > doubleLowerBound && averageBpm < doubleUpperBound
        bpm = averageBpm / 2;
    elseif averageBpm > halfLowerBound && averageBpm < halfUpperBound
        bpm = averageBpm * 2;
    else
        bpm = averageBpm;
    end

end