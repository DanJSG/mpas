%PICKBPM Function to choose the BPM based on a selection of possible BPMs
% Takes a list of BPMs and then picks the one thought to be accurate. It
% does this by calculating the mean BPM, then using the median BPM to
% create upper and lower bounds for double the BPM and half the BPM. It
% then uses this to check if the mean BPM is approximately double or half
% the median BPM, and if it is to adjust it. This is to help avoid picking
% a BPM that is twice as fast or half as slow as can commonly happen.
% Input arguments:
%   bpms - list of BPMs
function[bpm] = pickbpm(bpms)
    
    % If the length of BPMs is less than two, then return the BPM
    if length(bpms) < 2
       bpm = bpms;
       return;
    end
    
    % Calculate the mean BPM
    averageBpm = mean(bpms);
    
    % Calculate the median BPM
    medianBpm = median(bpms, 1);
    
    % Calculate the range for double the BPM (twice median +/-10%)
    doubleLowerBound = (2 * medianBpm) * 0.9;
    doubleUpperBound = (2 * medianBpm) * 1.1;
    
    % Calculate the range for half the BPM (half median +/-10%)
    halfLowerBound = (0.5 * medianBpm) * 0.9;
    halfUpperBound = (0.5 * medianBpm) * 1.1;
    
    % Check if the mean BPM is roughly double or half the median, and
    % adjust accordingly
    if averageBpm > doubleLowerBound && averageBpm < doubleUpperBound
        bpm = averageBpm / 2;
    elseif averageBpm > halfLowerBound && averageBpm < halfUpperBound
        bpm = averageBpm * 2;
    else
        bpm = averageBpm;
    end

end