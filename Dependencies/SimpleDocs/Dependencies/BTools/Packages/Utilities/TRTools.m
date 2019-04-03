(* ::Package:: *)

(* Autogenerated Package *)

(* ::Subsubsection::Closed:: *)
(*TRResources*)



$FEResourceDirectory::usage=
  "The base directory for FE resources";
$FEResourceFiles::usage=
  "The .tr files in the base directory";


FEAddResource::usage=
  "Adds a FE resource";
FELoadResources::usage=
  "Loads all FE resources";


(* ::Subsubsection::Closed:: *)
(*Keys*)



$FEKeyEventsDirectory::usage=
  "The directory the KeyEventTranslations.tr file dumps to";
$FEKeyEvents::usage=
  "The listing of keyboard events";
FEKeyEventAdd::usage=
  "Adds key events";
FEKeyEventDrop::usage=
  "Drops key events";
FEResetKeyEvents::usage=
  "Resets the key events";


(* ::Subsubsection::Closed:: *)
(*Menus*)



$FEMenuSetupDirectory::usage=
  "The directory the MenuSetup.tr file dumps to";
$FEMenuSetup::usage=
  "The association of menu items";
FEMenuSetupAdd::usage=
  "Adds to the MenuSetup.tr file";
FEMenuSetupDrop::usage=
  "Drops from the MenuSetup.tr file";
FEMenuSetupGet::usage=
  "Gets stuff from the MenuSetup.tr file";
FEResetMenuSetup::usage=
  "Resets the MenuSetup.tr file";


Begin["`Private`"];


Begin["System`"];
ToExpression@{
  "HelpMenu","AlternateItems","LinkedItems",
  "MenuKey","Modifiers","MenuAnchor",
  "RemoveMask","Scope"
  };
End[];


(* ::Subsubsection::Closed:: *)
(*FETextResource*)



$FETrBaseName=
  "TokenTranslationDictionary";
$FETrFileBaseName=
  "ExtendedFEResources";
If[!ListQ@$FETrResources,
  $FETrResources=
    FrontEndResource[$FETrBaseName]
  ];
$FETrBaseFile=
  FileNameJoin@{
    $InstallationDirectory,
    "SystemFiles",
    "FrontEnd",
    "TextResources",
    "TokenTranslationDictionary.tr"
    };
$FETrListing=
  AssociationMap[
    Null&,
    $FEResourceCompleteListing
    ];
$FEResourceDirectory=
  $FETemporaryResources=
    FrontEnd`FileName@{
      $TemporaryDirectory,
      "SystemFiles",
      "FrontEnd",
      "TextResources"
      };
$FEPersistentResources=
  FrontEnd`FileName@{
    $UserBaseDirectory,
    "SystemFiles",
    "FrontEnd",
    "TextResources"
    };
$FEResourceFiles:=
  FileNames["*.tr",ToFileName@@$FEResourceDirectory,\[Infinity]];


FELoadResources[]:=(
  CurrentValue[$FrontEndSession,
    {PrivatePaths,"TextResources"}
    ]=
    DeleteDuplicates@
      Prepend[
        CurrentValue[$FrontEndSession,
          {PrivatePaths,"TextResources"}
          ],
        FrontEnd`FileName[
          Evaluate@{ToFileName@@$FEResourceDirectory}
          ]
        ];
  FrontEndExecute@FrontEnd`FlushTextResourceCaches[]
  );


$FETrTemplate=
"@|
@|
@@resource `name`
`value`
@|
";
Options[FETrExport]={
  InputForm->True,
  TemplateApply->True
  };
FETrExport[name_,value_,
  OptionsPattern[]
  ]:=
  With[{file=
    If[MatchQ[$FEResourceDirectory,_FrontEnd`FileName],
      ToFileName@@
        Append[$FEResourceDirectory,
          If[StringQ@name,
              name<>".tr",
            Switch[Last@name,
              _String,
                Last@name<>".tr",
              _List,
                FileNameJoin[Last@name]<>".tr"
              ]
            ]
          ],
      FileNameJoin@{
        $FEResourceDirectory,
        If[StringQ@name,
              name<>".tr",
            Switch[Last@name,
              _String,
                Last@name<>".tr",
              _List,
                FileNameJoin[Last@name]<>".tr"
              ]
            ]
        }
      ]
    },
    If[value===Inherited,
      Quiet@DeleteFile[file],
      Quiet@
        CreateDirectory[
          DirectoryName@file,
          CreateIntermediateDirectories->True
          ];
      Export[
        file,
        If[OptionValue[TemplateApply]//TrueQ,
          TemplateApply[
            $FETrTemplate,<|
              "name"->
                If[StringQ@name,
                  name,
                  First@name
                  ],
              "value"->
                If[OptionValue[InputForm]//TrueQ,
                  ToString[value,InputForm],
                  value
                  ]
              |>],
          If[OptionValue[InputForm]//TrueQ,
            ToString[value,InputForm],
            ToString@value
            ]
          ],
        "Text"
        ]
      ]
    ];


Options[FEAddResource]=
  Options[FETrExport];
FEAddResource[
  name_String|
    (name_String->path_),
  value_,
  ops:OptionsPattern[]
  ]:=(
  If[KeyMemberQ[$FETrListing,name],
    If[MatchQ[{path},Except[{_String}|{_List}]],
      FETrExport[name,value,
        ops,
        InputForm->False
        ],
      FETrExport[name->path,value,
        ops,
        InputForm->False
        ]
      ],
    $FETrResources=
      Normal@DeleteCases[Inherited]@
        Merge[{$FETrResources,name->value},Last];
    Quiet@
      CopyFile[$FETrBaseFile,
        ToFileName@@
          Append[$FEResourceDirectory,
            FileNameTake@$FETrFileBaseName
            ]
        ];
    FETrExport[
      $FETrBaseName->$FETrFileBaseName,
      $FETrResources
      ]
    ];
  FELoadResources[]
  );
FEAddResource[r:{(_String->_)..}]:=(
  $FETrResources=
    Normal@DeleteCases[Inherited]@
      Merge[{$FETrResources,r},Last];
  Quiet@
      CopyFile[$FETrBaseFile,
        ToFileName@@
          Append[$FEResourceDirectory,
            $FETrFileBaseName<>".tr"
            ]
        ];
    FETrExport[
      $FETrBaseName->$FETrFileBaseName,
      $FETrResources
      ]
  );


$FEExtraResources=True;
Unprotect/@{FrontEndResource,FrontEndResourceString};
FrontEndResource[
  k_String?(!KeyMemberQ[$FETrListing,#]&)
  ]/;TrueQ@$FEExtraResources:=
  FrontEndResource[$FETrBaseName,k];
FrontEndResource/:
  Set[
    FrontEndResource[k_String],
    v_
    ]/;TrueQ@$FEExtraResources:=
  (FEAddResource[k,v];v);
FrontEndResourceString/:
  Set[
    FrontEndResourceString[k_String?(KeyMemberQ[$FETrListing,#]&)],
    v_
    ]/;TrueQ@$FEExtraResources:=
  (FEAddResource[k,ToString@v];FrontEndResourceString[k]);
FrontEndResource/:
  Unset[FrontEndResource[k_String]]:=
    (FrontEndResource[k]=Inherited;)
FrontEndResourceString/:
  Unset[
    FrontEndResourceString[
      k_String?(KeyMemberQ[$FETrListing,#]&)]
    ]:=
    (FrontEndResourceString[k]=Inherited;)
Protect/@{FrontEndResource,FrontEndResourceString};


(* ::Subsubsection::Closed:: *)
(*Keys*)



$FEKeyEventsDirectory=
  $FETemporaryResources;


$FEKeyEvents:=
  Replace[$feKeyEvents,
    Except[_Association]:>
      Set[$feKeyEvents,
        Begin["System`"];
        (End[];#)&[
          Replace[
            ToExpression[
              FrontEndResourceString["KeyEventTranslations"],
              StandardForm,
              HoldComplete
              ],
            Item[k_,a_]:>
              (k:>HoldComplete[a]),
            3]//ReleaseHold//Apply[Association]
          ]
        ]
    ];
$FEKeyEvents/:
  Unset[$FEKeyEvents]:=
    (Clear@$feKeyEvents;FEResetKeyEvents[]);
$FEKeyEvents/:
  Set[$FEKeyEvents,a_Association]:=
    ($feKeyEvents=a;feKeyEventExport[];a);


feKeyEventExport[]:=
  Block[{
    $FEResourceDirectory=
      $FEKeyEventsDirectory,
    $ContextPath=
      Prepend[$ContextPath,"FrontEnd`"]
    },
    Begin["System`"];
    (End[];#)&@
      FEAddResource[
        "KeyEventTranslations"->
          {
            Switch[$OperatingSystem,
               "MacOSX",
                 "Macintosh",
               "Windows",
                 "Windows",
               "Unix",
                 "X"],
            "KeyEventTranslations"
            },
        "EventTranslations[{\n\t``\n\t}]"~TemplateApply~
          StringRiffle[
            Map[ToString,
              ReleaseHold@
                Replace[
                  Hold@Evaluate@
                    Normal@$FEKeyEvents,{
                  (Rule|RuleDelayed)[k_,HoldComplete[v_]|v_]:>
                    RuleCondition[
                      ToString[Unevaluated@Item[k,v],InputForm],
                      True
                      ]
                  },
                  2]
              ],
            ",\n\t"
            ]
        ]
    ]


keyEventListing[k_]:=
  KeyMap[
    ReplaceAll[
      s_Symbol?(
        Function[Null,
          Context[#]===$Context,
          HoldFirst
          ]
        ):>
        RuleCondition[
          Symbol["FrontEnd`"<>SymbolName@Unevaluated[s]],
          True
          ]
        ]@*
      Replace[{
        key_String:>
          FrontEnd`KeyEvent[key],
        {key_,(Modifiers->modifiers_)|modifiers_}:>
          FrontEnd`KeyEvent[key,
            Modifiers->
              (Begin["System`"];(End[];#)&@
                ToExpression@Flatten@{modifiers})
            ]
        }]
    ]@
    Association[k]


FEKeyEventAdd[
  k:(_RuleDelayed|_Rule)|{(_RuleDelayed|_Rule)..}
  ]:=
  (
    $FEKeyEvents=
      Join[
        $FEKeyEvents,
        keyEventListing[k]
        ];
    );
FEKeyEventDrop[k_]:=
  (
    KeyDropFrom[$FEKeyEvents,
      Keys@keyEventListing@AssociationMap[Null&,Flatten@{k}]
      ];(*
		feKeyEventExport[]*)
    );
FEResetKeyEvents[]:=
  Block[{
    $FEResourceDirectory=
      $FETemporaryResources
    },
    Begin["System`"];
    (End[];#)&@
      FEAddResource[
        "KeyEventTranslations"->
          {
            Switch[$OperatingSystem,
               "MacOSX",
                 "Macintosh",
               "Windows",
                 "Windows",
               "Unix",
                 "X"],
            "KeyEventTranslations"
            },
        Inherited
        ];
    $feKeyEvents//Clear;
    ]


(* ::Subsubsection::Closed:: *)
(*MenuTR*)



$FEMenuSetupDirectory=
  $FETemporaryResources;


$feMSDelimiterKey:=
  CreateUUID["Delimiter-"];
$feMSItemsKey:=
  CreateUUID["Items-"];


feUnspoolMenuExpr[e_]:=
  Replace[e,
    {
      MenuItem[l_,arg_,ops___]:>
        (
          If[MemberQ[{ops},_System`MenuKey],
            {l,FirstCase[{ops},_System`MenuKey]},
            l
            ]-><|
          "Command":>arg,
          "Options"->{ops}
          |>),
      (t:AlternateItems|LinkedItems)[items_,ops___]:>
        (
          RuleCondition[
            With[{rules=feUnspoolMenuExpr/@items},
              With[{a=Alternatives@@Map[Association,rules]},
                $feMSItemsKey-><|
                  "Type"->t,
                  "Items"->a,
                  "Options"->{ops}
                  |>
                ]
              ],
            True
            ]),
      Delimiter:>(
        $feMSDelimiterKey->
          Delimiter
          ),
      (t:Menu|HelpMenu)[l_,items_,ops___]:>
        RuleCondition[
          With[{rules=feUnspoolMenuExpr/@items},
            With[{a=Association[rules]},
              l-><|
                "Type"->t,
                "Items"->a,
                "Options"->{ops}
                |>
              ]
            ],
          True
          ]
      }];
feRespoolMenuExpr[a_Alternatives]:=
  Flatten[feRespoolMenuExpr/@Apply[List,a]];
feRespoolMenuExpr[a_Association]:=
  KeyValueMap[
    Replace[{#,#2},{
      {_,Delimiter}:>
        Delimiter,
      {l_,m_Association?(KeyMemberQ["Items"])}:>
        Switch[m["Type"],
          AlternateItems|LinkedItems,
            m["Type"][
              feRespoolMenuExpr@
                m["Items"],
              Sequence@@Lookup[m,"Options",{}]
              ],
          _,
            Lookup[m,"Type",Menu][
              l,
                feRespoolMenuExpr@
                  m["Items"],
                Sequence@@Lookup[m,"Options",{}]
              ]
        ],
      {l_,m_Association?(KeyMemberQ["Command"])}:>
        With[{
          c=Extract[m,"Command",Hold],
          o=Sequence@@m["Options"]
          },
          Replace[c,
            Hold[cmd_]:>
              MenuItem[
                If[ListQ@l,
                  First@l,
                  l
                  ],
                cmd,
                o
                ]
            ]
          ]
      }]&,
  a
  ];


If[!BooleanQ@$FEMenuExportOnEdit,
  $FEMenuExportOnEdit=True
  ];
$FEMenuSetup:=
  Replace[$feMenuSetup,
    Except[_Association]:>
      Set[$feMenuSetup,
        Begin["System`"];
        (End[];#)&[
          Association@
            feUnspoolMenuExpr@
              FrontEndResource["MenuSetup"]
          ]
        ]
    ];
$FEMenuSetup/:
  Unset[$FEMenuSetup]:=
    (Clear@$feMenuSetup;
      FEResetMenuSetup[];
      );
$FEMenuSetup/:
  Set[$FEMenuSetup,a_Association]:=
    (
      $feMenuSetup=a;
      If[$FEMenuExportOnEdit,feMenuSetupExport[]];
      a
      );
$FEMenuSetup/:
  Set[$FEMenuSetup[part___,key_],val_]:=
    (
      $FEMenuSetup;
      If[Length@{part}>0,
        Do[
          With[{p=Sequence@@Take[{part},n]},
            If[Not@AssociationQ@$feMenuSetup[p],
              $feMenuSetup[p]=
                If[Last@{p}==="Items",
                  <||>,
                  <|
                    "Type"->Menu,
                    "Items"-><||>
                    |>
                  ]
              ]
            ],
          {n,Length@{part}}
          ]
        ];
      $feMenuSetup[part,key]=val;
      If[$FEMenuExportOnEdit,feMenuSetupExport[]];
      val
      );
$FEMenuSetup/:
  Unset[$FEMenuSetup[part___,key_]]:=
    (
      $FEMenuSetup;
      $feMenuSetup[part,key]=.;
      If[$FEMenuExportOnEdit,feMenuSetupExport[]];
      );


feMenuSetupExport[]:=
  Block[{
    $FEResourceDirectory=
      $FEMenuSetupDirectory
    },
    Begin["System`"];
    (End[];#)&@
      FEAddResource[
        "MenuSetup"->
          {
            Switch[$OperatingSystem,
               "MacOSX",
                 "Macintosh",
               "Windows",
                 "Windows",
               "Unix",
                 "X"],
            "MenuSetup"
            },
        First@FrontEndExecute@
          ExportPacket[
            Cell[BoxData@
              First@
                NewlineateCodeRecursive[
                  First@feRespoolMenuExpr@$FEMenuSetup,
                  _Menu|_List
                  ],
              ExportAutoReplacements->{
                ParentList,
                "\[Infinity]"->"Infinity",
                "\.14"->" "
                }
              ],
            "InputText"
            ],
        TemplateApply->False,
        InputForm->False
        ];
    FrontEndExecute@
      FrontEnd`ResetMenusPacket[{Automatic,Automatic}]
    ]


feMenuSetupObject[cmd_,ops___]:=
  Switch[Unevaluated[cmd],
    Delimiter,
      Delimiter,
    _MenuItem|_Menu|_Association,
      cmd,
    {(_Menu|_MenuItem|Delimiter)...},
      <|
        "Items"->cmd,
        "Options"->{ops}
        |>,
    _,
      <|
        "Command":>cmd,
        "Options"->{ops}
        |>
    ];
feMenuSetupObject~SetAttributes~HoldFirst;


feMenuPath[path__]:=
  Append["Items"]@
    Riffle[
      Switch[{path},
        {"Mathematica",___},
          {path},
        _,
          {"Mathematica",path}
        ],
      "Items"]


FEMenuSetupGet[{path___String,key:{_String,___}|_String|_Integer}]:=
  With[{p=Sequence@@feMenuPath[path]},
    Replace[$FEMenuSetup[p],
      a_Association:>
        Which[
          IntegerQ@key,
            Normal[a][[key]],
          StringQ@key,
            Lookup[a,key,
               If[Length[#]>0,
                 First@#,
                 Missing["KeyAbsent",key]
                 ]&@
                 KeySelect[a,
                   MatchQ[{key,___}]
                   ]
               ],
          True,
            Lookup[$FEMenuSetup[p], Key[key]]
           ]
          ]
    ];
FEMenuSetupGet[path_String]:=
  FEMenuSetupGet@{path};


FEMenuSetupAdd[
  {path__String,pos:_Integer|None:None},
  (Rule|RuleDelayed)[lab_,cmd_],
  ops___
  ]:=
  With[{
    p=
      Sequence@@feMenuPath[path],
    lab2=
      If[MemberQ[{ops},_System`MenuKey],
        {lab,FirstCase[{ops},_System`MenuKey]},
        lab
        ]
    },
    If[pos===None,
      $FEMenuSetup[p,lab2]=
        feMenuSetupObject[cmd,ops];,
      $FEMenuSetup[p]=
        Insert[
          $FEMenuSetup[p],
          lab2->feMenuSetupObject[cmd,ops],
          pos
          ];
      ]
    ];
FEMenuSetupAdd[
  p_String,
  r:(_Rule|_RuleDelayed),
  ops___
  ]:=
  FEMenuSetupAdd[{p},r,ops];
FEMenuSetupAdd[
  p_,
  Delimiter
  ]:=
  FEMenuSetupAdd[p,
    $feMSDelimiterKey->Delimiter
    ];
FEMenuSetupAdd~SetAttributes~HoldRest;


FEMenuSetupDrop[
  {path___String,pos:(_String|{_String,___}|_Integer|None):None}
  ]:=
  With[{p=Sequence@@Most@feMenuPath[path]},
    Switch[pos,
      None,
        $FEMenuSetup[p]=.,
      _String|_List,
        $FEMenuSetup[p,pos]=.,
      _Integer,
        With[{base=$FEMenuSetup[p]},
          If[AssociationQ@#,
            $FEMenuSetup[p]=#,
            #
            ]&@
            With[{k=Keys[base["Items"]][[pos]]},
              If[KeyMemberQ[base["Items"],k],
                ReplacePart[base,
                  "Items"->
                    KeyDrop[base["Items"],If[ListQ@k,{k},k]]
                  ],
                $Failed
                ]
              ]
          ]
      ]
    ];
FEMenuSetupDrop[path_String]:=
  FEMenuSetupDrop[{path}]


FEResetMenuSetup[]:=
  Block[{
    $FEResourceDirectory=
      $FETemporaryResources
    },
    Begin["System`"];
    (End[];#)&@
      FEAddResource[
        "MenuSetup"->
          {
            Switch[$OperatingSystem,
               "MacOSX",
                 "Macintosh",
               "Windows",
                 "Windows",
               "Unix",
                 "X"],
            "MenuSetup"
            },
        Inherited
        ];
    $feMenuSetup//Clear;
    FrontEndExecute@ResetMenusPacket[{Automatic,Automatic}]
    ]


End[];



