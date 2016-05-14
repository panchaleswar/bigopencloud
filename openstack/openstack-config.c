#include <newt.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
 
/* newt cleanup stuff */
void cleanupNewt() {
 
    newtFinished();
 
}
 
/* newt initialization stuff with background title */
void initNewt(unsigned int y, const char* pTitle) {
 
    unsigned int uiWidth = 0, uiHeight = 0;
    newtGetScreenSize(&uiWidth, &uiHeight);
 
    newtInit();
    newtCls();
    newtDrawRootText((uiWidth-strlen(pTitle))/2, y, pTitle);
    newtPushHelpLine(" Copyrights BigOpenCloud.com All Rights Reserved 2013");
 
}
 
/* draw centered window with components and specified title */
void drawWindow(unsigned int uiW, unsigned int uiH, char* pTitle, char* pEntryText) {
 
    newtComponent form, label, entry, button,okButton, cancelButton,rb[3];
    char* pEntry;
    int i; 
    newtCenteredWindow(uiW, uiH, pTitle);
    label = newtLabel(2, uiH/4, "Please Select the Server you want to Configure !");
    rb[0] = newtRadiobutton(1, 3, "Controller Server ", 1, NULL);
    rb[1] = newtRadiobutton(1, 4, "Compute Server ", 0, rb[0]);
    rb[2] = newtRadiobutton(1, 5, "All in One ", 0, rb[1]);

    entry = newtEntry(uiW/2, uiH/4, "RichNusGeeks", 12, \
                      (const char**) &pEntry, 0);
    okButton = newtButton((uiW-6)/2, (2*uiH/3)+5, "Ok");
    cancelButton = newtButton(((uiW-6)/2)+12, (2*uiH/3)+5, "Cancel");

    form = newtForm(NULL, NULL, 0);
    newtFormAddComponent(form, label);
    
    for (i = 0; i < 3; i++)
        newtFormAddComponent(form, rb[i]);

    newtFormAddComponents(form,okButton,cancelButton, NULL);
    newtRunForm(form);
    
     for (i = 0; i < 3; i++)
        if (newtRadioGetCurrent(rb[0]) == rb[i])
            {
            printf("radio button picked: %d\n", i);
            if (i==0)
                  strncpy(pEntryText, "Controller",12);
            else if (i==1)
                  strncpy(pEntryText, "Compute",12);
            else
                  strncpy(pEntryText, "AppInOne",12);
            }
    newtFormDestroy(form);
 
}
 
/* draw a centered message box */
void messageBox(unsigned int uiW, unsigned int uiH, const char* pMessage) {
 
    newtComponent form, label, button;
 
    newtCenteredWindow(uiW, uiH, "Message Box");
    newtPopHelpLine();
    newtPushHelpLine(" < Press ok button to return > ");
 
    label = newtLabel((uiW-strlen(pMessage))/2, uiH/4, pMessage);
    button = newtButton((uiW-6)/2, 2*uiH/3, "Ok");
    form = newtForm(NULL, NULL, 0);
    newtFormAddComponents(form, label, button, NULL);
    newtRunForm(form);
 
    newtFormDestroy(form);
 
}

void get_input()
{
  newtComponent form, internetnic,managementnic,entrynic1,entrynic2, button;
    char * entryValue1,entryValue2;

    //newtInit();
    newtCls();

    newtOpenWindow(10, 5, 100, 40, "Entry and Label Sample");

    internetnic = newtLabel(1, 1, "Enter the device name for the Internet NIC (eth0, etc.)  :");
    managementnic = newtLabel(2, 1, "Enter the device name for the Management NIC (eth1, etc.):");
    entrynic1 = newtEntry(16, 1, "sample", 20, &entryValue1, 
                      NEWT_FLAG_SCROLL | NEWT_FLAG_RETURNEXIT);
    entrynic2 = newtEntry(16, 2, "sample", 20, &entryValue2,
                      NEWT_FLAG_SCROLL | NEWT_FLAG_RETURNEXIT);

    button = newtButton(17, 3, "Ok");
    form = newtForm(NULL, NULL, 0);
    newtFormAddComponents(form, internetnic,entrynic1,managementnic, entrynic2, button, NULL);

    newtRunForm(form);

    newtFinished();

    printf("Final string was: %s\n", entryValue1);

    /* We cannot destroy the form until after we've used the value
       from the entry widget. */
    newtFormDestroy(form);
}
 
/* Main routine for the greeter */
int main(int argc, char* argv[])
{
 
    /* constant and variable data required */
    const char pBackTitle[] = "Openstack Installation and Configuration Window";    
    char pName[20], pMessage[40];
 
    /* initialize newt stuff */
    initNewt(1, pBackTitle);
 
    drawWindow(110 , 40, "OpenStack Server Congiguration !!!", pName);
    snprintf(pMessage, 39, "You Have choosen to Configure OpenStack %s Server \\m/", pName);
    messageBox(60, 10, pName);
    get_input();
 
    /* cleanup newt library */
    cleanupNewt();
 
    return 0;
 
}
