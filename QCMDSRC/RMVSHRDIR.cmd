             CMD        PROMPT('Netzfreigabe entfernen') +
                          TEXT('Netzfreigabe entfernen') +
                          ALWLMTUSR(*NO) AUT(*EXCLUDE)
             PARM       KWD(NAME) TYPE(*NAME) LEN(12) MIN(1) +
                          PROMPT('Freigabename')
