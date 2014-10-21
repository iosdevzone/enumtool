enumtool
========

A command line tool to wrap Cocoa constants in Swift enums.

```bash
grep '^extern CFTypeRef kSecAttrAccessible' SecItem.h | awk '{ print $3; }' > ~/Documents/src/enumtool/demo/SecAttrAcessible.txt
```