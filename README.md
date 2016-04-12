# Alternative File API (Swift)

The Alternative File API is an alternative to the Foundation file functions
and methods especially suited for file and directory analysis and basic
file input/output.

## Progress

### Working on:

Objected-oriented API which seeks to be implementation agnostic as in 
fully implemented using originally internal functions now part of the 
public API (no pointers or C functions either)

### Right now:

Currently contains functions and structs originally implemented 
to be used as internal helpers, but they took on a life of their own
so they are included in the public interface.

#### Features

* File/directory information functions
* Directory listing sequence type and generator
* File IO using lines and bytes
* File byte and line sequence types and generators

## License

The Alternative File API (Swift) is released  under the MIT license.

## Author

Michael P. Nitowski <[mpnitowski@gmail.com](mailto:mpnitowski@gmail.com)> 
    (Twitter: [@mikenitowski](https://twitter.com/mikenitowski))
