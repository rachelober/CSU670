Project 2: Double or Nothing

Included in this release are the following files:

/script/README/

    This is the current file, which describes the contents of this project release and how to run the included code.pl file.

/memos/task1.html

    Answer to task 1 in problem set in HTML memo format.

/memos/task2.html
    
    Answer to task 2 in problem set in HTML memo format.

/memos/task2a.html

    Answer to task 2a in problem set in HTML memo format.
    
/script/code.pl

    The written code for task 3. The code accepts a file specified by the user in XML format. code.pl then loads the given xmml file in an array for manipulation to occur. The program then determines of the aircraft entry is of the axis or allies and if it had an image attribute defined. The program then loads the array into a temporary file, deletes the file given by the user and renames the temporary file to the original filename.

	Usage:

    From the /script/ directory:
	$ perl code.pl <filename>

/script/compile
    
    This is a dummy file. When executing the bash script as "bash compile" it will print a message to the screen alerting the user that the "run" script will need to be executed. Because our code is written in perl, it is unnecessary to compile it.

    Usage:
    
    From the /script/ directory:
    $ bash compile
    
/script/run

    This is a file that runs the code.pl file. All it does is take the arguement specified from the user and passes it to code.pl.

    Usage:

    From the /script/ directory:
    $ bash run
    
/script/run-tests

    This is our test file. It runs on index.xml as a test case. When /script/run is executed, it takes the user specified xml file, this however will assume a file is located in the /script/ directory.

    Usage:

    From the /script/ directory:
    $ bash run-tests
    
/script/index.xml

    The sample xml file filled with aircraft data used for the test case.
