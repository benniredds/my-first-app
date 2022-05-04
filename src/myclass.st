//NAMESPACE esempio

CLASS myclass
    VAR //default protected which means that they can be access from 
        myStaticInt : INT;
    END_VAR

    VAR PUBLIC
        mypublic : INT;
    END_VAR

    VAR INTERNAL // can be access into the same namespace. If I do not have namespace, it is public.
        myInternal: INT;
    END_VAR

METHOD PUBLIC GetStaticInfo : INT
    GetStaticInfo:=myStaticInt;
END_METHOD

END_CLASS
