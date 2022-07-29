___ PROCEDURE Pounds Sold Last Year ____________________________________________
global vPoundssold, vItem

openfile "44ogscomments.linked"
gosheet

window "Mixes"

field «Mix Parent Code»
sortup
firstrecord

loop
    vItem = «Mix Parent Code»
    window "44ogscomments.linked"
    //Field «parent_code»
    Select «parent_code» = vItem
    Field sparetext3
    Total
    copycell
    //removesummaries
    window "Mixes"
    find «Mix Parent Code» = vItem
    field «43 Mix Pounds Sold»
    pastecell
    downrecord
until info("stopped")
    

___ ENDPROCEDURE Pounds Sold Last Year _________________________________________

___ PROCEDURE test _____________________________________________________________
global IngArray,PercArray, PercentDict

IngArray=str(lineitemarray(ItemIngredientΩ,","))
PercArray=lineitemarray(IngredientPercentageΩ,",")
arraystrip IngArray,","
arraystrip PercArray,","

if arraysize(IngArray,",")≠arraysize(PercArray,",")
message "You are missing either ingredients or Percentages on Code: "+«Mix Parent Code»
stop
endif

/*

notes for future me
goal is to get all those percentages of the total pounds for each item into a dictionary for each mix parent code
have the dictionary update the total every time it matches the item 
so that you have a running total of all the mixes items used
*/
___ ENDPROCEDURE test __________________________________________________________

___ PROCEDURE .soldthisyear ____________________________________________________
global vItem, vWeight
vItem = ""
vWeight=""
openfile "45ogscomments"
window "Mixes"

field «Mix Parent Code»
firstrecord
loop
    vItem = «Mix Parent Code»
    window "45ogscomments"
        select «parent_code» = vItem 
        Field sparemoney3
        FormulaFill ActWt*«45sold»
        Total
        lastrecord
        vWeight = sparemoney3
    window "Mixes"
        field «45 Mix Pounds Sold»
        «45 Mix Pounds Sold» = vWeight
        downrecord
until info("stopped")
window "45ogscomments" removeallsummaries
window "Mixes"
___ ENDPROCEDURE .soldthisyear _________________________________________________

___ PROCEDURE Pounds Sold This Year ____________________________________________
global vItem

openfile "44ogscomments.linked"
gosheet

window "Mixes"

field «Mix Parent Code»
sortup
firstrecord

loop
    vItem = «Mix Parent Code»
    window "44ogscomments.linked"
    //Field «parent_code»
    Select «parent_code» = vItem
    Field sparetext3
    Total
    copycell
    //removesummaries
    window "Mixes"
    find «Mix Parent Code» = vItem
    field «44 Mix Pounds Sold»
    pastecell
    downrecord
until info("stopped")
    

___ ENDPROCEDURE Pounds Sold This Year _________________________________________

___ PROCEDURE getfields ________________________________________________________

___ ENDPROCEDURE getfields _____________________________________________________

___ PROCEDURE GetFields ________________________________________________________
local GetNames

GetNames="" 

loop
if «Field Name» notcontains "Ingredient"
downrecord
else
GetNames=«Field Name»+¶+GetNames
endif
downrecord
until info("stopped")

clipboard()=GetNames

___ ENDPROCEDURE GetFields _____________________________________________________

___ PROCEDURE ShowMe ___________________________________________________________
local FullList, EachLine, CountOfItems, GetNumber, ChangedArray, ReversedArray

FullList="Ingredient 17 Pounds Needed
Ingredient 17 Percentage
Ingredient 17 Descrption
Ingredient 17 Item
Ingredient 16 Pounds Needed
Ingredient 16 Percentage
Ingredient 16 Description
Ingredient 16 Item
Ingredient 15 Pounds Needed
Ingredient 15 Percentage
Ingredient 15 Descrption
Ingredient 15 Item
Ingredient 14 Pounds Needed
Ingredient 14 Percentage
Ingredient 14 Description
Ingredient 14 Item
Ingredient 13 Pounds Needed
Ingredient 13 Percentage
Ingredient 13 Description
Ingredient 13 Item
Ingredient 12 Pounds Needed
Ingredient 12 Percentage
Ingredient 12 Description
Ingredient 12 Item
Ingredient 11 Pounds Needed
Ingredient 11 Percentage
Ingredient 11 Description
Ingredient 11 Item
Ingredient 10 Pounds Needed
Ingredient 10 Percentage
Ingredient 10 Description
Ingredient 10 Item
Ingredient 9 Pounds Needed
Ingredient 9 Percentage
Ingredient 9 Description
Ingredient 9 Item
Ingredient 8 Pounds Needed
Ingredient 8 Percentage
Ingredient 8 Description
Ingredient 8 Item
Ingredient 7 Pounds Needed
Ingredient 7 Percentage
Ingredient 7 Description
Ingredient 7 Item
Ingredient 6 Pounds Needed
Ingredient 6 Percentage
Ingredient 6 Description
Ingredient 6 Item
Ingredient 5 Pounds Needed
Ingredient 5 Percentage
Ingredient 5 Description
Ingredient 5 Item
Ingredient 4 Pounds Needed
Ingredient 4 Percentage
Ingredient 4 Description
Ingredient 4 Item
Ingredient 3 Pounds Needed
Ingredient 3 Percentage
Ingredient 3 Description
Ingredient 3 Item
Ingredient 2 Pounds Needed
Ingredient 2 Percentage
Ingredient 2 Description
Ingredient 2 Item
Ingredient 1 Pounds Needed
Ingredient 1 Percentage
Ingredient 1 Description"

ReversedArray=arrayreverse(FullList,¶)
FullList=ReversedArray

CountOfItems=arraysize(FullList,¶) //gives us the number of items in the array
EachLine=array(FullList, CountOfItems, ¶) //a line in the list ex: ingredient 1 pounds needed
//EachLine="Ingredient 1 Description"
GetNumber=array(EachLine, 2, " ")
//message GetNumber
ChangedArray=arraychange(EachLine, "", 2, " ")
ChangedArray=arraystrip(ChangedArray," ")
append ChangedArray," "+GetNumber





___ ENDPROCEDURE ShowMe ________________________________________________________

___ PROCEDURE tabdown/2 ________________________________________________________
;; a helper macro that triggers equations to recalculate

firstrecord
loop
Cell «»
downrecord
until info("stopped")

___ ENDPROCEDURE tabdown/2 _____________________________________________________

___ PROCEDURE .finditem ________________________________________________________
/* This macro creates the finditem variable (an ingredient parent code)
to select mixes that use that specific ingredient. The "test2" macro
then utilizes the finditem variable*/

global finditem
GetscrapOK "What's the Item# ?"
finditem=val(clipboard())
Select exportline() contains str(finditem)

___ ENDPROCEDURE .finditem _____________________________________________________

___ PROCEDURE .test2 ___________________________________________________________
global vPercent, vInMixes, vMix

vPercent = ""
vInMixes = ""
firstrecord
field ItemIngredient1
/* This macro calculates how many pounds of an ingredient is available in the total available number of #s of that mix */
loop
copycell
    if
     str(clipboard())=str(finditem)
          message "found it"
     right
     right
     copycell
     vPercent=clipboard()
     vInMixes = (vPercent/100)*MixPoundsAvailabletoSell
     message vInMixes
     «Mix Parent Code» = vMix
     
    else
        right
        right
        right
        right
    endif
 



___ ENDPROCEDURE .test2 ________________________________________________________

___ PROCEDURE Pounds of Mixes Available ________________________________________
global vItem, vWeight,wMixes
vItem = ""
vWeight=""
wMixes="Mixes Updated"
openfile "45ogscomments"
window wMixes

field «Mix Parent Code»
firstrecord
loop
    vItem = «Mix Parent Code»
    window "45ogscomments"
        select «parent_code» = vItem 
        Field sparemoney3
        FormulaFill ActWt*«45available»
        Total
        lastrecord
        vWeight = sparemoney3
        removeallsummaries
    window wMixes
        field MixPoundsAvailabletoSell
       MixPoundsAvailabletoSell = vWeight
        downrecord
until info("stopped")
window "45ogscomments" 
removeallsummaries
window wMixes
___ ENDPROCEDURE Pounds of Mixes Available _____________________________________

___ PROCEDURE .Initialize ______________________________________________________
call "Pounds of Mixes Available"
___ ENDPROCEDURE .Initialize ___________________________________________________

___ PROCEDURE .lineitemtest ____________________________________________________
global HoldingArray,strItem,strMixList

window "45MixPurchasingDB"
strItem=str(ItemNum)
HoldingArray=""
strMixList=""
window "Mixes"
firstrecord
selectall

loop
HoldingArray=lineitemarray(ItemIngredientΩ,¶)
if HoldingArray contains strItem
strMixList=strMixList+¶+str(«Mix Parent Code»)
endif
downrecord
until info("stopped")




___ ENDPROCEDURE .lineitemtest _________________________________________________

___ PROCEDURE .fielddelete _____________________________________________________
local fieldscount, fieldscount2

fieldscount=dbinfo("fields","")
;message str(arraysize(fieldscount,¶))
fieldscount2=dbinfo("fields","Mixes")
;message str(arraysize(fieldscount,¶))

message arraydifference(fieldscount,fieldscount2,¶)
/*
loop
if «Field Name» notcontains "Mix"
deleterecord
endif
until «Field Name» contains "Mix"
*/

;equation:(«Ingredient 1 Percentage»/100)*«Pounds Left to Sell» Ω

/*
iteming=num/0
des=text
percent=num/w
lbs=num/float
*/

___ ENDPROCEDURE .fielddelete __________________________________________________

___ PROCEDURE (CommonFunctions) ________________________________________________

___ ENDPROCEDURE (CommonFunctions) _____________________________________________

___ PROCEDURE ExportMacros _____________________________________________________
local Dictionary1, ProcedureList
//this saves your procedures into a variable
exportallprocedures "", Dictionary1
clipboard()=Dictionary1

message "Macros are saved to your clipboard!"
___ ENDPROCEDURE ExportMacros __________________________________________________

___ PROCEDURE ImportMacros _____________________________________________________
local Dictionary1,Dictionary2, ProcedureList
Dictionary1=""
Dictionary1=clipboard()
yesno "Press yes to import all macros from clipboard"
if clipboard()="No"
stop
endif
//step one
importdictprocedures Dictionary1, Dictionary2
//changes the easy to read macros into a panorama readable file

 
//step 2
//this lets you load your changes back in from an editor and put them in
//copy your changed full procedure list back to your clipboard
//now comment out from step one to step 2
//run the procedure one step at a time to load the new list on your clipboard back in
//Dictionary2=clipboard()
loadallprocedures Dictionary2,ProcedureList
message ProcedureList //messages which procedures got changed

___ ENDPROCEDURE ImportMacros __________________________________________________

___ PROCEDURE Symbol Reference _________________________________________________
bigmessage "Option+7= ¶  [in some functions use chr(13)
Option+= ≠ [not equal to]
Option+\= « || Option+Shift+\= » [chevron]
Option+L= ¬ [tab]
Option+Z= Ω [lineitem or Omega]
Option+V= √ [checkmark]
Option+M= µ [nano]
Option+<or>= ≤or≥ [than or equal to]"


___ ENDPROCEDURE Symbol Reference ______________________________________________

___ PROCEDURE GetDBInfo ________________________________________________________
local DBChoice, vAnswer1, vClipHold

Message "This Procedure will give you the names of Fields, procedures, etc in the Database"
//The spaces are to make it look nicer on the text box
DBChoice="fields
forms
procedures
permanent
folder
level
autosave
fileglobals
filevariables
fieldtypes
records
selected
changes"
superchoicedialog DBChoice,vAnswer1,“caption="What Info Would You Like?"
captionheight=1”


vClipHold=dbinfo(vAnswer1,"")
bigmessage "Your clipboard now has the name(s) of "+str(vAnswer1)+"(s)"+¶+
"Preview: "+¶+str(vClipHold)
Clipboard()=vClipHold

___ ENDPROCEDURE GetDBInfo _____________________________________________________
