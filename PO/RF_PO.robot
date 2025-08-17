*** Settings ***
Resource    ../Utils/RF_LandingPage_PO.robot
Resource    ../Utils/RF_CommonWrapper_PO.robot
Resource    ../Test Data/RF_Data.robot

*** Variables ***
###  MAIN MENU ###
${Menu_Bar_Icon}                                            locator (e.g: xpath)
${Dashboard_MenuLink}                                       locator (e.g: xpath)

###  SUB  MENU  ###
${Tools_Tab}                                                locator (e.g: xpath)

*** Keywords ***
Navigate to Tools Tab
     Wait Until Element Is Enabled           ${Tools_Tab}               20
     Click_Element_Until_Visible             ${Tools_Tab}
     sleep     5