global class accountsUpdatebatchable implements Database.Batchable<sObject>,Database.RaisesPlatformEvents
{
 global final string query;
    global accountsUpdatebatchable(string q)
    {
        query=q;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC,List<sObject> scope)
    {
        list<account> accList = new list<account> ();
        for(sObject obj:scope)
        {
            
           
            Account a = (Account)obj;
            a.NumberOfEmployees =10;
            accList.add(a);
        
        }
        system.debug('size--'+accList.size());
        update accList;
   
        
    }
    global void finish(Database.BatchableContext BC)
    {
        
    }
    /*
    this is how to call the class from the  dev console
    id batchinstanceid = database.executeBatch(new accountsUpdatebatchable('select Id from Account'),10);
    */
   
}