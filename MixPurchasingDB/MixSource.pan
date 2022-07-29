___ PROCEDURE (ForecastMacros) _________________________________________________

___ ENDPROCEDURE (ForecastMacros) ______________________________________________

___ PROCEDURE .BuildData _______________________________________________________
global arrayLbsPerYear, ItemNumArray,wIngList,wMixIngList,wMxList,arrayFiles,thisfolder,wComments,wPurch,TotalSoldArray,
CurrentYear,PrevYear,TwoYearsAgo,ThreeYearsAgo, Yr1Array,Yr2Array,Yr3Array,Yr4Array,SoldHold,wMixes

yesno "Years to get data from are: "+CurrentYear+", "+PrevYear+", "+TwoYearsAgo+", and "+ThreeYearsAgo+" ?"
if clipboard()="No"
message "Panorama will open the Procedure you need to edit. Find the //********** below"
goprocedure ".BuildData"
stop
endif

wPurch="MixPurchasingDB"
wComments="45ogscomments"
wMxList="MixIngList"
wIngList="IngMixList"
wMixes="Mixes Updated"
ItemNumArray=""

///these represent current (yr1) to 4 years back (yr4)
Yr1Array=""
Yr2Array=""
Yr3Array=""
Yr4Array=""

///Gets the List of Ingredients to Search with from the IngMixList
window wIngList
arraybuild ItemNumArray, ¶, "", «ItemList»


//********
//********
//these make it so all you have to do is chage the following code to make the rest work
//just change ##sold to the proper years!
window wComments
CurrentYear="45sold"
PrevYear="44sold"
TwoYearsAgo="43sold"
ThreeYearsAgo="42sold"
selectall
removeallsummaries
//********
//********
       
select ItemNumArray contains str(«parent_code»)
field «parent_code»
groupup


//loop1
firstrecord
loop
        if info("summary")>0
        arraystrip Yr1Array,¶
        field (CurrentYear)
        «» = float(arraynumerictotal(Yr1Array,¶))
        Yr1Array=""
        downrecord
        repeatloopif (not info("stopped"))
    endif

    field (CurrentYear)
        copycell
        SoldHold=clipboard()
        Yr1Array=str(float(SoldHold)*float(ActWt))+¶+str(Yr1Array)
    downrecord
until info("stopped")

///Loop2
firstrecord
loop

    if info("summary")>0
        arraystrip Yr2Array,¶
        field (PrevYear)
        «» = float(arraynumerictotal(Yr2Array,¶))
        Yr2Array=""
        downrecord
        repeatloopif (not info("stopped"))
    endif

    field (PrevYear)
        copycell
        SoldHold=clipboard()
        Yr2Array=str(float(SoldHold)*float(ActWt))+¶+str(Yr2Array)
    downrecord
until info("stopped")

///Loop3
firstrecord
loop

    if info("summary")>0
        arraystrip Yr3Array,¶
        field (TwoYearsAgo)
        «» = float(arraynumerictotal(Yr3Array,¶))
        Yr3Array=""
        downrecord
        repeatloopif (not info("stopped"))
    endif

    field (TwoYearsAgo)
        copycell
        SoldHold=clipboard()
        Yr3Array=str(float(SoldHold)*float(ActWt))+¶+str(Yr3Array)
    downrecord
until info("stopped")

///Loop4
firstrecord
loop

    if info("summary")>0
        arraystrip Yr4Array,¶
        field (ThreeYearsAgo)
        «» = float(arraynumerictotal(Yr4Array,¶))
        Yr4Array=""
        downrecord
        repeatloopif (not info("stopped"))
    endif

    field (ThreeYearsAgo)
        copycell
        SoldHold=clipboard()
        Yr4Array=str(float(SoldHold)*float(ActWt))+¶+str(Yr4Array)
    downrecord
until info("stopped")

lastrecord
deleterecord
nop

outlinelevel "2"

///**********************************************Part 2 Appending to The Purchasing Database

///Note: This uses global variables from .BuildData

global ParentDict, SoldArray, ParentCode, counter, Name,Lbs

ParentDict=""
SoldArray=""



///loop1
window wComments
firstrecord
loop
field (CurrentYear)
copycell
SoldArray=str(clipboard())
Name=str(«parent_code»)
setdictionaryvalue ParentDict, Name, SoldArray
downrecord
;message dumpdictionary(ParentDict)
until info("stopped")

window wPurch
loop
Name=Str(«ItemNum»)
if ParentDict contains «ItemNum»
LbsThisYear=val(getdictionaryvalue(ParentDict,Name))
downrecord
repeatloopif (not info("stopped"))
endif
downrecord
until info("stopped")

//Clears the Dictionary
ParentDict=""
///loop2
window wComments
firstrecord
loop
field (PrevYear)
copycell
SoldArray=str(clipboard())
Name=str(«parent_code»)
setdictionaryvalue ParentDict, Name, SoldArray
downrecord
;message dumpdictionary(ParentDict)
until info("stopped")

window wPurch
firstrecord
field LbsLastYear
loop
Name=Str(«ItemNum»)
if ParentDict contains «ItemNum»
LbsLastYear=val(getdictionaryvalue(ParentDict,Name))
downrecord
repeatloopif (not info("stopped"))
endif
downrecord
until info("stopped")

//Clears the Dictionary
ParentDict=""
///loop3
window wComments
firstrecord
loop
field (TwoYearsAgo)
copycell
SoldArray=str(clipboard())
Name=str(«parent_code»)
setdictionaryvalue ParentDict, Name, SoldArray
downrecord
;message dumpdictionary(ParentDict)
until info("stopped")

window wPurch
firstrecord
field Lbs2YrsAgo
loop
Name=Str(«ItemNum»)
if ParentDict contains «ItemNum»
Lbs2YrsAgo=val(getdictionaryvalue(ParentDict,Name))
downrecord
repeatloopif (not info("stopped"))
endif
downrecord
until info("stopped")

//Clears the Dictionary
ParentDict=""
///loop3
window wComments
firstrecord
loop
field (ThreeYearsAgo)
copycell
SoldArray=str(clipboard())
Name=str(«parent_code»)
setdictionaryvalue ParentDict, Name, SoldArray
downrecord
;message dumpdictionary(ParentDict)
until info("stopped")

window wPurch
firstrecord
field Lbs3YrsAgo
loop
Name=Str(«ItemNum»)
if ParentDict contains «ItemNum»
Lbs3YrsAgo=val(getdictionaryvalue(ParentDict,Name))
downrecord
repeatloopif (not info("stopped"))
endif
downrecord
until info("stopped")

lastrecord
if str(ItemNum)=""
deleterecord
nop
endif



///*****Part 3 Get the Percentages for the mixes in the database

window wPurch

global strItemArray, counter, 
MixLbsDict, ItemSelection,NumGet,PercGet,LbsGet,
IngPer,LineArrayIngs,checkSelect

IngPer=""

MixLbsDict=""

arraybuild strItemArray, ¶,"",«ItemNum»

counter=1
loop
    window wMixes
    selectall
    ItemSelection=array(strItemArray,counter,¶)
    select exportline() contains ItemSelection
        if info("empty")
        counter=counter+1
        repeatloopif counter<info("records")+1
        endif
    checkSelect=info("selected")
    RepeatFind:
    LineArrayIngs=lineitemarray(ItemIngredientΩ,¶)
    NumGet=arraysearch(LineArrayIngs,ItemSelection,1,¶ )
        if val(NumGet)<1
            downrecord
             if info("stopped")
            goto Skip
        else 
            goto RepeatFind
        endif
        endif
    ;NumGet=striptonum(info("fieldname"))
    IngPer="IngredientPercentage"+str(NumGet)
    field (IngPer)
    PercGet=«»/100
    setdictionaryvalue MixLbsDict,str(«Mix Parent Code»),str(PercGet)
    ;next
    ;debug
    downrecord
        if info("stopped")
            goto Skip
        else 
            goto RepeatFind
        endif
    ;repeatloopif info("found")

    Skip:
    window wPurch

    select ItemNum contains ItemSelection
    dumpdictionary MixLbsDict, MixPercDict
    MixLbsDict=""
    counter=counter+1
until counter>info("records")

////*****Part 4 Do Maths


global Yr1,Yr2,Yr3,Yr4,LbsHold,
MixLbsDict, DictNamesArray,ItemSelect, 
PercHold, DictHold, PercDictArray,
MixPercChoice,PercChoice,ItemNumCounter,YrHolder,MixYrHold,
MixLbsItem, MixWeightItemDict,YrCounter,AppendToMixWeight

Yr1="45 Mix Pounds Sold"
Yr2="44 Mix Pounds Sold"
Yr3="43 Mix Pounds Sold"
Yr4="42 Mix Pounds Sold"
MixLbsDict=""
PercHold=""
MixWeightItemDict=""


//Builds Dictionary of MixNumber and The Total Pounds Sold for X Year
Window wMixes
selectall
YrCounter=0

;debug
firstrecord
    ChangeYr:
    Window wMixes
    firstrecord
    YrCounter=YrCounter+1
    deletedictionaryvalue MixLbsDict,""
        loop
            //programatically picks a year and gets the Mix LBS sold for it
            //puts those into a dictionary of Code=Lbs
            YrHolder=arraybuild(¶,"","Yr1+¶+Yr2+¶+Yr3+¶+Yr4")
            YrHolder=array(YrHolder,YrCounter,¶)
            field (YrHolder)
            clipboard()=«»
            LbsHold=str(clipboard())
            setDictionaryValue MixLbsDict, str(«Mix Parent Code»), LbsHold
            downrecord
        until info("stopped")
    ;counter2=YrCounter
    ;YrCounter=YrCounter+1
    ///Makes an array of that Dictionary's Parent Codes
    //this lets us iterate through using the array fuction
    listDictionarynames MixLbsDict,DictNamesArray


    //find the percentage to do math with for each Mix Number
    //loop through the whole DictNames array
    ItemNumCounter=0
    MixYrHold="MixWeightDictYr"+str(YrCounter)
  ;  debug
    RepeatDictLoop:
    loop
    ItemNumCounter=ItemNumCounter+1
        if ItemNumCounter<arraysize(DictNamesArray,¶)+1
            window wPurch
            field (MixYrHold)
            ItemSelect=array(DictNamesArray,ItemNumCounter,¶)
            select MixPercDict contains ItemSelect
                if info("empty")
                    ItemNumCounter=ItemNumCounter+1
                    repeatloopif YrCounter<info("records")+1
                endif

            LbsHold=val(getdictionaryvalue(MixLbsDict,ItemSelect))   

            ///The next part is a complicated
            /*
            The arraycolumn is looking at the values that are ex. 1234=0.4 and saying to treat it
            like if it was a tiny database where the fields looked like
            column1     column2
            1234            0.04
            and I'm using that ability to separate them to find the correct value
            and then to extract the correct percentage to do math with
            */
           ; debug 
            loop
                //this finds which element of the array of x=y pairs (Dumped Dictionary) 
                //in MixPercDict
                //has the value we're looking for
                PercChoice=arraysearch(arraycolumn(ItemSelect,1,¶,"="),ItemSelect,1,¶)
                //this uses that element choice to grab the percent
                MixPercChoice=val(arraycolumn(array(MixPercDict,PercChoice,¶),2,¶,"="))
                field (MixYrHold)                        
                //This does the appropriate math
                MixLbsItem=0
                MixLbsItem=float(MixPercChoice)*float(LbsHold)
                //then adds to a dictionary that we'll use later
                deletedictionaryvalue MixWeightItemDict,""    
                setdictionaryvalue MixWeightItemDict, ItemSelect,str(MixLbsItem)
                ;debug
                AppendToMixWeight=""
                dumpdictionary MixWeightItemDict, AppendToMixWeight
                AppendToMixWeight=«»+¶+AppendToMixWeight
                //This Makes sure that any duplicate entries are deleted
                //instead of making a mess of doubled totals
                arraydeduplicate AppendToMixWeight,AppendToMixWeight,¶
                arraystrip AppendToMixWeight, ¶
                «» = AppendToMixWeight
                AppendToMixWeight=""
                downrecord
            until info("stopped")  
        endif
    until ItemNumCounter>arraysize(DictNamesArray,¶)

if YrCounter≠4
goto ChangeYr
endif





___ ENDPROCEDURE .BuildData ____________________________________________________

___ PROCEDURE .CheckCode _______________________________________________________
local test4, sel1,sel2

test4=MixWeightDictYr1
message test4

sel1="8060"

sel2=arraysearch(arraycolumn(MixWeightDictYr1,1,¶, "="), sel1, 1, ¶ )
message array(arraycolumn(MixWeightDictYr1,2,¶, "="),sel2,¶)
___ ENDPROCEDURE .CheckCode ____________________________________________________

___ PROCEDURE .AppendToMixPurch ________________________________________________
///Note: This uses global variables from .BuildData

global ParentDict, SoldArray, ParentCode, counter, Name,Lbs

ParentDict=""
SoldArray=""



///loop1
window wComments
firstrecord
loop
field (CurrentYear)
copycell
SoldArray=str(clipboard())
Name=str(«parent_code»)
setdictionaryvalue ParentDict, Name, SoldArray
downrecord
;message dumpdictionary(ParentDict)
until info("stopped")

window wPurch
loop
Name=Str(«ItemNum»)
if ParentDict contains «ItemNum»
LbsThisYear=val(getdictionaryvalue(ParentDict,Name))
downrecord
repeatloopif (not info("stopped"))
endif
downrecord
until info("stopped")

//Clears the Dictionary
ParentDict=""
///loop2
window wComments
firstrecord
loop
field (PrevYear)
copycell
SoldArray=str(clipboard())
Name=str(«parent_code»)
setdictionaryvalue ParentDict, Name, SoldArray
downrecord
;message dumpdictionary(ParentDict)
until info("stopped")

window wPurch
firstrecord
field LbsLastYear
loop
Name=Str(«ItemNum»)
if ParentDict contains «ItemNum»
LbsLastYear=val(getdictionaryvalue(ParentDict,Name))
downrecord
repeatloopif (not info("stopped"))
endif
downrecord
until info("stopped")

//Clears the Dictionary
ParentDict=""
///loop3
window wComments
firstrecord
loop
field (TwoYearsAgo)
copycell
SoldArray=str(clipboard())
Name=str(«parent_code»)
setdictionaryvalue ParentDict, Name, SoldArray
downrecord
;message dumpdictionary(ParentDict)
until info("stopped")

window wPurch
firstrecord
field Lbs2YrsAgo
loop
Name=Str(«ItemNum»)
if ParentDict contains «ItemNum»
Lbs2YrsAgo=val(getdictionaryvalue(ParentDict,Name))
downrecord
repeatloopif (not info("stopped"))
endif
downrecord
until info("stopped")

//Clears the Dictionary
ParentDict=""
///loop3
window wComments
firstrecord
loop
field (ThreeYearsAgo)
copycell
SoldArray=str(clipboard())
Name=str(«parent_code»)
setdictionaryvalue ParentDict, Name, SoldArray
downrecord
;message dumpdictionary(ParentDict)
until info("stopped")

window wPurch
firstrecord
field Lbs3YrsAgo
loop
Name=Str(«ItemNum»)
if ParentDict contains «ItemNum»
Lbs3YrsAgo=val(getdictionaryvalue(ParentDict,Name))
downrecord
repeatloopif (not info("stopped"))
endif
downrecord
until info("stopped")
___ ENDPROCEDURE .AppendToMixPurch _____________________________________________

___ PROCEDURE .GetPercentLbs ___________________________________________________
window wPurch

global strItemArray, counter, 
MixLbsDict, ItemSelection,NumGet,PercGet,LbsGet,
IngPer,LineArrayIngs,checkSelect,DictNames,
counter2,choice2,LbsField,LbsMath

IngPer=""

MixLbsDict=""

arraybuild strItemArray, ¶,"",«ItemNum»

counter=1
loop
    window wMixes
    selectall
    ItemSelection=array(strItemArray,counter,¶)
    select exportline() contains ItemSelection
        if info("empty")
        counter=counter+1
        repeatloopif counter<info("records")+1
        endif
    checkSelect=info("selected")
    RepeatFind:
    LineArrayIngs=lineitemarray(ItemIngredientΩ,¶)
    NumGet=arraysearch(LineArrayIngs,ItemSelection,1,¶ )
        if val(NumGet)<1
            downrecord
             if info("stopped")
            goto Skip
        else 
            goto RepeatFind
        endif
        endif
    ;NumGet=striptonum(info("fieldname"))
    IngPer="IngredientPercentage"+str(NumGet)
    LbsField="IngredientPoundsNeeded"+str(NumGet)
    field (IngPer)
    PercGet=«»/100
    field (LbsField)
    LbsGet=float(«»)
    LbsMath=PercGet*LbsGet
    setdictionaryvalue MixLbsDict,str(«Mix Parent Code»),str(LbsMath)    ;next
    ;next
        ;debug
    downrecord
        if info("stopped")
            goto Skip
        else 
            goto RepeatFind
        endif
    ;repeatloopif info("found")

    Skip:
    window wPurch

    select ItemNum contains ItemSelection
    dumpdictionary MixLbsDict, MixPercDict
    MixLbsDict=""
    counter=counter+1
until counter>info("records")

___ ENDPROCEDURE .GetPercentLbs ________________________________________________

___ PROCEDURE .getlbs __________________________________________________________

global Yr1,Yr2,Yr3,Yr4,LbsHold,
MixLbsDict, DictNamesArray,ItemSelect, 
PercHold, DictHold, PercDictArray,
MixPercChoice,PercChoice,ItemNumCounter,YrHolder,MixYrHold,
MixLbsItem, MixWeightItemDict,YrCounter,AppendToMixWeight

Yr1="45 Mix Pounds Sold"
Yr2="44 Mix Pounds Sold"
Yr3="43 Mix Pounds Sold"
Yr4="42 Mix Pounds Sold"
MixLbsDict=""
PercHold=""
MixWeightItemDict=""


//Builds Dictionary of MixNumber and The Total Pounds Sold for X Year
Window wMixes
selectall
YrCounter=0

;debug
firstrecord
    ChangeYr:
    Window wMixes
    firstrecord
    YrCounter=YrCounter+1
    deletedictionaryvalue MixLbsDict,""
        loop
            //programatically picks a year and gets the Mix LBS sold for it
            //puts those into a dictionary of Code=Lbs
            YrHolder=arraybuild(¶,"","Yr1+¶+Yr2+¶+Yr3+¶+Yr4")
            YrHolder=array(YrHolder,YrCounter,¶)
            field (YrHolder)
            clipboard()=«»
            LbsHold=str(clipboard())
            setDictionaryValue MixLbsDict, str(«Mix Parent Code»), LbsHold
            downrecord
        until info("stopped")
    ;counter2=YrCounter
    ;YrCounter=YrCounter+1
    ///Makes an array of that Dictionary's Parent Codes
    //this lets us iterate through using the array fuction
    listDictionarynames MixLbsDict,DictNamesArray


    //find the percentage to do math with for each Mix Number
    //loop through the whole DictNames array
    ItemNumCounter=0
    MixYrHold="MixWeightDictYr"+str(YrCounter)
  ;  debug
    RepeatDictLoop:
    loop
    ItemNumCounter=ItemNumCounter+1
        if ItemNumCounter<arraysize(DictNamesArray,¶)+1
            window wPurch
            field (MixYrHold)
            ItemSelect=array(DictNamesArray,ItemNumCounter,¶)
            select MixPercDict contains ItemSelect
                if info("empty")
                    ItemNumCounter=ItemNumCounter+1
                    repeatloopif YrCounter<info("records")+1
                endif

            LbsHold=val(getdictionaryvalue(MixLbsDict,ItemSelect))   

            ///The next part is a complicated
            /*
            The arraycolumn is looking at the values that are ex. 1234=0.4 and saying to treat it
            like if it was a tiny database where the fields looked like
            column1     column2
            1234            0.04
            and I'm using that ability to separate them to find the correct value
            and then to extract the correct percentage to do math with
            */
           ; debug 
            loop
                //this finds which element of the array of x=y pairs (Dumped Dictionary) 
                //in MixPercDict
                //has the value we're looking for
                PercChoice=arraysearch(arraycolumn(ItemSelect,1,¶,"="),ItemSelect,1,¶)
                //this uses that element choice to grab the percent
                MixPercChoice=val(arraycolumn(array(MixPercDict,PercChoice,¶),2,¶,"="))
                field (MixYrHold)                        
                //This does the appropriate math
                MixLbsItem=0
                MixLbsItem=float(MixPercChoice)*float(LbsHold)
                //then adds to a dictionary that we'll use later
                deletedictionaryvalue MixWeightItemDict,""    
                setdictionaryvalue MixWeightItemDict, ItemSelect,str(MixLbsItem)
                ;debug
                AppendToMixWeight=""
                dumpdictionary MixWeightItemDict, AppendToMixWeight
                AppendToMixWeight=«»+¶+AppendToMixWeight
                //This Makes sure that any duplicate entries are deleted
                //instead of making a mess of doubled totals
                arraydeduplicate AppendToMixWeight,AppendToMixWeight,¶
                arraystrip AppendToMixWeight, ¶
                «» = AppendToMixWeight
                AppendToMixWeight=""
                downrecord
            until info("stopped")  
        endif
    until ItemNumCounter>arraysize(DictNamesArray,¶)

if YrCounter≠4
goto ChangeYr
endif



___ ENDPROCEDURE .getlbs _______________________________________________________

___ PROCEDURE .getLbsV2 ________________________________________________________

global Yr1,Yr2,Yr3,Yr4,LbsHold,
MixLbsDict, DictNamesArray,DictSelect, 
PercHold, DictHold, PercDictArray,
MixPercChoice,PercChoice,counter3,YrHolder,MixYrHold

Yr1="45 Mix Pounds Sold"
Yr2="44 Mix Pounds Sold"
Yr3="43 Mix Pounds Sold"
Yr4="42 Mix Pounds Sold"
MixLbsDict=""
PercHold=""


//Builds Dictionary of MixNumber and The Total Pounds Sold for X Year
Window wMixes
selectall
firstrecord

counter=1
ChangeYr:
    loop
        YrHolder=arraybuild(¶,"","Yr1+¶+Yr2+¶+Yr3+¶+Yr4")
        YrHolder=array(YrHolder,counter,¶)
        field (YrHolder)
        clipboard()=«»
        LbsHold=str(clipboard())
        setDictionaryValue MixLbsDict, str(«Mix Parent Code»), LbsHold
        downrecord
    until info("stopped")
counter2=counter
counter=counter+1
///Makes an array of the Names (Mix #'s) in the Dictionary 
//this lets us iterate through using the array fuction
listDictionarynames MixLbsDict,DictNamesArray


//find the percentage to do math with for each Mix Number
//loop through the whole DictNames array
counter3=1
MixYrHold="MixWeightDictYr"+str(counter2)
loop
    if counter3<arraysize(DictNamesArray,¶)+1
        window wPurch
        field (MixYrHold)
        DictSelect=array(DictNamesArray,counter3,¶)
        select MixPercDict contains DictSelect
            if info("empty")
                counter3=counter3+1
                repeatloopif counter<info("records")+1
            endif
        counter3=counter3+1

        LbsHold=val(getdictionaryvalue(MixLbsDict,DictSelect))
        


        ///The next part is a complicated
        /*
        The arraycolumn is looking at the values that are ex. 1234=0.4 and saying to treat it
        like if it was a tiny database where the fields looked like
        column1     column2
        1234            0.04
        and I'm using that ability to separate them to find the correct value
        and then to extract the correct percentage to do math with
        */
        loop
            PercChoice=arraysearch(arraycolumn(DictSelect,1,¶,"="),DictSelect,1,¶)
            MixPercChoice=val(arraycolumn(array(MixPercDict,PercChoice,¶),2,¶,"="))
            MixWeightDictYr1=float(MixWeightDictYr1)+(float(MixPercChoice)*float(LbsHold))
            downrecord
        until info("stopped")  
    endif
until counter3>arraysize(DictNamesArray,¶)



___ ENDPROCEDURE .getLbsV2 _____________________________________________________

___ PROCEDURE ClearField _______________________________________________________
firstrecord
loop
clearcell
downrecord
until info("stopped")
___ ENDPROCEDURE ClearField ____________________________________________________

___ PROCEDURE .GetTotalLbs _____________________________________________________
global YrCount,counter4, MixDictArray,FHold1,FHold2,LbsArray1

YrCount=0
selectall
NextYear:
YrCount=YrCount+1
firstrecord
loop
    LbsArray1=0
    FHold1="MixLbsYr"+str(YrCount)
    FHold2="MixWeightDictYr"+str(YrCount)
    field (FHold2)
    clipboard()=«»
    MixDictArray=clipboard()


    counter4=1

        loop
        LbsArray1=LbsArray1+val(arraycolumn(array(MixDictArray,counter4,¶),2,¶,"="))
        increment counter4
        until counter4>arraysize(MixDictArray,¶)

    Field (FHold1)
    «» = LbsArray1
    counter4=1
    LbsArray1=0
    downrecord
    until info("stopped")

    if YrCount≠4
    goto NextYear
endif

___ ENDPROCEDURE .GetTotalLbs __________________________________________________

___ PROCEDURE ReBuildDatabase __________________________________________________
global arrayLbsPerYear, ItemNumArray,wIngList,wMixIngList,wMxList,
arrayFiles,thisfolder,wComments,wPurch,TotalSoldArray,
CurrentYear,PrevYear,TwoYearsAgo,ThreeYearsAgo, Yr1Array,
Yr2Array,Yr3Array,Yr4Array,SoldHold,wMixes,
Yr1,Yr2,Yr3,Yr4,LbsHold,
MixLbsDict, DictNamesArray,ItemSelect, 
PercHold, DictHold, PercDictArray,
MixPercChoice,PercChoice,ItemNumCounter,YrHolder,MixYrHold,
MixLbsItem, MixWeightItemDict,YrCounter,AppendToMixWeight,
WindowCheck, WindowsNeeded
permanent vTimeLastUsed
////************
////************
//these make it so all you have to do is chage the following code to make the rest work
/*
Edit
the
following
fields and databases 
to the correct years!
*/
//**************
Yr1="45 Mix Pounds Sold"
Yr2="44 Mix Pounds Sold"
Yr3="43 Mix Pounds Sold"
Yr4="42 Mix Pounds Sold"

CurrentYear="45sold"
PrevYear="44sold"
TwoYearsAgo="43sold"
ThreeYearsAgo="42sold"

wPurch="MixPurchasingDB"
wComments="45ogscomments"
wMxList="MixIngList"
wIngList="IngMixList"
wMixes="Mixes Updated"

///*************

/*this is just a test of how to get files to open programatically\

Doesn't currently work

WindowCheck=info("windows")

WindowsNeeded=wPurch+¶+wComments+wMxList+wIngList+wMixes
*/


MixLbsDict=""
PercHold=""
MixWeightItemDict=""

yesno "Years to get data from are: "
+CurrentYear+", "+PrevYear+", "+TwoYearsAgo+", and "+ThreeYearsAgo+" ?"
if clipboard()="No"
message "Panorama will open the Procedure you need to edit. Find the //********** "
goprocedure "ReBuildDatabase"
stop
endif

debug

ItemNumArray=""

///these represent current (yr1) to 4 years back (yr4)
Yr1Array=""
Yr2Array=""
Yr3Array=""
Yr4Array=""

///Gets the List of Ingredients to Search with from the IngMixList
window wIngList
arraybuild ItemNumArray, ¶, "", «ItemList»


//********
//********
window wComments
selectall
removeallsummaries
//********
//********

select ItemNumArray contains str(«parent_code»)
field «parent_code»
groupup



//loop1
firstrecord
loop
        if info("summary")>0
        arraystrip Yr1Array,¶
        field (CurrentYear)
        «» = float(arraynumerictotal(Yr1Array,¶))
        Yr1Array=""
        downrecord
        repeatloopif (not info("stopped"))
    endif

    field (CurrentYear)
        copycell
        SoldHold=clipboard()
        Yr1Array=str(float(SoldHold)*float(ActWt))+¶+str(Yr1Array)
    downrecord
until info("stopped")

///Loop2
firstrecord
loop

    if info("summary")>0
        arraystrip Yr2Array,¶
        field (PrevYear)
        «» = float(arraynumerictotal(Yr2Array,¶))
        Yr2Array=""
        downrecord
        repeatloopif (not info("stopped"))
    endif

    field (PrevYear)
        copycell
        SoldHold=clipboard()
        Yr2Array=str(float(SoldHold)*float(ActWt))+¶+str(Yr2Array)
    downrecord
until info("stopped")

///Loop3
firstrecord
loop

    if info("summary")>0
        arraystrip Yr3Array,¶
        field (TwoYearsAgo)
        «» = float(arraynumerictotal(Yr3Array,¶))
        Yr3Array=""
        downrecord
        repeatloopif (not info("stopped"))
    endif

    field (TwoYearsAgo)
        copycell
        SoldHold=clipboard()
        Yr3Array=str(float(SoldHold)*float(ActWt))+¶+str(Yr3Array)
    downrecord
until info("stopped")

///Loop4
firstrecord
loop

    if info("summary")>0
        arraystrip Yr4Array,¶
        field (ThreeYearsAgo)
        «» = float(arraynumerictotal(Yr4Array,¶))
        Yr4Array=""
        downrecord
        repeatloopif (not info("stopped"))
    endif

    field (ThreeYearsAgo)
        copycell
        SoldHold=clipboard()
        Yr4Array=str(float(SoldHold)*float(ActWt))+¶+str(Yr4Array)
    downrecord
until info("stopped")




lastrecord
deleterecord
nop

outlinelevel "2"


/*
****Part 2 Appending to The Purchasing Database
*/

;debug

global ParentDict, SoldArray, ParentCode, counter, Name,Lbs

ParentDict=""
SoldArray=""

///loop1
window wComments
firstrecord
loop
    field (CurrentYear)
    copycell
    SoldArray=str(clipboard())
    Name=str(«parent_code»)
    setdictionaryvalue ParentDict, Name, SoldArray
    downrecord
    ;message dumpdictionary(ParentDict)
until info("stopped")

window wPurch
firstrecord
loop
    Name=Str(«ItemNum»)
        if ParentDict contains «ItemNum»
        LbsThisYear=val(getdictionaryvalue(ParentDict,Name))
        downrecord
            repeatloopif (not info("stopped"))
    endif
    downrecord
until info("stopped")

//Clears the Dictionary
deletedictionaryvalue ParentDict,""
///loop2
window wComments
firstrecord
loop
field (PrevYear)
copycell
SoldArray=str(clipboard())
Name=str(«parent_code»)
setdictionaryvalue ParentDict, Name, SoldArray
downrecord
;message dumpdictionary(ParentDict)
until info("stopped")

window wPurch
firstrecord
field LbsLastYear
loop
Name=Str(«ItemNum»)
if ParentDict contains «ItemNum»
LbsLastYear=val(getdictionaryvalue(ParentDict,Name))
downrecord
repeatloopif (not info("stopped"))
endif
downrecord
until info("stopped")

//Clears the Dictionary
deletedictionaryvalue ParentDict,""
///loop3
window wComments
firstrecord
loop
field (TwoYearsAgo)
copycell
SoldArray=str(clipboard())
Name=str(«parent_code»)
setdictionaryvalue ParentDict, Name, SoldArray
downrecord
;message dumpdictionary(ParentDict)
until info("stopped")

window wPurch
firstrecord
field Lbs2YrsAgo
loop
Name=Str(«ItemNum»)
if ParentDict contains «ItemNum»
Lbs2YrsAgo=val(getdictionaryvalue(ParentDict,Name))
downrecord
repeatloopif (not info("stopped"))
endif
downrecord
until info("stopped")

//Clears the Dictionary
ParentDict=""
///loop3
window wComments
firstrecord
loop
field (ThreeYearsAgo)
copycell
SoldArray=str(clipboard())
Name=str(«parent_code»)
setdictionaryvalue ParentDict, Name, SoldArray
downrecord
;message dumpdictionary(ParentDict)
until info("stopped")

window wPurch
firstrecord
field Lbs3YrsAgo
loop
Name=Str(«ItemNum»)
if ParentDict contains «ItemNum»
Lbs3YrsAgo=val(getdictionaryvalue(ParentDict,Name))
downrecord
repeatloopif (not info("stopped"))
endif
downrecord
until info("stopped")

deletedictionaryvalue ParentDict,""

lastrecord
if str(ItemNum)=""
deleterecord
nop
endif



///*****Part 3 Get the Percentages for the mixes in the database

window wPurch

global strItemArray, counter, 
MixLbsDict, ItemSelection,NumGet,PercGet,LbsGet,
IngPer,LineArrayIngs,checkSelect

IngPer=""

MixLbsDict=""

arraybuild strItemArray, ¶,"",«ItemNum»

counter=1

/*
8012
9001
3432

*/
loop
    window wMixes
    selectall
    ItemSelection=array(strItemArray,counter,¶)
    select exportline() contains ItemSelection
        if info("empty")
        counter=counter+1
        repeatloopif counter<info("records")+1
        endif
    checkSelect=info("selected")
    RepeatFind:
    LineArrayIngs=lineitemarray(ItemIngredientΩ,¶)
    NumGet=arraysearch(LineArrayIngs,ItemSelection,1,¶ )
        if val(NumGet)<1
            downrecord
             if info("stopped")
            goto Skip
        else 
            goto RepeatFind
        endif
        endif
    ;NumGet=striptonum(info("fieldname"))
    IngPer="IngredientPercentage"+str(NumGet)
    field (IngPer)
    PercGet=«»/100
    setdictionaryvalue MixLbsDict,str(«Mix Parent Code»),str(PercGet)
    ;next
    ;debug
    downrecord
        if info("stopped")
            goto Skip
        else 
            goto RepeatFind
        endif
    ;repeatloopif info("found")

    Skip:
    window wPurch

    select ItemNum contains ItemSelection
    dumpdictionary MixLbsDict, MixPercDict
    MixLbsDict=""
    counter=counter+1
until counter>info("records")

////*****Part 4 Get Perc * Weight

//Builds Dictionary of MixNumber and The Total Pounds Sold for X Year
Window wMixes
selectall
YrCounter=0

debug
firstrecord
    ChangeYr:
    Window wMixes
    firstrecord
    YrCounter=YrCounter+1
    deletedictionaryvalue MixLbsDict,""
        loop
            //programatically picks a year and gets the Mix LBS sold for it
            //puts those into a dictionary of Code=Lbs
            YrHolder=arraybuild(¶,"","Yr1+¶+Yr2+¶+Yr3+¶+Yr4")
            YrHolder=array(YrHolder,YrCounter,¶)
            
            displaydata YrHolder
            
            field (YrHolder)
            clipboard()=«»
            LbsHold=str(clipboard())
            setDictionaryValue MixLbsDict, str(«Mix Parent Code»), LbsHold
            downrecord
        until info("stopped")
    ;counter2=YrCounter
    ;YrCounter=YrCounter+1
    ///Makes an array of that Dictionary's Parent Codes
    //this lets us iterate through using the array fuction
    listDictionarynames MixLbsDict,DictNamesArray


    //find the percentage to do math with for each Mix Number
    //loop through the whole DictNames array
    ItemNumCounter=0
    MixYrHold="MixWeightDictYr"+str(YrCounter)
  ;  debug
    RepeatDictLoop:
    loop
    ItemNumCounter=ItemNumCounter+1
        if ItemNumCounter<arraysize(DictNamesArray,¶)+1
            window wPurch
            field (MixYrHold)
            ItemSelect=array(DictNamesArray,ItemNumCounter,¶)
            select MixPercDict contains ItemSelect
                if info("empty")
                    ItemNumCounter=ItemNumCounter+1
                    repeatloopif YrCounter<info("records")+1
                endif

            LbsHold=val(getdictionaryvalue(MixLbsDict,ItemSelect))   

            ///The next part is a complicated
            /*
            The arraycolumn is looking at the values that are ex. 1234=0.4 and saying to treat it
            like if it was a tiny database where the fields looked like
            column1     column2
            1234            0.04
            and I'm using that ability to separate them to find the correct value
            and then to extract the correct percentage to do math with
            */
           ; debug 
            loop
                //this finds which element of the array of x=y pairs (Dumped Dictionary) 
                //in MixPercDict
                //has the value we're looking for
                PercChoice=arraysearch(arraycolumn(ItemSelect,1,¶,"="),ItemSelect,1,¶)
                //this uses that element choice to grab the percent
                MixPercChoice=val(arraycolumn(array(MixPercDict,PercChoice,¶),2,¶,"="))
                field (MixYrHold)                        
                //This does the appropriate math
                MixLbsItem=0
                MixLbsItem=float(MixPercChoice)*float(LbsHold)
                //then adds to a dictionary that we'll use later
                deletedictionaryvalue MixWeightItemDict,""    
                setdictionaryvalue MixWeightItemDict, ItemSelect,str(MixLbsItem)
                ;debug
                AppendToMixWeight=""
                dumpdictionary MixWeightItemDict, AppendToMixWeight
                AppendToMixWeight=«»+¶+AppendToMixWeight
                //This Makes sure that any duplicate entries are deleted
                //instead of making a mess of doubled totals
                arraydeduplicate AppendToMixWeight,AppendToMixWeight,¶
                arraystrip AppendToMixWeight, ¶
                «» = AppendToMixWeight
                AppendToMixWeight=""
                downrecord
            until info("stopped")  
        endif
    until ItemNumCounter>arraysize(DictNamesArray,¶)

if YrCounter≠4
goto ChangeYr
endif

///////****** Part 5 Fill in Weights

global YrCount,counter4, MixDictArray,FHold1,FHold2,LbsArray1

YrCount=0
selectall
NextYear:
YrCount=YrCount+1
firstrecord
loop
    LbsArray1=0
    FHold1="MixLbsYr"+str(YrCount)
    FHold2="MixWeightDictYr"+str(YrCount)
    field (FHold2)
    clipboard()=«»
    MixDictArray=clipboard()


    counter4=1

        loop
        LbsArray1=LbsArray1+val(arraycolumn(array(MixDictArray,counter4,¶),2,¶,"="))
        increment counter4
        until counter4>arraysize(MixDictArray,¶)

    Field (FHold1)
    «» = LbsArray1
    counter4=1
    LbsArray1=0
    downrecord
    until info("stopped")

if YrCount≠4
goto NextYear
endif

vTimeLastUsed=datepattern(today(),"mm-dd-YY")


___ ENDPROCEDURE ReBuildDatabase _______________________________________________

___ PROCEDURE Update Available _________________________________________________
global arrayLbsPerYear, ItemNumArray,wIngList,wMixIngList,wMxList,
arrayFiles,thisfolder,wComments,wPurch,TotalSoldArray, Available,
AvailArray,AvailHold,wMixes,
Yr1,Yr2,Yr3,Yr4,LbsHold,
MixLbsDict, DictNamesArray,ItemSelect, 
PercHold, DictHold, PercDictArray,
MixPercChoice,PercChoice,ItemNumCounter,MixAvHold, MixWeightDictAv,
MixLbsItem, MixWeightItemDict,YrCounter,AppendToMixWeight,
WindowCheck, WindowsNeeded
permanent vTimeLastUsed
////************
////************
//these make it so all you have to do is chage the following code to make the rest work
/*
Edit
the
following
fields and databases 
to the correct years!
*/
//**************

Available="45available"
AvailArray=""
AvailHold=""

wPurch="MixPurchasingDB"
wComments="45ogscomments"
wMxList="MixIngList"
wIngList="IngMixList"
wMixes="Mixes Updated"

///*************

/*this is just a test of how to get files to open programatically\

Doesn't currently work

WindowCheck=info("windows")

WindowsNeeded=wPurch+¶+wComments+wMxList+wIngList+wMixes
*/


MixLbsDict=""
PercHold=""
MixWeightItemDict=""

global wComments, wMxList, wIngList, wMixes

wComments="45ogscomments"
wMxList="MixIngList"
wIngList="IngMixList"
wMixes="Mixes Updated"

openfile wComments
openfile wMxList
openfile wIngList
openfile wMixes

yesno "Year to get data from is:"+ Available +" ?"
if clipboard()="No"
message "Panorama will open the Procedure you need to edit. Find the //********** "
goprocedure "ReBuildDatabase"
stop
endif



ItemNumArray=""

///Gets the List of Ingredients to Search with from the IngMixList
window wIngList
arraybuild ItemNumArray, ¶, "", «ItemList»



//********
//********
window wComments
selectall
removeallsummaries
//********
//********

select ItemNumArray contains str(«parent_code»)
field «parent_code»
groupup

//loop1
firstrecord
loop
        if info("summary")>0
        arraystrip AvailArray,¶
        field (Available)
        «» = float(arraynumerictotal(AvailArray,¶))
        AvailArray=""
        downrecord
        repeatloopif (not info("stopped"))
    endif

    field (Available)
        copycell
        AvailHold=clipboard()
        AvailArray=str(float(AvailHold)*float(ActWt))+¶+str(AvailArray)
    downrecord
until info("stopped")

debug
lastrecord
deleterecord
nop

outlinelevel "2"


/*
****Part 2 Appending to The Purchasing Database
*/

global ParentDict, ParentCode, counter, Name,Lbs

ParentDict=""
AvailArray=""

deletedictionaryvalue ParentDict,""

///loop1
window wComments
firstrecord
loop
    field (Available)
    copycell
    AvailArray=str(clipboard())
    Name=str(«parent_code»)
    setdictionaryvalue ParentDict, Name, AvailArray
    downrecord
    ;;message dumpdictionary(ParentDict)
until info("stopped")

window wPurch
firstrecord
loop
    Name=Str(«ItemNum»)
        if ParentDict contains «ItemNum»
        AvailableLbs=val(getdictionaryvalue(ParentDict,Name))
        downrecord
            repeatloopif (not info("stopped"))
    endif
    downrecord
until info("stopped")

debug

//Clears the Dictionary
deletedictionaryvalue ParentDict,""

lastrecord
if str(ItemNum)=""
deleterecord
nop
endif

yesno "Did any ingredient percentages change since last DB build?"
if clipboard()="Yes"
message "Panorama will open the Procedure you need to edit. Find the //********** "
goprocedure "ReBuildDatabase"
stop
endif


////*****Part 3 Get Perc * Weight

//Update MixPoundsAvailableToSell in wMixes


farcall "Mixes Updated", "Pounds of Mixes Available"


//Builds Dictionary of MixNumber and The Total Pounds Available
Window wMixes
selectall
YrCounter=0

;debug
firstrecord
    ChangeYr:
    Window wMixes
    firstrecord
    deletedictionaryvalue MixLbsDict,""
        loop
            //programatically picks a year and gets the Mix LBS sold for it
            //puts those into a dictionary of Code=Lbs
            ;;YrHolder=arraybuild(¶,"","Yr1+¶+Yr2+¶+Yr3+¶+Yr4")
            ;;YrHolder=array(YrHolder,YrCounter,¶)
            field (MixPoundsAvailabletoSell)
            clipboard()=«»
            LbsHold=str(clipboard())
            setDictionaryValue MixLbsDict, str(«Mix Parent Code»), LbsHold
            downrecord
        until info("stopped")
    ;counter2=YrCounter
    ;YrCounter=YrCounter+1
    ///Makes an array of that Dictionary's Parent Codes
    //this lets us iterate through using the array fuction
    listDictionarynames MixLbsDict,DictNamesArray



    //find the percentage to do math with for each Mix Number
    //loop through the whole DictNames array
    ItemNumCounter=0
    MixAvHold="MixWeightDictAvail"
  ;  debug
    RepeatDictLoop:
    loop
    ItemNumCounter=ItemNumCounter+1
        if ItemNumCounter<arraysize(DictNamesArray,¶)+1
            window wPurch
            field (MixAvHold)
            ItemSelect=array(DictNamesArray,ItemNumCounter,¶)
            select MixPercDict contains ItemSelect
                if info("empty")
                    ItemNumCounter=ItemNumCounter+1
                    ;;repeatloopif YrCounter<info("records")+1
                endif

            LbsHold=val(getdictionaryvalue(MixLbsDict,ItemSelect))   

            ///The next part is a complicated
            /*
            The arraycolumn is looking at the values that are ex. 1234=0.4 and saying to treat it
            like if it was a tiny database where the fields looked like
            column1     column2
            1234            0.04
            and I'm using that ability to separate them to find the correct value
            and then to extract the correct percentage to do math with
            */
           ; debug 
            loop
                //this finds which element of the array of x=y pairs (Dumped Dictionary) 
                //in MixPercDict
                //has the value we're looking for
                PercChoice=arraysearch(arraycolumn(ItemSelect,1,¶,"="),ItemSelect,1,¶)
                //this uses that element choice to grab the percent
                MixPercChoice=val(arraycolumn(array(MixPercDict,PercChoice,¶),2,¶,"="))
                field (MixYrHold)                        
                //This does the appropriate math
                MixLbsItem=0
                MixLbsItem=float(MixPercChoice)*float(LbsHold)
                //then adds to a dictionary that we'll use later
                deletedictionaryvalue MixWeightItemDict,""    
                setdictionaryvalue MixWeightItemDict, ItemSelect,str(MixLbsItem)
                ;debug
                AppendToMixWeight=""
                dumpdictionary MixWeightItemDict, AppendToMixWeight
                AppendToMixWeight=«»+¶+AppendToMixWeight
                //This Makes sure that any duplicate entries are deleted
                //instead of making a mess of doubled totals
                arraydeduplicate AppendToMixWeight,AppendToMixWeight,¶
                arraystrip AppendToMixWeight, ¶
                «» = AppendToMixWeight
                AppendToMixWeight=""
                downrecord
            until info("stopped")  
        endif
    until ItemNumCounter>arraysize(DictNamesArray,¶)

if YrCounter≠4
goto ChangeYr
endif

///////****** Part 5 Fill in Weights

global YrCount,counter4, MixDictArray,FHold1,FHold2,LbsArray1

YrCount=0
selectall
NextYear:
YrCount=YrCount+1
firstrecord
loop
    LbsArray1=0
    FHold1="MixLbsYr"+str(YrCount)
    FHold2="MixWeightDictYr"+str(YrCount)
    field (FHold2)
    clipboard()=«»
    MixDictArray=clipboard()


    counter4=1

        loop
        LbsArray1=LbsArray1+val(arraycolumn(array(MixDictArray,counter4,¶),2,¶,"="))
        increment counter4
        until counter4>arraysize(MixDictArray,¶)

    Field (FHold1)
    «» = LbsArray1
    counter4=1
    LbsArray1=0
    downrecord
    until info("stopped")

if YrCount≠4
goto NextYear
endif

vTimeLastUsed=datepattern(today(),"mm-dd-YY")

___ ENDPROCEDURE Update Available ______________________________________________

___ PROCEDURE open DBs _________________________________________________________
global wComments, wMxList, wIngList, wMixes

wComments="45ogscomments"
wMxList="MixIngList"
wIngList="IngMixList"
wMixes="Mixes Updated"

openfile wComments
openfile wMxList
openfile wIngList
openfile wMixes
___ ENDPROCEDURE open DBs ______________________________________________________

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
