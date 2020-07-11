@echo off
setlocal enabledelayedexpansion
echo Associate the following filetypes with "sourcecode"...
REM assoc .c=sourcecode
echo assoc .c=sourcecode
reg add HKCU\SOFTWARE\Classes\.c /v "" /t REG_SZ /d "sourcecode" /f
REM assoc .h=sourcecode
echo assoc .h=sourcecode
reg add HKCU\SOFTWARE\Classes\.h /v "" /t REG_SZ /d "sourcecode" /f
REM assoc .cpp=sourcecode
echo assoc .cpp=sourcecode
reg add HKCU\SOFTWARE\Classes\.cpp /v "" /t REG_SZ /d "sourcecode" /f
REM assoc .hpp=sourcecode
echo assoc .hpp=sourcecode
reg add HKCU\SOFTWARE\Classes\.hpp /v "" /t REG_SZ /d "sourcecode" /f
REM assoc .sh=sourcecode
echo assoc .sh=sourcecode
reg add HKCU\SOFTWARE\Classes\.sh /v "" /t REG_SZ /d "sourcecode" /f
REM assoc .bb=sourcecode
echo assoc .bb=sourcecode
reg add HKCU\SOFTWARE\Classes\.bb /v "" /t REG_SZ /d "sourcecode" /f
REM assoc .rc=sourcecode
echo assoc .rc=sourcecode
reg add HKCU\SOFTWARE\Classes\.rc /v "" /t REG_SZ /d "sourcecode" /f
REM assoc .patch=sourcecode
echo assoc .patch=sourcecode
reg add HKCU\SOFTWARE\Classes\.patch /v "" /t REG_SZ /d "sourcecode" /f
REM assoc .tcl=sourcecode
echo assoc .tcl=sourcecode
reg add HKCU\SOFTWARE\Classes\.tcl /v "" /t REG_SZ /d "sourcecode" /f
REM assoc .py=sourcecode
echo assoc .py=sourcecode
reg add HKCU\SOFTWARE\Classes\.py /v "" /t REG_SZ /d "sourcecode" /f
REM assoc .rb=sourcecode
echo assoc .rb=sourcecode
reg add HKCU\SOFTWARE\Classes\.rb /v "" /t REG_SZ /d "sourcecode" /f
echo.

echo Associate the following filetypes with "txtfile"...
REM assoc .csp=txtfile
echo assoc .csp=txtfile
reg add HKCU\SOFTWARE\Classes\.csp /v "" /t REG_SZ /d "txtfile" /f
REM assoc .txt=txtfile
echo assoc .txt=txtfile
reg add HKCU\SOFTWARE\Classes\.txt /v "" /t REG_SZ /d "txtfile" /f
REM assoc .log=txtfile
echo assoc .log=txtfile
reg add HKCU\SOFTWARE\Classes\.log /v "" /t REG_SZ /d "txtfile" /f
echo.

echo Create registry association for "sourcecode" to gvim.exe...
REM reg add HKCU\SOFTWARE\Classes\sourcecode\shell\open\command /v "" /t REG_SZ /d "\"<full path to gvim.exe>\" --remote-tab-silent \"%%1\"" /f
reg add HKCU\SOFTWARE\Classes\sourcecode\shell\open\command /v "" /t REG_SZ /d "\"C:\tools\neovim\Neovim\bin\nvim-qt.exe\" --servername SOURCEVIM --remote-tab-silent \"%%1\"" /f
echo.

echo Create registry association for "txtfile" to gvim.exe...
REM reg add HKCU\SOFTWARE\Classes\sourcecode\shell\open\command /v "" /t REG_SZ /d "\"<full path to gvim.exe>\" --remote-tab-silent \"%%1\"" /f
reg add HKCU\SOFTWARE\Classes\txtfile\shell\open\command /v "" /t REG_SZ /d "\"C:\tools\neovim\Neovim\bin\nvim-qt.exe\" --servername TXTVIM --remote-tab-silent \"%%1\"" /f
echo.

pause
