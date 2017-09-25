      /if not defined (#API_ERROR_DS)
      /define #API_ERROR_DS
     D dsAPIError_Template...
     D                 DS                  QUALIFIED
     D  iNbrBytesPrv                 10I 0  INZ( %SIZE( dsAPIError_Template ))
     D  iNbrBytesAvl                 10I 0
     D  aMsgID                        7A
     D  aReserved1                    1A
     D  aMsgData                   1024A
      /endif
