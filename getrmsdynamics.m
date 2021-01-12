function[rmsDynamics] = getrmsdynamics(audio, Fs, interval)
    
%     frameLength = 500e-3;
    frameLength = floor(interval * Fs);
    nFrames = floor(length(audio) / frameLength) - 1;

    rmsDynamics = zeros(nFrames, 1);
    for n=1:nFrames

        startSample = ((n - 1) * frameLength) + 1;
        endSample = startSample + frameLength;
        frame = audio(startSample:endSample);
        rmsDynamics(n) = rms(frame);

    end

end