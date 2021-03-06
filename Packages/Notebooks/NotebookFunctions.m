(* ::Package:: *)

(* Autogenerated Package *)

(* ::Text:: *)
(*IDE Notebook constructor*)



CreateIDENotebook::usage="";


Begin["`Private`"];


(* ::Subsection:: *)
(*CreateIDENotebook*)



(* ::Subsubsection::Closed:: *)
(*validateVomit*)



validateVomit[a_]:=
  (
    If[Quiet@NotebookInformation[a["Notebook"]]===$Failed, 
      PackageRaiseException[Automatic,
        "Notebook `` is invalid",
        a["Notebook"]
        ]
      ];
    If[Quiet[!TrueQ@DirectoryQ@a["Project"]],
      PackageRaiseException[Automatic,
        "Project directory `` is invalid",
        a["Project"]
        ]
      ];
    a
    )


(* ::Subsubsection::Closed:: *)
(*createIDENotebook*)



createIDENotebook[dir_String]:=
  CreateDocument@
    Notebook[
      {
        
        },
      TaggingRules->{
        $PackageName->{"Project"->{"Directory"->dir}},
        "IndentCharacter"->"  "
        },
      StyleDefinitions->
        Notebook[
          {
            Cell[
              StyleData[
                StyleDefinitions->FrontEnd`FileName[{"EasyIDE"}, "LightMode.nb"]
                ]
              ]
            },
          StyleDefinitions->"PrivateStylesheetFormatting.nb"
          ],
      WindowTitle->"EasyIDE: ``"~TemplateApply~FileBaseName[dir]
      ]


(* ::Subsubsection::Closed:: *)
(*CreateIDENotebook*)



CreateIDENotebook[a_Association]:=
  validateVomit@a
CreateIDENotebook[nb_NotebookObject, dir_String]:=
  CreateIDENotebook@<|
    "Notebook"->nb,
    "Project"->dir
    |>;
CreateIDENotebook[nb_NotebookObject]:=
  CreateIDENotebook@<|
    "Notebook"->nb,
    "Project"->IDEPath[nb]
    |>
CreateIDENotebook[dir_String]:=
  CreateIDENotebook[
    createIDENotebook[dir],
    dir
    ];


CreateIDENotebook[]:=
  CreateIDENotebook[EvaluationNotebook[]]


End[];



