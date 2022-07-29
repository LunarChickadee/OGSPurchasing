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
            
            ;displaydata YrHolder
            
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

