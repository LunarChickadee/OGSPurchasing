global arrayLbsPerYear, ItemNumArray,wIngList,wMixIngList,wMxList,
arrayFiles,thisfolder,wComments,wPurch,TotalSoldArray, Available,
AvailArray,AvailHold,wMixes,
Yr1,Yr2,Yr3,Yr4,LbsHold,
MixLbsAvailDict, DictNamesArray,ItemSelect, 
PercHold, DictHold, PercDictArray,
MixPercChoice,PercChoice,ItemNumCounter,MixAv, MixWeightDictAv,
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


MixLbsAvailDict=""
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

;debug

//Clears the Dictionary
deletedictionaryvalue ParentDict,""

lastrecord
if str(ItemNum)=""
deleterecord
nop
endif

noyes "Did any ingredient percentages change since last DB build?"
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

;;debug
firstrecord
    ChangeYr:
    Window wMixes
    firstrecord
    deletedictionaryvalue MixLbsAvailDict,""
        loop
            field MixPoundsAvailabletoSell
            clipboard()=«»
            LbsHold=str(clipboard())
            setDictionaryValue MixLbsAvailDict, str(«Mix Parent Code»), LbsHold
            downrecord
        until info("stopped")
 //makes an array of the parent codes to loop through to search the dictionary
    listDictionarynames MixLbsAvailDict,DictNamesArray



    //find the percentage to do math with for each Mix Number
    //loop through the whole DictNames array
    ItemNumCounter=0
    MixAv="MixWeightAvailDict"
    window wPurch
  ;  ;debug
    field (MixAv)
    call ClearField
    RepeatDictLoop:
    loop
    ItemNumCounter=ItemNumCounter+1
        if ItemNumCounter<arraysize(DictNamesArray,¶)+1
            window wPurch
            field (MixAv)
            //select the right Dumped Dictionaries that have the percents
            //we want
            ItemSelect=array(DictNamesArray,ItemNumCounter,¶)
            select «MixPercDict» contains ItemSelect
                if info("empty")
                    ItemNumCounter=ItemNumCounter+1
                    ;;repeatloopif YrCounter<info("records")+1
                endif
            //get the Total Available Poulds from our previous Dictionary
            LbsHold=val(getdictionaryvalue(MixLbsAvailDict,ItemSelect))   

            loop
                //this finds which element of the array of x=y pairs (Dumped Dictionary) 
                //in MixPercDict
                //has the value we're looking for
                field MixPercDict
                PercChoice=arraysearch(arraycolumn(ItemSelect,1,¶,"="),ItemSelect,1,¶)
                if PercChoice = 0
                stop
                endif
                //this uses that element choice to grab the percent
                MixPercChoice=val(arraycolumn(array(MixPercDict,PercChoice,¶),2,¶,"="))
                field (MixAv)                        
                //This does the appropriate math
                MixLbsItem=0
                MixLbsItem=float(MixPercChoice)*float(LbsHold)
                //then adds to a dictionary that we'll use later
                deletedictionaryvalue MixWeightItemDict,""    
                setdictionaryvalue MixWeightItemDict, ItemSelect,str(MixLbsItem)
                ;;debug
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
                debug
            until info("stopped")  
        endif
    until ItemNumCounter>arraysize(DictNamesArray,¶)

