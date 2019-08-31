#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

`::send,{t} ;Binds the ~ button to T so it works just like SA:MP.

^!c::
   clipback := ClipboardAll
   Clipboard := ""
   Send ^c
   ClipWait, 0
   if !ErrorLevel {
      res := GetCorrectedResultFromYahoo(Clipboard)
      if (res = "") {
         ToolTip No corrected result
         SetTimer, ToolTipDel, -1000
      }
      else {
         Clipboard := res
         Send ^v
         Sleep, 200
      }
   }
   Clipboard := clipback
   Return
   
ToolTipDel() {
   Tooltip
}
   
GetCorrectedResultFromYahoo(query) {
   url := "https://search.yahoo.com/search?p=" . query
   whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
   whr.Open("GET", url, false)
   whr.Send()
   status := whr.status
   if (status != 200)
      throw Exception("Status: " status)
   res := whr.responseText
   RegExMatch(res, "is)Including results for.+?""unsafe-url"".*?>\K[^\s<][^<]*", match)
   Return match
}
