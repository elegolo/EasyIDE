(* ::Package:: *)

(* Autogenerated Package *)

IDENotebookObject::usage=
  "The basic representation of a NotebookObject that supports an IDE";


Begin["`Private`"];


RegisterInterface[
  IDENotebookObject,
  {"Notebook", "Project"},
  "Constructor"->CreateIDENotebook,
  "MutationFunctions"->{"Keys"}
  ]


(* ::Subsection:: *)
(*Methods*)



InterfaceMethod[IDENotebookObject]@
  g_IDENotebookObject["Open"][f_]:=
    IDEOpen[g, f];
InterfaceMethod[IDENotebookObject]@
  g_IDENotebookObject["Save"][]:=
    IDESave[g];
InterfaceMethod[IDENotebookObject]@
  g_IDENotebookObject["Close"][f_]:=
    IDEClose[g, f];


End[];



