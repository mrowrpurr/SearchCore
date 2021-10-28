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

Actor property PlayerRef
    Actor function get()
        return GetActorReference()
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
event OnAction(int actionInfo)
    ; Intended to be overriden
endEvent

; DO NOT OVERRIDE THIS ~ use `OnAction()` instead
event OnSearchAction(int actionInfo)
    JValue.retain(actionInfo)
    OnAction(actionInfo)
    JValue.release(actionInfo)
endEvent

int function GetSearchResults(int resultInfo)
    return JMap.getObj(resultInfo, "searchResults")
endFunction

Form[] function GetAllFormsForCategories(int resultInfo)
    int theForms = JArray.object()
    JValue.retain(theForms)

    string[] desiredCategoryNames = JArray.asStringArray(JMap.getObj(JMap.getObj(resultInfo, "action"), "categories"))

    int searchResults        = GetSearchResults(resultInfo)
    int searchResultSetCount = Search.GetSearchResultSetCount(searchResults)
    int searchResultSetIndex = 0
    while searchResultSetIndex < searchResultSetCount
        int searchResultSet = Search.GetNthSearchResultSet(searchResults, searchResultSetIndex)
        string[] searchResultSetCategoryNames = Search.GetCategoryNamesForSearchResultSet(searchResultSet)
        int searchResultSetCategoryIndex = 0
        while searchResultSetCategoryIndex < searchResultSetCategoryNames.Length
            string searchResultSetCategoryName = searchResultSetCategoryNames[searchResultSetCategoryIndex]
            if desiredCategoryNames.Find(searchResultSetCategoryName) > -1
                int searchResultSetCategoryResultCount = Search.GetCategoryResultCountForSearchResultSet(searchResultSet, searchResultSetCategoryName)
                int searchResultSetCategoryResultIndex = 0
                while searchResultSetCategoryResultIndex < searchResultSetCategoryResultCount
                    int searchResult = Search.GetNthCategoryResultForSearchResultSet(searchResultSet, searchResultSetCategoryName, searchResultSetCategoryResultIndex)
                    string formId    = Search.GetResultFormId(searchResult)
                    Form theForm     = FormHelper.HexToForm(formId)
                    if theForm
                        JArray.addForm(theForms, theForm)
                    endIf
                    searchResultSetCategoryResultIndex += 1
                endWhile
            endIf
            searchResultSetCategoryIndex += 1
        endWhile
        searchResultSetIndex += 1
    endWhile

    Form[] theFormArray = JArray.asFormArray(theForms)
    JValue.release(theForms)

    return theFormArray
endFunction



; Form function GetForm(int resultInfo)
; endFunction

; string function GetFormId(int resultInfo)
; endFunction

string function GetEditorId(int actionInfo)
    return JMap.getStr(JMap.getObj(JMap.getObj(actionInfo, "searchResult"), "data"), "editorId")
endFunction

; string function GetProviderName(int resultInfo)
; endFunction
