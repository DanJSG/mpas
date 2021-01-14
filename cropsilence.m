function[croppedAudio] = cropsilence(audio, threshold)
    
   startPoint = 1;
    for n=1:length(audio)
        if audio(n) > threshold
            startPoint = n - 2;
            if startPoint < 1
                startPoint = 1;
            end
            break;
        end
    end

    endPoint = length(audio);
    for m=1:length(audio)
        n = length(audio) - m;
        if audio(n) > threshold
            endPoint = n + 2;
            if endPoint > length(audio)
                endPoint = length(audio);
            end
            break;
        end
    end 
    
    croppedAudio = audio(startPoint:endPoint);
    
end