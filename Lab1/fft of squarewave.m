Fs = 1000.0
t=0:1/Fs:1
f=523
%x=square(2*pi*t*f)
%nfft = 1024
%X = fft(x,nfft)
%X=X(1:nfft/2)
%mx = abs(X)
%f=(0:nfft/2-1)*Fs/nfft)

plot(t,x)
