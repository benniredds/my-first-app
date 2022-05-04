# Class inheritance

Inheritance relationship between classes is one of the core concepts of object-oriented programming.
It allows one to derive a new class from an already existing one, forming a hierarchy.
This can be useful to add new functionality while being able to reuse existing data structure and logic.

In ST, a class can be derived from **one** other class by using the keyword `EXTENDS`.
Note that deriving from more than one base class (multi-inheritance) is **not** available in ST.

Classes can be annotated with the `FINAL` keyword, which prevents the class from being inherited by other classes. If a final class is extended, an error message is emitted.

If a class `SubClass` extends a class `BaseClass`, the following rules apply:

- `SubClass` inherits _all_ methods and fields of `BaseClass`, except for
  - `PRIVATE` methods/fields
  - `INTERNAL` methods/fields **if** `SubClass` is in a different [namespace](../01_program-structure/3_namespaces.md) than `BaseClass`
- `SubClass` can add additional methods and fields
- Cyclic inheritance chains are forbidden (i.e., a class `A` cannot extend a class `B`, if `B` extends `A` or a subclass of `A`)
- [Overloading](../05_expressions.md#Overloading) across the inheritance hierarchy is allowed

## Basic example

```iecst
CLASS BaseClass
    VAR
        state : INT;    // Available in 'SubClass'
    END_VAR
    VAR PRIVATE
        inner_state : INT;  // Not available in 'SubClass'
    END_VAR
    METHOD Test
        inner_state := 10;
    END_METHOD
    METHOD PRIVATE InnerTest  // Not available in 'SubClass'
        ;
    END_METHOD
END_CLASS

CLASS SubClass EXTENDS BaseClass
    VAR
        additional_state : INT;    // Inherited by 'SubClass'
    END_VAR
    METHOD AdditionalTest
        THIS.Test();    // Access to method of 'BaseClass'
        state := 10;    // Access to fields of 'BaseClass'
        additional_state := 20;
    END_METHOD
END_CLASS

CLASS FINAL SealedSubClass EXTENDS BaseClass
    // 'SealedSubClass' is final and cannot be extended.
END_CLASS
```

## Method overriding

Within an inheritance hierarchy, a method in a subclass may override a public, protected or internal (if in the same namespace) method in its base class or higher base classes, using the `OVERRIDE` keyword. Methods can be overridden multiple times.

Methods can be annotated with the `FINAL` keyword, which prevents the method from being overridden in any subclasses. If a final method is overridden, an error message is emitted.

Since a `PRIVATE` method can't be overridden anyway, annotating it as final is treated as an error.

```iecst
CLASS BaseClass
    METHOD PUBLIC ExampleMethod : INT
        ExampleMethod := 111;
    END_METHOD

    METHOD PUBLIC FINAL SealedMethod
        ; // 'SealedMethod' is final and cannot be overridden in a subclass.
    END_METHOD
END_CLASS

CLASS SubClass EXTENDS BaseClass
    METHOD PUBLIC OVERRIDE ExampleMethod : INT
        ExampleMethod := 222;
    END_METHOD
END_CLASS
```

When performing a call to such a method, the **dynamic type** of the class instance determines which method is invoked.

```iecst
FUNCTION Example
    VAR_EXTERNAL
        baseClassInstance : BaseClass;
        subClassInstance : SubClass;
    END_VAR
    VAR_TEMP
        reference : REF_TO BaseClass;
        result : INT;
    END_VAR
    reference := REF(baseClassInstance);
    result := reference^.ExampleMethod();    // yields 111

    reference := REF(subClassInstance);
    result := reference^.ExampleMethod();    // yields 222
END_FUNCTION
```

## Static vs dynamic binding

Both, [overloading](../05_expressions.md#Overloading) and [overriding](#method-overriding), allow multiple declarations of a method with the same name.
The compiler then decides based on the call context (parameters, class instance) which method is actually called.

However, both features are binding differently:

- [Overloading](../05_expressions.md#Overloading) uses **static** binding, meaning the static type of a class instance determines the set of available methods.
- [Overriding](#method-overriding) uses **dynamic** binding, meaning the dynamic type of a class instance determines which method is called.

In combination with [implicit type conversion](../04_types-and-variables.md#implicit-conversion), complex scenarios can be constructed:

```iecst
FUNCTION Example
    VAR_EXTERNAL
        baseClassInstance : BaseClass;
        subClassInstance : SubClass;
    END_VAR
    VAR_TEMP
        baseClassRef : REF_TO BaseClass;
        subClassRef : REF_TO SubClass;
        result : Int;
    END_VAR
    // static type: BaseClass, dynamic type: BaseClass
    baseClassRef := REF(baseClassInstance);
    result := baseClassRef^.Overloaded(REAL#5.0);   // yields 1
    result := baseClassRef^.Overloaded(INT#3);      // yields 1

    // static type: BaseClass, dynamic type: SubClass
    baseClassRef := REF(subClassInstance);
    result := baseClassRef^.Overloaded(REAL#5.0);   // yields 22
    result := baseClassRef^.Overloaded(INT#3);      // yields 22

    // static type: SubClass, dynamic type: SubClass
    subClassRef := REF(subClassInstance);
    result := subClassRef^.Overloaded(REAL#5.0);    // yields 22
    result := subClassRef^.Overloaded(INT#3);       // yields 333
END_FUNCTION

CLASS BaseClass
    METHOD PUBLIC Overloaded : INT
        VAR_INPUT
            in : REAL;
        END_VAR
        Overloaded := 1;
    END_METHOD
END_CLASS

CLASS SubClass EXTENDS BaseClass
    METHOD PUBLIC OVERRIDE Overloaded : INT
        VAR_INPUT
            in : REAL;
        END_VAR
        Overloaded := 22;
    END_METHOD

    METHOD PUBLIC Overloaded : INT
        VAR_INPUT
            in : INT;
        END_VAR
        Overloaded := 333;
    END_METHOD
END_CLASS
```

## `SUPER` calls

Sometimes it might prove useful when it would be allowed to call a method that is overridden.
One such occurrence is, if you want to add additional functionality before or after the base code.

```iecst
CLASS MotorControl
    VAR
        MotorId: Int;
    END_VAR

    METHOD PUBLIC Start
        // <Code that performs motor startup>
        ;
    END_METHOD

    METHOD PUBLIC Stop
        // <Code that performs motor stop>
        ;
    END_METHOD
END_CLASS
```

Let's say we want to know when a motor is started or stopped. One way of performing this task is to
use a variant of the so-called [decorator pattern](https://en.wikipedia.org/wiki/Decorator_pattern).
Instead of using `MotorControl` directly, use `LoggingMotorControl` that calls into additional
functions before actually performing the starting/stopping of the motor.

```iecst
CLASS LoggingMotorControl EXTENDS MotorControl
    METHOD PUBLIC OVERRIDE Start
        // <Code that runs prior to actual motor startup>
        Logger.LogMotorStart(this.MotorId);
        SUPER.Start();
        // <Code that runs after actual motor startup>
    END_METHOD

    METHOD PUBLIC OVERRIDE Stop
        // <Code that runs prior to actual motor stop>
        Logger.LogMotorStop(this.MotorId);
        SUPER.Stop();
        // <Code that runs after to actual motor stop>
    END_METHOD
END_CLASS

NAMESPACE Logger
    FUNCTION LogMotorStart
        VAR_INPUT motorId: INT; END_VAR
        ;// <Code that performs the logging>
    END_FUNCTION
    FUNCTION LogMotorStop
        VAR_INPUT motorId: INT; END_VAR
        ;// <Code that performs the logging>
    END_FUNCTION
END_NAMESPACE
```

## Abstract classes and abstract methods

Sometimes it is useful to declare a class which can't be instantiated and should only be used as a base class of other classes. This can be achieved by annotating the class as ABSTRACT. An abstract class should have at least one abstract method, which declares the method name, the parameters and the return value but has no concrete implementation (code body). An abstract method may only be declared in an abstract class.

In contrast to an interface, an abstract class may also contain fields and non-abstract methods if necessary.

An abstract class follows the same behavior like non-abstract classes when it comes to inheritance. However, if a non-abstract class is directly derived from an abstract class, it has to override all abstract methods it inherits directly (from the abstract parent class) or indirectly (from the abstract grandparent class and so on), i.e. it has to provide concrete implementation.

For example, there are two variants of motor control, each of which needs its unique code to start or stop the motor. Both variants needs the restart method, which calls their own start and stop methods. In this case, we can declare an abstract base class `MotorControl`:

```iecst
CLASS ABSTRACT MotorControl
    VAR
        MotorId: Int;
    END_VAR

    METHOD PUBLIC ABSTRACT Start END_METHOD
    METHOD PUBLIC ABSTRACT Stop END_METHOD

    METHOD PUBLIC FINAL Restart
        this.Stop();
        this.Start();
    END_METHOD

END_CLASS
```

Now, the MotorControl class cannot be instantiated. And its non-abstract derived classes must implement the methods `Start` and `Stop`, otherwise the compiler will emit an error.

```iecst
CLASS MotorControlVariant1 EXTENDS MotorControl
    METHOD PUBLIC OVERRIDE Start
        ; //Start code for variant 1
    END_METHOD
    METHOD PUBLIC OVERRIDE Stop
        ; //Stop code for variant 1
    END_METHOD
END_CLASS

CLASS MotorControlVariant2 EXTENDS MotorControl
    METHOD PUBLIC OVERRIDE Start
        ; //Start code for variant 2
    END_METHOD
    METHOD PUBLIC OVERRIDE Stop
        ; //Stop code for variant 2
    END_METHOD
END_CLASS
```

Please note the `Restart` method that uses a variant of the [template method](https://en.wikipedia.org/wiki/Template_method_pattern) pattern.

By referring to objects of different concrete classes, an abstract class reference can be used to call different implementations of the abstract method. In this way, polymorphism is achieved.

```iecst
PROGRAM MyProgram
    VAR
        MotorControlVariant1_Inst: MotorControlVariant1;
        MotorControlVariant2_Inst: MotorControlVariant2;
        MotorControlRef: REF_TO MotorControl;
    END_VAR

    MotorControlVariant1_Inst.Start();
    MotorControlVariant2_Inst.Start();

    MotorControlRef:=REF(MotorControlVariant1_Inst);
    MotorControlRef^.Start();   //Calls the start code for variant 1
    MotorControlRef^.Restart(); //Calls the stop and start code for variant 1

    MotorControlRef:=REF(MotorControlVariant2_Inst);
    MotorControlRef^.Start();   //Calls the start code for variant 2
    MotorControlRef^.Restart(); //Calls the stop and start code for variant 2
END_PROGRAM
```
