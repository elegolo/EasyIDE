With[{
  tempArgs=
    (Join@@
      Flatten@{
        #,
        Replace[
          Templating`$TemplateArgumentStack,
          {
              {___,a_}:>a,
              _-><||>
            }
          ]
        })
  },
  Replace[
    tempArgs["SiteName"],
    Except[_String]:>
      URLParse[tempArgs["SiteURL"], "Path"][[-1]]
    ]
  ]&
