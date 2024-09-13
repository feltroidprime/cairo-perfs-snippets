### Some Cairo snippets to compare performance of different approaches

Usage : 
```
scarb test --print-resource-usage
```

To filter a specific file : 
```
scarb test --print-resource-usage -f <file_name>
```

#### Suggestion : 

Read the comments in the files. 

### Useful links

Builtins costs :  https://github.com/starkware-libs/cairo/blob/0743470c4a3a72301a7382adc946843f8820f0cb/crates/cairo-lang-runner/src/lib.rs#L136-L152

Libfunc costs : https://github.com/starkware-libs/cairo/blob/546c0d810f9c38969c00872ee974c1842cb2b15f/crates/cairo-lang-sierra-ap-change/src/core_libfunc_ap_change.rs