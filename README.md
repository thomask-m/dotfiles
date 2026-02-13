## dotfiles
mine!

run the script to write out the dotfiles to their locations by running this:

```
mkdir -p build && cd build && cmake -DCMAKE_BUILD_TYPE=Release .. && cmake --build . && ./dotfiles --to_home ; cd ..
```
