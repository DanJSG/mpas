function[matchedValues] = matchsegments(originalData, matchLength, duration)
    
    matchedTimeDomain = linspace(0, duration, length(originalData));
    segmentLength = matchedTimeDomain(end) / matchLength;

    matchedValues = zeros(matchLength, 1);
%     disp("Match length:" + matchLength);
%     disp(matchedTimeDomain);
    for n=1:matchLength
        
%         disp("Start: " + (n - 1) * segmentLength)
%         disp("End: " + n * segmentLength);
        
        midiRange = matchedTimeDomain <= n * segmentLength & matchedTimeDomain >= (n - 1) * segmentLength;
        indices = find(midiRange);
        disp(indices);
        value = originalData(indices);
        if length(value) > 1
            value = mean(value);
        elseif length(value) < 1 && n > 1
            value = matchedValues(n - 1);
        end
%         disp("Value = " + value + " on iteration " + n + ".");
%         disp("Value length = " + length(value) + ".");
        matchedValues(n) = value;
    end
    
end