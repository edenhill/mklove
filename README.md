mklove - not autoconf
=====================

mklove provides an auto-configuration and build environment for C/C++
applications and libraries.

It aims to be a lightweight alternative to the overly bloated autoconf.

mklove has two prongs on its fork:
 * the configure script, and
 * the Makefile base targets

These can be used together or on their own. The configure script provides
standard Makefile variable names in Makefile.config, while Makefile.base
uses these standard names. Other than that there is no special magic
tie between the two and you can use whichever part you like, or both, or none
(which seems pointless).


**NOTE**: mklove is work in progress



Why mklove and not autoconf/automake
------------------------------------
 * I dont want my Makefiles or targets auto generated.
   Why? Because it's hard to debug and it's trivial to write proper targets
   manually. (mklove provides optional standard targets for common operations).
 * The generated makefiles (et.al) from autoconf are usually larger than the
   sum of all source code for smaller projects. This is ridicolous.
 * autoconf is declarative, mklove is imperative, this allows fine grained
   and natural control flow that follows your line of thought.
 * I dont want to spend my time watching configure test for things that
   have been true since 1970. "checking for size of char... 1 byte".


Base design requirements for mklove
-----------------------------------
 * I want portability to be taken care of for me.
 * I want to understand the output files of configure:
    Makefile.config and config.h have no targets or logic, they only contain
    variable and #define assignments.
 * I want Makefile.config variables and config.h to match, and they do.
   WITH_FOOLIB will be defined in both files (to 1 in config.h,
   and y in Makefile)
 * I want configure checks to be reusable, in mklove they are separate
   module files that you can add as you see fit to your program.
 * Module files are automatically download on use if not present locally.
 * **Dont stop on each error**; run as many checks as possible then present me
   the fatal failures when done
 * Suggest to me what packages to install to fix a failure.
 * Be plug-in compatible with the beast.

Hip features
------------
 * Colored output, find errors quickly.
 * `./configure --reconfigure` reruns configure with the same arguments
   as the last run.
 * Will download mklove modules if necessary.


Checks produce the following output
-----------------------------------
 * Make variable with default value set to y or n, e.g:
   WITH_LIBFOO=y
 * Config define with default value set to 1 or 0
   WITH_LIBFOO=1


Modules
-------

Non-builtin modules are stored in a separate repository at
https://github.com/edenhill/mklove-modules and are downloaded automatically
when required.


Instructions
------------

````
# Copy the mklove directory to your projects top directory:
cd myproject
cp -r ...../mklove .

# Move configure base script
mv mklove/configure .

# Add your own options and checks by creating a configure.<projname> file:
emacs configure.myproject

# Run
./configure
````



See `mklove/modules` for a builtin modules providing options and checks.
