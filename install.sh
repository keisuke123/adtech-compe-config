# copy .bash_profile
cd ~/config
cp .bash_profile ~/.bash_profile

# copy dsp.service
sudo cp dsp.service /etc/systemd/system/

# copy Makefile-go
cp Makefile-golang .adtech-compe-2018-e/server/Makefile


