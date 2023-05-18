public with sharing class InfoJobsConnector implements IRecruitmentConnector {
    private static IRecruitmentConnector infoJobsConnectorInstance;

    public class InfoJobsConnectorException extends Exception {}

    private static final String BASIC_ENDPOINT = 'https://api.infojobs.net/api/';
    private static final String OFFER_BY_ID_ENDPOINT = '7/offer/{0}';

    public static IRecruitmentConnector getInstance() {
        if (infoJobsConnectorInstance == null) {
            infoJobsConnectorInstance = new InfoJobsConnector();
        }
        return infoJobsConnectorInstance;
    }

    public RecruitmentDTO.Offer getOffer(String offerId) {
        HttpRequest httpRequest = getHttpRequest();
        httpRequest.setEndpoint(BASIC_ENDPOINT + String.format(OFFER_BY_ID_ENDPOINT, new List<String>{offerId}));
        httpRequest.setMethod('GET');
        Http http = new Http();
        HTTPResponse httpResponse = http.send(httpRequest);
        validateHttpResponse(httpResponse);
        return transformOfferResponse(httpResponse.getBody());
    }

    private HttpRequest getHttpRequest() {
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setHeader('Content-Type', 'application/json');
        httpRequest.setHeader('Authorization', getToken());
        return httpRequest;
    }

    private String getToken() {
        return Token__mdt.getInstance('InfoJobs').Token__c;
    }

    private void validateHttpResponse(HTTPResponse httpResponse) {
        if (httpResponse.getStatusCode() != 200) {
            throw new InfoJobsConnectorException('InfoJobs callout failed with code: ' + httpResponse.getStatusCode() + ', message: ' + httpResponse.getBody());
        }
    }

    private RecruitmentDTO.Offer transformOfferResponse(String bodyString) {
        Map<String, Object> bodyMap = (Map<String, Object>) JSON.deserializeUntyped(bodyString);
        RecruitmentDTO.Offer offer = new RecruitmentDTO.Offer();
        offer.id = (String) bodyMap.get('id');
        offer.title = (String) bodyMap.get('title');
        offer.city = (String) bodyMap.get('city');
        offer.description = (String) bodyMap.get('description');
        offer.applications = (Integer) bodyMap.get('applications');
        return offer;
    }

}