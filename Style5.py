import os
import sys
import time
from time import sleep
os.system('clear')
os.system('xdg-open https://www.youtube.com/channel/UCft7Gzxk8Ow1eP_6yp1SApQ')
sleep(5)
print '\x1b[1;37m\xe2\x97\x80\x1b[1;36m\xe2\x95\x90\xe2\x95\x90\xe2\x95\x90\xe2\x95\x90\xe2\x95\x90\xe2\x95\x90\xe2\x95\x90\xe2\x95\x90\xe2\x95\x90\xe2\x95\x90\xe2\x95\x90\xe2\x95\x90\xe2\x95\x90\xe2\x95\x90\xe2\x95\x90\xe2\x95\x90\xe2\x95\x90\xe2\x95\x90\xe2\x95\x90\xe2\x95\x90\xe2\x95\x90\xe2\x95\x90\xe2\x95\x90\xe2\x95\x90\x1b[1;37m\xe2\x96\xb6'
print '\x1b[1;37m[\x1b[1;32m1\x1b[1;37m]\x1b[1;33mLogin SC'
print '\x1b[1;37m[\x1b[1;32m2\x1b[1;37m]\x1b[1;33minstall bahan dulu'
print '\x1b[1;37m[\x1b[1;32m0\x1b[1;37m]\x1b[1;31mexit'
pil = raw_input('\x1b[1;33mPilih > \x1b[1;32m')
if pil == '1':
    os.chdir('ANKER')
    os.system('python2 style.py')
elif pil == '2':
    os.system('clear')
    print '\x1b[1;33mInstalling...'
    sleep(2)
    os.system('pkg install figlet ruby -y')
    os.system('gem install lolcat')
    os.system('clear')
    print '\x1b[1;32mBahan Terinstall'
    fil = raw_input('\x1b[1;33mTekan Enter untuk login sc : ')
    if fil == '':
        os.chdir('ANKER')
        os.system('python2 run.py')

elif pil == '0':
    sys.exit()