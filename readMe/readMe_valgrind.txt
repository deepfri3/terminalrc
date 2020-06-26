
./pmiApp_x86 -ldebug | tee console_log_$(date +%Y%m%d)_$(date +%H%M%S).log
./pmiApp_x86 -ldebug | tee console_log_$(date +%Y%m%d).log
./pmiApp_x86 -ldebug | tee console_log.log

valgrind --tool=memcheck --leak-check=full --track-origins=yes --xml=yes --xml-file=pmiApp_ValgrindOut_$(date +%Y%m%d)_$(date +%H%M%S).xml --time-stamp=yes ./pmiApp_x86 -ldebug | tee pmiApp_console_$(date +%Y%m%d)_$(date +%H%M%S).log

valgrind --tool=memcheck --leak-check=full --track-origins=yes --xml=yes --xml-file=pmiApp_ValgrindOut_GB.xml --time-stamp=yes ./pmiApp_x86 -ldebug | tee pmiApp_console_GB.log

valgrind --tool=memcheck --leak-check=full --track-origins=yes --log-file=pmiApp_valgrind_$(date +%Y%m%d)_$(date +%H%M%S).log --time-stamp=yes ./pmiApp_x86

valgrind --tool=memcheck --leak-check=full --track-origins=yes --log-file=pmiApp_valgrind_$(date +%Y%m%d)_$(date +%H%M%S).log --time-stamp=yes ./pmiApp_x86 -ldebug | tee pmiApp_console_$(date +%Y%m%d)_$(date +%H%M%S).log

valgrind --tool=memcheck --leak-check=full --track-origins=yes --log-file=pmiApp_valgrind_GB.log --time-stamp=yes ./pmiApp_x86 -ltrace | tee pmiApp_console_GB.log
valgrind --tool=memcheck --leak-check=full --track-origins=yes --log-file=pmiApp_valgrind.log --time-stamp=yes ./pmiApp_x86 -ltrace | tee pmiApp_console.log
valgrind --tool=memcheck --leak-check=full --track-origins=yes --log-file=pmiApp_valgrind.log --time-stamp=yes ./pmiApp_x86 | tee pmiApp_console.log

valgrind --tool=callgrind -v --dump-before=KonqMainWindow::slotReload konqueror


valgrind --tool=callgrind konqueror
When the Konqueror window is shown, press the 'Force Dump' Toolbar button in KCachegrind. Now, when you move the mouse into the Konqueror window, you will see Konqueror freezing (no update) for a few seconds. And "magically", KCachegrind will load the first profile data file of the current konqueror run. For this to work, Callgrind can be controlled from the outside. This is also possible with the supplied script callgrind_control. E.g. to trigger dumping of any profile data up to now, run

   callgrind_control -d
