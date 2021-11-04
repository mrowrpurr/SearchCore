scriptName SearchActionBase extends ReferenceAlias
{For a simple interface to implement your own
Search "actions", extend the `SearchAction` script.

`SearchActionBase` is a lower-level script which
makes it easy to implement *multiple* actions in the same script.

> **Note:** `SearchAction` extends `SearchActionBase`}

string property SEARCH_ACTION_SKSE_MOD_EVENT_PREFIX = "Search_Action_" autoReadonly

string[] _actionNames
string[] _callbackFunctionNames

string[] _onUpdateActions
int[]    _onUpdateActionInfos

Actor property PlayerRef
    Actor function get()
        return GetActorReference()
    endFunction
endProperty

event OnUpdate()
    if _onUpdateActions
        while _onUpdateActions
            string actionName = _onUpdateActions[0]
            int    actionInfo = _onUpdateActionInfos[0]
            InvokeAction(actionName, actionInfo)
            _onUpdateActions = Utility.ResizeStringArray(_onUpdateActions, _onUpdateActions.Length - 1)
            _onUpdateActionInfos = Utility.ResizeIntArray(_onUpdateActionInfos, _onUpdateActionInfos.Length - 1)
        endWhile
    endIf
endEvent

; Invokes another action provided its name and the `actionInfo` to pass along
function InvokeAction(string actionName, int actionInfo)
    int actionEvent = ModEvent.Create(SEARCH_ACTION_SKSE_MOD_EVENT_PREFIX + actionName)
    ModEvent.PushInt(actionEvent, actionInfo)
    ModEvent.Send(actionEvent)
endFunction

; This will invoke an action after the specified `delay` time
function InvokeActionAsync(string actionName, int actionInfo, float delay = 0.1)
    if _onUpdateActions
        _onUpdateActions = Utility.ResizeStringArray(_onUpdateActions, _onUpdateActions.Length + 1)
        _onUpdateActions[_onUpdateActions.Length - 1] = actionName
        _onUpdateActionInfos = Utility.ResizeIntArray(_onUpdateActionInfos, _onUpdateActionInfos.Length + 1)
        _onUpdateActionInfos[_onUpdateActionInfos.Length - 1] = actionInfo
    else
        _onUpdateActions = new string[1]
        _onUpdateActions[0] = actionName
        _onUpdateActionInfos = new int[1]
        _onUpdateActionInfos[0] = actionInfo
    endIf
    RegisterForSingleUpdate(delay)
endFunction

; Do **NOT** override this function.
;
; For initialization, please override `OnSearchActionBaseInit` instead.
event OnInit()
    OnSearchActionBaseInit()
    if _actionNames
        int i = 0
        while i < _actionNames.Length
            string actionName = _actionNames[i]
            string callback   = _callbackFunctionNames[i]
            RegisterForModEvent(SEARCH_ACTION_SKSE_MOD_EVENT_PREFIX + actionName, callback)
            i += 1
        endWhile
    endIf
endEvent

; Do **NOT** override this function.
;
; If you must override this function, please call `super.OnPlayerLoadGame()`
event OnPlayerLoadGame()
    OnSearchActionBaseInit()
    if _actionNames
        int i = 0
        while i < _actionNames.Length
            string actionName = _actionNames[i]
            string callback   = _callbackFunctionNames[i]
            RegisterForModEvent(SEARCH_ACTION_SKSE_MOD_EVENT_PREFIX + actionName, callback)
            i += 1
        endWhile
    endIf
endEvent

; Override this to configure your `SearchActionBase`
; e.g. to listen for mulitple "Search Actions"
;
; ```
; event OnSearchActionBaseInit()
;   ListenForSearchAction("ActionOne", "OnActionOne")
;   ListenForSearchAction("ActionTwo") ; Defaults to "OnActionTwo"
; endEvent
; ```
event OnSearchActionBaseInit()
    ; Intended to be overriden by sub-scripts
endEvent

; Sets up a listener for a "Search Action"
;
; > _Implementation detail: this automatically listens for_
; > _the provided event on Mod Install as well as after Player Load Games._
function ListenForSearchAction(string actionName, string callback = "")
    if ! callback
        callback = "On" + actionName
    endIf

    ; Add the action with its callback function name
    ; (these will be registered immediately and on player load game)
    if _actionNames
        _actionNames           = Utility.ResizeStringArray(_actionNames, _actionNames.Length + 1)
        _callbackFunctionNames = Utility.ResizeStringArray(_callbackFunctionNames, _callbackFunctionNames.Length + 1)
        _actionNames[_actionNames.Length - 1] = actionName
        _callbackFunctionNames[_callbackFunctionNames.Length - 1] = callback
    else
        _actionNames              = new string[1]
        _callbackFunctionNames    = new string[1]
        _actionNames[0]           = actionName
        _callbackFunctionNames[0] = callback
    endIf
endFunction

; Get a reference to the **individual** search result.
; If this action is called for a top-level list or category view, this will be zero.
int function GetSearchResult(int resultInfo)
    return JMap.getObj(resultInfo, "searchResult")
endFunction

string function GetSearchResultString(int resultInfo, string propertyName)
    return JMap.getStr(GetSearchResult(resultInfo), propertyName)
endFunction

int function GetSearchResults(int resultInfo)
    return JMap.getObj(resultInfo, "searchResults")
endFunction

string function GetCategoryName(int resultInfo)
    return JMap.getStr(resultInfo, "categoryName")
endFunction

Form[] function GetAllForms(int resultInfo)
    int theForms = JArray.object()
    JValue.retain(theForms)

    int categoriesArray
    string[] desiredCategoryNames
    string categoryName = GetCategoryName(resultInfo)

    if categoryName
        desiredCategoryNames    = new string[1]
        desiredCategoryNames[0] = categoryName
    else
        categoriesArray = JMap.getObj(JMap.getObj(resultInfo, "action"), "categories")
        if categoriesArray
            desiredCategoryNames = JArray.asStringArray(categoriesArray)
        endIf
    endIf

    int searchResult = GetSearchResult(resultInfo)
    if searchResult
        string formId = Search.GetResultFormId(searchResult)
        Form theForm  = FormHelper.HexToForm(formId)
        if theForm
            JArray.addForm(theForms, theForm)
        endIf
        Form[] theFormArray = JArray.asFormArray(theForms)
        JValue.release(theForms)
        return theFormArray
    endIf

    int searchResults        = GetSearchResults(resultInfo)
    int searchResultSetCount = Search.GetSearchResultSetCount(searchResults)
    int searchResultSetIndex = 0
    while searchResultSetIndex < searchResultSetCount
        int searchResultSet = Search.GetNthSearchResultSet(searchResults, searchResultSetIndex)
        string[] searchResultSetCategoryNames = Search.GetCategoryNamesForSearchResultSet(searchResultSet)
        int searchResultSetCategoryIndex = 0
        while searchResultSetCategoryIndex < searchResultSetCategoryNames.Length
            string searchResultSetCategoryName = searchResultSetCategoryNames[searchResultSetCategoryIndex]
            if ! desiredCategoryNames || desiredCategoryNames.Find(searchResultSetCategoryName) > -1
                int searchResultSetCategoryResultCount = Search.GetCategoryResultCountForSearchResultSet(searchResultSet, searchResultSetCategoryName)
                int searchResultSetCategoryResultIndex = 0
                while searchResultSetCategoryResultIndex < searchResultSetCategoryResultCount
                    searchResult = Search.GetNthCategoryResultForSearchResultSet(searchResultSet, searchResultSetCategoryName, searchResultSetCategoryResultIndex)
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

string function GetEditorId(int actionInfo)
    return Search.GetResultEditorId(JMap.getObj(actionInfo, "searchResult"))
endFunction

string function GetDisplayText(int actionInfo)
    return Search.GetResultDisplayText(JMap.getObj(actionInfo, "searchResult"))
endFunction

string function GetFormId(int actionInfo)
    return Search.GetResultFormId(JMap.getObj(actionInfo, "searchResult"))
endFunction

Form function GetForm(int actionInfo)
    return FormHelper.HexToForm(GetFormId(actionInfo))
endFunction

bool function IsSearchResult(int actionInfo)
    return GetSearchResult(actionInfo)
endFunction