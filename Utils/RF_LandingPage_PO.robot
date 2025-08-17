*** Settings ***
Resource    ../Utils/RF_CommonWrapper_PO.robot

*** Variables ***
####### Elements  ########
${Browser}=              chrome
${QC_Url}=               url
${Stage_Url}=            url
${Username_textbox}=     locator (e.g: xpath)
${Password_textbox}=     locator (e.g: xpath)
${Signin_button}=        locator (e.g: xpath)
${Company_logo}=         locator (e.g: xpath)
${Log_Out_Icon}=         locator (e.g: name)
${Iframe_id}=            locator (e.g: id)


####### Test Data  ########
${Stage_User_name}=   testrf
${Stage_Password}=    testrf@7777
${QC_User_name}=      NivethaManoharan_QA
${QC_Password}=       rf@8888


*** Keywords ***
Launch_The_Browser_and_Log_in
    open browser   about:blank      ${Browser}
    maximize browser window
    Log_Into_Stage

Log_Into_Stage
    set library search order       SeleniumLibrary
    go to      ${QC_Unified_Url}
    sleep      5
    enter_the_value_until_visible   ${Username_textbox}    ${QC_User_name}
    sleep      2
    enter_the_value_until_visible   ${Password_textbox}    ${QC_Password}
    sleep      2
    click_element_until_visible     ${Signin_button}
    sleep      2
    Verify_Toaster_Message              Login successful
#    wait until page contains element   ${Company_logo}

Log_Out_From_App
    click_element_until_visible   ${Log_Out_Icon}
    Wait_Until_Elements_Are_Visible  ${Signin_button}

Switch_To_Frame
    Select_The_Iframe   ${Iframe_id}

Close_The_Browser
    close all browsers

