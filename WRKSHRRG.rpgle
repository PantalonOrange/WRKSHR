**FREE
//- Copyright (c) 2017 Christian Brunner

//- Permission is hereby granted, free of charge, to any person obtaining a copy
//- of this software and associated documentation files (the "Software"), to deal
//- in the Software without restriction, including without limitation the rights
//- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//- copies of the Software, and to permit persons to whom the Software is
//- furnished to do so, subject to the following conditions:

//- The above copyright notice and this permission notice shall be included in all
//- copies or substantial portions of the Software.

//- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//- SOFTWARE.

CTL-OPT MAIN( Main ) ALWNULL( *USRCTL ) AUT( *EXCLUDE )
        DATFMT( *ISO- ) TIMFMT( *ISO. ) DECEDIT( '0,' )
        DFTACTGRP( *NO ) ACTGRP( *NEW ) DEBUG( *YES ) USRPRF( *OWNER );

// Program prototype ------------------------------------------------------
DCL-PR Main EXTPGM( 'WRKSHRRG' );
 Name CHAR(12)      CONST;
 Path CHAR(1024)    CONST OPTIONS( *NOPASS :*VARSIZE );
 Text CHAR(50)      CONST OPTIONS( *NOPASS );
 Permission CHAR(1) CONST OPTIONS( *NOPASS );
 MaxUser  CHAR(4)   CONST OPTIONS( *NOPASS );
END-PR;


//#########################################################################
//- MAIN-Procedure
//#########################################################################
DCL-PROC Main;
DCL-PI *N;
 pName CHAR(12)      CONST;
 pPath CHAR(1024)    CONST OPTIONS( *NOPASS :*VARSIZE );
 pText CHAR(50)      CONST OPTIONS( *NOPASS );
 pPermission CHAR(1) CONST OPTIONS( *NOPASS );
 pMaxUser CHAR(4)    CONST OPTIONS( *NOPASS );
END-PI;

/INCLUDE QRPGLECPY,API_DIRSHR

/INCLUDE QRPGLECPY,CONSTANTS
DCL-C CREATE_SHARE 'C';
DCL-C REMOVE_SHARE 'R';

/INCLUDE QRPGLECPY,ERRORDS
DCL-S Success IND INZ( TRUE );
DCL-S Permission INT(10) INZ;
DCL-S MaxUser INT(10) INZ;
DCL-S CallType CHAR(1) INZ;
DCL-DS ErrorDS LIKEDS( dsAPIError_Template ) INZ;
//-------------------------------------------------------------------------

  If ( %Parms() = 1 );
    CallType = REMOVE_SHARE;
    Success  = TRUE;
  ElseIf ( %Parms() = 5 );
    CallType = CREATE_SHARE;
    Monitor;
      Permission = %Int(pPermission);
      MaxUser    = %Int(pMaxUser);
      On-Error;
        Permission = 1;
        MaxUser    = -1;
    EndMon;
    Success = TRUE;
  Else;
    Success = FALSE;
  EndIf;

  If Success And ( CallType = CREATE_SHARE );
    AddDirShare(pName :pPath :%Len(%Trim(pPath)) :0 :pText
                :Permission :MaxUser :ErrorDS);
  ElseIf Success And ( CallType = REMOVE_SHARE );
    RmvDirShare(pName :ErrorDS);
  EndIf;

  Return;

END-PROC;
