.info
  .source "SearchAction.psc"
  .modifyTime 1635385443
  .compileTime 1635385445
  .user "mrowr"
  .computer "MROWR-PURR"
.endInfo
.userFlagsRef
  .flag conditional 1
  .flag hidden 0
.endUserFlagsRef
.objectTable
  .object SearchAction ReferenceAlias
    .userFlags 0
    .docString "Extend this to create your own list action for the 'Search' mod"
    .autoState 
    .variableTable
      .variable _actionName string
        .userFlags 0
        .initialValue None
      .endVariable
    .endVariableTable
    .propertyTable
	  .property ActionName string
	    .userFlags 0
	    .docString ""
	    .function get 
	      .userFlags 0
	      .docString ""
	      .return string
	      .paramTable
	      .endParamTable
	      .localTable
	        .local ::temp0 bool
	        .local ::temp1 string
	        .local ::temp2 int
	        .local ::temp3 bool
	        .local theScriptName string
	      .endLocalTable
	      .code
	        NOT ::temp0 _actionName ;@line 11
	        JUMPF ::temp0 label3 ;@line 11
	        CAST ::temp1 self ;@line 12
	        ASSIGN theScriptName ::temp1 ;@line 12
	        CAST ::temp1 self ;@line 13
	        CALLSTATIC stringutil Find ::temp2 ::temp1 "[Search_Action_" 0 ;@line 13
	        COMPAREEQ ::temp3 ::temp2 0 ;@line 13
	        JUMPF ::temp3 label2 ;@line 13
	        CALLSTATIC stringutil Find ::temp2 theScriptName " " 0 ;@line 14
	        ISUBTRACT ::temp2 ::temp2 15 ;@line 14
	        CAST ::temp1 self ;@line 14
	        CALLSTATIC stringutil Substring ::temp1 ::temp1 15 ::temp2 ;@line 14
	        ASSIGN _actionName ::temp1 ;@line 14
	        JUMP label1
	        label2:
	        label1:
	        JUMP label0
	        label3:
	        label0:
	        RETURN _actionName ;@line 17
	      .endCode
	    .endFunction
	    .function set 
	      .userFlags 0
	      .docString ""
	      .return NONE
	      .paramTable
	        .param value string
	      .endParamTable
	      .localTable
	      .endLocalTable
	      .code
	        ASSIGN _actionName value ;@line 20
	      .endCode
	    .endFunction
	  .endProperty
	  .property PlayerRef Actor
	    .userFlags 0
	    .docString ""
	    .function get 
	      .userFlags 0
	      .docString ""
	      .return Actor
	      .paramTable
	      .endParamTable
	      .localTable
	        .local ::temp4 actor
	      .endLocalTable
	      .code
	        CALLMETHOD GetActorReference self ::temp4  ;@line 26
	        RETURN ::temp4 ;@line 26
	      .endCode
	    .endFunction
	  .endProperty
    .endPropertyTable
    .stateTable
      .state
        .function GetState
          .userFlags 0
          .docString "Function that returns the current state"
          .return String
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
            RETURN ::state
          .endCode
        .endFunction
        .function GotoState
          .userFlags 0
          .docString "Function that switches this object to the specified state"
          .return None
          .paramTable
            .param newState String
          .endParamTable
          .localTable
            .local ::NoneVar None
          .endLocalTable
          .code
            CALLMETHOD onEndState self ::NoneVar
            ASSIGN ::state newState
            CALLMETHOD onBeginState self ::NoneVar
          .endCode
        .endFunction
        .function OnInit 
          .userFlags 0
          .docString ""
          .return NONE
          .paramTable
          .endParamTable
          .localTable
            .local ::nonevar none
            .local ::temp5 string
          .endLocalTable
          .code
            CALLMETHOD OnActionInit self ::nonevar  ;@line 31
            PROPGET ActionName self ::temp5 ;@line 32
            STRCAT ::temp5 "Search_Action_" ::temp5 ;@line 32
            CALLMETHOD RegisterForModEvent self ::nonevar ::temp5 "OnSearchAction" ;@line 32
          .endCode
        .endFunction
        .function OnPlayerLoadGame 
          .userFlags 0
          .docString ""
          .return NONE
          .paramTable
          .endParamTable
          .localTable
            .local ::nonevar none
            .local ::temp6 string
          .endLocalTable
          .code
            CALLMETHOD OnActionInit self ::nonevar  ;@line 36
            PROPGET ActionName self ::temp6 ;@line 37
            STRCAT ::temp6 "Search_Action_" ::temp6 ;@line 37
            CALLMETHOD RegisterForModEvent self ::nonevar ::temp6 "OnSearchAction" ;@line 37
          .endCode
        .endFunction
        .function OnActionInit 
          .userFlags 0
          .docString ""
          .return NONE
          .paramTable
          .endParamTable
          .localTable
          .endLocalTable
          .code
          .endCode
        .endFunction
        .function OnAction 
          .userFlags 0
          .docString ""
          .return NONE
          .paramTable
            .param actionInfo int
          .endParamTable
          .localTable
          .endLocalTable
          .code
          .endCode
        .endFunction
        .function OnSearchAction 
          .userFlags 0
          .docString ""
          .return NONE
          .paramTable
            .param actionInfo int
          .endParamTable
          .localTable
            .local ::temp7 string
            .local ::nonevar none
            .local ::temp8 int
          .endLocalTable
          .code
            CAST ::temp7 actionInfo ;@line 58
            STRCAT ::temp7 "On Search Action " ::temp7 ;@line 58
            CALLSTATIC debug MessageBox ::nonevar ::temp7 ;@line 58
            CALLSTATIC jvalue retain ::temp8 actionInfo "" ;@line 59
            CALLMETHOD OnAction self ::nonevar actionInfo ;@line 60
            CALLSTATIC jvalue release ::temp8 actionInfo ;@line 61
          .endCode
        .endFunction
        .function GetAllForms 
          .userFlags 0
          .docString ""
          .return Form[]
          .paramTable
            .param resultInfo int
          .endParamTable
          .localTable
          .endLocalTable
          .code
          .endCode
        .endFunction
        .function GetEditorId 
          .userFlags 0
          .docString ""
          .return string
          .paramTable
            .param actionInfo int
          .endParamTable
          .localTable
            .local ::temp9 int
            .local ::temp10 string
          .endLocalTable
          .code
            CALLSTATIC jmap getObj ::temp9 actionInfo "searchResult" 0 ;@line 79
            CALLSTATIC jmap getObj ::temp9 ::temp9 "data" 0 ;@line 79
            CALLSTATIC jmap getStr ::temp10 ::temp9 "editorId" "" ;@line 79
            RETURN ::temp10 ;@line 79
          .endCode
        .endFunction
      .endState
    .endStateTable
  .endObject
.endObjectTable