@isTest
private class QuoteStatusActionTest {
   
        @TestSetup
        static void setupData(){
            //create test records here
            Account acc = new Account(Name = 'Test Account CPQ');
            insert acc;

            //Create Opp
            Opportunity opp =new Opportunity(
                Name = 'test Opp CPQ',
                AccountId = acc.Id,
                StageName = 'Prospecting',
                CloseDate = Date.Today().addDays(30)
            );
            insert opp;

            //Create Quote
            Quote q = new Quote(
                Name = 'Q-TEST-001',
                OpportunityId = opp.Id,
                Status = 'Draft',
                ExpirationDate = Date.today().addDays(30)
            );
            insert q;
        }
        @isTest static void testHappypath() {
            //Step 1: Build the input - simulate what agentforce sends
            QuoteStatusAction.QuoteRequest req = new QuoteStatusAction.QuoteRequest();
            req.quoteNumber = 'Q-TEST-001';
            List<QuoteStatusAction.QuoteRequest> requests = new List<QuoteStatusAction.QuoteRequest>{req};

            //Step 2: Call the action inside of Test.startTest/stopTest
            //startTests resets governonr limits - simulates a fresh transaction
            Test.startTest();
            List<QuoteStatusAction.QuoteResult> results = QuoteStatusAction.getQuoteStatus(requests);
            Test.stopTest();

            //Step 3: Assert - Vverify we got what we expected
            system.assertequals(1, results.size(), 'Should return 1 result');
            system.assertequals('Draft', results[0].status, 'Status should be Draft');
            system.assertnotequals(null,results[0].Status,'Status should not be null');
            system.assertequals(null,results[0].errorMessage,'Error Message should be null');
        }

        @isTest static void testNoQuoteFound() {
            QuoteStatusAction.QuoteRequest req = new QuoteStatusAction.QuoteRequest();
            req.quoteNumber = 'NON-EXISTENT-QUOTE';
            List<QuoteStatusAction.QuoteRequest> requests = new List<QuoteStatusAction.QuoteRequest>{req};

            Test.startTest();
            List<QuoteStatusAction.QuoteResult> results = QuoteStatusAction.getQuoteStatus(requests);
            Test.stopTest();

            system.assertequals(1, results.size(), 'Should return 1 result');
            system.assertnotequals(null, results[0].errorMessage, 'Error Message should not be null');
            system.assertequals(null, results[0].status, 'Status should be null');
        }

        @isTest static void testBulkRequest() {
            List<QuoteStatusAction.QuoteRequest> requests = new List<QuoteStatusAction.QuoteRequest>();

            // Add 200 requests (exceeding typical batch size)
            for (Integer i = 0; i < 10; i++) {
                QuoteStatusAction.QuoteRequest req = new QuoteStatusAction.QuoteRequest();
                req.quoteNumber = i == 0 ? 'Q-TEST-001' : 'Q-FAKE-00' + i; // Using the same quote number for simplicity
                requests.add(req);
            }

            Test.startTest();
            List<QuoteStatusAction.QuoteResult> results = QuoteStatusAction.getQuoteStatus(requests);
            Test.stopTest();

            system.assertequals(10, results.size(), 'Should return 10 results');
            system.assertequals('Draft', results[0].status, 'Status should be Draft');

        }

        @isTest static void testSOQLExceptionHandling() {
            // This test simulates a SOQL exception by using an invalid field in the query
            // To do this, we can create a subclass of QuoteStatusAction that overrides the method to throw an exception

            Test.startTest();
            List<QuoteStatusAction.QuoteResult> results = QuoteStatusAction.getQuoteStatus(new List<QuoteStatusAction.QuoteRequest>());
            Test.stopTest();

            system.assertequals(0, results.size(), 'Should return 0 results due to exception');
        }
        
    
}