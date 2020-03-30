Feature: GetConfig
  I need to be able to get the configuration via REST API

  Scenario:
    Given I call the REST API with Method "GET", Locale "de-DE" and URI "/v1/config"
    Then I should see a json response:
      """
      {
          "code": 1,
          "message": "SUCCESS",
          "config": {
              "data": {
                  "MAX_ARTICLE_COUNT_ANONYMOUS": 40,
                  "MAX_ARTICLE_COUNT_MEMBER": 80,
                  "MIN_ARTICLE_STOCK_FOR_STAMP": 20,
                  "DEFAULT_CAMPAIGN": "DE_ES_HE_HP_63_00042",
                  "CURRENCY_SYMBOL": "\u20ac",
                  "TOGGLE_PSO_GUI_ENABLED": true,
                  "LOGIN_URL": "/myaccount/login",
                  "REGISTRATION_URL": "/myaccount-service/myregistration"
              }
          }
      }
      """