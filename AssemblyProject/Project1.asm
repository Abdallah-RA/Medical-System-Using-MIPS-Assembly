.data
filename: .asciiz "C:\\Users\\frozn\\Downloads\\P1\\Pa.txt"
###Menu String Display###
menu: .asciiz "=Welcome to MTP=\n(1)Add a new medical test\n(2)Search for a test by patient ID\n(3)Searching for unnormal tests\n(4)Average test value\n(5)Update an existing test result\n(6)Delete a test\n(E)Exit\n\nChoose :"
newline: .asciiz "\n"
newTestEntry: .space 20


patientTests: .space 128
fileContent: .space 2048
askToEnterYear:.asciiz "Enter the year of the test : "
askToEnterMonth:.asciiz "Enter the mounth of the test : "
invalidYear:.asciiz "Invalid year, Enter year again"
invalidMonth: .asciiz "invalid month, Enter the month again"
askToEnterResult: .asciiz "Enter the test result : "
askForResultAgainF: .asciiz "Invalid floting number, Enter again"
searchAlgo: .asciiz "1-Retrieve all patient tests\n2-Retrieve all up normal patient tests\n3-Retrieve all patient tests in a given specific period\n\nChoose :"
updated: .asciiz "Patient recored has been updated successfully\n"

medicalTest: .asciiz "Hgb:13.8-17.2,BGT:70.0-99.0,LDL:0.0-100.0,SBP:0.0-120.0,DBP:0.0-80.0"
medicalTtoVeri:.asciiz "Hgb","BGT","LDL","SBP","DBP","0"
askForMTName:.asciiz "Enter The name of the test (3 char):"
askNTagain: .asciiz "Invalid Test name, enter again."

askForId:.asciiz "Enter the patient ID :"
askForIDAgain:.asciiz "Innvalid Id , please enter the Id agian\n"
testNotFound: .asciiz "Test not found\n"
resultLabel: .asciiz "Patient's test results:\n"
testAdded:.asciiz "\nPatient data has been added successfully\n"
notFoundedId:.asciiz "\nThe input ID is not founded in the recoreds\n"
noUp: .asciiz "Patient Dont have Up normal tests "
askToEnterIitialPeriod: .asciiz "Enter the from period(year-month(YYYY-MM)):"
askToEnterToPeriod:.asciiz "Enter to period (year-month(YYYY-MM)): "
####Temp Data#####
patientRecored:.space  28
patientId: .space 8
nameTest: .space 4
yearOfTest: .space 5
monthOfTest: .space 3
resultOfTest:.space 8
date: .space 8
minRange: .space 8
maxRange: .space 8
initialPeriod: .space 8
toPeriod: .space 8
intValue:.float 0
floatValue : .float 0
line:.space 28

.text
.globl main

main:
  
    jal readFile
  
      
    
 
menuloop:
    la $a0,menu
    li $v0,4
    syscall 
    li $v0, 12             
    syscall
    move $t1, $v0           
     
    # Check user's choice and call the appropriate function
    beq $t1, 49, addTest            
    beq $t1, 50, searchTest         
    beq $t1, 51, searchUnnormalTests 
    beq $t1, 52, averageTestValue 
    beq $t1, 53, updateTestResult 
    beq $t1, 54, deleteTest       
    beq $t1, 69, exitProgram       
    beq $t1, 101, exitProgram      
    j menuloop

addTest:

askForUId:
    li $v0, 4
    la $a0, newline
    syscall

    li $v0, 4
    la $a0, askForId
    syscall

    li $v0, 5
    syscall
    
    move $t0,$v0
    
    li $t2,9999999


    blt $t0,$t2, minIdRange
    
    
    li $v0, 4
    la $a0, askForIDAgain
    syscall
    
    j askForUId

minIdRange:
     li $t2,1000000
     bgt $t0,$t2,idPass
     
     
    li $v0, 4
    la $a0, askForIDAgain
    syscall
    
   j askForUId
     
     
    
    
idPass:  

    move $a0, $t0        
    la $a1, patientId    
    li $a3,7
    jal int2str 
    
                     
askForTestName: 
    
    li $v0,4
    la $a0,askForMTName
    syscall 
    
    li $v0,8
    la $a0,nameTest
    li $a1,4
    syscall 
    
 
    la $t3, medicalTtoVeri 
    la $t2,nameTest   
    li $t4, 0     
    li $t5,3  



verifyTestNameLoop:
    lb $t6, 0($t3)           
    addiu $t3, $t3, 1   
    
    beq $t6,48, testFail     

    lb $t7, 0($t2)            
    addiu $t2, $t2, 1
    beqz $t7, loadNameAgian      

    beq $t6, $t7, addCharT   

    j verifyTestNameLoop
    
loadNameAgian:
    la $t2,nameTest
    j verifyTestNameLoop

addCharT:
    addiu $t4,$t4,1
    beq $t4,$t5,testNamePass
    
    j verifyTestNameLoop

testFail:
   li $v0,4
   la $a0,askNTagain
   syscall  
   
    li $v0, 4
    la $a0, newline
    syscall
   j askForTestName

testNamePass:
     li $v0, 4
        la $a0, newline
        syscall
        
    
    
askForYear:
    li $v0,4
    la $a0,askToEnterYear
    syscall
    
    li $v0,5
    syscall 
    
    move $t0,$v0
    
    bgt $t0,2024,askForYearAgain
    
    blt $t0,2020,askForYearAgain
    
    move $a0, $t0        
    la $a1, yearOfTest   
    li $a3,4 
    jal int2str 
    
    
askForMonth:  
    li $v0,4
    la $a0,askToEnterMonth
    syscall
    
    li $v0,5
    syscall 
    
    move $t0,$v0 
   
    bgt $t0,12,askForMonthAgain
    blt $t0,1,askForMonthAgain
    
    


 
    move $a0, $t0        
    la $a1, monthOfTest 
    blt $t0, 10, movZero
    li $a3,2 
    jal int2str 
    j dontMove
 
 movZero:
    li $t1,48
    sb $t1,0($a1)
    addiu $a1,$a1,1
    addiu $t0,$t0,48
    sb $t0,0($a1)

dontMove:
    j datePass
   
     
    
    
askForYearAgain:
         li $v0,4
         la $a0,invalidYear
         syscall
         
        li $v0, 4
        la $a0, newline
        syscall
        
        j askForYear
        
askForMonthAgain:
        li $v0,4
         la $a0,invalidMonth
         syscall
         
        li $v0, 4
        la $a0, newline
        syscall
        
        j askForMonth     

datePass:

askForResult:
       li $v0,4
       la $a0,askToEnterResult
       syscall
       
       
       li $v0,8
       la $a0,resultOfTest
       li $a1,8
       syscall 
       
    la $t0, resultOfTest
    move $t5,$t0
    addiu $t5,$t5,1  
    li $t1,0

loopToVerifyResult:
     lb $t2, 0($t0)        
    beq $t2,10,doneLen
    addiu $t0, $t0, 1     
    
    beq $t2,46,checkDot
    blt $t2,48,askForResultAgain
    bgt $t2,57,askForResultAgain
    
    j loopToVerifyResult
    
 
checkDot:
  
   beq $t0,$t5,askForResultAgain
   addiu $t1,$t1,1
   bgt $t1,1,askForResultAgain
   
   j loopToVerifyResult
    
askForResultAgain:
       li $v0,4
       la $a0,askForResultAgainF
       syscall 
        
        li $v0, 4
        la $a0, newline
        syscall
        
         j  askForResult
doneLen:



la $t1, fileContent 


lastIndexLoop:
    lb $t2, ($t1)    
    beqz $t2, foundEnd  
    addi $t1, $t1, 1 
    j lastIndexLoop   


foundEnd:

la $a0, patientId


copyIdLoop:
    lb $t2, ($a0)     
    beqz $t2, doneCopyingId  
    sb $t2, ($t1)     
    addi $t1, $t1, 1 
    addi $a0, $a0, 1  
    j copyIdLoop       

doneCopyingId:
   
   li $t4,58
   sb $t4,($t1)
   addi $t1, $t1, 1 
    
   la $a0, nameTest
copyNameLoop:
    lb $t2, ($a0)     
    beqz $t2, doneCopyingName 
    sb $t2, ($t1)     
    addi $t1, $t1, 1 
    addi $a0, $a0, 1  
    j copyNameLoop   
    
doneCopyingName:

   
   li $t4,44
   sb $t4,($t1)
   addi $t1, $t1, 1 
    
   la $a0, yearOfTest
copyYearLoop:
    lb $t2, ($a0)     
    beqz $t2, doneCopyingYear
    sb $t2, ($t1)     
    addi $t1, $t1, 1 
    addi $a0, $a0, 1  
    j copyYearLoop   
    
doneCopyingYear: 
   li $t4,45
   sb $t4,($t1)
   addi $t1, $t1, 1
   la $a0, monthOfTest
copyMonthLoop:
    lb $t2, ($a0)     
    beqz $t2, doneCopyingMonth
    sb $t2, ($t1)     
    addi $t1, $t1, 1 
    addi $a0, $a0, 1  
    j copyMonthLoop   
    
doneCopyingMonth: 
   li $t4,44
   sb $t4,($t1)
   addi $t1, $t1, 1 

   la $a0, resultOfTest
   
copyResultLoop:
    lb $t2, ($a0)     
    beqz $t2, doneCopyingResult
    sb $t2, ($t1)     
    addi $t1, $t1, 1 
    addi $a0, $a0, 1  
    j copyResultLoop   
    
doneCopyingResult:
    li $t0,10
    sb $t0,0($t1)
    addi $t1, $t1, 1     
    sb $zero, ($t1)  
    li $v0,4
    la $a0,testAdded
    syscall
     li $v0,4
    la $a0,newline
    syscall
  
     li $v0,4
     la $a0,fileContent
     syscall 
     
    j menuloop



#----------------------------------------------------------
# int2str: Converts an unsigned integer into a string
# Input: $a0 = value, $a1 = buffer address 
# Output: None
#----------------------------------------------------------
int2str:  
   

   li $t0, 10         # $t0 = divisor = 10
   addu $v0, $a1, $a3 # start at end of buffer
   sb $zero, 0($v0)   # store a NULL character

L2: 
   divu $a0, $t0     # LO = value/10, HI = value%10
   mflo $a0          # $a0 = value/10
   mfhi $t1          # $t1 = value%10
   addiu $t1, $t1, 48   # convert digit into ASCII
   addiu $v0, $v0, -1  # point to previous byte
   sb $t1, 0($v0)
   bnez $a0, L2     # loop if value is not 0
done:


   jr $ra           # return to caller





searchTest:

     li $v0,4
     la $a0,newline
     syscall
     
     li $v0,4
     la $a0,askForId
     syscall 
     
     li $v0,8
     la $a0,patientId
     li $a1,8
     syscall 
     
     
      li $v0,4
     la $a0,newline
     syscall
     
     li $v0,4
     la $a0, searchAlgo
     syscall 
     
     
     li $v0,5
     syscall 
     
     move $t0,$v0
     
     beq $t0,1,searchAll
     beq $t0,2,searchUpNormal
     beq $t0,3,searchOnPeriod
     
searchAll:
    la $a0,fileContent
    la $a1,patientId
    li $a2,7
    li $a3,0

searchAllLoop:
   lb $t2, 0($a0)
   lb $t3,0($a1)
   beqz $t2,endOfFileContent
   addiu $a0,$a0,1
   addiu $a1,$a1,1
   bne $t2,$t3,notEqId
   subiu $a2,$a2,1
   beqz $a2,idFounded
  
   
  j searchAllLoop
  
notEqId:
   la $a1,patientId
   li $a2,7
nextRecored:
   lb $t2, 0($a0)
   addiu $a0,$a0,1
   beqz $t2,endOfFileContent
   beq $t2,10 searchAllLoop
   j nextRecored
   
   

idFounded:   
   addiu $a3,$a3,1 
   la $a1,patientId
   la $t1,patientRecored
copyIdToRecored:
   lb $t2, ($a1)     
   beqz $t2, doneId 
   sb $t2, ($t1)     
   addiu $t1, $t1, 1 
   addiu $a1, $a1, 1  
   j copyIdToRecored 
doneId:

copyRestOfRecord:
    lb $t2, 0($a0)
    beqz $t2, endOfFileContent
    beq $t2, 10, doneRecord
    sb $t2, ($t1)
    addiu $t1, $t1, 1
    addiu $a0, $a0, 1
    j copyRestOfRecord

doneRecord:
    li $t2, 0
    sb $t2, ($t1)
    
    move $t3,$a0
    
    li $v0,4
    la $a0,patientRecored
    syscall 
    
    li $v0,4
    la $a0,newline
    syscall
      
    move $a0,$t3
   la $a1,patientId
   li $a2,7
      
    j searchAllLoop

         
endOfFileContent:
    beqz $a3, notFounded
    j menuloop
notFounded:
    li $v0,4
    la $a0,notFoundedId 
    syscall  
     j menuloop
    
     
      
       
         
     
searchUpNormal:
    la $a0, fileContent     
    la $a1, patientId       
    li $a2, 7             
    li $a3, 0              

searchUpNormalLoop:
    lb $t2, 0($a0)       
    lb $t3, 0($a1)        


    beqz $t2, endOfFileContentUp
    addiu $a0, $a0, 1
    addiu $a1, $a1, 1
    bne $t2, $t3, notEqIdUp
    subiu $a2, $a2, 1


    beqz $a2, idFoundedUp

    j searchUpNormalLoop

notEqIdUp:
    la $a1, patientId      
    li $a2, 7             
    j nextRecordUp

nextRecordUp:
    lb $t2, 0($a0)          
    addiu $a0, $a0, 1      
    beqz $t2, endOfFileContentUp
    beq $t2, 10, searchUpNormalLoop
    j nextRecordUp

idFoundedUp:
    addiu $a3, $a3, 1
    la $t3, nameTest         
    li $t6, 3                
    addiu $a0, $a0, 1        
copyTestNameUp:
    lb $t5, 0($a0)
    sb $t5, 0($t3)
    addiu $t3, $t3, 1
    addiu $a0, $a0, 1
    subiu $t6, $t6, 1
    bnez $t6, copyTestNameUp


    li $t5, 0
    sb $t5, 0($t3)

    addiu $a0, $a0, 1
    la $t3, date             
    li $t6, 7               
copyDateUp:
    lb $t5, 0($a0)
    sb $t5, 0($t3)
    addiu $t3, $t3, 1
    addiu $a0, $a0, 1
    subiu $t6, $t6, 1
    bnez $t6, copyDateUp

    addiu $a0, $a0, 1
    li $t5, 0
    sb $t5, 0($t3)
    la $t3, resultOfTest   
copyResultUp:
    lb $t5, 0($a0)
    beq $t5, 10, doneCopyResultUp   
    sb $t5, 0($t3)
    addiu $t3, $t3, 1
    addiu $a0, $a0, 1
    j copyResultUp

doneCopyResultUp:
   la $t5, medicalTest
   la $t4, nameTest
   li $t3,3
   li $t7,0
findTheTest: 
    lb $t1,0($t5)
    lb $t0,0($t4)
    beqz $t1,endOfArray
    addiu $t4,$t4,1
    addiu $t5,$t5,1
    bne $t0,$t1,notEqName   
    subiu $t3,$t3,1
    beqz $t3,foundedName
    j findTheTest   
    
notEqName:
   
nextStringLoop:
    lb $t1, 0($t5)       
    beqz $t1, endOfArray 
    beq $t1,',',foundNextString 
    addiu $t5, $t5, 1    
    j nextStringLoop     

foundNextString:
    addiu $t5, $t5, 1    
    la $t4, nameTest
    li $t3, 3            
    j findTheTest        

foundedName:
  addiu $t7,$t7,1
  j endOfArray

endOfArray:  
    beq $t7,1,startCopy
    j menuloop

startCopy:  
  addiu $t5, $t5, 1       
    la $t3, minRange        
    la $t6, maxRange       
copyMinLoop:
    lb $t2, 0($t5)     
    beq $t2, '-', foundDash 
    sb $t2,0($t3)
    addiu $t5, $t5, 1       
    addiu $t3, $t3, 1       
    j copyMinLoop           
   
foundDash:
    addiu $t3, $t3, 1       
    li $t2,0
    sb $t2,0($t3)
    addiu $t5, $t5, 1       
copyMaxLoop:
    lb $t2, 0($t5)     
    beq $t2, ',', doneCopyMax
    sb $t2,0($t6)
    addiu $t5, $t5, 1       
    addiu $t6, $t6, 1       
    j copyMaxLoop           
           
doneCopyMax:
    la $t2 , resultOfTest
    li $t3,0
strlenResult:
   lb $t4,0($t2)
 
   beqz $t4, doneStrlenResult
   beq $t4,'.' ,addT
   blt $t4,'0',doneStrlenResult
   bgt $t4,'9',doneStrlenResult
   addT:
   addiu $t2,$t2,1
   addiu $t3,$t3,1

   j strlenResult
doneStrlenResult:


    la $t1 , minRange
    li $t4,0
strlenMin:
   lb $t5,0($t1)
   beqz $t5, doneStrlenMin
   addiu $t1,$t1,1
   addiu $t4,$t4,1
   j strlenMin
doneStrlenMin:
    
    move $t8,$t3
    beq $t3,$t4,startCopmaring
    blt $t3,$t4,printRecored
    bgt $t3,$t4,checkMaxRange
    

startCopmaring:  
   
   la $t0,resultOfTest
   la $t1,minRange 
    
loopToCompareMin:
   lb $t2,0($t0)
   lb $t3,0($t1)
   addiu $t0,$t0,1
   addiu $t1,$t1,1
   blt $t2,$t3,printRecored
   bgt $t2,$t3,checkMaxRange
   j loopToCompareMin
   

   
      

checkMaxRange:  
   la $t1,maxRange
   li $t4,0
strlenMax:
   lb $t5,0($t1)
   beqz $t5, doneStrlenMax
   addiu $t1,$t1,1
   addiu $t4,$t4,1
   j strlenMax
doneStrlenMax: 

   
    beq $t8,$t4,startCopmaringMax
    bgt $t8,$t4,printRecored
    blt $t8,$t4,searchUpNormalLoop
     
    
startCopmaringMax:

   la $t0,resultOfTest
   la $t1,maxRange 
    
loopToCompareMax:
   lb $t2,0($t0)
   lb $t3,0($t1)
   addiu $t0,$t0,1
   addiu $t1,$t1,1
   bgt $t2,$t3,printRecored
   blt $t2,$t3,searchUpNormalLoop
   j loopToCompareMax
   
   
  

printRecored:
   
   move $t7,$a0
   addiu $t7,$t7,1
   li $v0,4
   la $a0,patientId
   syscall 
   li $v0,11
   li $a0,58
   syscall 
    li $v0,4
   la $a0,nameTest
   syscall 
    li $v0,11
   li $a0,44
   syscall 
   
   li $v0,4
   la $a0,date
   syscall 
   
   li $v0,11
   li $a0,44
   syscall 
    li $v0,4
   la $a0,resultOfTest
   syscall 
   
   li $v0,4
   la $a0,newline
   syscall 

   move $a0,$t7
   la $a1, patientId       
   li $a2, 7 
   
   
   
 
   
    j searchUpNormalLoop

endOfFileContentUp:

    beqz $a3, noUpNormal
    j menuloop

noUpNormal:
     li $v0,4
     la $a0,noUp
     syscall
    j menuloop


searchOnPeriod: 
       li $v0,4
       la $a0,askToEnterIitialPeriod
       syscall 
       
       li $v0,8
       la $a0,initialPeriod
       li $a1,8
       syscall 
       li $v0,4
       la $a0,newline
       syscall
        
       li $v0,4
       la $a0,askToEnterToPeriod
       syscall 
       
       li $v0,8
       la $a0,toPeriod
       li $a1,8
       syscall
       li $v0,4
       la $a0,newline
       syscall
        
    la $a0, fileContent     
    la $a1, patientId       
    li $a2, 7             


searchFromToLoop:
    lb $t2, 0($a0)       
    lb $t3, 0($a1)        
  
    beqz $t2, endOfFileContentFromTo
    addiu $a0, $a0, 1
    addiu $a1, $a1, 1
    bne $t2, $t3, notEqIdFromTo
    subiu $a2, $a2, 1


    beqz $a2, idFoundedFromTo

    j searchFromToLoop
    
    
notEqIdFromTo:

    la $a1, patientId      
    li $a2, 7             
    j nextRecordFromTo

nextRecordFromTo:
    lb $t2, 0($a0)          
    addiu $a0, $a0, 1      
    beqz $t2, endOfFileContentFromTo
    beq $t2, 10, searchFromToLoop
    j nextRecordFromTo


idFoundedFromTo: 
  
     addiu $a3, $a3, 1
    la $t3, nameTest         
    li $t6, 3                
    addiu $a0, $a0, 1        
copyTestNameFromTo:
    lb $t5, 0($a0)
    sb $t5, 0($t3)
    addiu $t3, $t3, 1
    addiu $a0, $a0, 1
    subiu $t6, $t6, 1
    bnez $t6, copyTestNameFromTo


    li $t5, 0
    sb $t5, 0($t3)

    addiu $a0, $a0, 1
    la $t3, date             
    li $t6, 7               
copyDateFromTo:
    lb $t5, 0($a0)
    sb $t5, 0($t3)
    addiu $t3, $t3, 1
    addiu $a0, $a0, 1
    subiu $t6, $t6, 1
    bnez $t6, copyDateFromTo

    addiu $a0, $a0, 1
    li $t5, 0
    sb $t5, 0($t3)
    la $t3, resultOfTest   
copyResultFromTo:
    lb $t5, 0($a0)
    beq $t5, 10, doneCopyResultFromTo
    sb $t5, 0($t3)
    addiu $t3, $t3, 1
    addiu $a0, $a0, 1
    j copyResultFromTo

doneCopyResultFromTo: 

   la $t1,date   
   la $t2,initialPeriod
compareDateless:
   lb $t3,0($t1)
   lb $t4,0($t2)
    addiu $t1,$t1,1
   addiu $t2,$t2,1
   beqz $t3,doneCompareDateless
   blt $t3,$t4,searchFromToLoop
   bgt $t3,$t4,doneCompareDateless
   j compareDateless  
   
doneCompareDateless:
   la $t1,date   
   la $t2,toPeriod
  
compareDateMore:
   lb $t3,0($t1)
   lb $t4,0($t2)
   beqz $t3,doneCompareDateMore
   bgt $t3,$t4,searchFromToLoop
   blt $t3,$t4,doneCompareDateMore
   addiu $t1,$t1,1
   addiu $t2,$t2,1    
   j compareDateMore 
    
doneCompareDateMore:
    move $t7,$a0
   addiu $t7,$t7,1
   li $v0,4
   la $a0,patientId
   syscall 
   li $v0,11
   li $a0,58
   syscall 
    li $v0,4
   la $a0,nameTest
   syscall 
    li $v0,11
   li $a0,44
   syscall 
   
   li $v0,4
   la $a0,date
   syscall 
   
   li $v0,11
   li $a0,44
   syscall 
    li $v0,4
   la $a0,resultOfTest
   syscall 
   
   li $v0,4
   la $a0,newline
   syscall 

   move $a0,$t7
   la $a1, patientId       
   li $a2, 7 
   
    j searchFromToLoop

   
   
                
endOfFileContentFromTo:           
    j menuloop
    
    
searchUnnormalTests:
     li $v0,4
     la $a0,newline
     syscall
     li $v0,4
     la $a0,askForMTName
     syscall
     li $v0,8
     la $a0,nameTest
     li $a1,4
     syscall 
    li $v0,4
   la $a0,newline
   syscall 
     la $a0,fileContent
     la $a1,nameTest
     li $a2,3
     move $a3,$a0
     addiu $a0,$a0,8
searchForName:
    lb $t2, 0($a0)       
    lb $t3, 0($a1)        


    beqz $t2, endOfFileContentName
    addiu $a0, $a0, 1
    addiu $a1, $a1, 1
    bne $t2, $t3, notEqNameT
    subiu $a2, $a2, 1


    beqz $a2, nameFounded

    j searchForName
  
notEqNameT:
   la $a1, nameTest      
    li $a2, 3            
    j nextRecordName

nextRecordName:
    lb $t2, 0($a0)          
    addiu $a0, $a0, 1      
    beqz $t2, endOfFileContentName
    beq $t2, 10, jumpToName
    j nextRecordName
    
jumpToName:    
       move $a3,$a0
     addiu $a0,$a0,8
     j  searchForName 
nameFounded: 
     
     la $t3, patientId         
     li $t6,7                
copyIdName:
    lb $t5, 0($a3)
    sb $t5, 0($t3)
    addiu $t3, $t3, 1
    addiu $a3, $a3, 1
    subiu $t6, $t6, 1
    bnez $t6, copyIdName


    li $t5, 0
    sb $t5, 0($t3)

    addiu $a3, $a3, 5
    la $t3, date             
    li $t6, 7  
     
                 
copyDateName:
    lb $t5, 0($a3)
    sb $t5, 0($t3)
    addiu $t3, $t3, 1
    addiu $a3, $a3, 1
    subiu $t6, $t6, 1
    bnez $t6, copyDateName

    addiu $a3, $a3, 1
    li $t5, 0
    sb $t5, 0($t3)   
   
   
    la $t3, resultOfTest   
copyResultName:
    lb $t5, 0($a3)
    beq $t5, 10, doneCopyResultName
    sb $t5, 0($t3)
    addiu $t3, $t3, 1
    addiu $a3, $a3, 1
    j copyResultName  

doneCopyResultName:  

 
   la $t5, medicalTest
   la $t4, nameTest
   li $t3,3
   li $t7,0
findTheTestName: 
    lb $t1,0($t5)
    lb $t0,0($t4)
    beqz $t1,endOfArrayName
    addiu $t4,$t4,1
    addiu $t5,$t5,1
    bne $t0,$t1,notEqTestName  
    subiu $t3,$t3,1
    beqz $t3,foundedTestName
    j findTheTestName   
    
notEqTestName:
   
nextStringNameLoop:
    lb $t1, 0($t5)       
    beqz $t1, endOfArrayName 
    beq $t1,',',foundNextStringName 
    addiu $t5, $t5, 1    
    j nextStringNameLoop     

foundNextStringName:
    addiu $t5, $t5, 1    
    la $t4, nameTest
    li $t3, 3            
    j findTheTest        

foundedTestName:
  addiu $t7,$t7,1
  j endOfArrayName

endOfArrayName:  
    beq $t7,1,startCopyResult
    j menuloop
    
startCopyResult:  
  addiu $t5, $t5, 1       
    la $t3, minRange        
    la $t6, maxRange       
copyMinRangeLoop:
    lb $t2, 0($t5)     
    beq $t2, '-', foundDashName
    sb $t2,0($t3)
    addiu $t5, $t5, 1       
    addiu $t3, $t3, 1       
    j copyMinRangeLoop           
   
foundDashName:
    addiu $t3, $t3, 1       
    li $t2,0
    sb $t2,0($t3)
    addiu $t5, $t5, 1       
copyMaxRangeLoop:
    lb $t2, 0($t5)     
    beq $t2, ',', doneCopyMaxRange
    sb $t2,0($t6)
    addiu $t5, $t5, 1       
    addiu $t6, $t6, 1       
    j copyMaxRangeLoop           
           
doneCopyMaxRange: 
    la $t2 , resultOfTest
    li $t3,0
strlenResultName:
   lb $t4,0($t2)
 
   beqz $t4, doneStrlenResultName
   beq $t4,'.' ,addTestName
   blt $t4,'0',doneStrlenResultName
   bgt $t4,'9',doneStrlenResultName
   addTestName:
   addiu $t2,$t2,1
   addiu $t3,$t3,1

   j strlenResultName
doneStrlenResultName:
    la $t1 , minRange
    li $t4,0
strlenMinRange:
   lb $t5,0($t1)
   beqz $t5, doneStrlenMinRange
   addiu $t1,$t1,1
   addiu $t4,$t4,1
   j strlenMinRange
doneStrlenMinRange:
    
    move $t8,$t3
    beq $t3,$t4,startCopmaringResult
    blt $t3,$t4,printRecoredName
    bgt $t3,$t4,checkMaxRangeName
    

startCopmaringResult:  
   
    la $t0,resultOfTest
   la $t1,minRange 
    
loopToCompareMinRange:
   lb $t2,0($t0)
   lb $t3,0($t1)
   addiu $t0,$t0,1
   addiu $t1,$t1,1
   blt $t2,$t3,printRecoredName
   bgt $t2,$t3,checkMaxRangeName
   j loopToCompareMinRange
   

   
      

checkMaxRangeName:  
   la $t1,maxRange
   li $t4,0
strlenMaxRange:
   lb $t5,0($t1)
   beqz $t5, doneStrlenMaxRange
   addiu $t1,$t1,1
   addiu $t4,$t4,1
   j strlenMaxRange
doneStrlenMaxRange: 

   
    beq $t8,$t4,startCopmaringMaxRange
    bgt $t8,$t4,printRecoredName
    blt $t8,$t4,searchForName
     
    
startCopmaringMaxRange:

   la $t0,resultOfTest
   la $t1,maxRange 
    
loopToCompareMaxRange:
   lb $t2,0($t0)
   lb $t3,0($t1)
   addiu $t0,$t0,1
   addiu $t1,$t1,1
   bgt $t2,$t3,printRecoredName
   blt $t2,$t3,searchForName
   j loopToCompareMaxRange
   
   
        
                 
 printRecoredName:
   
   move $t7,$a0
   addiu $t7,$t7,1
   li $v0,4
   la $a0,patientId
   syscall 
   li $v0,11
   li $a0,58
   syscall 
    li $v0,4
   la $a0,nameTest
   syscall 
    li $v0,11
   li $a0,44
   syscall 
   
   li $v0,4
   la $a0,date
   syscall 
   
   li $v0,11
   li $a0,44
   syscall 
    li $v0,4
   la $a0,resultOfTest
   syscall 
   
   li $v0,4
   la $a0,newline
   syscall 

   move $a0,$t7
   move $a3,$a0
   la $a1, nameTest       
   li $a2, 3 
   
  
    
    j  searchForName


endOfFileContentName:      
    j menuloop


averageTestValue:

    la $a1,medicalTtoVeri
    
loopToCheckTestNames:
    la $a0,fileContent
    move $t4,$a1
    addiu $a0,$a0,8
    li $a3,3
loopToCheckOneTest:
     lb $t0,0($a0)
     lb $t1,0($a1)
    beq $t1,'0',doneCheckNames
    beqz $t0,doneCheckOneTest
    
    addiu $a0,$a0,1
    addiu $a1,$a1,1
     
    bne $t0,$t1,notEqTestNameT
    subiu $a3,$a3,1
    beqz $a3, foundedNameT
    
    j loopToCheckOneTest                

foundedNameT:
       
       addiu $a0,$a0,9
       li $t6,0
   
copyIntValue:
    lb $t1,0($a0)

     addiu $a0,$a0,1
    beq $t1,46 doneCopyIntValue
    subiu $t1,$t1,48
    mul $t6,$t6,10
    addu $t6,$t6,$t1

 
    
    j copyIntValue
    
doneCopyIntValue:

 li $t5, 10
mtc1 $t5, $f3
cvt.s.w $f3, $f3 # Convert 10 to float

li $t8, 0
mtc1 $t8, $f2
cvt.s.w $f2, $f2 # Initialize $f2 to 0.0

copyFloatValue:
    lb $t1, 0($a0)
    addiu $a0, $a0, 1
    beq $t1, 13, doneCopyFloatValue
    subiu $t1, $t1, 48
    mtc1 $t1, $f1
    cvt.s.w $f1, $f1 # Convert the digit to float
    div.s $f1, $f1, $f3 # Divide the digit by 10
    add.s $f2, $f2, $f1 # Add the digit to $f2
    div.s $f3, $f3, $f0 # Multiply the divisor by 10
    j copyFloatValue

doneCopyFloatValue:
         
      mtc1 $t6,$f1
      cvt.s.w $f1,$f1
      
      add.s $f3,$f1,$f2
      
     lwc1 $f4,floatValue
     add.s $f4,$f4,$f3
     swc1 $f4 ,floatValue
     li $t1,1
      mtc1 $t1,$f1
      cvt.s.w $f1,$f1
      
     lwc1 $f4,intValue
     add.s $f4,$f4,$f1
     swc1 $f4 ,intValue
     

      move $a3,$a0
     addiu $a0,$a0,9
      move $a1,$t4
      li $a3,3
     
  j loopToCheckOneTest

    
    



notEqTestNameT:

  move $a1,$t4
  li $a3,3
  
  
nextRecordNameT:
    lb $t2, 0($a0)          
    addiu $a0, $a0, 1      
    beqz $t2, doneCheckNames
    beq $t2, 10, jumpToNameT
    j nextRecordNameT
     
jumpToNameT:    
      move $a3,$a0
     addiu $a0,$a0,8
      move $a1,$t4
      li $a3,3
     
  j loopToCheckOneTest

    
doneCheckOneTest: 
    move $t7,$a0
    li $v0,4
    la $a0,newline
    syscall 
    li $v0,4
    move $a0,$a1
    syscall 
    li $v0,11
    li $a0,':'
    syscall
    move $a0,$t7
    lwc1 $f0,floatValue
    lwc1 $f1,intValue
    div.s $f3,$f0,$f1
    move $t7,$a0
    li $v0,2
    mov.s $f12,$f3
    syscall
     li $v0,4
     la $a0,newline
     syscall 
     li $t1,0
     mtc1 $t1,$f1
     cvt.s.w $f1,$f1
     swc1 $f1,floatValue
     swc1 $f1,intValue
     move $a1,$t4
      addiu $a1,$a1,4
       li $a3,3 
       
   j loopToCheckTestNames
   
    

doneCheckNames:
  li $v0,4
    la $a0,newline
    syscall
    j menuloop

updateTestResult:
     li $v0,4
    la $a0,newline
    syscall 
  
    li $v0,4
    la $a0,askForId
    syscall 
    
    li $v0,8
    la $a0,patientId
    li $a1,8
    syscall 
    li $v0,4
    la $a0,newline
    syscall
    li $v0,4
    la $a0,askForMTName
    syscall
    li $v0,8
    la $a0,nameTest
    li $a1,4
    syscall 
   
     la $a0, fileContent 

    la $a1, patientId       
    li $a2, 7             
    li $a3, 0              

searchIdLoop:

    lb $t2, 0($a0)       
    lb $t3, 0($a1)        


    beqz $t2, endOfFileContentR
    addiu $a0, $a0, 1
    addiu $a1, $a1, 1
    bne $t2, $t3, notEqIdR
    subiu $a2, $a2, 1


    beqz $a2, idFoundedR

    j searchIdLoop

notEqIdR:
    la $a1, patientId  

    li $a2, 7             
    j nextRecordR

nextRecordR:
    lb $t2, 0($a0)          
    addiu $a0, $a0, 1      
    beqz $t2, endOfFileContentR
    beq $t2, 10, searchIdLoop
    j nextRecordR

idFoundedR:

     la $a1, nameTest       
    li $a2, 3          
    li $a3, 0              
           
    addiu $a0, $a0, 1      
searchNameLoop:
    lb $t2, 0($a0)       
    lb $t3, 0($a1)        


    beqz $t2, endOfFileContentR
    addiu $a0, $a0, 1
    addiu $a1, $a1, 1
    bne $t2, $t3, notEqIdR
    subiu $a2, $a2, 1


    beqz $a2, nameIdFounded
   
    j searchNameLoop
   
nameIdFounded:
  
askForResultR:
    move $t7,$a0
       li $v0,4
       la $a0,newline
       syscall
   li $v0,4
       la $a0,askToEnterResult
       syscall
      
       li $v0,8
       la $a0,resultOfTest
       li $a1,8
       syscall 
     move $a0,$t7
     
    la $t0, resultOfTest
    move $t5,$t0
  
    addiu $t5,$t5,1  
    li $t1,0

loopToVerifyResultR:
     lb $t2, 0($t0)        
    beq $t2,10,doneLenR
    addiu $t0, $t0, 1     
    
    beq $t2,46,checkDotR
    blt $t2,48,askForResultAgainR
    bgt $t2,57,askForResultAgainR
    
    j loopToVerifyResultR
    
 
checkDotR:
  
   beq $t0,$t5,askForResultAgainR
   addiu $t1,$t1,1
   bgt $t1,1,askForResultAgainR
   
   j loopToVerifyResultR
    
askForResultAgainR:
       li $v0,4
       la $a0,askForResultAgainF
       syscall 
        
        li $v0, 4
        la $a0, newline
        syscall
        
         j  askForResultR
doneLenR:  
     addiu $a0,$a0,9
     move $t7,$a0
     la $a1,resultOfTest
copyNewReult:
     lb $t4,0($a1)
     beqz $t4,doneCopyNewResult
     sb $t4,0($a0)
     addiu $a0,$a0,1 
     addiu $a1,$a1,1
     j copyNewReult         
         
doneCopyNewResult:
      li $v0,4
   la $a0,fileContent
   syscall 
   
    li $v0,4
   la $a0,updated
   syscall 
endOfFileContentR:

    j menuloop

deleteTest:
     li $v0,4
    la $a0,newline
    syscall 
  
    li $v0,4
    la $a0,askForId
    syscall 
    
    li $v0,8
    la $a0,patientId
    li $a1,8
    syscall 
    li $v0,4
    la $a0,newline
    syscall
    li $v0,4
    la $a0,askForMTName
    syscall
    li $v0,8
    la $a0,nameTest
    li $a1,4
    syscall 
   
     la $a0, fileContent 
     move $t9,$a0
    la $a1, patientId       
    li $a2, 7             
    li $a3, 0              

searchIdLoopD:
    
    lb $t2, 0($a0)       
    lb $t3, 0($a1)        


    beqz $t2, endOfFileContentD
    addiu $a0, $a0, 1
    addiu $a1, $a1, 1
    bne $t2, $t3, notEqIdD
    subiu $a2, $a2, 1


    beqz $a2, idFoundedD

    j searchIdLoopD

notEqIdD:
    la $a1, patientId  

    li $a2, 7             
    j nextRecordD

nextRecordD:
    lb $t2, 0($a0)          
    addiu $a0, $a0, 1      
    beqz $t2, endOfFileContentD
    beq $t2, 10, saveAdd
    j nextRecordD
saveAdd:
  move $t9,$a0
  j searchIdLoopD
idFoundedD:

     la $a1, nameTest       
    li $a2, 3          
    li $a3, 0              
           
    addiu $a0, $a0, 1      
searchNameLoopD:
    lb $t2, 0($a0)       
    lb $t3, 0($a1)        


    beqz $t2, endOfFileContentD
    addiu $a0, $a0, 1
    addiu $a1, $a1, 1
    bne $t2, $t3, notEqIdD
    subiu $a2, $a2, 1


    beqz $a2, nameIdFoundedD
   
    j searchNameLoopD
   
nameIdFoundedD:
  move $a0,$t9
  li $t2,' '
deleteTheTest:
   lb $t1,0($a0)
   beq $t1,10,doneDelete
   sb $t2,0($a0)
   addiu $a0,$a0,1
   j deleteTheTest
     

doneDelete: 
   li $v0,4
   la $a0,newline
   syscall         
   li $v0,4
   la $a0,fileContent
   syscall 
   
    li $v0,4
   la $a0,updated
   syscall 
     
 endOfFileContentD:
    j menuloop
    

exitProgram:
    li $v0, 10          # syscall code for exit
    syscall             # exit program

readFile:

          # Open a file
         li $v0, 13          # system call for open file
         la $a0, filename    # load file name address
         li $a1, 0           # Open for reading
         li $a2, 0
         syscall             # open a file (file descriptor returned in $v0)
         move $s6, $v0       # pass file descriptor to readFile
  
        # Read from file
        li $v0, 14          # system call for read from file
        move $a0, $s6       # file descriptor
        la $a1, fileContent      # address of buffer to which to read
        li $a2, 1024        # hardcoded buffer length
        syscall             # read from file

        # Print buffer
        li $v0, 4           # syscall code for print string
        la $a0, fileContent      # load buffer address
        syscall             # print buffer

        # Close file
        li $v0, 16          # syscall code for close file
        move $a0, $s6       # file descriptor
        syscall             # close file
    

   
    doneRead:
        jr $ra              # return from function
