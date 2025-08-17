*** Settings ***
Library  SeleniumLibrary
Library  OperatingSystem
Library  DateTime
Library  String
#Library  Collection
#Library  ExcelLibrary
Resource    ../Utils/RF_CommonWrapper_PO.robot

*** Variables ***
${Time_out}                       60
${Common_Toster_Message}          locator (e.g: xpath)
${Load}                           locator (e.g: xpath)

*** Keywords ***
Click_Element_Until_Enabled
    [Documentation]  Wait Until Element Is Enabled And Then Click Element
    [Arguments]  ${locator}
    set library search order   SeleniumLibrary
    Wait Until Element Is Not Visible   ${Load}       200
    wait until element is enabled   ${locator}    ${Time_out}
    click element   ${locator}

Click_Element_Until_Visible
    [Documentation]  Wait Until Element Is Visible And Then Click Element
    [Arguments]  ${locator}
    set library search order   SeleniumLibrary
    Wait Until Element Is Not Visible   ${Load}       200
    wait until element is visible   ${locator}    ${Time_out}
    click element   ${locator}

Enter_The_Value_Until_Visible
    [Documentation]  Wait Until Element Is Visible And Then Enter The Value
    [Arguments]  ${locator}   ${text}
    set library search order   SeleniumLibrary
    Wait Until Element Is Not Visible   ${Load}       200
    wait until element is visible   ${locator}    ${Time_out}
    input text   ${locator}   ${text}

Page_Should_Contain_The_Element
    [Documentation]  Wait Until Page Should Contains Element
    [Arguments]  ${locator}
    set library search order   SeleniumLibrary
    page should contain element   ${locator}

Page_Should_Contain_The_Data
    [Documentation]   Wait Until Page Should Contains Data
    [Arguments]  ${Text}
    set library search order   SeleniumLibrary
    page should contain    ${Text}

Get_Text_From_The_Element
    [Documentation]   Wait Until Text Should Be Displayed
    [Arguments]  ${locator}
    set library search order   SeleniumLibrary
    wait until element is visible   ${locator}   ${Time_out}
    ${Text}=    get text    ${locator}
    RETURN     ${Text}

Select_The_Iframe
    [Documentation]   Select_The_Iframe
    [Arguments]    ${frame_id}
    select frame   ${frame_id}

Switch_To_MainFrame
    [Documentation]  Back to Main Frame
    unselect frame

Wait_Until_Elements_Are_Visible
    [Documentation]   Wait Until Multiple Elements Are Visible
    [Arguments]    @{Multi_elements}
    FOR  ${element}  IN  @{Multi_elements}
        wait until element is visible    ${element}   ${Time_out}
    END

Wait_Until_Page_Contains_Multiple_Elements
    [Documentation]   Wait Until Page Contains Elements
    [Arguments]    @{Multi_elements}
    FOR  ${element}  IN  @{Multi_elements}
        wait until page contains element   ${element}   ${Time_out}
    END

Page_Should_Contain_Multiple_Text
    [Documentation]   Page Should Contain Multiple Text At  Same Time
    [Arguments]  @{Multi_text}
    FOR  ${text}  IN  @{Multi_text}
        page should contain   ${text}
    END

Page_Should_Contain_Multiple_Element
    [Documentation]   Page Should Contain Multiple Element at  Same Time
    [Arguments]    @{Multi_elements}
    FOR  ${element}  IN  @{Multi_elements}
        page should contain element   ${element}
    END

Selected_Value_Should_Be
    [Arguments]    ${locator}    ${value}
    ${text}=   get text    ${locator}
    should be equal   ${text}  ${value}

Reload_The_Current_Page
    reload page
    sleep   8

Read excel
	[Arguments]	${filepath}	   ${sheetname} 	${rownum}	${columnnum}
	open excel document   ${filepath}	 1                                 # 1 is doc id we can give any number
	get sheet	 ${sheetname}
	${data}=	read excel cell	 ${rownum}	${columnnum}
	RETURN	${data}
	close current excel document

To_Generate_Random_String
    [Arguments] 	${RoleName}
    ${PO_Number}=    Generate random string    5    0123456789
    ${Name}=    Set Variable    ${RoleName}${PO_Number}
    RETURN	${Name}

To_Select_From_List_By_Label
    [Arguments]   ${locator}   ${label}
    sleep   2
    select from list by label   ${locator}  ${label}

To_Select_From_List_By_Value
    [Arguments]   ${locator}   ${value}
    sleep   2
    select from list by value   ${locator}  ${value}

If_The_Element_Is_Visible_Click_The_Element
    [Arguments]   ${element}
    ${present}=     run keyword and return status     element should be visible   ${element}
    run keyword if   ${present}   click_element_until_visible  ${element}

If_The_Element_Is_Visible_Click_The_Element_or_click_next
    [Arguments]   ${element}
    ${present}=     run keyword and return status     element should be visible   ${element}
    run keyword if   ${present}   click_element_until_visible  ${element}
    ...   ELSE    click element    //*[@class='paginate_button page-item next']


Find the data from table
    [Arguments]   ${element}
    ${count}=     get element count    //*[@class='paginate_button page-item ']
    FOR  ${element}  IN RANGE   0   ${count}
        ${result}=  run keyword and return status  wait until element is visible   ${element}
        run keyword if   ${result}   exit for loop
        ...     ELSE    click element    //*[@class='paginate_button page-item next']
        sleep  3
    END

To_Accept_The_Alert
    handle alert  ACCEPT

Verify the success message
    [Arguments]   ${element}
    ${present}=     run keyword and return status     wait until element is visible   ${element}  ${Time_out}
    run keyword if   ${present}   log   "message displayed"
    ...   ELSE    log  "message not displayed"

Log and log to console
    [Arguments]                          ${CostumMessage}
    Log                                  ${CostumMessage}
    Log to Console                       ${CostumMessage}
    Log Result To Excel                  ${CostumMessage}

Verify_Toaster_Message
    [Arguments]    ${ExpectedMessage}=None
    ${is_visible}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${Common_Toster_Message}    10
    Run Keyword If    '${is_visible}'=='False'          log                     ⚠️ Success or Failure Message not displayed
    Run Keyword If    '${is_visible}'=='False'          Log to Console          ⚠️ Success or Failure Message not displayed
    Run Keyword If    '${is_visible}'=='False'          Log Result To Excel     ⚠️ Success or Failure Message not displayed
    Set Global Variable               ${Message_Content_Value}             ${Common_Toster_Message}
    Set Global Variable               ${is_visible}                        ${is_visible}
    Set Global Variable               ${ExpectedMessage}
    Run Keyword If    '${is_visible}'=='True'           Run Keyword And Ignore Error        Log_Message

Log_Message
    wait until element is visible           ${Message_Content_Value}   ${Time_out}
    ${Message}=    get text                 ${Message_Content_Value}
    Set Global Variable                     ${ToastMessage}                        ${Message}
    Run Keyword If                          '${ExpectedMessage}' in '${Message}'        Log and log to console                  ✅ ${Message}
    Run Keyword If                          not '${ExpectedMessage}' in '${Message}'    Log and log to console                  ⚠️ ${Message}
    Click_Element_Until_Visible             ${Common_Toster_Message}
    Wait Until Element Is Not Visible       ${Common_Toster_Message}   ${Time_out}

Verify_Elements_Present
    [Arguments]                                 @{Elements}
    ${any_not_visible}=                         Set Variable      False
    FOR      ${Element}   IN                    @{Elements}
        ${is_visible}=    Run Keyword And Return Status    wait until element is visible    ${Element}    2
        Run Keyword If    not ${is_visible}      log to console              Element Not Visible: ${Element}
        Run Keyword If    not ${is_visible}      Set Variable      ${any_not_visible}    True
    END
    Run Keyword If    not ${any_not_visible}     Log Result To Excel        ✅ All elements are visible
    Run Keyword If    ${any_not_visible}         Log Result To Excel        ❌ Some elements are missing

Get_Attribute_Of_Element
    [Arguments]                                 ${Element}
    ${Name_Of_The_Field}=    Get Element Attribute      ${Element}          id
    Set Global Variable                    ${Name_Of_The_Field}             ${Name_Of_The_Field}

Get_Element_Text
    [Arguments]       ${Content_Location}
    wait until element is visible           ${Content_Location}
    ${Text}=    get text     ${Content_Location}
    Set Global Variable             ${Text}    ${Text}

Generate random_number
    ${random_number}=               Evaluate    str(random.randint(100000, 999999))
    Set Global Variable             ${random_number}    ${random_number}

Select_From_Input_Field_By_Value
    [Arguments]     ${Field}      ${Value}
    Wait Until Element Is Not Visible   ${Load}       200
    Click_Element_Until_Visible         ${Field}
    Enter_The_Value_Until_Visible       ${Field}      ${Value}
    Sleep  3
    Click_Element_Until_Visible         (//*[@role='option'])//*[normalize-space()='${Value}']

Log Result To Excel
    [Arguments]          ${Actual_Result}
    log_text_to_excel    ${Actual_Result}

Get Current URL
    ${url}=    Get Location
    Log and log to console    The current URL is: ${url}

Check naviagation
    [Arguments]          ${Title}
    ${is_visible}=    Run Keyword And Return Status    wait until element is visible    ${Title}    5
    Run Keyword If    ${is_visible}      Log and log to console    ✅ Opening "${Title}" popup is success
    Run Keyword If    not ${is_visible}      Log and log to console    ❌ Opening "${Title}" popup is Fail

Check Close
    [Arguments]          ${Title}
    ${is_visible}=    Run Keyword And Return Status    Element Should Not Be Visible    ${Title}    5
    Sleep             2
    Run Keyword If    ${is_visible}      Log and log to console    ❌ Popup "${Title}" is not closed
    Run Keyword If    not ${is_visible}      Log and log to console     ✅ Closing "${Title}" is success

Check element removed
    [Arguments]          ${Title}
    ${is_visible}=    Run Keyword And Return Status    Element Should Not Be Visible    ${Title}    5
    Sleep             2
    Run Keyword If    ${is_visible}      Log and log to console    ⚠️ "${Title}" is removed
    Run Keyword If    not ${is_visible}      Log and log to console    ⚠️ "${Title}" is not removed

*** Keywords ***
Get_Data_In_Field
    [Arguments]    @{Location_Of_The_Field}
    ${Field_Data}=    Evaluate    {}    # Initialize empty dictionary
    FOR    ${Content_Location}    IN    @{Location_Of_The_Field}
        Wait_Until_Elements_Are_Visible    ${Content_Location}
        ${Data_In_Field}=    Get Value    ${Content_Location}
        ${Field_ID}=    Get Element Attribute    ${Content_Location}    id
        Log                                     ${Field_ID} = ${Data_In_Field}
        Log to Console                          ${Field_ID} = ${Data_In_Field}
        Log Result To Excel                     ${Field_ID} = ${Data_In_Field}
    END

Log_buffer_time
    ${start}=    Get Time    epoch
    Wait Until Element Is Not Visible   ${Load}       200
    ${end}=      Get Time    epoch
    ${duration}=    Evaluate    ${end} - ${start}
    Log and log to console    ⏱️ Bufferd for ${duration} seconds

Switch_To_Tab
    [Arguments]    ${index}
    ${handles}=    Get Window Handles
    ${count}=    Get Length    ${handles}
    Should Be True    ${index} < ${count}    Invalid tab index: ${index} (Available: ${count})
    Switch Window    ${handles[${index}]}
Wait_Until_New_Tab_Is_Open
    ${initial_tabs}=            Get Window Handles
    ${initial_count}=           Get Length    ${initial_tabs}
    FOR  ${i}  IN RANGE   0   ${Time_out}
        Run Keyword If    ${initial_count} == 2    Exit For Loop
        ${initial_tabs}=         Get Window Handles
        ${initial_count}=    Get Length    ${initial_tabs}
        Sleep    1s
    END
    Run Keyword If    ${initial_count} != 2      Log and log to console    ❌ New tab did not open in ${Time_out} seconds

    Run Keyword If    ${initial_count} == 2      Log and log to console    ✅ New tab opened successfully
    Set Global Variable         ${initial_count}            ${initial_count}



Get time taken
    [Arguments]             ${Element}
    ${TimeTaken}      Set Variable     0
    FOR  ${i}  IN RANGE   0   200
        ${is_visible}=      Run Keyword And Return Status       wait until element is visible           ${Element}          1
        Run Keyword If      ${is_visible}       Set Global Variable         ${TimeTaken}        ${i}
        Run Keyword If      ${is_visible}       Log and log to console      🔄Time taken to load the element is: ${TimeTaken} seconds
        Run Keyword If      ${is_visible}       Exit For Loop
    END


Verify Text and log
    [Arguments]     ${Expected}=None
    ${is_match}=    Evaluate    '${Expected}' in '${Text}'
    Run Keyword If    ${is_match}    Log and log to console    ✅ ${Text}
    Run Keyword If    not ${is_match}    Log and log to console    ⚠️ ${Text}


Log If Element Not Visible
    [Arguments]     ${locator}
    ${is_visible}=  Run Keyword And Return Status  Element Should Be Visible  ${locator}
    Run Keyword If  not ${is_visible}  Log  WARN  ${locator} is not visible!!
    Run Keyword If  not ${is_visible}  Log to Console  WARN  ${locator} is not visible!!
    Run Keyword If  not ${is_visible}  Log Result To Excel  WARN  ${locator} is not visible!!

Capture Page Title
     [Arguments]     ${locator}
     ${page_title}=  Get Text  ${locator}
     Log                      ${page_title} Page loaded successfully
     Log to Console           ${page_title} Page loaded successfully
     Log Result To Excel      ${page_title} Page loaded successfully

Scroll_Bottom
    Execute JavaScript                 window.scrollTo(0, document.body.scrollHeight)

Scroll Into View Element
    [Documentation]   Scroll_Element_Into_View
    [Arguments]         ${locator}
    sleep   10
    Scroll Element Into View   ${locator}

Multi_Select_From_List
    [Arguments]    ${Element}    @{Values}
    Click_Element_Until_Visible    ${Element}
    FOR    ${item}    IN    @{Values}
        Enter_The_Value_Until_Visible    //*[@aria-label="multiselect-search"]    ${item}
        Sleep    1
        Click_Element_Until_Visible      //li[div[normalize-space(text())='${item}']]
    END