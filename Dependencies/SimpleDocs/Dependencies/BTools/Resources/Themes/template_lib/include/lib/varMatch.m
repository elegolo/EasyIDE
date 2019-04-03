With[{
  tempArgs=
    (Join@@
      Flatten@{
        #,
        Replace[Templating`$TemplateArgumentStack,{
            {___,a_}:>a,
            _-><||>
          }]
        })
  },
  MatchQ[
    Replace[
      tempArgs@
        Replace[tempArgs["val"],
          t_TemplateObject:>
            TemplateApply[t,tempArgs]
          ],
      TemplateObject[{
        Templating`Evaluator`PackagePrivate`apply[_,
          a_
          ]
        }]:>
          Block[
            {
              Templating`PackageScope`$TemplateEvaluate=True
              },
            a
            ]
      ],
      Replace[
        tempArgs@
          Replace[tempArgs["pat"],
            t_TemplateObject:>
              TemplateApply[t,tempArgs]
            ],
        TemplateObject[{
          Templating`Evaluator`PackagePrivate`apply[_,
            a_
            ]
          }]:>
            Block[
              {
                Templating`PackageScope`$TemplateEvaluate=True
                },
              a
              ]
        ]
    ]
  ]&
