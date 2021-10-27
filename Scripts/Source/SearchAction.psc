scriptName SearchAction extends ReferenceAlias
{Extend this to create your own list action for the 'Search' mod}

string _actionName

; Gets or sets the short name of the action.
; Will extract name from conventionally named actions,
; e.g. `Search_Action_CenterOnCell` becomes `CenterOnCell`
string property ActionName
    string function get()
        if ! _actionName
            string theScriptName = self ; [Search_Action_Foo < (12345678)>]
            if StringUtil.Find(self, "[Search_Action_") == 0
                _actionName = StringUtil.Substring(self, 15, StringUtil.Find(theScriptName, " ") - 15)
            endIf
        endIf
        return _actionName
    endFunction
    function set(string value)
        _actionName = value
    endFunction
endProperty

event OnInit()
    OnActionInit()
    RegisterForModEvent("Search_Action_" + ActionName, "OnSearchAction")
endEvent

event OnPlayerLoadGame()
    OnActionInit()
    RegisterForModEvent("Search_Action_" + ActionName, "OnSearchAction")
endEvent

; Override this to set your `ActionName` etc
;
; ```
; event OnActionInit()
;   ActionName = "MyCoolAction"
; endEvent
; ```
event OnActionInit()
    ; Meant to be overriden
endEvent

; Override this to implement a custom action
event OnAction(int resultInfo)
    ; Intended to be overriden
endEvent

; DO NOT OVERRIDE THIS ~ use `OnAction()` instead
event OnSearchAction(string actionName, int searchResults, string categoryName, int searchResultSet, int searchResult)
    int resultInfo = JMap.object()
    JMap.setObj(resultInfo, "searchResult", searchResult)
    JMap.setObj(resultInfo, "searchResults", searchResults)
    JMap.setObj(resultInfo, "searchResultSet", searchResultSet)
    JMap.setStr(resultInfo, "categoryName", categoryName)
    JValue.retain(resultInfo)
    OnAction(resultInfo)
    JValue.release(resultInfo)
endEvent

; Form function GetForm(int resultInfo) global
; endFunction

; string function GetFormId(int resultInfo) global
; endFunction

string function GetEditorId(int resultInfo)
    return JMap.getStr(JMap.getObj(JMap.getObj(resultInfo, "searchResult"), "data"), "editorId")
endFunction

; string function GetProviderName(int resultInfo) global
; endFunction
