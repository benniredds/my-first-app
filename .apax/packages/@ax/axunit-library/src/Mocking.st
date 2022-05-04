NAMESPACE AxUnit
NAMESPACE Mocking

    FUNCTION Mock
        VAR_INPUT
            {mandatory}
            mockeeFn:  string;
            {mandatory}
            mockFn:  string;
        END_VAR
        ;
    END_FUNCTION 

    FUNCTION Mock
        VAR_INPUT
            {mandatory}
            mockeeFn:  string;
            {mandatory}
            mockFn:  string;
            payload:  IPayload;
        END_VAR
        ;
    END_FUNCTION 

    INTERFACE IPayload
    END_INTERFACE
    
    FUNCTION GetPayload:IPayload;
    END_FUNCTION

END_NAMESPACE
END_NAMESPACE
