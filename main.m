midiMatrix = readmidi("./midi/satie100.mid");
[audio, Fs] = audioread("audio\pro_satie.mp3");

% Convert to mono and normalize the signal
audio = monoconvert(audio);
audio = audio / max(abs(audio));

mRecordingBpm = 100;
timeSigNumerator = 4;

[mBpm, mOnsets, ~] = getglobalmidibpm(midiMatrix, mRecordingBpm, timeSigNumerator);

mLocalBpms = getlocalmidibpms(mOnsets, mBpm, timeSigNumerator);

[aGlobalBpm, newLocalBpms] = getaudiobpms(audio, Fs, timeSigNumerator);

rmsDynamics = getrmsdynamics(audio, Fs, 500e-3);

localDynamics = getlocaldynamics(rmsDynamics, length(audio), Fs, aGlobalBpm, timeSigNumerator);

dynamics = convertrmstolabels(localDynamics);

mVelocities = getlocalvelocities(midiMatrix, mOnsets, mBpm, timeSigNumerator);

mDynamics = convertvelocitytolabels(mVelocities);

% crotchetLength = 60 / mBpm;
% barLength = crotchetLength * timeSigNumerator;
% segmentLength = barLength * 2;
% 
% velocityOnsets = zeros(length(midiMatrix), 2);
% velocityOnsets(:, 1) = midiMatrix(:, 1);
% velocityOnsets(:, 2) = midiMatrix(:, 5);
% velocityOnsets(:, 1) = (velocityOnsets(:, 1) - 1) .* crotchetLength;
% 
% lastOnset = velocityOnsets(end, 1);
% nSegments = ceil(lastOnset / segmentLength);
% 
% localVelocities = zeros(nSegments, 1);
% for n=1:nSegments
%     
%     segmentStart = (n - 1) * segmentLength;
%     segmentEnd = segmentStart + segmentLength;
%     
%     segmentVelocityOnsets = velocityOnsets(velocityOnsets(:, 1) >= segmentStart & velocityOnsets(:, 1) < segmentEnd, :);
%     
%     meanVelocity = mean(segmentVelocityOnsets(:, 2));
%     
%     localVelocities(n) = meanVelocity;
%    
% end



% disp(dynamics);

% disp(localDynamics);

% nSamplesBetweenCrotchets = floor((60 / aGlobalBpm) * Fs);
% nSamplesInBar = timeSigNumerator * nSamplesBetweenCrotchets;
% nSamplesInSegment = nSamplesInBar * 2;
% nSegments = ceil(length(audio) / nSamplesInSegment);
% 
% localDynamics = zeros(nSegments, 1);
% for n=1:nSegments
%     
%     startSample = (n - 1) * nSamplesInSegment + 1;
%     endSample = startSample + nSamplesInSegment;
%     
%     if endSample > length(audio)
%         endSample = length(audio);
%     end
%     
%     startSample = floor(startSample * (length(rmsDynamics) / length(audio)));
%     endSample = floor(endSample * (length(rmsDynamics) / length(audio)));
%     
%     if startSample == 0
%         startSample = 1;
%     end
%     
%     disp(startSample);
%     disp(endSample);
%     
%     localDynamics(n) = mean(rmsDynamics(startSample:endSample));
%     
% end
% 
% disp(localDynamics);

% disp("Global BPM of Audio:" + aGlobalBpm);
% disp("Local BPMs of Audio:");
% disp(aLocalBpms);
% 
% disp("Global BPM of MIDI: " + mBpm);
% disp("Local BPMS of MIDI:");
% disp(mLocalBpms);

% figure(1);
% tDomain1 = linspace(0, length(audio) / Fs, length(audio)); 
% tDomain2 = linspace(0, length(audio) / Fs, length(rmsDynamics));
% tDomain3 = linspace(0, length(audio) / Fs, length(localDynamics));
% plot(tDomain1, audio, tDomain2, rmsDynamics, tDomain3, localDynamics);
% 
% figure(2);
% tDomain1 = linspace(0, length(audio) / Fs, length(newLocalBpms));
% % tDomain2 = linspace(0, length(audio) / Fs, length(aLocalBpms));
% % plot(tDomain1, newLocalBpms, tDomain2, aLocalBpms);
% plot(tDomain1, newLocalBpms);
% ylim([60, 200]);


