# Namespace

Namespaces combine a number of language elements to a single entity. By using namespaces you may structure your code in separate scopes and isolate them from one another.

Every language element is part of a namespace.
Any element which does not have an enclosing namespace is implicitly part of the invisible _global_ namespace.

## Declaring a namespace

A new namespace is declared using the keywords `NAMESPACE` and `END_NAMESPACE`.

```iecst
NAMESPACE Vehicle

END_NAMESPACE
```

![Syntax Diagram](./../diagrams/namespaceDeclaration.svg "Syntax-Diagram")

> TIP
>
> A namespace may contain the following language elements:
>
> - [Namespace](#namespace)
> - [Function](2_program-organization-unit.md#function-declaration)
> - [Function](2_program-organization-unit.md#function-block-declaration)
> - [Class](2_program-organization-unit.md#class-declaration)
> - [Interface](../02_oop/2_interfaces.md#interface-declaration)
> - [Type](./../04_types-and-variables.md#user-defined-data-types)

### Example: Namespace declaration

```iecst
NAMESPACE Vehicle
    CLASS Truck

    END_CLASS
END_NAMESPACE
```

## Nesting of namespaces

Namespaces may be nested to an arbitrary depth. Meaning, a namespace may contain another namespace.

```iecst
NAMESPACE Outer
    NAMESPACE Inner

    END_NAMESPACE
END_NAMESPACE
```

Instead of textually nesting namespaces, you may also use a fully qualified name using '`.`' to separate individual namespaces.
The following declaration is entirely identical to the one above and declares two namespaces, one of which is _Outer_ and the other is _Inner_.

```iecst
NAMESPACE Outer.Inner

END_NAMESPACE
```

## Extending a namespace

A namespace may be declared multiple times. Each individual declaration contributes to the same namespace, which allows you to add new elements to an already existing namespace.

```iecst
NAMESPACE Math
    FUNCTION Abs : INT
        ;
    END_FUNCTION
END_NAMESPACE

NAMESPACE Math
    FUNCTION Floor : INT
        ;
    END_FUNCTION
END_NAMESPACE

FUNCTION Caller
    Math.Abs();
    Math.Floor();
END_FUNCTION
```

> TIP
>
> Splitting namespaces is possible not only within a single file, but also among multiple files.

## Using a namespace

The `USING` keyword may be used to reference a declared namespace. This allows you to use the contained functionality and types, without fully qualifying each element of the namespace.

This directive may appear:

- Anywhere in a source code file but outside any declaration. This makes the directive valid for the whole file
- In any namespace, but before any other declarations in this namespace
- In any program, but before any other declarations or statements
- In any class, but before any other declarations or statements
- In any method, after the return type, but before any other declarations or statements
- In any function, after the return type, but before any other declarations or statements

> TIP
>
> The scope of a _using_ directive is limited to the file in which it appears.

### Example: Using directive

```iecst
NAMESPACE Math
    FUNCTION Abs : INT
        ;
    END_FUNCTION
END_NAMESPACE

FUNCTION Caller
  USING Math;
    Abs(); // You don't have to fully qualify the access to the function.
END_FUNCTION
```

## Accessing members of a namespace

Namespace elements may be accessed from **inside** and **outside** of the namespace where they are declared in.

Accesses outside of a namespace require a qualified access, starting with the name of the namespace followed by a '`.`'.
This qualification may be omitted when accessing from within the namespace.

```iecst
NAMESPACE Math
    FUNCTION Abs : INT
        ;
    END_FUNCTION

    FUNCTION CallWithinNamespace
        Math.Abs();
        Abs();     // Qualification of namespace can be omitted.
    END_FUNCTION
END_NAMESPACE

FUNCTION CallOutsideNamespace
    Math.Abs();
END_FUNCTION
```

> TIP
>
> Alternatively you may use a [using](#using-a-namespace) to simplify namespace accesses.

## Shadowing

Every element declared within a namespace is part of this namespace.
Therefore, namespaces can be used to avoid identifier ambiguities which allows you to declare multiple elements with the same name as long as they are in different namespaces.

```iecst
NAMESPACE First
    FUNCTION Func : INT
        Func := 1;
    END_FUNCTION
END_NAMESPACE

NAMESPACE Second
    FUNCTION Func : INT
        Func := 2;
    END_FUNCTION
END_NAMESPACE

FUNCTION Caller
    First.Func();  // Returns 1
    Second.Func(); // Returns 2
END_FUNCTION
```

This also applies for nested namespaces, where identically named language elements in the inner namespace will _shadow_ the ones on the outer namespaces.

```iecst
NAMESPACE Outer
    FUNCTION Func : INT
        Func := 1;
    END_FUNCTION

    NAMESPACE Inner
        FUNCTION Func : INT
            Func := 2;
        END_FUNCTION
    END_NAMESPACE
END_NAMESPACE

FUNCTION Caller
    Outer.Func();       // Returns 1
    Outer.Inner.Func(); // Returns 2
END_FUNCTION
```
