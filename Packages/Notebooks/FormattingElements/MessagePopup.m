(* ::Package:: *)

(* Autogenerated Package *)

CreateMessagePopup::usage="Attaches a Message popup to a notebook";
MessagePopupPanel::usage="A panel for a Message popup";


IDECreateMessage::usage=""


Begin["`Private`"];


(* ::Subsection:: *)
(*CreateMessagePopup*)



(* ::Subsubsection::Closed:: *)
(*MessagePopupPanel*)



MessagePopupPanel[expression_]:=
  Panel[
    Grid[
      {
        {
          Pane[expression], 
          RawBoxes@ButtonBox["", BaseStyle->"MessagePopupClose"]
          }
        },
      GridBoxItemSize->Inherited
      ],
    BaseStyle->"MessagePopup"
    ]


(* ::Subsubsection::Closed:: *)
(*CreateMessagePopup*)



CreateMessagePopup//Clear
CreateMessagePopup[
  nb_, 
  expression_, 
  position:{_Integer|_Scaled, _Integer|_Scaled}:{-15, -15},
  align:{Left|Center|Right, Bottom|Center|Top}:{Right, Bottom},
  anchor:{Left|Center|Right, Bottom|Center|Top}:{Right, Bottom}
  ]:=
  FEAttachCell[
    nb,
    Cell[
      BoxData@ToBoxes@MessagePopupPanel[expression],
      "MessagePopupCell"
      ],
    Offset[position, 0],
    align,
    anchor,
    {"OutsideMouseClick"}
    ]


(* ::Subsection:: *)
(*IDECreateMessage*)



IDECreateMessage[nb_NotebookObject, expr_, args___]:=
  CreateMessagePopup[nb, expr, args];
IDECreateMessage[ide_IDENotebookObject, expr_, args___]:=
  CreateMessagePopup[ide["Notebook"], expr, args];


End[];


