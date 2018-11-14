      /if not defined (#API_QZLSADFS)
      /define #API_QZLSADFS
     D AddDirShare     PR                  EXTPGM( 'QZLSADFS' )                 Create share
     D  ShareName                    12A    CONST                                Name
     D  SharePath                  1024A    CONST                                Path
     D  PathLength                   10I 0  CONST                                Path-length
     D  CCSID                        10I 0  CONST                                CCSID
     D  ShareText                    50A    CONST                                Description
     D  Permission                   10I 0  CONST                                1=RO, 2=RW
     D  MaxUser                      10I 0  CONST                                -1=Nomax, >0
     D  ErrorDS                             LIKEDS( dsAPIError_Template )        Error
      /endif

      /if not defined (#API_QZLSRMS)
      /define #API_QZLSRMS
     D RmvDirShare     PR                  EXTPGM( 'QZLSRMS' )                  Remove share
     D  ShareName                    12A    CONST                                Name
     D  ErrorDS                             LIKEDS( dsAPIError_Template )        Error
      /endif

      /if not defined (#API_ERROR_DS)
      /include QRPGLECPY,ERRORDS
      /endif
