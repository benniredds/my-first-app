# Language Guide

The AX programming language is a structured text (ST) programming language complying with IEC 61131-3:2013.

Currently AX does not yet support the complete feature set of the IEC 61131-3. Please refer to the following documentation pages for clarification.

## How to read Syntax Diagrams

The ST documentation uses syntax diagrams to visualize syntactical constructs.

The diagrams are read from left to right along the lines.

![Syntax Diagram](./diagrams/elements.svg "Syntax-Diagram")  
Each of the above lines represents a `rule`. Each `rule` has its name written directly above. In each of the rules in the previous diagram there is a reference to either a token, a keyword or another rule.

A token is a variable string in the programming language, e.g. the number `1234` is an `untyped int`-token and `LINT#1234` is a `typed int`-token. A name like `program_1` is an `identifier`-token.

A keyword is a fixed string, like `FUNCTION` or `PROGRAM`.

To avoid complex diagrams, other rules can be referenced by name as in the `rule_reference` rule, which references the rule `rule_name`.

![Syntax Diagram](./diagrams/constructs.svg "Syntax-Diagram")  
With the diagrams we also show sequences, optional parts, alternatives, repetitions that are repeated at least once and repetitions that can be omitted.

A complete list of syntax rules can be found [here](./09_syntax-reference.md).
