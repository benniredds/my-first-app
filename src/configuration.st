CONFIGURATION MyConfiguration
    TASK Main(Interval := T#1000ms, Priority := 1);
    TASK task_2(Interval := T#1000ms, Priority := 1);
    TASK task_3(Interval := T#1000ms, Priority := 1);
    PROGRAM P1 WITH Main: MyProgram;
    PROGRAM P2 WITH task_2: MyProgram_2;
    PROGRAM P3 WITH task_3: MyProgram_3;

    VAR_GLOBAL

    END_VAR
END_CONFIGURATION



FUNCTION myfunction_3 : INT
    VAR_INPUT
    myIN_3: INT;
    END_VAR

    ;

END_FUNCTION
