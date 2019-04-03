With[{Templating`lib`$$libdir=DirectoryName[$InputFileName]},
  Templating`lib`$$templateLib[f_]:=
    Templating`lib`$$templateLib[f]=
      Internal`WithLocalSettings[
        Begin["Templating`lib`Private`"],
        Get@FileNameJoin[{Templating`lib`$$libdir,f<>".m"}],
        End[]
        ]
  ]
