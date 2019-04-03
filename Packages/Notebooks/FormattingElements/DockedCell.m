(* ::Package:: *)

(* Autogenerated Package *)

GetNotebookMenu::usage="Gets the menu used in the IDENotebookObjects";


Begin["`Private`"];


(* ::Subsubsection::Closed:: *)
(*createNotebookDockedCell*)



createNotebookDockedCell[nb_]:=
  With[
    {
      tabRowRefresh = Unique[tabRowRefresh],
      toolbarRefresh = Unique[toolbarRefresh]
      },
    IDEData[nb, PrivateKey["TabsRefreshHandle"]]=Hold[tabRowRefresh];
    IDEData[nb, PrivateKey["ToolbarRefreshHandle"]]=Hold[toolbarRefresh];
    Module[
      {
        tabs=
          CreateTabRow[tabRowRefresh],
        toolbars=
          CreateToolbarsBox[toolbarRefresh],
        menus=
          Values@GetPluginsMenus[nb],
        viewer=
          ToggleFileViewerButton[]
        },
      Cell[
        BoxData@
          If[Length@menus[[2]]>3,
            GridBox[
              {
                {ToBoxes@Panel[
                  Column[
                    {
                      Grid[
                        menus[[2]]//List, 
                        BaseStyle->"MainMenuTwoRowTop",
                        GridBoxItemSize->Inherited
                        ],
                      Grid[
                        {{viewer, tabs, menus[[1]]}},
                        BaseStyle->"MainMenuTwoRowBottom",
                        GridBoxItemSize->Inherited
                        ]
                      },
                    BaseStyle->"MainMenuTwoRow"
                    ],
                  BaseStyle->"MainMenuTwoRow"
                  ]},
              {PanelBox[toolbars, BaseStyle->"MainMenuTwoRowToolbars"]}
              },
            BaseStyle->"MainMenu"
            ],
          GridBox[
            {
              {ToBoxes@Panel[
                Grid[
                  {
                    {
                      viewer,
                      tabs,
                      Grid[
                        {Append[menus[[2]], menus[[1]]]},
                        BaseStyle->"MainMenuOneRowPlugins",
                        GridBoxItemSize->Inherited
                        ]
                      }
                    },
                  BaseStyle->"MainMenuOneRow",
                  GridBoxItemSize->Inherited
                  ],
                BaseStyle->"MainMenuOneRow"
                ]},
            {PanelBox[toolbars, BaseStyle->"MainMenuOneRowToolbars"]}
            },
          BaseStyle->"MainMenu"
          ]
        ],
      "MainMenuCell"
      ]
    ]
  ];


(* ::Subsubsection::Closed:: *)
(*GetNotebookMenu*)



GetNotebookMenu[nb_:Automatic]:=
  createNotebookDockedCell@
    Replace[nb, Automatic:>EvaluationNotebook[]];


End[];



