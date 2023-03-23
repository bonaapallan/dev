public  class accountcls
    {
        
          public String stringVal {get; set;} 
          //public list<wrapperAccount> wrapperAccountList;
          public list<wrapperAccount> wrapperAccountListTest;
          
          public list<wrapperAccount> wrapperAccountListTest()
          {
          	wrapperAccountListTest =new list<wrapperAccount> ();	  
			            	if(wrapperAccountList.size() > 0)
			            		
			            	{
				            	for(wrapperAccount wrapper:wrapperAccountList)
				            	{
				            		
				            			system.debug('_____________'+wrapper.selected+'________'+wrapper);
				            			if(wrapper.selected == true)
				            			{
				            			
				            			  stringVal =stringVal + wrapper.accObj.name;
				            			  wrapperAccountListTest.add(wrapper);
				            			}
				            	}
				            			system.debug('**********String val**************'+stringVal);			 
	           		 
	          	 
	          				}
	          				 return   wrapperAccountListTest;
          	
          }
          public  list<wrapperAccount> getwrapperAccountListTest(){
          	
          	
			            	wrapperAccountListTest =new list<wrapperAccount> ();	  
			            	if(wrapperAccountList.size() > 0)
			            		
			            	{
				            	for(wrapperAccount wrapper:wrapperAccountList)
				            	{
				            		
				            			system.debug('_____________'+wrapper.selected+'________'+wrapper);
				            			if(wrapper.selected == true)
				            			{
				            			
				            			  stringVal =stringVal + wrapper.accObj.name;
				            			  wrapperAccountListTest.add(wrapper);
				            			}
				            	}
				            			system.debug('**********String val**************'+stringVal);			 
	           		 
	          	 
	          				}
	          				 return   wrapperAccountListTest;
          	
          }
    
          public list<wrapperAccount> wrapperAccountList  {
          	
	          get{
	          
	          	
		          	    wrapperAccountList = new list<wrapperAccount> ();	           
			            for(account acc:[select name from account limit 5])
			            {		                
			               
			                wrapperAccountList.add(new wrapperAccount(acc));	                 
			                  
			            } 
			            return   wrapperAccountList;  	
	          	
	          }          	
	          set{        	
			            	
			            /*	if(wrapperAccountList.size() > 0)
			            		
			            	{
				            	for(wrapperAccount wrapper:wrapperAccountList)
				            	{
				            		
				            			if(wrapper.selected = true)
				            			{
				            			
				            			  stringVal =stringVal + wrapper.accObj.name;
				            			}
				            	}
				            			system.debug('**********String val**************'+stringVal);			 
	           		 
	          	 
	          				}*/
	             }
          }
        
        public class wrapperAccount
        {
            
             

            public Boolean selected {get; set;}  
            public account accObj {get;set;}
            

            public  wrapperAccount(account acc)
            {
              
               accObj = acc;
                selected = false;
            }
        }
    
        
      }