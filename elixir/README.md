ONE TIME
Installation of Skuid package

After installing the SKUID Extension package, go to the Pages tab. (Click on the '+' in the tab bar, and search for Pages tab.) and click "Unpack Pages..."  in the  + Create New Page drop down. Select one by one the static resources named:
clOriginate
CLSbasepages
CLSSngUI
CLLeasePages
with Namespace = genesisExtn, and click Unpack. Close this page once a Success message is displayed.
Navigate back to the CL Originate Setup page.
Override custom object Application's actions - New and View. To do this:
               a. Go to Setup, Build, Create, Objects.
               b. Click the Application object, and scroll down to the Buttons, Links, and Actions section.
               c. Click the New label. The Override Properties page is displayed.
               d. Click Edit. 
               e. In the Override With options, select Visualforce Page.
               f. In the Visualforce Page drop down list, select NewApplication (genesisExtn__NewApplication).
               g. Repeat Steps c- f for the View action. Change the Visualforce page View to ApplicationDetails (genesisExtn__ApplicationDetails)
 
 For enabling Lease application processing in CL Originate, override custom object Quick Quotes's actions - New and View. To do this perform steps i to v. Then select the pages listed below for both New and View and save your changes.
Change New to NewQuickQuote(genesisExtn__NewQuickQuote)
Change View to QuickQuoteDetails(genesisExtn__QuickQuoteDetails)


       After you have done the above, perform the following steps to use the custom UI pages :
Go to Setup, Build, Develop, Custom Settings.
Click Org Parameters. If you do not see this in the Custom Settings list, check that CL Originate is selected in the View drop down on top.
Click Manage.
Click Edit.
Select the Use Contact As Account check box.
Click Save.


Unpacking of CLS Pages :

Running Seed Data Script :

Checking for seed data

To check if seed data is present in an org, run the following query in the Develop Console:

Click Your Name | Developer Console or navigate to Setup | Develop | Tools and click the Developer Console link.

Click on Query Editor, paste the below query and click ‘Execute’ button

SELECT ID FROM loan__Payment_Mode__c

If this query does not return any data, there is no seed data in the org else, it will return more than 1 row implying seed data is present. 

Depending on the results returned by the query, proceed to the next steps listed below

Creating seed data

For CL Loan to function properly post a Sandbox refresh which is not a full sandbox, the below script needs to be run by following the below steps:

Click Your Name | Developer Console or navigate to Setup | Develop | Tools and click the Developer Console link.


Click on Debug and select the Open Execute Anonymous Window option from the dropdown menu 

Paste the below script as it is and click Execute:

loan.PostInstallManager.createSeedDataOnInstall();

Run the query mentioned in the earlier section. If the script ran successfully, the query above must return more than 1 row.


The above steps will ensure the necessary seed data is loaded into Sandbox for CL Loan.


RECURRING

4. Package.xml update from Git is deployed into the new org

5. Unpacking of skuid pages (if static resource for Skuid pages is deployed)
6.Data :



(in genesis__Conversion_Mapping_Header__c field value put the ID created in Conversion Mapping header)

CL Product added manually

