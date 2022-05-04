NAMESPACE AxUnit

function WriteToArray : UINT
VAR_INPUT
    offset: uINT;
    value: array[*] of BYTE;
end_var
VAR_IN_OUT
    buffer : array[*] of BYTE;
end_var
VAR_TEMP
    index: dint;
end_var
    
    FOR Index := dint#0 TO UPPER_BOUND(value, 1) DO
        IF Index + offset < Upper_bound(buffer, 1) THEN
           buffer[offset + index] := value[index];
        END_IF;
    END_FOR;
    
    WriteToArray := offset + uint#1 + To_uint(UPPER_BOUND(value,1));
end_function


function WriteToArray : uINT
VAR_INPUT
    offset: uINT;
    value: BOOL;
end_var
VAR_IN_OUT
    buffer : array[*] of BYTE;
end_var
VAR_TEMP
    valueArray : array[0..0] of BYTE;
end_var

    valueArray := ToByteArray(value);
    WriteToArray := WriteToArray(offset, valueArray, buffer);

end_function


function WriteToArray : uINT
VAR_INPUT
    offset: uINT;
    value: WORD;
end_var
VAR_IN_OUT
    buffer : array[*] of BYTE;
end_var
VAR_TEMP
    valueArray : array[0..1] of BYTE;
end_var

    valueArray := ToByteArray(value);
    WriteToArray := WriteToArray(offset, valueArray, buffer);

end_function



function WriteToArray : uINT
VAR_INPUT
    offset: uINT;
    value: dword;
end_var
VAR_IN_OUT
    buffer : array[*] of BYTE;
end_var
VAR_TEMP
    valueArray : array[0..3] of BYTE;
end_var

    valueArray := ToByteArray(value);
    WriteToArray := WriteToArray(offset, valueArray, buffer);

end_function

function WriteToArray : uINT
VAR_INPUT
    offset: uINT;
    value: LWORD;
end_var
VAR_IN_OUT
    buffer : array[*] of BYTE;
end_var
VAR_TEMP
    valueArray : array[0..7] of BYTE;
end_var

    valueArray := ToByteArray(value);
    WriteToArray := WriteToArray(offset, valueArray, buffer);

end_function

function WriteToArray : uINT
VAR_INPUT
    offset: uINT;
    value: BYTE;
end_var
VAR_IN_OUT
    buffer : array[*] of BYTE;
end_var
VAR_TEMP
    valueArray : array[0..0] of BYTE;
end_var

valueArray := ToByteArray(value);
    WriteToArray := WriteToArray(offset, valueArray, buffer);

end_function

function WriteToArray : uINT
VAR_INPUT
    offset: uINT;
    value: SINT;
end_var
VAR_IN_OUT
    buffer : array[*] of BYTE;
end_var
VAR_TEMP
    valueArray : array[0..0] of BYTE;
end_var

    valueArray := ToByteArray(value);
    WriteToArray := WriteToArray(offset, valueArray, buffer);

end_function

function WriteToArray : uINT
VAR_INPUT
    offset: uINT;
    value: INT;
end_var
VAR_IN_OUT
    buffer : array[*] of BYTE;
end_var
VAR_TEMP
    valueArray : array[0..1] of BYTE;
end_var
    valueArray := ToByteArray(value);
    WriteToArray := WriteToArray(offset, valueArray, buffer);

end_function

function WriteToArray : uINT
VAR_INPUT
    offset: uINT;
    value: dINT;
end_var
VAR_IN_OUT
    buffer : array[*] of BYTE;
end_var
VAR_TEMP
    valueArray : array[0..3] of BYTE;
end_var

    valueArray := ToByteArray(value);
    WriteToArray := WriteToArray(offset, valueArray, buffer);

end_function


function WriteToArray : uINT
VAR_INPUT
    offset: uINT;
    value: lint;
end_var
VAR_IN_OUT
    buffer : array[*] of BYTE;
end_var
VAR_TEMP
    valueArray : array[0..7] of BYTE;
end_var

    valueArray := ToByteArray(value);
    WriteToArray := WriteToArray(offset, valueArray, buffer);

end_function

function WriteToArray : uINT
VAR_INPUT
    offset: uINT;
    value: USINT;
end_var
VAR_IN_OUT
    buffer : array[*] of BYTE;
end_var
VAR_TEMP
    valueArray : array[0..0] of BYTE;
end_var

    valueArray := ToByteArray(value);
    WriteToArray := WriteToArray(offset, valueArray, buffer);

end_function

function WriteToArray : uINT
VAR_INPUT
    offset: uINT;
    value: uINT;
end_var
VAR_IN_OUT
    buffer : array[*] of BYTE;
end_var
VAR_TEMP
    valueArray : array[0..1] of BYTE;
end_var

    valueArray := ToByteArray(value);
    WriteToArray := WriteToArray(offset, valueArray, buffer);
end_function

function WriteToArray : uINT
VAR_INPUT
    offset: uINT;
    value: udint;
end_var
VAR_IN_OUT
    buffer : array[*] of BYTE;
end_var
VAR_TEMP
    valueArray : array[0..3] of BYTE;
end_var
 
    valueArray := ToByteArray(value);
    WriteToArray := WriteToArray(offset, valueArray, buffer);

end_function

function WriteToArray : uINT
VAR_INPUT
    offset: uINT;
    value: ulint;
end_var
VAR_IN_OUT
    buffer : array[*] of BYTE;
end_var
VAR_TEMP
    valueArray : array[0..7] of BYTE;
end_var

    valueArray := ToByteArray(value);
    WriteToArray := WriteToArray(offset, valueArray, buffer);

end_function

function WriteToArray : uINT
VAR_INPUT
    offset: uINT;
    value: real;
end_var
VAR_IN_OUT
    buffer : array[*] of BYTE;
end_var
VAR_TEMP
    valueArray : array[0..3] of BYTE;
end_var

    valueArray := ToByteArray(value);
    WriteToArray := WriteToArray(offset, valueArray, buffer);

end_function

function WriteToArray : uINT
VAR_INPUT
    offset: uINT;
    value: LREAL;
end_var
VAR_IN_OUT
    buffer : array[*] of BYTE;
end_var
VAR_TEMP
    valueArray : array[0..7] of BYTE;
end_var
    valueArray := ToByteArray(value);
    WriteToArray := WriteToArray(offset, valueArray, buffer);
end_function


/*
function WriteToArray : uINT
VAR_INPUT
    offset: uINT;
    value: time;
end_var
VAR_IN_OUT
    buffer : array[*] of BYTE;
end_var
VAR_TEMP
    valueArray : array[0..7] of BYTE;
    len : uint;
    index: uint;
end_var
     valueArray := ToByteArray(value);
    //WriteToArray := WriteToArray(offset, TO_LWORD(value), uint#8, buffer);
end_function

function WriteToArray : uINT
VAR_INPUT
    offset: uINT;
    value: LTIME;
end_var
VAR_IN_OUT
    buffer : array[*] of BYTE;
end_var
VAR_TEMP
    valueArray : array[0..8] of BYTE;
    len : uint;
    index: uint;
end_var
    ;
    //WriteToArray := WriteToArray(offset, TO_LWORD(value), uint#8, buffer);
end_function

function WriteToArray : uINT
VAR_INPUT
    offset: uINT;
    value: date;
end_var
VAR_IN_OUT
    buffer : array[*] of BYTE;
end_var
VAR_TEMP
    valueArray : array[0..8] of BYTE;
    len : uint;
    index: uint;
end_var
    ;
    //WriteToArray := WriteToArray(offset, TO_LWORD(value), uint#8, buffer);
end_function

function WriteToArray : uINT
VAR_INPUT
    offset: uINT;
    value: ldate;
end_var
VAR_IN_OUT
    buffer : array[*] of BYTE;
end_var
VAR_TEMP
    valueArray : array[0..8] of BYTE;
    len : uint;
    index: uint;
end_var
    ;
    //WriteToArray := WriteToArray(offset, TO_LWORD(value), uint#8, buffer);
end_function

function WriteToArray : uINT
VAR_INPUT
    offset: uINT;
    value: TIME_OF_DAY;
end_var
VAR_IN_OUT
    buffer : array[*] of BYTE;
end_var
VAR_TEMP
    valueArray : array[0..8] of BYTE;
    len : uint;
    index: uint;
end_var
    ;
    //WriteToArray := WriteToArray(offset, TO_LWORD(value), uint#8, buffer);
end_function

function WriteToArray : uINT
VAR_INPUT
    offset: uINT;
    value: LTIME_OF_DAY;
end_var
VAR_IN_OUT
    buffer : array[*] of BYTE;
end_var
VAR_TEMP
    valueArray : array[0..8] of BYTE;
    len : uint;
    index: uint;
end_var
    ;
    //WriteToArray := WriteToArray(offset, TO_LWORD(value), uint#8, buffer);
end_function

function WriteToArray : uINT
VAR_INPUT
    offset: uINT;
    value: DATE_AND_TIME;
end_var
VAR_IN_OUT
    buffer : array[*] of BYTE;
end_var
VAR_TEMP
    valueArray : array[0..8] of BYTE;
    len : uint;
    index: uint;
end_var
    ;
    //WriteToArray := WriteToArray(offset, TO_LWORD(value), uint#8, buffer);
end_function

function WriteToArray : uINT
VAR_INPUT
    offset: uINT;
    value: LDATE_AND_TIME;
end_var
VAR_IN_OUT
    buffer : array[*] of BYTE;
end_var
VAR_TEMP
    valueArray : array[0..8] of BYTE;
    len : uint;
    index: uint;
end_var
    ;
    //WriteToArray := WriteToArray(offset, TO_LWORD(value), uint#8, buffer);
end_function
*/

/*
function WriteToArray : uINT
VAR_INPUT
    offset: uINT;
    value: char;
end_var
VAR_IN_OUT
    buffer : array[*] of BYTE;
end_var
VAR_TEMP
    valueArray : array[0..0] of BYTE;
    len : uint;
    index: uint;
end_var
    valueArray := ToByteArray(value);
    //WriteToArray := WriteToArray(offset, TO_LWORD(value), uint#8, buffer);
end_function

function WriteToArray : uINT
VAR_INPUT
    offset: uINT;
    value: WCHAR;
end_var
VAR_IN_OUT
    buffer : array[*] of BYTE;
end_var
VAR_TEMP
    valueArray : array[0..8] of BYTE;
    len : uint;
    index: uint;
end_var
    ;
    //WriteToArray := WriteToArray(offset, TO_LWORD(value), uint#8, buffer);
end_function

function WriteToArray : uINT
VAR_INPUT
    offset: uINT;
    value: STRING;
end_var
VAR_IN_OUT
    buffer : array[*] of BYTE;
end_var
VAR_TEMP
    valueArray : array[0..254] of BYTE;
    len : uint;
    index: uint;
end_var
    ;
    //WriteToArray := WriteToArray(offset, TO_LWORD(value), uint#8, buffer);
end_function

function WriteToArray : uINT
VAR_INPUT
    offset: uINT;
    value: WSTRING;
end_var
VAR_IN_OUT
    buffer : array[*] of BYTE;
end_var
VAR_TEMP
    valueArray : array[0..65534] of BYTE;
    len : uint;
    index: uint;
end_var
    ;
    //WriteToArray := WriteToArray(offset, TO_LWORD(value), uint#8, buffer);
end_function

*/





FUNCTION ToByteArray :  ARRAY[0..0] of byte
    VAR_INPUT
        value: bool;
    END_VAR
    ToByteArray8(value, ToByteArray);
END_FUNCTION

/*
FUNCTION ToByteArray :  ARRAY[0..0] of byte
    VAR_INPUT
        value: char;
    END_VAR
    ToByteArray8(To_byte(To_usint(value)), ToByteArray);
END_FUNCTION
*/

FUNCTION ToByteArray :  ARRAY[0..0] of byte
    VAR_INPUT
        value: byte;
    END_VAR
    ToByteArray8(value, ToByteArray);
END_FUNCTION

FUNCTION ToByteArray :  ARRAY[0..0] of byte
    VAR_INPUT
        value: SINT;
    END_VAR
    ToByteArray8(to_Byte(value), ToByteArray);
END_FUNCTION

FUNCTION ToByteArray :  ARRAY[0..0] of byte
    VAR_INPUT
        value: USINT;
    END_VAR
    ToByteArray8(to_Byte(value), ToByteArray);
END_FUNCTION

FUNCTION ToByteArray :  ARRAY[0..1] of byte
    VAR_INPUT
        value: WORD;
    END_VAR
    ToByteArray16(value, ToByteArray);
END_FUNCTION

FUNCTION ToByteArray :  ARRAY[0..3] of byte
    VAR_INPUT
        value: dword;
    END_VAR
    ToByteArray32(value, ToByteArray);
END_FUNCTION

FUNCTION ToByteArray :  ARRAY[0..3] of byte
    VAR_INPUT
        value: UDINT;
    END_VAR
    ToByteArray32(TO_DWORD(value), ToByteArray);
END_FUNCTION

FUNCTION ToByteArray :  ARRAY[0..1] of byte
    VAR_INPUT
        value: int;
    END_VAR
    ToByteArray16(TO_WORD(value), ToByteArray);
END_FUNCTION

FUNCTION ToByteArray :  ARRAY[0..1] of byte
    VAR_INPUT
        value: uint;
    END_VAR
    ToByteArray16(TO_WORD(value), ToByteArray);
END_FUNCTION

FUNCTION ToByteArray :  ARRAY[0..3] of byte
    VAR_INPUT
        value: dint;
    END_VAR
    ToByteArray32(TO_DWORD(value), ToByteArray);
END_FUNCTION

FUNCTION ToByteArray :  ARRAY[0..7] of byte
    VAR_INPUT
        value: lint;
    END_VAR
    ToByteArray64(TO_LWORD(value), ToByteArray);
END_FUNCTION

FUNCTION ToByteArray :  ARRAY[0..3] of byte
    VAR_INPUT
        value: REAL;
    END_VAR
    ToByteArray32(TO_DWORD(value), ToByteArray);
END_FUNCTION

FUNCTION ToByteArray :  ARRAY[0..7] of byte
    VAR_INPUT
        value: LWORD;
    END_VAR
    ToByteArray64(value, ToByteArray);
END_FUNCTION

FUNCTION ToByteArray :  ARRAY[0..7] of byte
    VAR_INPUT
        value: ULINT;
    END_VAR
    ToByteArray64(TO_LWORD(value), ToByteArray);
END_FUNCTION

FUNCTION ToByteArray :  ARRAY[0..7] of byte
    VAR_INPUT
        value: LREAL;
    END_VAR
    ToByteArray64(TO_LWORD(value), ToByteArray);
END_FUNCTION

/*
FUNCTION ToByteArray :  ARRAY[0..7] of byte
    VAR_INPUT
        value: time;
    END_VAR
    
    ToByteArray64(TO_LWORD(value), ToByteArray);
END_FUNCTION
*/

{inline}
FUNCTION ToByteArray64
    VAR_INPUT
        value: LWORD;
    END_VAR
    VAR_IN_OUT
        arr :  ARRAY[0..7] of BYTE;
    END_VAR
    
    arr[0] := TO_BYTE(SHR(value, UINT#56));
    arr[1] := TO_BYTE(SHR(value, UINT#48));
    arr[2] := TO_BYTE(SHR(value, UINT#40));
    arr[3] := TO_BYTE(SHR(value , UINT#32));
                      
    arr[4] := TO_BYTE(SHR(value , UINT#24));
    arr[5] := TO_BYTE(SHR(value , UINT#16));
    arr[6] := TO_BYTE(SHR(value , UINT#8));
    arr[7] := TO_BYTE(value);
END_FUNCTION

{inline}
FUNCTION ToByteArray32
    VAR_INPUT
        value: DWORD;
    END_VAR
    VAR_IN_OUT
        arr :  ARRAY[0..3] of BYTE;
    END_VAR
    
    arr[0] := TO_BYTE(SHR(value, UINT#24));
    arr[1] := TO_BYTE(SHR(value, UINT#16));
    arr[2] := TO_BYTE(SHR(value, UINT#8));
    arr[3] := TO_BYTE(value);
END_FUNCTION

{inline}
FUNCTION ToByteArray16
    VAR_INPUT
        value: WORD;
    END_VAR
    VAR_IN_OUT
        arr :  ARRAY[0..1] of BYTE;
    END_VAR
    
    arr[0] := TO_BYTE(SHR(value, UINT#8));
    arr[1] := TO_BYTE(value);
END_FUNCTION

{inline}
FUNCTION ToByteArray8
    VAR_INPUT
        value: BYTE;
    END_VAR
    VAR_IN_OUT
        arr :  ARRAY[0..0] of BYTE;
    END_VAR
    
    arr[0] := value;
END_FUNCTION

END_NAMESPACE