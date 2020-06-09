# Lua C Interop Libs


350137278@qq.com


## Build for Windows

Open c_lua-interop/msvc/luawin32/luawin32.sln with vs2015, build all.


## Build for Linux

INSTALLDIR=/path/to/c_lua-interop/libs


- lua-5.3.5

[lua](http://troubleshooters.com/codecorn/lua/lua_c_calls_lua.htm)


    $ make linux test && make install INSTALL_TOP=${INSTALLDIR}


- lua-cjson-2.1.1

[lua-cjson](https://www.kyne.com.au/~mark/software/lua-cjson-manual.html)


    $ make -e PREFIX=${INSTALLDIR}

    $ cp cjson.so ${INSTALLDIR}/lib/lua/5.3/
