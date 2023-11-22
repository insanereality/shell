There are already several (probably correct) answers but I had this exact same problem and this is what worked for me:

add to ~/.bash_profile the following lines:

if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi
