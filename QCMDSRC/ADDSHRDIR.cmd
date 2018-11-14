             CMD        PROMPT('Netzfreigabe erstellen') +
                          TEXT('Netzfreigabe erstellen') +
                          ALWLMTUSR(*NO) AUT(*EXCLUDE)
             PARM       KWD(NAME) TYPE(*NAME) LEN(12) MIN(1) +
                          PROMPT('Freigabename')
             PARM       KWD(PATH) TYPE(*CHAR) LEN(1024) MIN(1) +
                          PROMPT('Pfad')
             PARM       KWD(TEXT) TYPE(*CHAR) LEN(50) +
                          PROMPT('Beschreibung')
             PARM       KWD(PERMISSION) TYPE(*CHAR) LEN(1) +
                          RSTD(*YES) DFT(1) VALUES(1 2) +
                          CHOICE('1=RO; 2=RW') PROMPT('Allgemeine +
                          Berechtigung')
             PARM       KWD(MAXUSER) TYPE(*CHAR) LEN(4) DFT(-1) +
                          CHOICE('-1=NoMax; >0') PROMPT('Maximale +
                          Anzahl an Benutzern')
