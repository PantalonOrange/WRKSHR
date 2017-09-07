     *  WRKSHRRG                      :
     *  ######........................: Mit Netzfreigaben arbeiten
     *        RG......................: RPG IV
     *  VERSION.......................: V1R1M0

     *- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
     *- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
     *- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
     *- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
     *- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
     *- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
     *- SOFTWARE.

     *  00000000                        BRC      07.09.2017


     *#########################################################################
     *- Kopfdefinitionen
     *#########################################################################

     H MAIN( Main ) ALWNULL( *USRCTL ) AUT( *EXCLUDE )
     H DATFMT( *ISO- ) TIMFMT( *ISO. ) DECEDIT( '0,' )
     H DFTACTGRP( *NO ) ACTGRP( *CALLER ) DEBUG( *YES ) USRPRF( *OWNER )


     *#########################################################################
     *- Definitionen
     *#########################################################################

     * Datentypen -------------------------------------------------------------
      /INCLUDE *LIBL/QRPGLECPY,INLR

     * Programm Prototype -----------------------------------------------------
     D Main            PR                  EXTPGM( 'WRKSHRRG' )
     D  paName                       12A   CONST
     D  paPath                     1024A   CONST OPTIONS( *NOPASS:*VARSIZE )
     D  paText                       50A   CONST OPTIONS( *NOPASS )
     D  paPermission                  1A   CONST OPTIONS( *NOPASS )
     D  paMaxUser                     4A   CONST OPTIONS( *NOPASS )

     * Importierte Prototypen -------------------------------------------------
      /INCLUDE *LIBL/QRPGLECPY,SYSTEM

     * Globale Konstanten -----------------------------------------------------
      /INCLUDE *LIBL/QRPGLECPY,CONSTANTS
     D CREATE_SHARE    C                   'C'
     D REMOVE_SHARE    C                   'R'


     *#########################################################################
     *- MAIN-Prozedur fuer das Programm
     *#########################################################################
    P Main            B
     D Main            PI
     D  paName                       12A   CONST
     D  paPath                     1024A   CONST OPTIONS( *NOPASS:*VARSIZE )
     D  paText                       50A   CONST OPTIONS( *NOPASS )
     D  paPermission                  1A   CONST OPTIONS( *NOPASS )
     D  paMaxUser                     4A   CONST OPTIONS( *NOPASS )

     D EC#AddDirShare  PR                  EXTPGM( 'QZLSADFS' )                 Create share
     D  paShareName                  12A    CONST                                Name
     D  paSharePath                1024A    CONST                                Path
     D  piPathLength                 10I 0  CONST                                Path-length
     D  piCCSID                      10I 0  CONST                                CCSID
     D  paShareText                  50A    CONST                                Description
     D  piPermission                 10I 0  CONST                                1=RO, 2=RW
     D  piMaxUser                    10I 0  CONST                                -1=Nomax, >0
     D  pdsErrorDS                          LIKE( dsErrorDS )                    Error

     D EC#RmvDirShare  PR                  EXTPGM( 'QZLSRMS' )                  Remove share
     D  paShareName                  12A    CONST                                Name
     D  pdsErrorDS                          LIKE( dsErrorDS )                    Error

     D aCallType       S              1A   INZ
     D iPermission     S             10I 0 INZ
     D iMaxUser        S             10I 0 INZ
     D nSuccess        S               N   INZ( TRUE )

     d dsErrorDS       DS                  QUALIFIED
     d  iNbrBytesPrv                 10I 0  INZ( %SIZE(dsErrorDS) )
     d  iNbrBytesAvl                 10I 0  INZ
     d  aMsgID                        7A    INZ
     d  aReserved1                    1A    INZ
     d  aMsgData                   1024A    INZ
     *-------------------------------------------------------------------------

      If ( %Parms()=1 );
         aCallType=REMOVE_SHARE;
         nSuccess=TRUE;
      ElseIf ( %Parms()=5 );
         aCallType=CREATE_SHARE;
         iPermission=%Int(paPermission);
         iMaxUser=%Int(paMaxUser);
         nSuccess=TRUE;
      Else;
         nSuccess=FALSE;
      EndIf;

      If nSuccess And ( aCallType=CREATE_SHARE );
         EC#AddDirShare(paName :paPath :%Len(%Trim(paPath)) :0 :paText
                        :iPermission  :iMaxUser :dsErrorDS);
      ElseIf nSuccess And ( aCallType=REMOVE_SHARE );
         EC#RmvDirShare(paName :dsErrorDS);
      EndIf;

      // Programm beenden
       ExitProgram=TRUE;
       Return;

    P                 E
