## validate-sources
I 'wget' the website source files, but in production these are copied from the previous step "mv ../"
## test1.sh

i set the version_gui variable to "v0.17.3.0" and clone / zip it / mv/rename back to "v0.17.3.2" (at the end the extracted folder name is renamed from v0.17.3.0 > v0.17.3.2    
Output:
```
ALOT of diffs
```
## test2.sh 

the simplest test, after downloading / extracting all files , i modify wallet2.cpp before the diff comparisons.    
Output:
```
--> Unpacking all...

--> Comparing CLI directories
diff -r yours/monero-source-v0.17.3.2/src/wallet/wallet2.cpp from_website/monero-source-v0.17.3.2/src/wallet/wallet2.cpp
13990a13991
> sussy amogus

--> Comparing GUI directories

```
