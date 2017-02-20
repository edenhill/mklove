mklove - not autoconf
=====================

mklove provides an auto-configuration and build environment for C/C++
applications and libraries.

It aims to be a lightweight drop-in compatible replacement to
the overly bloated autoconf.

mklove has two prongs on its fork:
 * the configure script, and
 * the Makefile base targets

These can be used together or on their own. The configure script provides
standard Makefile variable names in Makefile.config, while Makefile.base
uses these standard names. Other than that there is no special magic
tie between the two and you can use whichever part you like, or both, or none
(which seems pointless).



Why mklove and not autoconf/automake
------------------------------------
 * I dont want my Makefiles or targets auto generated.
   Why? Because it's hard to debug and it's trivial to write proper targets
   manually. (mklove provides optional standard targets for common operations).
 * The generated makefiles (et.al) from autoconf are usually larger than the
   sum of all source code for smaller projects. This is ridiculous.
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
 * Be drop-in compatible with the beast.

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

Missing modules are downloaded automatically when required.

See `mklove/modules` for the available modules.


Instructions
------------

Run the `setup.sh` script from the mklove checkout directory
(not from your project's mklove directory).
Specify your project's top level directory as the only argument to setup.sh:

````
# Go to mklove checkout directory
cd mklove

# Run setup, specify the path to your project
./setup.sh ~/src/myproject

# Answer the questions and let mklove set up itself.

# Go to your project directory
cd ~/src/myproject

# Add your own options and checks by creating a configure.<projname> file.
emacs configure.myproject

# Update modules.
# This copies the required modules to your project's mklove/modules directory
# so that your project can be packaged and shipped with all required
# mklove files.
# Note: --update-modules will overwrite modules in <proj>/mklove.
./configure --update-modules


# Configure your project
./configure

# Build it
make (or whatever)

````



