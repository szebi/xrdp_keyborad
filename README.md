# xrdp_keyborad
Helper for keyborad layout settings (Ubuntu, xfce4)

### This is a workaround for keyborad layoout probelem in Ubuntu dexktop environment using xrdp and xfce4
At login/reconnect the XRDP client sends the actual kbd layout code to the server, but according the protocol only one code can be sent. This overwrites the xface multilingual keyboard assignment settings ~5-20 seconds after the session manager or /etc/xdrdp/reconnectwm.sh has been started. This script restores the keyboard layout according to xfconf keyboard-layout settings.

# Usage:
1. Copy this script to **/etc/xrdp/setkeyboard.sh**
2. Make it executable (chmod +x /etc/xrdp/setkeyboard.sh)
3. Put this to end of **/etc/xrdp/reconnectwm.sh:** ```/etc/xrdp/setkeyboard.sh 5 syslog &```
4. Create a file **/etc/X11/Xsession.d/98setxrdp-keyboard** with this content: ```/etc/xrdp/setkeyboard.sh 30 syslog &```. This step can be omitted on Ununtu 24.04.
5. The timeouts (5 and 30) may vary.
   
