# xrdp_keyborad
Helper for keyborad layout settings (Ubuntu, xfce4)

### This is a workaround for keyborad layoout probelem in Ubuntu dexktop environment using xrdp and xfce4
At login/reconnect the XRDP client sends the actual kbd layout code to the server, but according the protocol only one code can be sent. This overrides the xface kayboard-layout settings ~10-20 seconds later than the session manager or the /etc/drdp/reconnectwm.sh has been started.

# Usage:
1. Copy this script to **/etc/xrdp/setkeyboard.sh**
2. Make is executable (x bit)
3. Put this to end of **/etc/xrdp/reconnectwm.sh:** ```/etc/xrdp/setkeyboard.sh 10 &```
4. Create a file **/etc/X11/Xsession.d/98setxrdp-keyboard** with this content: ```/etc/xrdp/setkeyboard.sh 40 &```
   
