# Comments

Comments support you in clarification of certain parts of your code.

## Example

```iecst
(* declaration of a program *)
PROGRAM SampleProgram /* name of the program */
    VAR_TEMP // temp variable declarations
        a (* declaration of variable a *): INT;
        b : INT;
    END_VAR (*end of variable declaration*)
    b := 5; // assigns 5 to b
    a := b + 1; // assigns b+1 (=6) to a
END_PROGRAM
```

```sh
COMMENT
    : '//' <all characters until new line>
    | '(*' <any character> '*)'
    | '/*' <any character> '*/' ;
```

Comments may be declared anywhere between tokens, identifiers or numbers in the ST language.

> TIP
>
> A comment does not contribute to the execution of the program, nor to its memory layout or any other property of the runtime environment. It is skipped by the ST compiler.
