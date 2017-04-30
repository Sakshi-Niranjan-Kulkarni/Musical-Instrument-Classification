function [ profile ] = tambre( signal )
% Tambre: generates list of principal harmonics
% from a given sound vector

% Convert stereo to mono:
if max(size(signal,2)) > 1
    signal = (signal(:,1)+signal(:,2))/2;
end

profile = abs(fft(signal));
%profile = signal;
% Vector will be symmetric, only need 1/2
s = int32(size(profile,1)/2);
profile = profile(1:s);
%cutoff = mean(profile);

%normalize:
profile = profile / max(abs(profile));

% Reduce noise by cutting off amplitutes <10
%cutoff = 0.1;
%profile(abs(profile) < cutoff)=0;


end

