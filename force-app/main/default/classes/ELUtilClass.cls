/*******************************************************************************
Description: This class contains general utility functions 
Developer: Khalid Fazlullah

@TO_PROPER_CASE
turns all words in a text string to proper case except those that should be kept lower case
first and last words are always capitalized
*******************************************************************************/

public class ELUtilClass{
    public static String toProperCase(String str){
       if(str.trim().length() == 0) return str;
       String[] words = str.toLowerCase().normalizeSpace().split(' ');
       String rslt = words[0].capitalize(); //always capitalize the first word
       for(integer i=1; i<words.size()-1; i++){
          rslt += ' ' + words[i].capitalize();
       }
       rslt += ' ' + words[words.size()-1].capitalize(); //always capitalize the last word
       return rslt;
    }
}