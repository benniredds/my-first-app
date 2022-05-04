PROGRAM MyProgram
    VAR_EXTERNAL

    END_VAR

    VAR
        myclassinstance: myclass;
    END_VAR

    VAR_TEMP

    END_VAR

    myclassinstance.mypublic := 1;
    myclassinstance.GetStaticInfo();
    myclassinstance.myInternal := 1;

    ;
END_PROGRAM
