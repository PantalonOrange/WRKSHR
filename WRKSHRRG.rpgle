     *- Copyright (c) 2017 Christian Brunner
     *-
     *- Permission is hereby granted, free of charge, to any person obtaining a copy
     *- of this software and associated documentation files (the "Software"), to deal
     *- in the Software without restriction, including without limitation the rights
     *- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
     *- copies of the Software, and to permit persons to whom the Software is
     *- furnished to do so, subject to the following conditions:
     *-
     *- The above copyright notice and this permission notice shall be included in all
     *- copies or substantial portions of the Software.
     *-
     *- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
     *- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
     *- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
     *- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
     *- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
     *- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
     *- SOFTWARE.

     H MAIN( Main ) ALWNULL( *USRCTL ) AUT( *EXCLUDE )
     H DATFMT( *ISO- ) TIMFMT( *ISO. ) DECEDIT( '0,' )
     H DFTACTGRP( *NO ) ACTGRP( *NEW ) DEBUG( *YES ) USRPRF( *OWNER )

     * Program prototype ------------------------------------------------------
     D Main            PR                  EXTPGM( 'WRKSHRRG' )
     D  Name                         12A   CONST
     D  Path                       1024A   CONST OPTIONS( *NOPASS :*VARSIZE )
     D  Text                         50A   CONST OPTIONS( *NOPASS )
     D  Permission                    1A   CONST OPTIONS( *NOPASS )
     D  MaxUser                       4A   CONST OPTIONS( *NOPASS )


     *#########################################################################
     *- MAIN-Procedure
     *#########################################################################
     P Main            B
     D Main            PI
     D  paName                       12A   CONST
     D  paPath                     1024A   CONST OPTIONS( *NOPASS :*VARSIZE )
     D  paText                       50A   CONST OPTIONS( *NOPASS )
     D  paPermission                  1A   CONST OPTIONS( *NOPASS )
     D  paMaxUser                     4A   CONST OPTIONS( *NOPASS )

      /INCLUDE QRPGLECPY,API_DIRSHR

      /INCLUDE QRPGLECPY,CONSTANTS
     D CREATE_SHARE    C                   'C'
     D REMOVE_SHARE    C                   'R'

      /INCLUDE QRPGLECPY,ERRORDS
     D nSuccess        S               N   INZ( TRUE )
     D iPermission     S             10I 0 INZ
     D iMaxUser        S             10I 0 INZ
     D aCallType       S              1A   INZ
     D dsErrorDS       DS                  LIKEDS( dsAPIError_Template ) INZ
     *-------------------------------------------------------------------------

      If ( %Parms() = 1 );
        aCallType = REMOVE_SHARE;
        nSuccess = TRUE;
      ElseIf ( %Parms() = 5 );
        aCallType = CREATE_SHARE;
        Monitor;
          iPermission = %Int(paPermission);
          iMaxUser = %Int(paMaxUser);
          On-Error;
             iPermission = 1;
             iMaxUser = -1;
        EndMon;
        nSuccess = TRUE;
      Else;
        nSuccess = FALSE;
      EndIf;

      If nSuccess And ( aCallType = CREATE_SHARE );
        AddDirShare(paName :paPath :%Len(%Trim(paPath)) :0 :paText
                     :iPermission :iMaxUser :dsErrorDS);
      ElseIf nSuccess And ( aCallType = REMOVE_SHARE );
        RmvDirShare(paName :dsErrorDS);
      EndIf;

      Return;

     P                 E
