public with sharing class QuoteStatusAction {
    /**
 * @description Input wrapper — Agentforce passes one input per invocation
 */
    public class  QuoteRequest {
        @InvocableVariable(
            label='Quote Number'
            description='The CPQ Quote number to look up (e.g. Q-00001)'
            required=true
        )
        public String quoteNumber;
    }
    /**
     * @description Output wrapper — returned back to the Agentforce agent
     */
    public class QuoteResult {
        @InvocableVariable(label='Quote Status')
        public String status;

        @InvocableVariable(label='Quote Total Amount')
        public Decimal totalAmount;

        @InvocableVariable(label='Expiration Date')
        public String expirationDate;

        @InvocableVariable(label='Account Name')
        public String accountName;

        @InvocableVariable(label='Error Message')
        public String errorMessage;
    }
        @InvocableMethod(
        label='Get Quote Status'
        description='Retrieves CPQ Quote status, total amount, and expiration date by quote number'
        category='CPQ'
    )
    public static List<QuoteResult> getQuoteStatus(List<QuoteRequest> requests) {

        List<QuoteResult> results = new List<QuoteResult>();
        Set<String> quoteNumbers = new Set<String>();
        for (QuoteRequest req : requests) {
            quoteNumbers.add(req.quoteNumber);
            }
            //QuoteResult result = new QuoteResult();
            Map<String, Quote> quotesByName = new Map<String, Quote>();
            try {
                for(Quote q : [Select Id, Name, Status, TotalPrice, ExpirationDate, Account.Name from Quote WHERE Name IN :quoteNumbers
                    WITH USER_MODE])
                    {
                        quotesByName.put(q.Name,q);
                    }
                }
                    catch (Exception e) {
        // If SOQL fails entirely, return error for all requests
                for (QuoteRequest req : requests) {
                    QuoteResult r = new QuoteResult();
                    r.errorMessage = 'Database error: ' + e.getMessage();
                    results.add(r);
                }
                return results;
            }
                    // Step 3: Loop requests and match from the Map — NO SOQL here
                for (QuoteRequest req : requests) {
                    QuoteResult result = new QuoteResult();

                    if (!quotesByName.containsKey(req.quoteNumber)) {
                        result.errorMessage = 'No quote found with number: ' + req.quoteNumber;
                    } else {
                        Quote q = quotesByName.get(req.quoteNumber);
                        result.status         = q.Status;
                        result.totalAmount    = q.TotalPrice;
                        result.expirationDate = q.ExpirationDate != null
                            ? q.ExpirationDate.format()
                            : 'No expiration date set';
                        result.accountName    = q.Account?.Name;
                    }
                    results.add(result);
                }
                return results;
        }
}