public with Sharing class ApexCodeCoverage{
    
    public list<codecoverageWrapper> codecoverageWrapperList = new list<codecoverageWrapper> ();
    public list<ApexCodeCoverageWrapper> ApexCodeCoverageWrapperList {get;set;}


public ApexCodeCoverage()
{
   ApexCodeCoverageWrapperlist = new list<ApexCodeCoverageWrapper> ();
    HttpRequest req = new HttpRequest();
    req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
    req.setHeader('Content-Type', 'application/json');
    //req.setEndpoint('https://berry--bqa1.cs9.my.salesforce.com/services/data/v29.0/tooling/query/?q=SELECT+ApexClassOrTriggerId,+ApexClassOrTrigger.Name,+NumLinesCovered,+NumLinesUncovered+FROM+ApexCodeCoverageAggregate+ORDER+BY+ApexClassOrTrigger.Name');
     req.setEndpoint('https://bona-dev-ed.my.salesforce.com/services/data/v29.0/tooling/query/?q=SELECT+ApexClassOrTriggerId,+ApexClassOrTrigger.Name,+NumLinesCovered,+NumLinesUncovered+FROM+ApexCodeCoverageAggregate++++WHERE+NumLinesUncovered+!=+NULL+ORDER+BY+ApexClassOrTrigger.Name');


    req.setMethod('GET');

    Http h = new Http();
    HttpResponse res = h.send(req);
    //system.debug(res.getBody()); 
    String fieldName;
    string ApexClassOrTriggerId;
    string ApexClassOrTriggerName;
    integer NumLinesCovered;
    integer NumLinesUncovered;    
    system.debug('----------test----------');
    JSONParser parser = JSON.createParser(res.getBody());    
    while (parser.nextToken() != null)
    {         
        if (parser.getCurrentToken() == JSONToken.FIELD_NAME)
        {
            system.debug('---testing 1--');
            fieldName = parser.getText();            
             parser.nextToken();
            IF(fieldName == 'ApexClassOrTriggerId')
            { 
                ApexClassOrTriggerId =parser.getText();
            
            }else if(fieldName == 'Name')
            {
                ApexClassOrTriggerName = parser.getText();
            }else if(fieldName == 'NumLinesCovered')
            {        
                NumLinesCovered =Integer.valueOf(parser.getText());               
               
            }else if(fieldName == 'NumLinesUncovered')
            {
                    system.debug('--adien-----'+parser.getText());
                 NumLinesUncovered =Integer.valueOf(parser.getText());
            }        
             if(ApexClassOrTriggerId !='' && ApexClassOrTriggerName != '' && NumLinesCovered != null &&  NumLinesUncovered !=null)
            {
                system.debug('--ifloop --'+ApexClassOrTriggerId+'----------'+ApexClassOrTriggerName+'------'+NumLinesCovered+'------'+NumLinesUncovered);               
                codecoverageWrapperList.add(new codecoverageWrapper(ApexClassOrTriggerId,ApexClassOrTriggerName,NumLinesCovered,NumLinesUncovered));
                ApexClassOrTriggerId = '';
                ApexClassOrTriggerName ='';           
                NumLinesCovered=null;
                NumLinesUncovered =null;
                system.debug('-----------testing 3-----------');
            }
        }      
    }
    system.debug('-------code wrapper list -------'+codecoverageWrapperList);
    //for userid ->names
    Map <ID,string> userName = new Map<ID,String>();
    List<user> userList = [select Id,name from user];
    for(user userObj:userList)
    {
        userName.put(userObj.Id,userObj.name);      
    }
        system.debug('-------testing 5st--');

    
    //fOR APEX Trigger
    Map <ID,Map<ID,ID>> apexTriggerMap = new Map <ID,Map<ID,ID>>();
    Map<ID,ID> TriggerAttributes;
    LIST<ApexTrigger> APEXTriggerList =[Select Id,NAME,CreatedById,LastModifiedById From ApexTrigger WHERE NamespacePrefix =''];
    for(ApexTrigger apexTriggerobj:APEXTriggerList)
    {
        TriggerAttributes = new Map <ID,ID>();
        TriggerAttributes.put(apexTriggerobj.CreatedById,apexTriggerobj.LastModifiedById);
        apexTriggerMap.put(apexTriggerobj.id,TriggerAttributes);
        
    }
    
   system.debug('-----------testing--6');
 //fOR APEX Class
    Map <ID,Map<ID,ID>> apexClassMap = new Map <ID,Map<ID,ID>>();
    Map<ID,ID> classAttributes;
    LIST<ApexClass> APEXClassList =[Select Id,NAME,CreatedById,LastModifiedById From ApexClass WHERE NamespacePrefix =''];
    for(ApexClass apexClassObj:APEXClassList)
    {
        classAttributes = new Map <ID,ID>();
        classAttributes.put(apexClassObj.CreatedById,apexClassObj.LastModifiedById);
        apexClassMap.put(apexClassObj.id,classAttributes);
        
    }
    
    
    map<ID,Id> userIds = new map <ID,ID> ();
    string createbyUserName;
    string lastmodifiedByUserName;
    for(codecoverageWrapper wrapper:codecoverageWrapperList)
    {   
        system.debug('NAME--wrapper test-----'+wrapper);
        system.debug('ID'+wrapper.classId); 
        system.debug('className  '+wrapper.className+'--------'+wrapper.classId);
        if(apexClassMap.containsKey(wrapper.classId))
        {
            userIds = apexClassMap.get(wrapper.classId);        
        }else
        {        
            userIds = apexTriggerMap.get(wrapper.classId);        
        }
        system.debug('-----------userId-------'+userIds);
        if(userIds.size() > 0){
            for(string userId:userIds.keyset())
            {
                
                createbyUserName = userName.get(userId);
                lastmodifiedByUserName = userName.get(userIds.get(userId));
                
            }
            system.debug('createbyUserName--'+createbyUserName);
            system.debug('lastmodifiedByUserName--'+lastmodifiedByUserName);
        }
        
        system.debug('----wrapper class name-------'+wrapper.className+'--'+wrapper.NumLinescovered+'--'+wrapper.NumLinesUncovered);
        ApexCodeCoverageWrapperlist.add(new ApexCodeCoverageWrapper(wrapper.classId,wrapper.className,createbyUserName,lastmodifiedByUserName,wrapper.NumLinescovered,wrapper.NumLinesUncovered));
        
    }
    system.debug(ApexCodeCoverageWrapperlist.size());

}
 public class codecoverageWrapper
    {
        public string classId {get;set;}
        public string className {get;set;}
        public integer NumLinescovered{get;set;}
        public integer NumLinesUncovered{get;set;}
        public integer totalLines {get;set;}
       
        public codecoverageWrapper(string ApexID,string ApexName,Integer Linescovered,Integer LinesUncovered)
        {
            classId = ApexID;
           className = ApexName;
            NumLinescovered =Linescovered;
            NumLinesUncovered = LinesUncovered;
            system.debug('------------lines covered--'+NumLinescovered+'--'+NumLinesUncovered);
            totalLines = Linescovered+LinesUncovered;
        }
    
    } 
    
    public class ApexCodeCoverageWrapper
    {
        
        public string ApexId {get;set;}
        public string ApexClassName {get;set;}
        public decimal ApexNumLinescovered{get;set;}
        public decimal ApexNumLinesUncovered{get;set;}
        public decimal ApextotalLines {get;set;}
        public string createdbyName{get;set;}
        public string lastmodifiedbyname{get;set;}
        public decimal Apexcodecoverage{get;set;}
        
        //new ApexCodeCoverageWrapper(wrapper.className,wrapper.classId,createbyUserName,lastmodifiedByUserName,wrapper.totalLines);
        public ApexCodeCoverageWrapper(string ApexID,string ApexName,string createdbyId,string LastmodifiedbyId,Integer Linescovered,Integer LinesUncovered)
        {
            try{
            ApexId = ApexID;
            ApexClassName = ApexName;
            ApexNumLinescovered = decimal.valueOF(Linescovered);
            ApexNumLinesUncovered = decimal.valueOf(LinesUncovered);
            ApextotalLines = Linescovered+LinesUncovered;
           //Apexcodecoverage = ApexNumLinescovered/ApextotalLines;
            Apexcodecoverage = (ApexNumLinescovered.divide(ApextotalLines,2))*100;

           
            createdbyName =createdbyId;
            lastmodifiedbyname=LastmodifiedbyId;
            system.debug('-------apex name---------'+Apexcodecoverage+'--'+ApextotalLines+'--'+ApexNumLinescovered+'--'+ApexNumLinesUncovered );
            }
            catch (exception ex)
            {
                system.debug(ex.getCause());
            }
        
        }
        
        
    }
    


}