[audio, Fs] = audioread("./audio/GymnopediesIntroPerformance.wav");

audio = monoconvert(audio);
audio = audio / max(abs(audio));

% startPoint = 1;
% for n=1:length(audio)
%     if audio(n) > 2e-3
%         startPoint = n - 2;
%         if startPoint < 1
%             startPoint = 1;
%         end
%         break;
%     end
% end
% 
% endPoint = length(audio);
% for m=1:length(audio)
%     n = length(audio) - m;
%     if audio(n) > 2e-3
%         endPoint = n + 2;
%         if endPoint > length(audio)
%             endPoint = length(audio);
%         end
%         break;
%     end
% end
% 
% disp(startPoint);

% croppedAudio = audio(startPoint:endPoint);
croppedAudio = cropsilence(audio, 2e-3);

tDomain1 = linspace(0, length(audio) / Fs, length(audio));
tDomain2 = linspace(0, length(croppedAudio) / Fs, length(croppedAudio));
plot(tDomain1, audio, tDomain2, croppedAudio);


% 
% rmsDynamics = getrmsdynamics(audio, Fs, 50e-3);
% % rmsDynamics = rmsDynamics / max(abs(rmsDynamics));
% 
% [pks, pkLocs] = findpeaks(rmsDynamics, 'NPeaks', 8);
% 
% tDomain1 = linspace(0, length(audio) / Fs, length(audio));
% tDomain2 = linspace(0, length(audio) / Fs, length(rmsDynamics));
% % plot(tDomain1, audio, tDomain2, rmsDynamics);
% plot(tDomain2, rmsDynamics);
% hold on;
% plot(tDomain2(pkLocs), pks, 'x');
% hold off;