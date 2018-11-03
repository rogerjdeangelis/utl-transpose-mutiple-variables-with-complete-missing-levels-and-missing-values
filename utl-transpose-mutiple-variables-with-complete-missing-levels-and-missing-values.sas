Transpose mutiple variables with complete missing levels and missing values                                            
                                                                                                                       
All techniques output a table not a static report                                                                      
                                                                                                                       
github                                                                                                                 
https://tinyurl.com/yav3d2fh                                                                                           
https://github.com/rogerjdeangelis/utl-transpose-mutiple-variables-with-complete-missing-levels-and-missing-values     
                                                                                                                       
see                                                                                                                    
https://tinyurl.com/y77332od                                                                                           
https://communities.sas.com/t5/SAS-Procedures/Proc-Report-two-across-variables/m-p/510063                              
                                                                                                                       
This is a complex transpose due to complete missing levels and                                                         
complete missing values within levels. There are at least four valid solutions?                                        
                                                                                                                       
Missing values are the vain of programming.                                                                            
                                                                                                                       
                                                                                                                       
see for a static report output                                                                                         
                                                                                                                       
  FOUR SOLUTIONS                                                                                                       
                                                                                                                       
      1. Proc transpose (without missing levels)                                                                       
                                                                                                                       
      2. proc report  (with missing levels -  and missings sums)                                                       
         Variation of Dav25                                                                                            
         https://communities.sas.com/t5/user/viewprofilepage/user-id/43753                                             
                                                                                                                       
      3. Transpose Macro ( all possible crossings)                                                                     
                                                                                                                       
      4. SQL Arrays ( all possible frossings)                                                                          
                                                                                                                       
                                                                                                                       
INPUT                                                                                                                  
=====                                                                                                                  
                                                                                                                       
WORK.HAVE total obs=5                                                                                                  
                                                                                                                       
 GRADE    TYPE1    COUNT1    TYPE2A    TYPE2B    COUNT2                                                                
                                                                                                                       
   1       A1         1                             .                                                                  
   1       B1         2                             .                                                                  
   1       C1         3                             .                                                                  
   1                  .        A2       A2a         4                                                                  
   1                  .        A2       A2b         5                                                                  
                                                                                                                       
                                                                                                                       
* make data;                                                                                                           
data have;                                                                                                             
  input grade type1 $ count1 type2a $ type2b $ count2;                                                                 
cards4;                                                                                                                
1 A1 1 . . .                                                                                                           
1 B1 2 . . .                                                                                                           
1 C1 3 . . .                                                                                                           
1 . . A2 A2a 4                                                                                                         
1 . . A2 A2b 5                                                                                                         
;;;;                                                                                                                   
run;quit;                                                                                                              
                                                                                                                       
                                                                                                                       
SOLUTIONS                                                                                                              
=========                                                                                                              
                                                                                                                       
 1. Proc transpose (without missing levels)                                                                            
                                                                                                                       
    data havAdd / view=havAdd;                                                                                         
      length rid $8;                                                                                                   
      set have;                                                                                                        
      rid=cats(type1,type2b);                                                                                          
      count=coalesce(count1,count2);                                                                                   
      drop type1 type2a type2b;                                                                                        
    run;quit;                                                                                                          
                                                                                                                       
    proc transpose data=havAdd out=want_proc(drop=_name_);                                                             
      by grade;                                                                                                        
      id rid;                                                                                                          
      var count;                                                                                                       
    run;quit;                                                                                                          
                                                                                                                       
   /*                                                                                                                  
    WORK.WANT total obs=1                                                                                              
                                                                                                                       
     GRADE   A1    B1    C1    A2A    A2B                                                                              
                                                                                                                       
   */                                                                                                                  
    1      1     2     3     4      5                                                                                  
                                                                                                                       
  2. Proc report With missing levels and sum of missing values.                                                        
                                                                                                                       
     proc report data=have missing out=wantRpt (rename=(                                                               
       _C2_ = MIS1                                                                                                     
       _C3_ = A1                                                                                                       
       _C4_ = B1                                                                                                       
       _C5_ = C1                                                                                                       
       _C6_ = MIS2                                                                                                     
       _C7_ = A2A                                                                                                      
       _C8_ = A2B                                                                                                      
     ));                                                                                                               
     columns ("Grade" grade)  (type1,(count1))  (type2b,(count2));                                                     
     define grade/' ' group;                                                                                           
     define type1/' ' nozero across;                                                                                   
     define type2b/' ' nozero across;                                                                                  
     define count1/' ' sum;                                                                                            
     define count2/' ' sum;                                                                                            
     run;quit;                                                                                                         
                                                                                                                       
                                                                                                                       
   2. Proc report With missing levels and sum of missing values.                                                       
                                                                                                                       
      GRADE    MIS1     A1      B1      C1     MIS2   A2A    A2B                                                       
                                                                                                                       
        1       .        1       2       3      .      4       5                                                       
                                                                                                                       
 3. Transpose Macro ( all crossings)                                                                                   
                                                                                                                       
     data havTrn / view=havTrn;                                                                                        
       length rid $8;                                                                                                  
       set have;                                                                                                       
       rid=cats(type1,type2b);                                                                                         
       drop type1 type2a type2b;                                                                                       
       rename count1=C1 count2=C2;                                                                                     
     run;quit;                                                                                                         
                                                                                                                       
     %utl_transpose(data=havTrn, out=wantMac, by=grade, id=rid, guessingrows=1000, var=c1 c2);                         
                                                                                                                       
    /*                                                                                                                 
     WORK.WANT total obs=1                                                                                             
                                                                                                                       
      GRADE    C1A1    C2A1    C1A2A    C2A2A    C1A2B    C2A2B    C1B1    C2B1    C1C1    C2C1                        
                                                                                                                       
        1        1       .       .        4        .        5        2       .       3       .                         
   */                                                                                                                  
                                                                                                                       
 4. SQL Arrays                                                                                                         
                                                                                                                       
    data havAdd / view=havAdd;                                                                                         
      length rid $8;                                                                                                   
      set have;                                                                                                        
      rid=cats(type1,type2b);                                                                                          
      count=coalesce(count1,count2);                                                                                   
      drop type1 type2a type2b;                                                                                        
    run;quit;                                                                                                          
                                                                                                                       
    %array(vs,data=havAdd,var=rid)                                                                                     
    proc sql;                                                                                                          
      create                                                                                                           
        table wantSQL as                                                                                               
      select                                                                                                           
        grade                                                                                                          
       ,%do_over(vs,phrase=sum((rid="?")*count1) as c1?,between=comma)                                                 
       ,%do_over(vs,phrase=sum((rid="?")*count2) as c2?,between=comma)                                                 
      from                                                                                                             
        havAdd                                                                                                         
      group                                                                                                            
        by grade                                                                                                       
    ;quit;                                                                                                             
                                                                                                                       
   /*                                                                                                                  
    Up to 40 obs WORK.WANTSQL total obs=1                                                                              
                                                                                                                       
    Obs    GRADE    C1A1    C1B1    C1C1    C1A2A    C1A2B    C2A1    C2B1    C2C1    C2A2A    C2A2B                   
                                                                                                                       
     1       1        1       2       3       0        0        0       0       0       4        5                     
   */                                                                                                                  
                                                                                                                       
                                                                                                                       
                                                                                                                       
                                                                                                                       
                                                                                                                       
