# Access modifier

An access modifier may be used to restrict or control the visibility of certain code elements.

## Private

The access modifier `PRIVATE` is the most restrictive modifier available. Code elements using this modifier are not accessible by any other [POU](./01_program-structure/2_program-organization-unit.md#program-organization-unit).

> TIP
>
> This access modifier may be applied to the following elements:
>
> - [Method](./01_program-structure/2_program-organization-unit.md#method-declaration)
> - [Static section](./01_program-structure/4_pou-interface.md#static-section)

### Example: Private access modifier

```iecst
CLASS Motor
    VAR PRIVATE
        isRunning : INT;
    END_VAR
END_CLASS
```

## Protected

The access modifier `PROTECTED` allows accessing a member from inside a defining [class](./01_program-structure/2_program-organization-unit.md#class-declaration) and all [subclasses](./02_oop/1_inheritance.md).

> TIP
>
> [Methods](./01_program-structure/2_program-organization-unit.md#method-declaration) and [class fields](./01_program-structure/4_pou-interface.md#static-section) are `PROTECTED` by default if no other modifier is specified.

> TIP
>
> This access modifier may be applied to the following elements:
>
> - Program organization units
> - [Method](./01_program-structure/2_program-organization-unit.md#method-declaration)
> - Variable sections
> - [Static section](./01_program-structure/4_pou-interface.md#static-section)

### Example: Protected access modifier

```iecst
CLASS Motor
    VAR PROTECTED
        displacement : INT;
    END_VAR
END_CLASS
```

## Internal

The access modifier `INTERNAL` allows accessing a [program organization unit](./01_program-structure/2_program-organization-unit.md) only from inside the surrounding [namespace].(/01_program-structure/3_namespaces.md#namespace)

> TIP
>
> This access modifier may be applied to the following elements:
>
> - Program organization units
> - [Class](./01_program-structure/2_program-organization-unit.md#class-declaration)
> - [Method](./01_program-structure/2_program-organization-unit.md#method-declaration)
> - [Interface](./02_oop/2_interfaces.md#interface-declaration)
> - [Function](./01_program-structure/2_program-organization-unit.md#function-declaration)
> - [Function block](./01_program-structure/2_program-organization-unit.md#function-block-declaration)
> - Types
> - [Types](./04_types-and-variables.md#user-defined-data-types)
> - Variable sections
> - [Static section](./01_program-structure/4_pou-interface.md#static-section)

### Example: Internal access modifier

```iecst
NAMESPACE Vehicles
    CLASS INTERNAL Motor
    END_CLASS
END_NAMESPACE
```

In this example, the class _Motor_ may only be used by elements inside the namespace _Vehicle_.

## Public

The access modifier `PUBLIC` is the least restrictive modifier available. Code elements using this modifier are accessible by any other [POU](./01_program-structure/2_program-organization-unit.md#program-organization-unit).

> TIP
>
> This access modifier may be applied to the following elements:
>
> - Program organization units
> - [Program](./01_program-structure/2_program-organization-unit.md#program-declaration)
> - [Class](./01_program-structure/2_program-organization-unit.md#class-declaration)
> - [Method](./01_program-structure/2_program-organization-unit.md#method-declaration)
> - [Function](./01_program-structure/2_program-organization-unit.md#function-declaration)
> - [Function block](./01_program-structure/2_program-organization-unit.md#function-block-declaration)
> - [Interface](./02_oop/2_interfaces.md#interface)
> - Types
> - [Types](./04_types-and-variables.md#user-defined-data-types)
> - Variable sections
> - [Static section](./01_program-structure/4_pou-interface.md#static-section)

> TIP
>
> Members of a [class](./01_program-structure/2_program-organization-unit.md#class-declaration) declared public may be accessed and written from anywhere the class is accessible.

### Example: Public access modifier

```iecst
CLASS Motor
    VAR PUBLIC
        displacement : INT;
    END_VAR
END_CLASS
```
