 **Assignment Cover Letter** **(Group Work)**

 

 

 **![img](https://lh5.googleusercontent.com/dbnM9kncTvNjj9dfXGy4FwUiS71ufAzDf1rZpueRRVqC6PjBgwwszZFCZDUTVrqKXTNC0mU6syfkayL7YqVQwjPIghaDOXPVBHDluIz4AsKnzbsvC6eSPrylhNTRMhbZTW-0Mll5)**

 

**Student Information**:       **Surname**    **Given Names**     **Student ID Number**         

​         

​               1.     **Tandra**        **Vincentius**     **2301894804**

​              2.     **Tanjaya**       **Ravel**         **2301890320**    

​              3.  **Yowen**    **Yowen**    **2301902390**

​      4.  **Santoso**    **William**    **2301890390**

**Course Code**  **: COMP6340**                   **Course Name**            **: Analysis of Algorithms**

 

**Class**       **: L3AC**                         **Name of Lecturer(s)**      **:** **Maria Seraphina Astriani**

 

   **Major**    **: CS**                             

**Title of Assignment**    :                         

Hung-Lang 2

 

**Type of Assignment**    **: Final Project**                             

 

**Submission Pattern** 

 

**Due Date**    **:**  Week 13              **Submission Date**  **:** Week 13  

# Hung-Lang 2 



Group Members:

Vincentius Gabriel Tandra 2301894804

Ravel Tanjaya 2301890320

Yowen 2301902390

William Lucianto Santoso 2301890390





# Introduction

**Background**

We decided to choose a compiler - oriented topic where we are going to create the interpreter for our very own programming language. This programming language is based on a previous project hung - lang a programming language previously developed in Python.



***Problem description***

During our first semester of the Computer Science program we were introduced to the world of programming through the Python programming language, now the 2nd most popular programming language in the world. However, as we moved on to the second semester we were introduced to languages such as Java and C++ which are vastly different from Python. To satisfy two sides of the problem we aim to keep the simplicity of Python while introducing some aspects offered in different programming languages.



*Target/aims (to solve the problem)*

So we decided to create a programming language that is easy to learn (like python) but at the same time also not whitespace sensitive, allowing better formatting and avoiding beginner confusion related to whitespaces. This programming language would act as an educational alternative for beginner programmers that could potentially replace Python as an example as the first language they are going to learn. Our programming language is not optimized for speed or runtime but it is going to remain powerful enough for anyone to learn and use for their programming needs.





# Related works



T.H. Cormen, C.E. Leiserson, R.L. Rivest, Introduction to Algorithms (MIT Press, Cambridge, 1993) - KMP Algorithm (Page 1005).

https://github.com/raveltan/hung-lang

# Proposed method(s)/solution



The interpreter that is created should be created with these specifications:



\- Compiled to native binary or not running in a language specific VM like JVM (which means it is not possible to be done in Java or python as they produce byte-code rather than native, this step is also done to remove installation complexity and remove dependencies)

\- Using a language with a built in Garbage collector (this is to prevent unnecessary work to free the memory which can be hard to track and hard to test on) which means very low level language like C and C + + does not match this requirement.



Languages that is quite popular and matches this criteria are:



\- Go Programming Language

\- Rust

\- Dart



All of these 3 language can be compiled to native code and have some kind of garbage collection



\> Even though rust does not use a GC, it implements a special kind of tracking system to track when a variable gets out of scope and free the memory [*reference](https://doc.rust-lang.org/book/ch04-01-what-is-ownership.html#the-stack-and-the-heap)



Let's take a look at each of this following language and see it's pro and cons:



1. Go



  ***Pros***



  \- Cross compilation

  \- Wide adoption (especially as webserver)

  \- Very fast

  \- Great package management



  ***Cons***



  \- No OOP (not always a bad thing, but case of compiler, it maybe harder to satisfy certain interface implementation rather than extending a class)



2. Rust



​	***Pros***



  \- Cross compilation (even though not as easy as Go)

  \- Wide adoption (especially as system programming language)

  \- Many packages



  **Cons**:



  \- Weird syntax

  \- complicated *foreign function interface* (*FFI*)



3. Dart



  ***Pro***:



  \- Java or C- Like syntax

  \- Great support for functional programming

  \- Null-able support

  \- Wide adoption (flutter only)

  \- Great tooling

  \- Higher level than Go or Rust



***Cons***



  \- No cross compile (will need to use CI to build for different platforms) [*reference](https://github.com/dart-lang/sdk/issues/28617)

  \- No signing support

  \- Not that fast when compared to Go or Rust



After some consideration, especially to maximize efficiency and speed of development, dart is chosen to create the interpreter as:



\- Great tooling for maximum productivity

\- Easy and and robust test system to catch error

\- Great debugger

\- Many syntactic sugar that will help a lot in development

\- Great functional support



In this interpreter implementation, tree walking algorithm will be used rather than implementing a VM that is able to interpret specific bytecode, this is done even though VM has a much faster execution speed ,creating a VM will require too much time and will be too hard to debug. So we decided to do tree walking implementation rather than JIT Compilation with a VM companion.



We will also not use any parser generator in order to fully demonstrate the pratts' algorithm (even though technically it will be more efficient and faster to use a parser generator as it is optimized).



# Implementation



***Formal description of computational problem***

Having chosen Dart as our language of choice and a tree walking algorithm as the chosen method of implementing our interpreter we are going to need to follow the main principles of creating an interpreter, we’ll need to parse the source code, translate it into an intermediate form of code before executing the code created by the Dart compiler. 



 ***Design of Compiler***

First we will go through the phases of an interpreter which are: Lexical analysis, syntax analysis, semantic analysis and then direct execution.



We begin with lexical analysis, to briefly explain this phase, we can simplify lexical analysis as the phase where our code which is a sequence of characters is converted into a sequence of tokens. These tokens will represent the characters using token names and values, the tokens can be separated into different token types such as identifiers, operators, double operators and delimiters. This phase of the interpreter is performed by what is known as a lexer, this lexer is used to check each character and transform them into their corresponding token types. Other features of the lexer include that they remove all whitespace used in the source code. 



Next, we will discuss the parsing method being used in this implementation. The method being used here is known as the Pratt Parser also known as a top down precedence parser. A Pratt parser is a top down parser that works on the system of operator precedence, where the parser will store how important an operator is and uses this to determine which operation should be done first and a top down parser is one where the parser parses the input using the production rules instead of a bottom up parser where the parser uses the input and then deconstructs that input and checks it against the production rules to check for validity.  One reason we chose to do a top down parser is because it is easier to implement than a top down parser. However, there are many other types of top down parsers such as recursive descent parsers and LL parsers so why did we choose to use the Pratt parser? One documented issue of recursive descent parsers are that they suffer from backtracking  which is an issue where the parser has to go through each production rule one by one before arriving at the proper output. Pratt parsing also makes use of what are known as binding powers which are assigned to each token to determine associativity and precedence. An example of what this looks like is humans are able to evaluate the expression 1 + 2 * 3 by understanding that the asterisk binds to 2 and 3 and then the plus symbol binds 1 and the smaller expression. This shows that the asterisk symbol has a higher binding power than the plus symbol and we can do that with all other symbols for the precedence to work.  Pratt parsing also allows for different treatment depending on whether the operator token is in an infix or prefix context. An example would be a = b - c and a = b. Within Pratt parsing, the terminology for handling tokens as a prefix is null denotation and handling tokens as infix as left denotation. So a Pratt parser makes the best out of both the qualities of a recursive descent parser and an operator precedence method and we chose it because it is easy to implement and works very efficiently.

Within this phase, we define the grammar for our programming language and then we use this grammar to put it against the syntax of our code to check for correct syntax. The code is evaluated in the form of an AST or an abstract syntax tree. 

Typically, the next phase of an interpreter would be semantic analysis but we chose to perform this phase of the interpreter by implementing what is known as an evaluator instead. The output of a semantic analyzer is an annotated syntax tree, we chose not to use this implementation and decided that we could evaluate the code in its form after lexing and parsing has been performed. Within our code we also use what are known as entities to represent the values within tokens. Within the evaluator, the values of the code are analysed and checked for any further error outside of syntactic or lexical errors. We then use a class to check and store for variables and identifiers which are then executed within the main function of our program.



# Evaluation

 ***Implementation Details***

The project is composed of many parts, an important part of this project is the idea of using test driven development. In order for us to be able to test every working part of our programming language, we use test cases and run our program against them to check whether our program satisfies these test cases. Separate tests are created for the different parts of the interpreter. For example, our project uses 3 tests for the lexer, parser and evaluator and using the designed test cases we check to see if the program is making the correct checks and if our program passes every test case we can be sure that each of these implemented features will be sure to work. This method of development also allows for easier debugging because we can immediately see the specific type of error the program has encountered. This allows for a better workflow and is much better than using practical testing because there is a chance you miss something within self testing and a bug can be encountered later that could cause problems. 



The interpreter is being compiled to the Dart programming language and so the code for the interpreter’s functionality is written in Dart. The parts of the interpreter are split into different files located in the lib folder of the repository, we will go through the functions of each file. ![img](https://lh3.googleusercontent.com/HSTtP9nY7qM2ZU49gc064ydjMVM-0MijiukXoU8n2jF7wZlawbNyRchY1XUINJzcZXyZCFz9wleP6bVqtacIgBwlbKQ6dThFsw4TMQGJ-OpG_RC_SJOabu52iOC_eey1EcA_iIZI) 

Following the steps of the interpreter, we start with the file **lexer.dart** which contains the code for the lexer of our programming language. Working closely with **lexer.dart** is the **token.dart** file which is a file that contains all of the token types that our language is going to be able to understand and a function that checks if an identifier is a keyword, this is important because we do not want to let users use keywords as their identifier names. 



Within the lexer we test for a few things, our language does not allow the underscore (_) character to be used within identifiers so we must check for it, we need to be able to check for an identifier or keyword, and return the appropriate token for either. We’ll need to check for text characters and numbers as well. 



Once every character within the code has been assigned their token type and values, they are going to be parsed within the **parser.dart** file. We begin by defining the grammar for our programming language.

![img](https://lh4.googleusercontent.com/215o60ObEyOJrYAmvZiG3CY1hora6dvfT2nteYuNJNHyyesQKB8r3vyIQ8b3uCSsfhvCZn5qshVl33gWZULYOZm-xpJWEl9wv8AuX7l3fF9XQ4iqZRyo4blNVWhlxJ6EmCanFMsJ)

We are then going to define the precedence of our operations, and store these values inside an enum, the precedence will then be taken from the index of these values.

![img](https://lh5.googleusercontent.com/SgDtU_KfiXwlvNgFzxCQG4PFAzcSPmkC6cuH9LMT-zLkVrptbk83mto-vjx4L-1yu2IYuJMtyIMEQ-Ha9qCcJyVodpxX-T9Rk3PkBhNwI02DvEtsLQXnEo6uABt-CkIgHcaJqSHa)

We then assign the operating order to each corresponding token type and begin parsing the input from the lexer. First we prepare a function to parse through the prefix and infix expressions, we check for any syntax errors within the code in this phase. Most of the features within the programming language use expressions instead of regular statements, the main difference between a statement and an expression is that statements such as an if statement in another programming language have no return value. However, in our programming language an if statement is actually read by the language as an if expression allowing a more flexible use. Checking the syntax of the code is important because if one part of the syntax is wrong, the entire use of the statement is incorrect and this is reflected in the code, the parser will go through each token and continue to do so if the syntax is correct but will stop once it encounters an error within the code that does not follow the predefined syntax. Within the parsing phase, the code is evaluated in the form of an AST, the structure of this AST is defined in the file **ast.dart**, where the AST is composed of a Node, a Statement and an Expression. The nodes of the AST will contain tokens and statements and expressions will each extend from Node. Within our language, we have multiple types of statements and expressions that will each extend from either Statement of Expression. For our program to properly read all of the written statements or expressions within written code, a written program in our language is evaluated as a collection of statements.



Once the code has been checked by the lexer and parser, we move on to the evaluator located in **evaluator.dart**. Within the evaluator, the expressions written within the code will be evaluated so that the code written will be understood by our language as specific expressions. Within the evaluator some error checking is also being done, since we do not have an isolated semantic analysis phase, a lot of the semantic checking such as missing parameters or improper type assignment. Once all of the keywords, characters, functions and loops have been evaluated the code enters the last phase before being executed. Within the file **system.dart**, we use a map to get and store variables and then set them to be executed. The variable attempts to obtain a value by looking at the value within the parent variable first and if that value is not null, then it will use the parent’s value, otherwise it will not. 

 

Finally we are going to run the code within the main function of our project, **main.dart**, our programming language is able to run in two modes, REPL(Read Eval Print Loop) mode which is defined in the file **repl.dart** which means it will take singular user inputs and then execute and return the result of that input, it looks similar to a command line shell such as Python shell. The other mode that our language can run in is through opening files, our language will open the file, read the contents as a string and then parse and evaluate through the code and return the result. 



***\*Test Run Analysis\****

Through our test driven development design we were able to successfully test multiple cases within the lexer, parser and evaluator processes within our language. 
![img](https://lh6.googleusercontent.com/oJqNlaT6ER0AKl8aQjKpFgSdSBdOoejBlNprmPoqEkeguweAibj7O4yHpumOjaGeasiFKTJTXc3Zr7C2Z0UQgHe4KrtIMq41Pjx6EJTZxKO9h6yexF_tc0sVFJlp9Ev60lntWJPy)

Here is an example of a test case to check whether the number data type is functioning properly within our language located in the test for the evaluator. There are multiple test cases within the whole test and using the IDE we are using for our development we use the built in test feature to run the whole test. If at any point during the test, the program fails a test case, it will immediately stop the test and return the specific error and which test case has been failed. In the case that all test cases have been fulfilled, the test program will exit normally signifying that this part of the programming language works properly.



# Discussions

We had also done some practical coding to show the usages of our programming language. We were able to successfully create some examples of these programs and even some of the algorithms we learnt for our lab assignment.
![img](https://lh5.googleusercontent.com/PbvoCNaQVuoE9D0mUUnFR894BdL_KTs2akTNFNBGIcwp0knPqlmMKCn9tYFyrqODLqmnbYkDQIYpJEkUrStSlXO8UBfXEIbzj_eOHseFqv3meesS5-jifFyX_EXSVPqeEW_HocBL)

An example of that code writes here, this code defines an algorithm that is used to check when two objects, jumping on a number line are going to intersect or not within the same number of jumps. First a function is defined, and then the user’s input is read and the code returns the strings yes or no to signify whether or not the two objects are going to intersect or not. More details of these examples can be seen at our github in **examples/algo** where this specific one is called number-jump with the code and problem defined there. More information about the syntax and workings of our code can be found within the guide section below.



# Conclusion and Recommendation

In conclusion, our interpreted language, Hung-Lang 2 can be considered successful in solving our problem description. We believe that the interface of our programming language is quite easy to learn and boasts the capabilities to be able to be used for programming beginners for their early code. Simpler algorithmic problems that they will be learning within their first couple or so semesters can be done within this code, this language retains our idea of replicating an easier programming language such as python but using a syntax more similar to C. However, that is not to mean our language is all encompassing and powerful either. For example, this is a programming language that would not be able to teach students more advanced concepts such as class design and OOP. With that we believe that our programming language fulfills the needs for our target demographic which are newer programmers allowing for the much needed easier transition from learning easier programming languages such as python to an immediately different and more advanced syntax seen in languages such as Java and C

# Program manual and Installation



**Welcome to Hung-Lang 2**

Hung lang 2 is a programming language that is able to operate in 2 modes:

- REPL (Read Evaluate Print Loop)
- File Read Mode

REPL mode allows you to type the input once at a time, and it will evaluate it for you.

If you want to create a hung script in a file, then you can use file read mode to execute it.



To get started with hung lang, it’s better to try it in REPL mode, to get in REPL mode please type in hung in your terminal, you will see a screen with hung lang 2 and it’s version information.



At this point, you can start typing your command to the REPL,

Let’s start with something simple,



```10 + 10```



This is a simple expression in Hung lang 2, expression is everything that produces a value.

In hung lang 2, expressions are a very important concept, few things that are not expressions in other languages are expressions in hung lang 2, we’ll take a look at this later.



Next we will take a look at the assignment statements, this is a statement (code that does not produce a return value) that will move the value of the right hand side expression to the variable storage.



```var name = ‘hung lang;```



In the above statement we are creating a new variable called name, we can create a variable in hung lang 2 by using the keyword **var** then with the assignment operator (**=**), we can place any expression on the right hand side which will be evaluated for a value and will be placed as the value of the variable.

 

The data that we place there is a string, a string is a collection of characters that is stored in the memory, it is one of the 3 data types available in hung lang 2.



- Boolean (true or false)
- String (list or character written in double quotes)
- Number



Just like in other dynamic languages, if you have declared a language with a certain data type, you can always reassign it with different data types.



For example:

```var a = 10; var a = ‘hello’;```

In other programming languages, this kind of syntax may be invalid as we are using the var keyword when reassigning a value to a variable, but in hung lang 2 this is completely valid.

- We can reassign a variable with different data type
- We **need** to use the var keyword when reassigning a variable



Great, up to this point, we have successfully created our own variable and we have also taken a look at data types in hung.



Now in order to access the data in the variable, we can use the variable name without any keyword, to print the data out, we can do:



```write(a)```



This will print the value of a (a variable name).

Write can also accept infinite amount of parameter,



```write(a,’hello world’)```



This will print out the result of a concatenated with a space and hello world. This is quite handy when working with strings as we do not need to manually add them (this will also auto convert any variable that is not with type of string to string, of course we can do this manually with the str() built in function).



Great, how about reading a value from the stdin (console input)?

We can use 2 alternative:

- read() : read the current console input as a string
- eval(read()) : read the current console input and evaluate its value as a hung lang 2 object.

The main difference between read() and eval(read()) is that, if we want users to input a number directly, it’s easier to use eval(read()) as hung lang will evaluate the value directly so that it can be directly “converted” to the expected type.



For conditions, Hung lang 2 will support logical conditions from mathematics:

- Equals: a == b
- Not Equals: a != b
- Greater than: a > b
- Less than: a<b

And Hung lang 2 also support some logical operators using:

- and(a,b) : return the result of and operation between a and b
- or(a,b) : return the result of or operation between a and b



Usually these conditions are usually going to be used in if and else statements. The if keyword will have condition and the code to be executed if the condition is true, and else keyword that will run if the condition is false. The syntax if and else is:

```if(condition){code to be executed if true}```

```else{code to be executed if false}```



The example for the if and else statement:



```if(or(a == b,a > b)){write(‘a is equal or higher than b’)} ```

```else {write(‘a is smaller than b’)}```



In this example, it will check if variable a is equal or higher to variable b, if it’s not both of them, then it will run the statement inside of the else’s curly braces which in this case is to print “a is smaller than b”.



Function is a block of code which only runs when it is called. You can pass data, known as parameters, into a function. The functions in hung lang 2 will automatically print the returned data as a result. For example we have the following function expression:



```var multiplication = f(a,b){a * b}```



The var multiplication in above has a function in it where it takes two data as parameters which is (a, b), and then it will return the result of the multiply between a and b. So for example if we want to get the result of 10 * 3 then we can call this function by putting the variable name where it has the function in it with the arguments of (a = 10, b = 3). In this case the call expression will be:



```multiplication(10,3)```



Where it will return 30 and automatically print it.



Arrays in hung lang can be used by using some built-in function. To create the array we first need to create a new variable and then put the array function in the right hand side. After creating the array we can use others built-in function to add data into the array, remove value from the array in the specific index, update the value in the array at the specific index, and then get the value of index in the array.The function array will be:

- array(args) : create a new array
- add(array, index, value) : add a new value at specified index
- remove(array, index) : remove a value at specified index
- update(array, index, value) : update the value at specific index
- get(array,index) : get a value of index in array



For example of Arrays, we are going to create new array first with some books in it, in this case we will name it books:

~```var books = array(‘Harry Potter’,’Maze Runner’) ```



The next thing we can do is to add new value into the array using the add function with the argument of the array name, the index, and the value. For this case we will add new book in index 2:         

~ ```add(books,2,’Hunger Games’) ```

And it will return ```[‘Harry Potter’,’Maze Runner’,’Hunger Games’]```



Now, if we want to delete the “Maze Runner” book which is in index 1 of the books array we can do:

~ ```remove(books,1)```

And it will return ```[‘Harry Potter’,’Hunger Games’]```



For example if we want to update the “Hunger Games” book in index 1 into “Hungry Games”:

~ ```update(books,1,’Hungry Games’)```

And it will return ```[‘Harry Potter’,’Hungry Games’]```



For example if we want to get the value in the books array in index 0:

~ ```get(books,0)```

And it will return ```‘Harry Potter’```



Loops in hung lang 2 is already implemented in the built-in function. It has 2 functions which are: 

- each(array, func) to loop through each element of the array 
- for(start,end,increment,func) to run the statement until the start has reached the end. 



The each loop argument will be the element of the array in the each function while in the for loops you can have up to 3 args since there are the start, end, and the increment on each iteration.For example the loop for array that will return all of the value inside of the books array:



```each(books,f(a){write(a)})```



The example of using for loops with the args a,b,c where a = start, b = end, and c = increment:



```for(1,5,1,f(a,b,c){write(a,b,c)})```



The result of the loops above will be:

1   5   1

2   5   1

3   5   1

4   5   1

5   5   1



Conversion of data type can be done with two built-in functions to convert string to number, and data to string.The two function syntax are:

- num(string) : convert string to number return false if fail
- str(data) : convert data to string

With this function it will only return the result, so if you want to convert a number in the variable then you need to reassign it with the function, for example if we want to convert var a that have “10” which is a string into a number:



```var a = ‘10’```

```var a = num(string) ```

 

This will convert the string into a number so you can do:

```a + 1```

And it will return 11, to convert it back into a String then we can use the other function



```var a = str(a)```



Which will return an evaluation error if you try the (a + 1) since you cannot do addition for string.



There are some other built-in function in hung lang 2 that is useful in some cases such as:

- id(data) : return hashcode of object
- isType(a,b) : return if a is the same type with b
- random(max) : return a random number between 0 and max
- len(data) : return the length of string or array
- mod(a,b) : return a mod b



The id(data) function can be used to get hashcode. Hashcode is a number which represents the internal address of an object and it differs from one object to another.



```var a = 10```

```var b = a```

```id(a) == id(b)```



The above code will return true since variable b is pointing to the variable a address. Note that if we declare var b = 10, it won’t return true since it will create a new address which will result in returning a different hashcode. 



isType(a,b) is used to check if the datatype of a is the same as datatype b. So if we want to check if variable a is a number or not then we can try to compare it to a number. The example of the code are:



```var a = 10```

```isType(a,0)```



The code in above will return true since we know that variable a is a number and we compare it to 0 which is another number so it will return true.



random(max) are used when we want to generate a random number from 0 until max. Since we don’t have the argument of min, we would need to do an addition to get the random number that starts from a certain number. For example if we are going to create a dice simulator that generate number from 1 to 6 then the we can do:



```random(6)+1```



The code above will work since random will generate a number from 0 until 5 and then the + 1 will change it to 1 until 6.



len(data) can be used if we want to get the length of a string or an array. This can be used to find how many letters does the string have, and how many values that are inside of the array. For example:



```len(‘Happy New Year’)```

```len(books) ```



The code above for the happy new year has 12 letters but it will actually return 14 since they also count whitespace as a string. For the array it will return how many values right now inside of the array, if you only add 1 book into the array then it will only return 1. 



The last function is modulus which is a function to get the remainder of the euclidean division of one number by another. The example of modulus is:



```mod(3,2)```



Where it will return 1 since 3 divided by 2 equals 1 but it also remains 1.



**Installation**

1. Firstly, head on over to https://github.com/raveltan/hung-lang2/releases and download the latest release version. 

![img](https://lh4.googleusercontent.com/HV3KZ5v6OO5Ol_lhxOVD4dp74D3RAZ-I8d7wtdi2ucC5SBXifVYUSoTVJhR92eFaGp63CxGc615QtiUnYBkPuC_fCz20uquvduT44ny_ktojl0hh_4Ebr7AkNZHLIwpRjV9f6UY4)



1. Move the hung.exe or hung(linux) file to your desired location. It is recommended to place it in a dedicated folder.



Windows Installation



1. For Windows users we recommend downloading Hung Lang 2 through our Windows installer. 
2. Click the Hung.Lang.2.Setup.exe to start downloading the installer right away.
3. Once the download is complete, you can start by running the installer file.
4. Once the installer has started, you may pick the installation folder for Hung Lang 2. It will also ask for the name for the Start Menu folder.

![img](https://lh4.googleusercontent.com/b0fDZkJ1HWZBAKHmxKOgf_yd5r-lqmclN4fLPt7Tih5xelOhnangXRky2dAN2-EpvNk9OxJLDlzCbY_0OPh46Tgm9J-5drWywiV1OtzWwAQsP53M_lMEbq3REWWK5XTIck_VnR3J)

![img](https://lh4.googleusercontent.com/ahrstFjmWBuk3DVU44BuPTikKE7puh9EkWDyUlqLVxkKVIpqJr1Hb1JRjto35WIk79r9IWwCqWzr4qucgi6jf2geySUYuAhiFRJOXGeKqH29NMw11cvIJdeC-Z8MO0xjEaSgULJC)

1. After clicking next, you have the optional additions to create a desktop shortcut or add to PATH variable (recommended).

![img](https://lh6.googleusercontent.com/Hr3pko7WOeCkBuFZKycrDTF_XhUKxztq1jAwNBgUCJ2Jel-yG88U5r1A55rdo6ctGDCsmTn9V9LpNDuHX_GdXK-4UyWjPMOUGGOj-fsZbct_uuivY5shNkwgQNLE_pxJvvV9kY46)

1. After that you can click install to begin the installation of Hung Lang 2.

![img](https://lh5.googleusercontent.com/7qvwVPISODfjSuGd1-EjI68LIV5Iye5yJcfx6GvcUY7SyEEAlf078XAyBPJcTXF6l7E7-BeXPE1PYPfSmV02kUZIznXbDrOSPKUrhH-iqgq8nDDvj9B_Vg2XB7iH1echtDAdqXEo)

1. Once completed you can open Hung Lang 2 from the executable file in the directory it was downloaded or access it directly through your command line or powershell by typing ‘hung’ (if Hung Lang 2 was added to path).

![img](https://lh6.googleusercontent.com/pBmoHSan6IgnmzfdYUrRhMWj8xPEoQqnxE0ekHBbLmaVZ_OR5CtT2O8pH98y54HxPUlHunS9xVQHDMz4G_oAChVdjNDtJx1vZzC0HTKar-7VU1K98q5GPjyI13to3dpN2nnqOdT_)

1. Happy coding!

![img](https://lh3.googleusercontent.com/DkScC1heP4Va4pcrNOeCpcRYfD6G79MlX54s60CFLbJUOhoV98uxlJDLlwMALlZHIHB6N3k41pQ0t7WXvnFl8tEfKnXdvOrgcDl0slrpFV-esdQXZA06s3Fg3J1VfulPuDZpsBMQ)



Linux Installation

Run this on terminal:

https://snapcraft.io/hung

sudo snap install hung --edge