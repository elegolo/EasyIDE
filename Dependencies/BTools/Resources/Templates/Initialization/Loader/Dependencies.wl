(* ::Package:: *)

(* ::Subsection:: *)
(*Dependencies*)


$Name::nodep="Couldn't load dependency `` of type ``";
$Name::nodup="Couldn't update dependency `` of type ``";


PackageExtendContextPath::usage="";
PackageInstallPackageDependency::usage="";
PackageLoadPackageDependency::usage="";
PackageCheckPacletDependency::usage="";
PackageInstallPacletDependency::usage="";
PackageLoadPacletDependency::usage="";
PackageUpdatePacletDependency::usage="";
PackageLoadResourceDependency::usage="";
PackageEnsureLoadDependencies::usage="Ensures all declared dependencies are loaded";
PackageExposeDependencies::usage="";


(* ::Subsubsection::Closed:: *)
(*Begin*)


Begin["`Dependencies`"];


(* ::Subsubsection::Closed:: *)
(*PackageExtendContextPath*)


PackageExtendContextPath[cp:{__String}]:=
  (
    Unprotect[$PackageContexts];
    $PackageContexts=
      DeleteCases[
        DeleteDuplicates@
          Join[$PackageContexts, cp],
        "System`"|"Global`"
        ];
    (* Should I protect it again? *)
    )


(* ::Subsubsection::Closed:: *)
(*PackageInstallPackageDependency*)


Options[PackageInstallPackageDependency]=
  {
    "Permanent"->False
    };
PackageInstallPackageDependency[dep_String, ops:OptionsPattern[]]:=
  Block[{retcode, site, path, file, tmp},
    path=
      StringSplit[StringTrim[dep, "`"]<>If[FileExtension[dep]=="", ".m", ""], "`"];
    site=
      Replace[OptionValue["Site"],
        {
          s_String?(
            URLParse[#, "Domain"]==="github.com"&
            ):>
          URLBuild@
            <|
              "Scheme"->"http",
              "Domain"->"raw.githubusercontent.com",
              "Path"->
                Function[If[Length[#]==2, Append[#, "master"], #]]@
                  DeleteCases[""]@URLParse[s, "Path"]
              |>,
          _->
            "http://raw.githubusercontent.com/paclets/PackageServer/master/Listing"
          }
        ];
      file=
        If[TrueQ@OptionValue["Permanent"],
          FileNameJoin@{$UserBaseDirectory, "Applications", Last@path},
          FileNameJoin@{$TemporaryDirectory, "Applications", Last@path}
          ];
      tmp=CreateFile[];
      Monitor[
        retcode=URLDownload[URLBuild[Prepend[site], path], tmp, "StatusCode"],
        Internal`LoadingPanel[
          TemplateApply[
            "Loading package `` from site ``",
            {URLBuild@path, site}
            ]
          ]
        ];
      If[retcode<300,
        CopyFile[tmp, file,
          OverwriteTarget->Not@TrueQ@OptionValue["Permanent"]
          ];
        DeleteFile[tmp];
        file,
        Message[$Name::nodep, dep, "Package"];
        DeleteFile[tmp];
        $Failed
        ]
      ];


(* ::Subsubsection::Closed:: *)
(*PackageLoadPackageDependency*)


Options[PackageLoadPackageDependency]=
  Append[
    Options[PackageInstallPackageDependency],
    "Loading"->Needs
    ];
PackageLoadPackageDependency[dep_String, ops:OptionsPattern[]]:=
  Internal`WithLocalSettings[
    BeginPackage[dep];,
    If[Quiet@Check[OptionValue["Loading"][dep], $Failed]===$Failed&&
        Quiet@Check[
          Get[FileNameJoin@@
            StringSplit[
              StringTrim[dep, "`"]<>If[FileExtension[dep]=="", ".m", ""], 
              "`"
              ]
            ], 
          $Failed]===$Failed,
      Replace[PackageInstallPacletDependency[dep, ops],
        f:_String|_File:>Get[f]
        ]
      ];
    PackageExtendContextPath@
      Select[$Packages, StringStartsQ[dep]];,
    EndPackage[];
    ]


(* ::Subsubsection::Closed:: *)
(*PackageCheckPacletDependency*)


PackageCheckPacletDependency[dep_]:=
  Length@PacletManager`PacletFind[StringDelete[dep, "`"]]>0


(* ::Subsubsection::Closed:: *)
(*PackageInstallPacletDependency*)


Options[PackageInstallPacletDependency]=
  Options[PacletManager`PacletInstall];
PackageInstallPacletDependency[
  deps:{__String?(
    StringMatchQ[
      (LetterCharacter|"_"|"`")~~(WordCharacter|"_"|"`")..
      ]
    )}, 
  ops:OptionsPattern[]
  ]:=
  Block[{site, pacs, pac},
    pacs=
      StringDelete[deps, "`"];
    site=
      Replace[OptionValue["Site"],
        {
          s_String?(
            URLParse[#, "Domain"]==="github.com"&
            ):>
          URLBuild@
            <|
              "Scheme"->"http",
              "Domain"->"raw.githubusercontent.com",
              "Path"->
                Function[If[Length[#]==2, Append[#, "master"], #]]@
                  DeleteCases[""]@URLParse[s, "Path"]
              |>,
          None->
            Automatic,
          Except[_String]->
            "http://raw.githubusercontent.com/paclets/PacletServer/master"
          }
        ];
    pac=First@pacs;
    Monitor[
      MapThread[
        Check[
          PacletManager`PacletInstall[
            pac=#,
            "Site"->site,
            ops
            ],
          Message[$Name::nodep, #2, "Paclet"];
          $Failed
          ]&,
        {
          pacs,
          deps
          }
        ],
      Internal`LoadingPanel[
        TemplateApply[
          "Loading paclet `` from site ``",
          {pac, site}
          ]
        ]
      ]
    ]


PackageInstallPacletDependency[
  dep:_String?(
    StringMatchQ[
      (LetterCharacter|"_"|"`")~~(WordCharacter|"_"|"`")..
      ]
    ), 
  ops:OptionsPattern[]
  ]:=First@PackageInstallPacletDependency[{dep}, ops]


(* ::Subsubsection::Closed:: *)
(*PackageLoadPacletDependency*)


Options[PackageLoadPacletDependency]=
  Join[
    Options[PackageInstallPacletDependency],
    {
      "Update"->False
      }
    ];
PackageLoadPacletDependency[dep_String?(StringEndsQ["`"]), ops:OptionsPattern[]]:=
  Internal`WithLocalSettings[
    System`Private`NewContextPath[{dep, "System`"}];,
    If[PackageCheckPacletDependency[dep],
      If[TrueQ@OptionValue["Update"],
        PackageUpdatePacletDependency[dep,
          "Sites"->Replace[OptionValue["Site"], s_String:>{s}]
          ]
        ],
      PackageInstallPacletDependency[dep, 
        FilterRules[{ops}, Options@PackageInstallPacletDependency ]
        ]
      ];
    Needs[dep];
    PackageExtendContextPath@
      Select[$Packages, 
        StringStartsQ[#, dep]&&StringFreeQ[#, "`Private`"]&
        ];,
    System`Private`RestoreContextPath[];
    ]


(* ::Subsubsection::Closed:: *)
(*PackageUpdatePacletDependency*)


Options[PackageUpdatePacletDependency]=
  {
    "Sites"->Automatic
    };
PackageUpdatePacletDependency[
  deps:{__String?(StringMatchQ[(LetterCharacter|"_")~~(WordCharacter|"_")..])}, 
  ops:OptionsPattern[]
  ]:=
  Block[
    {
      added=<||>,
      ps=PacletManager`PacletSites[],
      pac
      },
    Replace[
      Replace[OptionValue["Sites"], 
        Automatic:>"http://raw.githubusercontent.com/paclets/PacletServer/master"
        ],
      {
        s_String:>
          If[!MemberQ[ps, PacletManager`PacletSite[s, ___]],
            added[s]=True
            ],
        p:PacletManager`PacletSite[__]:>
          If[!MemberQ[ps, p],
            added[p]=True
            ]
        },
      1
      ];
    pac=StringDelete[deps[[1]], "`"];
    Internal`WithLocalSettings[
      KeyMap[PacletManager`PacletSiteAdd, added],
      Monitor[
        MapThread[
          Check[
            PacletManager`PacletCheckUpdate[pac=#],
            Message[$Name::nodup, #2, "Paclet"];
            $Failed
            ]&,
          {
            StringDelete[deps, "`"],
            deps
            }
          ],
        Internal`LoadingPanel[
          "Updating paclet ``"~TemplateApply~pac
          ]
        ],
      KeyMap[PacletManager`PacletSiteRemove, added]
      ]
    ];


PackageUpdatePacletDependency[
  dep:_String?(StringMatchQ[(LetterCharacter|"_")~~(WordCharacter|"_")..]), 
  ops:OptionsPattern[]
  ]:=
  First@PackageUpdatePacletDependency[{dep}, ops]


(* ::Subsubsection::Closed:: *)
(*PackageLoadResourceDependency*)


(* ::Text:: *)
(*Nothing I've implemented yet, but could be very useful for installing resources for a paclet*)


(* ::Subsubsection:: *)
(*PackageEnsureLoadDependency*)


Options[PackageEnsureLoadDependency]=
  Join[
    Options@PackageLoadPacletDependency,
    {
      "Bundled"->True
      }
    ];
PackageEnsureLoadDependency[dep_, ops:OptionsPattern[]]:=
  Module[
    {
      depsDir,
      pfp,
      foundFile,
      bund=TrueQ@Quiet@OptionValue["Bundled"]
      },
     depsDir=
       If[$PackageLoadingMode==="Dependency",
         DeleteDuplicates@Flatten@{
          ParentDirectory@$PackageDirectory,
          PackageFilePath["Dependencies"],
          pfp = 
            SplitBy[
              FileNameSplit[$PackageDirectory],
              #==="Dependencies"&
              ];
          Reap[
            Fold[
              If[#2==="Dependencies", 
                Sow,
                Identity
                ]@
                FileNameJoin@Flatten@{#, #2}&,
              pfp
              ]
            ][[2]]
         },
        {PackageFilePath["Dependencies"]}
        ];
     If[bund,
       If[AnyTrue[depsDir, DirectoryQ],
         foundFile=
           Block[
             {
               $Path=depsDir,
               PacletManager`PacletManagerEnabled
               },
             FindFile[dep]
             ];
         ];
       If[!StringQ@foundFile, foundFile=FindFile[dep]];
       bund=StringQ@foundFile
       ];
     Quiet[(* this is a temporary hack until WRI fixes a $ContextPath bug *)
       If[!bund,
         PackageLoadPacletDependency[dep,
           Sequence@@FilterRules[
             {
               ops,
               "Update"->True,
               "Loading"->Get
               },
             Options@PackageLoadPacletDependency
             ]
           ],
         Lookup[Flatten@{ops}, "Loading", Get]@foundFile
         (* I have my reasons to do this rather than Needs... but it could change... *)
         ],
      General::shdw
      ];
     ];


(* ::Subsubsection:: *)
(*PackageEnsureLoadDependencies*)


PackageEnsureLoadDependencies[]:=
  If[!TrueQ@$dependenciesLoaded,
    $dependenciesLoaded=True;
    Module[
      {
        deps=$PackageDependencies,
        site=$PackageDependencyBase
        },
       PackageExecute[
         Begin["`Dependencies`"];
         PackageEnsureLoadDependency@@
           Flatten@{#, "Site"->site}&/@deps;
         PackageExposeDependencies[];
         End[];
         ]
      ];
   ];


(* ::Subsubsection:: *)
(*PackageExposeDependencies*)


PackageExposeDependencies[deps_, permanent:True|False:False]:=
  Module[
    {
      cdeps,
      loadQ,
      depCs
      },
    (* 
      someday I'll need this to be more sophisticated, but today is not that day
      *)
    depCs=
      {
        If[$PackageLoadingMode==="Dependency",
          StringSplit[$PackageContexts[[1]], "Dependencies`", 2][[1]]<>
            "Dependencies`",
          Nothing
          ],
        $PackageContexts[[1]]<>"Dependencies`"
        };
    cdeps=
      With[{ctx=#},
        SelectFirst[
          depCs,
          Length@
            Join[Names[#<>ctx<>"*"], Names[#<>ctx<>"*`*"]]>0&,
          ""
          ]<>#
        ]&/@deps;
    (* only gonna be used within PackageExecute...? *)
    $ContextPath=
      DeleteDuplicates@
        Join[cdeps, $ContextPath];
    If[permanent,
      PackageExtendContextPath@cdeps
      ];
    cdeps
    ];
PackageExposeDependencies[]:= 
  PackageExposeDependencies[
    Lookup[$PackageLoadSpecs, "DependencyContexts", {}],
    True
    ]


(* ::Subsubsection:: *)
(*End*)


End[]
