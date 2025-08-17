*** Settings ***
Library         OperatingSystem
Library         SeleniumLibrary
Library         BuiltIn
Library         String
Resource        ../Utils/Common_Wrapper.robot
Resource        ../PO/Home.robot
Resource        ../PO/Login.robot
#Resource        ../PO/RF_PO.robot

*** Test Cases ***
Verify Login
     [Tags]              Login
     Launch_The_Browser_and_Log_in

Verify Logout
     Log_Out_From_App