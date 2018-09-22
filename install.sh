# copy .bash_profile
cd ~/config
cp .bash_profile ~/.bash_profile

# copy dsp.service
sudo cp dsp.service /etc/systemd/system/
sudo systemctl enable dsp
sudo systemctl start dsp

# copy Makefile-go
cd ~/adtech-compe-2018-e/
git checkout feature/server
cp ~/config/Makefile-golang ~/adtech-compe-2018-e/server/Makefile
